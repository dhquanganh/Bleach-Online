package Logics.KingChallenge
{
   import Logics.Inventories.TInventories;
   
   public class TKingChallenge
   {
      
      protected var FPlayerNames:Vector.<String>;
      
      protected var FPlayersInfo:Vector.<TPlayerInfo>;
      
      protected var FRankData:Vector.<TRankData>;
      
      protected var FJackPoint:TInventories;
      
      protected var FSeasonStatus:int;
      
      protected var FFighterStartTime:int;
      
      protected var FFightsInfo:Vector.<TFighterInfo>;
      
      protected var FBettingsInfo:Vector.<TBettingInfo>;
      
      protected var FUserBaseInfo:TUserBaseInfo;
      
      public function TKingChallenge()
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super();
         this.FPlayersInfo = new Vector.<TPlayerInfo>();
         this.FPlayerNames = new Vector.<String>();
         this.FRankData = new Vector.<TRankData>();
         this.FBettingsInfo = new Vector.<TBettingInfo>();
         this.FFightsInfo = new Vector.<TFighterInfo>();
         this.FUserBaseInfo = new TUserBaseInfo();
      }
      
      public function get PlayerNames() : Vector.<String>
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = 8;
         _loc1_ = new Vector.<String>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_] = "";
            _loc3_++;
         }
         _loc2_ = this.FPlayersInfo.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[this.FPlayersInfo[_loc3_].Position] = this.FPlayersInfo[_loc3_].UserName;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function set PlayerNames(param1:Vector.<String>) : void
      {
         this.FPlayerNames = param1;
      }
      
      public function get JackPoint() : TInventories
      {
         return this.FJackPoint;
      }
      
      public function set JackPoint(param1:TInventories) : void
      {
         this.FJackPoint = param1;
      }
      
      public function get PlayersInfo() : Vector.<TPlayerInfo>
      {
         return this.FPlayersInfo;
      }
      
      public function set PlayersInfo(param1:Vector.<TPlayerInfo>) : void
      {
         this.FPlayersInfo = param1;
      }
      
      public function get RankData() : Vector.<TRankData>
      {
         return this.FRankData;
      }
      
      public function set RankData(param1:Vector.<TRankData>) : void
      {
         this.FRankData = param1;
      }
      
      public function get SeasonStatus() : int
      {
         return this.FSeasonStatus;
      }
      
      public function set SeasonStatus(param1:int) : void
      {
         this.FSeasonStatus = param1;
      }
      
      public function get FighterStartTime() : int
      {
         return this.FFighterStartTime;
      }
      
      public function set FighterStartTime(param1:int) : void
      {
         this.FFighterStartTime = param1;
      }
      
      public function get FightsInfo() : Vector.<TFighterInfo>
      {
         return this.FFightsInfo;
      }
      
      public function set FightsInfo(param1:Vector.<TFighterInfo>) : void
      {
         this.FFightsInfo = param1;
      }
      
      public function get BettingsInfo() : Vector.<TBettingInfo>
      {
         return this.FBettingsInfo;
      }
      
      public function set BettingsInfo(param1:Vector.<TBettingInfo>) : void
      {
         this.FBettingsInfo = param1;
      }
      
      public function get UserBaseInfo() : TUserBaseInfo
      {
         return this.FUserBaseInfo;
      }
      
      public function set UserBaseInfo(param1:TUserBaseInfo) : void
      {
         this.FUserBaseInfo = param1;
      }
      
      public function FindPlayerInfoById(param1:uint, param2:uint) : TPlayerInfo
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = this.FPlayersInfo.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1 == this.FPlayersInfo[_loc4_].LowId && param2 == this.FPlayersInfo[_loc4_].HighId)
            {
               return this.FPlayersInfo[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function FindFightInfoById(param1:uint) : TFighterInfo
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.FFightsInfo.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.FFightsInfo[_loc3_].FightNum)
            {
               return this.FFightsInfo[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function SetFightInfoById(param1:uint, param2:TFighterInfo) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = this.FFightsInfo.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1 == this.FFightsInfo[_loc4_].FightNum)
            {
               this.FFightsInfo[_loc4_] = param2;
            }
            _loc4_++;
         }
      }
      
      public function HadFightInfoById(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.FFightsInfo.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.FFightsInfo[_loc3_].FightNum)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function HadBettingInfoById(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.FBettingsInfo.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.FBettingsInfo[_loc3_].FighterNum)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}

