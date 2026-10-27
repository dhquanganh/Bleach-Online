package Logics.Streamization.HDActivityNewHalloween.ConsumeVo
{
   import Logics.Inventories.TInventories;
   
   public class TCandyShopVo
   {
      
      private var FInventories:TInventories;
      
      private var FGold:int;
      
      private var FIndex:int;
      
      private var FName:String;
      
      private var FIsDiscount:Boolean;
      
      private var FCondition:int;
      
      private var FMinus:int;
      
      private var FShopCartAmount:int;
      
      public function TCandyShopVo()
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
      
      public function get IsDiscount() : Boolean
      {
         return this.FIsDiscount;
      }
      
      public function set IsDiscount(param1:Boolean) : void
      {
         this.FIsDiscount = param1;
      }
      
      public function get ShopCartAmount() : int
      {
         return this.FShopCartAmount;
      }
      
      public function set ShopCartAmount(param1:int) : void
      {
         this.FShopCartAmount = param1;
      }
      
      public function get Condition() : int
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:int) : void
      {
         this.FCondition = param1;
      }
      
      public function get Minus() : int
      {
         return this.FMinus;
      }
      
      public function set Minus(param1:int) : void
      {
         this.FMinus = param1;
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

