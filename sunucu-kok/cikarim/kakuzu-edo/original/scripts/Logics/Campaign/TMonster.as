package Logics.Campaign
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TMonster extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIndex:int;
      
      protected var FIsChar:Boolean;
      
      protected var FMonsterPos:int;
      
      protected var FMonsterLevel:int;
      
      protected var FMonsterHealth:int;
      
      protected var FMonsterCount:int;
      
      public function TMonster(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get IsChar() : Boolean
      {
         return this.FIsChar;
      }
      
      public function set IsChar(param1:Boolean) : void
      {
         this.FIsChar = param1;
      }
      
      public function get MonsterPos() : int
      {
         return this.FMonsterPos;
      }
      
      public function set MonsterPos(param1:int) : void
      {
         this.FMonsterPos = param1;
      }
      
      public function get MonsterLevel() : int
      {
         return this.FMonsterLevel;
      }
      
      public function set MonsterLevel(param1:int) : void
      {
         this.FMonsterLevel = param1;
      }
      
      public function get MonsterHealth() : int
      {
         return this.FMonsterHealth;
      }
      
      public function set MonsterHealth(param1:int) : void
      {
         this.FMonsterHealth = param1;
      }
      
      public function get MonsterCount() : int
      {
         return this.FMonsterCount;
      }
      
      public function set MonsterCount(param1:int) : void
      {
         this.FMonsterCount = param1;
      }
   }
}

