package Logics.Streamization.HDThanksgivingDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDThanksFeast;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThanksFeastData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerThanksFeast extends TUnstreamizer
   {
      
      public function TUnstreamizerThanksFeast()
      {
         super();
      }
      
      protected function InitConfigData(param1:TThanksFeastData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:TInventories = null;
         _loc4_ = param1.Config.Puzzle.award;
         _loc3_ = _loc4_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_[_loc2_];
            _loc6_ = uint(_loc5_.awardID);
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_,_loc7_);
            param1.PuzzleInvs[_loc2_] = _loc7_;
            _loc2_++;
         }
         _loc4_ = param1.Config.DailyGift.award[param1.Day];
         _loc3_ = _loc4_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_[_loc2_];
            _loc6_ = uint(_loc5_.awardID);
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_,_loc7_);
            param1.DailyGiftInvs[_loc2_] = _loc7_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TThanksFeastData) : void
      {
         if(param1 == param3.Config.Puzzle.index)
         {
            param3.PuzzleKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.Pet.index)
         {
            param3.PetKey = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.RechargeIndex)
         {
            param3.RechargeGold = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.DailyGift.index)
         {
            param3.AwardListKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.DailyRechargeIndex)
         {
            param3.DailyRechargeGold = TUtilityTool.ActState(param2);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TThanksFeastData = null;
         var _loc8_:THDThanksFeast = null;
         _loc7_ = param2 as TThanksFeastData;
         _loc8_ = param3 as THDThanksFeast;
         _loc7_.Day = param1.ParameterVec[0];
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.InitConfigData(_loc7_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TThanksFeastData = null;
         _loc4_ = param2 as TThanksFeastData;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

