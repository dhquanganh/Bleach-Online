package Logics.Streamization.NewYear2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2016Check;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Check;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNYCheck extends TUnstreamizer
   {
      
      public function TUnstreamizerNYCheck()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2016Check) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.SignInGifts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.SignInGifts[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.RightGifts[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.PreferentialGifts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.PreferentialGifts[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.LeftGifts[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = uint(param1.Config.SignIn.awardIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.SignIn.awardIds[_loc2_]);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.DayGifts[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2016Check) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNewYear2016Check = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.SignIn.index)
         {
            param3.RawCheckData = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.SignInGifts.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.SignInGifts[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.RightGiftsStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.PreferentialGifts.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.PreferentialGifts[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.LeftGiftsStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TNewYear2016Check = null;
         var _loc9_:THDNewYear2016Check = null;
         _loc8_ = param2 as TNewYear2016Check;
         _loc9_ = param3 as THDNewYear2016Check;
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
         _loc8_.NowDay = param1.ParameterVec[0];
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TNewYear2016Check = null;
         _loc4_ = param2 as TNewYear2016Check;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

