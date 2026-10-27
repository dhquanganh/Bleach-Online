package Logics.Affairs
{
   public class TAffairInt extends TAffair
   {
      
      protected var FValue:int;
      
      public function TAffairInt(param1:uint)
      {
         super(param1);
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.FValue = param1;
      }
   }
}

