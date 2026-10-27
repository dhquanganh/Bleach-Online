package Logics.Affairs
{
   public class TAffairUInt64 extends TAffair
   {
      
      protected var FValue0:uint;
      
      protected var FValue1:uint;
      
      public function TAffairUInt64(param1:uint)
      {
         super(param1);
      }
      
      public function get Value0() : uint
      {
         return this.FValue0;
      }
      
      public function set Value0(param1:uint) : void
      {
         this.FValue0 = param1;
      }
      
      public function get Value1() : uint
      {
         return this.FValue1;
      }
      
      public function set Value1(param1:uint) : void
      {
         this.FValue1 = param1;
      }
   }
}

