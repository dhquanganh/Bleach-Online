package Logics.Streamization.HDTreasureHunt
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDTreasureHuntShop;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDTreasureHunt.TTreasureShop;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerTreasureShop extends TUnstreamizer
   {
      
      public function TUnstreamizerTreasureShop()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TTreasureShop) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 6;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Items[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.DarkShowItems = _loc5_;
         _loc3_ = 6;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Items[_loc2_ + 6].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.LightShowItems = _loc5_;
         _loc3_ = 6;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Shop[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.DarkShop = _loc5_;
         _loc3_ = 6;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Shop[_loc2_ + 6].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.LightShop = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TTreasureShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDTreasureHuntShop = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.LightItemIndex)
         {
            param3.LightItemCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.DarkItemIndex)
         {
            param3.DarkItemCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.BigAward.index)
         {
            param3.BigAwardStatus = TUtilityTool.ActState(param2);
         }
         this.LightShopResult(param1,param2,param3);
         this.DarkShopResult(param1,param2,param3);
      }
      
      protected function LightShopResult(param1:uint, param2:Object, param3:TTreasureShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = 6;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Shop[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.LightShopStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      protected function DarkShopResult(param1:uint, param2:Object, param3:TTreasureShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = 6;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Shop[_loc5_ + 6];
            if(_loc4_.index == param1)
            {
               param3.DarkShopStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TTreasureShop = null;
         var _loc9_:THDTreasureHuntShop = null;
         _loc8_ = param2 as TTreasureShop;
         _loc9_ = param3 as THDTreasureHuntShop;
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
         var _loc4_:TTreasureShop = null;
         var _loc5_:THDTreasureHuntShop = null;
         _loc4_ = param2 as TTreasureShop;
         _loc5_ = param3 as THDTreasureHuntShop;
         if(param1.Index == _loc5_.LightItemIndex && param1.Status - _loc4_.LightItemCount > 0)
         {
            SToolReward.ShowMessage(_loc5_.Texts[0] + "*" + (param1.Status - _loc4_.LightItemCount));
         }
         if(param1.Index == _loc5_.DarkItemIndex && param1.Status - _loc4_.DarkItemCount > 0)
         {
            SToolReward.ShowMessage(_loc5_.Texts[1] + "*" + (param1.Status - _loc4_.DarkItemCount));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

