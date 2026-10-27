package Logics.Streamization.HDNationalDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNationalDayTwo;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay.TNationalDayTwo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerNationalDayTwo extends TUnstreamizer
   {
      
      public function TUnstreamizerNationalDayTwo()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNationalDayTwo) : void
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
            _loc4_ = uint(param1.Config.Mall[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.Shop = _loc5_;
         param1.CurItemsLast = new Vector.<int>(param1.Config.Items.length);
         _loc3_ = param1.Config.Mall.length;
         param1.ShopStatus = new Vector.<int>(_loc3_);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TNationalDayTwo) : void
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
               param3.ShopStatus[_loc5_] = -1 * TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNationalDayTwo) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNationalDayTwo = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.FreeIndex)
         {
            param3.Free = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.DiscountIndex)
         {
            param3.IsDiscount = TUtilityTool.ActState(param2);
         }
         else if(param1 >= _loc7_.CurPoolIndex[0] && param1 <= _loc7_.CurPoolIndex[5])
         {
            param3.CurItemsIndex[param1 - _loc7_.CurPoolIndex[0]] = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.Items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.Items[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.CurItemsLast[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         this.ShopResult(param1,param2,param3);
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TNationalDayTwo = null;
         var _loc8_:THDNationalDayTwo = null;
         _loc7_ = param2 as TNationalDayTwo;
         _loc8_ = param3 as THDNationalDayTwo;
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
         var _loc4_:TNationalDayTwo = null;
         var _loc5_:THDNationalDayTwo = null;
         _loc4_ = param2 as TNationalDayTwo;
         _loc5_ = param3 as THDNationalDayTwo;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

