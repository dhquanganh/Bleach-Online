package Logics.Streamization.HDActivityNewHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDNewHalloweenConsume;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewHalloween.THDNewHalloweenConsumeData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TCandyShopVo;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TPumpkinShopVo;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNewHalloweenConsume extends TUnstreamizer
   {
      
      public function TUnstreamizerNewHalloweenConsume()
      {
         super();
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THDNewHalloweenConsumeData = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDNewHalloweenConsume = null;
         var _loc9_:THDBoxStateData = null;
         var _loc10_:TInventories = null;
         var _loc11_:TPumpkinShopVo = null;
         var _loc12_:TCandyShopVo = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as THDNewHalloweenConsumeData;
         _loc8_ = param3 as THDNewHalloweenConsume;
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc6_.CurDay = _loc7_.ParameterVec[0];
         _loc6_.ActivityConfig = _loc8_;
         _loc13_ = _loc8_.DoubleScoreVec[_loc6_.CurDay];
         _loc5_ = int(_loc8_.PumpkinIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new TInventories();
            _loc11_ = new TPumpkinShopVo();
            _loc11_.Index = _loc8_.PumpkinIndexVec[_loc4_];
            _loc11_.Gold = _loc8_.PumpkinGoldVec[_loc4_];
            SToolReward.GetAwardsByAwardID(_loc8_.PumpkinAwardVec[_loc4_],_loc10_);
            _loc11_.Inventories = _loc10_;
            _loc11_.Name = _loc10_.GetInventoryByIndex(0).Name;
            _loc11_.IsDouble = _loc13_.indexOf(_loc11_.Index) != -1 ? true : false;
            _loc6_.PumpkinDataVec[_loc4_] = _loc11_;
            _loc4_++;
         }
         _loc5_ = int(_loc8_.CandyAreaIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new TInventories();
            _loc12_ = new TCandyShopVo();
            _loc12_.Index = _loc8_.CandyAreaIndexVec[_loc4_];
            _loc12_.Gold = _loc8_.CandyAreaGoldVec[_loc4_];
            SToolReward.GetAwardsByAwardID(_loc8_.CandyAreaAwardVec[_loc4_],_loc10_);
            _loc12_.Inventories = _loc10_;
            _loc12_.Name = _loc8_.CandyAreaNameVec[_loc4_];
            _loc14_ = this.GetDiscountData(_loc8_.DiscountPosVec[_loc6_.CurDay],_loc12_.Index,_loc8_.DiscountTypeVec);
            _loc12_.IsDiscount = _loc14_[0];
            _loc12_.Condition = _loc14_[1];
            _loc12_.Minus = _loc14_[2];
            _loc6_.CandyDataVec[_loc4_] = _loc12_;
            _loc4_++;
         }
         _loc5_ = int(_loc7_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc7_.AllBox[_loc4_];
            this.SetData(_loc9_.BoxIndex,_loc9_.State,_loc6_);
            _loc4_++;
         }
      }
      
      private function GetDiscountData(param1:Object, param2:int, param3:Vector.<Object>) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         _loc7_ = [];
         _loc4_ = (param1.index as Array).indexOf(param2);
         _loc6_ = _loc4_ != -1 ? true : false;
         _loc7_[0] = _loc6_;
         if(_loc6_)
         {
            _loc5_ = int((param1.type as Array)[_loc4_]);
            for each(_loc8_ in param3)
            {
               if(_loc8_.type == _loc5_)
               {
                  _loc7_[1] = _loc8_.condition;
                  _loc7_[2] = _loc8_.discount;
                  break;
               }
            }
         }
         else
         {
            _loc7_[1] = 0;
            _loc7_[2] = 0;
         }
         return _loc7_;
      }
      
      private function SetData(param1:int, param2:int, param3:THDNewHalloweenConsumeData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPumpkinShopVo = null;
         var _loc7_:TCandyShopVo = null;
         if(param3.ActivityConfig.ScoreIndex == param1)
         {
            param3.Score = param2;
         }
         else if(param3.ActivityConfig.BuyShopIndex != param1)
         {
            if(param3.ActivityConfig.BuyAwardObj.index == param1)
            {
               param3.AwardState = param2;
            }
         }
         _loc5_ = int(param3.PumpkinDataVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.PumpkinDataVec[_loc4_];
            if(_loc6_.Index == param1)
            {
               _loc6_.ShopCartAmount = param2;
               break;
            }
            _loc4_++;
         }
         _loc5_ = int(param3.CandyDataVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param3.CandyDataVec[_loc4_];
            if(_loc7_.Index == param1)
            {
               _loc7_.ShopCartAmount = param2;
               break;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THDNewHalloweenConsumeData = null;
         var _loc5_:THDNewHalloweenConsume = null;
         var _loc6_:TActAwardStatusInfo = null;
         _loc6_ = param1 as TActAwardStatusInfo;
         _loc4_ = param2 as THDNewHalloweenConsumeData;
         _loc5_ = param3 as THDNewHalloweenConsume;
         this.SetData(_loc6_.Index,_loc6_.Status,_loc4_);
      }
   }
}

