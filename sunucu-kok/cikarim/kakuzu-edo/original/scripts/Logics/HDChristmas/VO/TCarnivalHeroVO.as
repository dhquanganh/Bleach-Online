package Logics.HDChristmas.VO
{
   import Logics.DatebaseVO.VO.TBaseHero;
   
   public class TCarnivalHeroVO
   {
      
      protected var FHero:TBaseHero;
      
      protected var FDiscount:Number;
      
      protected var FCost:uint;
      
      protected var FDiscountCost:uint;
      
      protected var FRefreshCount:uint;
      
      protected var FExchangeed:Boolean;
      
      protected var FIsMinDiscount:Boolean;
      
      public function TCarnivalHeroVO()
      {
         super();
      }
      
      public function get Hero() : TBaseHero
      {
         return this.FHero;
      }
      
      public function set Hero(param1:TBaseHero) : void
      {
         this.FHero = param1;
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
      
      public function get DiscountCost() : uint
      {
         return this.FDiscountCost;
      }
      
      public function set DiscountCost(param1:uint) : void
      {
         this.FDiscountCost = param1;
      }
      
      public function get RefreshCount() : uint
      {
         return this.FRefreshCount;
      }
      
      public function set RefreshCount(param1:uint) : void
      {
         this.FRefreshCount = param1;
      }
      
      public function get Exchangeed() : Boolean
      {
         return this.FExchangeed;
      }
      
      public function set Exchangeed(param1:Boolean) : void
      {
         this.FExchangeed = param1;
      }
      
      public function get IsMinDiscount() : Boolean
      {
         return this.FIsMinDiscount;
      }
      
      public function set IsMinDiscount(param1:Boolean) : void
      {
         this.FIsMinDiscount = param1;
      }
   }
}

