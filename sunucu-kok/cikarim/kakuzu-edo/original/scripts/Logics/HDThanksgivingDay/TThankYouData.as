package Logics.HDThanksgivingDay
{
   import Logics.DatebaseVO.VO.THDThankYou;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TThankYouData extends TActivityOSBase
   {
      
      protected var FOnlineDay:uint;
      
      protected var FWitnessKeys:int;
      
      protected var FGrowthKeys:int;
      
      protected var FVipKeys:int;
      
      protected var FSuperVipKeys:int;
      
      protected var FConfig:THDThankYou;
      
      public function TThankYouData()
      {
         super();
      }
      
      public function get WitnessKeys() : int
      {
         return this.FWitnessKeys;
      }
      
      public function set WitnessKeys(param1:int) : void
      {
         this.FWitnessKeys = param1;
      }
      
      public function get GrowthKeys() : int
      {
         return this.FGrowthKeys;
      }
      
      public function set GrowthKeys(param1:int) : void
      {
         this.FGrowthKeys = param1;
      }
      
      public function get OnlineDay() : uint
      {
         return this.FOnlineDay;
      }
      
      public function set OnlineDay(param1:uint) : void
      {
         this.FOnlineDay = param1;
      }
      
      public function get VipKeys() : int
      {
         return this.FVipKeys;
      }
      
      public function set VipKeys(param1:int) : void
      {
         this.FVipKeys = param1;
      }
      
      public function get SuperVipKeys() : int
      {
         return this.FSuperVipKeys;
      }
      
      public function set SuperVipKeys(param1:int) : void
      {
         this.FSuperVipKeys = param1;
      }
      
      public function get Config() : THDThankYou
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDThankYou) : void
      {
         this.FConfig = param1;
      }
   }
}

