package Logics.Dailytask
{
   public class TTargetTaskList
   {
      
      protected var FEventType:uint;
      
      protected var FIsFinish:uint;
      
      public function TTargetTaskList()
      {
         super();
      }
      
      public function get EventType() : uint
      {
         return this.FEventType;
      }
      
      public function set EventType(param1:uint) : void
      {
         this.FEventType = param1;
      }
      
      public function get IsFinish() : uint
      {
         return this.FIsFinish;
      }
      
      public function set IsFinish(param1:uint) : void
      {
         this.FIsFinish = param1;
      }
   }
}

