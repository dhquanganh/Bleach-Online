package Processors.Game.Log
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Registries.TRegistryInstance;
   import Foundation.UI.TUIComponent;
   import Logics.Log.TLog;
   import Logics.Log.TLogs;
   import Logics.Streamization.Log.TUnstreamizerLog;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_NETWORK;
   
   public class TProcessorLog extends TProcessorGame
   {
      
      protected static const LogType_Goal:int = 0;
      
      protected static const LogType_Person:int = 1;
      
      protected static const LogCommond_All:int = 0;
      
      protected static const LogCommond_Person:int = 1;
      
      protected static const LogCommond_AllPerson:int = 2;
      
      protected var FUnstreamizerLog:TUnstreamizerLog;
      
      protected var FRegistryInstance:TRegistryInstance;
      
      protected var FLogs:TLogs;
      
      public function TProcessorLog(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerLog = new TUnstreamizerLog();
         this.FRegistryInstance = new TRegistryInstance();
         this.FLogs = new TLogs();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Log_Ret,this.PacketPerform_LogRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LogUpdate_Ret,this.PacketPerform_LogUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Log_PersonRet,this.PacketPerform_LogPerson);
      }
      
      protected function PacketPerform_LogRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         _loc3_ = uint(this.CreateNewID(LogType_Goal,_loc2_));
         this.FLogs.ClearByType(_loc3_);
         this.FUnstreamizerLog.Unstreamize(param1.Data,this.FLogs,_loc3_);
         this.NotifyListener(_loc3_);
      }
      
      protected function PacketPerform_LogPerson(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         _loc4_ = uint(this.CreateNewID(LogType_Person,_loc2_));
         this.FLogs.ClearByType(_loc4_);
         this.FUnstreamizerLog.Unstreamize(param1.Data,this.FLogs,_loc4_);
         this.NotifyListener(_loc4_);
      }
      
      protected function PacketPerform_LogUpdate(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<TLog> = null;
         var _loc6_:Vector.<TLog> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         _loc4_ = param1.Data.readUnsignedInt();
         if(_loc4_ == LogCommond_AllPerson)
         {
            _loc3_ = uint(this.CreateNewID(LogType_Person,_loc2_));
            _loc6_ = this.FLogs.GetLogsByType(_loc3_);
            _loc3_ = uint(this.CreateNewID(LogType_Goal,_loc2_));
            _loc5_ = this.FLogs.GetLogsByType(_loc3_);
            _loc7_ = int(_loc5_.length);
            this.FUnstreamizerLog.Unstreamize(param1.Data,this.FLogs,_loc2_);
            _loc9_ = int(_loc5_.length);
            _loc8_ = _loc7_;
            while(_loc8_ < _loc9_)
            {
               _loc6_.push(_loc5_[_loc8_]);
               _loc8_++;
            }
            this.NotifyListener(_loc3_);
            _loc3_ = uint(this.CreateNewID(LogType_Person,_loc2_));
            this.NotifyListener(_loc3_);
            return;
         }
         switch(_loc4_)
         {
            case LogCommond_All:
               _loc3_ = uint(this.CreateNewID(LogType_Goal,_loc2_));
               break;
            case LogCommond_Person:
               _loc3_ = uint(this.CreateNewID(LogType_Person,_loc2_));
         }
         this.FUnstreamizerLog.Unstreamize(param1.Data,this.FLogs,_loc2_);
         this.NotifyListener(_loc3_);
      }
      
      protected function NotifyListener(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Function> = null;
         _loc4_ = this.FRegistryInstance.GetInstanceByIdentifier(param1) as Vector.<Function>;
         if(_loc4_ == null)
         {
            return;
         }
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_](this.FLogs.GetLogsByType(param1) as Vector.<TLog>);
            _loc2_++;
         }
      }
      
      protected function CreateNewID(param1:int, param2:uint) : int
      {
         switch(param1)
         {
            case LogType_Goal:
               return param2;
            case LogType_Person:
               return param2 * 10000;
            default:
               return -1;
         }
      }
      
      public function LoadPersonLog(param1:uint, param2:Function) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         var _loc5_:Vector.<Function> = null;
         var _loc6_:int = 0;
         _loc3_ = uint(this.CreateNewID(LogType_Person,param1));
         _loc5_ = this.FRegistryInstance.GetInstanceByIdentifier(_loc3_) as Vector.<Function>;
         if(_loc5_ == null)
         {
            _loc5_ = new Vector.<Function>();
            this.FRegistryInstance.Register(_loc3_,_loc5_);
         }
         _loc6_ = _loc5_.indexOf(param2);
         if(_loc6_ == -1)
         {
            _loc5_.push(param2);
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Log_PersonReq);
         _loc4_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      public function LoadLog(param1:uint, param2:Function) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:Vector.<Function> = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         _loc6_ = uint(this.CreateNewID(LogType_Goal,param1));
         _loc4_ = this.FRegistryInstance.GetInstanceByIdentifier(_loc6_) as Vector.<Function>;
         if(_loc4_ == null)
         {
            _loc4_ = new Vector.<Function>();
            this.FRegistryInstance.Register(_loc6_,_loc4_);
         }
         _loc5_ = _loc4_.indexOf(param2);
         if(_loc5_ == -1)
         {
            _loc4_.push(param2);
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Log_Req);
         _loc3_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
   }
}

