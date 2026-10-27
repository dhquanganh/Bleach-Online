package Foundation.Network
{
   import Debugging.*;
   import Foundation.Network.Spaces.*;
   import Foundation.Timing.*;
   import Foundation.Utilities.*;
   import Logging.*;
   import Resources.Constants.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   use namespace NetworkSpace;
   
   public class TTransceiver
   {
      
      public static const CONNECTIONSTATE_Disconnected:int = CONST_NETWORK.CONNECTIONSTATE_Disconnected;
      
      public static const CONNECTIONSTATE_Connecting:int = CONST_NETWORK.CONNECTIONSTATE_Connecting;
      
      public static const CONNECTIONSTATE_Connected:int = CONST_NETWORK.CONNECTIONSTATE_Connected;
      
      public static const CONNECTIONSTATE_Failed:int = CONST_NETWORK.CONNECTIONSTATE_Failed;
      
      protected static const RECEIVINGSTATE_PacketLength:int = 0;
      
      protected static const RECEIVINGSTATE_Data:int = 1;
      
      protected static const RECEIVINGSTATE_PacketCipher:int = 2;
      
      protected static const RECEIVINGSTATE_PacketID:int = 3;
      
      protected static const SILENCEDETECTION_Ticks:int = 30000;
      
      protected static const SIZE_PacketLength:uint = CONST_GT_NETWORK.SIZE_PacketLength;
      
      protected static const SIZE_PacketID:uint = CONST_GT_NETWORK.SIZE_PacketID;
      
      protected static const SIZE_PacketHeader:uint = CONST_GT_NETWORK.SIZE_PacketHeader;
      
      protected var FPoolPacket:TPoolPacket;
      
      protected var FSocket:Socket;
      
      protected var FReceivedPackets:Vector.<TPacket>;
      
      protected var FReceivingState:int;
      
      protected var FReceivedDataLength:int;
      
      protected var FReceivedPacketID:uint;
      
      protected var FMaskingSeed:uint;
      
      protected var FMaskingOffset:uint;
      
      protected var FSilenceDetectionReferenceTick:int;
      
      protected var FSilenceDetectionCount:int;
      
      protected var FIsCipher:Boolean;
      
      private var FPacketCipher:TPacketCipher;
      
      private var FTransmitDataBuffer:ByteArray;
      
      private var FReceivedDataBuffer:ByteArray;
      
      protected var FServerHost:String;
      
      protected var FServerPort:int;
      
      protected var FConnectionState:int;
      
      protected var FSilenceDetection:Boolean;
      
      protected var FSilenceDetectionTicks:int;
      
      protected var FOnSilenceDetected:Function;
      
      public function TTransceiver(param1:TPoolPacket)
      {
         super();
         this.FPoolPacket = param1;
         this.FSocket = new Socket();
         this.FSocket.addEventListener(Event.CONNECT,this.SocketOnConnect);
         this.FSocket.addEventListener(Event.CLOSE,this.SocketOnClose);
         this.FSocket.addEventListener(IOErrorEvent.IO_ERROR,this.SocketOnIOError);
         this.FSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.SocketOnSecurityError);
         this.FReceivedPackets = new Vector.<TPacket>();
         this.FPacketCipher = new TPacketCipher();
         this.FPacketCipher.InitRandom();
         this.FTransmitDataBuffer = new ByteArray();
         this.FReceivedDataBuffer = new ByteArray();
         this.FTransmitDataBuffer.endian = Endian.LITTLE_ENDIAN;
         this.FConnectionState = CONNECTIONSTATE_Disconnected;
         this.FSilenceDetectionTicks = SILENCEDETECTION_Ticks;
      }
      
      private function ReceivingPerform() : void
      {
         var _loc1_:int = 0;
         do
         {
            _loc1_ = this.FReceivingState;
            switch(this.FReceivingState)
            {
               case RECEIVINGSTATE_PacketLength:
                  this.ReceivingPerform_PacketLength();
                  break;
               case RECEIVINGSTATE_Data:
                  this.ReceivingPerform_Data();
                  break;
               case RECEIVINGSTATE_PacketCipher:
                  this.ReceivingPerform_PacketCipher();
                  break;
               case RECEIVINGSTATE_PacketID:
                  this.ReceivingPerform_PacketID();
            }
         }
         while(this.FReceivingState != _loc1_);
      }
      
      protected function ReceivingPerform_PacketLength() : void
      {
         var _loc1_:int = 0;
         if(this.FSocket.bytesAvailable < SIZE_PacketLength)
         {
            return;
         }
         this.FReceivedDataLength = this.FSocket.readInt() - SIZE_PacketLength;
         if(this.FReceivedDataLength >= 0)
         {
            this.FReceivingState = RECEIVINGSTATE_Data;
            return;
         }
         throw new RangeError("Invalid Packet Length.");
      }
      
      protected function ReceivingPerform_Data() : void
      {
         if(this.FSocket.bytesAvailable >= this.FReceivedDataLength)
         {
            if(this.FReceivedDataLength != 0)
            {
               this.FSocket.readBytes(this.FReceivedDataBuffer,0,this.FReceivedDataLength);
            }
            this.FReceivingState = RECEIVINGSTATE_PacketCipher;
         }
      }
      
      private function ReceivingPerform_PacketCipher() : void
      {
         if(this.FIsCipher)
         {
            this.FPacketCipher.CrevasseNetBuffer(this.FReceivedDataBuffer,this.FReceivedDataBuffer.length);
         }
         this.FReceivingState = RECEIVINGSTATE_PacketID;
      }
      
      protected function ReceivingPerform_PacketID() : void
      {
         var _loc1_:TPacket = null;
         this.FReceivedDataBuffer.position = 0;
         this.FReceivedDataBuffer.endian = Endian.BIG_ENDIAN;
         this.FReceivedPacketID = this.FReceivedDataBuffer.readUnsignedInt();
         this.FReceivedDataBuffer.endian = Endian.LITTLE_ENDIAN;
         _loc1_ = this.FPoolPacket.Acquire(this.FReceivedPacketID);
         _loc1_.StubReferences.Reference(this);
         if(this.FReceivedDataLength != 0)
         {
            TUtilityMemory.CopyMemory(_loc1_.Data,this.FReceivedDataBuffer,this.FReceivedDataBuffer.length - SIZE_PacketID,0,SIZE_PacketID);
         }
         this.FReceivedPackets.push(_loc1_);
         this.FReceivingState = RECEIVINGSTATE_PacketLength;
         this.FReceivedDataBuffer.clear();
         ++SLogger.State.Received;
         SLogger.TraceTransceiver(TLogger.LEVEL_PacketReceive,_loc1_);
      }
      
      protected function SilenceDetectionReset(param1:int) : void
      {
         this.FSilenceDetectionReferenceTick = param1;
      }
      
      protected function SilenceDetectionPerform() : void
      {
         var _loc1_:int = 0;
         if(this.FConnectionState != CONNECTIONSTATE_Connected)
         {
            return;
         }
         if(!this.FSilenceDetection)
         {
            return;
         }
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FSilenceDetectionReferenceTick >= this.FSilenceDetectionTicks)
         {
            this.FSilenceDetectionReferenceTick = _loc1_;
            if(this.FOnSilenceDetected != null)
            {
               this.FOnSilenceDetected(this);
            }
         }
      }
      
      protected function SocketOnConnect(param1:Event) : void
      {
         var _loc2_:TPacket = null;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Socket Connected.");
         this.FReceivingState = RECEIVINGSTATE_PacketLength;
         this.FConnectionState = CONNECTIONSTATE_Connected;
         _loc2_ = this.FPoolPacket.Acquire(CONST_NETWORK.PACKETID_SocketConnect);
         _loc2_.StubReferences.Reference(this);
         this.FReceivedPackets.push(_loc2_);
         this.SilenceDetectionReset(STimingCore.TickCount);
      }
      
      protected function SocketOnClose(param1:Event) : void
      {
         var _loc2_:TPacket = null;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Socket Disconnected.");
         this.FConnectionState = CONNECTIONSTATE_Disconnected;
         _loc2_ = this.FPoolPacket.Acquire(CONST_NETWORK.PACKETID_SocketDisconnect);
         _loc2_.StubReferences.Reference(this);
         this.FReceivedPackets.push(_loc2_);
      }
      
      protected function SocketOnIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:TPacket = null;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Socket IO Error.");
         try
         {
            this.FSocket.close();
         }
         catch(E:Error)
         {
         }
         this.FConnectionState = CONNECTIONSTATE_Failed;
         _loc2_ = this.FPoolPacket.Acquire(CONST_NETWORK.PACKETID_SocketError);
         _loc2_.StubReferences.Reference(this);
         this.FReceivedPackets.push(_loc2_);
      }
      
      protected function SocketOnSecurityError(param1:SecurityErrorEvent) : void
      {
         var _loc2_:TPacket = null;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Socket Security Error." + param1.text);
         if(this.FConnectionState != CONNECTIONSTATE_Disconnected)
         {
            try
            {
               this.FSocket.close();
            }
            catch(E:Error)
            {
            }
            this.FConnectionState = CONNECTIONSTATE_Failed;
            _loc2_ = this.FPoolPacket.Acquire(CONST_NETWORK.PACKETID_SocketError);
            _loc2_.StubReferences.Reference(this);
            this.FReceivedPackets.push(_loc2_);
         }
      }
      
      public function get ServerHost() : String
      {
         return this.FServerHost;
      }
      
      public function set ServerHost(param1:String) : void
      {
         this.FServerHost = param1;
      }
      
      public function get ServerPort() : int
      {
         return this.FServerPort;
      }
      
      public function set ServerPort(param1:int) : void
      {
         this.FServerPort = param1;
      }
      
      public function get ConnectionState() : int
      {
         return this.FConnectionState;
      }
      
      public function get ReceivedPacketCount() : int
      {
         return this.FReceivedPackets.length;
      }
      
      public function get SilenceDetection() : Boolean
      {
         return this.FSilenceDetection;
      }
      
      public function set SilenceDetection(param1:Boolean) : void
      {
         if(param1 != this.FSilenceDetection)
         {
            this.FSilenceDetection = param1;
            if(param1)
            {
               this.SilenceDetectionReset(STimingCore.TickCount);
            }
         }
      }
      
      public function get SilenceDetectionTicks() : int
      {
         return this.FSilenceDetectionTicks;
      }
      
      public function set SilenceDetectionTicks(param1:int) : void
      {
         this.FSilenceDetectionTicks = param1;
      }
      
      public function get OnSilenceDetected() : Function
      {
         return this.FOnSilenceDetected;
      }
      
      public function set OnSilenceDetected(param1:Function) : void
      {
         this.FOnSilenceDetected = param1;
      }
      
      public function get IsCipher() : Boolean
      {
         return this.FIsCipher;
      }
      
      public function set IsCipher(param1:Boolean) : void
      {
         this.FIsCipher = param1;
      }
      
      public function Process() : void
      {
         if(this.FConnectionState != CONNECTIONSTATE_Connected)
         {
            return;
         }
         this.ReceivingPerform();
         this.SilenceDetectionPerform();
      }
      
      public function Connect() : void
      {
         switch(this.FConnectionState)
         {
            case CONNECTIONSTATE_Disconnected:
               this.FSocket.connect(this.FServerHost,this.FServerPort);
               this.FPacketCipher.ClearData();
               this.FConnectionState = CONNECTIONSTATE_Connecting;
         }
      }
      
      public function Disconnect() : void
      {
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Socket Disconnect.");
         try
         {
            this.FSocket.close();
         }
         catch(E:Error)
         {
         }
         this.FConnectionState = CONNECTIONSTATE_Disconnected;
      }
      
      public function PacketReceive() : TPacket
      {
         var _loc1_:TPacket = null;
         if(this.FReceivedPackets.length != 0)
         {
            _loc1_ = this.FReceivedPackets.shift();
            _loc1_.StubReferences.Dereference(this);
            return _loc1_;
         }
         return null;
      }
      
      public function PacketTransmit(param1:TPacket) : void
      {
         if(this.FConnectionState != CONNECTIONSTATE_Connected)
         {
            return;
         }
         if(this.FIsCipher)
         {
            this.FTransmitDataBuffer.endian = Endian.BIG_ENDIAN;
            this.FTransmitDataBuffer.writeUnsignedInt(param1.Identifier);
            this.FTransmitDataBuffer.endian = Endian.LITTLE_ENDIAN;
            TUtilityMemory.CopyMemory(this.FTransmitDataBuffer,param1.Data,param1.Data.length,SIZE_PacketLength);
            this.FPacketCipher.EncryptNetBuffer(this.FTransmitDataBuffer,this.FTransmitDataBuffer.length);
            TUtilityMemory.CopyMemory(param1.Data,this.FTransmitDataBuffer);
            this.FSocket.writeUnsignedInt(param1.Data.length + SIZE_PacketLength);
            this.FTransmitDataBuffer.clear();
         }
         else
         {
            param1.Data.endian = Endian.BIG_ENDIAN;
            this.FSocket.writeUnsignedInt(param1.Data.length + SIZE_PacketHeader);
            this.FSocket.writeUnsignedInt(param1.Identifier);
         }
         if(param1.Data.length != 0)
         {
            this.FSocket.writeBytes(param1.Data);
         }
         this.FSocket.flush();
         ++SLogger.State.Transmit;
         SLogger.TraceTransceiver(TLogger.LEVEL_PacketTransmit,param1);
      }
   }
}

