package Logics.Streamization.HDChristmas2015
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChrismasRecharge;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TActivityChristmasRecharge;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerChristmasRecharge extends TUnstreamizer
   {
      
      public function TUnstreamizerChristmasRecharge()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TActivityChristmasRecharge) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.ChallengeInfo.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.ChallengeInfo[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Gifts[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TActivityChristmasRecharge) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDChrismasRecharge = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.DayPayIndex)
         {
            param3.Recharged = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.DrawLotteryIndex)
         {
            param3.Free = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.SnowballIndex)
         {
            param3.Cards += TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.ChallengeInfo.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.ChallengeInfo[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.GiftStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TActivityChristmasRecharge = null;
         var _loc9_:THDChrismasRecharge = null;
         _loc8_ = param2 as TActivityChristmasRecharge;
         _loc9_ = param3 as THDChrismasRecharge;
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
            if(_loc6_.BoxIndex == _loc9_.SnowballIndex)
            {
               _loc8_.Cards = _loc6_.State;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TActivityChristmasRecharge = null;
         var _loc5_:THDChrismasRecharge = null;
         _loc4_ = param2 as TActivityChristmasRecharge;
         _loc5_ = param3 as THDChrismasRecharge;
         if(param1.Index == _loc5_.SnowballIndex)
         {
            if(param1.Status > 0)
            {
               SToolReward.ShowMessage(_loc5_.Text + ":" + param1.Status);
            }
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

