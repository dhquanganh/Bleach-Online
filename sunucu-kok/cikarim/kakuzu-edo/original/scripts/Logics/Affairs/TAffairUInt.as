package Logics.Affairs
{
   public class TAffairUInt extends TAffair
   {
      
      protected var FValue:uint;
      
      public function TAffairUInt(param1:uint)
      {
         super(param1);
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
   }
}

