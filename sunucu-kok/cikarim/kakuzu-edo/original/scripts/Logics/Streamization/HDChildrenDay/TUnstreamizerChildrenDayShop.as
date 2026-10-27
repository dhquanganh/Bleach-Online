package Logics.Streamization.HDChildrenDay
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChildrenDayShop;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayShop;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerChildrenDayShop extends TUnstreamizer
   {
      
      public function TUnstreamizerChildrenDayShop()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TChildrenDayShop) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         _loc5_ = new TInventories();
         _loc4_ = uint(param1.Config.LoginAward[0].awardid);
         SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
         param1.Bags_Award[0] = _loc5_;
         _loc6_ = new TInventories();
         SToolReward.GetInventoryByIDAmount(param1.Config.CandyID,param1.Config.LoginAward[0].addScore,_loc6_);
         param1.Bags_Award[0].Add(_loc6_.GetInventoryByIndex(0));
         _loc3_ = 5;
         _loc2_ = 1;
         while(_loc2_ <= _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.PayAward[_loc2_ - 1].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Bags_Award[_loc2_] = _loc5_;
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByIDAmount(param1.Config.CandyID,param1.Config.PayAward[_loc2_ - 1].addScore,_loc6_);
            param1.Bags_Award[_loc2_].Add(_loc6_.GetInventoryByIndex(0));
            _loc2_++;
         }
         _loc3_ = param1.Config.ScoreMall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.ScoreMall[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
         _loc3_ = param1.Config.GoldMall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.GoldMall[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailMoneyInvs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TChildrenDayShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:THDChildrenDayShop = null;
         var _loc9_:uint = 0;
         _loc8_ = param3.Config;
         if(param1 == _loc8_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc8_.PayIndex)
         {
            param3.TodayPay = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc8_.LoginAward[0].index)
         {
            param3.BagStatus[0] = TUtilityTool.ActState(param2);
         }
         _loc6_ = 5;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc8_.PayAward[_loc5_].index == param1)
            {
               param3.BagStatus[_loc5_ + 1] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TChildrenDayShop) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.ScoreMall.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.ScoreMall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.MailStatus[_loc5_] = 0 - TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = param3.Config.GoldMall.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.GoldMall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.MailMoneyStatus[_loc5_] = 0 - TUtilityTool.ActState(param2);
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
         var _loc8_:TChildrenDayShop = null;
         var _loc9_:THDChildrenDayShop = null;
         _loc8_ = param2 as TChildrenDayShop;
         _loc9_ = param3 as THDChildrenDayShop;
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
         var _loc4_:TChildrenDayShop = null;
         var _loc5_:THDChildrenDayShop = null;
         var _loc6_:String = null;
         var _loc7_:TArticle = null;
         _loc4_ = param2 as TChildrenDayShop;
         _loc5_ = param3 as THDChildrenDayShop;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.CandyID) as TArticle;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(_loc7_.Name + ":" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

