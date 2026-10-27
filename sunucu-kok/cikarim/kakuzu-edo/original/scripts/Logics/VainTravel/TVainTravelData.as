package Logics.VainTravel
{
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   
   public class TVainTravelData
   {
      
      protected var FVainTravelPlayerInfor:Vector.<TVainTravelPlayerInfor>;
      
      protected var FVainTravelCoinNum:int;
      
      protected var FMyHeroIDS:Vector.<int>;
      
      protected var FMyHeroBloodRate:Vector.<int>;
      
      protected var FVainTravelShopData:TVainTravelShopData;
      
      protected var FVainTravelNiceFightReports:Vector.<TVainTravelFightReport>;
      
      protected var FVainTravelTodayFightReports:Vector.<TVainTravelFightReport>;
      
      protected var FCurrentResetTime:int;
      
      protected var FCurrentResetTimeBuied:int;
      
      protected var FFreeTimeEveryDay:int;
      
      protected var FResetCost:Vector.<int>;
      
      protected var FCurrentReliveTime:int;
      
      protected var FCurrentReliveTimeBuied:int;
      
      protected var FReliveCostVec:Vector.<int>;
      
      protected var FReliveTimeEveryDay:int;
      
      protected var FBAData:TBleachAgentData;
      
      public function TVainTravelData(param1:int)
      {
         var _loc2_:int = 0;
         super();
         this.FVainTravelPlayerInfor = new Vector.<TVainTravelPlayerInfor>();
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            this.FVainTravelPlayerInfor.push(new TVainTravelPlayerInfor());
            _loc2_++;
         }
         this.FVainTravelShopData = new TVainTravelShopData();
         this.FMyHeroIDS = new Vector.<int>();
         this.FMyHeroBloodRate = new Vector.<int>();
         this.FVainTravelTodayFightReports = new Vector.<TVainTravelFightReport>();
         this.FVainTravelNiceFightReports = new Vector.<TVainTravelFightReport>();
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      public function get VainTravelShopData() : TVainTravelShopData
      {
         return this.FVainTravelShopData;
      }
      
      public function get VainTravelPlayerInfor() : Vector.<TVainTravelPlayerInfor>
      {
         return this.FVainTravelPlayerInfor;
      }
      
      public function get MyHeroIDS() : Vector.<int>
      {
         return this.FMyHeroIDS;
      }
      
      public function get MyHeroBloodRate() : Vector.<int>
      {
         return this.FMyHeroBloodRate;
      }
      
      public function get CurrentResetTime() : int
      {
         return this.FCurrentResetTime;
      }
      
      public function set CurrentResetTime(param1:int) : void
      {
         this.FCurrentResetTime = param1;
      }
      
      public function get LastResetTime() : int
      {
         return this.FreeTimeEveryDay + SLogicsCore.Character.VipData.VainTravelBuy + SLogicsCore.Character.VipData.VainTravelFree - this.FCurrentResetTime;
      }
      
      public function get IfFree() : Boolean
      {
         var _loc1_:int = 0;
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_BraveCirleRefreshCount) > 0)
         {
            return true;
         }
         _loc1_ = this.FreeTimeEveryDay + SLogicsCore.Character.VipData.VainTravelFree - this.FCurrentResetTime;
         return _loc1_ > 0;
      }
      
      public function get CurrentResetCost() : int
      {
         var _loc1_:int = 0;
         if(this.IfFree)
         {
            return 0;
         }
         _loc1_ = this.FResetCost.length - this.LastResetTime;
         if(_loc1_ == this.FResetCost.length)
         {
            return 0;
         }
         return this.FResetCost[_loc1_];
      }
      
      public function get VainTravelCoinNum() : int
      {
         return this.FVainTravelCoinNum;
      }
      
      public function set VainTravelCoinNum(param1:int) : void
      {
         this.FVainTravelCoinNum = param1;
      }
      
      public function get VainTravelNiceFightReports() : Vector.<TVainTravelFightReport>
      {
         return this.FVainTravelNiceFightReports;
      }
      
      public function get VainTravelTodayFightReports() : Vector.<TVainTravelFightReport>
      {
         return this.FVainTravelTodayFightReports;
      }
      
      public function get CurrentResetTimeBuied() : int
      {
         return this.FCurrentResetTimeBuied;
      }
      
      public function set CurrentResetTimeBuied(param1:int) : void
      {
         this.FCurrentResetTimeBuied = param1;
      }
      
      public function get FreeTimeEveryDay() : int
      {
         return this.FFreeTimeEveryDay;
      }
      
      public function set FreeTimeEveryDay(param1:int) : void
      {
         this.FFreeTimeEveryDay = param1;
      }
      
      public function get CurrentReliveTime() : int
      {
         return this.FCurrentReliveTime;
      }
      
      public function set CurrentReliveTime(param1:int) : void
      {
         this.FCurrentReliveTime = param1;
      }
      
      public function get CurrentReliveTimeBuied() : int
      {
         return this.FCurrentReliveTimeBuied;
      }
      
      public function set CurrentReliveTimeBuied(param1:int) : void
      {
         this.FCurrentReliveTimeBuied = param1;
      }
      
      public function get ReliveCostVec() : Vector.<int>
      {
         return this.FReliveCostVec;
      }
      
      public function set ReliveCostVec(param1:Vector.<int>) : void
      {
         this.FReliveCostVec = param1;
      }
      
      public function get ResetCost() : Vector.<int>
      {
         return this.FResetCost;
      }
      
      public function set ResetCost(param1:Vector.<int>) : void
      {
         this.FResetCost = param1;
      }
      
      public function get CanReliveTime() : int
      {
         return this.FReliveTimeEveryDay + this.FCurrentReliveTimeBuied - this.FCurrentReliveTime;
      }
      
      public function get LastReliveBuyTime() : int
      {
         return SLogicsCore.Character.VipData.VainTravelCanReliveTime - this.FCurrentReliveTimeBuied;
      }
      
      public function get BuyReliveCost() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.FReliveCostVec.length - this.LastReliveBuyTime;
         if(_loc1_ == this.FReliveCostVec.length)
         {
            return 0;
         }
         return this.FReliveCostVec[_loc1_];
      }
      
      public function get ReliveTimeEveryDay() : int
      {
         return this.FReliveTimeEveryDay;
      }
      
      public function set ReliveTimeEveryDay(param1:int) : void
      {
         this.FReliveTimeEveryDay = param1;
      }
      
      public function PlayerInforByIndex(param1:int) : TVainTravelPlayerInfor
      {
         return this.FVainTravelPlayerInfor[param1];
      }
   }
}

