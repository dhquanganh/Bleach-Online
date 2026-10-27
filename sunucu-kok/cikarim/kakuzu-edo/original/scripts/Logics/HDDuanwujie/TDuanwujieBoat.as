package Logics.HDDuanwujie
{
   import Logics.DatebaseVO.VO.THDDuanwujieBoat;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TDuanwujieBoat extends TActivityOSBase
   {
      
      protected var FGameCount:uint;
      
      protected var FScore:uint;
      
      protected var FBuffs:uint;
      
      protected var FEvaluation:int;
      
      protected var FMorale:uint;
      
      protected var FAddSpeed:uint;
      
      protected var FShowAwards:TInventories;
      
      protected var FTimeEnd:uint;
      
      protected var FTimeStart:uint;
      
      protected var FBoatAwards:Vector.<TInventories>;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FLevel:uint;
      
      protected var FCurPeriod:uint;
      
      protected var FLastBigAward:int;
      
      protected var FConfig:THDDuanwujieBoat;
      
      public function TDuanwujieBoat()
      {
         super();
         this.FShowAwards = new TInventories();
         this.FBoatAwards = new Vector.<TInventories>();
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
      }
      
      public function get GameCount() : uint
      {
         return this.FGameCount;
      }
      
      public function set GameCount(param1:uint) : void
      {
         this.FGameCount = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Buffs() : uint
      {
         return this.FBuffs;
      }
      
      public function set Buffs(param1:uint) : void
      {
         this.FBuffs = param1;
      }
      
      public function get Evaluation() : int
      {
         return this.FEvaluation;
      }
      
      public function set Evaluation(param1:int) : void
      {
         this.FEvaluation = param1;
      }
      
      public function get Morale() : uint
      {
         return this.FMorale;
      }
      
      public function set Morale(param1:uint) : void
      {
         this.FMorale = param1;
      }
      
      public function get AddSpeed() : uint
      {
         return this.FAddSpeed;
      }
      
      public function set AddSpeed(param1:uint) : void
      {
         this.FAddSpeed = param1;
      }
      
      public function get ShowAwards() : TInventories
      {
         return this.FShowAwards;
      }
      
      public function set ShowAwards(param1:TInventories) : void
      {
         this.FShowAwards = param1;
      }
      
      public function get Config() : THDDuanwujieBoat
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDDuanwujieBoat) : void
      {
         this.FConfig = param1;
      }
      
      public function get TimeEnd() : uint
      {
         return this.FTimeEnd;
      }
      
      public function set TimeEnd(param1:uint) : void
      {
         this.FTimeEnd = param1;
      }
      
      public function get BoatAwards() : Vector.<TInventories>
      {
         return this.FBoatAwards;
      }
      
      public function set BoatAwards(param1:Vector.<TInventories>) : void
      {
         this.FBoatAwards = param1;
      }
      
      public function get TimeStart() : uint
      {
         return this.FTimeStart;
      }
      
      public function set TimeStart(param1:uint) : void
      {
         this.FTimeStart = param1;
      }
      
      public function get MailStatus() : Vector.<int>
      {
         return this.FMailStatus;
      }
      
      public function set MailStatus(param1:Vector.<int>) : void
      {
         this.FMailStatus = param1;
      }
      
      public function get MailInvs() : TInventories
      {
         return this.FMailInvs;
      }
      
      public function set MailInvs(param1:TInventories) : void
      {
         this.FMailInvs = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get CurPeriod() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FCurPeriod = 0;
         _loc1_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FMorale >= this.FConfig.Morale.nums[_loc2_])
            {
               this.FCurPeriod = _loc2_;
            }
            _loc2_++;
         }
         return this.FCurPeriod + 1;
      }
      
      public function get LastBigAward() : int
      {
         return this.FLastBigAward;
      }
      
      public function set LastBigAward(param1:int) : void
      {
         this.FLastBigAward = param1;
      }
   }
}

