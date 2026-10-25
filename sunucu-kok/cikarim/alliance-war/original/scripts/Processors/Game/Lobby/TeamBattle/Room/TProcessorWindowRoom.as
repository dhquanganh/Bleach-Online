package Processors.Game.Lobby.TeamBattle.Room
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HyperStrings.Elements.THyperStringElement;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import Logics.HyperStrings.THyperString;
   import Logics.Inventories.*;
   import Logics.Rooms.Seat.*;
   import Logics.Rooms.Seat.Player.*;
   import Logics.Streamization.Inventories.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.Room.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowRoom extends TProcessorLobbyWindow
   {
      
      protected static const PVE_PlayerCountLimit:uint = 1;
      
      protected static const PVP_PlayerCountLimit:uint = 1;
      
      protected static const AFFAIRID_TimingWaitTransferLeader:uint = 1;
      
      protected static const AFFAIRID_TimingWaitReadyStartGame:uint = 2;
      
      protected static const AFFAIRID_TimingWaitAnnouncementCD:uint = 3;
      
      protected static const TIME_INTERVAL_ANNOUNCEMENT_CD_PERIOD:int = 10000;
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      protected static const TYPE_OPERATING_READY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_READY;
      
      protected static const TYPE_OPERATING_CANCEL:uint = CONST_TEAMBATTLE.TYPE_OPERATING_CANCEL;
      
      protected static const TYPE_OPERATING_APPLY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_APPLY;
      
      protected static const TYPE_OPERATING_KICK:uint = CONST_TEAMBATTLE.TYPE_OPERATING_KICK;
      
      protected static const TYPE_OPERATING_TRANSFER:uint = CONST_TEAMBATTLE.TYPE_OPERATING_TRANSFER;
      
      protected static const TYPE_OPERATING_LEAVE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_LEAVE;
      
      protected static const TYPE_OPERATING_REFUSALAPPLY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_REFUSALAPPLY;
      
      protected static const TYPE_OPERATING_STARTGAME:uint = CONST_TEAMBATTLE.TYPE_OPERATING_STARTGAME;
      
      protected static const FRAME_PVE_Normal:uint = CONST_TEAMBATTLE.FRAME_PVE_Normal;
      
      protected static const FRAME_PVE_Hard:uint = CONST_TEAMBATTLE.FRAME_PVE_Hard;
      
      protected static const FRAME_PVP:uint = CONST_TEAMBATTLE.FRAME_PVP;
      
      protected static const CAPACITY_PLAYERS:uint = CONST_TEAMBATTLE.CAPACITY_PLAYERS;
      
      protected static const CAPACITY_Reward_Slots:uint = CONST_TEAMBATTLE.CAPACITY_Reward_Slots;
      
      protected var FCharacter:TCharacter;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FRoomSeatInfo:TRoomSeatInfo;
      
      protected var FLeagueMapPves:TBins;
      
      protected var FLeagueMapPvps:TBins;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FHint:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FMC_TeamBattleRoom:MovieClip;
      
      protected var FSP_Main:Sprite;
      
      protected var FMC_MainBackground:MovieClip;
      
      protected var FSP_Secondary:Sprite;
      
      protected var FMC_SecondaryBackground:MovieClip;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FMC_EffectLeftTop:MovieClip;
      
      protected var FMC_EffectRightTop:MovieClip;
      
      protected var FBtn_Setup:TUIButton;
      
      protected var FBtn_Cancel:TUIButton;
      
      protected var FTF_Password:TextField;
      
      protected var FSP_Modifed:Sprite;
      
      protected var FTF_RoomID:TextField;
      
      protected var FSP_FriendBuff:Sprite;
      
      protected var FSP_OrganizationBuff:Sprite;
      
      protected var FApplianceFriend:TAppliance;
      
      protected var FApplianceOrganization:TAppliance;
      
      protected var FFriendBuffStatus:Boolean;
      
      protected var FOrganizationBuffStatus:Boolean;
      
      protected var FSP_PVE_Select:Sprite;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_RewardPVECount:TextField;
      
      protected var FTF_RecommendLevel:TextField;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FBtn_AgainChoose:TUIButton;
      
      protected var FSP_PVP_Select:Sprite;
      
      protected var FTF_PVP_Readme:TextField;
      
      protected var FUISlot:TUISlot;
      
      protected var FTF_RewardPVPCount:TextField;
      
      protected var FSP_TeamLeader:Sprite;
      
      protected var FTF_CD:TextField;
      
      protected var FBtn_Announcement:TUIButton;
      
      protected var FBtn_Invite:TUIButton;
      
      protected var FBtn_StartGame:TUIButton;
      
      protected var FSP_StartTick:Sprite;
      
      protected var FTF_StartTick:TextField;
      
      protected var FSP_RegionTeammate:Sprite;
      
      protected var FBtn_MySelected:TUIButton;
      
      protected var FBtn_MyUnselect:TUIButton;
      
      protected var FBtn_AllSelected:TUIButton;
      
      protected var FBtn_AllUnselect:TUIButton;
      
      protected var FBtn_PVPReady:TUIButton;
      
      protected var FBtn_PVPCancel:TUIButton;
      
      protected var FBtn_PVEReady:TUIButton;
      
      protected var FBtn_PVECancel:TUIButton;
      
      protected var FTF_Title:TextField;
      
      protected var FBtn_ReturnHall:TUIButton;
      
      protected var FSP_ImagePoint:Sprite;
      
      protected var FBmpIcon:Bitmap;
      
      protected var FUIPlayers:Vector.<TUIPlayer>;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FStrApplyNickname:String;
      
      protected var FTickTransferLeader:int;
      
      protected var FTickReadyStartGame:int;
      
      protected var FTickAnnouncementCD:int;
      
      protected var FIsTerminationTransferLeader:Boolean;
      
      protected var FIsTerminationReadyStartGame:Boolean;
      
      protected var FTimeIntervalRefreshTransferLeader:int;
      
      protected var FTimeIntervalRefreshReadyStartGame:int;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnPlayerTipOver:Function;
      
      protected var FOnPlayerTipOut:Function;
      
      protected var FOnOpenInvite:Function;
      
      protected var FOnEnterCreateRoom:Function;
      
      protected var FOnAddFriend:Function;
      
      public function TProcessorWindowRoom(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FRoomSeatInfo = this.FTeamBattle.RoomSeatInfo;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleRoom);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUISlot = null;
         var _loc4_:TUIPlayer = null;
         this.FHint = new THint();
         this.FRolesModelID = new Vector.<int>();
         this.FMC_TeamBattleRoom = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_MC_TeamBattleRoom) as MovieClip;
         addChild(this.FMC_TeamBattleRoom);
         this.FSP_Main = this.FMC_TeamBattleRoom[CONST_TEAMBATTLE.RESOURCE_Link_SP_Main];
         this.FMC_EffectLeft = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectLeft];
         this.FMC_EffectRight = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectRight];
         this.FMC_EffectLeft.stop();
         this.FMC_EffectRight.stop();
         this.FMC_MainBackground = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_MC_Background];
         this.FMC_MainBackground.stop();
         _loc2_ = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_SP_Password];
         this.FBtn_Setup = new TUIButton();
         this.FBtn_Setup.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Setup];
         this.FBtn_Setup.OnClick = this.Btn_SetupOnClick;
         this.FBtn_Cancel = new TUIButton();
         this.FBtn_Cancel.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Cancel];
         this.FBtn_Cancel.OnClick = this.Btn_CancelOnClick;
         this.FSP_Modifed = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_Modifed];
         this.FTF_Password = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Password];
         this.FTF_Password.addEventListener(Event.CHANGE,this.TF_PasswordOnChange);
         this.FTF_Password.maxChars = 6;
         this.FTF_Password.restrict = "[0-9]";
         this.FTF_Password.text = "";
         this.FTF_RoomID = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_TF_RoomID];
         this.FTF_RoomID.text = "";
         this.FSP_FriendBuff = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_SP_FriendBuff];
         this.FSP_OrganizationBuff = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_SP_OrganizationBuff];
         this.FUIPlayers = new Vector.<TUIPlayer>(CAPACITY_PLAYERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc4_ = new TUIPlayer(null);
            _loc4_.Resource = this.FSP_Main[CONST_TEAMBATTLE.RESOURCE_Link_SP_Player + _loc1_];
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc4_.OnApply = this.UIPlayerOnApply;
            _loc4_.OnTransfer = this.UIPlayerOnTransfer;
            _loc4_.OnAddFriend = this.UIPlayerOnAddFriend;
            _loc4_.OnKick = this.UIPlayerOnKick;
            _loc4_.OnMove = this.UIPlayerOnMove;
            _loc4_.OnOut = this.UIPlayerOnOut;
            _loc4_.Perform_UIDispatch();
            this.FUIPlayers[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FSP_Secondary = this.FMC_TeamBattleRoom[CONST_TEAMBATTLE.RESOURCE_Link_SP_Secondary];
         this.FMC_SecondaryBackground = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_MC_Background];
         this.FMC_SecondaryBackground.stop();
         this.FSP_PVE_Select = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVE_Select];
         this.FTF_Level = this.FSP_PVE_Select[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_RewardPVECount = this.FSP_PVE_Select[CONST_TEAMBATTLE.RESOURCE_Link_TF_RewardPVECount];
         this.FTF_RecommendLevel = this.FSP_PVE_Select[CONST_TEAMBATTLE.RESOURCE_Link_TF_RecommendLevel];
         this.FTF_Level.text = "";
         this.FTF_RewardPVECount.text = "";
         this.FTF_RecommendLevel.text = "";
         this.FUISlots = new Vector.<TUISlot>(CAPACITY_Reward_Slots);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FSP_PVE_Select[CONST_TEAMBATTLE.RESOURCE_Link_MC_Slot + _loc1_];
            _loc3_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.Init();
            this.FUISlots[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FBtn_AgainChoose = new TUIButton();
         this.FBtn_AgainChoose.Substrate = this.FSP_PVE_Select[CONST_TEAMBATTLE.RESOURCE_Link_Btn_AgainChoose];
         this.FBtn_AgainChoose.OnClick = this.Btn_AgainChooseOnClick;
         this.FSP_PVP_Select = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVP_Select];
         this.FTF_PVP_Readme = this.FSP_PVP_Select[CONST_TEAMBATTLE.RESOURCE_Link_TF_PVP_Readme];
         this.FUISlot = new TUISlot(this);
         this.FUISlot.Resource = this.FSP_PVP_Select[CONST_TEAMBATTLE.RESOURCE_Link_SP_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUISlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUISlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlot.Init();
         this.FTF_RewardPVPCount = this.FSP_PVP_Select[CONST_TEAMBATTLE.RESOURCE_Link_TF_RewardPVPCount];
         this.FTF_RewardPVPCount.text = "";
         this.FTF_Title = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_TF_Title];
         this.FTF_Title.text = "";
         this.FBtn_ReturnHall = new TUIButton();
         this.FBtn_ReturnHall.Substrate = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_Btn_ReturnHall];
         this.FBtn_ReturnHall.OnClick = this.Btn_ReturnHallOnClick;
         this.FSP_ImagePoint = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_ImagePoint];
         this.FBmpIcon = new Bitmap();
         this.FSP_ImagePoint.addChild(this.FBmpIcon);
         this.FSP_TeamLeader = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_TeamLeader];
         this.FTF_CD = this.FSP_TeamLeader[CONST_TEAMBATTLE.RESOURCE_Link_TF_CD];
         this.FTF_CD.text = "";
         this.FBtn_Announcement = new TUIButton();
         this.FBtn_Announcement.Substrate = this.FSP_TeamLeader[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Announcement];
         this.FBtn_Announcement.OnClick = this.Btn_AnnouncementOnClick;
         this.FBtn_Invite = new TUIButton();
         this.FBtn_Invite.Substrate = this.FSP_TeamLeader[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Invite];
         this.FBtn_Invite.OnClick = this.Btn_InviteOnClick;
         _loc2_ = this.FSP_TeamLeader[CONST_TEAMBATTLE.RESOURCE_Link_SP_StartGame];
         this.FBtn_StartGame = new TUIButton();
         this.FBtn_StartGame.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_StartGame];
         this.FBtn_StartGame.OnClick = this.Btn_StartGameOnClick;
         this.FSP_StartTick = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_StartTick];
         this.FTF_StartTick = this.FSP_StartTick[CONST_TEAMBATTLE.RESOURCE_Link_TF_StartTick];
         this.FSP_RegionTeammate = this.FSP_Secondary[CONST_TEAMBATTLE.RESOURCE_Link_SP_RegionTeammate];
         _loc2_ = this.FSP_RegionTeammate[CONST_TEAMBATTLE.RESOURCE_Link_SP_MyAutoReady];
         this.FBtn_MySelected = new TUIButton();
         this.FBtn_MySelected.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Selected];
         this.FBtn_MySelected.OnClick = this.Btn_MySelectedOnClick;
         this.FBtn_MySelected.OnMove = this.BtnOnOver;
         this.FBtn_MySelected.OnOut = this.BtnOnOut;
         this.FBtn_MyUnselect = new TUIButton();
         this.FBtn_MyUnselect.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Unselect];
         this.FBtn_MyUnselect.OnClick = this.Btn_MyUnselectOnClick;
         this.FBtn_MyUnselect.OnMove = this.BtnOnOver;
         this.FBtn_MyUnselect.OnOut = this.BtnOnOut;
         _loc2_ = this.FSP_RegionTeammate[CONST_TEAMBATTLE.RESOURCE_Link_SP_AllAutoReady];
         this.FBtn_AllSelected = new TUIButton();
         this.FBtn_AllSelected.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Selected];
         this.FBtn_AllSelected.OnClick = this.Btn_AllSelectedOnClick;
         this.FBtn_AllSelected.OnMove = this.BtnOnOver;
         this.FBtn_AllSelected.OnOut = this.BtnOnOut;
         this.FBtn_AllUnselect = new TUIButton();
         this.FBtn_AllUnselect.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Unselect];
         this.FBtn_AllUnselect.OnClick = this.Btn_AllUnselectOnClick;
         this.FBtn_AllUnselect.OnMove = this.BtnOnOver;
         this.FBtn_AllUnselect.OnOut = this.BtnOnOut;
         _loc2_ = this.FSP_RegionTeammate[CONST_TEAMBATTLE.RESOURCE_Link_SP_Ready];
         this.FBtn_PVPReady = new TUIButton();
         this.FBtn_PVPReady.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_PVPReady];
         this.FBtn_PVPReady.OnClick = this.Btn_PVPReadyOnClick;
         this.FBtn_PVPCancel = new TUIButton();
         this.FBtn_PVPCancel.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_PVPCancel];
         this.FBtn_PVPCancel.OnClick = this.Btn_PVPCancelOnClick;
         this.FBtn_PVEReady = new TUIButton();
         this.FBtn_PVEReady.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_PVEReady];
         this.FBtn_PVEReady.OnClick = this.Btn_PVEReadyOnClick;
         this.FBtn_PVECancel = new TUIButton();
         this.FBtn_PVECancel.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_PVECancel];
         this.FBtn_PVECancel.OnClick = this.Btn_PVECancelOnClick;
         this.FBtn_PVEReady.Visible = true;
         this.FBtn_PVECancel.Visible = false;
         this.FBtn_PVPReady.Visible = true;
         this.FBtn_PVPCancel.Visible = false;
         this.FLeagueMapPves = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve);
         this.FLeagueMapPvps = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventoryReference = new TInventoryReference();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FTimeIntervalRefreshTransferLeader = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Pveleader) as TConfigValue).Value) * 1000;
         this.FTimeIntervalRefreshReadyStartGame = uint((SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.League_Pveready) as TConfigValue).Value) * 1000;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FSP_FriendBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.SPOnOver,false,0,true);
         this.FSP_FriendBuff.addEventListener(MouseEvent.MOUSE_OUT,this.SPOnOut,false,0,true);
         this.FSP_OrganizationBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.SPOnOver,false,0,true);
         this.FSP_OrganizationBuff.addEventListener(MouseEvent.MOUSE_OUT,this.SPOnOut,false,0,true);
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitTransferLeader,this.AffairPerform_TimingWaitTransferLeader);
         FAffairRoutines.Register(AFFAIRID_TimingWaitReadyStartGame,this.AffairPerform_TimingWaitReadyStartGameTick);
         FAffairRoutines.Register(AFFAIRID_TimingWaitAnnouncementCD,this.AffairPerform_TimingWaitAnnouncementCD);
      }
      
      protected function AffairPerform_TimingWaitTransferLeader(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitTransferLeader();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitTransferLeader() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(this.FIsTerminationTransferLeader)
         {
            return false;
         }
         if(_loc1_ - this.FTickTransferLeader >= this.FTimeIntervalRefreshTransferLeader)
         {
            this.UIWindowConfirmationOnOK(this);
            this.FUIWindowConfirmation.Visible = false;
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (this.FTimeIntervalRefreshTransferLeader - (_loc1_ - this.FTickTransferLeader)) / 1000;
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_16),this.FStrApplyNickname,TUtilityTiming.FormatDHMBySeconds(_loc2_));
         }
         return true;
      }
      
      protected function AffairPerform_TimingWaitReadyStartGameTick(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitReadyStartGameTick();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitReadyStartGameTick() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(this.FIsTerminationReadyStartGame)
         {
            return false;
         }
         if(_loc1_ - this.FTickReadyStartGame >= this.FTimeIntervalRefreshReadyStartGame)
         {
            this.ProcessorResetStartTick();
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (this.FTimeIntervalRefreshReadyStartGame - (_loc1_ - this.FTickReadyStartGame)) / 1000;
            this.FTF_StartTick.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_37),_loc2_);
         }
         return true;
      }
      
      protected function AffairPerform_TimingWaitAnnouncementCD(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitAnnouncementCDTick();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitAnnouncementCDTick() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickAnnouncementCD >= TIME_INTERVAL_ANNOUNCEMENT_CD_PERIOD)
         {
            this.FTF_CD.text = "";
            this.FBtn_Announcement.Enabled = true;
            return false;
         }
         if(_loc1_ % 150 > 100)
         {
            _loc2_ = (TIME_INTERVAL_ANNOUNCEMENT_CD_PERIOD - (_loc1_ - this.FTickAnnouncementCD)) / 1000;
            this.FTF_CD.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_12),_loc2_);
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
               if(this.FMC_TeamBattleRoom.isPlaying)
               {
                  this.LogicsPerform_EffectStart();
               }
               if(this.FMC_EffectLeft.isPlaying)
               {
                  this.LogicsPerform_EffectLeft();
               }
               if(this.FMC_EffectRight.isPlaying)
               {
                  this.LogicsPerform_EffectRight();
               }
               if(this.FMC_EffectLeftTop == null)
               {
                  this.FMC_EffectLeftTop = this.FMC_EffectLeft[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectLeftTop != null)
                  {
                     this.FMC_EffectLeftTop.play();
                  }
               }
               if(this.FMC_EffectRightTop == null)
               {
                  this.FMC_EffectRightTop = this.FMC_EffectRight[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectRightTop != null)
                  {
                     this.FMC_EffectRightTop.play();
                  }
               }
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_Reward_Slots)
               {
                  this.FUISlots[_loc1_].Update();
                  _loc1_++;
               }
               this.FUISlot.Update();
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_PLAYERS)
               {
                  this.FUIPlayers[_loc1_].Update();
                  _loc1_++;
               }
            }
         }
      }
      
      protected function LogicsPerform_EffectStart() : void
      {
         if(this.FMC_TeamBattleRoom.currentFrame == this.FMC_TeamBattleRoom.totalFrames - 5)
         {
            this.FMC_EffectLeft.play();
            this.FMC_EffectRight.play();
         }
         if(this.FMC_TeamBattleRoom.currentFrame == this.FMC_TeamBattleRoom.totalFrames)
         {
            this.FMC_TeamBattleRoom.stop();
         }
      }
      
      protected function LogicsPerform_EffectLeft() : void
      {
         if(this.FMC_EffectLeft.currentFrame == this.FMC_EffectLeft.totalFrames)
         {
            this.FMC_EffectLeft.stop();
         }
      }
      
      protected function LogicsPerform_EffectRight() : void
      {
         if(this.FMC_EffectRight.currentFrame == this.FMC_EffectRight.totalFrames)
         {
            this.FMC_EffectRight.stop();
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.X = (_loc1_ - this.Width) / 2 + 50;
         this.Y = (_loc2_ - this.Height) / 2;
      }
      
      protected function ProcessorUpdatePVE() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TLeagueMapPve = null;
         var _loc6_:Vector.<uint> = null;
         this.FSP_FriendBuff.visible = true;
         this.FSP_OrganizationBuff.visible = true;
         this.FSP_PVE_Select.visible = true;
         this.FSP_PVP_Select.visible = false;
         _loc5_ = this.FLeagueMapPves.GetDatebaseByIdentifier(this.FRoomSeatInfo.ModelID) as TLeagueMapPve;
         _loc4_ = uint(_loc5_.Identifier);
         if(_loc4_ % 2 == 0)
         {
            this.FMC_MainBackground.gotoAndStop(FRAME_PVE_Hard);
            this.FMC_SecondaryBackground.gotoAndStop(FRAME_PVE_Hard);
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_03);
            _loc3_ = CONST_TEAMBATTLE.COLOR_PVE_HARD;
         }
         else
         {
            this.FMC_MainBackground.gotoAndStop(FRAME_PVE_Normal);
            this.FMC_SecondaryBackground.gotoAndStop(FRAME_PVE_Normal);
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_02);
            _loc3_ = CONST_TEAMBATTLE.COLOR_PVE_NORMAL;
         }
         this.FTF_Title.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_11),_loc5_.Name,_loc2_);
         this.FTF_Title.textColor = _loc3_;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_10),_loc5_.SuitableLevel);
         this.FTF_RewardPVECount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_13),this.FTeamBattle.PVERewardCount);
         this.FTF_RecommendLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),_loc5_.RecommendLevel);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         _loc6_ = _loc5_.Awards;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc6_);
         _loc1_ = 0;
         while(_loc1_ < this.FInventories.Count)
         {
            this.FUISlots[_loc1_].Context = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(_loc5_.ImageID,this.AutoLoadCallBack);
      }
      
      protected function ProcessorUpdatePVP() : void
      {
         var _loc1_:TLeagueMapPvp = null;
         var _loc2_:Vector.<uint> = null;
         this.FSP_FriendBuff.visible = false;
         this.FSP_OrganizationBuff.visible = false;
         this.FSP_PVP_Select.visible = true;
         this.FSP_PVE_Select.visible = false;
         this.FMC_MainBackground.gotoAndStop(FRAME_PVP);
         this.FMC_SecondaryBackground.gotoAndStop(FRAME_PVP);
         _loc1_ = this.FLeagueMapPvps.GetDatebaseByIdentifier(this.FRoomSeatInfo.ModelID) as TLeagueMapPvp;
         this.FTF_Title.text = _loc1_.Name;
         this.FTF_Title.textColor = CONST_TEAMBATTLE.COLOR_PVP;
         this.FTF_PVP_Readme.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_39);
         this.FTF_RewardPVPCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_13),this.FTeamBattle.PVPRewardCount);
         this.FUISlot.Context = null;
         _loc2_ = _loc1_.Awards;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc2_);
         this.FUISlot.Context = this.FInventories.GetInventoryByIndex(0);
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(_loc1_.ImageID,this.AutoLoadCallBack);
      }
      
      protected function ProcessorBuffReward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TLeagueMapPve = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:TPlayerRoomDigest = null;
         var _loc8_:Vector.<TPlayerRoomDigest> = null;
         _loc4_ = int(this.FRoomSeatInfo.OneselfIndex);
         _loc8_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc7_ = _loc8_[_loc1_];
            if(_loc7_.Identifier0 != 0 || _loc7_.Identifier1 != 0)
            {
               if(_loc4_ == _loc7_.SeatIndex)
               {
                  _loc5_ = _loc7_.FriendBuffStatus;
                  _loc6_ = _loc7_.OrganizationBuffStatus;
                  break;
               }
            }
            _loc1_++;
         }
         if(this.FApplianceFriend != null)
         {
            this.FApplianceFriend.StubReferences.Dereference(this);
            this.FApplianceFriend = null;
         }
         if(this.FApplianceOrganization != null)
         {
            this.FApplianceOrganization.StubReferences.Dereference(this);
            this.FApplianceOrganization = null;
         }
         this.FSP_FriendBuff.filters = [TUtilityFilter.gBlackFilters];
         this.FSP_OrganizationBuff.filters = [TUtilityFilter.gBlackFilters];
         _loc3_ = this.FLeagueMapPves.GetDatebaseByIdentifier(this.FRoomSeatInfo.ModelID) as TLeagueMapPve;
         if(_loc5_)
         {
            this.FSP_FriendBuff.filters = [];
         }
         if(_loc6_)
         {
            this.FSP_OrganizationBuff.filters = [];
         }
         _loc2_ = _loc3_.FriendBuff.Code;
         if(_loc2_ != 0)
         {
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,_loc2_);
            this.FApplianceFriend = this.FInventoryReference.Inventory as TAppliance;
            this.FApplianceFriend.Quantity = _loc3_.FriendBuff.Amount;
            this.FApplianceFriend.StubReferences.Reference(this);
            this.FInventoryReference.Inventory = null;
         }
         _loc2_ = _loc3_.OrganizationBuff.Code;
         if(_loc2_ != 0)
         {
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,_loc2_);
            this.FApplianceOrganization = this.FInventoryReference.Inventory as TAppliance;
            this.FApplianceOrganization.Quantity = _loc3_.OrganizationBuff.Amount;
            this.FApplianceOrganization.StubReferences.Reference(this);
            this.FInventoryReference.Inventory = null;
         }
         this.FFriendBuffStatus = _loc5_;
         this.FOrganizationBuffStatus = _loc6_;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(1);
         this.FBmpIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function ProcessorResetStartTick() : void
      {
         this.FSP_Main.mouseEnabled = true;
         this.FSP_Main.mouseChildren = true;
         this.FSP_PVE_Select.mouseEnabled = true;
         this.FSP_PVE_Select.mouseChildren = true;
         this.FIsTerminationReadyStartGame = true;
         this.FTF_StartTick.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_36);
      }
      
      protected function ProcessorStartGameTick() : void
      {
         this.FSP_Main.mouseEnabled = false;
         this.FSP_Main.mouseChildren = false;
         this.FSP_PVE_Select.mouseEnabled = false;
         this.FSP_PVE_Select.mouseChildren = false;
         this.FIsTerminationReadyStartGame = false;
         this.FTickReadyStartGame = STimingCore.TickCount;
         FAffairGenerator.Generate(AFFAIRID_TimingWaitReadyStartGame);
      }
      
      protected function ProcessorUpdateCommon() : void
      {
         if(this.FTeamBattle.AutoReady)
         {
            this.FBtn_MySelected.Visible = true;
            this.FBtn_MyUnselect.Visible = false;
         }
         else
         {
            this.FBtn_MySelected.Visible = false;
            this.FBtn_MyUnselect.Visible = true;
         }
         this.FTF_RoomID.text = this.FRoomSeatInfo.Identifier.toString();
      }
      
      protected function ProcessorUpdatePasswordUI() : void
      {
         this.FSP_Modifed.visible = true;
         this.FBtn_Setup.Enabled = true;
         this.FBtn_Setup.Visible = true;
         this.FBtn_Cancel.Visible = true;
         if(this.FRoomSeatInfo.RoomOwnerIndex == this.FRoomSeatInfo.OneselfIndex)
         {
            this.FTF_Password.type = TextFieldType.INPUT;
            this.FSP_Modifed.visible = this.FTeamBattle.PasswordModifed;
            this.FBtn_Setup.Enabled = !this.FTeamBattle.PasswordModifed;
            this.FBtn_Cancel.Visible = this.FTeamBattle.PasswordModifed;
            if(!TUtilityString.Empty(this.FRoomSeatInfo.Password))
            {
               this.FTF_Password.text = this.FRoomSeatInfo.Password;
               this.FBtn_Setup.Visible = !this.FTeamBattle.PasswordModifed;
            }
            else
            {
               this.FTF_Password.text = "";
            }
         }
         else
         {
            this.FTF_Password.type = TextFieldType.DYNAMIC;
            this.FSP_Modifed.visible = false;
            this.FBtn_Setup.Enabled = false;
            this.FBtn_Cancel.Visible = false;
            if(!TUtilityString.Empty(this.FRoomSeatInfo.Password))
            {
               this.FTF_Password.text = this.FRoomSeatInfo.Password;
            }
            else
            {
               this.FTF_Password.text = "";
            }
         }
      }
      
      protected function ProcessorUpdateRoomSeats() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPlayerRoomDigest = null;
         var _loc5_:Vector.<TPlayerRoomDigest> = null;
         _loc2_ = this.FRoomSeatInfo.RoomOwnerIndex;
         _loc3_ = this.FRoomSeatInfo.OneselfIndex;
         if(_loc2_ == _loc3_)
         {
            this.ProcessorUpdateTeamLeader();
         }
         else
         {
            this.ProcessorUpdateRegionTeammate();
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FUIPlayers[_loc1_].Context = null;
            _loc1_++;
         }
         _loc5_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc4_ = _loc5_[_loc1_];
            _loc4_.OneselfSeatIndex = _loc3_;
            _loc4_.RoomOwnerIndex = _loc2_;
            if(_loc4_.Identifier0 != 0 || _loc4_.Identifier1 != 0)
            {
               this.FUIPlayers[_loc4_.SeatIndex].Context = _loc4_;
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorCheckReadyStart() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRoomSeatInfo.ReadyCount);
         if(_loc2_ >= 3)
         {
            this.ProcessorStartGameTick();
         }
         else
         {
            this.ProcessorResetStartTick();
         }
      }
      
      protected function ProcessorUpdateTeamLeader() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRoomSeatInfo.ReadyCount);
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(_loc2_ >= PVE_PlayerCountLimit)
            {
               this.FBtn_StartGame.Enabled = true;
            }
            else
            {
               this.FBtn_StartGame.Enabled = false;
            }
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            if(_loc2_ >= PVP_PlayerCountLimit)
            {
               this.FBtn_StartGame.Enabled = true;
            }
            else
            {
               this.FBtn_StartGame.Enabled = false;
            }
         }
         if(this.FBtn_StartGame.Enabled)
         {
            this.FBtn_StartGame.OnMove = null;
            this.FBtn_StartGame.OnOut = null;
         }
         else
         {
            this.FBtn_StartGame.OnMove = this.Btn_StartGameOnMove;
            this.FBtn_StartGame.OnOut = this.Btn_StartGameOnOut;
         }
         if(this.FRoomSeatInfo.PlayerCount == 1)
         {
            this.FBtn_ReturnHall.Visible = true;
         }
         this.FBtn_PVPReady.Visible = false;
         this.FBtn_PVPCancel.Visible = false;
         this.FBtn_PVEReady.Visible = false;
         this.FBtn_PVECancel.Visible = false;
         this.FBtn_AgainChoose.Visible = true;
         this.FBtn_ReturnHall.Visible = true;
         this.FSP_TeamLeader.visible = true;
         this.FSP_RegionTeammate.visible = false;
      }
      
      protected function ProcessorUpdateRegionTeammate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPlayerRoomDigest = null;
         var _loc4_:TPlayerRoomDigest = null;
         var _loc5_:Vector.<TPlayerRoomDigest> = null;
         _loc2_ = 0;
         _loc5_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc3_ = _loc5_[_loc1_];
            if(_loc3_.Identifier0 != 0 || _loc3_.Identifier1 != 0)
            {
               if(_loc3_.SeatIndex == this.FRoomSeatInfo.OneselfIndex)
               {
                  _loc4_ = _loc3_;
               }
               if(_loc5_[_loc1_].Ready)
               {
                  _loc2_++;
               }
            }
            _loc1_++;
         }
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.FBtn_PVEReady.Visible = !_loc4_.Ready;
            this.FBtn_PVECancel.Visible = _loc4_.Ready;
            if((this.FTeamBattle.AutoReady || this.FTeamBattle.AllAutoReady) && !_loc4_.Ready)
            {
               if(this.FBtn_PVEReady.Visible)
               {
                  this.Btn_PVEReadyOnClick(this,null);
               }
            }
            this.FBtn_PVPReady.Visible = false;
            this.FBtn_PVPCancel.Visible = false;
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            this.FBtn_PVPReady.Visible = !_loc4_.Ready;
            this.FBtn_PVPCancel.Visible = _loc4_.Ready;
            if((this.FTeamBattle.AutoReady || this.FTeamBattle.AllAutoReady) && !_loc4_.Ready)
            {
               if(this.FBtn_PVPReady.Visible)
               {
                  this.Btn_PVPReadyOnClick(this,null);
               }
            }
            this.FBtn_PVEReady.Visible = false;
            this.FBtn_PVECancel.Visible = false;
         }
         this.FBtn_AgainChoose.Visible = false;
         this.FSP_TeamLeader.visible = false;
         this.FSP_RegionTeammate.visible = true;
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPlayerRoomDigest = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as TPlayerRoomDigest;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.RoleTempleteID) as TRoleModel;
         _loc9_ = CONST_ROLE.GetModelIDByIndex(_loc8_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
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
      
      protected function ProcessorRoomInOperatingReq(param1:uint, param2:TPlayerRoomDigest = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<TPlayerRoomDigest> = null;
         var _loc11_:TPlayerRoomDigest = null;
         _loc10_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc4_ = int(_loc10_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc11_ = _loc10_[_loc3_];
            if(this.FCharacter.Identifier0 == _loc11_.Identifier0 && this.FCharacter.Identifier1 == _loc11_.Identifier1)
            {
               _loc8_ = _loc11_.SeatIndex;
               break;
            }
            _loc3_++;
         }
         switch(param1)
         {
            case TYPE_OPERATING_APPLY:
            case TYPE_OPERATING_KICK:
            case TYPE_OPERATING_TRANSFER:
            case TYPE_OPERATING_REFUSALAPPLY:
               _loc9_ = param2.SeatIndex;
               break;
            default:
               _loc9_ = 0;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_RoomInOperating);
         _loc6_ = _loc5_.Data;
         _loc6_.writeByte(param1);
         _loc6_.writeByte(_loc8_);
         _loc6_.writeByte(_loc9_);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function ProcessorStartGame() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_StartGame);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.ProcessorResetStartTick();
      }
      
      protected function Btn_SetupOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(!TUtilityString.Empty(this.FTF_Password.text))
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_ChangePassword);
            _loc4_ = _loc3_.Data;
            TUtilityString.FlushUTF(_loc4_,this.FTF_Password.text);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
            this.FTeamBattle.PasswordModifed = true;
         }
         else
         {
            this.Btn_CancelOnClick(this,null);
         }
      }
      
      protected function Btn_CancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_ChangePassword);
         _loc4_ = _loc3_.Data;
         TUtilityString.FlushUTF(_loc4_,"");
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FTeamBattle.PasswordModifed = false;
      }
      
      protected function TF_PasswordOnChange(param1:Event) : void
      {
         if(this.FSP_Modifed.visible)
         {
            this.FSP_Modifed.visible = false;
            this.FBtn_Setup.Enabled = true;
            this.FBtn_Setup.Visible = true;
            this.FBtn_Cancel.Visible = false;
         }
      }
      
      protected function UIPlayerOnApply(param1:Object, param2:TPlayerRoomDigest) : void
      {
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_APPLY,param2);
      }
      
      protected function UIPlayerOnTransfer(param1:Object, param2:TPlayerRoomDigest) : void
      {
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_25),param2.Nickname);
         this.FUIWindowConfirmation.Context = param2;
         this.FUIWindowConfirmation.Tag = TYPE_OPERATING_TRANSFER;
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function UIPlayerOnAddFriend(param1:Object, param2:TPlayerRoomDigest) : void
      {
         var _loc3_:TFriendDigest = null;
         _loc3_ = SLogicsCore.PoolCharacter.AcquireFriendDigest(param2.Identifier0,param2.Identifier1);
         if(this.FOnAddFriend != null)
         {
            this.FOnAddFriend(this,CONST_FRIEND.TYPE_Whitelist_Add,_loc3_);
         }
      }
      
      protected function UIPlayerOnKick(param1:Object, param2:TPlayerRoomDigest) : void
      {
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_26),param2.Nickname);
         this.FUIWindowConfirmation.Context = param2;
         this.FUIWindowConfirmation.Tag = TYPE_OPERATING_KICK;
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function UIPlayerOnMove(param1:Object, param2:TPlayerRoomDigest) : void
      {
         if(this.FOnPlayerTipOver != null)
         {
            this.FOnPlayerTipOver(this,param2);
         }
      }
      
      protected function UIPlayerOnOut(param1:Object, param2:TPlayerRoomDigest) : void
      {
         if(this.FOnPlayerTipOut != null)
         {
            this.FOnPlayerTipOut(this,param2);
         }
      }
      
      protected function Btn_AgainChooseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEnterCreateRoom != null)
         {
            this.FOnEnterCreateRoom(this);
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function Btn_ReturnHallOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_33);
         this.FUIWindowConfirmation.Tag = TYPE_OPERATING_LEAVE;
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function Btn_AnnouncementOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:TPacket = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Invite_AnnouncementReq);
         _loc3_ = _loc4_.Data;
         _loc3_.writeByte(this.FTeamBattle.ModeType);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         this.FBtn_Announcement.Enabled = false;
         this.FTickAnnouncementCD = STimingCore.TickCount;
         FAffairGenerator.Generate(AFFAIRID_TimingWaitAnnouncementCD);
      }
      
      protected function Btn_InviteOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenInvite != null)
         {
            this.FOnOpenInvite(this);
         }
      }
      
      protected function Btn_StartGameOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(this.FRoomSeatInfo.ReadyCount <= 2)
            {
               this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_38);
               this.FUIWindowConfirmation.Tag = TYPE_OPERATING_STARTGAME;
               this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
               this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
               this.FUIWindowConfirmation.Visible = true;
               return;
            }
            if(this.FRoomSeatInfo.ReadyCount >= PVE_PlayerCountLimit)
            {
               this.ProcessorStartGame();
            }
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            if(this.FRoomSeatInfo.ReadyCount >= PVP_PlayerCountLimit)
            {
               this.ProcessorStartGame();
            }
         }
      }
      
      protected function Btn_StartGameOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_31);
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_32);
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHint);
         }
      }
      
      protected function Btn_StartGameOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function Btn_MySelectedOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_MyUnselect.Visible = true;
         this.FBtn_MySelected.Visible = false;
         this.FTeamBattle.AutoReady = false;
      }
      
      protected function Btn_MyUnselectOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(this.FBtn_PVEReady.Visible)
            {
               this.Btn_PVEReadyOnClick(this,null);
            }
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            if(this.FBtn_PVPReady.Visible)
            {
               this.Btn_PVPReadyOnClick(this,null);
            }
         }
         this.FBtn_MyUnselect.Visible = false;
         this.FBtn_MySelected.Visible = true;
         this.FTeamBattle.AutoReady = true;
      }
      
      protected function Btn_AllSelectedOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_AllUnselect.Visible = true;
         this.FBtn_AllSelected.Visible = false;
         this.FTeamBattle.AllAutoReady = false;
      }
      
      protected function Btn_AllUnselectOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(this.FBtn_PVEReady.Visible)
            {
               this.Btn_PVEReadyOnClick(this,null);
            }
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            if(this.FBtn_PVPReady.Visible)
            {
               this.Btn_PVPReadyOnClick(this,null);
            }
         }
         this.FBtn_AllUnselect.Visible = false;
         this.FBtn_AllSelected.Visible = true;
         this.FTeamBattle.AllAutoReady = true;
      }
      
      protected function Btn_PVEReadyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_READY);
         this.FBtn_PVEReady.Visible = false;
         this.FBtn_PVECancel.Visible = true;
         this.FBtn_ReturnHall.Visible = false;
      }
      
      protected function Btn_PVECancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.AllAutoReady)
         {
            return;
         }
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CANCEL);
         this.ProcessorResetStartTick();
         this.FBtn_PVEReady.Visible = true;
         this.FBtn_PVECancel.Visible = false;
         this.FBtn_MySelected.Visible = false;
         this.FBtn_MyUnselect.Visible = true;
         this.FTeamBattle.AutoReady = false;
         this.FBtn_ReturnHall.Visible = true;
      }
      
      protected function Btn_PVPReadyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_READY);
         this.FBtn_PVPReady.Visible = false;
         this.FBtn_PVPCancel.Visible = true;
         this.FBtn_ReturnHall.Visible = false;
      }
      
      protected function Btn_PVPCancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTeamBattle.AllAutoReady)
         {
            return;
         }
         this.ProcessorRoomInOperatingReq(TYPE_OPERATING_CANCEL);
         this.ProcessorResetStartTick();
         this.FBtn_PVPReady.Visible = true;
         this.FBtn_PVPCancel.Visible = false;
         this.FBtn_MySelected.Visible = false;
         this.FBtn_MyUnselect.Visible = true;
         this.FTeamBattle.AutoReady = false;
         this.FBtn_ReturnHall.Visible = true;
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TPlayerRoomDigest = null;
         _loc2_ = uint(this.FUIWindowConfirmation.Tag);
         if(this.FUIWindowConfirmation.Context != null)
         {
            _loc3_ = this.FUIWindowConfirmation.Context as TPlayerRoomDigest;
         }
         if(_loc2_ == TYPE_OPERATING_APPLY)
         {
            _loc2_ = TYPE_OPERATING_TRANSFER;
            this.FIsTerminationTransferLeader = true;
         }
         if(_loc2_ == TYPE_OPERATING_STARTGAME)
         {
            this.ProcessorStartGame();
            return;
         }
         this.ProcessorRoomInOperatingReq(_loc2_,_loc3_);
      }
      
      protected function UIWindowConfirmationOnCancel(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TPlayerRoomDigest = null;
         _loc2_ = uint(this.FUIWindowConfirmation.Tag);
         if(this.FUIWindowConfirmation.Context != null)
         {
            _loc3_ = this.FUIWindowConfirmation.Context as TPlayerRoomDigest;
         }
         if(_loc2_ == TYPE_OPERATING_APPLY)
         {
            _loc2_ = TYPE_OPERATING_REFUSALAPPLY;
            this.ProcessorRoomInOperatingReq(_loc2_,_loc3_);
            this.FIsTerminationTransferLeader = true;
         }
         this.FUIWindowConfirmation.Text = "";
         this.FUIWindowConfirmation.Tag = 0;
         this.FUIWindowConfirmation.Context = null;
      }
      
      protected function SPOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:String = null;
         _loc2_ = param1.currentTarget as Sprite;
         switch(_loc2_)
         {
            case this.FSP_FriendBuff:
               if(this.FFriendBuffStatus)
               {
                  _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_29),this.FApplianceFriend.Name,this.FApplianceFriend.Quantity);
               }
               else
               {
                  _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_27),this.FApplianceFriend.Name);
               }
               break;
            case this.FSP_OrganizationBuff:
               if(this.FOrganizationBuffStatus)
               {
                  _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_30),this.FApplianceOrganization.Name,this.FApplianceOrganization.Quantity);
               }
               else
               {
                  _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_28),this.FApplianceOrganization.Name);
               }
               break;
            case this.FBtn_MySelected:
            case this.FBtn_MyUnselect:
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_34);
               break;
            case this.FBtn_AllSelected:
            case this.FBtn_AllUnselect:
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_35);
         }
         this.FHint.Caption = _loc3_;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHint);
         }
      }
      
      protected function SPOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function BtnOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:String = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtn_MySelected:
            case this.FBtn_MyUnselect:
               _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_34);
               break;
            case this.FBtn_AllSelected:
            case this.FBtn_AllUnselect:
               _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_35);
         }
         this.FHint.Caption = _loc4_;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHint);
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
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
      
      public function get OnOpenInvite() : Function
      {
         return this.FOnOpenInvite;
      }
      
      public function set OnOpenInvite(param1:Function) : void
      {
         this.FOnOpenInvite = param1;
      }
      
      public function get OnEnterCreateRoom() : Function
      {
         return this.FOnEnterCreateRoom;
      }
      
      public function set OnEnterCreateRoom(param1:Function) : void
      {
         this.FOnEnterCreateRoom = param1;
      }
      
      public function get OnAddFriend() : Function
      {
         return this.FOnAddFriend;
      }
      
      public function set OnAddFriend(param1:Function) : void
      {
         this.FOnAddFriend = param1;
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
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         if(this.FBmpIcon != null && this.FBmpIcon.bitmapData != null)
         {
            this.FBmpIcon.bitmapData = null;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FUIPlayers[_loc1_].Context = null;
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
         if(this.FApplianceFriend != null)
         {
            this.FApplianceFriend.StubReferences.Dereference(this);
            this.FApplianceFriend = null;
         }
         if(this.FApplianceOrganization != null)
         {
            this.FApplianceOrganization.StubReferences.Dereference(this);
            this.FApplianceOrganization = null;
         }
         this.FIsTerminationTransferLeader = false;
         this.FIsTerminationReadyStartGame = false;
         this.FFriendBuffStatus = false;
         this.FOrganizationBuffStatus = false;
         this.FInventories.Clear();
         this.FRolesModelID.length = 0;
         this.FBtn_StartGame.OnMove = null;
         this.FBtn_StartGame.OnOut = null;
         this.FBtn_StartGame.Enabled = true;
         this.FUISlot.Context = null;
         this.FStrApplyNickname = "";
         this.FBtn_MySelected.Visible = false;
         this.FBtn_MyUnselect.Visible = true;
         this.FSP_TeamLeader.visible = false;
         this.FSP_RegionTeammate.visible = false;
         this.FSP_PVE_Select.visible = false;
         this.FSP_PVP_Select.visible = false;
         this.FBtn_ReturnHall.Visible = true;
         this.FSP_Main.mouseEnabled = true;
         this.FSP_Main.mouseChildren = true;
         this.FSP_PVE_Select.mouseEnabled = true;
         this.FSP_PVE_Select.mouseChildren = true;
         this.FBtn_PVEReady.Visible = true;
         this.FBtn_PVECancel.Visible = false;
         this.FBtn_PVPReady.Visible = true;
         this.FBtn_PVPCancel.Visible = false;
      }
      
      public function Update() : void
      {
         this.ProcessorResetStartTick();
         this.UpdateRoomSeatInfo();
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.ProcessorUpdatePVE();
            this.ProcessorBuffReward();
         }
         else
         {
            this.ProcessorUpdatePVP();
         }
         this.FMC_TeamBattleRoom.play();
      }
      
      public function UpdateRoomSeatInfo() : void
      {
         this.ProcessorUpdateCommon();
         this.ProcessorUpdatePasswordUI();
         this.ProcessorUpdateRoomSeats();
         this.ProcessorCheckReadyStart();
      }
      
      public function UpdateCharInfoChange() : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.ProcessorBuffReward();
         }
         this.UpdateRoomSeatInfo();
      }
      
      public function UpdatePasswordUI() : void
      {
         this.ProcessorUpdatePasswordUI();
      }
      
      public function OpenApplyConfirmation(param1:TPlayerRoomDigest) : void
      {
         this.FStrApplyNickname = param1.Nickname;
         this.FUIWindowConfirmation.Context = param1;
         this.FUIWindowConfirmation.Tag = TYPE_OPERATING_APPLY;
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
         this.FUIWindowConfirmation.Visible = true;
         this.FIsTerminationTransferLeader = false;
         this.FTickTransferLeader = STimingCore.TickCount;
         FAffairGenerator.Generate(AFFAIRID_TimingWaitTransferLeader);
      }
      
      public function TeamBattleChatPopNtf(param1:uint, param2:uint, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPlayerRoomDigest = null;
         var _loc8_:Vector.<TPlayerRoomDigest> = null;
         var _loc9_:TUIPlayer = null;
         var _loc10_:THyperString = null;
         var _loc11_:THyperStringElement = null;
         var _loc12_:THyperStringElementText = null;
         var _loc13_:String = null;
         _loc13_ = "";
         _loc10_ = param3 as THyperString;
         _loc5_ = _loc10_.Count;
         _loc4_ = 2;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc10_.GetElementByIndex(_loc4_);
            if(_loc11_ is THyperStringElementText)
            {
               _loc12_ = _loc11_ as THyperStringElementText;
               _loc13_ += _loc12_.Text;
            }
            _loc4_++;
         }
         _loc8_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc8_[_loc4_];
            if(_loc7_.Identifier0 == param1 && _loc7_.Identifier1 == param2)
            {
               _loc6_ = int(_loc7_.SeatIndex);
               _loc9_ = this.FUIPlayers[_loc6_];
               _loc9_.SetChatPop(_loc13_);
               break;
            }
            _loc4_++;
         }
      }
      
      public function SyncBattleWait() : void
      {
         this.Btn_StartGameOnOut(this,null);
         this.FIsTerminationReadyStartGame = true;
      }
   }
}

