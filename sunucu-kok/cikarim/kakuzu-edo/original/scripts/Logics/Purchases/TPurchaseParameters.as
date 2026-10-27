package Logics.Purchases
{
   public class TPurchaseParameters
   {
      
      protected var FRoutineSuccess:Function;
      
      protected var FRoutineFailure:Function;
      
      protected var FRoutineCancel:Function;
      
      public function TPurchaseParameters()
      {
         super();
         this.Reset();
      }
      
      public function get RoutineSuccess() : Function
      {
         return this.FRoutineSuccess;
      }
      
      public function set RoutineSuccess(param1:Function) : void
      {
         this.FRoutineSuccess = param1;
      }
      
      public function get RoutineFailure() : Function
      {
         return this.FRoutineFailure;
      }
      
      public function set RoutineFailure(param1:Function) : void
      {
         this.FRoutineFailure = param1;
      }
      
      public function get RoutineCancel() : Function
      {
         return this.FRoutineCancel;
      }
      
      public function set RoutineCancel(param1:Function) : void
      {
         this.FRoutineCancel = param1;
      }
      
      public function Reset() : void
      {
         this.FRoutineSuccess = null;
         this.FRoutineFailure = null;
         this.FRoutineCancel = null;
      }
   }
}

