package Logics.Streamization.HDThanksgivingDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDThanksTreasure;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThanksTreasureData;
   import Logics.HDThanksgivingDay.TThanksTreasureVO;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerThanksTreasure extends TUnstreamizer
   {
      
      protected const SeqKey:uint = 100;
      
      protected const StateKey:uint = 10;
      
      public function TUnstreamizerThanksTreasure()
      {
         super();
      }
      
      protected function InitConfigData(param1:TThanksTreasureData) : void
      {
         var _loc2_:Object = null;
         param1.InitMap();
         for each(_loc2_ in param1.Config.ScoreMall)
         {
            SToolReward.GetAwardsByAwardID(_loc2_.award,param1.ScoreShop);
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TThanksTreasureData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TThanksTreasureVO = null;
         var _loc7_:TInventory = null;
         if(param1 == param3.Config.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.FreeIndex)
         {
            param3.RemainDig = param3.Config.FreeTreasure - TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.TreasureIndex)
         {
            param3.StopIndex = TUtilityTool.ActState(param2) - param3.Config.AwardIndex[0];
         }
         else if(param1 == param3.Config.RefreshIndex)
         {
            param3.CurRefresh = true;
            param3.GameOver = false;
         }
         else if(param1 >= param3.Config.AwardIndex[0] && param1 <= param3.Config.AwardIndex[1])
         {
            _loc4_ = TUtilityTool.ActState(param2) / this.SeqKey;
            _loc5_ = TUtilityTool.ActState(param2) % this.StateKey;
            _loc6_ = param3.Map[param1 - param3.Config.AwardIndex[0]];
            _loc6_.State = _loc5_;
            if(_loc4_ == 0)
            {
               _loc6_.Article = null;
               if(_loc5_ == TThanksTreasureVO.STATE_RECEIVE)
               {
                  param3.GameOver = true;
               }
            }
            else
            {
               _loc7_ = this.GetTreasureInv(_loc4_,param3.Config.GoldRate);
               if(_loc7_ == null)
               {
                  _loc7_ = this.GetTreasureInv(_loc4_,param3.Config.SilverRate);
               }
               _loc6_.Article = _loc7_;
            }
         }
         else if(param1 == param3.Config.HeroGift.index)
         {
            param3.HeroGiftState = TUtilityTool.ActState(param2);
         }
         else
         {
            this.ToMall(param1,param2,param3);
         }
      }
      
      protected function ToMall(param1:uint, param2:Object, param3:TThanksTreasureData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         _loc5_ = param3.Config.ScoreMall.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.Config.ScoreMall[_loc4_];
            if(_loc6_.index == param1)
            {
               if(_loc6_.limit != 0 && _loc6_.limit - TUtilityTool.ActState(param2) <= 0)
               {
                  _loc7_ = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
               }
               else
               {
                  _loc7_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
               }
               param3.ScoreItemStates[_loc4_] = _loc7_;
            }
            _loc4_++;
         }
      }
      
      protected function GetTreasureInv(param1:uint, param2:Vector.<Object>) : TInventory
      {
         var _loc3_:Object = null;
         var _loc4_:TInventories = null;
         for each(_loc3_ in param2)
         {
            if(param1 == _loc3_.seq)
            {
               _loc4_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc3_.award,_loc4_,true);
               return _loc4_.GetInventoryByIndex(0);
            }
         }
         return null;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TThanksTreasureData = null;
         var _loc8_:THDThanksTreasure = null;
         _loc7_ = param2 as TThanksTreasureData;
         _loc8_ = param3 as THDThanksTreasure;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.InitConfigData(_loc7_);
         }
         _loc7_.CurRefresh = false;
         _loc7_.StopIndex = -1;
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
         var _loc4_:TThanksTreasureData = null;
         _loc4_ = param2 as TThanksTreasureData;
         _loc4_.CurRefresh = false;
         _loc4_.StopIndex = -1;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

