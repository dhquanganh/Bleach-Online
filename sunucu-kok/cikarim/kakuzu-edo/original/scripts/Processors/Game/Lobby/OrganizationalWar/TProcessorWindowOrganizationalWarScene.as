package Processors.Game.Lobby.OrganizationalWar
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.OrganizationalWar.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowOrganizationalWarScene extends TProcessorLobbyWindow
   {
      
      protected static const QUEUE_WAIT_NUM:int = 10;
      
      protected static const QUEUE_BATTLE_NUM:int = 5;
      
      protected static const ShadowYOffset:int = 300;
      
      protected static const CAMPFRIEND:int = 1;
      
      protected static const CAMPENEMY:int = 2;
      
      protected static const TimeZoneOffset:int = 8 * 3600;
      
      protected static const SecondOneDay:int = 24 * 3600;
      
      protected var FGoalData:TOrganizationalWarGoalData;
      
      protected var FQueues_Wait:Vector.<TUIOrganizationalPlayers>;
      
      protected var FQueues_Battle:Vector.<TUIOrganizationalPlayers>;
      
      protected var FMCArrows:Vector.<MovieClip>;
      
      protected var FRoleMountPoint:Vector.<Sprite>;
      
      protected var FBooms:Vector.<MovieClip>;
      
      protected var FPath:Vector.<MovieClip>;
      
      protected var FBirthPlace:Vector.<TCoordinate>;
      
      protected var FMCBirthPlace:Vector.<MovieClip>;
      
      protected var FMC_Arrow:MovieClip;
      
      protected var FSpeedMove:Number;
      
      protected var FSeverStartTime:Number;
      
      protected var FTickStoreGetServerTime:uint;
      
      protected var FHint:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FQueueIndex:int;
      
      protected var FSetDailyActivityStatus:Function;
      
      protected var FCommandRequest:Function;
      
      protected var FOnScoreChanged:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TProcessorWindowOrganizationalWarScene(param1:TUIComponent)
      {
         super(param1);
         this.FSeverStartTime = 0;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCoordinate = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         this.FQueues_Wait = new Vector.<TUIOrganizationalPlayers>();
         this.FQueues_Battle = new Vector.<TUIOrganizationalPlayers>();
         this.FBirthPlace = new Vector.<TCoordinate>();
         this.FMCBirthPlace = new Vector.<MovieClip>();
         this.FBooms = new Vector.<MovieClip>();
         this.FMCArrows = new Vector.<MovieClip>();
         this.FPath = new Vector.<MovieClip>();
         this.FRoleMountPoint = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < QUEUE_WAIT_NUM)
         {
            this.FQueues_Wait.push(new TUIOrganizationalPlayers());
            _loc4_ = param1["BirthPlace" + (_loc2_ + 1)];
            _loc3_ = new TCoordinate();
            _loc3_.X = _loc4_.x;
            _loc3_.Y = _loc4_.y;
            this.FBirthPlace.push(_loc3_);
            if(_loc2_ < QUEUE_BATTLE_NUM)
            {
               _loc4_.addEventListener(MouseEvent.CLICK,this.BirthPlaceClicked);
               this.FMCArrows.push(param1["Pointer" + (_loc2_ + 1)]);
               this.FPath.push(param1["Path" + (_loc2_ + 1)]);
               _loc5_ = new Sprite();
               this.FRoleMountPoint.push(_loc5_);
            }
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.BirthPlaceMouseOver);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.BirthPlaceMouseOut);
            _loc4_.buttonMode = true;
            this.FMCBirthPlace.push(_loc4_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < QUEUE_BATTLE_NUM)
         {
            this.FQueues_Battle.push(new TUIOrganizationalPlayers());
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("Boom") as MovieClip;
            _loc4_.visible = false;
            this.addChild(_loc4_);
            this.FBooms.push(_loc4_);
            _loc2_++;
         }
         this.FMC_Arrow = TUtilityReflection.CreateDisplayObjectInstance("Arrow") as MovieClip;
         this.FMC_Arrow.play();
         this.FMC_Arrow.visible = false;
         addChild(this.FMC_Arrow);
         this.FHint = new THint();
         addChild(this.FRoleMountPoint[4]);
         addChild(this.FRoleMountPoint[2]);
         addChild(this.FRoleMountPoint[0]);
         addChild(this.FRoleMountPoint[1]);
         addChild(this.FRoleMountPoint[3]);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      public function UILocations() : void
      {
         FIsResourcesLoadCompleted = true;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         if(!this.Visible)
         {
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_ORGANIZATIONWAR)
         {
            return;
         }
         this.CheckIfGameOver();
         this.CheckIfShowArrow();
         _loc1_ = 0;
         while(_loc1_ < this.FBooms.length)
         {
            if(this.FBooms[_loc1_].currentFrameLabel == "End")
            {
               this.FBooms[_loc1_].visible = false;
            }
            _loc1_++;
         }
         super.LogicsPerform();
         if(FIsResourcesLoadCompleted)
         {
            this.UpdateQueuesWait();
            this.UpdateQueuesBattle();
         }
      }
      
      protected function ResetOneQueue(param1:TUIOrganizationalPlayers) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUIOrganizationalWarPlayer = null;
         _loc2_ = 0;
         while(_loc2_ < param1.Count)
         {
            _loc3_ = param1.GetRoleByIndex(_loc2_);
            _loc3_.ExistPool = null;
            _loc3_.visible = false;
            _loc2_++;
         }
         param1.Clear();
      }
      
      protected function ResetAllPlayer() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FQueues_Wait.length)
         {
            this.ResetOneQueue(this.FQueues_Wait[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FQueues_Battle.length)
         {
            this.ResetOneQueue(this.FQueues_Battle[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function CheckIfGameOver() : void
      {
         var _loc1_:Number = NaN;
         if(this.FSeverStartTime == 0)
         {
            return;
         }
         _loc1_ = this.GetCurrentServerTime() / 1000 - STimingCore.ServerTimeZone;
         _loc1_ %= CONST_COMMON.SecondPerDay;
         if(_loc1_ > this.FGoalData.Time_BattleEnd)
         {
            this.FGoalData.Running = false;
            this.ResetAllPlayer();
            this.FMC_Arrow.stop();
            this.FMC_Arrow.visible = false;
            if(this.FSetDailyActivityStatus != null)
            {
               this.FSetDailyActivityStatus(this,CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE,CONST_ORGANIZATION.STATUS_ORGACTIVITY_End);
            }
         }
      }
      
      protected function CheckIfShowArrow() : void
      {
         var _loc1_:TTimeCoolDown = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         _loc1_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_DieColdTime);
         _loc3_ = 0;
         while(_loc3_ < this.FMCArrows.length)
         {
            this.FMCArrows[_loc3_].play();
            if(_loc1_.TimingTime <= 0 && !this.FMC_Arrow.visible)
            {
               this.FMCArrows[_loc3_].visible = this.FMCBirthPlace[_loc3_].visible;
            }
            else
            {
               this.FMCArrows[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function UpdateQueuesWait() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < QUEUE_WAIT_NUM)
         {
            this.UpdateQueueSingle(this.FQueues_Wait[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function UpdateQueueSingle(param1:TUIOrganizationalPlayers) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIOrganizationalWarPlayer = null;
         var _loc7_:TOrganizationRole = null;
         var _loc8_:TUIOrganizationalPlayers = null;
         _loc2_ = uint(STimingCore.ServerTick);
         _loc4_ = 0;
         while(_loc4_ < param1.Count)
         {
            _loc6_ = param1.GetRoleByIndex(_loc4_) as TUIOrganizationalWarPlayer;
            _loc7_ = _loc6_.RoleData;
            _loc3_ = _loc7_.BattleStartTime - this.GetCurrentServerTime();
            _loc7_.BattleLocalTime = _loc3_ + STimingCore.TickCount;
            if(_loc3_ < 0)
            {
               _loc8_ = this.FQueues_Battle[_loc7_.BirthPlaceID - 1];
               _loc8_.Add(_loc6_);
               _loc6_.ExistPool = _loc8_;
               param1.DeleteRoleByIdentifier(_loc7_.Identifier0,_loc7_.Identifier1);
               this.FRoleMountPoint[_loc6_.RoleData.BirthPlaceID - 1].addChild(_loc6_);
               _loc4_--;
               _loc6_.StartMove();
            }
            _loc4_++;
         }
      }
      
      protected function UpdateQueuesBattle() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < QUEUE_BATTLE_NUM)
         {
            this.UpdateQueueBattleSingle(this.FQueues_Battle[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function UpdateQueueBattleSingle(param1:TUIOrganizationalPlayers) : void
      {
         var _loc2_:* = 0;
         var _loc3_:TUIOrganizationalWarPlayer = null;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.Count)
         {
            _loc4_ = param1.Count;
            _loc3_ = param1.GetRoleByIndex(_loc2_) as TUIOrganizationalWarPlayer;
            this.ActionMove(_loc3_);
            if(_loc4_ != param1.Count)
            {
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      protected function ActionMove(param1:TUIOrganizationalWarPlayer) : void
      {
         var _loc2_:TOrganizationRole = null;
         var _loc3_:TCoordinate = null;
         var _loc4_:TCoordinate = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         _loc2_ = param1.RoleData;
         _loc5_ = this.GetIndexByCampIDBornID(_loc2_.CampID,_loc2_.BirthPlaceID);
         _loc3_ = this.FBirthPlace[_loc5_];
         _loc6_ = _loc2_.CampID == CAMPFRIEND ? CAMPENEMY : CAMPFRIEND;
         _loc5_ = this.GetIndexByCampIDBornID(_loc6_,_loc2_.BirthPlaceID);
         _loc4_ = this.FBirthPlace[_loc5_];
         _loc7_ = STimingCore.TickCount - _loc2_.BattleLocalTime;
         if(_loc7_ >= this.FGoalData.MoveTime)
         {
            this.ActionReset(param1);
            return;
         }
         param1.x = _loc3_.X + (_loc4_.X - _loc3_.X) * _loc7_ / this.FGoalData.MoveTime;
         param1.y = _loc3_.Y + (_loc4_.Y - _loc3_.Y) * _loc7_ / this.FGoalData.MoveTime;
         _loc8_ = this.CheckIfMainRole(param1);
         if(_loc8_)
         {
            this.FMC_Arrow.x = param1.x;
            this.FMC_Arrow.y = param1.y - param1.height;
            this.FMC_Arrow.visible = true;
            this.FRoleMountPoint[param1.RoleData.BirthPlaceID - 1].addChild(this.FMC_Arrow);
         }
         param1.visible = true;
      }
      
      protected function ActionReset(param1:TUIOrganizationalWarPlayer) : void
      {
         var _loc2_:TUIOrganizationalPlayers = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc2_ = param1.ExistPool as TUIOrganizationalPlayers;
         _loc4_ = this.CheckIfMainRole(param1);
         if(_loc4_)
         {
            this.FMC_Arrow.visible = false;
         }
         if(_loc2_ != null)
         {
            _loc2_.DeleteRoleByIdentifier(param1.RoleData.Identifier0,param1.RoleData.Identifier1);
         }
         param1.ExistPool = null;
         param1.visible = false;
         param1.StopMove();
      }
      
      protected function GetIndexByCampIDBornID(param1:int, param2:int) : int
      {
         return (param1 - 1) * QUEUE_BATTLE_NUM + param2 - 1;
      }
      
      protected function CheckIfMainRole(param1:TUIOrganizationalWarPlayer) : Boolean
      {
         var _loc2_:TCharacter = null;
         _loc2_ = SLogicsCore.Character;
         return param1.RoleData.Identifier0 == _loc2_.Identifier0 && param1.RoleData.Identifier1 == _loc2_.Identifier1;
      }
      
      protected function GetDirectionByCampID(param1:int) : int
      {
         switch(param1)
         {
            case CAMPFRIEND:
               return CONST_MainScene.DIRECTION_Left;
            case CAMPENEMY:
               return CONST_MainScene.DIRECTION_RIGHT;
            default:
               return 0;
         }
      }
      
      protected function GetLocalCampIDByServerCampID(param1:uint) : int
      {
         if(param1 == this.FGoalData.CampFlag)
         {
            return CAMPFRIEND;
         }
         return CAMPENEMY;
      }
      
      protected function IfInWaitQueue(param1:TUIOrganizationalPlayers) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = this.FQueues_Wait.indexOf(param1);
         return _loc2_ >= 0;
      }
      
      protected function AllRoleAdvance(param1:TUIOrganizationalPlayers, param2:TUIOrganizationalWarPlayer) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TUIOrganizationalWarPlayer = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.Count)
         {
            _loc4_ = param1.GetRoleByIndex(_loc3_);
            if(_loc4_ == param2)
            {
               break;
            }
            _loc3_++;
         }
         _loc5_ = _loc4_.RoleData.BattleStartTime;
         _loc3_++;
         while(_loc3_ < param1.Count)
         {
            _loc4_ = param1.GetRoleByIndex(_loc3_);
            _loc6_ = _loc4_.RoleData.BattleStartTime;
            _loc4_.RoleData.BattleStartTime = _loc5_;
            _loc5_ = _loc6_;
            _loc3_++;
         }
      }
      
      protected function GetCurrentServerTime() : Number
      {
         return this.FSeverStartTime + STimingCore.TickCount - this.FTickStoreGetServerTime;
      }
      
      protected function SynchronousTime(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FTickStoreGetServerTime = STimingCore.TickCount;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedInt();
         this.FSeverStartTime = _loc2_ * 4294967296 + _loc3_;
      }
      
      protected function CheckIfMainRoleInQueue(param1:Vector.<TUIOrganizationalPlayers>) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:TUIOrganizationalWarPlayer = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_].GetRoleByIdentifier(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1);
            if(_loc3_ != null)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      protected function RequestChangeQueue(param1:Object) : void
      {
         if(this.FCommandRequest != null)
         {
            this.FCommandRequest(CONST_ORGANIZATIONALWAR.CommandID_EnterQueue,this.FQueueIndex,null);
         }
      }
      
      protected function UpdateEndTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:TTimeCoolDown = null;
         _loc1_ = this.GetCurrentServerTime() / 1000 - STimingCore.ServerTimeZone;
         _loc1_ %= CONST_COMMON.SecondPerDay;
         if(_loc1_ < this.FGoalData.Time_BattleEnd)
         {
            _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_ActiveColdTime);
            _loc2_.TimingTime = this.FGoalData.Time_BattleEnd - _loc1_;
         }
      }
      
      protected function BirthPlaceClicked(param1:MouseEvent) : void
      {
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:Boolean = false;
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_DieColdTime);
         if(_loc2_.TimingTime > 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_13));
            return;
         }
         _loc3_ = this.CheckIfMainRoleInQueue(this.FQueues_Battle);
         if(_loc3_)
         {
            return;
         }
         this.FQueueIndex = this.FMCBirthPlace.indexOf(param1.currentTarget as MovieClip);
         ++this.FQueueIndex;
         _loc3_ = this.CheckIfMainRoleInQueue(this.FQueues_Wait);
         if(_loc3_)
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_14);
            this.FUIWindowConfirmation.OnOK = this.RequestChangeQueue;
            this.FUIWindowConfirmation.Visible = true;
            return;
         }
         this.RequestChangeQueue(null);
      }
      
      protected function UpdateRoad() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FGoalData.RoadNum)
         {
            this.FMCBirthPlace[_loc1_].visible = true;
            this.FMCBirthPlace[_loc1_ + QUEUE_BATTLE_NUM].visible = true;
            this.FPath[_loc1_].visible = true;
            _loc1_++;
         }
         _loc1_ = int(this.FGoalData.RoadNum);
         while(_loc1_ < QUEUE_BATTLE_NUM)
         {
            this.FMCBirthPlace[_loc1_].visible = false;
            this.FMCBirthPlace[_loc1_ + QUEUE_BATTLE_NUM].visible = false;
            this.FPath[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function GetPlayerCurrentNameColor(param1:int) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc2_ = 0;
         while(_loc2_ < this.FGoalData.RoleWinTimes.length)
         {
            _loc3_ = this.FGoalData.RoleWinTimes[_loc2_];
            if(param1 <= _loc3_[1] && param1 >= _loc3_[0])
            {
               return this.FGoalData.RoleChangeColors[_loc2_];
            }
            _loc2_++;
         }
         return this.FGoalData.RoleChangeColors[0];
      }
      
      protected function BirthPlaceMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.FOnHintOver != null)
         {
            _loc3_ = this.FMCBirthPlace.indexOf(_loc2_);
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_20) + this.FQueues_Wait[_loc3_].Count;
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function BirthPlaceMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      public function set GoalData(param1:TOrganizationalWarGoalData) : void
      {
         this.FGoalData = param1;
      }
      
      public function get CommandRequest() : Function
      {
         return this.FCommandRequest;
      }
      
      public function set CommandRequest(param1:Function) : void
      {
         this.FCommandRequest = param1;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function set SetDailyActivityStatus(param1:Function) : void
      {
         this.FSetDailyActivityStatus = param1;
      }
      
      public function set OnScoreChanged(param1:Function) : void
      {
         this.FOnScoreChanged = param1;
      }
      
      public function RoleFight(param1:uint, param2:uint, param3:uint, param4:uint, param5:int) : void
      {
         var _loc6_:TUIOrganizationalWarPlayer = null;
         var _loc7_:TUIOrganizationalWarPlayer = null;
         var _loc8_:TUIOrganizationalPlayers = null;
         var _loc9_:TTimeCoolDown = null;
         var _loc10_:uint = 0;
         var _loc11_:MovieClip = null;
         var _loc12_:Boolean = false;
         _loc6_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(param1,param2);
         _loc7_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(param3,param4);
         if(_loc6_ != null)
         {
            _loc6_.RoleData.BloodRate = param5;
            ++_loc6_.RoleData.ConsecutiveVictories;
            _loc12_ = this.CheckIfMainRole(_loc6_);
            if(_loc12_)
            {
               this.FGoalData.WinTimes = _loc6_.RoleData.ConsecutiveVictories;
            }
            _loc10_ = this.GetPlayerCurrentNameColor(_loc6_.RoleData.ConsecutiveVictories);
            _loc6_.ChangeColor(_loc10_);
            _loc6_.UpdateBooldRate();
         }
         if(_loc7_ != null)
         {
            _loc12_ = this.CheckIfMainRole(_loc7_);
            if(_loc12_)
            {
               _loc9_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_DieColdTime);
               _loc9_.TimingTime = this.FGoalData.DieColdDownTime;
               this.FGoalData.WinTimes = 0;
            }
         }
         if(_loc7_ != null)
         {
            this.ActionReset(_loc7_);
         }
         if(_loc6_.RoleData.BirthPlaceID == 0)
         {
            return;
         }
         _loc11_ = this.FBooms[_loc6_.RoleData.BirthPlaceID - 1];
         _loc11_.gotoAndPlay(1);
         _loc11_.visible = true;
         _loc11_.x = (_loc6_.x + _loc6_.x) / 2;
         _loc11_.y = (_loc6_.y + _loc6_.y) / 2;
      }
      
      public function RoleEnterQueue(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIOrganizationalWarPlayer = null;
         var _loc5_:TUIOrganizationalPlayers = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         this.SynchronousTime(param1.Data);
         _loc13_ = int(param1.Data.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc13_)
         {
            _loc2_ = param1.Data.readUnsignedInt();
            _loc3_ = param1.Data.readUnsignedInt();
            _loc4_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc2_,_loc3_);
            if(_loc4_.ExistPool != null)
            {
               _loc5_ = _loc4_.ExistPool as TUIOrganizationalPlayers;
               _loc7_ = this.IfInWaitQueue(_loc5_);
               if(_loc7_)
               {
                  this.AllRoleAdvance(_loc5_,_loc4_);
               }
               this.ActionReset(_loc4_);
            }
            _loc9_ = param1.Data.readUnsignedInt();
            _loc10_ = param1.Data.readUnsignedInt();
            _loc4_.RoleData.BattleStartTime = _loc9_ * 4294967296 + _loc10_;
            _loc4_.RoleData.BirthPlaceID = param1.Data.readUnsignedByte();
            if(_loc4_.RoleData.BirthPlaceID <= 0)
            {
               _loc4_.RoleData.BirthPlaceID = 1;
            }
            _loc4_.RoleData.BloodRate = param1.Data.readUnsignedByte();
            _loc4_.RoleData.ConsecutiveVictories = param1.Data.readUnsignedInt();
            _loc8_ = this.GetPlayerCurrentNameColor(_loc4_.RoleData.ConsecutiveVictories);
            _loc4_.ChangeColor(_loc8_);
            _loc4_.UpdateBooldRate();
            _loc14_ = this.GetIndexByCampIDBornID(_loc4_.RoleData.CampID,_loc4_.RoleData.BirthPlaceID);
            _loc5_ = this.FQueues_Wait[_loc14_];
            _loc5_.Add(_loc4_);
            _loc4_.ExistPool = _loc5_;
            _loc12_ = this.CheckIfMainRole(_loc4_);
            if(_loc12_)
            {
               this.FGoalData.WinTimes = _loc4_.RoleData.ConsecutiveVictories;
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_15));
            }
            _loc6_++;
         }
      }
      
      public function RoleQuit(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIOrganizationalWarPlayer = null;
         var _loc5_:Boolean = false;
         var _loc6_:TUIOrganizationalPlayers = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc2_,_loc3_);
         if(_loc4_.ExistPool != null)
         {
            _loc6_ = _loc4_.ExistPool as TUIOrganizationalPlayers;
            _loc5_ = this.IfInWaitQueue(_loc6_);
            if(_loc5_)
            {
               this.AllRoleAdvance(_loc6_,_loc4_);
            }
         }
         this.ActionReset(_loc4_);
      }
      
      public function AddNewRole(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TUIOrganizationalWarPlayer = null;
         var _loc5_:TOrganizationRole = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TUIOrganizationalWarPlayer = null;
         _loc3_ = param1.Data;
         this.FGoalData.RoadNum = _loc3_.readUnsignedByte();
         this.UpdateRoad();
         this.FGoalData.CurrentInspironNum = _loc3_.readUnsignedInt();
         this.SynchronousTime(_loc3_);
         this.UpdateEndTime();
         this.FGoalData.CampFlag = _loc3_.readUnsignedByte();
         _loc2_ = int(_loc3_.readUnsignedByte());
         _loc2_ = this.GetLocalCampIDByServerCampID(_loc2_);
         _loc7_ = int(_loc3_.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = new TUIOrganizationalWarPlayer(this);
            _loc5_ = new TOrganizationRole(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
            _loc4_.Direction = _loc2_ == CAMPFRIEND ? TUIOrganizationalWarPlayer.Direction_Up : TUIOrganizationalWarPlayer.Direction_Down;
            _loc5_.CampID = _loc2_;
            _loc5_.TempleteID = _loc3_.readUnsignedInt();
            _loc5_.Name = TUtilityString.FetchUTF(_loc3_);
            _loc5_.RoleLevel = _loc3_.readUnsignedShort();
            _loc5_.TotalScore = _loc3_.readUnsignedInt();
            _loc5_.OrganizationalID = _loc3_.readUnsignedInt();
            _loc4_.RoleData = _loc5_;
            _loc4_.Init();
            _loc10_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc5_.Identifier0,_loc5_.Identifier1);
            if(_loc10_ == null)
            {
               this.FGoalData.OrganizationRole.Add(_loc4_);
            }
            _loc6_++;
         }
      }
      
      public function ContorlBirthPlace(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.FMCBirthPlace == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this.FMCBirthPlace.length)
         {
            if(param1)
            {
               this.FMCBirthPlace[_loc2_].play();
            }
            else
            {
               this.FMCBirthPlace[_loc2_].stop();
            }
            _loc2_++;
         }
      }
      
      public function BackToTown() : void
      {
         this.ResetAllPlayer();
         this.FMC_Arrow.visible = false;
      }
   }
}

