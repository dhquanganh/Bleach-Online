package Logics.HDFirstPayGift
{
   import Logics.DatebaseVO.VO.THDFirstPayBagConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFirstPayGift.VO.TRechargeGoldVo;
   import Logics.Inventories.TInventories;
   
   public class TActivityFirstPayGiftData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDFirstPayBagConfig;
      
      protected var FRechargeGoldValue:int;
      
      protected var FRechargeGoldGiftVec:Vector.<TRechargeGoldVo>;
      
      protected var FFirstInventories:TInventories;
      
      protected var FFirstState:int;
      
      protected var FIsFinishAllTask:Boolean;
      
      public function TActivityFirstPayGiftData()
      {
         super();
         this.FRechargeGoldGiftVec = new Vector.<TRechargeGoldVo>();
      }
      
      public function get ActivityConfig() : THDFirstPayBagConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDFirstPayBagConfig) : void
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
      
      public function get RechargeGoldGiftVec() : Vector.<TRechargeGoldVo>
      {
         return this.FRechargeGoldGiftVec;
      }
      
      public function set RechargeGoldGiftVec(param1:Vector.<TRechargeGoldVo>) : void
      {
         this.FRechargeGoldGiftVec = param1;
      }
      
      public function get IsFinishAllTask() : Boolean
      {
         return this.FIsFinishAllTask;
      }
      
      public function set IsFinishAllTask(param1:Boolean) : void
      {
         this.FIsFinishAllTask = param1;
      }
      
      public function get FirstInventories() : TInventories
      {
         return this.FFirstInventories;
      }
      
      public function set FirstInventories(param1:TInventories) : void
      {
         this.FFirstInventories = param1;
      }
      
      public function get FirstState() : int
      {
         return this.FFirstState;
      }
      
      public function set FirstState(param1:int) : void
      {
         this.FFirstState = param1;
      }
   }
}

