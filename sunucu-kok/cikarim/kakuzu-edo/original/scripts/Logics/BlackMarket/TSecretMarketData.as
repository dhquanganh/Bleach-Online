package Logics.BlackMarket
{
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.Inventories.TInventories;
   
   public class TSecretMarketData
   {
      
      protected var FMarketID:uint;
      
      protected var FSecretMarketState:int;
      
      protected var FSecretMarketOpenTime:int;
      
      protected var FSecretMarketDurationTime:int;
      
      protected var FCurrentFlashTime:int;
      
      protected var FCurrentGoodBornTime:int;
      
      protected var FGoodsVec:Vector.<int>;
      
      protected var FBuiedTime:Vector.<int>;
      
      protected var FInited:Boolean;
      
      protected var FInventories:TInventories;
      
      protected var FConfigs:Vector.<TBlackMarket>;
      
      protected var FFlushCosts:Vector.<Object>;
      
      public function TSecretMarketData()
      {
         super();
         this.FGoodsVec = new Vector.<int>();
         this.FBuiedTime = new Vector.<int>();
         this.FInventories = new TInventories();
         this.FFlushCosts = new Vector.<Object>();
         this.FConfigs = new Vector.<TBlackMarket>();
      }
      
      public function get SecretMarketState() : int
      {
         return this.FSecretMarketState;
      }
      
      public function set SecretMarketState(param1:int) : void
      {
         this.FSecretMarketState = param1;
      }
      
      public function get SecretMarketOpenTime() : int
      {
         return this.FSecretMarketOpenTime;
      }
      
      public function set SecretMarketOpenTime(param1:int) : void
      {
         this.FSecretMarketOpenTime = param1;
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
      
      public function get SecretMarketDurationTime() : int
      {
         return this.FSecretMarketDurationTime;
      }
      
      public function set SecretMarketDurationTime(param1:int) : void
      {
         this.FSecretMarketDurationTime = param1;
      }
   }
}

