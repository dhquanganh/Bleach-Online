package Logics.HDNewYearSheep.SendRedPacketVO
{
   import Logics.Inventories.TInventories;
   
   public class TFavornMarketExchangeVo
   {
      
      private var FInventories:TInventories;
      
      private var FNeedFavornValue:int;
      
      private var FLimitValue:int;
      
      private var FIndex:int;
      
      private var FBuyCount:int;
      
      public function TFavornMarketExchangeVo()
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
      
      public function get NeedFavornValue() : int
      {
         return this.FNeedFavornValue;
      }
      
      public function set NeedFavornValue(param1:int) : void
      {
         this.FNeedFavornValue = param1;
      }
      
      public function get LimitValue() : int
      {
         return this.FLimitValue;
      }
      
      public function set LimitValue(param1:int) : void
      {
         this.FLimitValue = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get BuyCount() : int
      {
         return this.FBuyCount;
      }
      
      public function set BuyCount(param1:int) : void
      {
         this.FBuyCount = param1;
      }
   }
}

