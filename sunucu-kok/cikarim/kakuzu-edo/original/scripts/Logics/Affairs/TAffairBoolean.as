package Logics.Affairs
{
   public class TAffairBoolean extends TAffair
   {
      
      protected var FValue:Boolean;
      
      public function TAffairBoolean(param1:uint)
      {
         super(param1);
      }
      
      public function get Value() : Boolean
      {
         return this.FValue;
      }
      
      public function set Value(param1:Boolean) : void
      {
         this.FValue = param1;
      }
   }
}

