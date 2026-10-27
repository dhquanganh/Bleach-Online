package Logics.HDUniteTask
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.Json.TArticalItem;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.THDUniteTaskConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDUniteTask.VO.TUltimateRewardVO;
   import Logics.HDUniteTask.VO.TUniteTaskTaskVO;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUniteTaskData extends TActivityOSBase
   {
      
      public static const TaskCount:uint = 10;
      
      public static const LotteryRewardCount:uint = 9;
      
      protected var FTaskVOs:Vector.<TUniteTaskTaskVO>;
      
      protected var FUltimateRewardVO:TUltimateRewardVO;
      
      protected var FLowEmploymentEnabled:Boolean;
      
      protected var FSeniorEmploymentEnabled:Boolean;
      
      protected var FRemainLotteryCount:uint;
      
      protected var FDay:uint;
      
      protected var FConfig:THDUniteTaskConfig;
      
      protected var FLotteryInventories:TInventories;
      
      protected var FLotteryTarget:TTypeCodeAmount;
      
      public function TUniteTaskData()
      {
         super();
         this.FTaskVOs = new Vector.<TUniteTaskTaskVO>(TaskCount);
         this.FUltimateRewardVO = new TUltimateRewardVO();
         this.FLotteryInventories = new TInventories();
         this.FLotteryTarget = new TTypeCodeAmount();
      }
      
      public function get TaskVOs() : Vector.<TUniteTaskTaskVO>
      {
         return this.FTaskVOs;
      }
      
      public function set TaskVOs(param1:Vector.<TUniteTaskTaskVO>) : void
      {
         this.FTaskVOs = param1;
      }
      
      public function get UltimateRewardVO() : TUltimateRewardVO
      {
         return this.FUltimateRewardVO;
      }
      
      public function set UltimateRewardVO(param1:TUltimateRewardVO) : void
      {
         this.FUltimateRewardVO = param1;
      }
      
      public function get RemainLotteryCount() : uint
      {
         return this.FRemainLotteryCount;
      }
      
      public function set RemainLotteryCount(param1:uint) : void
      {
         this.FRemainLotteryCount = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get Config() : THDUniteTaskConfig
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDUniteTaskConfig) : void
      {
         this.FConfig = param1;
      }
      
      public function get LowEmploymentEnabled() : Boolean
      {
         return this.FLowEmploymentEnabled;
      }
      
      public function set LowEmploymentEnabled(param1:Boolean) : void
      {
         this.FLowEmploymentEnabled = param1;
      }
      
      public function get SeniorEmploymentEnabled() : Boolean
      {
         return this.FSeniorEmploymentEnabled;
      }
      
      public function set SeniorEmploymentEnabled(param1:Boolean) : void
      {
         this.FSeniorEmploymentEnabled = param1;
      }
      
      public function get LotteryInventories() : TInventories
      {
         return this.FLotteryInventories;
      }
      
      public function set LotteryInventories(param1:TInventories) : void
      {
         this.FLotteryInventories = param1;
      }
      
      public function get LotteryTarget() : TTypeCodeAmount
      {
         return this.FLotteryTarget;
      }
      
      public function set LotteryTarget(param1:TTypeCodeAmount) : void
      {
         this.FLotteryTarget = param1;
      }
      
      public function GetAwardIndexByAwardInfo() : int
      {
         var _loc1_:uint = 0;
         var _loc2_:TInventory = null;
         var _loc3_:int = 0;
         var _loc4_:TAward = null;
         var _loc5_:TArticalItem = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,this.FConfig.Extract.award[this.FDay]) as TAward;
         _loc1_ = 0;
         while(_loc1_ < LotteryRewardCount)
         {
            _loc5_ = _loc4_.RandomAwards[_loc1_];
            if(this.FLotteryTarget.Type == _loc5_.Type && this.FLotteryTarget.Code == _loc5_.Code && this.FLotteryTarget.Amount == _loc5_.Amount)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
   }
}

