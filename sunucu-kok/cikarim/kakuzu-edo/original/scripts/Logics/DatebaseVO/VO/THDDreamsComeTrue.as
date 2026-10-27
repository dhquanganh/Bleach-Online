package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDreamsComeTrue extends THDActivityBase
   {
      
      private var FRankAwardsVec:Vector.<int>;
      
      private var FRankPromptVec:Vector.<String>;
      
      private var FLowExtractIndex:int;
      
      private var FLowGoldCost:int;
      
      private var FLowAwardPosVec:Vector.<int>;
      
      private var FLowAwardTipsNameVec:Vector.<String>;
      
      private var FLowAwardIndexVec:Vector.<int>;
      
      private var FLowScore:int;
      
      private var FHighExtractIndex:int;
      
      private var FHighGoldCost:int;
      
      private var FHighAwardPosVec:Vector.<int>;
      
      private var FHighAwardTipsNameVec:Vector.<String>;
      
      private var FHighAwardIndexVec:Vector.<int>;
      
      private var FHighScore:int;
      
      private var FLowFreeTimeIndex:int;
      
      private var FHighFreeTimeIndex:int;
      
      private var FLowFreeTime:int;
      
      private var FHighFreeTime:int;
      
      private var FExchangeIndex:int;
      
      private var FScoreIndex:int;
      
      private var FAwardIndexVec:Vector.<int>;
      
      private var FAwardIdVec:Vector.<int>;
      
      private var FAwardTypeVec:Vector.<int>;
      
      private var FAwardLimitVec:Vector.<int>;
      
      private var FAwardCostFontValueVec:Vector.<Array>;
      
      private var FAwardShowFontIndexVec:Vector.<Array>;
      
      private var FAwardTypeDescVec:Vector.<String>;
      
      private var FTenPrompt:String;
      
      private var FOneprompt:String;
      
      private var FRankNum:int;
      
      private var FResourcePosArr:Array;
      
      private var FHeroIndexVec:Vector.<int>;
      
      private var FFightReportUrlVec:Vector.<String>;
      
      public function THDDreamsComeTrue()
      {
         super();
         this.FRankAwardsVec = new Vector.<int>();
         this.FRankPromptVec = new Vector.<String>();
         this.FLowAwardPosVec = new Vector.<int>();
         this.FLowAwardIndexVec = new Vector.<int>();
         this.FLowAwardTipsNameVec = new Vector.<String>();
         this.FHighAwardIndexVec = new Vector.<int>();
         this.FHighAwardTipsNameVec = new Vector.<String>();
         this.FHighAwardPosVec = new Vector.<int>();
         this.FAwardIndexVec = new Vector.<int>();
         this.FAwardIdVec = new Vector.<int>();
         this.FAwardTypeVec = new Vector.<int>();
         this.FAwardLimitVec = new Vector.<int>();
         this.FAwardCostFontValueVec = new Vector.<Array>();
         this.FAwardShowFontIndexVec = new Vector.<Array>();
         this.FAwardTypeDescVec = new Vector.<String>();
         this.FHeroIndexVec = new Vector.<int>();
         this.FFightReportUrlVec = new Vector.<String>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRankAwardsVec[_loc2_] = _loc4_[_loc2_].value;
            this.FRankPromptVec[_loc2_] = _loc4_[_loc2_].prompt;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowExtractIndex = _loc6_.index;
         this.FLowGoldCost = _loc6_.goldCost;
         this.FLowScore = _loc6_.getScore;
         _loc4_ = _loc6_.award;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FLowAwardIndexVec[_loc2_] = _loc4_[_loc2_].awardIndex;
            this.FLowAwardPosVec[_loc2_] = _loc4_[_loc2_].pos;
            this.FLowAwardTipsNameVec[_loc2_] = _loc4_[_loc2_].tipsName;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FHighExtractIndex = _loc6_.index;
         this.FHighGoldCost = _loc6_.goldCost;
         this.FHighScore = _loc6_.getScore;
         _loc4_ = _loc6_.award;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FHighAwardIndexVec[_loc2_] = _loc4_[_loc2_].awardIndex;
            this.FHighAwardPosVec[_loc2_] = _loc4_[_loc2_].pos;
            this.FHighAwardTipsNameVec[_loc2_] = _loc4_[_loc2_].tipsName;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowFreeTimeIndex = _loc6_.lowIndex;
         this.FHighFreeTimeIndex = _loc6_.highIndex;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowFreeTime = _loc6_.lowFreeTime;
         this.FHighFreeTime = _loc6_.highFreeTime;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FAwardIdVec[_loc2_] = _loc4_[_loc2_].showId;
            this.FAwardTypeVec[_loc2_] = _loc4_[_loc2_].type;
            this.FAwardLimitVec[_loc2_] = _loc4_[_loc2_].limit;
            _loc7_ = _loc4_[_loc2_].costFont;
            _loc8_ = [];
            _loc9_ = [];
            _loc10_ = 0;
            while(_loc10_ < _loc7_.length)
            {
               _loc8_[_loc10_] = _loc7_[_loc10_].needCount;
               _loc9_[_loc10_] = _loc7_[_loc10_].fontIndex;
               _loc10_++;
            }
            this.FAwardCostFontValueVec[_loc2_] = _loc8_;
            this.FAwardShowFontIndexVec[_loc2_] = _loc9_;
            _loc2_++;
         }
         this.FExchangeIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardTypeDescVec[_loc2_] = _loc4_[_loc2_].desc;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FTenPrompt = _loc6_.tenExtract;
         this.FOneprompt = _loc6_.oneExtract;
         this.FRankNum = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FResourcePosArr = _loc4_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FHeroIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FFightReportUrlVec[_loc2_] = _loc4_[_loc2_].fightReportAddr;
            _loc2_++;
         }
      }
      
      public function get RankAwardsVec() : Vector.<int>
      {
         return this.FRankAwardsVec;
      }
      
      public function get RankPromptVec() : Vector.<String>
      {
         return this.FRankPromptVec;
      }
      
      public function get LowExtractIndex() : int
      {
         return this.FLowExtractIndex;
      }
      
      public function get LowGoldCost() : int
      {
         return this.FLowGoldCost;
      }
      
      public function get LowAwardPosVec() : Vector.<int>
      {
         return this.FLowAwardPosVec;
      }
      
      public function get LowAwardIndexVec() : Vector.<int>
      {
         return this.FLowAwardIndexVec;
      }
      
      public function get LowAwardTipsNameVec() : Vector.<String>
      {
         return this.FLowAwardTipsNameVec;
      }
      
      public function get HighExtractIndex() : int
      {
         return this.FHighExtractIndex;
      }
      
      public function get HighGoldCost() : int
      {
         return this.FHighGoldCost;
      }
      
      public function get HighAwardPosVec() : Vector.<int>
      {
         return this.FHighAwardPosVec;
      }
      
      public function get HighAwardIndexVec() : Vector.<int>
      {
         return this.FHighAwardIndexVec;
      }
      
      public function get HighAwardTipsNameVec() : Vector.<String>
      {
         return this.FHighAwardTipsNameVec;
      }
      
      public function get LowFreeTimeIndex() : int
      {
         return this.FLowFreeTimeIndex;
      }
      
      public function get HighFreeTimeIndex() : int
      {
         return this.FHighFreeTimeIndex;
      }
      
      public function get LowFreeTime() : int
      {
         return this.FLowFreeTime;
      }
      
      public function get HighFreeTime() : int
      {
         return this.FHighFreeTime;
      }
      
      public function get ExchangeIndex() : int
      {
         return this.FExchangeIndex;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get LowScore() : int
      {
         return this.FLowScore;
      }
      
      public function get HighScore() : int
      {
         return this.FHighScore;
      }
      
      public function get AwardIndexVec() : Vector.<int>
      {
         return this.FAwardIndexVec;
      }
      
      public function get AwardIdVec() : Vector.<int>
      {
         return this.FAwardIdVec;
      }
      
      public function get AwardTypeVec() : Vector.<int>
      {
         return this.FAwardTypeVec;
      }
      
      public function get AwardLimitVec() : Vector.<int>
      {
         return this.FAwardLimitVec;
      }
      
      public function get AwardCostFontValueVec() : Vector.<Array>
      {
         return this.FAwardCostFontValueVec;
      }
      
      public function get AwardShowFontIndexVec() : Vector.<Array>
      {
         return this.FAwardShowFontIndexVec;
      }
      
      public function get TenPrompt() : String
      {
         return this.FTenPrompt;
      }
      
      public function get Oneprompt() : String
      {
         return this.FOneprompt;
      }
      
      public function get AwardTypeDescVec() : Vector.<String>
      {
         return this.FAwardTypeDescVec;
      }
      
      public function get ResourcePosArr() : Array
      {
         return this.FResourcePosArr;
      }
      
      public function get RankNum() : int
      {
         return this.FRankNum;
      }
      
      public function get FightReportUrlVec() : Vector.<String>
      {
         return this.FFightReportUrlVec;
      }
      
      public function get HeroIndexVec() : Vector.<int>
      {
         return this.FHeroIndexVec;
      }
   }
}

