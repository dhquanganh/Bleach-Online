package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.Inventories.TInventories;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenPay extends THDActivityBase
   {
      
      protected var FPayIndex:uint;
      
      protected var FGetPayIndex:uint;
      
      protected var FPayAwards:Vector.<uint>;
      
      protected var FFreeAwards:Vector.<TInventories>;
      
      protected var FFreeAwardsPos:Vector.<uint>;
      
      protected var FLimitBuyAwards:Vector.<uint>;
      
      protected var FLimitBuyNowPrice:Vector.<uint>;
      
      protected var FLimitBuyOldPrice:Vector.<uint>;
      
      protected var FLimitBuyBtnIndex:uint;
      
      protected var FAllServerBuyIndex:Vector.<uint>;
      
      protected var FAllServerBuyAwards:Vector.<uint>;
      
      protected var FAllServerBuyConds:Vector.<uint>;
      
      protected var FPackageIndex:Vector.<uint>;
      
      protected var FPackageReceives:Vector.<uint>;
      
      protected var FPackageCond:Vector.<uint>;
      
      protected var FPackageCost:Vector.<uint>;
      
      protected var FLimitBuyIndex:uint;
      
      protected var FServerLimitIndex:uint;
      
      protected var FTempArr:Array;
      
      public function THDHalloweenPay()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:TFixedAward = null;
         var _loc10_:Vector.<TFixedAward> = null;
         var _loc11_:TInventories = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FPayIndex = _loc7_.index;
         _loc2_ = uint(_loc7_.award.length);
         this.FPayAwards = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FPayAwards[_loc3_] = _loc7_.award[_loc3_];
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FGetPayIndex = 1;
         _loc2_ = _loc6_.length;
         this.FTempArr = _loc6_;
         this.FFreeAwardsPos = new Vector.<uint>(_loc2_);
         this.FFreeAwards = new Vector.<TInventories>(_loc2_ / 6);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FLimitBuyBtnIndex = _loc7_.index;
         _loc2_ = uint(_loc7_.buy.length);
         this.FLimitBuyAwards = new Vector.<uint>(_loc2_);
         this.FLimitBuyNowPrice = new Vector.<uint>(_loc2_);
         this.FLimitBuyOldPrice = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FLimitBuyAwards[_loc3_] = _loc7_.buy[_loc3_].award;
            this.FLimitBuyNowPrice[_loc3_] = _loc7_.buy[_loc3_].cost;
            this.FLimitBuyOldPrice[_loc3_] = _loc7_.buy[_loc3_].oldPrice;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FAllServerBuyIndex = new Vector.<uint>(_loc2_);
         this.FAllServerBuyAwards = new Vector.<uint>(_loc2_);
         this.FAllServerBuyConds = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FAllServerBuyIndex[_loc3_] = _loc6_[_loc3_].index;
            this.FAllServerBuyAwards[_loc3_] = _loc6_[_loc3_].award;
            this.FAllServerBuyConds[_loc3_] = _loc6_[_loc3_].condition;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FPackageIndex = new Vector.<uint>(_loc2_);
         this.FPackageReceives = new Vector.<uint>(_loc2_);
         this.FPackageCost = new Vector.<uint>(_loc2_);
         this.FPackageCond = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FPackageIndex[_loc3_] = _loc6_[_loc3_].index;
            this.FPackageReceives[_loc3_] = _loc6_[_loc3_].award;
            this.FPackageCost[_loc3_] = _loc6_[_loc3_].cost;
            this.FPackageCond[_loc3_] = _loc6_[_loc3_].condition;
            _loc3_++;
         }
         this.FLimitBuyIndex = param1.readUnsignedInt();
         this.FServerLimitIndex = param1.readUnsignedInt();
      }
      
      public function get PayAwards() : Vector.<uint>
      {
         return this.FPayAwards;
      }
      
      public function get FreeAwards() : Vector.<TInventories>
      {
         return this.FFreeAwards;
      }
      
      public function set FreeAwards(param1:Vector.<TInventories>) : void
      {
         this.FFreeAwards = param1;
      }
      
      public function get LimitBuyAwards() : Vector.<uint>
      {
         return this.FLimitBuyAwards;
      }
      
      public function get LimitBuyNowPrice() : Vector.<uint>
      {
         return this.FLimitBuyNowPrice;
      }
      
      public function get LimitBuyOldPrice() : Vector.<uint>
      {
         return this.FLimitBuyOldPrice;
      }
      
      public function get AllServerBuyIndex() : Vector.<uint>
      {
         return this.FAllServerBuyIndex;
      }
      
      public function get AllServerBuyAwards() : Vector.<uint>
      {
         return this.FAllServerBuyAwards;
      }
      
      public function get AllServerBuyConds() : Vector.<uint>
      {
         return this.FAllServerBuyConds;
      }
      
      public function get PackageIndex() : Vector.<uint>
      {
         return this.FPackageIndex;
      }
      
      public function get PackageReceives() : Vector.<uint>
      {
         return this.FPackageReceives;
      }
      
      public function get PackageCond() : Vector.<uint>
      {
         return this.FPackageCond;
      }
      
      public function get PackageCost() : Vector.<uint>
      {
         return this.FPackageCost;
      }
      
      public function get LimitBuyBtnIndex() : uint
      {
         return this.FLimitBuyBtnIndex;
      }
      
      public function get ServerLimitIndex() : uint
      {
         return this.FServerLimitIndex;
      }
      
      public function get PayIndex() : uint
      {
         return this.FPayIndex;
      }
      
      public function get GetPayIndex() : uint
      {
         return this.FGetPayIndex;
      }
      
      public function get LimitBuyIndex() : uint
      {
         return this.FLimitBuyIndex;
      }
      
      public function get FreeAwardsPos() : Vector.<uint>
      {
         return this.FFreeAwardsPos;
      }
      
      public function set FreeAwardsPos(param1:Vector.<uint>) : void
      {
         this.FFreeAwardsPos = param1;
      }
      
      public function get TempArr() : Array
      {
         return this.FTempArr;
      }
   }
}

