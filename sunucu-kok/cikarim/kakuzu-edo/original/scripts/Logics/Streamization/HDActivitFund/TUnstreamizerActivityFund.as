package Logics.Streamization.HDActivitFund
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDGrowFundGamble;
   import Logics.DatebaseVO.VO.THDGrowFundLv;
   import Logics.DatebaseVO.VO.THDGrowFundShop;
   import Logics.HDActivityFund.TFundInvestment;
   import Logics.HDActivityFund.TFundLvAwardData;
   import Logics.HDActivityFund.TFundShopAward;
   import Logics.HDActivityFund.THDFundInvestmentData;
   import Logics.HDActivityFund.THDFundLvData;
   import Logics.HDActivityFund.THDFundShopData;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerActivityFund extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityFund()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateFundLevel(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDFundLvData = null;
         var _loc6_:TFundLvAwardData = null;
         var _loc7_:THDGrowFundLv = null;
         _loc5_ = param1 as THDFundLvData;
         _loc7_ = param2 as THDGrowFundLv;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetAwardByIndex(_loc3_);
            _loc6_.Name = _loc7_.Bags[_loc3_].Prompt;
            _loc6_.Level = _loc7_.Bags[_loc3_].Level;
            _loc6_.Gold = _loc7_.Bags[_loc3_].Gold;
            _loc6_.ItemIdList = _loc7_.Bags[_loc3_].Awards;
            _loc6_.InventoriesId = _loc7_.Bags[_loc3_].InventoriesId;
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateFundInvestment(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDFundInvestmentData = null;
         var _loc6_:TFundInvestment = null;
         var _loc7_:THDGrowFundGamble = null;
         var _loc8_:uint = 0;
         _loc5_ = param1 as THDFundInvestmentData;
         _loc7_ = param2 as THDGrowFundGamble;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetAwardByIndex(_loc3_);
            _loc6_.NeedGold = _loc7_.GambleAwards[_loc3_].Gold;
            _loc6_.Range = _loc7_.GambleAwards[_loc3_].Range;
            _loc6_.Decs = _loc7_.GambleAwards[_loc3_].Prompt;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetAwardByIndex(_loc3_);
            if(_loc6_.Income == 0)
            {
               _loc8_ = uint(_loc3_);
               break;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetAwardByIndex(_loc3_);
            if(_loc3_ < _loc8_)
            {
               _loc6_.State = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            }
            else if(_loc3_ == _loc8_)
            {
               _loc6_.State = CONST_ACTIVITY_MODE.Activity_CanReceive;
            }
            else
            {
               _loc6_.State = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateFundShop(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDFundShopData = null;
         var _loc6_:TFundShopAward = null;
         var _loc7_:THDGrowFundShop = null;
         var _loc8_:int = 0;
         _loc5_ = param1 as THDFundShopData;
         _loc7_ = param2 as THDGrowFundShop;
         _loc5_.ClearAward();
         _loc4_ = int(_loc7_.FundShops.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = new TFundShopAward();
            _loc6_.NeedGold = _loc7_.FundShops[_loc3_].Gold;
            _loc6_.ShopName = _loc7_.FundShops[_loc3_].Name;
            _loc6_.AwardIDs = _loc7_.FundShops[_loc3_].Goods;
            _loc6_.ReturnMoney = _loc7_.FundShops[_loc3_].Ticket;
            _loc5_.AddAward(_loc6_);
            _loc3_++;
         }
      }
      
      public function UnstreamizeUpdateFundLevel(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateFundLevel(param1,param2);
      }
      
      public function UnstreamizeUpdateFundInvestment(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateFundInvestment(param1,param2);
      }
      
      public function UnstreamizeUpdateFundShop(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateFundShop(param1,param2);
      }
   }
}

