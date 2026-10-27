package Logics.Achievenment
{
   public class TAchievementGroupInfor
   {
      
      protected var FGroupName:String;
      
      protected var FAchievementInfors:TAchievementInfors;
      
      protected var FTotalSchedule:int;
      
      protected var FCurrentSchedule:int;
      
      protected var FAchievementClassInfor:TAchievementClassInfor;
      
      public function TAchievementGroupInfor()
      {
         super();
         this.FAchievementInfors = new TAchievementInfors();
      }
      
      public function get GroupName() : String
      {
         return this.FGroupName;
      }
      
      public function set GroupName(param1:String) : void
      {
         this.FGroupName = param1;
      }
      
      public function get AchievementInfors() : TAchievementInfors
      {
         return this.FAchievementInfors;
      }
      
      public function get TotalSchedule() : int
      {
         return this.FTotalSchedule;
      }
      
      public function set TotalSchedule(param1:int) : void
      {
         this.FTotalSchedule = param1;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get AchievementClassInfor() : TAchievementClassInfor
      {
         return this.FAchievementClassInfor;
      }
      
      public function set AchievementClassInfor(param1:TAchievementClassInfor) : void
      {
         this.FAchievementClassInfor = param1;
      }
      
      public function DeleteAchievementByID(param1:uint) : void
      {
         this.FAchievementInfors.DeleteAchievementByID(param1);
      }
   }
}

