package Logics.VainTravel
{
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.Inventories.TInventories;
   
   public class TVainTravelShopData
   {
      
      protected var FCurrentFlashTime:int;
      
      protected var FCurrentGoodBornTime:int;
      
      protected var FGoodsVec:Vector.<int>;
      
      protected var FBuiedTime:Vector.<int>;
      
      protected var FFlushTime:Vector.<int>;
      
      protected var FInventories:TInventories;
      
      protected var FConfigs:Vector.<TBlackMarket>;
      
      protected var FFlushCosts:Vector.<Object>;
      
      protected var FRequestNewFlushTime:int;
      
      protected var FVainTravelCoin:int;
      
      public function TVainTravelShopData()
      {
         super();
         this.FGoodsVec = new Vector.<int>();
         this.FBuiedTime = new Vector.<int>();
         this.FFlushTime = new Vector.<int>();
         this.FInventories = new TInventories();
         this.FConfigs = new Vector.<TBlackMarket>();
      }
      
      public function get CurrentFlashTime() : int
      {
         return this.FCurrentFlashTime;
      }
      
      public function set CurrentFlashTime(param1:int) : void
      {
         this.FCurrentFlashTime = param1;
      }
      
      public function get GoodsVec() : Vector.<int>
      {
         return this.FGoodsVec;
      }
      
      public function get BuiedTime() : Vector.<int>
      {
         return this.FBuiedTime;
      }
      
      public function get FlushTime() : Vector.<int>
      {
         return this.FFlushTime;
      }
      
      public function set FlushTime(param1:Vector.<int>) : void
      {
         this.FFlushTime = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function get Configs() : Vector.<TBlackMarket>
      {
         return this.FConfigs;
      }
      
      public function get FlushCosts() : Vector.<Object>
      {
         return this.FFlushCosts;
      }
      
      public function set FlushCosts(param1:Vector.<Object>) : void
      {
         this.FFlushCosts = param1;
      }
      
      public function get CurrentGoodBornTime() : int
      {
         return this.FCurrentGoodBornTime;
      }
      
      public function set CurrentGoodBornTime(param1:int) : void
      {
         this.FCurrentGoodBornTime = param1;
      }
      
      public function get RequestNewFlushTime() : int
      {
         return this.FRequestNewFlushTime;
      }
      
      public function set RequestNewFlushTime(param1:int) : void
      {
         this.FRequestNewFlushTime = param1;
      }
      
      public function get VainTravelCoin() : int
      {
         return this.FVainTravelCoin;
      }
      
      public function set VainTravelCoin(param1:int) : void
      {
         this.FVainTravelCoin = param1;
      }
   }
}

