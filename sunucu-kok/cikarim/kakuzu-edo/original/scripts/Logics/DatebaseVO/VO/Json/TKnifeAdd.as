package Logics.DatebaseVO.VO.Json
{
   public class TKnifeAdd
   {
      
      protected var FType:int;
      
      protected var FValue:Number;
      
      public function TKnifeAdd(param1:Object)
      {
         super();
         this.FType = param1.type;
         this.FValue = param1.value;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Value() : Number
      {
         return this.FValue;
      }
   }
}

