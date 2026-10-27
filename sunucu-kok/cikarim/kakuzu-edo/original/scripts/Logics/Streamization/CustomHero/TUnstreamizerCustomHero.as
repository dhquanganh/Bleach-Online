package Logics.Streamization.CustomHero
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Streamization.TUnstreamizer;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerCustomHero extends TUnstreamizer
   {
      
      public function TUnstreamizerCustomHero()
      {
         super();
      }
      
      public function InitRet(param1:ByteArray) : void
      {
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

