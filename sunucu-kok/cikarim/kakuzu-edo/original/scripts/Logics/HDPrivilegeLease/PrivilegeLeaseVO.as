package Logics.HDPrivilegeLease
{
   import Logics.Characters.THero;
   
   public class PrivilegeLeaseVO
   {
      
      protected var FHeroState:int;
      
      protected var FHeroId:int;
      
      protected var FIndex:int;
      
      protected var FPriceA:int;
      
      protected var FPriceB:int;
      
      protected var FPriceC:int;
      
      protected var FPriceD:int;
      
      protected var FDayA:int;
      
      protected var FDayB:int;
      
      protected var FDayC:int;
      
      protected var FDayD:int;
      
      protected var FHero:THero;
      
      public function PrivilegeLeaseVO()
      {
         super();
      }
      
      public function set HeroState(param1:int) : void
      {
         this.FHeroState = param1;
      }
      
      public function get HeroState() : int
      {
         return this.FHeroState;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set PriceA(param1:int) : void
      {
         this.FPriceA = param1;
      }
      
      public function get PriceA() : int
      {
         return this.FPriceA;
      }
      
      public function set PriceB(param1:int) : void
      {
         this.FPriceB = param1;
      }
      
      public function get PriceB() : int
      {
         return this.FPriceB;
      }
      
      public function set PriceC(param1:int) : void
      {
         this.FPriceC = param1;
      }
      
      public function get PriceC() : int
      {
         return this.FPriceC;
      }
      
      public function set PriceD(param1:int) : void
      {
         this.FPriceD = param1;
      }
      
      public function get PriceD() : int
      {
         return this.FPriceD;
      }
      
      public function set DayA(param1:int) : void
      {
         this.FDayA = param1;
      }
      
      public function get DayA() : int
      {
         return this.FDayA;
      }
      
      public function set DayB(param1:int) : void
      {
         this.FDayB = param1;
      }
      
      public function get DayB() : int
      {
         return this.FDayB;
      }
      
      public function set DayC(param1:int) : void
      {
         this.FDayC = param1;
      }
      
      public function get DayC() : int
      {
         return this.FDayC;
      }
      
      public function set DayD(param1:int) : void
      {
         this.FDayD = param1;
      }
      
      public function get DayD() : int
      {
         return this.FDayD;
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
      }
      
      public function get Hero() : THero
      {
         return this.FHero;
      }
   }
}

