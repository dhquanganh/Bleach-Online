package Logics.Affairs
{
   public class TAffairString extends TAffair
   {
      
      protected var FValue:String;
      
      public function TAffairString(param1:uint)
      {
         super(param1);
      }
      
      public function get Value() : String
      {
         return this.FValue;
      }
      
      public function set Value(param1:String) : void
      {
         this.FValue = param1;
      }
   }
}

