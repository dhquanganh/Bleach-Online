package Logics.HDChristmas.VO
{
   import Logics.Inventories.TInventories;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   
   public class TCarnivalRandomItemVO extends TTypeCodeAmount
   {
      
      protected var FDiscount:Number;
      
      protected var FCost:uint;
      
      protected var FDiscountCost:uint;
      
      protected var FRefreshCount:uint;
      
      protected var FName:String;
      
      protected var FBuyed:Boolean;
      
      protected var FIsMinDiscount:Boolean;
      
      protected var FInventories:TInventories;
      
      protected var FMindiscount:Number;
      
      protected var FFrame:int;
      
      public function TCarnivalRandomItemVO()
      {
         super();
      }
      
      public function get Discount() : Number
      {
         return this.FDiscount;
      }
      
      public function set Discount(param1:Number) : void
      {
         this.FDiscount = param1;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get RefreshCount() : uint
      {
         return this.FRefreshCount;
      }
      
      public function set RefreshCount(param1:uint) : void
      {
         this.FRefreshCount = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get DiscountCost() : uint
      {
         return this.FDiscountCost;
      }
      
      public function set DiscountCost(param1:uint) : void
      {
         this.FDiscountCost = param1;
      }
      
      public function get Buyed() : Boolean
      {
         return this.FBuyed;
      }
      
      public function set Buyed(param1:Boolean) : void
      {
         this.FBuyed = param1;
      }
      
      public function get IsMinDiscount() : Boolean
      {
         return this.FIsMinDiscount;
      }
      
      public function set IsMinDiscount(param1:Boolean) : void
      {
         this.FIsMinDiscount = param1;
      }
      
      public function get Mindiscount() : Number
      {
         return this.FMindiscount;
      }
      
      public function set Mindiscount(param1:Number) : void
      {
         this.FMindiscount = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Frame() : int
      {
         return this.FFrame;
      }
      
      public function set Frame(param1:int) : void
      {
         this.FFrame = param1;
      }
   }
}

