package Logics.HDActivityEquipmentShop
{
   public class TRateData
   {
      
      protected var FRate:uint;
      
      protected var FAmount:uint;
      
      public function TRateData()
      {
         super();
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function set Rate(param1:uint) : void
      {
         this.FRate = param1;
      }
      
      public function get Amount() : uint
      {
         return this.FAmount;
      }
      
      public function set Amount(param1:uint) : void
      {
         this.FAmount = param1;
      }
   }
}

