package Logics.HDActivityHalloween
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityHalloweenTreeData extends TActivityOSBase
   {
      
      protected var FTreesLevel:int;
      
      protected var FResidueWaterTimes:int;
      
      protected var FWaterTimes:int;
      
      protected var FGetAwardNum:int;
      
      protected var FGiveTimes:int;
      
      protected var FRechargeGold:int;
      
      protected var FDataList:Vector.<THalloweenTreeGiftVo>;
      
      protected var FShowInventories:Vector.<TInventories>;
      
      protected var FWaterAwardInventories:Vector.<TInventories>;
      
      protected var FCurrentExp:int;
      
      protected var FCurrentTotalExp:int;
      
      protected var FLevelExpList:Vector.<int>;
      
      protected var FGiftExpList:Vector.<int>;
      
      protected var FTreePosList:Vector.<int>;
      
      protected var FWateIndex:int;
      
      protected var FGetAwardIndex:int;
      
      protected var FCurrentGetAWardId:int;
      
      protected var FCurrrntGetAwardIndex:int;
      
      protected var FGetPromptStr:String;
      
      protected var FGetFreePromptStr:String;
      
      protected var FWaterSpendCost:int;
      
      protected var FWatrePromptStr:String;
      
      public function TActivityHalloweenTreeData()
      {
         super();
         this.FDataList = new Vector.<THalloweenTreeGiftVo>();
         this.FShowInventories = new Vector.<TInventories>();
         this.FWaterAwardInventories = new Vector.<TInventories>();
      }
      
      public function get TreesLevel() : int
      {
         return this.FTreesLevel;
      }
      
      public function set TreesLevel(param1:int) : void
      {
         this.FTreesLevel = param1;
      }
      
      public function get ResidueWaterTimes() : int
      {
         return this.FResidueWaterTimes;
      }
      
      public function set ResidueWaterTimes(param1:int) : void
      {
         this.FResidueWaterTimes = param1;
      }
      
      public function get WaterTimes() : int
      {
         return this.FWaterTimes;
      }
      
      public function set WaterTimes(param1:int) : void
      {
         this.FWaterTimes = param1;
      }
      
      public function get RechargeGold() : int
      {
         return this.FRechargeGold;
      }
      
      public function set RechargeGold(param1:int) : void
      {
         this.FRechargeGold = param1;
      }
      
      public function get DataList() : Vector.<THalloweenTreeGiftVo>
      {
         return this.FDataList;
      }
      
      public function set DataList(param1:Vector.<THalloweenTreeGiftVo>) : void
      {
         this.FDataList = param1;
      }
      
      public function get ShowInventories() : Vector.<TInventories>
      {
         return this.FShowInventories;
      }
      
      public function set ShowInventories(param1:Vector.<TInventories>) : void
      {
         this.FShowInventories = param1;
      }
      
      public function get WaterAwardInventories() : Vector.<TInventories>
      {
         return this.FWaterAwardInventories;
      }
      
      public function set WaterAwardInventories(param1:Vector.<TInventories>) : void
      {
         this.FWaterAwardInventories = param1;
      }
      
      public function get CurrentExp() : int
      {
         return this.FCurrentExp;
      }
      
      public function set CurrentExp(param1:int) : void
      {
         this.FCurrentExp = param1;
      }
      
      public function get CurrentTotalExp() : int
      {
         return this.FCurrentTotalExp;
      }
      
      public function set CurrentTotalExp(param1:int) : void
      {
         this.FCurrentTotalExp = param1;
      }
      
      public function get LevelExpList() : Vector.<int>
      {
         return this.FLevelExpList;
      }
      
      public function set LevelExpList(param1:Vector.<int>) : void
      {
         this.FLevelExpList = param1;
      }
      
      public function get GiftExpList() : Vector.<int>
      {
         return this.FGiftExpList;
      }
      
      public function set GiftExpList(param1:Vector.<int>) : void
      {
         this.FGiftExpList = param1;
      }
      
      public function get GetAwardNum() : int
      {
         return this.FGetAwardNum;
      }
      
      public function set GetAwardNum(param1:int) : void
      {
         this.FGetAwardNum = param1;
      }
      
      public function get TreePosList() : Vector.<int>
      {
         return this.FTreePosList;
      }
      
      public function set TreePosList(param1:Vector.<int>) : void
      {
         this.FTreePosList = param1;
      }
      
      public function get GiveTimes() : int
      {
         return this.FGiveTimes;
      }
      
      public function set GiveTimes(param1:int) : void
      {
         this.FGiveTimes = param1;
      }
      
      public function get WateIndex() : int
      {
         return this.FWateIndex;
      }
      
      public function set WateIndex(param1:int) : void
      {
         this.FWateIndex = param1;
      }
      
      public function get GetAwardIndex() : int
      {
         return this.FGetAwardIndex;
      }
      
      public function set GetAwardIndex(param1:int) : void
      {
         this.FGetAwardIndex = param1;
      }
      
      public function get CurrentGetAWardId() : int
      {
         return this.FCurrentGetAWardId;
      }
      
      public function set CurrentGetAWardId(param1:int) : void
      {
         this.FCurrentGetAWardId = param1;
      }
      
      public function get CurrrntGetAwardIndex() : int
      {
         return this.FCurrrntGetAwardIndex;
      }
      
      public function set CurrrntGetAwardIndex(param1:int) : void
      {
         this.FCurrrntGetAwardIndex = param1;
      }
      
      public function get GetPromptStr() : String
      {
         return this.FGetPromptStr;
      }
      
      public function set GetPromptStr(param1:String) : void
      {
         this.FGetPromptStr = param1;
      }
      
      public function get waterSpendCost() : int
      {
         return this.FWaterSpendCost;
      }
      
      public function set waterSpendCost(param1:int) : void
      {
         this.FWaterSpendCost = param1;
      }
      
      public function get GetFreePromptStr() : String
      {
         return this.FGetFreePromptStr;
      }
      
      public function set GetFreePromptStr(param1:String) : void
      {
         this.FGetFreePromptStr = param1;
      }
      
      public function get WatrePromptStr() : String
      {
         return this.FWatrePromptStr;
      }
      
      public function set WatrePromptStr(param1:String) : void
      {
         this.FWatrePromptStr = param1;
      }
   }
}

