package Logics.HDNewYear2016
{
   import Logics.DatebaseVO.VO.THDNewYear2016Chess;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2016Chess extends TActivityOSBase
   {
      
      protected var FCurPos:uint;
      
      protected var FScore:uint;
      
      protected var FShopStatus:Vector.<int>;
      
      protected var FJackStatus:int;
      
      protected var FTime:uint;
      
      protected var FAwards:Vector.<TInventories>;
      
      protected var FAwardShow:TInventories;
      
      protected var FScoreShop:TInventories;
      
      protected var FConfig:THDNewYear2016Chess;
      
      public function TNewYear2016Chess()
      {
         super();
         this.FShopStatus = new Vector.<int>();
         this.FAwards = new Vector.<TInventories>();
         this.FScoreShop = new TInventories();
         this.FAwardShow = new TInventories();
      }
      
      public function get CurPos() : uint
      {
         return this.FCurPos;
      }
      
      public function set CurPos(param1:uint) : void
      {
         this.FCurPos = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get Config() : THDNewYear2016Chess
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2016Chess) : void
      {
         this.FConfig = param1;
      }
      
      public function get ShopStatus() : Vector.<int>
      {
         return this.FShopStatus;
      }
      
      public function set ShopStatus(param1:Vector.<int>) : void
      {
         this.FShopStatus = param1;
      }
      
      public function get JackStatus() : int
      {
         return this.FJackStatus;
      }
      
      public function set JackStatus(param1:int) : void
      {
         this.FJackStatus = param1;
      }
      
      public function get ScoreShop() : TInventories
      {
         return this.FScoreShop;
      }
      
      public function set ScoreShop(param1:TInventories) : void
      {
         this.FScoreShop = param1;
      }
      
      public function get Awards() : Vector.<TInventories>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<TInventories>) : void
      {
         this.FAwards = param1;
      }
      
      public function get AwardShow() : TInventories
      {
         return this.FAwardShow;
      }
      
      public function set AwardShow(param1:TInventories) : void
      {
         this.FAwardShow = param1;
      }
   }
}

