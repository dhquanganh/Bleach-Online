package Logics.Streamization.Campaign
{
   import Logics.Campaign.AutoBattle.TTurnResult;
   import Logics.Campaign.TNodalAutoBattleInfo;
   import Logics.Items.TItems;
   import Logics.Streamization.Items.TUnstreamizerRewards;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerAutoBattleInfo extends TUnstreamizerCampaignUnknown
   {
      
      private var FUnstreamizerRewards:TUnstreamizerRewards;
      
      public function TUnstreamizerAutoBattleInfo()
      {
         super();
         this.FUnstreamizerRewards = new TUnstreamizerRewards();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TTurnResult = null;
         var _loc7_:TNodalAutoBattleInfo = null;
         var _loc8_:uint = 0;
         var _loc9_:TItems = null;
         var _loc10_:uint = 0;
         _loc7_ = param2 as TNodalAutoBattleInfo;
         _loc7_.CostTimer = param1.readInt();
         _loc7_.IsWorldLevel = Boolean(param1.readByte() > 0);
         _loc8_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc6_ = new TTurnResult();
            _loc10_ = uint(param1.readShort());
            _loc5_ = 0;
            while(_loc5_ < _loc10_)
            {
               _loc9_ = new TItems();
               this.FUnstreamizerRewards.Unstreamize(param1,_loc9_,param3);
               _loc6_.WaveReward.push(_loc9_);
               _loc5_++;
            }
            this.FUnstreamizerRewards.Unstreamize(param1,_loc6_.EndReward,param3);
            _loc7_.BattleResult.push(_loc6_);
            _loc4_++;
         }
      }
   }
}

