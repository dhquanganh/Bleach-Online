package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewHalloweenConsume extends THDActivityBase
   {
      
      private var FBuyAwardObj:Object;
      
      private var FPumpkinIndexVec:Vector.<int>;
      
      private var FPumpkinGoldVec:Vector.<int>;
      
      private var FPumpkinAwardVec:Vector.<int>;
      
      private var FDoubleScoreVec:Array;
      
      private var FCandyAreaIndexVec:Vector.<int>;
      
      private var FCandyAreaGoldVec:Vector.<int>;
      
      private var FCandyAreaAwardVec:Vector.<int>;
      
      private var FCandyAreaNameVec:Vector.<String>;
      
      private var FDiscountPosVec:Vector.<Object>;
      
      private var FDiscountTypeVec:Vector.<Object>;
      
      private var FShopCartDiscountObj:Object;
      
      private var FScoreIndex:int;
      
      private var FBuyShopIndex:int;
      
      private var FRate:int;
      
      private var FPromptMsgObj:Object;
      
      public function THDNewHalloweenConsume()
      {
         super();
         this.FPumpkinIndexVec = new Vector.<int>();
         this.FPumpkinGoldVec = new Vector.<int>();
         this.FPumpkinAwardVec = new Vector.<int>();
         this.FCandyAreaIndexVec = new Vector.<int>();
         this.FCandyAreaGoldVec = new Vector.<int>();
         this.FCandyAreaAwardVec = new Vector.<int>();
         this.FCandyAreaNameVec = new Vector.<String>();
         this.FDiscountPosVec = new Vector.<Object>();
         this.FDiscountTypeVec = new Vector.<Object>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FBuyAwardObj = _loc6_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPumpkinIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FPumpkinGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            this.FPumpkinAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FDoubleScoreVec = _loc4_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCandyAreaIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FCandyAreaGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            this.FCandyAreaAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FCandyAreaNameVec[_loc2_] = _loc4_[_loc2_].name;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDiscountPosVec[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDiscountTypeVec[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FShopCartDiscountObj = _loc6_;
         this.FScoreIndex = param1.readUnsignedInt();
         this.FBuyShopIndex = param1.readUnsignedInt();
         this.FRate = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FPromptMsgObj = _loc6_;
      }
      
      public function get BuyAwardObj() : Object
      {
         return this.FBuyAwardObj;
      }
      
      public function get PumpkinIndexVec() : Vector.<int>
      {
         return this.FPumpkinIndexVec;
      }
      
      public function get PumpkinGoldVec() : Vector.<int>
      {
         return this.FPumpkinGoldVec;
      }
      
      public function get PumpkinAwardVec() : Vector.<int>
      {
         return this.FPumpkinAwardVec;
      }
      
      public function get DoubleScoreVec() : Array
      {
         return this.FDoubleScoreVec;
      }
      
      public function get CandyAreaIndexVec() : Vector.<int>
      {
         return this.FCandyAreaIndexVec;
      }
      
      public function get CandyAreaGoldVec() : Vector.<int>
      {
         return this.FCandyAreaGoldVec;
      }
      
      public function get CandyAreaAwardVec() : Vector.<int>
      {
         return this.FCandyAreaAwardVec;
      }
      
      public function get CandyAreaNameVec() : Vector.<String>
      {
         return this.FCandyAreaNameVec;
      }
      
      public function get DiscountPosVec() : Vector.<Object>
      {
         return this.FDiscountPosVec;
      }
      
      public function get DiscountTypeVec() : Vector.<Object>
      {
         return this.FDiscountTypeVec;
      }
      
      public function get ShopCartDiscountObj() : Object
      {
         return this.FShopCartDiscountObj;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get BuyShopIndex() : int
      {
         return this.FBuyShopIndex;
      }
      
      public function get Rate() : int
      {
         return this.FRate;
      }
      
      public function get PromptMsgObj() : Object
      {
         return this.FPromptMsgObj;
      }
   }
}

