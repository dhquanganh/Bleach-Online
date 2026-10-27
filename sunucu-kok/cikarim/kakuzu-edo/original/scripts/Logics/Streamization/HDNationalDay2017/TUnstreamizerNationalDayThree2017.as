package Logics.Streamization.HDNationalDay2017
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNationalDayThree2017;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay2017.TNationalDay2017Three;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNationalDayThree2017 extends TUnstreamizer
   {
      
      public function TUnstreamizerNationalDayThree2017()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNationalDay2017Three) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.Mall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Mall[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNationalDay2017Three) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNationalDayThree2017 = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 >= _loc7_.ItemsIndex[0] && param1 <= _loc7_.ItemsIndex[8])
         {
            param3.ItemsID[param1 - _loc7_.ItemsIndex[0]] = TUtilityTool.ActState(param2);
         }
         else if(param1 >= _loc7_.ItemsStatus[0] && param1 <= _loc7_.ItemsStatus[8])
         {
            param3.ItemsStatus[param1 - _loc7_.ItemsStatus[0]] = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.LotteryIndex)
         {
            param3.LotteryCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == 9)
         {
            param3.LotteryPos = TUtilityTool.ActState(param2);
         }
         _loc6_ = 10;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.LotteryAward[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.LotteryStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TNationalDay2017Three) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.Mall.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Mall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.MailStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TNationalDay2017Three = null;
         var _loc8_:THDNationalDayThree2017 = null;
         _loc7_ = param2 as TNationalDay2017Three;
         _loc8_ = param3 as THDNationalDayThree2017;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.ConfigHandle(_loc7_);
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
         var _loc4_:TNationalDay2017Three = null;
         _loc4_ = param2 as TNationalDay2017Three;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

