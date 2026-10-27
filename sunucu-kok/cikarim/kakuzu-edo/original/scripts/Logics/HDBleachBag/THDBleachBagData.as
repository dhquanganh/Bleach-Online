package Logics.HDBleachBag
{
   import Logics.DatebaseVO.VO.THDBleachBagConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class THDBleachBagData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDBleachBagConfig;
      
      protected var FFreeAwards:Vector.<TInventories>;
      
      protected var FCurFreeAwardState:int;
      
      protected var FRechargeGifts:Vector.<Vector.<TRechargeGiftVo>>;
      
      protected var FCostGifts:Vector.<Vector.<TCostGiftVo>>;
      
      protected var FFinalAwardState:int;
      
      protected var FActivityDay:int;
      
      protected var FTaskAwards:Vector.<Vector.<TBleachTaskVo>>;
      
      protected var FInited:Boolean;
      
      public function THDBleachBagData()
      {
         super();
         this.FFreeAwards = new Vector.<TInventories>();
         this.FRechargeGifts = new Vector.<Vector.<TRechargeGiftVo>>();
         this.FCostGifts = new Vector.<Vector.<TCostGiftVo>>();
         this.FTaskAwards = new Vector.<Vector.<TBleachTaskVo>>();
      }
      
      public function get ActivityConfig() : THDBleachBagConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDBleachBagConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get FreeAwards() : Vector.<TInventories>
      {
         return this.FFreeAwards;
      }
      
      public function set FreeAwards(param1:Vector.<TInventories>) : void
      {
         this.FFreeAwards = param1;
      }
      
      public function set RechargeGifts(param1:Vector.<Vector.<TRechargeGiftVo>>) : void
      {
         this.FRechargeGifts = param1;
      }
      
      public function get RechargeGifts() : Vector.<Vector.<TRechargeGiftVo>>
      {
         return this.FRechargeGifts;
      }
      
      public function set CostGifts(param1:Vector.<Vector.<TCostGiftVo>>) : void
      {
         this.FCostGifts = param1;
      }
      
      public function get CostGifts() : Vector.<Vector.<TCostGiftVo>>
      {
         return this.FCostGifts;
      }
      
      public function set FinalAwardState(param1:int) : void
      {
         this.FFinalAwardState = param1;
      }
      
      public function get FinalAwardState() : int
      {
         return this.FFinalAwardState;
      }
      
      public function get ActivityDay() : int
      {
         return this.FActivityDay;
      }
      
      public function set ActivityDay(param1:int) : void
      {
         this.FActivityDay = param1;
      }
      
      public function get TaskAwards() : Vector.<Vector.<TBleachTaskVo>>
      {
         return this.FTaskAwards;
      }
      
      public function set TaskAwards(param1:Vector.<Vector.<TBleachTaskVo>>) : void
      {
         this.FTaskAwards = param1;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
      
      public function set CurFreeAwardState(param1:int) : void
      {
         this.FCurFreeAwardState = param1;
      }
      
      public function get CurFreeAwardState() : int
      {
         return this.FCurFreeAwardState;
      }
      
      public function GetRechargeGiftsData() : Vector.<TRechargeGiftVo>
      {
         var _loc1_:Vector.<TRechargeGiftVo> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = new Vector.<TRechargeGiftVo>();
         _loc3_ = int(this.FRechargeGifts.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_[_loc2_] = this.FRechargeGifts[_loc2_][this.FActivityDay];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function GetCostGiftsData() : Vector.<TCostGiftVo>
      {
         var _loc1_:Vector.<TCostGiftVo> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = new Vector.<TCostGiftVo>();
         _loc3_ = int(this.FCostGifts.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_[_loc2_] = this.FCostGifts[_loc2_][this.FActivityDay];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function GetTaskGiftsData() : Vector.<TBleachTaskVo>
      {
         var _loc1_:Vector.<TBleachTaskVo> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = new Vector.<TBleachTaskVo>();
         _loc3_ = int(this.FTaskAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_[_loc2_] = this.FTaskAwards[_loc2_][this.FActivityDay];
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

