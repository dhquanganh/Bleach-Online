package Logics.BleachAgent.VO
{
   import Logics.Inventories.TInventories;
   
   public class TBleachAgentConfigValueVO
   {
      
      protected var FEnjoyDay:uint;
      
      protected var FOriginal:uint;
      
      protected var FDiscount:uint;
      
      protected var FRenewal:uint;
      
      protected var FDailyReward:TInventories;
      
      protected var FWeeklyReward:TInventories;
      
      protected var FRenewReward:TInventories;
      
      protected var FFirstReward:TInventories;
      
      protected var FTotalTime:uint;
      
      public function TBleachAgentConfigValueVO()
      {
         super();
         this.FDailyReward = new TInventories();
         this.FWeeklyReward = new TInventories();
         this.FRenewReward = new TInventories();
         this.FFirstReward = new TInventories();
      }
      
      public function get EnjoyDay() : uint
      {
         return this.FEnjoyDay;
      }
      
      public function set EnjoyDay(param1:uint) : void
      {
         this.FEnjoyDay = param1;
      }
      
      public function get Original() : uint
      {
         return this.FOriginal;
      }
      
      public function set Original(param1:uint) : void
      {
         this.FOriginal = param1;
      }
      
      public function get Discount() : uint
      {
         return this.FDiscount;
      }
      
      public function set Discount(param1:uint) : void
      {
         this.FDiscount = param1;
      }
      
      public function get DailyReward() : TInventories
      {
         return this.FDailyReward;
      }
      
      public function get WeeklyReward() : TInventories
      {
         return this.FWeeklyReward;
      }
      
      public function get RenewReward() : TInventories
      {
         return this.FRenewReward;
      }
      
      public function get FirstReward() : TInventories
      {
         return this.FFirstReward;
      }
      
      public function get TotalTime() : uint
      {
         return this.FTotalTime;
      }
      
      public function set TotalTime(param1:uint) : void
      {
         this.FTotalTime = param1;
      }
      
      public function get Renewal() : uint
      {
         return this.FRenewal;
      }
      
      public function set Renewal(param1:uint) : void
      {
         this.FRenewal = param1;
      }
   }
}

