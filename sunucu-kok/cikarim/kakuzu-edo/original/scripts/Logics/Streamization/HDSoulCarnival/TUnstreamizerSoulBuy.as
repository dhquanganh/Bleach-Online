package Logics.Streamization.HDSoulCarnival
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDSoulBuy;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulBuy;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerSoulBuy extends TUnstreamizer
   {
      
      public function TUnstreamizerSoulBuy()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TSoulBuy) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         _loc3_ = 12;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.BuyAward[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Bags[_loc2_] = _loc5_;
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByIDAmount(param1.Config.ScoreID,param1.Config.BuyAward[_loc2_].score,_loc6_);
            param1.Bags[_loc2_].Add(_loc6_.GetInventoryByIndex(0));
            _loc2_++;
         }
         _loc3_ = param1.Config.ScoreMall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.ScoreMall[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.Shop = _loc5_;
      }
      
      protected function DarkShopResult(param1:uint, param2:Object, param3:TSoulBuy) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.ScoreMall.length;
         param3.ShopStatus = new Vector.<int>(_loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.ScoreMall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.ShopStatus[_loc5_] = -1 * TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TSoulBuy) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDSoulBuy = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.BigAward.index)
         {
            param3.BigAwardStatus = TUtilityTool.ActState(param2);
         }
         this.DarkShopResult(param1,param2,param3);
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TSoulBuy = null;
         var _loc9_:THDSoulBuy = null;
         _loc8_ = param2 as TSoulBuy;
         _loc9_ = param3 as THDSoulBuy;
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
         var _loc4_:TSoulBuy = null;
         var _loc5_:THDSoulBuy = null;
         _loc4_ = param2 as TSoulBuy;
         _loc5_ = param3 as THDSoulBuy;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(_loc5_.Texts + "*" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

