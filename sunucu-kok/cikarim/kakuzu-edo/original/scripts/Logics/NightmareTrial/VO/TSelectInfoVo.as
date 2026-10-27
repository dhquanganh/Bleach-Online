package Logics.NightmareTrial.VO
{
   import Logics.Inventories.TInventories;
   
   public class TSelectInfoVo
   {
      
      private var FInventories:Vector.<Vector.<TInventories>>;
      
      private var FPassLevelInventories:Vector.<Vector.<TInventories>>;
      
      private var FResetGold:int;
      
      private var FResetTimes:int;
      
      private var FCurrentCityId:int;
      
      private var FHistoryCityId:int;
      
      private var FPassAmount:int;
      
      private var FCurrentRefreshTimes:int;
      
      private var FNightmareTrialPointVec:Vector.<Vector.<TNightmareTrialPointVo>>;
      
      private var FSkillInfoStr:String;
      
      public function TSelectInfoVo()
      {
         super();
         this.FInventories = new Vector.<Vector.<TInventories>>();
         this.FPassLevelInventories = new Vector.<Vector.<TInventories>>();
         this.FNightmareTrialPointVec = new Vector.<Vector.<TNightmareTrialPointVo>>();
      }
      
      public function set Inventories(param1:Vector.<Vector.<TInventories>>) : void
      {
         this.FInventories = param1;
      }
      
      public function get Inventories() : Vector.<Vector.<TInventories>>
      {
         return this.FInventories;
      }
      
      public function set PassLevelInventories(param1:Vector.<Vector.<TInventories>>) : void
      {
         this.FPassLevelInventories = param1;
      }
      
      public function get PassLevelInventories() : Vector.<Vector.<TInventories>>
      {
         return this.FPassLevelInventories;
      }
      
      public function set ResetGold(param1:int) : void
      {
         this.FResetGold = param1;
      }
      
      public function get ResetGold() : int
      {
         return this.FResetGold;
      }
      
      public function set ResetTimes(param1:int) : void
      {
         this.FResetTimes = param1;
      }
      
      public function get ResetTimes() : int
      {
         return this.FResetTimes;
      }
      
      public function set CurrentCityId(param1:int) : void
      {
         this.FCurrentCityId = param1;
      }
      
      public function get CurrentCityId() : int
      {
         return this.FCurrentCityId;
      }
      
      public function set HistoryCityId(param1:int) : void
      {
         this.FHistoryCityId = param1;
      }
      
      public function get HistoryCityId() : int
      {
         return this.FHistoryCityId;
      }
      
      public function set CurrentRefreshTimes(param1:int) : void
      {
         this.FCurrentRefreshTimes = param1;
      }
      
      public function get CurrentRefreshTimes() : int
      {
         return this.FCurrentRefreshTimes;
      }
      
      public function set PassAmount(param1:int) : void
      {
         this.FPassAmount = param1;
      }
      
      public function get PassAmount() : int
      {
         return this.FPassAmount;
      }
      
      public function set NightmareTrialPointVec(param1:Vector.<Vector.<TNightmareTrialPointVo>>) : void
      {
         this.FNightmareTrialPointVec = param1;
      }
      
      public function get NightmareTrialPointVec() : Vector.<Vector.<TNightmareTrialPointVo>>
      {
         return this.FNightmareTrialPointVec;
      }
      
      public function set SkillInfoStr(param1:String) : void
      {
         this.FSkillInfoStr = param1;
      }
      
      public function get SkillInfoStr() : String
      {
         return this.FSkillInfoStr;
      }
   }
}

