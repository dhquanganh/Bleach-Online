package Logics.Streamization.EquipForge
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Streamization.TUnstreamizer;
   import Resources.Constants.CONST_NETWORK;
   
   public class TUnstreamizerEquipForge extends TUnstreamizer
   {
      
      public function TUnstreamizerEquipForge()
      {
         super();
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

