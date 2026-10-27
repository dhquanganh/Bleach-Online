package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDCircleHero extends THDActivityBase
   {
      
      private var FTaskInfoIndexVec:Vector.<int>;
      
      private var FTaskInfoTypeVec:Vector.<int>;
      
      private var FTaskInfoValueVec:Vector.<int>;
      
      private var FTaskDescribeTypeVec:Vector.<int>;
      
      private var FTaskDescribeInfoVec:Vector.<String>;
      
      private var FTaskDescribeModuleIdVec:Vector.<int>;
      
      private var FTaskList:Vector.<int>;
      
      private var FCurTaskIndex:int;
      
      private var FRefreshTaskIndex:int;
      
      private var FRefreshTaskCost:int;
      
      private var FRechargeGiftIndex:int;
      
      private var FRechargeIndex:int;
      
      private var FRechargeCondition:Vector.<int>;
      
      private var FRechargeAwardVec:Vector.<int>;
      
      private var FShowArr:Vector.<int>;
      
      private var FExtractOneIndex:int;
      
      private var FExtractCost:int;
      
      private var FExtractTenIndex:int;
      
      private var FExtractFiftyIndex:int;
      
      private var FChipItemObj:Object;
      
      private var FDiscount:int;
      
      private var FExtractGiftIndexVec:Vector.<int>;
      
      private var FExtractGiftConVec:Vector.<int>;
      
      private var FExtractAwardVec:Vector.<int>;
      
      private var FExtrctDebrisValueVect:Vector.<int>;
      
      private var FExchangeHeroIndex:int;
      
      private var FNeedDebrisAmount:int;
      
      private var FHeroType:int;
      
      private var FHeroId:int;
      
      private var FAddChipIndex:int;
      
      private var FPlayerChipIndex:int;
      
      private var FChipGiftIndexVec:Vector.<int>;
      
      private var FChipGiftConVec:Vector.<int>;
      
      private var FChipGiftAwardVec:Vector.<int>;
      
      private var FFreeTimeIndex:int;
      
      private var FTotalExtractTimes:int;
      
      private var FRoundsIndex:int;
      
      private var FLimitPrompt:String;
      
      private var FSpeedPrompt:String;
      
      private var FExchangePrompt:String;
      
      private var FAddChipPrompt:String;
      
      private var FPopUpPrompt:String;
      
      private var FDebrisTipsPrompt:String;
      
      private var FChipMoney:int;
      
      public function THDCircleHero()
      {
         super();
         this.FTaskInfoIndexVec = new Vector.<int>();
         this.FTaskInfoTypeVec = new Vector.<int>();
         this.FTaskInfoValueVec = new Vector.<int>();
         this.FTaskDescribeTypeVec = new Vector.<int>();
         this.FTaskDescribeInfoVec = new Vector.<String>();
         this.FTaskDescribeModuleIdVec = new Vector.<int>();
         this.FExtractGiftIndexVec = new Vector.<int>();
         this.FExtractGiftConVec = new Vector.<int>();
         this.FExtractAwardVec = new Vector.<int>();
         this.FExtrctDebrisValueVect = new Vector.<int>();
         this.FChipGiftIndexVec = new Vector.<int>();
         this.FChipGiftConVec = new Vector.<int>();
         this.FChipGiftAwardVec = new Vector.<int>();
         this.FShowArr = new Vector.<int>();
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
            this.FTaskInfoIndexVec.push(_loc6_.index);
            this.FTaskInfoTypeVec.push(_loc6_.type);
            this.FTaskInfoValueVec.push(_loc6_.value);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FCurTaskIndex = _loc6_.index;
         this.FTaskList = Vector.<int>(_loc6_.tasks);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRefreshTaskIndex = _loc6_.index;
         this.FRefreshTaskCost = _loc6_.cost;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRechargeGiftIndex = _loc6_.index;
         this.FRechargeIndex = _loc6_.rechargeIndex;
         this.FRechargeCondition = Vector.<int>(_loc6_.condition);
         this.FRechargeAwardVec = Vector.<int>(_loc6_.award);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FExtractOneIndex = _loc6_.index;
         this.FExtractCost = _loc6_.cost;
         _loc3_ = int(_loc6_.award.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowArr[_loc2_] = (_loc6_.award as Array)[_loc2_]["awardId"];
            _loc2_++;
         }
         this.FExtractTenIndex = param1.readUnsignedInt();
         this.FExtractFiftyIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTaskDescribeTypeVec[_loc2_] = _loc4_[_loc2_].type;
            this.FTaskDescribeInfoVec[_loc2_] = _loc4_[_loc2_].info;
            this.FTaskDescribeModuleIdVec[_loc2_] = _loc4_[_loc2_].moduleId;
            _loc2_++;
         }
         this.FDiscount = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FExtractGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FExtractGiftConVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FExtractAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FExtrctDebrisValueVect[_loc2_] = _loc4_[_loc2_].chip;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FExchangeHeroIndex = _loc6_.index;
         this.FNeedDebrisAmount = _loc6_.condition;
         this.FHeroType = _loc6_.awardType;
         this.FHeroId = _loc6_.id;
         this.FAddChipIndex = param1.readUnsignedInt();
         this.FPlayerChipIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FChipGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FChipGiftConVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FChipGiftAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         this.FFreeTimeIndex = param1.readUnsignedInt();
         this.FTotalExtractTimes = param1.readUnsignedInt();
         this.FRoundsIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLimitPrompt = _loc6_.task;
         this.FSpeedPrompt = _loc6_.prompt1;
         this.FExchangePrompt = _loc6_.prompt2;
         this.FAddChipPrompt = _loc6_.prompt3;
         this.FPopUpPrompt = _loc6_.prompt4;
         this.FDebrisTipsPrompt = _loc6_.prompt5;
         this.FChipMoney = param1.readUnsignedInt();
      }
      
      public function get TaskInfoIndexVec() : Vector.<int>
      {
         return this.FTaskInfoIndexVec;
      }
      
      public function get TaskInfoTypeVec() : Vector.<int>
      {
         return this.FTaskInfoTypeVec;
      }
      
      public function get TaskInfoValueVec() : Vector.<int>
      {
         return this.FTaskInfoValueVec;
      }
      
      public function get TaskDescribeTypeVec() : Vector.<int>
      {
         return this.FTaskDescribeTypeVec;
      }
      
      public function get TaskDescribeInfoVec() : Vector.<String>
      {
         return this.FTaskDescribeInfoVec;
      }
      
      public function get TaskDescribeModuleIdVec() : Vector.<int>
      {
         return this.FTaskDescribeModuleIdVec;
      }
      
      public function get TaskList() : Vector.<int>
      {
         return this.FTaskList;
      }
      
      public function get RechargeCondition() : Vector.<int>
      {
         return this.FRechargeCondition;
      }
      
      public function get RechargeAwardVec() : Vector.<int>
      {
         return this.FRechargeAwardVec;
      }
      
      public function get CurTaskIndex() : int
      {
         return this.FCurTaskIndex;
      }
      
      public function get RefreshTaskIndex() : int
      {
         return this.FRefreshTaskIndex;
      }
      
      public function get RefreshTaskCost() : int
      {
         return this.FRefreshTaskCost;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get RechargeGiftIndex() : int
      {
         return this.FRechargeGiftIndex;
      }
      
      public function get ShowArr() : Vector.<int>
      {
         return this.FShowArr;
      }
      
      public function get ExtractOneIndex() : int
      {
         return this.FExtractOneIndex;
      }
      
      public function get ExtractCost() : int
      {
         return this.FExtractCost;
      }
      
      public function get ExtractTenIndex() : int
      {
         return this.FExtractTenIndex;
      }
      
      public function get ExtractFiftyIndex() : int
      {
         return this.FExtractFiftyIndex;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get ExtractGiftIndexVec() : Vector.<int>
      {
         return this.FExtractGiftIndexVec;
      }
      
      public function get ExtractGiftConVec() : Vector.<int>
      {
         return this.FExtractGiftConVec;
      }
      
      public function get ExtractAwardVec() : Vector.<int>
      {
         return this.FExtractAwardVec;
      }
      
      public function get ExtrctDebrisValueVect() : Vector.<int>
      {
         return this.FExtrctDebrisValueVect;
      }
      
      public function get ChipGiftIndexVec() : Vector.<int>
      {
         return this.FChipGiftIndexVec;
      }
      
      public function get ChipGiftConVec() : Vector.<int>
      {
         return this.FChipGiftConVec;
      }
      
      public function get ChipGiftAwardVec() : Vector.<int>
      {
         return this.FChipGiftAwardVec;
      }
      
      public function get ExchangeHeroIndex() : int
      {
         return this.FExchangeHeroIndex;
      }
      
      public function get NeedDebrisAmount() : int
      {
         return this.FNeedDebrisAmount;
      }
      
      public function get HeroType() : int
      {
         return this.FHeroType;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function get AddChipIndex() : int
      {
         return this.FAddChipIndex;
      }
      
      public function get PlayerChipIndex() : int
      {
         return this.FPlayerChipIndex;
      }
      
      public function get FreeTimeIndex() : int
      {
         return this.FFreeTimeIndex;
      }
      
      public function get TotalExtractTimes() : int
      {
         return this.FTotalExtractTimes;
      }
      
      public function get RoundsIndex() : int
      {
         return this.FRoundsIndex;
      }
      
      public function get LimitPrompt() : String
      {
         return this.FLimitPrompt;
      }
      
      public function get SpeedPrompt() : String
      {
         return this.FSpeedPrompt;
      }
      
      public function get ExchangePrompt() : String
      {
         return this.FExchangePrompt;
      }
      
      public function get AddChipPrompt() : String
      {
         return this.FAddChipPrompt;
      }
      
      public function get PopUpPrompt() : String
      {
         return this.FPopUpPrompt;
      }
      
      public function get DebrisTipsPrompt() : String
      {
         return this.FDebrisTipsPrompt;
      }
      
      public function get ChipMoney() : int
      {
         return this.FChipMoney;
      }
      
      public function get ChipItemObj() : Object
      {
         return this.FChipItemObj;
      }
   }
}

