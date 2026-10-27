package Logics.TraitorAttack
{
   import flash.utils.Dictionary;
   
   public class TTraitorAttackData
   {
      
      protected var FCDTime:uint;
      
      protected var FEndTime:uint;
      
      protected var FCountdown:uint;
      
      protected var FCurWave:uint;
      
      protected var FEnterHeroCount:uint;
      
      protected var FResurrectionTimes:uint;
      
      protected var FScoreList:Vector.<int>;
      
      protected var FRankList:TTraitorAttackRankHeros;
      
      protected var FMonsterList:Dictionary;
      
      public function TTraitorAttackData()
      {
         super();
         this.FScoreList = new Vector.<int>(3);
         this.FRankList = new TTraitorAttackRankHeros();
         this.FMonsterList = new Dictionary();
         this.FCurWave = 1;
         this.FResurrectionTimes = 0;
      }
      
      public function get CDTime() : uint
      {
         return this.FCDTime;
      }
      
      public function set CDTime(param1:uint) : void
      {
         this.FCDTime = param1;
      }
      
      public function get EndTime() : uint
      {
         return this.FEndTime;
      }
      
      public function set EndTime(param1:uint) : void
      {
         this.FEndTime = param1;
      }
      
      public function get Countdown() : uint
      {
         return this.FCountdown;
      }
      
      public function set Countdown(param1:uint) : void
      {
         this.FCountdown = param1;
      }
      
      public function get CurWave() : uint
      {
         return this.FCurWave;
      }
      
      public function set CurWave(param1:uint) : void
      {
         this.FCurWave = param1;
      }
      
      public function get EnterHeroCount() : uint
      {
         return this.FEnterHeroCount;
      }
      
      public function set EnterHeroCount(param1:uint) : void
      {
         this.FEnterHeroCount = param1;
      }
      
      public function get ResurrectionTimes() : uint
      {
         return this.FResurrectionTimes;
      }
      
      public function set ResurrectionTimes(param1:uint) : void
      {
         this.FResurrectionTimes = param1;
      }
      
      public function get ScoreList() : Vector.<int>
      {
         return this.FScoreList;
      }
      
      public function set ScoreList(param1:Vector.<int>) : void
      {
         this.FScoreList = param1;
      }
      
      public function get RankList() : TTraitorAttackRankHeros
      {
         return this.FRankList;
      }
      
      public function set RankList(param1:TTraitorAttackRankHeros) : void
      {
         this.FRankList = param1;
      }
      
      public function get MonsterList() : Dictionary
      {
         return this.FMonsterList;
      }
      
      public function set MonsterList(param1:Dictionary) : void
      {
         this.FMonsterList = param1;
      }
   }
}

