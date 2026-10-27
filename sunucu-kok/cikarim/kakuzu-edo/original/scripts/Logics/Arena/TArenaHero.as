package Logics.Arena
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TArenaHero extends TEntity64
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FCountry:uint;
      
      protected var FRanking:uint;
      
      protected var FMilitary:uint;
      
      protected var FHeroId:uint;
      
      protected var FPlayerNick:String;
      
      protected var FPlayerLevel:uint;
      
      public function TArenaHero(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Country() : uint
      {
         return this.FCountry;
      }
      
      public function set Country(param1:uint) : void
      {
         this.FCountry = param1;
      }
      
      public function get Ranking() : uint
      {
         return this.FRanking;
      }
      
      public function set Ranking(param1:uint) : void
      {
         this.FRanking = param1;
      }
      
      public function get Military() : uint
      {
         return this.FMilitary;
      }
      
      public function set Military(param1:uint) : void
      {
         this.FMilitary = param1;
      }
      
      public function get HeroId() : uint
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:uint) : void
      {
         this.FHeroId = param1;
      }
      
      public function get PlayerNick() : String
      {
         return this.FPlayerNick;
      }
      
      public function set PlayerNick(param1:String) : void
      {
         this.FPlayerNick = param1;
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:uint) : void
      {
         this.FPlayerLevel = param1;
      }
   }
}

