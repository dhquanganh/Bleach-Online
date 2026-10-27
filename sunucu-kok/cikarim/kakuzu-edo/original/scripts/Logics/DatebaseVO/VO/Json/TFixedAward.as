package Logics.DatebaseVO.VO.Json
{
   public class TFixedAward
   {
      
      protected var FType:uint;
      
      protected var FCode:uint;
      
      protected var FAmount:uint;
      
      public function TFixedAward(param1:Object)
      {
         super();
         this.FType = param1.type;
         this.FCode = param1.code;
         this.FAmount = param1.amount;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get Code() : uint
      {
         return this.FCode;
      }
      
      public function get Amount() : uint
      {
         return this.FAmount;
      }
   }
}

