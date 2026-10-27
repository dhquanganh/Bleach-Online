package Logics.Streamization.NewYear2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2016Pocket;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Pocket;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerNYPocket extends TUnstreamizer
   {
      
      protected var FIsinit:Boolean;
      
      public function TUnstreamizerNYPocket()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2016Pocket) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TInventories = null;
         for each(_loc2_ in param1.Config.ScoreShop)
         {
            SToolReward.GetAwardsByAwardID(_loc2_.awardId,param1.ScoreShop);
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2016Pocket) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TInventories = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:THDNewYear2016Pocket = null;
         _loc13_ = param3.Config;
         if(param1 == _loc13_.PocketsCount.index)
         {
            param3.RedLast = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc13_.RedPackageIndex)
         {
            param3.Red = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc13_.ScoreIndex)
         {
            _loc10_ = int(param3.Candy);
            param3.Candy = TUtilityTool.ActState(param2);
            _loc10_ = param3.Candy - _loc10_;
            if(this.FIsinit && _loc10_ > 0)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + _loc10_);
            }
         }
         else if(param1 == _loc13_.BigAward.index)
         {
            param3.BigAwardStatus = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc13_.Refresh.index)
         {
            param3.IsReFlash = true;
         }
         else if(param1 == _loc13_.lookIndex)
         {
            _loc12_ = uint(TUtilityTool.ActState(param2));
            _loc4_ = 15;
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               param3.BagsStatus[_loc7_] = 0;
               _loc7_++;
            }
            _loc7_ = 0;
            while(_loc12_ > 0)
            {
               param3.BagsStatus[_loc7_] = TUtilityTool.GetValueByBit(_loc12_,0);
               _loc12_ >>= 1;
               _loc7_++;
            }
         }
         else
         {
            _loc4_ = _loc13_.PocketIndexs.length;
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               if(param1 == _loc13_.PocketIndexs[_loc7_])
               {
                  param3.BagsID[_loc7_] = TUtilityTool.ActState(param2);
               }
               _loc7_++;
            }
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TNewYear2016Pocket) : void
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
               param3.ShopStates[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TNewYear2016Pocket = null;
         var _loc9_:THDNewYear2016Pocket = null;
         _loc8_ = param2 as TNewYear2016Pocket;
         _loc9_ = param3 as THDNewYear2016Pocket;
         _loc8_.IsReFlash = false;
         this.FIsinit = false;
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
         _loc8_.IsReFlash = false;
         this.FIsinit = true;
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TNewYear2016Pocket = null;
         _loc4_ = param2 as TNewYear2016Pocket;
         _loc4_.IsReFlash = false;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

