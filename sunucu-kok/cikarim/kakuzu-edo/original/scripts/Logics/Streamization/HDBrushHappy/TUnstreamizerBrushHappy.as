package Logics.Streamization.HDBrushHappy
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDBrushHappy;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDBrushHappy.TBrushHappyArticle;
   import Logics.HDBrushHappy.TBrushHappyData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerBrushHappy extends TUnstreamizer
   {
      
      public function TUnstreamizerBrushHappy()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:Object, param3:TBrushHappyData) : void
      {
         if(this.ItemIndexsHandle(param1,param2,param3))
         {
            return;
         }
         if(this.RefreshHandle(param1,param2,param3))
         {
            return;
         }
         if(this.ResetHandle(param1,param2,param3))
         {
            return;
         }
         if(this.GiftindexHandle(param1,param2,param3))
         {
            return;
         }
      }
      
      protected function ItemIndexsHandle(param1:uint, param2:Object, param3:TBrushHappyData) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:TBrushHappyArticle = null;
         var _loc6_:uint = 0;
         var _loc7_:TInventories = null;
         var _loc8_:Object = null;
         for each(_loc4_ in param3.Config.ItemIndexs)
         {
            if(param1 == _loc4_)
            {
               _loc5_ = param3.Articles[_loc4_];
               _loc5_.Buyed = TUtilityTool.ActState(param2) == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
               _loc6_ = uint(TUtilityTool.ActIntVec(param2)[0]);
               _loc5_.AwardID = _loc6_;
               _loc7_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc6_,_loc7_);
               _loc5_.Article = _loc7_.GetInventoryByIndex(0);
               _loc8_ = TUtilityTool.GetObjByAtt(param3.Config.Items,"awardId",_loc6_);
               _loc5_.InitPrice = _loc8_.gold;
               _loc5_.CurPrice = _loc5_.InitPrice * _loc5_.CurDiscount / 100;
               _loc5_.DiscountGold = param3.Config.Discount[_loc4_].gold;
               _loc5_.MinDiscount = param3.Config.Discount[_loc4_].discount;
               return true;
            }
         }
         return false;
      }
      
      protected function RefreshHandle(param1:uint, param2:Object, param3:TBrushHappyData) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:TBrushHappyArticle = null;
         for each(_loc4_ in param3.Config.Refresh)
         {
            if(param1 == _loc4_)
            {
               _loc5_ = param3.Articles[param3.Config.Refresh.indexOf(_loc4_)];
               _loc5_.CurDiscount = TUtilityTool.ActState(param2);
               _loc5_.CurPrice = _loc5_.InitPrice * _loc5_.CurDiscount / 100;
               return true;
            }
         }
         return false;
      }
      
      protected function ResetHandle(param1:uint, param2:Object, param3:TBrushHappyData) : Boolean
      {
         if(param1 == param3.Config.Reset.index)
         {
            param3.Time = TUtilityTool.ActState(param2);
            return true;
         }
         return false;
      }
      
      protected function GiftindexHandle(param1:uint, param2:Object, param3:TBrushHappyData) : Boolean
      {
         if(param1 == param3.Config.GiftIndex)
         {
            param3.SpecialItemBuyed = TUtilityTool.ActState(param2) == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            return true;
         }
         return false;
      }
      
      protected function ConfigHandle(param1:TBrushHappyData) : void
      {
         SToolReward.GetAwardsByAwardID(param1.Config.RareGoods,param1.Invs);
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TBrushHappyData = null;
         var _loc8_:THDBrushHappy = null;
         _loc7_ = param2 as TBrushHappyData;
         _loc8_ = param3 as THDBrushHappy;
         _loc7_.Day = param1.ParameterVec[0];
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
         var _loc4_:TBrushHappyData = null;
         _loc4_ = param2 as TBrushHappyData;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

