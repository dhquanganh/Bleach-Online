package Logics.TypeCodeAmount
{
   public class TTypeCodeAmount
   {
      
      protected var FType:int;
      
      protected var FCode:int;
      
      protected var FAmount:int;
      
      public function TTypeCodeAmount()
      {
         super();
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get Code() : int
      {
         return this.FCode;
      }
      
      public function set Code(param1:int) : void
      {
         this.FCode = param1;
      }
      
      public function get Amount() : int
      {
         return this.FAmount;
      }
      
      public function set Amount(param1:int) : void
      {
         this.FAmount = param1;
      }
   }
}

