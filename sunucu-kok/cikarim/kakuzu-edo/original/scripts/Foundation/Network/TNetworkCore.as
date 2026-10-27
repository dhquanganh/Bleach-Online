package Foundation.Network
{
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TNetworkCore
   {
      
      protected static const CONNECTIONSTATE_Disconnected:int = CONST_NETWORK.CONNECTIONSTATE_Disconnected;
      
      protected static const CONNECTIONSTATE_Connected:int = CONST_NETWORK.CONNECTIONSTATE_Connected;
      
      protected var FPoolPacket:TPoolPacket;
      
      protected var FTransceiver:TTransceiver;
      
      public function TNetworkCore()
      {
         super();
         this.FPoolPacket = new TPoolPacket();
         this.FTransceiver = new TTransceiver(this.FPoolPacket);
      }
      
      public function get Transceiver() : TTransceiver
      {
         return this.FTransceiver;
      }
      
      public function Update() : void
      {
         this.FTransceiver.Process();
         this.FPoolPacket.Update();
      }
      
      public function ConnectionVerify() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = this.FTransceiver.ConnectionState;
         switch(_loc1_)
         {
            case CONNECTIONSTATE_Connected:
               return true;
            case CONNECTIONSTATE_Disconnected:
               return false;
            default:
               return false;
         }
      }
      
      public function PacketAcquire(param1:uint, param2:ByteArray = null) : TPacket
      {
         return this.FPoolPacket.Acquire(param1,param2);
      }
   }
}

