package Logics.Streamization.Vip
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TVipConfig;
   import Logics.Spaces.LogicsSpace;
   import Logics.Vip.TVip;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerVip extends TUnstreamizer
   {
      
      public function TUnstreamizerVip()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_VipByDatabase(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_VipByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TVip = null;
         var _loc5_:TVipConfig = null;
         _loc4_ = param2 as TVip;
         _loc4_.Reset();
         _loc5_ = param3 as TVipConfig;
         _loc4_.CoerceProperties(_loc5_.ChargeCount,_loc5_.DailyChicket,_loc5_.FreeLook,_loc5_.BlockTime,_loc5_.StonePecent,_loc5_.SkipBlock,_loc5_.BagCount,_loc5_.ActionLimit,_loc5_.BuyActionLimit,_loc5_.DailySingleReset,_loc5_.DailyChaReset,_loc5_.SkipChargeFight,_loc5_.OneWine,_loc5_.OneWinWine,_loc5_.MoreChange,_loc5_.DailyChangeNum,_loc5_.ArenaSkip,_loc5_.OneTimePet,_loc5_.OneWater,_loc5_.AutoBuyAct,_loc5_.BossFightUp,_loc5_.OneTimeWash,_loc5_.MonsterOneTime,_loc5_.StoneOneTime,_loc5_.Digging,_loc5_.NoClearTime,_loc5_.DayBuyCount,_loc5_.SevenHeroCount,_loc5_.SevenHeroOneKey,_loc5_.SkipSevenHeroFight,_loc5_.AutoJoinActivity,_loc5_.TeamerExpand,_loc5_.AKeyBableTower,_loc5_.ResourcesBackvip,_loc5_.ChangeHeroEnterBuy,_loc5_.ChangeHeroReset,_loc5_.PetInteractionCount,_loc5_.PetTrainClearCD,_loc5_.VainTravelBuy,_loc5_.VainTravelFree,_loc5_.VainTravelReliveTime,_loc5_.CanAutoFight);
      }
   }
}

