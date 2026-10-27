package Logics.Streamization.HDActivityNewHalloween.ConsumeVo
{
   import Logics.Inventories.TInventories;
   
   public class TPumpkinShopVo
   {
      
      private var FInventories:TInventories;
      
      private var FGold:int;
      
      private var FIndex:int;
      
      private var FName:String;
      
      private var FIsDouble:Boolean;
      
      private var FShopCartAmount:int;
      
      public function TPumpkinShopVo()
      {
         super();
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function set Gold(param1:int) : void
      {
         this.FGold = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get IsDouble() : Boolean
      {
         return this.FIsDouble;
      }
      
      public function set IsDouble(param1:Boolean) : void
      {
         this.FIsDouble = param1;
      }
      
      public function get ShopCartAmount() : int
      {
         return this.FShopCartAmount;
      }
      
      public function set ShopCartAmount(param1:int) : void
      {
         this.FShopCartAmount = param1;
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

