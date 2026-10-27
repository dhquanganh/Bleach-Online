package Logics.HDHalloween2016
{
   import Logics.DatebaseVO.VO.THDHalloweenShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class THalloweenShop extends TActivityOSBase
   {
      
      protected var FShopStatus:Vector.<int>;
      
      protected var FShop:TInventories;
      
      protected var FScore:int;
      
      protected var FCurItemsIndex:Vector.<int>;
      
      protected var FCurPos:int;
      
      protected var FCurItemsStatus:Vector.<int>;
      
      protected var FItemsStatus:Vector.<int>;
      
      protected var FConfig:THDHalloweenShop;
      
      public function THalloweenShop()
      {
         super();
         this.FShop = new TInventories();
         this.FCurItemsIndex = new Vector.<int>(8);
      }
      
      public function get ShopStatus() : Vector.<int>
      {
         return this.FShopStatus;
      }
      
      public function set ShopStatus(param1:Vector.<int>) : void
      {
         this.FShopStatus = param1;
      }
      
      public function get Shop() : TInventories
      {
         return this.FShop;
      }
      
      public function set Shop(param1:TInventories) : void
      {
         this.FShop = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
      
      public function get CurItemsIndex() : Vector.<int>
      {
         return this.FCurItemsIndex;
      }
      
      public function set CurItemsIndex(param1:Vector.<int>) : void
      {
         this.FCurItemsIndex = param1;
      }
      
      public function get CurItemsStatus() : Vector.<int>
      {
         return this.FCurItemsStatus;
      }
      
      public function set CurItemsStatus(param1:Vector.<int>) : void
      {
         this.FCurItemsStatus = param1;
      }
      
      public function get Config() : THDHalloweenShop
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDHalloweenShop) : void
      {
         this.FConfig = param1;
      }
      
      public function get CurPos() : int
      {
         return this.FCurPos;
      }
      
      public function set CurPos(param1:int) : void
      {
         this.FCurPos = param1;
      }
      
      public function GetCurItemsInfo() : Vector.<Object>
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:TInventories = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = 8;
         _loc2_ = new Vector.<Object>(_loc4_);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = new Object();
            _loc3_ = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.CurItemsIndex[_loc5_] - 1].award,_loc3_);
            _loc1_.inv = _loc3_.GetInventoryByIndex(0);
            _loc2_[_loc5_] = _loc1_;
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

