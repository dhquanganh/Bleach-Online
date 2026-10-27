package Logics.Affairs
{
   public class TAffairInstance extends TAffair
   {
      
      protected var FInstance:Object;
      
      public function TAffairInstance(param1:uint)
      {
         super(param1);
      }
      
      public function get Instance() : Object
      {
         return this.FInstance;
      }
      
      public function set Instance(param1:Object) : void
      {
         this.FInstance = param1;
      }
   }
}

