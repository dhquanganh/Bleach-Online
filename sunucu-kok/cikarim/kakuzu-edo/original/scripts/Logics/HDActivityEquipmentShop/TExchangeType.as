package Logics.HDActivityEquipmentShop
{
   public class TExchangeType
   {
      
      protected var FType:uint;
      
      protected var FName:String;
      
      public function TExchangeType()
      {
         super();
         this.FName = "";
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
   }
}

