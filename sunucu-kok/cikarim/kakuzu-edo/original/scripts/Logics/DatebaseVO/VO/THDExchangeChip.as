package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityEquipmentShop.TBuyBox;
   import Logics.HDActivityEquipmentShop.TChip;
   import Logics.HDActivityEquipmentShop.TExchange;
   import Logics.HDActivityEquipmentShop.TExchangeType;
   import Logics.HDActivityEquipmentShop.TFreeDraw;
   import Logics.HDActivityEquipmentShop.TRateData;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDExchangeChip extends THDActivityBase
   {
      
      protected var FBuyBoxVect:Vector.<TBuyBox>;
      
      protected var FFreeDrawVect:Vector.<TFreeDraw>;
      
      protected var FChipVect:Vector.<TChip>;
      
      protected var FExchangeVect:Vector.<TExchange>;
      
      protected var FPage1Desc:String;
      
      protected var FPage2Desc:String;
      
      protected var FExchangeTypeVect:Vector.<TExchangeType>;
      
      public function THDExchangeChip()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:TBuyBox = null;
         var _loc10_:TFreeDraw = null;
         var _loc11_:TExchange = null;
         var _loc12_:TChip = null;
         var _loc13_:TExchangeType = null;
         var _loc14_:TRateData = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FChipVect = new Vector.<TChip>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc12_ = new TChip(_loc6_[_loc2_].index);
            _loc12_.GetType = _loc6_[_loc2_].getType;
            _loc12_.Need = _loc6_[_loc2_].need;
            _loc12_.Name = _loc6_[_loc2_].name;
            this.FChipVect[_loc2_] = _loc12_;
            _loc2_++;
         }
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FBuyBoxVect = new Vector.<TBuyBox>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new TBuyBox(_loc6_[_loc2_].index);
            _loc9_.GetType = _loc6_[_loc2_].getType;
            _loc9_.Need = _loc6_[_loc2_].need;
            _loc9_.Chip = this.GetChipByUniqueIndex(_loc6_[_loc2_].chipIndex);
            _loc5_ = int(_loc6_[_loc2_].award.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_.Awards.push(_loc6_[_loc2_].award[_loc4_]);
               _loc4_++;
            }
            _loc5_ = int(_loc6_[_loc2_].rateData.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc14_ = new TRateData();
               _loc14_.Rate = _loc6_[_loc2_].rateData[_loc4_].rate;
               _loc14_.Amount = _loc6_[_loc2_].rateData[_loc4_].amount;
               _loc9_.RateData.push(_loc14_);
               _loc4_++;
            }
            this.FBuyBoxVect[_loc2_] = _loc9_;
            _loc2_++;
         }
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FFreeDrawVect = new Vector.<TFreeDraw>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new TFreeDraw(_loc6_[_loc2_].index);
            _loc10_.GetType = _loc6_[_loc2_].getType;
            _loc10_.Limit = _loc6_[_loc2_].limit;
            _loc10_.Amount = _loc6_[_loc2_].amount;
            _loc7_ = _loc6_[_loc2_].rateData;
            _loc5_ = int(_loc7_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc10_.Chips.push(this.GetChipByUniqueIndex(_loc7_[_loc4_].chipIndex));
               _loc4_++;
            }
            this.FFreeDrawVect[_loc2_] = _loc10_;
            _loc2_++;
         }
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FExchangeVect = new Vector.<TExchange>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = new TExchange(_loc6_[_loc2_].index);
            _loc11_.GetType = _loc6_[_loc2_].getType;
            _loc11_.Limit = _loc6_[_loc2_].limit;
            _loc11_.KeysChip.push(this.GetChipByUniqueIndex(uint(_loc6_[_loc2_].keys[0].chipIndex)));
            _loc11_.KeysAmount.push(_loc6_[_loc2_].keys[0].amount);
            _loc5_ = int(_loc6_[_loc2_].award.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc11_.Awards.push(_loc6_[_loc2_].award[_loc4_]);
               _loc4_++;
            }
            _loc11_.Type = _loc6_[_loc2_].type;
            this.FExchangeVect[_loc2_] = _loc11_;
            _loc2_++;
         }
         this.FPage1Desc = TUtilityString.FetchUTF(param1);
         this.FPage2Desc = TUtilityString.FetchUTF(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FExchangeTypeVect = new Vector.<TExchangeType>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc13_ = new TExchangeType();
            _loc13_.Type = _loc6_[_loc2_].type;
            _loc13_.Name = _loc6_[_loc2_].name;
            this.FExchangeTypeVect[_loc2_] = _loc13_;
            _loc2_++;
         }
      }
      
      public function get BuyBoxVect() : Vector.<TBuyBox>
      {
         return this.FBuyBoxVect;
      }
      
      public function get FreeDrawVect() : Vector.<TFreeDraw>
      {
         return this.FFreeDrawVect;
      }
      
      public function get ChipVect() : Vector.<TChip>
      {
         return this.FChipVect;
      }
      
      public function get ExchangeVect() : Vector.<TExchange>
      {
         return this.FExchangeVect;
      }
      
      public function get Page1Desc() : String
      {
         return this.FPage1Desc;
      }
      
      public function get Page2Desc() : String
      {
         return this.FPage2Desc;
      }
      
      public function get ExchangeTypeVect() : Vector.<TExchangeType>
      {
         return this.FExchangeTypeVect;
      }
      
      public function GetChipByUniqueIndex(param1:uint) : TChip
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TChip = null;
         _loc3_ = int(this.FChipVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FChipVect[_loc2_];
            if(_loc4_.Index == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

