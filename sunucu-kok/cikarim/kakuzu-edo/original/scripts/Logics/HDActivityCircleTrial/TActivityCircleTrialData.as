package Logics.HDActivityCircleTrial
{
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityCircleTrialData extends TActivityOSBase
   {
      
      protected var FBlockList:Vector.<TBlockInfo>;
      
      protected var FExtractInventories:Vector.<TInventories>;
      
      protected var FFixedAwardVec:Vector.<TFixedAward>;
      
      protected var FHDDataList:Vector.<TCircleTrialAwardVo>;
      
      protected var FHDHeroGiftDataList:Vector.<TCircleTrialAwardVo>;
      
      protected var FPlayerTotalScore:int;
      
      protected var FExtractCostScore:int;
      
      protected var FExtractCostGold:int;
      
      protected var FExtractScoreIndex:int;
      
      protected var FExtractOnKeyIndex:int;
      
      protected var FExtractGoldIndex:int;
      
      protected var FPromptFontArr:Array;
      
      protected var FCurrentDebrisNum:int;
      
      protected var FImageDebris:int;
      
      public function TActivityCircleTrialData()
      {
         super();
         this.FBlockList = new Vector.<TBlockInfo>();
         this.FExtractInventories = new Vector.<TInventories>();
         this.FHDDataList = new Vector.<TCircleTrialAwardVo>();
         this.FHDHeroGiftDataList = new Vector.<TCircleTrialAwardVo>();
         this.FFixedAwardVec = new Vector.<TFixedAward>();
      }
      
      public function get BlockList() : Vector.<TBlockInfo>
      {
         return this.FBlockList;
      }
      
      public function set BlockList(param1:Vector.<TBlockInfo>) : void
      {
         this.FBlockList = param1;
      }
      
      public function get ExtractInventories() : Vector.<TInventories>
      {
         return this.FExtractInventories;
      }
      
      public function set ExtractInventories(param1:Vector.<TInventories>) : void
      {
         this.FExtractInventories = param1;
      }
      
      public function get HDDataList() : Vector.<TCircleTrialAwardVo>
      {
         return this.FHDDataList;
      }
      
      public function set HDDataList(param1:Vector.<TCircleTrialAwardVo>) : void
      {
         this.FHDDataList = param1;
      }
      
      public function get HDHeroGiftDataList() : Vector.<TCircleTrialAwardVo>
      {
         return this.FHDHeroGiftDataList;
      }
      
      public function set HDHeroGiftDataList(param1:Vector.<TCircleTrialAwardVo>) : void
      {
         this.FHDHeroGiftDataList = param1;
      }
      
      public function get PlayerTotalScore() : int
      {
         return this.FPlayerTotalScore;
      }
      
      public function set PlayerTotalScore(param1:int) : void
      {
         this.FPlayerTotalScore = param1;
      }
      
      public function get ExtractCostScore() : int
      {
         return this.FExtractCostScore;
      }
      
      public function set ExtractCostScore(param1:int) : void
      {
         this.FExtractCostScore = param1;
      }
      
      public function get ExtractCostGold() : int
      {
         return this.FExtractCostGold;
      }
      
      public function set ExtractCostGold(param1:int) : void
      {
         this.FExtractCostGold = param1;
      }
      
      public function get ExtractScoreIndex() : int
      {
         return this.FExtractScoreIndex;
      }
      
      public function set ExtractScoreIndex(param1:int) : void
      {
         this.FExtractScoreIndex = param1;
      }
      
      public function get ExtractOnKeyIndex() : int
      {
         return this.FExtractOnKeyIndex;
      }
      
      public function set ExtractOnKeyIndex(param1:int) : void
      {
         this.FExtractOnKeyIndex = param1;
      }
      
      public function get ExtractGoldIndex() : int
      {
         return this.FExtractGoldIndex;
      }
      
      public function set CurrentDebrisNum(param1:int) : void
      {
         this.FCurrentDebrisNum = param1;
      }
      
      public function get CurrentDebrisNum() : int
      {
         return this.FCurrentDebrisNum;
      }
      
      public function set ImageDebris(param1:int) : void
      {
         this.FImageDebris = param1;
      }
      
      public function get ImageDebris() : int
      {
         return this.FImageDebris;
      }
      
      public function set ExtractGoldIndex(param1:int) : void
      {
         this.FExtractGoldIndex = param1;
      }
      
      public function get FixedAwardVec() : Vector.<TFixedAward>
      {
         return this.FFixedAwardVec;
      }
      
      public function set FixedAwardVec(param1:Vector.<TFixedAward>) : void
      {
         this.FFixedAwardVec = param1;
      }
      
      public function get PromptFontArr() : Array
      {
         return this.FPromptFontArr;
      }
      
      public function set PromptFontArr(param1:Array) : void
      {
         this.FPromptFontArr = param1;
      }
   }
}

