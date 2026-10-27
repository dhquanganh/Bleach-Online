package Logics.Achievenment
{
   public class TAchievementClassInfor
   {
      
      protected var FAchievementClassName:String;
      
      protected var FAchivementGroups:Vector.<TAchievementGroupInfor>;
      
      protected var FTotalSchedule:int;
      
      protected var FCurrentSchedule:int;
      
      public function TAchievementClassInfor()
      {
         super();
         this.FAchivementGroups = new Vector.<TAchievementGroupInfor>();
      }
      
      public function get AchievementClassName() : String
      {
         return this.FAchievementClassName;
      }
      
      public function set AchievementClassName(param1:String) : void
      {
         this.FAchievementClassName = param1;
      }
      
      public function get AchivementGroups() : Vector.<TAchievementGroupInfor>
      {
         return this.FAchivementGroups;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get TotalSchedule() : int
      {
         return this.FTotalSchedule;
      }
      
      public function set TotalSchedule(param1:int) : void
      {
         this.FTotalSchedule = param1;
      }
      
      public function DeleteAchievementByID(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FAchivementGroups.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAchivementGroups[_loc2_].DeleteAchievementByID(param1);
            _loc2_++;
         }
      }
   }
}

