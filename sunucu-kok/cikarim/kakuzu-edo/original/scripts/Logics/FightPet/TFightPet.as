package Logics.FightPet
{
   import Foundation.Common.Integer.UInt64;
   
   public class TFightPet
   {
      
      protected var FMainPlayerDamage:UInt64;
      
      protected var FTopTenRank:Vector.<TFightPetRank>;
      
      protected var FMonsterID:uint;
      
      protected var FMonsterHP:uint;
      
      protected var FMonsterTotaleHP:uint;
      
      protected var FMonsterName:String;
      
      protected var FMonsterLV:uint;
      
      protected var FMonsterModleID:uint;
      
      protected var FCDTime:uint;
      
      protected var FInspireCount:uint;
      
      protected var FIsDie:Boolean;
      
      protected var FAllplayerCount:uint;
      
      protected var FGameOver:Boolean;
      
      protected var FTotalCD:uint;
      
      protected var FReviveTimes:uint;
      
      public function TFightPet()
      {
         super();
         this.FTopTenRank = new Vector.<TFightPetRank>();
         this.FMainPlayerDamage = new UInt64();
      }
      
      public function get MainPlayerDamage() : UInt64
      {
         return this.FMainPlayerDamage;
      }
      
      public function set MainPlayerDamage(param1:UInt64) : void
      {
         this.FMainPlayerDamage = param1;
      }
      
      public function get TopTenRank() : Vector.<TFightPetRank>
      {
         return this.FTopTenRank;
      }
      
      public function set TopTenRank(param1:Vector.<TFightPetRank>) : void
      {
         this.FTopTenRank = param1;
      }
      
      public function get MonsterHP() : uint
      {
         return this.FMonsterHP;
      }
      
      public function set MonsterHP(param1:uint) : void
      {
         this.FMonsterHP = param1;
      }
      
      public function get MonsterName() : String
      {
         return this.FMonsterName;
      }
      
      public function set MonsterName(param1:String) : void
      {
         this.FMonsterName = param1;
      }
      
      public function get CDTime() : uint
      {
         return this.FCDTime;
      }
      
      public function set CDTime(param1:uint) : void
      {
         this.FCDTime = param1;
      }
      
      public function get InspireCount() : uint
      {
         return this.FInspireCount;
      }
      
      public function set InspireCount(param1:uint) : void
      {
         this.FInspireCount = param1;
      }
      
      public function get MonsterID() : uint
      {
         return this.FMonsterID;
      }
      
      public function set MonsterID(param1:uint) : void
      {
         this.FMonsterID = param1;
      }
      
      public function get MonsterTotaleHP() : uint
      {
         return this.FMonsterTotaleHP;
      }
      
      public function set MonsterTotaleHP(param1:uint) : void
      {
         this.FMonsterTotaleHP = param1;
      }
      
      public function get MonsterLV() : uint
      {
         return this.FMonsterLV;
      }
      
      public function set MonsterLV(param1:uint) : void
      {
         this.FMonsterLV = param1;
      }
      
      public function get IsDie() : Boolean
      {
         return this.FIsDie;
      }
      
      public function set IsDie(param1:Boolean) : void
      {
         this.FIsDie = param1;
      }
      
      public function get AllplayerCount() : uint
      {
         return this.FAllplayerCount;
      }
      
      public function set AllplayerCount(param1:uint) : void
      {
         this.FAllplayerCount = param1;
      }
      
      public function get GameOver() : Boolean
      {
         return this.FGameOver;
      }
      
      public function set GameOver(param1:Boolean) : void
      {
         this.FGameOver = param1;
      }
      
      public function get TotalCD() : uint
      {
         return this.FTotalCD;
      }
      
      public function set TotalCD(param1:uint) : void
      {
         this.FTotalCD = param1;
      }
      
      public function get MonsterModleID() : uint
      {
         return this.FMonsterModleID;
      }
      
      public function set MonsterModleID(param1:uint) : void
      {
         this.FMonsterModleID = param1;
      }
      
      public function get ReviveTimes() : uint
      {
         return this.FReviveTimes;
      }
      
      public function set ReviveTimes(param1:uint) : void
      {
         this.FReviveTimes = param1;
      }
      
      public function ClearRankList() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TFightPetRank = null;
         _loc1_ = int(this.FTopTenRank.length);
         while(_loc1_ > 0)
         {
            _loc2_ = this.FTopTenRank[_loc1_ - 1];
            _loc2_ = null;
            this.FTopTenRank.pop();
            _loc1_--;
         }
      }
   }
}

