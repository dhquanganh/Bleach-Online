package Logics.HDNewYear2016
{
   import Logics.DatebaseVO.VO.THDNewYear2016Pocket;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2016Pocket extends TActivityOSBase
   {
      
      protected var FConfig:THDNewYear2016Pocket;
      
      protected var FRedLast:uint;
      
      protected var FRed:uint;
      
      protected var FCandy:uint;
      
      protected var FBigAwardStatus:int;
      
      protected var FBagsStatus:Vector.<int>;
      
      protected var FBagsID:Vector.<uint>;
      
      protected var FBagsBin:TInventories;
      
      protected var FShopStates:Vector.<int>;
      
      protected var FScoreShop:TInventories;
      
      protected var FIsReFlash:Boolean;
      
      public function TNewYear2016Pocket()
      {
         super();
         this.FBagsStatus = new Vector.<int>(15);
         this.FBagsID = new Vector.<uint>(15);
         this.FBagsBin = new TInventories();
         this.FShopStates = new Vector.<int>();
         this.FScoreShop = new TInventories();
      }
      
      public function get Config() : THDNewYear2016Pocket
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2016Pocket) : void
      {
         this.FConfig = param1;
      }
      
      public function get RedLast() : uint
      {
         return this.FRedLast;
      }
      
      public function set RedLast(param1:uint) : void
      {
         this.FRedLast = param1;
      }
      
      public function get Red() : uint
      {
         return this.FRed;
      }
      
      public function set Red(param1:uint) : void
      {
         this.FRed = param1;
      }
      
      public function get Candy() : uint
      {
         return this.FCandy;
      }
      
      public function set Candy(param1:uint) : void
      {
         this.FCandy = param1;
      }
      
      public function get BagsStatus() : Vector.<int>
      {
         return this.FBagsStatus;
      }
      
      public function set BagsStatus(param1:Vector.<int>) : void
      {
         this.FBagsStatus = param1;
      }
      
      public function get BigAwardStatus() : int
      {
         return this.FBigAwardStatus;
      }
      
      public function set BigAwardStatus(param1:int) : void
      {
         this.FBigAwardStatus = param1;
      }
      
      public function get BagsID() : Vector.<uint>
      {
         return this.FBagsID;
      }
      
      public function set BagsID(param1:Vector.<uint>) : void
      {
         this.FBagsID = param1;
      }
      
      public function get BagsBin() : TInventories
      {
         return this.BagsBin;
      }
      
      public function set BagsBin(param1:TInventories) : void
      {
         this.BagsBin = param1;
      }
      
      public function get ShopStates() : Vector.<int>
      {
         return this.FShopStates;
      }
      
      public function set ShopStates(param1:Vector.<int>) : void
      {
         this.FShopStates = param1;
      }
      
      public function get ScoreShop() : TInventories
      {
         return this.FScoreShop;
      }
      
      public function set ScoreShop(param1:TInventories) : void
      {
         this.FScoreShop = param1;
      }
      
      public function get IsReFlash() : Boolean
      {
         return this.FIsReFlash;
      }
      
      public function set IsReFlash(param1:Boolean) : void
      {
         this.FIsReFlash = param1;
      }
   }
}

