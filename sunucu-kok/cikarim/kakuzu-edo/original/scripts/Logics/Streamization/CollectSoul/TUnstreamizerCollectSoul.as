package Logics.Streamization.CollectSoul
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Logics.SoulCollection.TSoulCollectionRnd;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   
   public class TUnstreamizerCollectSoul extends TUnstreamizer
   {
      
      public function TUnstreamizerCollectSoul()
      {
         super();
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CollectSoul_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function GetInventoryByCongfigID(param1:uint, param2:TInventories) : void
      {
         var _loc3_:TRewards = null;
         var _loc4_:TSoulCollectionRnd = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SoulCollectionRnd,param1) as TSoulCollectionRnd;
         _loc3_ = new TRewards([_loc4_.Reward]);
         SToolReward.CreateRewardInventoryByRewardInfor(_loc3_,param2);
      }
   }
}

