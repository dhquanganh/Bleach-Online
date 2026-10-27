package Logics.HDGrowthPlan
{
   import Logics.DatebaseVO.VO.THDGrowthPlanConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGrowthPlan.VO.TLevelGrowPlanVO;
   
   public class TActivityGrowthPlanData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDGrowthPlanConfig;
      
      protected var FRechargeGoldValue:int;
      
      protected var FBuyGrowthPlanState:int;
      
      protected var FGrowPlanVec:Vector.<TLevelGrowPlanVO>;
      
      protected var FIsFinishAllTask:Boolean;
      
      public function TActivityGrowthPlanData()
      {
         super();
         this.FGrowPlanVec = new Vector.<TLevelGrowPlanVO>();
      }
      
      public function get ActivityConfig() : THDGrowthPlanConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDGrowthPlanConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get RechargeGoldValue() : int
      {
         return this.FRechargeGoldValue;
      }
      
      public function set RechargeGoldValue(param1:int) : void
      {
         this.FRechargeGoldValue = param1;
      }
      
      public function get BuyGrowthPlanState() : int
      {
         return this.FBuyGrowthPlanState;
      }
      
      public function set BuyGrowthPlanState(param1:int) : void
      {
         this.FBuyGrowthPlanState = param1;
      }
      
      public function get GrowPlanVec() : Vector.<TLevelGrowPlanVO>
      {
         return this.FGrowPlanVec;
      }
      
      public function set GrowPlanVec(param1:Vector.<TLevelGrowPlanVO>) : void
      {
         this.FGrowPlanVec = param1;
      }
      
      public function get IsFinishAllTask() : Boolean
      {
         return this.FIsFinishAllTask;
      }
      
      public function set IsFinishAllTask(param1:Boolean) : void
      {
         this.FIsFinishAllTask = param1;
      }
   }
}

