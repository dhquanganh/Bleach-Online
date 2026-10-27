package Logics.Streamization.HDChristmas2015
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDSnowBattle;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.TSnowBattleData;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerSnowBattle extends TUnstreamizer
   {
      
      protected var FInit:Boolean;
      
      public function TUnstreamizerSnowBattle()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TSnowBattleData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = param1.Config.Gift.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Gift[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,param1.Invs);
            param1.ArticleState[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TSnowBattleData) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(param1 == param3.Config.Candy)
         {
            _loc7_ = uint(TUtilityTool.ActState(param2));
            if(!this.FInit)
            {
               param3.CurGetScore = _loc7_ - param3.TotalScore;
            }
            param3.TotalScore = _loc7_;
         }
         else if(param1 == param3.Config.Notify)
         {
            param3.GameCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.TitleGift.index)
         {
            param3.TitleState = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.Turn)
         {
            param3.Wheel = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.CardsIndex)
         {
            param3.CardsBtnState = TUtilityTool.ActState(param2);
         }
         else
         {
            _loc6_ = param3.Config.Gift.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc4_ = param3.Config.Gift[_loc5_];
               if(_loc4_.index == param1)
               {
                  param3.ArticleState[_loc5_] = TUtilityTool.ActState(param2);
               }
               _loc5_++;
            }
            if(param3.AllReceive())
            {
               param3.ResetReceive();
            }
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TSnowBattleData = null;
         var _loc8_:THDSnowBattle = null;
         _loc7_ = param2 as TSnowBattleData;
         _loc8_ = param3 as THDSnowBattle;
         this.FInit = true;
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
         var _loc4_:TSnowBattleData = null;
         _loc4_ = param2 as TSnowBattleData;
         this.FInit = false;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

