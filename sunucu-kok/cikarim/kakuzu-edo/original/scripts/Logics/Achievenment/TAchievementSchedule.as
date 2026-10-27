package Logics.Achievenment
{
   public class TAchievementSchedule
   {
      
      protected var FType:int;
      
      protected var FValue:int;
      
      protected var FConditionStrings:String;
      
      protected var FCurrentSchedule:int;
      
      protected var FComplete:Boolean;
      
      public function TAchievementSchedule()
      {
         super();
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.FValue = param1;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get ConditionStrings() : String
      {
         return this.FConditionStrings;
      }
      
      public function set ConditionStrings(param1:String) : void
      {
         this.FConditionStrings = param1;
      }
      
      public function get Complete() : Boolean
      {
         return this.FComplete;
      }
      
      public function set Complete(param1:Boolean) : void
      {
         this.FComplete = param1;
      }
   }
}

