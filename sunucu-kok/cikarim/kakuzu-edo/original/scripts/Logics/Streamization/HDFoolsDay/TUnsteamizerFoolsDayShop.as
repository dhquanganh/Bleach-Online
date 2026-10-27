package Logics.Streamization.HDFoolsDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDFoolsDayShop;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFoolsDay.TFoolsDayShop;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnsteamizerFoolsDayShop extends TUnstreamizer
   {
      
      public function TUnsteamizerFoolsDayShop()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TFoolsDayShop) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.ScoreShop.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.ScoreShop[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TFoolsDayShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:THDFoolsDayShop = null;
         var _loc9_:uint = 0;
         var _loc10_:TInventories = null;
         _loc8_ = param3.Config;
         if(param1 == _loc8_.CurPriceIndex)
         {
            param3.Price = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc8_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc8_.LuckIndex)
         {
            param3.IsShowLuck = TUtilityTool.ActState(param2) == 1 ? true : false;
         }
         else if(param1 == _loc8_.PlayOnceIndex)
         {
            param3.Free = TUtilityTool.ActState(param2);
         }
         _loc6_ = 3;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc8_.CurItemsIndex[_loc5_] == param1)
            {
               param3.CurInsStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = 3;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc8_.CurItems[_loc5_] == param1)
            {
               _loc10_ = new TInventories();
               _loc7_ = uint(TUtilityTool.ActState(param2));
               SToolReward.GetAwardsByAwardID(_loc7_,_loc10_);
               param3.CurIns[_loc5_] = _loc10_.GetInventoryByIndex(0);
            }
            _loc5_++;
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TFoolsDayShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.ScoreShop.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.ScoreShop[_loc5_];
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
         var _loc7_:uint = 0;
         var _loc8_:TFoolsDayShop = null;
         var _loc9_:THDFoolsDayShop = null;
         _loc8_ = param2 as TFoolsDayShop;
         _loc9_ = param3 as THDFoolsDayShop;
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
         var _loc4_:TFoolsDayShop = null;
         var _loc5_:THDFoolsDayShop = null;
         _loc4_ = param2 as TFoolsDayShop;
         _loc5_ = param3 as THDFoolsDayShop;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + ":" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

