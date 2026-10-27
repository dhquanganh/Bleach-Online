package Logics.HDActivityCircleTrial
{
   import Logics.Inventories.TInventories;
   
   public class TCircleTrialAwardVo
   {
      
      protected var FGetAwardState:int;
      
      protected var FCurrentGetValue:int;
      
      protected var FTotalValue:int;
      
      protected var FAwardId:int;
      
      protected var FInventories:TInventories;
      
      protected var FIndex:int;
      
      protected var FHeroGiftName:String;
      
      protected var FEmployName:String;
      
      protected var FHeroId:int;
      
      protected var FUpHeroId:int;
      
      public function TCircleTrialAwardVo()
      {
         super();
      }
      
      public function get GetAwardState() : int
      {
         return this.FGetAwardState;
      }
      
      public function set GetAwardState(param1:int) : void
      {
         this.FGetAwardState = param1;
      }
      
      public function get CurrentGetValue() : int
      {
         return this.FCurrentGetValue;
      }
      
      public function set CurrentGetValue(param1:int) : void
      {
         this.FCurrentGetValue = param1;
      }
      
      public function get TotalValue() : int
      {
         return this.FTotalValue;
      }
      
      public function set TotalValue(param1:int) : void
      {
         this.FTotalValue = param1;
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
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get HeroGiftName() : String
      {
         return this.FHeroGiftName;
      }
      
      public function set HeroGiftName(param1:String) : void
      {
         this.FHeroGiftName = param1;
      }
      
      public function get EmployName() : String
      {
         return this.FEmployName;
      }
      
      public function set EmployName(param1:String) : void
      {
         this.FEmployName = param1;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function get UpHeroId() : int
      {
         return this.FUpHeroId;
      }
      
      public function set UpHeroId(param1:int) : void
      {
         this.FUpHeroId = param1;
      }
   }
}

