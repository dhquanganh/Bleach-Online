package Logics.Streamization.NewYear2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2016Nian;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Nian;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNYNian extends TUnstreamizer
   {
      
      public function TUnstreamizerNYNian()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2016Nian) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         _loc3_ = param1.Config.OnceFund.length;
         _loc6_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TInventories();
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.OnceFund[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            SToolReward.GetInventoryByIDAmount(param1.Config.ArrowId,param1.Config.OnceFund[_loc2_].arrow,_loc6_);
            _loc5_.Add(_loc6_.GetInventoryByIndex(0));
            param1.OnceBags[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.DailyFund.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.DailyFund[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.DaysBags[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.ArrowAwards.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.ArrowAwards[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.NianBags = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2016Nian) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNewYear2016Nian = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ArrowIndex)
         {
            param3.ArrowNum = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.DayRechargeIndex)
         {
            param3.DailyRecharge = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.TotalRechargeIndex)
         {
            param3.AllRecharge = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ActivityFund.index)
         {
            param3.PetStatus = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.OnceFund.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.OnceFund[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.OnceBagsStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.DailyFund.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.DailyFund[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.DailyBagsStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TNewYear2016Nian = null;
         var _loc9_:THDNewYear2016Nian = null;
         _loc8_ = param2 as TNewYear2016Nian;
         _loc9_ = param3 as THDNewYear2016Nian;
         if(_loc8_.Config == null)
         {
            _loc8_.Config = _loc9_;
            this.ConfigHandle(_loc8_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TNewYear2016Nian = null;
         _loc4_ = param2 as TNewYear2016Nian;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

