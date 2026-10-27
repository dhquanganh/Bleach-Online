package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChristmasGift extends THDActivityBase
   {
      
      protected var FRechargeAwardIndex:int;
      
      protected var FRechargeAwardGold:int;
      
      protected var FDayAwardIndex:int;
      
      protected var FBuyTimesIndex:int;
      
      protected var FBagBuyIndexVec:Vector.<int>;
      
      protected var FBagGetIndexVec:Vector.<int>;
      
      protected var FRechargeAwardVec:Vector.<int>;
      
      protected var FDayAwardVec:Vector.<int>;
      
      protected var FBagGetAwardVec:Vector.<int>;
      
      protected var FBagGetLimitVec:Vector.<int>;
      
      protected var FBagBuyGoldsVec:Vector.<Vector.<int>>;
      
      protected var FBagBuyAwardsVec:Vector.<Vector.<int>>;
      
      public function THDChristmasGift()
      {
         super();
         this.FBagBuyIndexVec = new Vector.<int>();
         this.FBagGetIndexVec = new Vector.<int>();
         this.FRechargeAwardVec = new Vector.<int>();
         this.FDayAwardVec = new Vector.<int>();
         this.FBagGetAwardVec = new Vector.<int>();
         this.FBagGetLimitVec = new Vector.<int>();
         this.FBagBuyGoldsVec = new Vector.<Vector.<int>>();
         this.FBagBuyAwardsVec = new Vector.<Vector.<int>>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc11_ = Json.decode(_loc10_);
         this.FRechargeAwardIndex = _loc11_.index;
         this.FRechargeAwardGold = _loc11_.gold;
         _loc4_ = _loc11_.award;
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FRechargeAwardVec.push(_loc4_[_loc6_]);
            _loc6_++;
         }
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc11_ = Json.decode(_loc10_);
         this.FDayAwardIndex = _loc11_.index;
         _loc4_ = _loc11_.award;
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FDayAwardVec.push(_loc4_[_loc6_]);
            _loc6_++;
         }
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc7_ = new Array();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FBagBuyIndexVec.push(_loc4_[_loc6_].index);
            _loc7_.length = 0;
            _loc7_ = _loc4_[_loc6_].gold;
            _loc3_ = new Vector.<int>();
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc3_.push(_loc7_[_loc9_]);
               _loc9_++;
            }
            this.FBagBuyGoldsVec.push(_loc3_);
            _loc7_.length = 0;
            _loc7_ = _loc4_[_loc6_].award;
            _loc2_ = new Vector.<int>();
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc2_.push(_loc7_[_loc9_]);
               _loc9_++;
            }
            this.FBagBuyAwardsVec.push(_loc2_);
            _loc6_++;
         }
         this.FBuyTimesIndex = param1.readUnsignedInt();
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FBagGetIndexVec.push(_loc4_[_loc6_].index);
            this.FBagGetAwardVec.push(_loc4_[_loc6_].award);
            this.FBagGetLimitVec.push(_loc4_[_loc6_].limit);
            _loc6_++;
         }
      }
      
      public function get RechargeAwardIndex() : int
      {
         return this.FRechargeAwardIndex;
      }
      
      public function set RechargeAwardIndex(param1:int) : void
      {
         this.FRechargeAwardIndex = param1;
      }
      
      public function get DayAwardIndex() : int
      {
         return this.FDayAwardIndex;
      }
      
      public function set DayAwardIndex(param1:int) : void
      {
         this.FDayAwardIndex = param1;
      }
      
      public function get BuyTimesIndex() : int
      {
         return this.FBuyTimesIndex;
      }
      
      public function set BuyTimesIndex(param1:int) : void
      {
         this.FBuyTimesIndex = param1;
      }
      
      public function get BagBuyIndexVec() : Vector.<int>
      {
         return this.FBagBuyIndexVec;
      }
      
      public function get BagGetIndexVec() : Vector.<int>
      {
         return this.FBagGetIndexVec;
      }
      
      public function get RechargeAwardVec() : Vector.<int>
      {
         return this.FRechargeAwardVec;
      }
      
      public function get DayAwardVec() : Vector.<int>
      {
         return this.FDayAwardVec;
      }
      
      public function get BagGetAwardVec() : Vector.<int>
      {
         return this.FBagGetAwardVec;
      }
      
      public function get BagGetLimitVec() : Vector.<int>
      {
         return this.FBagGetLimitVec;
      }
      
      public function get RechargeAwardGold() : int
      {
         return this.FRechargeAwardGold;
      }
      
      public function set RechargeAwardGold(param1:int) : void
      {
         this.FRechargeAwardGold = param1;
      }
      
      public function get BagBuyAwardsCount() : int
      {
         return this.FBagBuyAwardsVec.length;
      }
      
      public function GetGoldsByType(param1:int) : Vector.<int>
      {
         return this.FBagBuyGoldsVec[param1];
      }
      
      public function GetAwardsByType(param1:int) : Vector.<int>
      {
         return this.FBagBuyAwardsVec[param1];
      }
   }
}

