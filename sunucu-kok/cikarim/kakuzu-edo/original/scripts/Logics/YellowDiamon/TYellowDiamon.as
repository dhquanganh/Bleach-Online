package Logics.YellowDiamon
{
   public class TYellowDiamon
   {
      
      protected var FIFYellowDiamondUser:Boolean;
      
      protected var FIFYearYellowDiamondUser:Boolean;
      
      protected var FLevel:uint;
      
      protected var FIFReciveFreshGiftBag:Boolean;
      
      protected var FIFReciveDailyGiftBag:Boolean;
      
      protected var FIFReciveYearDailyGiftBag:Boolean;
      
      protected var FIFReciveYearFreshGiftBag:Boolean;
      
      protected var FGrowUpGiftBagState:uint;
      
      protected var FLevelGiftBagState:uint;
      
      public function TYellowDiamon()
      {
         super();
      }
      
      public function get IFYellowDiamondUser() : Boolean
      {
         return this.FIFYellowDiamondUser;
      }
      
      public function set IFYellowDiamondUser(param1:Boolean) : void
      {
         this.FIFYellowDiamondUser = param1;
      }
      
      public function get IFYearYellowDiamondUser() : Boolean
      {
         return this.FIFYearYellowDiamondUser;
      }
      
      public function set IFYearYellowDiamondUser(param1:Boolean) : void
      {
         this.FIFYearYellowDiamondUser = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get IFReciveFreshGiftBag() : Boolean
      {
         return this.FIFReciveFreshGiftBag;
      }
      
      public function set IFReciveFreshGiftBag(param1:Boolean) : void
      {
         this.FIFReciveFreshGiftBag = param1;
      }
      
      public function get IFReciveDailyGiftBag() : Boolean
      {
         return this.FIFReciveDailyGiftBag;
      }
      
      public function set IFReciveDailyGiftBag(param1:Boolean) : void
      {
         this.FIFReciveDailyGiftBag = param1;
      }
      
      public function get GrowUpGiftBagState() : uint
      {
         return this.FGrowUpGiftBagState;
      }
      
      public function set GrowUpGiftBagState(param1:uint) : void
      {
         this.FGrowUpGiftBagState = param1;
      }
      
      public function get LevelGiftBagState() : uint
      {
         return this.FLevelGiftBagState;
      }
      
      public function set LevelGiftBagState(param1:uint) : void
      {
         this.FLevelGiftBagState = param1;
      }
      
      public function get IFReciveYearDailyGiftBag() : Boolean
      {
         return this.FIFReciveYearDailyGiftBag;
      }
      
      public function set IFReciveYearDailyGiftBag(param1:Boolean) : void
      {
         this.FIFReciveYearDailyGiftBag = param1;
      }
      
      public function get IFReciveYearFreshGiftBag() : Boolean
      {
         return this.FIFReciveYearFreshGiftBag;
      }
      
      public function set IFReciveYearFreshGiftBag(param1:Boolean) : void
      {
         this.FIFReciveYearFreshGiftBag = param1;
      }
   }
}

