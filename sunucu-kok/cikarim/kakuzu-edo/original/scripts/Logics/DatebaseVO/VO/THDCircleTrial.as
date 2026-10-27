package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDCircleTrial extends THDActivityBase
   {
      
      protected var FConditionIndexVec:Vector.<int>;
      
      protected var FConditionValueVec:Vector.<int>;
      
      protected var FConditionPromptVec:Vector.<String>;
      
      protected var FConditionScoreVec:Vector.<int>;
      
      protected var FScoreExtrecIndex:int;
      
      protected var FScore:int;
      
      protected var FGoldExtractIndex:int;
      
      protected var FGold:int;
      
      protected var FOneKeyIndex:int;
      
      protected var FScoreIndex:int;
      
      protected var FShowAwardArr:Array;
      
      protected var FTaskIndexVec:Vector.<int>;
      
      protected var FTaskAwardVec:Vector.<int>;
      
      protected var FTaskValueVec:Vector.<int>;
      
      protected var FTaskPromptVec:Vector.<String>;
      
      protected var FGiftIndexVec:Vector.<int>;
      
      protected var FGiftAwardVec:Vector.<int>;
      
      protected var FGiftHeroIdVec:Vector.<int>;
      
      protected var FGiftHeroNameVec:Vector.<String>;
      
      protected var FEmployCouponNameVec:Vector.<String>;
      
      protected var FPromptFontArr:Array;
      
      protected var FChipIndex:int;
      
      public function THDCircleTrial()
      {
         super();
         this.FConditionIndexVec = new Vector.<int>();
         this.FConditionPromptVec = new Vector.<String>();
         this.FConditionScoreVec = new Vector.<int>();
         this.FConditionValueVec = new Vector.<int>();
         this.FTaskIndexVec = new Vector.<int>();
         this.FTaskAwardVec = new Vector.<int>();
         this.FTaskValueVec = new Vector.<int>();
         this.FTaskPromptVec = new Vector.<String>();
         this.FGiftIndexVec = new Vector.<int>();
         this.FGiftAwardVec = new Vector.<int>();
         this.FGiftHeroIdVec = new Vector.<int>();
         this.FGiftHeroNameVec = new Vector.<String>();
         this.FEmployCouponNameVec = new Vector.<String>();
         this.FPromptFontArr = [];
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
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FConditionIndexVec.push(_loc6_.index);
            this.FConditionPromptVec.push(_loc6_.prompt);
            this.FConditionScoreVec.push(_loc6_.score);
            this.FConditionValueVec.push(_loc6_.value);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FScoreExtrecIndex = _loc6_.index;
         this.FScore = _loc6_.score;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FGoldExtractIndex = _loc6_.index;
         this.FGold = _loc6_.cost;
         this.FOneKeyIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FShowAwardArr = _loc4_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTaskAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FTaskIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FTaskValueVec[_loc2_] = _loc4_[_loc2_].value;
            this.FTaskPromptVec[_loc2_] = _loc4_[_loc2_].condition;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FGiftAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FGiftHeroIdVec[_loc2_] = _loc4_[_loc2_].hero;
            this.FGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FGiftHeroNameVec[_loc2_] = _loc4_[_loc2_].name;
            this.FEmployCouponNameVec[_loc2_] = _loc4_[_loc2_].condition;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FPromptFontArr.push(_loc6_.condition1,_loc6_.condition2);
         this.FChipIndex = param1.readUnsignedInt();
      }
      
      public function get ConditionIndexVec() : Vector.<int>
      {
         return this.FConditionIndexVec;
      }
      
      public function get ConditionPromptVec() : Vector.<String>
      {
         return this.FConditionPromptVec;
      }
      
      public function get ConditionValueVec() : Vector.<int>
      {
         return this.FConditionValueVec;
      }
      
      public function get ConditionScoreVec() : Vector.<int>
      {
         return this.FConditionScoreVec;
      }
      
      public function get ScoreExtrecIndex() : int
      {
         return this.FScoreExtrecIndex;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function get GoldExtractIndex() : int
      {
         return this.FGoldExtractIndex;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function get OneKeyIndex() : int
      {
         return this.FOneKeyIndex;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get ShowAwardArr() : Array
      {
         return this.FShowAwardArr;
      }
      
      public function get TaskIndexVec() : Vector.<int>
      {
         return this.FTaskIndexVec;
      }
      
      public function get TaskAwardVec() : Vector.<int>
      {
         return this.FTaskAwardVec;
      }
      
      public function get TaskValueVec() : Vector.<int>
      {
         return this.FTaskValueVec;
      }
      
      public function get GiftIndexVec() : Vector.<int>
      {
         return this.FGiftIndexVec;
      }
      
      public function get GiftAwardVec() : Vector.<int>
      {
         return this.FGiftAwardVec;
      }
      
      public function get GiftHeroNameVec() : Vector.<String>
      {
         return this.FGiftHeroNameVec;
      }
      
      public function get GiftHeroIdVec() : Vector.<int>
      {
         return this.FGiftHeroIdVec;
      }
      
      public function get PromptFontArr() : Array
      {
         return this.FPromptFontArr;
      }
      
      public function get EmployCouponNameVec() : Vector.<String>
      {
         return this.FEmployCouponNameVec;
      }
      
      public function get TaskPromptVec() : Vector.<String>
      {
         return this.FTaskPromptVec;
      }
      
      public function get ChipIndex() : int
      {
         return this.FChipIndex;
      }
   }
}

