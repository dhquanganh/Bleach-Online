package Logics.Streamization.NewYear2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2016Chess;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Chess;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNYChess extends TUnstreamizer
   {
      
      public function TUnstreamizerNYChess()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2016Chess) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         for each(_loc2_ in param1.Config.ScoreShop)
         {
            if(_loc2_.type != 1)
            {
               SToolReward.GetAwardsByAwardID(_loc2_.awardId,param1.ScoreShop);
            }
            else
            {
               _loc4_ = new TInventories();
               SToolReward.GetInventoryByIDAmount(param1.Config.DumplinId,_loc2_.dumpling,_loc4_);
               param1.ScoreShop.Add(_loc4_.GetInventoryByIndex(0));
               _loc4_.Clear();
            }
         }
         for each(_loc3_ in param1.Config.AwardShow)
         {
            SToolReward.GetAwardsByAwardID(_loc3_,param1.AwardShow);
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2016Chess) : void
      {
         var _loc4_:THDNewYear2016Chess = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param3.Config;
         if(param1 == _loc4_.SuperDice.index)
         {
            param3.CurPos = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc4_.OrdinaryDice.index)
         {
            param3.Time = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc4_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc4_.BigAward.index)
         {
            param3.JackStatus = TUtilityTool.ActState(param2);
         }
         else
         {
            _loc5_ = _loc4_.AwardBins.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(param1 == _loc4_.AwardBins[_loc6_].index)
               {
                  param3.Awards[_loc6_] = new TInventories();
                  SToolReward.GetAwardsByAwardID(TUtilityTool.ActState(param2),param3.Awards[_loc6_]);
               }
               _loc6_++;
            }
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TNewYear2016Chess) : void
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
               param3.ShopStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TNewYear2016Chess = null;
         var _loc9_:THDNewYear2016Chess = null;
         _loc8_ = param2 as TNewYear2016Chess;
         _loc9_ = param3 as THDNewYear2016Chess;
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
         var _loc4_:TNewYear2016Chess = null;
         _loc4_ = param2 as TNewYear2016Chess;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

