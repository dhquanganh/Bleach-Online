package Logics.Organization.VO
{
   import Logics.DatebaseVO.VO.TBlackMarket;
   
   public class TOrgShopCommodityItemVO
   {
      
      protected var FType:uint;
      
      protected var FBuyCount:uint;
      
      protected var FName:String;
      
      protected var FMarket:TBlackMarket;
      
      public function TOrgShopCommodityItemVO()
      {
         super();
         this.FType = 1;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get BuyCount() : uint
      {
         return this.FBuyCount;
      }
      
      public function set BuyCount(param1:uint) : void
      {
         this.FBuyCount = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Market() : TBlackMarket
      {
         return this.FMarket;
      }
      
      public function set Market(param1:TBlackMarket) : void
      {
         this.FMarket = param1;
      }
   }
}

