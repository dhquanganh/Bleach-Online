package Logics.HDEaster2016
{
   import Logics.DatebaseVO.VO.THDEaster2016_1;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class THDEasterData2016_1 extends TActivityOSBase
   {
      
      protected var FRound:uint;
      
      protected var FRechargeTaskStatus:Vector.<int>;
      
      protected var FConsumeTaskStatus:Vector.<int>;
      
      protected var FRechargeGiftStatus:Vector.<int>;
      
      protected var FConsumeGiftStatus:Vector.<int>;
      
      protected var FRechargeAwards:Vector.<TInventories>;
      
      protected var FConsunmeAwards:Vector.<TInventories>;
      
      protected var FJackPointStatus:int;
      
      protected var FConsumed:uint;
      
      protected var FHaveEgg01:uint;
      
      protected var FHaveEgg02:uint;
      
      protected var FHaveEgg03:uint;
      
      protected var FConfig:THDEaster2016_1;
      
      public function THDEasterData2016_1()
      {
         super();
         this.FRechargeTaskStatus = new Vector.<int>();
         this.FConsumeTaskStatus = new Vector.<int>();
         this.FRechargeGiftStatus = new Vector.<int>();
         this.FConsumeGiftStatus = new Vector.<int>();
         this.FRechargeAwards = new Vector.<TInventories>();
         this.FConsunmeAwards = new Vector.<TInventories>();
      }
      
      public function get Round() : uint
      {
         return this.FRound;
      }
      
      public function set Round(param1:uint) : void
      {
         this.FRound = param1;
      }
      
      public function get RechargeTaskStatus() : Vector.<int>
      {
         return this.FRechargeTaskStatus;
      }
      
      public function set RechargeTaskStatus(param1:Vector.<int>) : void
      {
         this.FRechargeTaskStatus = param1;
      }
      
      public function get ConsumeTaskStatus() : Vector.<int>
      {
         return this.FConsumeTaskStatus;
      }
      
      public function set ConsumeTaskStatus(param1:Vector.<int>) : void
      {
         this.FConsumeTaskStatus = param1;
      }
      
      public function get RechargeGiftStatus() : Vector.<int>
      {
         return this.FRechargeGiftStatus;
      }
      
      public function set RechargeGiftStatus(param1:Vector.<int>) : void
      {
         this.FRechargeGiftStatus = param1;
      }
      
      public function get ConsumeGiftStatus() : Vector.<int>
      {
         return this.FConsumeGiftStatus;
      }
      
      public function set ConsumeGiftStatus(param1:Vector.<int>) : void
      {
         this.FConsumeGiftStatus = param1;
      }
      
      public function get JackPointStatus() : int
      {
         return this.FJackPointStatus;
      }
      
      public function set JackPointStatus(param1:int) : void
      {
         this.FJackPointStatus = param1;
      }
      
      public function get Config() : THDEaster2016_1
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDEaster2016_1) : void
      {
         this.FConfig = param1;
      }
      
      public function get RechargeAwards() : Vector.<TInventories>
      {
         return this.FRechargeAwards;
      }
      
      public function set RechargeAwards(param1:Vector.<TInventories>) : void
      {
         this.FRechargeAwards = param1;
      }
      
      public function get ConsunmeAwards() : Vector.<TInventories>
      {
         return this.FConsunmeAwards;
      }
      
      public function set ConsunmeAwards(param1:Vector.<TInventories>) : void
      {
         this.FConsunmeAwards = param1;
      }
      
      public function get Consumed() : uint
      {
         return this.FConsumed;
      }
      
      public function set Consumed(param1:uint) : void
      {
         this.FConsumed = param1;
      }
      
      public function get HaveEgg02() : uint
      {
         return this.FHaveEgg02;
      }
      
      public function set HaveEgg02(param1:uint) : void
      {
         this.FHaveEgg02 = param1;
      }
      
      public function get HaveEgg03() : uint
      {
         return this.FHaveEgg03;
      }
      
      public function set HaveEgg03(param1:uint) : void
      {
         this.FHaveEgg03 = param1;
      }
      
      public function get HaveEgg01() : uint
      {
         return this.FHaveEgg01;
      }
      
      public function set HaveEgg01(param1:uint) : void
      {
         this.FHaveEgg01 = param1;
      }
   }
}

