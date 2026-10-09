package Logics.BlackMarket
{
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.Inventories.TInventories;
   
   public class TBlackMarketData
   {
      
      public var ServerRefreshSeconds:int = 0;
      protected var FMarketID:uint;
      
      protected var FCurrentFlashTime:int;
      
      protected var FCurrentGoodBornTime:int;
      
      protected var FGoodsVec:Vector.<int>;
      
      protected var FBuiedTime:Vector.<int>;
      
      protected var FFlushTime:Vector.<int>;
      
      protected var FInited:Boolean;
      
      protected var FInventories:TInventories;
      
      protected var FConfigs:Vector.<TBlackMarket>;
      
      protected var FFlushCosts:Vector.<Object>;
      
      protected var FRequestNewFlushTime:int;
      
      public function TBlackMarketData()
      {
         super();
         this.FGoodsVec = new Vector.<int>();
         this.FBuiedTime = new Vector.<int>();
         this.FInventories = new TInventories();
         this.FFlushCosts = new Vector.<Object>();
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
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
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
   }
}

