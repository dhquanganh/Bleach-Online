package Logics.HDThanksgivingDay
{
   import Logics.DatebaseVO.VO.THDThanksFeast;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TThanksFeastData extends TActivityOSBase
   {
      
      protected var FPuzzleKeys:int;
      
      protected var FPetKey:int;
      
      protected var FRechargeGold:uint;
      
      protected var FDailyRechargeGold:uint;
      
      protected var FDay:uint;
      
      protected var FAwardListKeys:int;
      
      protected var FConfig:THDThanksFeast;
      
      protected var FPuzzleInvs:Vector.<TInventories>;
      
      protected var FDailyGiftInvs:Vector.<TInventories>;
      
      public function TThanksFeastData()
      {
         super();
         this.FPuzzleInvs = new Vector.<TInventories>();
         this.FDailyGiftInvs = new Vector.<TInventories>();
      }
      
      public function get Config() : THDThanksFeast
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDThanksFeast) : void
      {
         this.FConfig = param1;
      }
      
      public function get PuzzleKeys() : int
      {
         return this.FPuzzleKeys;
      }
      
      public function set PuzzleKeys(param1:int) : void
      {
         this.FPuzzleKeys = param1;
      }
      
      public function get PetKey() : int
      {
         return this.FPetKey;
      }
      
      public function set PetKey(param1:int) : void
      {
         this.FPetKey = param1;
      }
      
      public function get RechargeGold() : uint
      {
         return this.FRechargeGold;
      }
      
      public function set RechargeGold(param1:uint) : void
      {
         this.FRechargeGold = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get AwardListKeys() : int
      {
         return this.FAwardListKeys;
      }
      
      public function set AwardListKeys(param1:int) : void
      {
         this.FAwardListKeys = param1;
      }
      
      public function get PuzzleInvs() : Vector.<TInventories>
      {
         return this.FPuzzleInvs;
      }
      
      public function get DailyGiftInvs() : Vector.<TInventories>
      {
         return this.FDailyGiftInvs;
      }
      
      public function get DailyRechargeGold() : uint
      {
         return this.FDailyRechargeGold;
      }
      
      public function set DailyRechargeGold(param1:uint) : void
      {
         this.FDailyRechargeGold = param1;
      }
   }
}

