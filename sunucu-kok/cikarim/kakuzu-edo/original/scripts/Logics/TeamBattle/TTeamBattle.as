package Logics.TeamBattle
{
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Rooms.Seat.TRoomSeatInfo;
   import Logics.SLogicsCore;
   
   public class TTeamBattle
   {
      
      protected var FPvpStatus:Boolean;
      
      protected var FPVPRewardCount:uint;
      
      protected var FPVERewardCount:uint;
      
      protected var FHonor:uint;
      
      protected var FPVPModels:TModels;
      
      protected var FPVEModels:TModels;
      
      protected var FSelectModelID:uint;
      
      protected var FPassword:String;
      
      protected var FPasswordModifed:Boolean;
      
      protected var FIsCreatePassword:Boolean;
      
      protected var FAutoReady:Boolean;
      
      protected var FAllAutoReady:Boolean;
      
      protected var FRoomSeatInfo:TRoomSeatInfo;
      
      protected var FModeType:uint;
      
      protected var FBakModelID:uint;
      
      protected var FAgainModelID:uint;
      
      public function TTeamBattle()
      {
         super();
         this.FPVPModels = new TModels();
         this.FPVEModels = new TModels();
         this.FPassword = "";
         this.FPasswordModifed = false;
         this.FIsCreatePassword = false;
         this.FRoomSeatInfo = new TRoomSeatInfo(0);
      }
      
      protected function get BAData() : TBleachAgentData
      {
         return SLogicsCore.BleachAgentData;
      }
      
      public function get PvpStatus() : Boolean
      {
         return this.FPvpStatus;
      }
      
      public function set PvpStatus(param1:Boolean) : void
      {
         this.FPvpStatus = param1;
      }
      
      public function get PVPRewardCount() : uint
      {
         return this.FPVPRewardCount + this.BAData.GetWelfareCountByType(this.BAData.WelfareType_LeagueBloodAwardCount);
      }
      
      public function set PVPRewardCount(param1:uint) : void
      {
         this.FPVPRewardCount = param1;
      }
      
      public function get PVERewardCount() : uint
      {
         return this.FPVERewardCount + this.BAData.GetWelfareCountByType(this.BAData.WelfareType_LeagueAwardCount);
      }
      
      public function set PVERewardCount(param1:uint) : void
      {
         this.FPVERewardCount = param1;
      }
      
      public function get Honor() : uint
      {
         return this.FHonor;
      }
      
      public function set Honor(param1:uint) : void
      {
         this.FHonor = param1;
      }
      
      public function get PVPModels() : TModels
      {
         return this.FPVPModels;
      }
      
      public function get PVEModels() : TModels
      {
         return this.FPVEModels;
      }
      
      public function get SelectModelID() : uint
      {
         return this.FSelectModelID;
      }
      
      public function set SelectModelID(param1:uint) : void
      {
         this.FSelectModelID = param1;
      }
      
      public function get Password() : String
      {
         return this.FPassword;
      }
      
      public function set Password(param1:String) : void
      {
         this.FPassword = param1;
      }
      
      public function get PasswordModifed() : Boolean
      {
         return this.FPasswordModifed;
      }
      
      public function set PasswordModifed(param1:Boolean) : void
      {
         this.FPasswordModifed = param1;
      }
      
      public function get IsCreatePassword() : Boolean
      {
         return this.FIsCreatePassword;
      }
      
      public function set IsCreatePassword(param1:Boolean) : void
      {
         this.FIsCreatePassword = param1;
      }
      
      public function get AutoReady() : Boolean
      {
         return this.FAutoReady;
      }
      
      public function set AutoReady(param1:Boolean) : void
      {
         this.FAutoReady = param1;
      }
      
      public function get AllAutoReady() : Boolean
      {
         return this.FAllAutoReady;
      }
      
      public function set AllAutoReady(param1:Boolean) : void
      {
         this.FAllAutoReady = param1;
      }
      
      public function get RoomSeatInfo() : TRoomSeatInfo
      {
         return this.FRoomSeatInfo;
      }
      
      public function get ModeType() : uint
      {
         return this.FModeType;
      }
      
      public function set ModeType(param1:uint) : void
      {
         this.FModeType = param1;
      }
      
      public function get CurPveModelID() : uint
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         var _loc4_:uint = 0;
         _loc2_ = this.FPVEModels.Count;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = this.FPVEModels.GetModelByIndex(_loc1_);
            if(_loc3_.IsUnlock)
            {
               _loc4_ = _loc3_.Identifier;
               break;
            }
            _loc1_--;
         }
         return _loc4_;
      }
      
      public function get CurPvpModelID() : uint
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         var _loc4_:uint = 0;
         _loc2_ = this.FPVPModels.Count;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = this.FPVPModels.GetModelByIndex(_loc1_);
            if(_loc3_.IsUnlock)
            {
               _loc4_ = _loc3_.Identifier;
               break;
            }
            _loc1_--;
         }
         return _loc4_;
      }
      
      public function get BakModelID() : uint
      {
         return this.FBakModelID;
      }
      
      public function set BakModelID(param1:uint) : void
      {
         this.FBakModelID = param1;
      }
      
      public function get AgainModelID() : uint
      {
         return this.FAgainModelID;
      }
      
      public function set AgainModelID(param1:uint) : void
      {
         this.FAgainModelID = param1;
      }
      
      public function Reset() : void
      {
         this.FModeType = 0;
         this.FBakModelID = 0;
         this.FAgainModelID = 0;
         this.FSelectModelID = 0;
         this.FPassword = "";
         this.FPasswordModifed = false;
         this.FIsCreatePassword = false;
         this.FAllAutoReady = false;
         this.FPVPModels.Clear();
         this.FPVEModels.Clear();
         this.FRoomSeatInfo.Reset();
      }
   }
}

