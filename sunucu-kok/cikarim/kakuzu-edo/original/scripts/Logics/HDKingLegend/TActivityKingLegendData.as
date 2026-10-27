package Logics.HDKingLegend
{
   import Logics.DatebaseVO.VO.THDKingLegend;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDKingLegend.TKingLegendTaskVo;
   
   public class TActivityKingLegendData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDKingLegend;
      
      private var FPlayerOrderValue:int;
      
      private var FRechargeInventories:TInventories;
      
      private var FGetAwardInventories:TInventories;
      
      private var FBagAwardInventories:TInventories;
      
      private var FExtractInventories:Vector.<TInventories>;
      
      private var FTaskList:Vector.<TKingLegendTaskVo>;
      
      private var FCurDay:int;
      
      private var FCurCostGold:int;
      
      private var FExchargeFirstState:int;
      
      private var FExchargeSecondState:int;
      
      private var FBagBtnState:int;
      
      private var FGetExtractInfoVec:Vector.<int>;
      
      public function TActivityKingLegendData()
      {
         super();
         this.FExtractInventories = new Vector.<TInventories>();
         this.FTaskList = new Vector.<TKingLegendTaskVo>();
      }
      
      public function get ActivityConfig() : THDKingLegend
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDKingLegend) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get PlayerOrderValue() : int
      {
         return this.FPlayerOrderValue;
      }
      
      public function set PlayerOrderValue(param1:int) : void
      {
         this.FPlayerOrderValue = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get CurCostGold() : int
      {
         return this.FCurCostGold;
      }
      
      public function set CurCostGold(param1:int) : void
      {
         this.FCurCostGold = param1;
      }
      
      public function get ExchargeFirstState() : int
      {
         return this.FExchargeFirstState;
      }
      
      public function set ExchargeFirstState(param1:int) : void
      {
         this.FExchargeFirstState = param1;
      }
      
      public function get ExchargeSecondState() : int
      {
         return this.FExchargeSecondState;
      }
      
      public function set ExchargeSecondState(param1:int) : void
      {
         this.FExchargeSecondState = param1;
      }
      
      public function get BagBtnState() : int
      {
         return this.FBagBtnState;
      }
      
      public function set BagBtnState(param1:int) : void
      {
         this.FBagBtnState = param1;
      }
      
      public function get RechargeInventories() : TInventories
      {
         return this.FRechargeInventories;
      }
      
      public function set RechargeInventories(param1:TInventories) : void
      {
         this.FRechargeInventories = param1;
      }
      
      public function get GetAwardInventories() : TInventories
      {
         return this.FGetAwardInventories;
      }
      
      public function set GetAwardInventories(param1:TInventories) : void
      {
         this.FGetAwardInventories = param1;
      }
      
      public function get BagAwardInventories() : TInventories
      {
         return this.FBagAwardInventories;
      }
      
      public function set BagAwardInventories(param1:TInventories) : void
      {
         this.FBagAwardInventories = param1;
      }
      
      public function get ExtractInventories() : Vector.<TInventories>
      {
         return this.FExtractInventories;
      }
      
      public function set ExtractInventories(param1:Vector.<TInventories>) : void
      {
         this.FExtractInventories = param1;
      }
      
      public function get TaskList() : Vector.<TKingLegendTaskVo>
      {
         return this.FTaskList;
      }
      
      public function set TaskList(param1:Vector.<TKingLegendTaskVo>) : void
      {
         this.FTaskList = param1;
      }
      
      public function get GetExtractInfoVec() : Vector.<int>
      {
         return this.FGetExtractInfoVec;
      }
      
      public function set GetExtractInfoVec(param1:Vector.<int>) : void
      {
         this.FGetExtractInfoVec = param1;
      }
   }
}

