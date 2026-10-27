package Logics.DatebaseVO.VO.Json
{
   public class TAddOther
   {
      
      protected var FType:int;
      
      protected var FValue:String;
      
      public function TAddOther(param1:Object)
      {
         super();
         this.FType = param1.type;
         this.FValue = param1.value;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
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

