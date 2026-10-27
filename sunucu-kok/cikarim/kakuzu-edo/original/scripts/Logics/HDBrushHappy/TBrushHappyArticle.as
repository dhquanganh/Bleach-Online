package Logics.HDBrushHappy
{
   import Logics.Inventories.TInventory;
   
   public class TBrushHappyArticle
   {
      
      protected var FInitPrice:uint;
      
      protected var FCurPrice:uint;
      
      protected var FCurDiscount:uint;
      
      protected var FMinDiscount:uint;
      
      protected var FDiscountGold:uint;
      
      protected var FArticle:TInventory;
      
      protected var FBuyed:Boolean;
      
      protected var FAwardID:uint;
      
      public function TBrushHappyArticle()
      {
         super();
      }
      
      public function get InitPrice() : uint
      {
         return this.FInitPrice;
      }
      
      public function set InitPrice(param1:uint) : void
      {
         this.FInitPrice = param1;
      }
      
      public function get CurPrice() : uint
      {
         return this.FCurPrice;
      }
      
      public function set CurPrice(param1:uint) : void
      {
         this.FCurPrice = param1;
      }
      
      public function get CurDiscount() : uint
      {
         return this.FCurDiscount;
      }
      
      public function set CurDiscount(param1:uint) : void
      {
         this.FCurDiscount = param1;
      }
      
      public function get MinDiscount() : uint
      {
         return this.FMinDiscount;
      }
      
      public function set MinDiscount(param1:uint) : void
      {
         this.FMinDiscount = param1;
      }
      
      public function get Article() : TInventory
      {
         return this.FArticle;
      }
      
      public function set Article(param1:TInventory) : void
      {
         this.FArticle = param1;
      }
      
      public function get Buyed() : Boolean
      {
         return this.FBuyed;
      }
      
      public function set Buyed(param1:Boolean) : void
      {
         this.FBuyed = param1;
      }
      
      public function get DiscountGold() : uint
      {
         return this.FDiscountGold;
      }
      
      public function set DiscountGold(param1:uint) : void
      {
         this.FDiscountGold = param1;
      }
      
      public function get AwardID() : uint
      {
         return this.FAwardID;
      }
      
      public function set AwardID(param1:uint) : void
      {
         this.FAwardID = param1;
      }
   }
}

