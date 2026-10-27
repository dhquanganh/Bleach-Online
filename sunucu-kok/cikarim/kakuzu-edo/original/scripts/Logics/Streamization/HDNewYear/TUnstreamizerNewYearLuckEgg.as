package Logics.Streamization.HDNewYear
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYearLuckEggConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear.THDNewYearLuckEggData;
   import Logics.HDNewYear.VO.TNewYearLuckEggGiftVO;
   import Logics.HDNewYear.VO.TNewYearLuckEggVO;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNewYearLuckEgg extends TUnstreamizer
   {
      
      public function TUnstreamizerNewYearLuckEgg()
      {
         super();
      }
      
      protected function Core(param1:int, param2:int, param3:THDNewYearLuckEggData, param4:THDNewYearLuckEggConfig) : void
      {
         if(this.ProcessorLoginGift(param1,param2,param3,param4))
         {
            return;
         }
         if(this.ProcessorEggRollGift(param1,param2,param3,param4))
         {
            return;
         }
         this.ProcessorOther(param1,param2,param3,param4);
      }
      
      protected function ProcessorLoginGift(param1:int, param2:int, param3:THDNewYearLuckEggData, param4:THDNewYearLuckEggConfig) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         _loc6_ = param4.LoginAward.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param4.LoginAward[_loc5_];
            if(_loc7_.index == param1)
            {
               param3.LoginGifts[_loc5_].GiftState = param2;
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function ProcessorEggRollGift(param1:int, param2:int, param3:THDNewYearLuckEggData, param4:THDNewYearLuckEggConfig) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         _loc6_ = param4.EggTicketAward.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param4.EggTicketAward[_loc5_];
            if(_loc7_.index == param1)
            {
               param3.EggRollGifts[_loc5_].GiftState = param2;
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function ProcessorOther(param1:int, param2:int, param3:THDNewYearLuckEggData, param4:THDNewYearLuckEggConfig) : void
      {
         switch(param1)
         {
            case param4.FreeTimeIndex:
               param3.Eggs[0].CurCount = param2;
               break;
            case param4.HammerIndex:
               param3.HammerCount = param2;
               break;
            case param4.EggTicketIndex:
               param3.EggRollCount = param2;
               break;
            case param4.TimeIndex:
               param3.UpdateFreeEggTimeStamp(param4.CopperEgg.condition[0].value * 3600,param2);
         }
      }
      
      protected function ProcessorConfig(param1:THDNewYearLuckEggData, param2:THDNewYearLuckEggConfig) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TNewYearLuckEggGiftVO = null;
         var _loc5_:TInventories = null;
         var _loc6_:uint = 0;
         var _loc7_:TNewYearLuckEggVO = null;
         var _loc8_:TNewYearLuckEggVO = null;
         var _loc9_:TNewYearLuckEggVO = null;
         var _loc10_:Object = null;
         param1.Config = param2;
         _loc3_ = 0;
         while(_loc3_ < THDNewYearLuckEggData.LOGINGIFTS_COUNT)
         {
            _loc5_ = new TInventories();
            _loc6_ = uint(param2.LoginAward[_loc3_].award);
            SToolReward.GetAwardsByAwardID(_loc6_,_loc5_);
            _loc4_ = param1.LoginGifts[_loc3_];
            _loc4_.Inventories = _loc5_;
            _loc3_++;
         }
         _loc9_ = param1.Eggs[0];
         _loc8_ = param1.Eggs[1];
         _loc7_ = param1.Eggs[2];
         _loc5_ = new TInventories();
         _loc6_ = uint(param2.CopperEgg.award);
         SToolReward.GetAwardsByAwardID(_loc6_,_loc5_,true);
         _loc9_.IsFree = true;
         _loc9_.GetEggRollCount = param2.CopperEgg.eggTicket;
         _loc9_.Inventories = _loc5_;
         _loc9_.TotalCount = param2.FreeTimes;
         _loc5_ = new TInventories();
         _loc6_ = uint(param2.SilverEgg.award);
         SToolReward.GetAwardsByAwardID(_loc6_,_loc5_,true);
         _loc8_.IsFree = false;
         _loc8_.GetEggRollCount = param2.SilverEgg.eggTicket;
         _loc8_.NeedGold = param2.SilverEgg.costHammer * param2.HammerCostGold;
         _loc8_.NeedHammerCount = param2.SilverEgg.costHammer;
         _loc8_.Inventories = _loc5_;
         _loc5_ = new TInventories();
         _loc6_ = uint(param2.GoldEgg.award);
         SToolReward.GetAwardsByAwardID(_loc6_,_loc5_,true);
         _loc7_.IsFree = false;
         _loc7_.GetEggRollCount = param2.GoldEgg.eggTicket;
         _loc7_.NeedGold = param2.GoldEgg.costHammer * param2.HammerCostGold;
         _loc7_.NeedHammerCount = param2.GoldEgg.costHammer;
         _loc7_.Inventories = _loc5_;
         _loc3_ = 0;
         while(_loc3_ < THDNewYearLuckEggData.EGGROLLGIFTS_COUNT)
         {
            _loc10_ = param2.EggTicketAward[_loc3_];
            _loc5_ = new TInventories();
            _loc6_ = uint(_loc10_.award);
            SToolReward.GetAwardsByAwardID(_loc6_,_loc5_);
            _loc4_ = param1.EggRollGifts[_loc3_];
            _loc4_.Inventories = _loc5_;
            _loc4_.Condition = _loc10_.condition;
            _loc3_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:THDNewYearLuckEggData = null;
         var _loc8_:THDNewYearLuckEggConfig = null;
         _loc7_ = param2 as THDNewYearLuckEggData;
         _loc8_ = param3 as THDNewYearLuckEggConfig;
         this.ProcessorConfig(_loc7_,_loc8_);
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc7_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:THDNewYearLuckEggData = null;
         var _loc5_:THDNewYearLuckEggConfig = null;
         _loc4_ = param2 as THDNewYearLuckEggData;
         _loc5_ = param3 as THDNewYearLuckEggConfig;
         this.Core(param1.Index,param1.Status,_loc4_,_loc5_);
      }
   }
}

