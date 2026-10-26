package Processors.Game.Lobby.TeamBattle.Room
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Rooms.Seat.*;
   import Logics.Rooms.Seat.Player.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.TeamBattle.Room.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowPreparation extends TProcessorLobbyWindow
   {
      
      protected static const AFFAIRID_TimingWaitStartBattlePve:uint = 1;
      
      protected static const AFFAIRID_TimingWaitStartMatchingBattlePvP:uint = 2;
      
      protected static const AFFAIRID_TimingWaitAgainMatchingBattlePvP:uint = 3;
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      protected static const CAPACITY_PLAYERS:uint = CONST_TEAMBATTLE.CAPACITY_PLAYERS;
      
      protected static const CAPACITY_MONSTERS:uint = CONST_TEAMBATTLE.CAPACITY_MONSTERS;
      
      protected static const TYPE_OPERATING_CHANGEPOSITION:uint = CONST_TEAMBATTLE.TYPE_OPERATING_CHANGEPOSITION;
      
      protected static const TYPE_CHANGE_TOP_DOWN:uint = CONST_TEAMBATTLE.TYPE_CHANGE_TOP_DOWN;
      
      protected static const TYPE_CHANGE_MIDDLE_UP:uint = CONST_TEAMBATTLE.TYPE_CHANGE_MIDDLE_UP;
      
      protected static const TYPE_CHANGE_MIDDLE_DOWN:uint = CONST_TEAMBATTLE.TYPE_CHANGE_MIDDLE_DOWN;
      
      protected static const TYPE_CHANGE_BOTTOM_UP:uint = CONST_TEAMBATTLE.TYPE_CHANGE_BOTTOM_UP;
      
      protected static const STEP_BATTLEWAIT:uint = CONST_TEAMBATTLE.STEP_BATTLEWAIT;
      
      protected static const STEP_BATTLENOW:uint = CONST_TEAMBATTLE.STEP_BATTLENOW;
      
      public static const TYPE_MATCHING_AGAIN:uint = CONST_TEAMBATTLE.TYPE_MATCHING_AGAIN;
      
      public static const TYPE_MATCHING_CANCEL:uint = CONST_TEAMBATTLE.TYPE_MATCHING_CANCEL;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FRoomSeatInfo:TRoomSeatInfo;
      
      protected var FHint:THint;
      
      protected var FSP_Preparation:Sprite;
      
      protected var FBmpBackground:Bitmap;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FSP_PVE:Sprite;
      
      protected var FUIPlayersPve:Vector.<TUIHero>;
      
      protected var FUIMonsters:Vector.<TUIHero>;
      
      protected var FUIPlayerSmalls:Vector.<TUIPlayerSmall>;
      
      protected var FSP_MonsterIcons:Vector.<Sprite>;
      
      protected var FBmp_MonsterIcons:Vector.<Bitmap>;
      
      protected var FBtn_Top_ChangeDown:TUIButton;
      
      protected var FBtn_Middle_ChangeUp:TUIButton;
      
      protected var FBtn_Middle_ChangeDown:TUIButton;
      
      protected var FBtn_Bottom_ChangeUp:TUIButton;
      
      protected var FBtn_BattleWait:TUIButton;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FSP_PVP:Sprite;
      
      protected var FSP_Matching:Sprite;
      
      protected var FTF_Time:TextField;
      
      protected var FBtn_AgainMatching:TUIButton;
      
      protected var FBtn_CancelMatching:TUIButton;
      
      protected var FUIPlayerDoubles:Vector.<TUIPlayerDouble>;
      
      protected var FStep:uint;
      
      protected var FMapID:uint;
      
      protected var FTickStartBattlePve:int;
      
      protected var FTickStartBattlePvP:int;
      
      protected var FTickAgainMatchingBattlePvP:int;
      
      protected var FIsTerminationStartBattlePve:Boolean;
      
      protected var FIsTerminationStartBattlePvP:Boolean;
      
      protected var FIsTerminationAgainMatchingBattlePvP:Boolean;
      
      protected var FTimePveIntervalWaitStartGame:uint;
      
      protected var FTimePveIntervalNowStartGame:uint;
      
      protected var FTimePvpIntervalBattleMatching:uint;
      
      protected var FTimePvpIntervalOpenMatch:uint;
      
      protected var FTimePvpIntervalAgainMatch:uint;
      
      protected var FTimeIntervalRefreshStartBattle:int;
      
      protected var FIsOpenAgainMatching:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnPlayerTipOver:Function;
      
      protected var FOnPlayerTipOut:Function;
      
      public function TProcessorWindowPreparation(param1:TUIComponent)
      {
         super(param1);
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FRoomSeatInfo = this.FTeamBattle.RoomSeatInfo;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattlePreparation);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:TUIHero = null;
         var _loc5_:TUIPlayerDouble = null;
         var _loc6_:TUIPlayerSmall = null;
         var _loc7_:Bitmap = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         this.FHint = new THint();
         this.FRolesModelID = new Vector.<int>();
         this.FSP_Preparation = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_SP_Preparation) as Sprite;
         this.addChild(this.FSP_Preparation);
         _loc2_ = this.FSP_Preparation[CONST_TEAMBATTLE.RESOURCE_Link_SP_MountPoint];
         this.FBmpBackground = new Bitmap();
         _loc2_.addChild(this.FBmpBackground);
         this.FSP_PVE = this.FSP_Preparation[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVE];
         this.FUIPlayersPve = new Vector.<TUIHero>(CAPACITY_PLAYERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc2_ = this.FSP_PVE[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPosition_PVE_L + _loc1_];
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc4_ = new TUIHero(this);
            _loc2_.addChild(_loc4_);
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            _loc4_.SequenceDefaultRole.Evaluate(_loc9_,_loc8_);
            _loc4_.X = _loc8_.X;
            _loc4_.Y = _loc8_.Y;
            this.FUIPlayersPve[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIMonsters = new Vector.<TUIHero>(CAPACITY_MONSTERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            _loc2_ = this.FSP_PVE[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPosition_PVE_R + _loc1_];
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc4_ = new TUIHero(this);
            _loc2_.addChild(_loc4_);
            _loc4_.scaleX = -1;
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            _loc4_.SequenceDefaultRole.Evaluate(_loc9_,_loc8_);
            _loc4_.X = _loc8_.X;
            _loc4_.Y = _loc8_.Y;
            this.FUIMonsters[_loc1_] = _loc4_;
            _loc1_++;
         }
         _loc2_ = this.FSP_PVE[CONST_TEAMBATTLE.RESOURCE_Link_SP_ChangePosition];
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = _loc2_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.Btn_CloseOnClick;
         _loc2_ = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_ChangePosition];
         this.FUIPlayerSmalls = new Vector.<TUIPlayerSmall>(CAPACITY_PLAYERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc6_ = new TUIPlayerSmall(null);
            _loc6_.Resource = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_Player + _loc1_];
            _loc6_.OnMove = this.UIPlayerSmallOnMove;
            _loc6_.OnOut = this.UIPlayerSmallOnOut;
            _loc6_.Perform_UIDispatch();
            this.FUIPlayerSmalls[_loc1_] = _loc6_;
            _loc1_++;
         }
         this.FSP_MonsterIcons = new Vector.<Sprite>(CAPACITY_MONSTERS);
         this.FBmp_MonsterIcons = new Vector.<Bitmap>(CAPACITY_MONSTERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            _loc3_ = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_MonsterIcon + _loc1_];
            _loc7_ = new Bitmap();
            _loc3_.addChild(_loc7_);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.SP_MonsterIconOnMove,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.SP_MonsterIconOnOut,false,0,true);
            this.FBmp_MonsterIcons[_loc1_] = _loc7_;
            this.FSP_MonsterIcons[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FBtn_Top_ChangeDown = new TUIButton();
         this.FBtn_Top_ChangeDown.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Top_ChangeDown];
         this.FBtn_Top_ChangeDown.OnClick = this.Btn_Top_ChangeDownOnClick;
         this.FBtn_Middle_ChangeUp = new TUIButton();
         this.FBtn_Middle_ChangeUp.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Middle_ChangeUp];
         this.FBtn_Middle_ChangeUp.OnClick = this.Btn_Middle_ChangeUpOnClick;
         this.FBtn_Middle_ChangeDown = new TUIButton();
         this.FBtn_Middle_ChangeDown.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Middle_ChangeDown];
         this.FBtn_Middle_ChangeDown.OnClick = this.Btn_Middle_ChangeDownOnClick;
         this.FBtn_Bottom_ChangeUp = new TUIButton();
         this.FBtn_Bottom_ChangeUp.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Bottom_ChangeUp];
         this.FBtn_Bottom_ChangeUp.OnClick = this.Btn_Bottom_ChangeUpOnClick;
         this.FBtn_BattleWait = new TUIButton();
         this.FBtn_BattleWait.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_BattleWait];
         this.FBtn_BattleWait.OnClick = this.Btn_BattleWaitOnClick;
         this.FSP_PVP = this.FSP_Preparation[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVP];
         this.FUIPlayerDoubles = new Vector.<TUIPlayerDouble>(CAPACITY_PLAYERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc2_ = this.FSP_PVP[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPosition_PVP + _loc1_];
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc5_ = new TUIPlayerDouble(null);
            _loc5_.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_SP_Heros) as Sprite;
            _loc5_.OnHeroQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc5_.OnKnifeQuerySequenceContext = this.KnifeOnQuerySequenceContext;
            _loc5_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc5_.Perform_UIDispatch();
            _loc2_.addChild(_loc5_);
            this.FUIPlayerDoubles[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FSP_Matching = this.FSP_PVP[CONST_TEAMBATTLE.RESOURCE_Link_SP_Matching];
         this.FTF_Time = this.FSP_Matching[CONST_TEAMBATTLE.RESOURCE_Link_TF_Time];
         this.FBtn_AgainMatching = new TUIButton();
         this.FBtn_AgainMatching.Substrate = this.FSP_Matching[CONST_TEAMBATTLE.RESOURCE_Link_Btn_AgainMatching];
         this.FBtn_AgainMatching.OnClick = this.Btn_AgainMatchingOnClick;
         this.FBtn_AgainMatching.OnMove = this.Btn_AgainMatchingOnMove;
         this.FBtn_AgainMatching.OnOut = this.Btn_AgainMatchingOnOut;
         this.FBtn_CancelMatching = new TUIButton();
         this.FBtn_CancelMatching.Substrate = this.FSP_Matching[CONST_TEAMBATTLE.RESOURCE_Link_Btn_CancelMatching];
         this.FBtn_CancelMatching.OnClick = this.Btn_CancelMatchingOnClick;
         this.FBtn_CancelMatching.OnMove = this.Btn_CancelMatchingOnMove;
         this.FBtn_CancelMatching.OnOut = this.Btn_CancelMatchingOnOut;
         this.FTimePveIntervalWaitStartGame = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Pveready) as TConfigValue).Value) * 1000;
         this.FTimePveIntervalNowStartGame = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Pvefight) as TConfigValue).Value) * 1000;
         this.FTimePvpIntervalBattleMatching = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Matchlimit) as TConfigValue).Value);
         this.FTimePvpIntervalOpenMatch = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Matchcancel) as TConfigValue).Value);
         this.FTimePvpIntervalAgainMatch = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_PvpReprepare) as TConfigValue).Value) * 1000;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitStartBattlePve,this.AffairPerform_TimingWaitStartBattlePve);
         FAffairRoutines.Register(AFFAIRID_TimingWaitStartMatchingBattlePvP,this.AffairPerform_TimingWaitStartMatchingBattlePvp);
         FAffairRoutines.Register(AFFAIRID_TimingWaitAgainMatchingBattlePvP,this.AffairPerform_TimingWaitAgainMatchingBattlePvP);
      }
      
      protected function AffairPerform_TimingWaitStartBattlePve(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitStartBattlePve();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitStartBattlePve() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc1_ = int(STimingCore.TickCount);
         if(this.FIsTerminationStartBattlePve)
         {
            this.FIsTerminationStartBattlePve = false;
            return false;
         }
         if(_loc1_ - this.FTickStartBattlePve >= this.FTimeIntervalRefreshStartBattle)
         {
            if(this.FStep == STEP_BATTLEWAIT)
            {
               if(this.FRoomSeatInfo.OneselfIndex == this.FRoomSeatInfo.RoomOwnerIndex)
               {
                  this.FBtn_BattleWait.Enabled = true;
               }
               this.FStep = STEP_BATTLENOW;
               this.FTimeIntervalRefreshStartBattle = this.FTimePveIntervalNowStartGame;
               this.FTickStartBattlePve = STimingCore.TickCount;
               FAffairGenerator.Generate(AFFAIRID_TimingWaitStartBattlePve);
            }
            else if(this.FStep == STEP_BATTLENOW)
            {
            }
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (this.FTimeIntervalRefreshStartBattle - (_loc1_ - this.FTickStartBattlePve)) / 1000;
            if(this.FStep == STEP_BATTLEWAIT)
            {
               _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_45),_loc2_);
            }
            else if(this.FStep == STEP_BATTLENOW)
            {
               _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_46),_loc2_);
            }
            this.FBtn_BattleWait.Caption = _loc3_;
         }
         return true;
      }
      
      protected function AffairPerform_TimingWaitStartMatchingBattlePvp(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitStartMatchingBattlePvp();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitStartMatchingBattlePvp() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(this.FIsTerminationStartBattlePvP)
         {
            this.FIsTerminationStartBattlePvP = false;
            return false;
         }
         if(_loc1_ - this.FTickStartBattlePvP >= this.FTimeIntervalRefreshStartBattle)
         {
            this.FTimeIntervalRefreshStartBattle = this.FTimePvpIntervalAgainMatch;
            this.FTickAgainMatchingBattlePvP = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitAgainMatchingBattlePvP);
            this.FTF_Time.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_52);
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (_loc1_ - this.FTickStartBattlePvP) / 1000;
            if(_loc2_ >= this.FTimePvpIntervalOpenMatch)
            {
               if(!this.FIsOpenAgainMatching)
               {
                  if(this.FRoomSeatInfo.OneselfIndex == this.FRoomSeatInfo.RoomOwnerIndex)
                  {
                     this.FBtn_AgainMatching.Enabled = true;
                     this.FBtn_CancelMatching.Enabled = true;
                  }
                  this.FIsOpenAgainMatching = true;
               }
            }
            this.FTF_Time.text = TUtilityTiming.FormatMSBySeconds(_loc2_);
         }
         return true;
      }
      
      protected function AffairPerform_TimingWaitAgainMatchingBattlePvP(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitAgainMatchingBattlePvP();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitAgainMatchingBattlePvP() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(this.FIsTerminationAgainMatchingBattlePvP)
         {
            this.FIsTerminationAgainMatchingBattlePvP = false;
            return false;
         }
         if(_loc1_ - this.FTickAgainMatchingBattlePvP >= this.FTimeIntervalRefreshStartBattle)
         {
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (this.FTimeIntervalRefreshStartBattle - (_loc1_ - this.FTickAgainMatchingBattlePvP)) / 1000;
            if(_loc2_ <= 0)
            {
               if(this.FRoomSeatInfo.OneselfIndex == this.FRoomSeatInfo.RoomOwnerIndex)
               {
                  this.FBtn_AgainMatching.Enabled = false;
                  this.FBtn_CancelMatching.Enabled = false;
               }
               this.FIsOpenAgainMatching = false;
               this.FBtn_AgainMatching.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_47);
               this.FBtn_AgainMatching.Enabled = false;
               this.FBtn_CancelMatching.Enabled = false;
               return false;
            }
            this.FBtn_AgainMatching.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_48),_loc2_);
         }
         return true;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_PLAYERS)
               {
                  this.FUIPlayersPve[_loc1_].Update();
                  this.FUIPlayerDoubles[_loc1_].Update();
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_MONSTERS)
               {
                  this.FUIMonsters[_loc1_].Update();
                  _loc1_++;
               }
            }
         }
      }
      
      protected function ProcessorUpdatePVE() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TPlayerRoomDigest = null;
         var _loc3_:Vector.<TPlayerRoomDigest> = null;
         _loc3_ = this.FRoomSeatInfo.MonsterDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            _loc2_ = _loc3_[_loc1_];
            if(_loc2_.Identifier0 != 0)
            {
               this.FUIMonsters[_loc1_].Context = _loc2_;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.RoleHeadID,this.AutoLoadCallBack);
            }
            _loc1_++;
         }
         this.FBtn_BattleWait.Enabled = false;
         this.FStep = STEP_BATTLEWAIT;
         this.FIsTerminationStartBattlePve = false;
         this.FSP_PVE.visible = true;
         this.FSP_PVP.visible = false;
      }
      
      protected function ProcessorUpdatePVP() : void
      {
         this.FBtn_AgainMatching.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_47);
         this.FIsOpenAgainMatching = false;
         this.FBtn_AgainMatching.Enabled = false;
         this.FBtn_CancelMatching.Enabled = false;
         this.FIsTerminationStartBattlePvP = false;
         this.FIsTerminationAgainMatchingBattlePvP = false;
         this.FSP_PVP.visible = true;
         this.FSP_PVE.visible = false;
      }
      
      protected function ProcessorUpdateBackground() : void
      {
         var _loc1_:TLeagueMapPve = null;
         var _loc2_:TLeagueMapPvp = null;
         var _loc3_:uint = 0;
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve,this.FRoomSeatInfo.ModelID) as TLeagueMapPve;
            _loc3_ = _loc1_.MapID;
         }
         else
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp,this.FRoomSeatInfo.ModelID) as TLeagueMapPvp;
            _loc3_ = _loc2_.MapID;
         }
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(_loc3_,this.AutoLoadCallBack);
         this.FMapID = _loc3_;
      }
      
      protected function ProcessorUpdatePveFriendlyForces() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPlayerRoomDigest = null;
         var _loc5_:Vector.<TPlayerRoomDigest> = null;
         _loc5_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FUIPlayersPve[_loc1_].Context = null;
            this.FUIPlayerSmalls[_loc1_].Context = null;
            _loc1_++;
         }
         _loc2_ = this.FRoomSeatInfo.RoomOwnerIndex;
         _loc3_ = this.FRoomSeatInfo.OneselfIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc4_ = _loc5_[_loc1_];
            if(_loc4_.Identifier0 != 0 || _loc4_.Identifier1 != 0)
            {
               _loc4_.OneselfSeatIndex = _loc3_;
               _loc4_.RoomOwnerIndex = _loc2_;
               this.FUIPlayersPve[_loc4_.SeatIndex].Context = _loc4_;
               this.FUIPlayerSmalls[_loc4_.SeatIndex].Context = _loc4_;
            }
            _loc1_++;
         }
         if(_loc2_ == _loc3_)
         {
            this.ProcessorUpdateChangeStatus();
            this.FBtn_Top_ChangeDown.Visible = true;
            this.FBtn_Middle_ChangeUp.Visible = true;
            this.FBtn_Middle_ChangeDown.Visible = true;
            this.FBtn_Bottom_ChangeUp.Visible = true;
         }
         else
         {
            this.FBtn_Top_ChangeDown.Visible = false;
            this.FBtn_Middle_ChangeUp.Visible = false;
            this.FBtn_Middle_ChangeDown.Visible = false;
            this.FBtn_Bottom_ChangeUp.Visible = false;
         }
         if(this.FRoomSeatInfo.PlayerCount <= 2)
         {
            this.FBtn_Close.Visible = true;
         }
         else
         {
            this.FBtn_Close.Visible = false;
         }
      }
      
      protected function ProcessorUpdateChangeStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TPlayerRoomDigest = null;
         var _loc3_:Vector.<TPlayerRoomDigest> = null;
         _loc3_ = this.FRoomSeatInfo.PlayerRoomDigests;
         this.FBtn_Top_ChangeDown.Enabled = false;
         this.FBtn_Middle_ChangeUp.Enabled = false;
         this.FBtn_Middle_ChangeDown.Enabled = false;
         this.FBtn_Bottom_ChangeUp.Enabled = false;
         _loc1_ = 0;
         for(; _loc1_ < CAPACITY_PLAYERS; _loc1_++)
         {
            _loc2_ = _loc3_[_loc1_];
            if(!(_loc2_.Identifier0 != 0 || _loc2_.Identifier1 != 0))
            {
               continue;
            }
            switch(_loc2_.SeatIndex)
            {
               case 0:
                  this.FBtn_Top_ChangeDown.Enabled = true;
                  break;
               case 1:
                  this.FBtn_Middle_ChangeUp.Enabled = true;
                  this.FBtn_Middle_ChangeDown.Enabled = true;
                  break;
               case 2:
                  this.FBtn_Bottom_ChangeUp.Enabled = true;
            }
         }
      }
      
      protected function ProcessorUpdatePvpFriendlyForces() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPlayerRoomDigest = null;
         var _loc5_:Vector.<TPlayerRoomDigest> = null;
         _loc5_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FUIPlayerDoubles[_loc1_].Context = null;
            _loc1_++;
         }
         _loc2_ = this.FRoomSeatInfo.RoomOwnerIndex;
         _loc3_ = this.FRoomSeatInfo.OneselfIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc4_ = _loc5_[_loc1_];
            if(_loc4_.Identifier0 != 0 || _loc4_.Identifier1 != 0)
            {
               _loc4_.OneselfSeatIndex = _loc3_;
               _loc4_.RoomOwnerIndex = _loc2_;
               this.FUIPlayerDoubles[_loc4_.SeatIndex].Context = _loc4_;
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorRoomInOperatingReq(param1:uint, param2:uint, param3:TPlayerRoomDigest = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc8_ = param3.SeatIndex;
         switch(param2)
         {
            case TYPE_CHANGE_TOP_DOWN:
               _loc9_ = _loc8_ + 1;
               break;
            case TYPE_CHANGE_MIDDLE_UP:
               _loc9_ = _loc8_ - 1;
               break;
            case TYPE_CHANGE_MIDDLE_DOWN:
               _loc9_ = _loc8_ + 1;
               break;
            case TYPE_CHANGE_BOTTOM_UP:
               _loc9_ = _loc8_ - 1;
         }
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_RoomInOperating);
         _loc7_ = _loc6_.Data;
         _loc7_.writeByte(param1);
         _loc7_.writeByte(_loc8_);
         _loc7_.writeByte(_loc9_);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TAnimationSequence = null;
         var _loc6_:TPlayerRoomDigest = null;
         var _loc7_:Vector.<TPlayerRoomDigest> = null;
         _loc7_ = this.FRoomSeatInfo.MonsterDigests;
         _loc5_ = param2.GetAnimationSequenceByIndex(0);
         _loc4_ = 0;
         while(_loc4_ < CAPACITY_MONSTERS)
         {
            _loc6_ = _loc7_[_loc4_];
            if(_loc6_.RoleHeadID == param3)
            {
               this.FBmp_MonsterIcons[_loc4_].bitmapData = _loc5_.GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
         if(this.FMapID == param3)
         {
            this.FBmpBackground.bitmapData = _loc5_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function GetDigestBySeatIndex(param1:int) : TPlayerRoomDigest
      {
         var _loc2_:int = 0;
         var _loc3_:TPlayerRoomDigest = null;
         var _loc4_:TPlayerRoomDigest = null;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_PLAYERS)
         {
            _loc3_ = this.FRoomSeatInfo.PlayerRoomDigests[_loc2_];
            if(_loc3_.Identifier0 != 0 || _loc3_.Identifier1 != 0)
            {
               if(_loc3_.SeatIndex == param1)
               {
                  _loc4_ = _loc3_;
                  break;
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function Btn_CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattlePveReturnRoom);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UIPlayerSmallOnMove(param1:Object, param2:TPlayerRoomDigest) : void
      {
         if(this.FOnPlayerTipOver != null)
         {
            this.FOnPlayerTipOver(this,param2);
         }
      }
      
      protected function UIPlayerSmallOnOut(param1:Object, param2:TPlayerRoomDigest) : void
      {
         if(this.FOnPlayerTipOut != null)
         {
            this.FOnPlayerTipOut(this,param2);
         }
      }
      
      protected function SP_MonsterIconOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TPlayerRoomDigest = null;
         _loc3_ = param1.currentTarget as Sprite;
         _loc2_ = this.FSP_MonsterIcons.indexOf(_loc3_);
         if(_loc2_ < 0)
         {
            return;
         }
         _loc4_ = this.FRoomSeatInfo.MonsterDigests[_loc2_];
         if(this.FOnPlayerTipOver != null)
         {
            this.FOnPlayerTipOver(this,_loc4_);
         }
      }
      
      protected function SP_MonsterIconOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TPlayerRoomDigest = null;
         _loc3_ = param1.currentTarget as Sprite;
         _loc2_ = this.FSP_MonsterIcons.indexOf(_loc3_);
         if(_loc2_ < 0)
         {
            return;
         }
         _loc4_ = this.FRoomSeatInfo.MonsterDigests[_loc2_];
         if(this.FOnPlayerTipOut != null)
         {
            this.FOnPlayerTipOut(this,_loc4_);
         }
      }
      
      protected function Btn_Top_ChangeDownOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPlayerRoomDigest = null;
         _loc3_ = this.GetDigestBySeatIndex(0);
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CHANGEPOSITION,TYPE_CHANGE_TOP_DOWN,_loc3_);
      }
      
      protected function Btn_Middle_ChangeUpOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPlayerRoomDigest = null;
         _loc3_ = this.GetDigestBySeatIndex(1);
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CHANGEPOSITION,TYPE_CHANGE_MIDDLE_UP,_loc3_);
      }
      
      protected function Btn_Middle_ChangeDownOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPlayerRoomDigest = null;
         _loc3_ = this.GetDigestBySeatIndex(1);
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CHANGEPOSITION,TYPE_CHANGE_MIDDLE_DOWN,_loc3_);
      }
      
      protected function Btn_Bottom_ChangeUpOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPlayerRoomDigest = null;
         _loc3_ = this.GetDigestBySeatIndex(2);
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CHANGEPOSITION,TYPE_CHANGE_BOTTOM_UP,_loc3_);
      }
      
      protected function Btn_BattleWaitOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_StartBattlePVE);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function Btn_AgainMatchingOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattleMatching);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(TYPE_MATCHING_AGAIN);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FIsTerminationAgainMatchingBattlePvP = true;
      }
      
      protected function Btn_AgainMatchingOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FBtn_AgainMatching.Enabled)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_49);
            if(this.FHintOnMove != null)
            {
               this.FHintOnMove(this,this.FHint);
            }
         }
      }
      
      protected function Btn_AgainMatchingOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function Btn_CancelMatchingOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattleMatching);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(TYPE_MATCHING_CANCEL);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FIsTerminationStartBattlePvP = true;
      }
      
      protected function Btn_CancelMatchingOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(this.FBtn_CancelMatching.Enabled)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_50);
         }
         else
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_51);
         }
         this.FHint.Caption = _loc3_;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHint);
         }
      }
      
      protected function Btn_CancelMatchingOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPlayerRoomDigest = null;
         var _loc6_:TRoleModel = null;
         _loc5_ = param2 as TPlayerRoomDigest;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.RoleTempleteID) as TRoleModel;
         this.ProcessorQuerySequenceContext(param1,_loc6_,param3,param4);
      }
      
      protected function KnifeOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPlayerRoomDigest = null;
         var _loc6_:TRoleModel = null;
         _loc5_ = param2 as TPlayerRoomDigest;
         if(_loc5_.KnifeID == 0)
         {
            return;
         }
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.KnifeID) as TRoleModel;
         this.ProcessorQuerySequenceContext(param1,_loc6_,param3,param4);
      }
      
      protected function ProcessorQuerySequenceContext(param1:Object, param2:TRoleModel, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TResourceRepositoryTexture = null;
         var _loc6_:TTexture = null;
         var _loc7_:TBounds = null;
         var _loc8_:TCoordinate = null;
         var _loc9_:uint = 0;
         var _loc10_:TUIHero = null;
         _loc10_ = param1 as TUIHero;
         _loc5_ = SResourcesCore.TexturesModel;
         _loc9_ = CONST_ROLE.GetModelIDByIndex(param2.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc6_ = _loc5_.GetTextureByIdentifier(_loc9_);
         if(_loc6_ != null)
         {
            _loc7_ = new TBounds();
            _loc8_ = new TCoordinate();
            param3.Value = _loc6_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc8_,_loc7_);
            if(_loc10_.scaleX == -1)
            {
               _loc10_.X = Math.abs(_loc7_.X);
            }
            else
            {
               _loc10_.X = _loc7_.X;
            }
            _loc10_.Y = _loc7_.Y;
         }
         else
         {
            _loc5_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnPlayerTipOver() : Function
      {
         return this.FOnPlayerTipOver;
      }
      
      public function set OnPlayerTipOver(param1:Function) : void
      {
         this.FOnPlayerTipOver = param1;
      }
      
      public function get OnPlayerTipOut() : Function
      {
         return this.FOnPlayerTipOut;
      }
      
      public function set OnPlayerTipOut(param1:Function) : void
      {
         this.FOnPlayerTipOut = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(!this.FInitialization)
         {
            return;
         }
         this.FBmpBackground.bitmapData = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FUIPlayersPve[_loc1_].Context = null;
            this.FUIPlayerSmalls[_loc1_].Context = null;
            this.FUIPlayerDoubles[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            this.FUIMonsters[_loc1_].Context = null;
            this.FBmp_MonsterIcons[_loc1_].bitmapData = null;
            _loc1_++;
         }
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = uint(this.FRolesModelID[_loc1_]);
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FMapID = 0;
         this.FStep = 0;
         this.FSP_PVE.visible = false;
         this.FSP_PVP.visible = false;
      }
      
      public function Update() : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.ProcessorUpdatePVE();
            this.ProcessorUpdatePveFriendlyForces();
         }
         else
         {
            this.ProcessorUpdatePVP();
            this.ProcessorUpdatePvpFriendlyForces();
         }
         this.ProcessorUpdateBackground();
      }
      
      public function StartTimeCD() : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.UpdateTimeCD(this.FTimePveIntervalWaitStartGame / 1000);
         }
         else
         {
            this.UpdateTimeCD(this.FTimePvpIntervalBattleMatching);
         }
      }
      
      public function UpdateFriendlyForces() : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.ProcessorUpdatePveFriendlyForces();
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            this.ProcessorUpdatePvpFriendlyForces();
         }
      }
      
      public function UpdateTimeCD(param1:uint) : void
      {
         this.FTimeIntervalRefreshStartBattle = param1 * 1000;
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.FTickStartBattlePve = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitStartBattlePve);
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            this.FTickStartBattlePvP = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitStartMatchingBattlePvP);
            this.FBtn_AgainMatching.Enabled = false;
         }
      }
      
      public function UpdateMatching(param1:uint) : void
      {
         var _loc2_:String = null;
         if(param1 == TYPE_MATCHING_AGAIN)
         {
            this.FTickStartBattlePvP = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitStartMatchingBattlePvP);
            this.FBtn_AgainMatching.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_47);
            this.FBtn_AgainMatching.Enabled = false;
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_63);
         }
         else if(param1 == TYPE_MATCHING_CANCEL)
         {
            this.FTimeIntervalRefreshStartBattle = this.FTimePvpIntervalAgainMatch;
            this.FTickAgainMatchingBattlePvP = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitAgainMatchingBattlePvP);
            if(this.FRoomSeatInfo.OneselfIndex == this.FRoomSeatInfo.RoomOwnerIndex)
            {
               this.FBtn_AgainMatching.Enabled = true;
            }
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_64);
         }
         if(this.FRoomSeatInfo.OneselfIndex != this.FRoomSeatInfo.RoomOwnerIndex)
         {
            EffectGenerateText(_loc2_);
         }
         this.FIsOpenAgainMatching = false;
         this.FBtn_CancelMatching.Enabled = false;
      }
      
      public function BattleStartWaitReq() : void
      {
         var _loc1_:TPacket = null;
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattlePveStartWait);
            SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
         }
      }
      
      public function SyncBattleWait() : void
      {
         this.FIsTerminationStartBattlePve = true;
         this.FIsTerminationStartBattlePvP = true;
         this.FIsTerminationAgainMatchingBattlePvP = true;
      }
   }
}

