package Logics.SuperMarket
{
   public class TSuperMarketData
   {
      
      protected var FAlreadyBuySuitID:uint;
      
      protected var FAlreadyBuyArmID:uint;
      
      protected var FAlreadyBuyEquipID:Vector.<uint>;
      
      protected var FLoadCompelet:Boolean;
      
      public function TSuperMarketData()
      {
         super();
         this.FAlreadyBuyEquipID = new Vector.<uint>();
      }
      
      public function get AlreadyBuySuitID() : uint
      {
         return this.FAlreadyBuySuitID;
      }
      
      public function set AlreadyBuySuitID(param1:uint) : void
      {
         this.FAlreadyBuySuitID = param1;
      }
      
      public function get AlreadyBuyArmID() : uint
      {
         return this.FAlreadyBuyArmID;
      }
      
      public function set AlreadyBuyArmID(param1:uint) : void
      {
         this.FAlreadyBuyArmID = param1;
      }
      
      public function get LoadCompelet() : Boolean
      {
         return this.FLoadCompelet;
      }
      
      public function set LoadCompelet(param1:Boolean) : void
      {
         this.FLoadCompelet = param1;
      }
      
      public function get AlreadyBuyEquipID() : Vector.<uint>
      {
         return this.FAlreadyBuyEquipID;
      }
   }
}

