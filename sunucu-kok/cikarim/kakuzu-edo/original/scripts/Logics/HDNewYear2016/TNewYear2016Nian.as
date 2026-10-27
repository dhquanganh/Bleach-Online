package Logics.HDNewYear2016
{
   import Logics.DatebaseVO.VO.THDNewYear2016Nian;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2016Nian extends TActivityOSBase
   {
      
      protected var FOnceBagsStatus:Vector.<int>;
      
      protected var FDailyBagsStatus:Vector.<int>;
      
      protected var FArrowNum:uint;
      
      protected var FAllRecharge:uint;
      
      protected var FDailyRecharge:uint;
      
      protected var FPetStatus:int;
      
      protected var FOnceBags:Vector.<TInventories>;
      
      protected var FOnceRndBags:Vector.<TInventories>;
      
      protected var FDaysBags:Vector.<TInventories>;
      
      protected var FNianBags:TInventories;
      
      protected var FConfig:THDNewYear2016Nian;
      
      public function TNewYear2016Nian()
      {
         super();
         this.FOnceBagsStatus = new Vector.<int>();
         this.FDailyBagsStatus = new Vector.<int>();
         this.FOnceBags = new Vector.<TInventories>();
         this.FOnceRndBags = new Vector.<TInventories>();
         this.FDaysBags = new Vector.<TInventories>();
         this.FNianBags = new TInventories();
      }
      
      public function get OnceBagsStatus() : Vector.<int>
      {
         return this.FOnceBagsStatus;
      }
      
      public function set OnceBagsStatus(param1:Vector.<int>) : void
      {
         this.FOnceBagsStatus = param1;
      }
      
      public function get DailyBagsStatus() : Vector.<int>
      {
         return this.FDailyBagsStatus;
      }
      
      public function set DailyBagsStatus(param1:Vector.<int>) : void
      {
         this.FDailyBagsStatus = param1;
      }
      
      public function get ArrowNum() : uint
      {
         return this.FArrowNum;
      }
      
      public function set ArrowNum(param1:uint) : void
      {
         this.FArrowNum = param1;
      }
      
      public function get AllRecharge() : uint
      {
         return this.FAllRecharge;
      }
      
      public function set AllRecharge(param1:uint) : void
      {
         this.FAllRecharge = param1;
      }
      
      public function get DailyRecharge() : uint
      {
         return this.FDailyRecharge;
      }
      
      public function set DailyRecharge(param1:uint) : void
      {
         this.FDailyRecharge = param1;
      }
      
      public function get PetStatus() : int
      {
         return this.FPetStatus;
      }
      
      public function set PetStatus(param1:int) : void
      {
         this.FPetStatus = param1;
      }
      
      public function get OnceBags() : Vector.<TInventories>
      {
         return this.FOnceBags;
      }
      
      public function set OnceBags(param1:Vector.<TInventories>) : void
      {
         this.FOnceBags = param1;
      }
      
      public function get DaysBags() : Vector.<TInventories>
      {
         return this.FDaysBags;
      }
      
      public function set DaysBags(param1:Vector.<TInventories>) : void
      {
         this.FDaysBags = param1;
      }
      
      public function get NianBags() : TInventories
      {
         return this.FNianBags;
      }
      
      public function set NianBags(param1:TInventories) : void
      {
         this.FNianBags = param1;
      }
      
      public function get Config() : THDNewYear2016Nian
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2016Nian) : void
      {
         this.FConfig = param1;
      }
      
      public function get OnceRndBags() : Vector.<TInventories>
      {
         return this.FOnceRndBags;
      }
      
      public function set OnceRndBags(param1:Vector.<TInventories>) : void
      {
         this.FOnceRndBags = param1;
      }
   }
}

