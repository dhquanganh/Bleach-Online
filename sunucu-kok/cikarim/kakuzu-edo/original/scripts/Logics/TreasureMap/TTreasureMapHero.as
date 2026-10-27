package Logics.TreasureMap
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TTreasureMapHero extends TEntity64
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FUserIndex:uint;
      
      protected var FHeroId:uint;
      
      protected var FPlayerNick:String;
      
      protected var FMilitary:uint;
      
      protected var FPlayerLevel:uint;
      
      protected var FHeroUnionName:String;
      
      protected var FIsGameWin:Boolean;
      
      protected var FLastTime:int;
      
      protected var FBeRobberyTimes:int;
      
      protected var FCurQuality:int;
      
      public function TTreasureMapHero(param1:uint, param2:uint)
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
      
      public function get UserIndex() : uint
      {
         return this.FUserIndex;
      }
      
      public function set UserIndex(param1:uint) : void
      {
         this.FUserIndex = param1;
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
      
      public function get Military() : uint
      {
         return this.FMilitary;
      }
      
      public function set Military(param1:uint) : void
      {
         this.FMilitary = param1;
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:uint) : void
      {
         this.FPlayerLevel = param1;
      }
      
      public function get HeroUnionName() : String
      {
         return this.FHeroUnionName;
      }
      
      public function set HeroUnionName(param1:String) : void
      {
         this.FHeroUnionName = param1;
      }
      
      public function get IsGameWin() : Boolean
      {
         return this.FIsGameWin;
      }
      
      public function set IsGameWin(param1:Boolean) : void
      {
         this.FIsGameWin = param1;
      }
      
      public function get LastTime() : int
      {
         return this.FLastTime;
      }
      
      public function set LastTime(param1:int) : void
      {
         this.FLastTime = param1;
      }
      
      public function get BeRobberyTimes() : int
      {
         return this.FBeRobberyTimes;
      }
      
      public function set BeRobberyTimes(param1:int) : void
      {
         this.FBeRobberyTimes = param1;
      }
      
      public function get CurQuality() : int
      {
         return this.FCurQuality;
      }
      
      public function set CurQuality(param1:int) : void
      {
         this.FCurQuality = param1;
      }
   }
}

