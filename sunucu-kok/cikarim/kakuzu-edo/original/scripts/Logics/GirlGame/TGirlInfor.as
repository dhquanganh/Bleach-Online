package Logics.GirlGame
{
   public class TGirlInfor
   {
      
      protected var FID:uint;
      
      protected var FName:String;
      
      protected var FOpenCondition:int;
      
      protected var FIfOpen:Boolean;
      
      protected var FClothes:Vector.<TGirlClothes>;
      
      protected var FCurrentSchedule:int;
      
      protected var FScheduleHistory:int;
      
      protected var FRewardString:String;
      
      protected var FRewardName:Vector.<String>;
      
      protected var FSuccessText:Vector.<String>;
      
      protected var FFailText:String;
      
      public function TGirlInfor()
      {
         super();
         this.FClothes = new Vector.<TGirlClothes>();
         this.FRewardName = new Vector.<String>();
         this.FCurrentSchedule = 0;
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get Clothes() : Vector.<TGirlClothes>
      {
         return this.FClothes;
      }
      
      public function set Clothes(param1:Vector.<TGirlClothes>) : void
      {
         this.FClothes = param1;
      }
      
      public function get OpenCondition() : int
      {
         return this.FOpenCondition;
      }
      
      public function set OpenCondition(param1:int) : void
      {
         this.FOpenCondition = param1;
      }
      
      public function get ScheduleHistory() : int
      {
         return this.FScheduleHistory;
      }
      
      public function set ScheduleHistory(param1:int) : void
      {
         this.FScheduleHistory = param1;
      }
      
      public function get RewardString() : String
      {
         return this.FRewardString;
      }
      
      public function set RewardString(param1:String) : void
      {
         this.FRewardString = param1;
      }
      
      public function get RewardName() : Vector.<String>
      {
         return this.FRewardName;
      }
      
      public function set RewardName(param1:Vector.<String>) : void
      {
         this.FRewardName = param1;
      }
      
      public function get IfOpen() : Boolean
      {
         return this.FIfOpen;
      }
      
      public function set IfOpen(param1:Boolean) : void
      {
         this.FIfOpen = param1;
      }
      
      public function get SuccessText() : Vector.<String>
      {
         return this.FSuccessText;
      }
      
      public function set SuccessText(param1:Vector.<String>) : void
      {
         this.FSuccessText = param1;
      }
      
      public function get FailText() : String
      {
         return this.FFailText;
      }
      
      public function set FailText(param1:String) : void
      {
         this.FFailText = param1;
      }
      
      public function Reset() : void
      {
         this.FCurrentSchedule = -1;
      }
   }
}

