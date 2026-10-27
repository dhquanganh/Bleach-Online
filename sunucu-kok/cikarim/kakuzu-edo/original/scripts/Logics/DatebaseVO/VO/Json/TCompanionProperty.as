package Logics.DatebaseVO.VO.Json
{
   public class TCompanionProperty
   {
      
      protected var FType:int;
      
      protected var FValue:Number;
      
      protected var FOper:int;
      
      protected var FPos:int;
      
      public function TCompanionProperty(param1:Object)
      {
         super();
         this.FType = param1.type;
         this.FValue = param1.value;
         this.FOper = param1.oper;
         this.FPos = param1.pos;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Value() : Number
      {
         return this.FValue;
      }
      
      public function set Value(param1:Number) : void
      {
         this.FValue = param1;
      }
      
      public function get Oper() : int
      {
         return this.FOper;
      }
      
      public function get Pos() : int
      {
         return this.FPos;
      }
   }
}

