package Logics.Streamization.HDChristmas
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChristmasCarnivalConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.THDChristmasCarnivalData;
   import Logics.HDChristmas.VO.TCarnivalHeroVO;
   import Logics.HDChristmas.VO.TCarnivalRandomItemVO;
   import Logics.Inventories.TInventories;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerChristmasCarnival extends TUnstreamizer
   {
      
      protected const ItemData_Len:uint = 4;
      
      protected const ItemData_Tag_ID:uint = 0;
      
      protected const ItemData_Tag_Discount:uint = 1;
      
      protected const ItemData_Tag_BuyState:uint = 2;
      
      protected const ItemData_Tag_DiscountCount:uint = 3;
      
      protected const OtherData_Tag_DiscountCost:uint = 4;
      
      protected const OtherData_Tag_TimeTick:uint = 5;
      
      protected const DiscountRateCom:uint = 100;
      
      protected var FDiscountRateShow:uint;
      
      public function TUnstreamizerChristmasCarnival()
      {
         super();
         if(false)
         {
            this.FDiscountRateShow = 1;
         }
         else
         {
            this.FDiscountRateShow = 10;
         }
      }
      
      protected function FillOtherAll(param1:Vector.<int>, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig, param4:Boolean) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TCarnivalRandomItemVO = null;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:TBins = null;
         var _loc10_:uint = 0;
         param2.ResetRandomItemsFrame();
         _loc5_ = 0;
         while(_loc5_ < THDChristmasCarnivalData.RandomItem_Count)
         {
            _loc8_ = _loc5_ * this.ItemData_Len;
            _loc7_ = this.GetRandomItemObjByCode(param3,param1[this.ItemData_Tag_ID + _loc8_]);
            _loc6_ = new TCarnivalRandomItemVO();
            _loc6_.Inventories = _loc7_.CustomInventories;
            _loc10_ = uint(param1[this.ItemData_Tag_Discount + _loc8_]);
            _loc6_.Discount = _loc10_ / this.FDiscountRateShow;
            _loc6_.Buyed = param1[this.ItemData_Tag_BuyState + _loc8_] <= 0 ? true : false;
            _loc6_.Cost = _loc7_.cost;
            _loc6_.DiscountCost = _loc6_.Cost * (_loc10_ / this.DiscountRateCom);
            _loc6_.Mindiscount = _loc7_.mindiscount / this.FDiscountRateShow;
            _loc6_.IsMinDiscount = _loc6_.Discount <= _loc6_.Mindiscount;
            _loc6_.Name = _loc7_.name;
            _loc6_.RefreshCount = param1[this.ItemData_Tag_DiscountCount + _loc8_];
            _loc6_.Frame = param2.GerRandomItemsFrameByType(_loc7_.type);
            param2.RandomItems[_loc5_] = _loc6_;
            _loc5_++;
         }
         _loc8_ = _loc5_ * this.ItemData_Len;
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         param2.Hero.Cost = param3.Hero.gold;
         _loc10_ = uint(param1[this.ItemData_Tag_Discount + _loc8_]);
         param2.Hero.Discount = _loc10_ / this.FDiscountRateShow;
         param2.Hero.DiscountCost = param2.Hero.Cost * (_loc10_ / this.DiscountRateCom);
         param2.Hero.Exchangeed = param1[this.ItemData_Tag_BuyState + _loc8_] <= 0 ? true : false;
         param2.Hero.Hero = _loc9_.GetDatebaseByIdentifier(param3.Hero.heroId) as TBaseHero;
         param2.Hero.IsMinDiscount = param2.Hero.Discount <= param3.Hero.mindiscount / this.FDiscountRateShow;
         param2.Hero.RefreshCount = param1[this.ItemData_Tag_DiscountCount + _loc8_];
         param2.DiscountCoin = param1[this.OtherData_Tag_DiscountCost + _loc8_];
         if(param2.FirstInit || param2.RemainFreeRefreshTime == 0)
         {
            param2.UpdateRefreshGoodsTimeStamp(param3.RefreshIntervalTime * 3600,param1[this.OtherData_Tag_TimeTick + _loc8_]);
         }
      }
      
      protected function GetRandomItemObjByCode(param1:THDChristmasCarnivalConfig, param2:uint) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:TInventories = null;
         _loc4_ = param1.AllItems.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AllItems[_loc3_];
            if(_loc5_.award == param2)
            {
               _loc6_ = new TInventories();
               SToolReward.GetAwardsByAwardID(param2,_loc6_);
               _loc5_.CustomInventories = _loc6_;
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function ItemRefresh(param1:TActAwardStatusInfo, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig, param4:int) : void
      {
         var _loc5_:TCarnivalRandomItemVO = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc5_ = param2.RandomItems[param4];
         _loc7_ = uint(param1.Status);
         _loc5_.Discount = _loc7_ / this.FDiscountRateShow;
         _loc5_.DiscountCost = _loc5_.Cost * (_loc7_ / this.DiscountRateCom);
         _loc5_.IsMinDiscount = _loc5_.Discount <= _loc5_.Mindiscount;
         _loc6_ = param2.GetNeedDiscountCoinByCount(_loc5_.RefreshCount);
         param2.DiscountCoin -= _loc6_;
         ++_loc5_.RefreshCount;
         param2.Msg.push(param2.Language.GetStr4(_loc5_.Discount));
      }
      
      protected function ItemBuy(param1:TActAwardStatusInfo, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig, param4:int) : void
      {
         var _loc5_:TCarnivalRandomItemVO = null;
         _loc5_ = param2.RandomItems[param4];
         _loc5_.Buyed = true;
      }
      
      protected function HeroRefresh(param1:TActAwardStatusInfo, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig) : void
      {
         var _loc4_:TCarnivalHeroVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2.Hero;
         _loc6_ = uint(param1.Status);
         _loc4_.Discount = _loc6_ / this.FDiscountRateShow;
         _loc4_.DiscountCost = _loc4_.Cost * (_loc6_ / this.DiscountRateCom);
         _loc4_.IsMinDiscount = _loc4_.Discount <= param3.Hero.mindiscount / this.FDiscountRateShow;
         _loc5_ = param2.GetNeedDiscountCoinByCount(_loc4_.RefreshCount);
         param2.DiscountCoin -= _loc5_;
         ++_loc4_.RefreshCount;
         param2.Msg.push(param2.Language.GetStr4(_loc4_.Discount));
      }
      
      protected function HeroBuy(param1:TActAwardStatusInfo, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig) : void
      {
         var _loc4_:TCarnivalHeroVO = null;
         _loc4_ = param2.Hero;
         _loc4_.Exchangeed = true;
      }
      
      protected function UpdateDiscountCost(param1:TActAwardStatusInfo, param2:THDChristmasCarnivalData, param3:THDChristmasCarnivalConfig) : void
      {
         param2.DiscountCoin = param1.Status;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TTypeCodeAmount = null;
         var _loc6_:THDChristmasCarnivalData = null;
         var _loc7_:THDChristmasCarnivalConfig = null;
         var _loc8_:Object = null;
         if(param1.ParameterVec.length <= 0)
         {
            return;
         }
         _loc6_ = param2 as THDChristmasCarnivalData;
         _loc7_ = param3 as THDChristmasCarnivalConfig;
         _loc6_.Config = _loc7_;
         _loc4_ = 0;
         while(_loc4_ < THDChristmasCarnivalData.RareItem_Count)
         {
            _loc5_ = new TTypeCodeAmount();
            _loc8_ = _loc7_.SuperItems[_loc4_];
            _loc5_.Type = _loc8_.type;
            _loc5_.Code = _loc8_.code;
            _loc5_.Amount = _loc8_.amount;
            _loc6_.RareItems[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.FillOtherAll(param1.ParameterVec,_loc6_,_loc7_,true);
         _loc6_.FirstInit = false;
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:THDChristmasCarnivalData = null;
         var _loc5_:THDChristmasCarnivalConfig = null;
         var _loc6_:int = 0;
         _loc4_ = param2 as THDChristmasCarnivalData;
         _loc5_ = param3 as THDChristmasCarnivalConfig;
         _loc6_ = _loc5_.ItemRefreshIndexs.indexOf(param1.Index);
         if(_loc6_ != -1)
         {
            this.ItemRefresh(param1,_loc4_,_loc5_,_loc6_);
            return;
         }
         _loc6_ = _loc5_.ItemBuyIndexs.indexOf(param1.Index);
         if(_loc6_ != -1)
         {
            this.ItemBuy(param1,_loc4_,_loc5_,_loc6_);
            return;
         }
         if(param1.Index == _loc5_.RefreshHeroIndex)
         {
            this.HeroRefresh(param1,_loc4_,_loc5_);
            return;
         }
         if(param1.Index == _loc5_.Hero.index)
         {
            this.HeroBuy(param1,_loc4_,_loc5_);
            return;
         }
         if(param1.Index == _loc5_.RefreshIndex)
         {
            this.FillOtherAll(param1.Condition,_loc4_,_loc5_,false);
            return;
         }
         if(param1.Index == _loc5_.DiscountCostIndex)
         {
            this.UpdateDiscountCost(param1,_loc4_,_loc5_);
            return;
         }
      }
   }
}

