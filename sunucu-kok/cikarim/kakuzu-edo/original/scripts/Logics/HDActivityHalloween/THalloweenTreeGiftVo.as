package Logics.HDActivityHalloween
{
   import Logics.Inventories.TInventories;
   
   public class THalloweenTreeGiftVo
   {
      
      protected var FGetAwardExp:int;
      
      protected var FCurrentGiftState:int;
      
      protected var FAwardId:int;
      
      protected var FInventories:TInventories;
      
      public function THalloweenTreeGiftVo()
      {
         super();
      }
      
      public function get GetAwardExp() : int
      {
         return this.FGetAwardExp;
      }
      
      public function set GetAwardExp(param1:int) : void
      {
         this.FGetAwardExp = param1;
      }
      
      public function get CurrentGiftState() : int
      {
         return this.FCurrentGiftState;
      }
      
      public function set CurrentGiftState(param1:int) : void
      {
         this.FCurrentGiftState = param1;
      }
      
      public function get AwardId() : int
      {
         return this.FAwardId;
      }
      
      public function set AwardId(param1:int) : void
      {
         this.FAwardId = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
   }
}

