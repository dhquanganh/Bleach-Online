package Logics.OrganizationalWar
{
   import Processors.Game.Lobby.OrganizationalWar.TUIOrganizationalPlayers;
   import Resources.Constants.CONST_ORGANIZATIONALWAR;
   
   public class TOrganizationalWarGoalData
   {
      
      protected var FPlayerRankInfors:Vector.<TRankInfor>;
      
      protected var FPlayerRankActiveNum:int;
      
      protected var FOrganizationRankInfors:Vector.<TRankInfor>;
      
      protected var FOrganizationRankActiveNum:int;
      
      protected var FOrganizationRole:TUIOrganizationalPlayers;
      
      protected var FOrganizationsInfor:Vector.<TOraganizationalInfor>;
      
      protected var FCampFlag:uint;
      
      protected var FRoadNum:uint;
      
      protected var FWinTimes:uint;
      
      protected var FPlayerRecord:uint;
      
      protected var FPlayerRank:uint;
      
      protected var FOrganizationRecord:uint;
      
      protected var FOrganizationRank:uint;
      
      protected var FPlayerAdded:uint;
      
      protected var FOrganizationAdded:uint;
      
      protected var FSystemColdDownTime:uint;
      
      protected var FDieColdDownTime:uint;
      
      protected var FRunning:Boolean;
      
      protected var FTime_Ready:uint;
      
      protected var FTime_StartSignUp:uint;
      
      protected var FTime_EndSignUp:uint;
      
      protected var FTime_BattleStart:uint;
      
      protected var FTime_BattleEnd:uint;
      
      protected var FTime_CanEnterScene:uint;
      
      protected var FGold_ClearColdTime:uint;
      
      protected var FInspironCost:Vector.<uint>;
      
      protected var FInspironData:Vector.<uint>;
      
      protected var FCurrentInspironNum:int;
      
      protected var FIntervalTime:uint;
      
      protected var FMoveTime:uint;
      
      protected var FRoleWinTimes:Vector.<Vector.<uint>>;
      
      protected var FRoleChangeColors:Vector.<uint>;
      
      public function TOrganizationalWarGoalData()
      {
         var _loc1_:int = 0;
         super();
         this.FOrganizationRole = new TUIOrganizationalPlayers();
         this.FPlayerRankInfors = new Vector.<TRankInfor>();
         this.FPlayerRankActiveNum = 0;
         this.FOrganizationRankInfors = new Vector.<TRankInfor>();
         this.FOrganizationRankActiveNum = 0;
         this.FInspironCost = new Vector.<uint>();
         this.FInspironData = new Vector.<uint>();
         this.FRoleWinTimes = new Vector.<Vector.<uint>>();
         this.FRoleChangeColors = new Vector.<uint>();
         _loc1_ = 0;
         while(_loc1_ < CONST_ORGANIZATIONALWAR.RankInforNum)
         {
            this.FPlayerRankInfors.push(new TRankInfor());
            this.FOrganizationRankInfors.push(new TRankInfor());
            _loc1_++;
         }
         this.FOrganizationsInfor = new Vector.<TOraganizationalInfor>();
      }
      
      public function get PlayerRankInfors() : Vector.<TRankInfor>
      {
         return this.FPlayerRankInfors;
      }
      
      public function set PlayerRankInfors(param1:Vector.<TRankInfor>) : void
      {
         this.FPlayerRankInfors = param1;
      }
      
      public function get PlayerRankActiveNum() : int
      {
         return this.FPlayerRankActiveNum;
      }
      
      public function set PlayerRankActiveNum(param1:int) : void
      {
         this.FPlayerRankActiveNum = param1;
      }
      
      public function get OrganizationRankInfors() : Vector.<TRankInfor>
      {
         return this.FOrganizationRankInfors;
      }
      
      public function set OrganizationRankInfors(param1:Vector.<TRankInfor>) : void
      {
         this.FOrganizationRankInfors = param1;
      }
      
      public function get OrganizationRankActiveNum() : int
      {
         return this.FOrganizationRankActiveNum;
      }
      
      public function set OrganizationRankActiveNum(param1:int) : void
      {
         this.FOrganizationRankActiveNum = param1;
      }
      
      public function get OrganizationRole() : TUIOrganizationalPlayers
      {
         return this.FOrganizationRole;
      }
      
      public function get CampFlag() : uint
      {
         return this.FCampFlag;
      }
      
      public function set CampFlag(param1:uint) : void
      {
         this.FCampFlag = param1;
      }
      
      public function get WinTimes() : uint
      {
         return this.FWinTimes;
      }
      
      public function set WinTimes(param1:uint) : void
      {
         this.FWinTimes = param1;
      }
      
      public function get PlayerRecord() : uint
      {
         return this.FPlayerRecord;
      }
      
      public function set PlayerRecord(param1:uint) : void
      {
         this.FPlayerRecord = param1;
      }
      
      public function get PlayerRank() : uint
      {
         return this.FPlayerRank;
      }
      
      public function set PlayerRank(param1:uint) : void
      {
         this.FPlayerRank = param1;
      }
      
      public function get OrganizationRecord() : uint
      {
         return this.FOrganizationRecord;
      }
      
      public function set OrganizationRecord(param1:uint) : void
      {
         this.FOrganizationRecord = param1;
      }
      
      public function get OrganizationRank() : uint
      {
         return this.FOrganizationRank;
      }
      
      public function set OrganizationRank(param1:uint) : void
      {
         this.FOrganizationRank = param1;
      }
      
      public function get PlayerAdded() : uint
      {
         return this.FPlayerAdded;
      }
      
      public function set PlayerAdded(param1:uint) : void
      {
         this.FPlayerAdded = param1;
      }
      
      public function get OrganizationAdded() : uint
      {
         return this.FOrganizationAdded;
      }
      
      public function set OrganizationAdded(param1:uint) : void
      {
         this.FOrganizationAdded = param1;
      }
      
      public function get SystemColdDownTime() : uint
      {
         return this.FSystemColdDownTime;
      }
      
      public function set SystemColdDownTime(param1:uint) : void
      {
         this.FSystemColdDownTime = param1;
      }
      
      public function get DieColdDownTime() : uint
      {
         return this.FDieColdDownTime;
      }
      
      public function set DieColdDownTime(param1:uint) : void
      {
         this.FDieColdDownTime = param1;
      }
      
      public function get RoadNum() : uint
      {
         return this.FRoadNum;
      }
      
      public function set RoadNum(param1:uint) : void
      {
         this.FRoadNum = param1;
      }
      
      public function get Time_Ready() : uint
      {
         return this.FTime_Ready;
      }
      
      public function set Time_Ready(param1:uint) : void
      {
         this.FTime_Ready = param1;
      }
      
      public function get Time_StartSignUp() : uint
      {
         return this.FTime_StartSignUp;
      }
      
      public function set Time_StartSignUp(param1:uint) : void
      {
         this.FTime_StartSignUp = param1;
      }
      
      public function get Time_EndSignUp() : uint
      {
         return this.FTime_EndSignUp;
      }
      
      public function set Time_EndSignUp(param1:uint) : void
      {
         this.FTime_EndSignUp = param1;
      }
      
      public function get Time_BattleStart() : uint
      {
         return this.FTime_BattleStart;
      }
      
      public function set Time_BattleStart(param1:uint) : void
      {
         this.FTime_BattleStart = param1;
      }
      
      public function get InspironCost() : Vector.<uint>
      {
         return this.FInspironCost;
      }
      
      public function set InspironCost(param1:Vector.<uint>) : void
      {
         this.FInspironCost = param1;
      }
      
      public function get Time_BattleEnd() : uint
      {
         return this.FTime_BattleEnd;
      }
      
      public function set Time_BattleEnd(param1:uint) : void
      {
         this.FTime_BattleEnd = param1;
      }
      
      public function get Gold_ClearColdTime() : uint
      {
         return this.FGold_ClearColdTime;
      }
      
      public function set Gold_ClearColdTime(param1:uint) : void
      {
         this.FGold_ClearColdTime = param1;
      }
      
      public function get CurrentInspironNum() : int
      {
         return this.FCurrentInspironNum;
      }
      
      public function set CurrentInspironNum(param1:int) : void
      {
         this.FCurrentInspironNum = param1;
      }
      
      public function get IntervalTime() : uint
      {
         return this.FIntervalTime;
      }
      
      public function set IntervalTime(param1:uint) : void
      {
         this.FIntervalTime = param1;
      }
      
      public function get MoveTime() : uint
      {
         return this.FMoveTime;
      }
      
      public function set MoveTime(param1:uint) : void
      {
         this.FMoveTime = param1;
      }
      
      public function get RoleChangeColors() : Vector.<uint>
      {
         return this.FRoleChangeColors;
      }
      
      public function set RoleChangeColors(param1:Vector.<uint>) : void
      {
         this.FRoleChangeColors = param1;
      }
      
      public function get RoleWinTimes() : Vector.<Vector.<uint>>
      {
         return this.FRoleWinTimes;
      }
      
      public function set RoleWinTimes(param1:Vector.<Vector.<uint>>) : void
      {
         this.FRoleWinTimes = param1;
      }
      
      public function get Time_CanEnterScene() : uint
      {
         return this.FTime_CanEnterScene;
      }
      
      public function set Time_CanEnterScene(param1:uint) : void
      {
         this.FTime_CanEnterScene = param1;
      }
      
      public function get InspironData() : Vector.<uint>
      {
         return this.FInspironData;
      }
      
      public function set InspironData(param1:Vector.<uint>) : void
      {
         this.FInspironData = param1;
      }
      
      public function get Running() : Boolean
      {
         return this.FRunning;
      }
      
      public function set Running(param1:Boolean) : void
      {
         this.FRunning = param1;
      }
      
      public function get OrganizationsInfor() : Vector.<TOraganizationalInfor>
      {
         return this.FOrganizationsInfor;
      }
   }
}

