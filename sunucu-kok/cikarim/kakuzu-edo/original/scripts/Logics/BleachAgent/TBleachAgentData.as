package Logics.BleachAgent
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Logics.BleachAgent.VO.TBleachAgentConfigValueVO;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.Dictionary;
   
   public class TBleachAgentData
   {
      
      public const WelfareType_SignCout:int = 4;
      
      public const WelfareType_DayTaskRefreshCout:int = 5;
      
      public const WelfareType_DayTaskFinishCout:int = 6;
      
      public const WelfareType_JadeOpenFreeCount:int = 7;
      
      public const WelfareType_ChangeHeroCount:int = 8;
      
      public const WelfareType_LeagueAwardCount:int = 9;
      
      public const WelfareType_LeagueBloodAwardCount:int = 10;
      
      public const WelfareType_DiggingFreeCount:int = 11;
      
      public const WelfareType_BraveCirleRefreshCount:int = 12;
      
      public const WelfareType_RelatedPartnerFreeCount:int = 13;
      
      public const WelfareType_NightmareTrialRaidCount:int = 14;
      
      public const WelfareType_DayBuyOrderFreeCount:int = 15;
      
      public const WelfareType_DayHellButterflyCount:int = 16;
      
      protected var FWelfareCount:Dictionary;
      
      protected var FWelfareTotalCount:Dictionary;
      
      protected var FCurIsBuyState:Boolean;
      
      protected var FConfigValueVO:TBleachAgentConfigValueVO;
      
      protected var FTimeStamp:uint;
      
      protected var FDailyRewardState:int;
      
      protected var FWeeklyRewardState:int;
      
      protected var FRenewRewardState:int;
      
      protected var FFirstRewardState:int;
      
      protected var FOpen:Boolean;
      
      public function TBleachAgentData()
      {
         super();
         this.FConfigValueVO = new TBleachAgentConfigValueVO();
         this.FWelfareCount = new Dictionary();
         this.InitWelfareCount();
      }
      
      protected function InitWelfareCount() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = uint(this.WelfareType_SignCout);
         while(_loc1_ <= this.WelfareType_DayHellButterflyCount)
         {
            this.FWelfareCount[_loc1_] = 0;
            _loc1_++;
         }
      }
      
      protected function CreateWelfareTotalCount() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         this.FWelfareTotalCount = new Dictionary();
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_SignCout) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_SignCout] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DayTaskRefreshCout) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_DayTaskRefreshCout] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DayTaskFinishCout) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_DayTaskFinishCout] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_JadeOpenFreeCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_JadeOpenFreeCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_ChangeHeroCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_ChangeHeroCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_LeagueAwardCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_LeagueAwardCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_LeagueBloodAwardCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_LeagueBloodAwardCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DiggingFreeCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_DiggingFreeCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_BraveCirleRefreshCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_BraveCirleRefreshCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_RelatedPartnerFreeCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_RelatedPartnerFreeCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_NightmareTrialRaidCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_NightmareTrialRaidCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DayBuyOrderFreeCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_DayBuyOrderFreeCount] = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DayHellButterflyCount) as TConfigValue;
         this.FWelfareTotalCount[this.WelfareType_DayHellButterflyCount] = int(_loc2_.Value);
      }
      
      public function get ConfigValueVO() : TBleachAgentConfigValueVO
      {
         return this.FConfigValueVO;
      }
      
      public function get Remain() : uint
      {
         var _loc1_:uint = 0;
         return uint(Math.max(0,this.FTimeStamp - STimingCore.ServerTick));
      }
      
      public function set TimeStamp(param1:uint) : void
      {
         this.FTimeStamp = param1;
      }
      
      public function get Open() : Boolean
      {
         return this.FOpen;
      }
      
      public function set Open(param1:Boolean) : void
      {
         this.FOpen = param1;
      }
      
      public function get DailyRewardState() : int
      {
         return this.FDailyRewardState;
      }
      
      public function set DailyRewardState(param1:int) : void
      {
         this.FDailyRewardState = param1;
      }
      
      public function get WeeklyRewardState() : int
      {
         return this.FWeeklyRewardState;
      }
      
      public function set WeeklyRewardState(param1:int) : void
      {
         this.FWeeklyRewardState = param1;
      }
      
      public function get RenewRewardState() : int
      {
         return this.FRenewRewardState;
      }
      
      public function set RenewRewardState(param1:int) : void
      {
         this.FRenewRewardState = param1;
      }
      
      public function get FirstRewardState() : int
      {
         return this.FFirstRewardState;
      }
      
      public function set FirstRewardState(param1:int) : void
      {
         this.FFirstRewardState = param1;
      }
      
      public function get CurIsBuyState() : Boolean
      {
         return this.FCurIsBuyState;
      }
      
      public function set CurIsBuyState(param1:Boolean) : void
      {
         this.FCurIsBuyState = param1;
      }
      
      public function GetWelfareCountByType(param1:uint) : int
      {
         if(!this.FOpen)
         {
            return 0;
         }
         return this.FWelfareCount[param1];
      }
      
      public function SetWelfareCountByType(param1:uint, param2:int) : void
      {
         if(this.FWelfareTotalCount == null)
         {
            this.CreateWelfareTotalCount();
         }
         this.FWelfareCount[param1] = this.FWelfareTotalCount[param1] - param2;
      }
      
      public function UpdateCountForTotal() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = uint(this.WelfareType_SignCout);
         while(_loc1_ <= this.WelfareType_DayHellButterflyCount)
         {
            this.SetWelfareCountByType(_loc1_,0);
            _loc1_++;
         }
      }
   }
}

