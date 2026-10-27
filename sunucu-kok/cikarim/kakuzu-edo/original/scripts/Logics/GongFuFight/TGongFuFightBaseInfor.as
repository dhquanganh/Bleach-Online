package Logics.GongFuFight
{
   public class TGongFuFightBaseInfor
   {
      
      protected var FRankYesterday:uint;
      
      protected var FRankToday:uint;
      
      protected var FFightValue:uint;
      
      protected var FGrounpLevel:uint;
      
      protected var FScoreYesterDay:uint;
      
      protected var FScoreToday:uint;
      
      protected var FCurFightTimes:uint;
      
      protected var FLastFightSce:uint;
      
      protected var FIfApplyToday:Boolean;
      
      protected var FToastTimes:uint;
      
      protected var FSpanFightFlag:uint;
      
      protected var FCanBuyTime:uint;
      
      protected var FApplyYesterdaySce:uint;
      
      protected var FBoxState:uint;
      
      protected var FTimeCanApply:uint;
      
      protected var FTimeStartFight:uint;
      
      protected var FTimeEndFight:uint;
      
      protected var FSeasonState:uint;
      
      protected var FSeasonOpenTime:uint;
      
      protected var FSeasonResetTime:uint;
      
      protected var FSeasonCloseTime:uint;
      
      protected var FFightZoneID:uint;
      
      protected var FGongFuFightState:uint;
      
      public function TGongFuFightBaseInfor()
      {
         super();
      }
      
      public function get ApplyYesterdaySce() : uint
      {
         return this.FApplyYesterdaySce;
      }
      
      public function set ApplyYesterdaySce(param1:uint) : void
      {
         this.FApplyYesterdaySce = param1;
      }
      
      public function get RankYesterday() : uint
      {
         return this.FRankYesterday;
      }
      
      public function set RankYesterday(param1:uint) : void
      {
         this.FRankYesterday = param1;
      }
      
      public function get RankToday() : uint
      {
         return this.FRankToday;
      }
      
      public function set RankToday(param1:uint) : void
      {
         this.FRankToday = param1;
      }
      
      public function get FightValue() : uint
      {
         return this.FFightValue;
      }
      
      public function set FightValue(param1:uint) : void
      {
         this.FFightValue = param1;
      }
      
      public function get GrounpLevel() : uint
      {
         return this.FGrounpLevel;
      }
      
      public function set GrounpLevel(param1:uint) : void
      {
         this.FGrounpLevel = param1;
      }
      
      public function get ScoreYesterDay() : uint
      {
         return this.FScoreYesterDay;
      }
      
      public function set ScoreYesterDay(param1:uint) : void
      {
         this.FScoreYesterDay = param1;
      }
      
      public function get ScoreToday() : uint
      {
         return this.FScoreToday;
      }
      
      public function set ScoreToday(param1:uint) : void
      {
         this.FScoreToday = param1;
      }
      
      public function get CurFightTimes() : uint
      {
         return this.FCurFightTimes;
      }
      
      public function set CurFightTimes(param1:uint) : void
      {
         this.FCurFightTimes = param1;
      }
      
      public function get LastFightSce() : uint
      {
         return this.FLastFightSce;
      }
      
      public function set LastFightSce(param1:uint) : void
      {
         this.FLastFightSce = param1;
      }
      
      public function get ToastTimes() : uint
      {
         return this.FToastTimes;
      }
      
      public function set ToastTimes(param1:uint) : void
      {
         this.FToastTimes = param1;
      }
      
      public function get SpanFightFlag() : uint
      {
         return this.FSpanFightFlag;
      }
      
      public function set SpanFightFlag(param1:uint) : void
      {
         this.FSpanFightFlag = param1;
      }
      
      public function get TimeCanApply() : uint
      {
         return this.FTimeCanApply;
      }
      
      public function set TimeCanApply(param1:uint) : void
      {
         this.FTimeCanApply = param1;
      }
      
      public function get TimeStartFight() : uint
      {
         return this.FTimeStartFight;
      }
      
      public function set TimeStartFight(param1:uint) : void
      {
         this.FTimeStartFight = param1;
      }
      
      public function get TimeEndFight() : uint
      {
         return this.FTimeEndFight;
      }
      
      public function set TimeEndFight(param1:uint) : void
      {
         this.FTimeEndFight = param1;
      }
      
      public function get IfApplyToday() : Boolean
      {
         return this.FIfApplyToday;
      }
      
      public function set IfApplyToday(param1:Boolean) : void
      {
         this.FIfApplyToday = param1;
      }
      
      public function get SeasonState() : uint
      {
         return this.FSeasonState;
      }
      
      public function set SeasonState(param1:uint) : void
      {
         this.FSeasonState = param1;
      }
      
      public function get SeasonOpenTime() : uint
      {
         return this.FSeasonOpenTime;
      }
      
      public function set SeasonOpenTime(param1:uint) : void
      {
         this.FSeasonOpenTime = param1;
      }
      
      public function get SeasonResetTime() : uint
      {
         return this.FSeasonResetTime;
      }
      
      public function set SeasonResetTime(param1:uint) : void
      {
         this.FSeasonResetTime = param1;
      }
      
      public function get SeasonCloseTime() : uint
      {
         return this.FSeasonCloseTime;
      }
      
      public function set SeasonCloseTime(param1:uint) : void
      {
         this.FSeasonCloseTime = param1;
      }
      
      public function get FightZoneID() : uint
      {
         return this.FFightZoneID;
      }
      
      public function set FightZoneID(param1:uint) : void
      {
         this.FFightZoneID = param1;
      }
      
      public function get CanBuyTime() : uint
      {
         return this.FCanBuyTime;
      }
      
      public function set CanBuyTime(param1:uint) : void
      {
         this.FCanBuyTime = param1;
      }
      
      public function get GongFuFightState() : uint
      {
         return this.FGongFuFightState;
      }
      
      public function set GongFuFightState(param1:uint) : void
      {
         this.FGongFuFightState = param1;
      }
      
      public function get BoxState() : uint
      {
         return this.FBoxState;
      }
      
      public function set BoxState(param1:uint) : void
      {
         this.FBoxState = param1;
      }
   }
}

