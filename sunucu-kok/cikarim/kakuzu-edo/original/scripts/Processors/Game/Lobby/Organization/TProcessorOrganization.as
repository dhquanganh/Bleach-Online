package Processors.Game.Lobby.Organization
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Inventories.*;
   import Logics.Organization.*;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.Organization.*;
   import Processors.Game.Lobby.BlackMarket.InterfaceTimeMarket;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.*;
   
   public class TProcessorOrganization extends TProcessorLobbyWindows implements InterfaceTimeMarket
   {
      
      public static const SIZE_WindowOrganizationMain_Width:uint = 826;
      
      public static const SIZE_WindowOrganizationMain_Height:uint = 540;
      
      public static const SIZE_WindowOrganizationCamp_Width:uint = 688;
      
      public static const SIZE_WindowOrganizationCamp_Height:uint = 408;
      
      public static const SIZE_WindowOrgCreate_Width:uint = 310;
      
      public static const SIZE_WindowOrgCreate_Height:uint = 190;
      
      public static const SIZE_WindowOrgApplyAndPower_Width:uint = 465;
      
      public static const SIZE_WindowOrgApplyAndPower_Height:uint = 430;
      
      public static const SIZE_WindowOrgDonate_Width:uint = 330;
      
      public static const SIZE_WindowOrgDonate_Height:uint = 274;
      
      public static const SIZE_WindowOrgPower_Width:uint = 405;
      
      public static const SIZE_WindowOrgPower_Height:uint = 377;
      
      public static const SIZE_WindowOrgShopExchang_Width:uint = 670;
      
      public static const SIZE_WindowOrgShopExchang_Height:uint = 366;
      
      protected static const TYPE_ORGACTIVITY_CAMP:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_CAMP;
      
      protected static const TYPE_ORGACTIVITY_MUYEGUARD:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEGUARD;
      
      protected static const TYPE_ORGACTIVITY_PETBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_PETBATTLE;
      
      protected static const TYPE_ORGACTIVITY_MUYEBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE;
      
      protected static const TYPE_ORGACTIVITY_TRAITORATTACK:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_TRAITORATTACK;
      
      protected static const TYPE_ORGACTIVITY_VoidSoulWorld:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_VoidSoulWorld;
      
      protected static const STATUS_ORGACTIVITY_NotOpen:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_NotOpen;
      
      protected static const STATUS_ORGACTIVITY_SignUp:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_SignUp;
      
      protected static const STATUS_ORGACTIVITY_Battle:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Battle;
      
      protected static const STATUS_ORGACTIVITY_End:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_End;
      
      protected static const STATUS_ORGACTIVITY_Added:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Added;
      
      protected var FMountInfo:ByteArray;
      
      protected var FBoundsOrganizationMain:TBounds;
      
      protected var FBoundsOrganizationActivity:TBounds;
      
      protected var FBoundsOrgCreate:TBounds;
      
      protected var FBoundsOrgApplyAndPower:TBounds;
      
      protected var FBoundsOrgDonate:TBounds;
      
      protected var FBoundsOrgPower:TBounds;
      
      protected var FBoundsOrgShopExchang:TBounds;
      
      protected var FProcessorWindowOrganizationMain:TProcessorWindowOrganizationMain;
      
      protected var FProcessorWindowOrganizationActivity:TProcessorWindowOrganizationActivity;
      
      protected var FProcessorWindowOrgShopExchange:TProcessorWindowOrgShopExchange;
      
      protected var FProcessorWindowOrgCreate:TProcessorWindowOrgCreate;
      
      protected var FProcessorWindowOrgApplyAndPower:TProcessorWindowOrgApplyAndPower;
      
      protected var FProcessorWindowOrgDonate:TProcessorWindowOrgDonate;
      
      protected var FProcessorWindowOrgPower:TProcessorWindowOrgPower;
      
      protected var FLayerMask:Sprite;
      
      protected var FUnstreamizerOrg:TUnstreamizerOrganization;
      
      protected var FNewOrgData:TNewOrgData;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FOrgListDataVect:Vector.<TBaseOrganiztionList>;
      
      protected var FOrgApplyListDataVect:Vector.<TBaseOrganizationMember>;
      
      protected var FOrgBaseData:TBaseOrganization;
      
      protected var FOrgMemberListDataVect:Vector.<TBaseOrganizationMember>;
      
      protected var FOrgCampDataVect:Vector.<Object>;
      
      protected var FOrgActivityStatus:Vector.<Object>;
      
      protected var FOrgLogVect:Vector.<Object>;
      
      protected var FOrgApplyListCount:uint;
      
      protected var FMuyeGuardRank:TMuyeGuardRank;
      
      protected var FOrgAdditionBin:TBins;
      
      protected var FOrgBaseBin:TBins;
      
      protected var FOrgDevotionBin:TBins;
      
      protected var FOrgInitWindows:Boolean;
      
      protected var FBAlreadyLoadOrgActivityStatus:Boolean;
      
      protected var FBOnSetOrganizationChannel:Boolean;
      
      protected var FBOnBtnOrgListClick:Boolean;
      
      protected var FWindowBtnStatus:Vector.<Object>;
      
      protected var FMuyeBattleOrgRankData:Vector.<TBaseOrganiztionList>;
      
      protected var FMuyeBattlePlayerRankData:Vector.<TBaseOrganizationMember>;
      
      protected var FOnOrgActivityMuyeBattleSignUp:Function;
      
      protected var FSetDailyActivityStatus:Function;
      
      protected var FOnSetOrganizationName:Function;
      
      protected var FUpdateHerosPower:Function;
      
      protected var FOnSetOrganizationChannel:Function;
      
      protected var FOnOrgActivityMuyeGuardStartBattle:Function;
      
      protected var FOnOrgActivityMuyeBattleStartBattle:Function;
      
      protected var FOnOrgGotoSinglePointMap:Function;
      
      protected var FOnOrgGotoGroupPointMap:Function;
      
      protected var FOnShowHeroInfo:Function;
      
      protected var FOnShowHeroAchievement:Function;
      
      protected var FOnChatWhisper:Function;
      
      protected var FOnInterpersonalRelationships:Function;
      
      protected var FSingleInitRetCall:Function;
      
      protected var FGroupInitRetCall:Function;
      
      public function TProcessorOrganization(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowOrganizationMain = new TProcessorWindowOrganizationMain(this);
         this.FProcessorWindowOrganizationMain.OnClose = this.OnOrgClose;
         this.FProcessorWindowOrganizationMain.ClickMainPartOrgActivityOk = this.OnOrgActivityOkClick;
         this.FProcessorWindowOrganizationMain.ClickCreateOrg = this.OnProcessorWindowOrgCreateShow;
         this.FProcessorWindowOrganizationMain.ClickBtnDonate = this.OnProcessorWindowOrgDonate;
         this.FProcessorWindowOrganizationMain.ClickBtnOrgList = this.OnProcessorWindowOrgList;
         this.FProcessorWindowOrganizationMain.ClickBtnGotoPower = this.OnProcessorWindowOrgGotoPower;
         this.FProcessorWindowOrganizationMain.ClickBtnApplyList = this.OnProcessorWindowOrgApplyList;
         this.FProcessorWindowOrganizationMain.ClickBtnSwitchPowerList = this.OnProcessorWindowOrgSwitchPower;
         this.FProcessorWindowOrganizationMain.ClickBtnGotoSinglePointMap = this.OnProcessorWindowOrgGotoSinglePointMap;
         this.FProcessorWindowOrganizationMain.ClickBtnGotoGroupPointMap = this.OnProcessorWindowOrgGotoGroupPointMap;
         this.FProcessorWindowOrganizationMain.ClickBtnQuitOrg = this.OnBtnQuitClick;
         this.FProcessorWindowOrganizationMain.OverAward = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOrganizationMain.OutAward = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOrganizationMain.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowOrganizationMain.OnShowHeroInfo = this.ProcessorOnShowHeroInfo;
         this.FProcessorWindowOrganizationMain.OnShowHeroAchievement = this.ProcessorOnShowHeroAchievement;
         this.FProcessorWindowOrganizationMain.OnChatWhisper = this.ProcessorOnChatWhisper;
         this.FProcessorWindowOrganizationMain.OnInterpersonalRelationships = this.ProcessorOnInterpersonalRelationships;
         this.FProcessorWindowOrganizationMain.OnOpenShopExchang = this.OnOpenShopExchang;
         this.FProcessorWindowOrganizationMain.OverHintUpgradeBtn = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOrganizationMain.OutHintUpgradeBtn = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOrganizationMain.OnSelectSlotOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOrganizationMain.OnSelectSlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOrganizationMain.GetMountInfo = this.GetMountInfo;
         this.FProcessorWindowOrganizationMain.SetMountInfo = this.SetMountInfo;
         this.FLayerMask = new Sprite();
         this.FLayerMask.visible = false;
         addChild(this.FLayerMask);
         this.FProcessorWindowOrganizationActivity = new TProcessorWindowOrganizationActivity(this);
         this.FProcessorWindowOrganizationActivity.OnClose = this.OnProcessorWindowOrgActivityClose;
         this.FProcessorWindowOrganizationActivity.OnBtnDonateClick = this.OnProcessorWinowOrgDonateFromOrgActivity;
         this.FProcessorWindowOrganizationActivity.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowOrganizationActivity.OnHintMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOrganizationActivity.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOrgShopExchange = new TProcessorWindowOrgShopExchange(this);
         this.FProcessorWindowOrgShopExchange.OnClose = this.OnProcessorWindowOrgShopExchangeClose;
         this.FProcessorWindowOrgCreate = new TProcessorWindowOrgCreate(this);
         this.FProcessorWindowOrgCreate.OnClose = this.OnProcessorWindowOrgCreateClose;
         this.FProcessorWindowOrgCreate.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowOrgApplyAndPower = new TProcessorWindowOrgApplyAndPower(this);
         this.FProcessorWindowOrgApplyAndPower.OnClose = this.OnProcessorWindowOrgApplyListAndPowerClose;
         this.FProcessorWindowOrgApplyAndPower.OnApplyListCount = this.OnChangeApplyListCount;
         this.FProcessorWindowOrgDonate = new TProcessorWindowOrgDonate(this);
         this.FProcessorWindowOrgDonate.OnClose = this.OnProcessorWindowOrgDonateClose;
         this.FProcessorWindowOrgDonate.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowOrgPower = new TProcessorWindowOrgPower(this);
         this.FProcessorWindowOrgPower.OnClose = this.OnProcessorWindowOrgGotoPowerClose;
         this.FBoundsOrganizationMain = new TBounds();
         this.FBoundsOrganizationMain.Width = SIZE_WindowOrganizationMain_Width;
         this.FBoundsOrganizationMain.Height = SIZE_WindowOrganizationMain_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrganizationMain,this.FBoundsOrganizationMain);
         this.FBoundsOrganizationMain = null;
         this.FBoundsOrganizationActivity = new TBounds();
         this.FBoundsOrganizationActivity.Width = SIZE_WindowOrganizationCamp_Width;
         this.FBoundsOrganizationActivity.Height = SIZE_WindowOrganizationCamp_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrganizationActivity,this.FBoundsOrganizationActivity);
         this.FBoundsOrganizationActivity = null;
         this.FBoundsOrgShopExchang = new TBounds();
         this.FBoundsOrgShopExchang.Width = SIZE_WindowOrgShopExchang_Width;
         this.FBoundsOrgShopExchang.Height = SIZE_WindowOrgShopExchang_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrgShopExchange,this.FBoundsOrgShopExchang);
         this.FBoundsOrgShopExchang = null;
         this.FBoundsOrgCreate = new TBounds();
         this.FBoundsOrgCreate.Width = SIZE_WindowOrgCreate_Width;
         this.FBoundsOrgCreate.Height = SIZE_WindowOrgCreate_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrgCreate,this.FBoundsOrgCreate);
         this.FBoundsOrgCreate = null;
         this.FBoundsOrgApplyAndPower = new TBounds();
         this.FBoundsOrgApplyAndPower.Width = SIZE_WindowOrgApplyAndPower_Width;
         this.FBoundsOrgApplyAndPower.Height = SIZE_WindowOrgApplyAndPower_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrgApplyAndPower,this.FBoundsOrgApplyAndPower);
         this.FBoundsOrgApplyAndPower = null;
         this.FBoundsOrgDonate = new TBounds();
         this.FBoundsOrgDonate.Width = SIZE_WindowOrgDonate_Width;
         this.FBoundsOrgDonate.Height = SIZE_WindowOrgDonate_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrgDonate,this.FBoundsOrgDonate);
         this.FBoundsOrgDonate = null;
         this.FBoundsOrgPower = new TBounds();
         this.FBoundsOrgPower.Width = SIZE_WindowOrgPower_Width;
         this.FBoundsOrgPower.Height = SIZE_WindowOrgPower_Height;
         ComponentBoundsCenter(this.FProcessorWindowOrgPower,this.FBoundsOrgPower);
         this.FBoundsOrgPower = null;
         this.FUnstreamizerOrg = new TUnstreamizerOrganization();
         this.FOrgApplyListDataVect = new Vector.<TBaseOrganizationMember>();
         this.FOrgBaseData = new TBaseOrganization();
         this.FOrgListDataVect = new Vector.<TBaseOrganiztionList>();
         this.FOrgMemberListDataVect = new Vector.<TBaseOrganizationMember>();
         this.FOrgCampDataVect = new Vector.<Object>();
         this.FOrgActivityStatus = new Vector.<Object>();
         this.FOrgLogVect = new Vector.<Object>();
         this.FMuyeGuardRank = new TMuyeGuardRank();
         this.FOrgInitWindows = false;
         this.FBAlreadyLoadOrgActivityStatus = false;
         this.FBOnBtnOrgListClick = false;
         this.FBOnSetOrganizationChannel = false;
         this.FWindowBtnStatus = Vector.<Object>([{"windowOrgDonate":0},{"windowOrgList":0},{"windowOrgLookPower":0},{"windowOrgApplyList":0},{"windowOrgSwitchPower":0},{"tabOrgCamp":0},{"tabOrgMemberList":0},{"tabOrgLog":0},{"tabOrgBag":0},{"activityOrgCamp":0},{"activityOrgMuyeBattleRank":0},{"activityOrgMuyeGuardRank":0}]);
         this.FNewOrgData = SLogicsCore.NewOrgData;
         this.FProcessorWindowOrganizationMain.Data = this.FNewOrgData;
         this.FProcessorWindowOrganizationMain.BaseData = this.FOrgBaseData;
         this.FProcessorWindowOrgShopExchange.Data = this.FNewOrgData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMuyeBattleOrgRankData = new Vector.<TBaseOrganiztionList>();
         this.FMuyeBattlePlayerRankData = new Vector.<TBaseOrganizationMember>();
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FOrgAdditionBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationAddition);
         this.FOrgBaseBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         this.FOrgDevotionBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationDevotion);
         if(this.FUnstreamizerOrganizationNew == null)
         {
            this.FUnstreamizerOrganizationNew = new TUnstreamizerOrganizationNew(this.FNewOrgData);
            this.FProcessorWindowOrganizationMain.UnstreamizerOrganizationNew = this.FUnstreamizerOrganizationNew;
            this.FUnstreamizerOrganizationNew.UnstreamizerConfig();
         }
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_LoadGulidListRet,this.PerformPacket_SC_Organization_LoadGulidListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_CreateGulidRet,this.PerformPacket_SC_Organization_CreateGulidRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_ApplyJoinGulidRet,this.PerformPacket_SC_Organization_ApplyJoinGulidRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_UpGradeRet,this.PerformPacket_SC_Organization_UpGradeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_LoadApplyListRet,this.PerformPacket_SC_Organization_LoadApplyListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_UpGradeGuildTechRet,this.PerformPacket_SC_Organization_UpGradeGuildTechRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_LoadMemberListRet,this.PerformPacket_SC_Organization_LoadMemberListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GetGulidInfoRet,this.PerformPacket_SC_Organization_GetGulidInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GetCampRet,this.PerformPacket_SC_Organization_GetCampRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_SwitchPowerRet,this.PerformPacket_SC_Organization_SwitchPowerRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_MuyeBattleRet,this.PerformPacket_SC_Organization_MuyeBattleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_ConfirmApplyJoinGuildRet,this.PerformPacket_SC_Organization_ConfirmApplyJoinGuildRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_LoadGulidDepotRet,this.PerformPacket_SC_Organization_LoadGulidDepotRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_AssignGulidDepotRet,this.PerformPacket_SC_Organization_AssignGulidDepotRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_DonateRet,this.PerformPacket_SC_Organization_DonateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_QuitGuildRet,this.PerformPacket_SC_Organization_QuitGuildRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_DismissGuildRet,this.PerformPacket_SC_Organization_DismissGuildRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_ActivityStatusRet,this.PerformPacket_SC_Organization_ActivityStatusRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_BoardModifyRet,this.PerformPacket_SC_Organization_BoardModifyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GuildLogRet,this.PerformPacket_SC_Organization_GuildLogRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_ChangeActivityRet,this.PerformPacket_SC_Organization_ChangeActivityStatusRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_KickMemberRet,this.PerformPacket_SC_Organization_KickMemberRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_CityDefendInfoRet,this.PerformPacket_SC_Organization_CityDefendInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_SingleInitRet,this.PerformPacket_SC_Organization_SingleInitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_SingleEnterRet,this.PerformPacket_SC_Organization_SingleEnterRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_ActionEexertion,this.PerformPacket_SC_Organization_ActionEexertion);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GroupInitRet,this.PerformPacket_SC_Organization_GroupInitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GroupOpenRet,this.PerformPacket_SC_Organization_GroupOpenRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_GroupEnterRet,this.PerformPacket_SC_Organization_GroupEnterRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Organization_CopyRefreshRet,this.PerformPacket_SC_Organization_CopyRefreshRet);
         super.PacketRegisterRoutines();
      }
      
      protected function PerformPacket_SC_Organization_LoadGulidListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         this.FUnstreamizerOrg.UnstreamizeOrganizationList(_loc2_,this.FOrgListDataVect,null);
         if(this.FOrgInitWindows)
         {
            if(this.FBOnBtnOrgListClick)
            {
               this.FProcessorWindowOrganizationMain.UpDataPartData(this.FOrgBaseData,this.FOrgListDataVect,this.FOrgApplyListCount,false);
            }
            else
            {
               this.FProcessorWindowOrganizationMain.UpDataPartData(this.FOrgBaseData,this.FOrgListDataVect,this.FOrgApplyListCount);
            }
         }
      }
      
      protected function PerformPacket_SC_Organization_CreateGulidRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowOrgCreate.Visible = false;
         this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         this.FProcessorWindowOrganizationMain.Visible = true;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_14));
      }
      
      protected function PerformPacket_SC_Organization_ApplyJoinGulidRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_15));
      }
      
      protected function PerformPacket_SC_Organization_UpGradeRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         _loc4_ = _loc2_.readUnsignedInt();
         _loc7_ = _loc2_.readUnsignedInt();
         this.FOrgBaseData.SetOrgActivityLevel(_loc4_,_loc5_);
         this.FOrgBaseData.OrgMoney = _loc7_;
         if(_loc4_ == 1)
         {
            this.FOrgBaseData.OrgLevel = _loc5_;
            this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         }
         this.FProcessorWindowOrganizationMain.UpDataUI_OrgPart(this.FOrgBaseData,this.FOrgApplyListCount);
         this.FProcessorWindowOrganizationMain.UpDateUI_OrgActivityUpgrade(_loc4_);
         this.FProcessorWindowOrganizationMain.UpDateUI_OrgCamp();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_16));
      }
      
      protected function PerformPacket_SC_Organization_LoadApplyListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerOrg.UnstreamizeOrganizationApplyAndSwitchList(_loc2_,this.FOrgApplyListDataVect,null);
         this.FProcessorWindowOrgApplyAndPower.UpDateList(this.FOrgBaseData,this.FOrgApplyListDataVect,1);
      }
      
      protected function PerformPacket_SC_Organization_UpGradeGuildTechRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc6_ = _loc2_.readUnsignedInt();
         _loc7_ = _loc2_.readUnsignedInt();
         _loc8_ = _loc2_.readUnsignedInt();
         this.FOrgBaseData.OrgExploit = _loc8_;
         _loc5_ = int(this.FOrgBaseData.OrgAddition.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc6_ == this.FOrgBaseData.OrgAddition[_loc4_].type)
            {
               this.FOrgBaseData.OrgAddition[_loc4_].level = _loc7_;
               break;
            }
            _loc4_++;
         }
         this.FProcessorWindowOrganizationActivity.UpData_Technology(this.FOrgBaseData.OrgAddition,this.FOrgBaseData.OrgExploit);
         this.FProcessorWindowOrganizationActivity.UpDateUI_Technology();
         this.FProcessorWindowOrganizationActivity.ShowEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_16));
         if(this.FUpdateHerosPower != null)
         {
            this.FUpdateHerosPower(this);
         }
         this.FProcessorWindowOrganizationMain.UpDataUI_OrgPart(this.FOrgBaseData,this.FOrgApplyListCount);
      }
      
      protected function PerformPacket_SC_Organization_LoadMemberListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<TBaseOrganizationMember> = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = new Vector.<TBaseOrganizationMember>();
         this.FUnstreamizerOrg.UnstreamizeOrganizationMembers(_loc2_,_loc4_,null);
         this.FOrgMemberListDataVect = _loc4_;
         if(this.FOrgInitWindows)
         {
            this.FProcessorWindowOrganizationMain.UpData_OrgMember(this.FOrgMemberListDataVect);
            if(this.FOrgMemberListDataVect.length > 0)
            {
               this.FProcessorWindowOrganizationMain.UpDateUI_OrgMember();
               this.FProcessorWindowOrganizationMain.UpDateUI_OrgMemberCount(this.FOrgMemberListDataVect.length);
            }
         }
      }
      
      protected function PerformPacket_SC_Organization_GetGulidInfoRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         this.FUnstreamizerOrg.Unstreamize(_loc2_,this.FOrgBaseData,this.FOrgBaseBin);
         if(this.FOrgBaseData.OrgId > 0)
         {
            if(this.FOrgCampDataVect.length <= 0)
            {
               this.PerformPacket_CS_GetCampReq();
            }
            this.PerformPacket_CS_LoadOrgMembersReq();
         }
         if(!this.FBAlreadyLoadOrgActivityStatus)
         {
            this.PerformPacket_CS_ActivityStatusReq();
         }
         if(this.FOnSetOrganizationName != null)
         {
            if(this.FOrgBaseData.OrgId > 0)
            {
               this.FOnSetOrganizationName(this,this.FOrgBaseData.OrgName);
            }
            else
            {
               this.FOnSetOrganizationName(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_21));
            }
         }
         if(this.FOnSetOrganizationChannel != null)
         {
            if(this.FOrgBaseData.OrgId > 0)
            {
               this.FOnSetOrganizationChannel(this,CONST_CHAT.CHANNEL_TYPE_Organization,true);
            }
            else
            {
               this.FOnSetOrganizationChannel(this,CONST_CHAT.CHANNEL_TYPE_Organization,false);
            }
         }
         if(this.FOrgInitWindows)
         {
            if(this.FOrgBaseData.OrgId > 0)
            {
               this.FProcessorWindowOrganizationMain.UpDataPartData(this.FOrgBaseData,this.FOrgListDataVect,this.FOrgApplyListCount);
               if(this.FOrgMemberListDataVect.length <= 0)
               {
                  this.PerformPacket_CS_LoadOrgMembersReq();
               }
            }
            else
            {
               this.PerformPacket_CS_LoadOrgListReq();
            }
         }
         SLogicsCore.Organization = this.FOrgBaseData;
      }
      
      protected function PerformPacket_SC_Organization_GetCampRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readShort();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = {
               "type":0,
               "level":0
            };
            _loc4_.type = _loc2_.readUnsignedInt();
            _loc4_.level = _loc2_.readUnsignedInt();
            this.FOrgCampDataVect[_loc6_] = _loc4_;
            _loc6_++;
         }
         this.FOrgBaseData.OrgCampData = this.FOrgCampDataVect;
         if(this.FOrgBaseData.OrgId > 0 && this.FOrgInitWindows)
         {
            this.FProcessorWindowOrganizationMain.UpDataUI_OrgPart(this.FOrgBaseData,this.FOrgApplyListCount);
            this.FProcessorWindowOrganizationMain.UpDateUI_OrgCamp();
         }
      }
      
      protected function PerformPacket_SC_Organization_SwitchPowerRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowOrgApplyAndPower.Visible = false;
         this.FProcessorWindowOrganizationMain.Visible = true;
         this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         this.PerformPacket_CS_LoadOrgMembersReq();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_17));
      }
      
      protected function PerformPacket_SC_Organization_MuyeBattleRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FMuyeBattleOrgRankData.length = 0;
         this.FMuyeBattlePlayerRankData.length = 0;
         this.FUnstreamizerOrg.UnstreamizeMuyeBattleRank(_loc2_,this.FMuyeBattleOrgRankData,this.FMuyeBattlePlayerRankData);
         this.FProcessorWindowOrganizationActivity.UpdateUI_MuyeBattleRank(this.FMuyeBattleOrgRankData,this.FMuyeBattlePlayerRankData);
      }
      
      protected function PerformPacket_SC_Organization_ConfirmApplyJoinGuildRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<TBaseOrganizationMember> = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc8_ = new Vector.<TBaseOrganizationMember>();
         _loc6_ = _loc2_.readShort();
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = _loc2_.readUnsignedInt();
            _loc5_ = _loc2_.readUnsignedInt();
            this.SpliceApplyListHandler(_loc4_,_loc5_);
            _loc7_++;
         }
         this.FProcessorWindowOrgApplyAndPower.UpDateList(this.FOrgBaseData,this.FOrgApplyListDataVect,1);
         this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         this.PerformPacket_CS_LoadOrgMembersReq();
      }
      
      protected function SpliceApplyListHandler(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FOrgApplyListDataVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FOrgApplyListDataVect[_loc3_].Identifier0 && param2 == this.FOrgApplyListDataVect[_loc3_].Identifier1)
            {
               this.FOrgApplyListDataVect.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      protected function PerformPacket_SC_Organization_LoadGulidDepotRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TInventory = null;
         var _loc9_:TInventories = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:TUnstreamizerInventoryReference = null;
         var _loc13_:Vector.<uint> = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc12_ = new TUnstreamizerInventoryReference();
         _loc5_ = _loc2_.readShort();
         _loc9_ = new TInventories();
         _loc6_ = new Vector.<uint>(_loc5_);
         _loc7_ = new Vector.<uint>(_loc5_);
         _loc13_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc13_[_loc4_] = _loc2_.readUnsignedInt();
            _loc6_[_loc4_] = _loc2_.readUnsignedInt();
            _loc7_[_loc4_] = _loc2_.readUnsignedInt();
            _loc4_++;
         }
         _loc9_.Clear();
         _loc12_.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc9_,_loc6_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc9_.GetInventoryByIndex(_loc4_);
            _loc8_.Quantity = _loc7_[_loc4_];
            _loc4_++;
         }
         this.FProcessorWindowOrganizationMain.UpData_OrgBag(_loc9_,_loc13_,this.FOrgMemberListDataVect,this.FOrgBaseData);
      }
      
      protected function PerformPacket_SC_Organization_AssignGulidDepotRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.PerformPacket_CS_LoadGulidDepotReq();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_18));
      }
      
      protected function PerformPacket_SC_Organization_DonateRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FOrgBaseData.OrgId > 0)
         {
            this.FOrgBaseData.OrgContribution = _loc2_.readUnsignedInt();
            this.FOrgBaseData.OrgExploit = _loc2_.readUnsignedInt();
            this.FOrgBaseData.OrgMoney = _loc2_.readUnsignedInt();
         }
         this.FProcessorWindowOrgDonate.UpData(this.FOrgBaseData.OrgExploit,this.FOrgBaseData.OrgMoney);
         this.FProcessorWindowOrgDonate.UpDateUI();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_19));
      }
      
      protected function PerformPacket_SC_Organization_QuitGuildRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TBaseOrganization = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         if(this.FOrgInitWindows)
         {
            this.OnOrgClose(this);
         }
         _loc5_ = new TBaseOrganization();
         SLogicsCore.Organization = _loc5_;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_20));
         this.CleanAllData();
         if(this.FOnSetOrganizationChannel != null)
         {
            this.FOnSetOrganizationChannel(this,CONST_CHAT.CHANNEL_TYPE_Organization,false);
         }
         if(this.FOnSetOrganizationName != null)
         {
            this.FOnSetOrganizationName(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_21));
         }
         SLogicsCore.Organization.OrgMemberList.Clear();
      }
      
      protected function PerformPacket_SC_Organization_DismissGuildRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TBaseOrganization = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.OnOrgClose(this);
         _loc4_ = new TBaseOrganization();
         SLogicsCore.Organization = _loc4_;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_22));
         this.CleanAllData();
         if(this.FOnSetOrganizationChannel != null)
         {
            this.FOnSetOrganizationChannel(this,CONST_CHAT.CHANNEL_TYPE_Organization,false);
         }
         if(this.FOnSetOrganizationName != null)
         {
            this.FOnSetOrganizationName(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_21));
         }
         SLogicsCore.Organization.OrgMemberList.Clear();
      }
      
      protected function PerformPacket_SC_Organization_ActivityStatusRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<Object> = null;
         _loc2_ = param1.Data;
         _loc4_ = 7;
         _loc7_ = new Vector.<Object>();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = uint(_loc2_.readByte());
            _loc5_ = {
               "type":0,
               "status":0
            };
            if(_loc3_ == 0)
            {
               _loc5_.type = TYPE_ORGACTIVITY_MUYEGUARD;
            }
            else if(_loc3_ == 1)
            {
               _loc5_.type = TYPE_ORGACTIVITY_MUYEBATTLE;
            }
            else if(_loc3_ == 5)
            {
               _loc5_.type = TYPE_ORGACTIVITY_TRAITORATTACK;
            }
            else if(_loc3_ == 6)
            {
               _loc5_.type = TYPE_ORGACTIVITY_VoidSoulWorld;
            }
            else
            {
               _loc5_.type = _loc3_ + TYPE_ORGACTIVITY_PETBATTLE;
            }
            _loc5_.status = _loc6_;
            _loc7_.push(_loc5_);
            _loc3_++;
         }
         this.FOrgActivityStatus = _loc7_;
         this.FOrgBaseData.OrgActivityStatus = _loc7_;
         SLogicsCore.Organization.OrgActivityStatus = this.FOrgActivityStatus;
         if(this.FSetDailyActivityStatus != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.FOrgActivityStatus.length)
            {
               this.FSetDailyActivityStatus(this,this.FOrgActivityStatus[_loc3_].type,this.FOrgActivityStatus[_loc3_].status);
               if(this.FOrgActivityStatus[_loc3_].type == TYPE_ORGACTIVITY_MUYEBATTLE && this.FOrgActivityStatus[_loc3_].status == STATUS_ORGACTIVITY_SignUp)
               {
                  if(this.FOnOrgActivityMuyeBattleSignUp != null)
                  {
                     this.FOnOrgActivityMuyeBattleSignUp(this,CONST_ORGANIZATIONALWAR.CommandID_SignUpInfor,0,this.SignUpCallBack);
                  }
               }
               _loc3_++;
            }
         }
         this.FBAlreadyLoadOrgActivityStatus = true;
      }
      
      protected function PerformPacket_SC_Organization_BoardModifyRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = TUtilityString.FetchUTF(_loc2_);
         this.FOrgBaseData.OrgNotice = _loc4_;
         this.FProcessorWindowOrganizationMain.UpDataUI_OrgPart(this.FOrgBaseData,this.FOrgApplyListCount);
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_23));
      }
      
      protected function PerformPacket_SC_Organization_GuildLogRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = {
               "subject":"",
               "verbType":0,
               "object":"",
               "time":0,
               "short":0
            };
            _loc6_.subject = TUtilityString.FetchUTF(_loc2_);
            _loc6_.verbType = _loc2_.readUnsignedInt();
            _loc6_.object = TUtilityString.FetchUTF(_loc2_);
            _loc6_.time = _loc2_.readUnsignedInt();
            _loc6_.short = _loc2_.readUnsignedShort();
            this.FOrgLogVect[_loc4_] = _loc6_;
            _loc4_++;
         }
         this.FProcessorWindowOrganizationMain.UpDateUI_OrgLog(this.FOrgLogVect);
      }
      
      protected function PerformPacket_SC_Organization_ChangeActivityStatusRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<Object> = null;
         _loc2_ = param1.Data;
         _loc3_ = {
            "type":0,
            "status":0
         };
         _loc3_.type = _loc2_.readByte();
         _loc3_.status = _loc2_.readByte();
         _loc6_ = SLogicsCore.Organization.OrgActivityStatus;
         if(_loc6_ == null)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            if(_loc6_[_loc4_].type == _loc3_.type)
            {
               _loc6_[_loc4_].status = _loc3_.status;
               break;
            }
            _loc4_++;
         }
         SLogicsCore.Organization.OrgActivityStatus = _loc6_;
         if(this.FOrgInitWindows)
         {
            this.FProcessorWindowOrganizationMain.UpDataUI_OrgActivityBtnStatus(_loc3_.type,_loc3_.status);
         }
         if(this.FSetDailyActivityStatus != null)
         {
            this.FSetDailyActivityStatus(this,_loc3_.type,_loc3_.status);
         }
      }
      
      protected function PerformPacket_SC_Organization_KickMemberRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TMuyeGuardRank = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         this.PerformPacket_CS_LoadOrgMembersReq();
      }
      
      protected function PerformPacket_SC_Organization_CityDefendInfoRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerOrg.UnstreamizeMuyeGuardRank(_loc2_,this.FMuyeGuardRank,null);
         this.FProcessorWindowOrganizationActivity.UpDataUI_MuyeGuardRank(this.FMuyeGuardRank);
      }
      
      protected function PerformPacket_SC_Organization_SingleInitRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FUnstreamizerOrganizationNew == null)
         {
            this.FUnstreamizerOrganizationNew = new TUnstreamizerOrganizationNew(this.FNewOrgData);
            this.FProcessorWindowOrganizationMain.UnstreamizerOrganizationNew = this.FUnstreamizerOrganizationNew;
            this.FUnstreamizerOrganizationNew.UnstreamizerConfig();
         }
         this.FUnstreamizerOrganizationNew.SingleInitRet(_loc2_);
         if(Visible)
         {
            this.FProcessorWindowOrganizationMain.OpenSingleTab();
         }
         if(this.FSingleInitRetCall != null)
         {
            this.FSingleInitRetCall(this.FNewOrgData.SingleCopys);
         }
      }
      
      protected function PerformPacket_SC_Organization_SingleEnterRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerOrganizationNew.SingleEnterRet(_loc2_);
         this.FOnOrgGotoSinglePointMap();
      }
      
      protected function PerformPacket_SC_Organization_ActionEexertion(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.Data;
         _loc5_ = uint(_loc2_.readInt());
         _loc3_ = Math.min(this.FOrgBaseData.MyActive + _loc5_,this.FOrgBaseData.MyActiveMax);
         _loc4_ = Math.min(this.FOrgBaseData.GroupActive + _loc5_,this.FOrgBaseData.GroupActiveMax);
         this.FOrgBaseData.MyActive = _loc3_;
         this.FOrgBaseData.GroupActive = _loc4_;
         this.FProcessorWindowOrganizationMain.UpdateActive();
      }
      
      protected function PerformPacket_SC_Organization_GroupInitRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FUnstreamizerOrganizationNew == null)
         {
            this.FUnstreamizerOrganizationNew = new TUnstreamizerOrganizationNew(this.FNewOrgData);
            this.FProcessorWindowOrganizationMain.UnstreamizerOrganizationNew = this.FUnstreamizerOrganizationNew;
            this.FUnstreamizerOrganizationNew.UnstreamizerConfig();
         }
         this.FUnstreamizerOrganizationNew.GroupInitRet(_loc2_);
         if(Visible)
         {
            this.FProcessorWindowOrganizationMain.OpenGroupTab();
         }
         if(this.FGroupInitRetCall != null)
         {
            this.FGroupInitRetCall(this.FNewOrgData.GroupCopys);
         }
      }
      
      protected function PerformPacket_SC_Organization_GroupOpenRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerOrganizationNew.GroupOpenRet(_loc2_,this.FOrgBaseData);
         this.FProcessorWindowOrganizationMain.StartCopyUpdateUI();
      }
      
      protected function PerformPacket_SC_Organization_GroupEnterRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerOrganizationNew.GroupEnterRet(_loc2_);
         this.FOnOrgGotoGroupPointMap();
      }
      
      protected function PerformPacket_SC_Organization_CopyRefreshRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerOrganizationNew.CopyRefreshRet(_loc2_,this.FOrgBaseData);
         this.FProcessorWindowOrganizationMain.ResetCopyUpdateUI();
      }
      
      protected function PerformPacket_CS_UpdateOrgBaseInfoReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GetGulidInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_LoadOrgListReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadGulidListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_LoadOrgMembersReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadMemberListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_GetCampReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GetCampReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_ActivityStatusReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_ActivityStatusReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_LoadGulidDepotReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadGulidDepotReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_QuitGuildReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_QuitGuildReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_DismissGuildReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_DismissGuildReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CleanAllData() : void
      {
         this.FOrgListDataVect.length = 0;
         this.FOrgApplyListDataVect.length = 0;
         this.FOrgMemberListDataVect.length = 0;
         this.FOrgCampDataVect.length = 0;
         this.FOrgActivityStatus.length = 0;
         this.FOrgLogVect.length = 0;
      }
      
      protected function OnChangeApplyListCount(param1:Object, param2:uint) : void
      {
         this.FOrgApplyListCount = param2;
         this.FProcessorWindowOrganizationMain.UpDateUI_OrgApplyListCount(this.FOrgApplyListCount);
      }
      
      protected function OnOrgActivityOkClick(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         this.FProcessorWindowOrganizationActivity.UpData_OrgBaseInfo(this.FOrgBaseData);
         switch(param2)
         {
            case TYPE_ORGACTIVITY_CAMP:
               this.FProcessorWindowOrganizationMain.Visible = false;
               this.FProcessorWindowOrganizationActivity.Visible = true;
               this.FProcessorWindowOrganizationActivity.OnOrgActivityClick(1);
               this.FProcessorWindowOrganizationActivity.UpData_Technology(this.FOrgBaseData.OrgAddition,this.FOrgBaseData.OrgExploit);
               this.FProcessorWindowOrganizationActivity.UpDateUI_Technology();
               break;
            case TYPE_ORGACTIVITY_MUYEGUARD:
               if(param3 == STATUS_ORGACTIVITY_Battle)
               {
                  ProcessorClose();
                  if(this.FOnOrgActivityMuyeGuardStartBattle != null)
                  {
                     this.FOnOrgActivityMuyeGuardStartBattle(this);
                  }
               }
               else
               {
                  this.FProcessorWindowOrganizationMain.Visible = false;
                  this.FProcessorWindowOrganizationActivity.Visible = true;
                  this.FProcessorWindowOrganizationActivity.OnOrgActivityClick(2);
               }
               break;
            case TYPE_ORGACTIVITY_PETBATTLE:
               break;
            case TYPE_ORGACTIVITY_MUYEBATTLE:
               if(param3 == STATUS_ORGACTIVITY_SignUp)
               {
                  if(this.FOnOrgActivityMuyeBattleSignUp != null)
                  {
                     this.FOnOrgActivityMuyeBattleSignUp(this,CONST_ORGANIZATIONALWAR.CommandID_SignUp,0,null);
                  }
               }
               else if(param3 == STATUS_ORGACTIVITY_Battle)
               {
                  ProcessorClose();
                  if(this.FOnOrgActivityMuyeBattleStartBattle != null)
                  {
                     this.FOnOrgActivityMuyeBattleStartBattle(this);
                  }
               }
               else
               {
                  this.FProcessorWindowOrganizationMain.Visible = false;
                  this.FProcessorWindowOrganizationActivity.Visible = true;
                  this.FProcessorWindowOrganizationActivity.OnOrgActivityClick(4);
               }
         }
      }
      
      protected function SignUpCallBack(param1:uint) : void
      {
         if(param1 != 0)
         {
            this.OnSetOrgActivity(TYPE_ORGACTIVITY_MUYEBATTLE,STATUS_ORGACTIVITY_Added);
         }
      }
      
      protected function OnProcessorWindowOrgDonate(param1:Object) : void
      {
         this.FProcessorWindowOrganizationMain.Visible = false;
         this.FProcessorWindowOrgDonate.Visible = true;
         this.FProcessorWindowOrgDonate.UpData(this.FOrgBaseData.OrgExploit,this.FOrgBaseData.OrgMoney);
         this.FProcessorWindowOrgDonate.UpDateUI();
      }
      
      protected function OnProcessorWindowOrgDonateClose(param1:Object) : void
      {
         this.FProcessorWindowOrganizationMain.Visible = true;
         this.FProcessorWindowOrganizationMain.UpDataUI_OrgPart(this.FOrgBaseData,this.FOrgApplyListCount);
         this.FProcessorWindowOrgDonate.Visible = false;
      }
      
      protected function OnProcessorWindowOrgList(param1:Object, param2:Boolean) : void
      {
         this.FBOnBtnOrgListClick = true;
         this.PerformPacket_CS_LoadOrgListReq();
      }
      
      protected function OnProcessorWindowOrgGotoPower(param1:Object) : void
      {
         this.FProcessorWindowOrgPower.Visible = true;
         this.FProcessorWindowOrganizationMain.Visible = false;
      }
      
      protected function OnProcessorWindowOrgGotoPowerClose(param1:Object) : void
      {
         this.FProcessorWindowOrgPower.Visible = false;
         this.FProcessorWindowOrganizationMain.Visible = true;
      }
      
      protected function OnProcessorWindowOrgApplyList(param1:Object, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadApplyListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FProcessorWindowOrganizationMain.Visible = false;
         this.FProcessorWindowOrgApplyAndPower.Visible = true;
      }
      
      protected function OnProcessorWindowOrgSwitchPower(param1:Object, param2:int) : void
      {
         this.FProcessorWindowOrganizationMain.Visible = false;
         this.FProcessorWindowOrgApplyAndPower.Visible = true;
         this.FProcessorWindowOrgApplyAndPower.UpDateList(this.FOrgBaseData,this.FOrgMemberListDataVect,2);
      }
      
      protected function OnProcessorWindowOrgApplyListAndPowerClose(param1:Object) : void
      {
         this.FProcessorWindowOrganizationMain.Visible = true;
         this.FProcessorWindowOrgApplyAndPower.Visible = false;
      }
      
      protected function OnProcessorWindowOrgCreateShow(param1:Object) : void
      {
         this.FProcessorWindowOrgCreate.Visible = true;
         this.FProcessorWindowOrganizationMain.Visible = false;
         this.FProcessorWindowOrgCreate.UpDateUI();
      }
      
      protected function OnProcessorWindowOrgCreateClose(param1:Object) : void
      {
         this.FProcessorWindowOrgCreate.Visible = false;
         this.FProcessorWindowOrganizationMain.Visible = true;
      }
      
      protected function OnProcessorWindowOrgActivityClose(param1:Object) : void
      {
         this.FProcessorWindowOrganizationActivity.Visible = false;
         this.FProcessorWindowOrganizationMain.Visible = true;
      }
      
      protected function OnProcessorWindowOrgShopExchangeClose(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      protected function OnOpenShopExchang() : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowOrgShopExchange.Visible = true;
      }
      
      protected function OnProcessorWinowOrgDonateFromOrgActivity(param1:Object) : void
      {
         this.FProcessorWindowOrganizationActivity.Visible = false;
         this.FProcessorWindowOrgDonate.Visible = true;
         this.FProcessorWindowOrgDonate.UpData(this.FOrgBaseData.OrgExploit,this.FOrgBaseData.OrgMoney);
         this.FProcessorWindowOrgDonate.UpDateUI();
      }
      
      protected function OnBtnQuitClick(param1:Object) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FOrgBaseData.OrgPower;
         if(_loc2_ == 2)
         {
            this.PerformPacket_CS_DismissGuildReq();
         }
         else
         {
            this.PerformPacket_CS_QuitGuildReq();
         }
      }
      
      protected function OnProcessorWindowOrgGotoSinglePointMap() : void
      {
         this.FUnstreamizerOrganizationNew.SingleEnterReq();
      }
      
      protected function OnProcessorWindowOrgGotoGroupPointMap() : void
      {
         this.FUnstreamizerOrganizationNew.GroupEnterReq();
      }
      
      protected function OnOrgClose(param1:Object) : void
      {
         if(this.FBOnBtnOrgListClick)
         {
            this.FProcessorWindowOrganizationMain.UpDataPartData(this.FOrgBaseData,this.FOrgListDataVect,this.FOrgApplyListCount,true);
            this.FBOnBtnOrgListClick = false;
         }
         else
         {
            ProcessorClose();
         }
      }
      
      protected function ProcessorOnShowHeroInfo(param1:Object, param2:uint, param3:uint) : void
      {
         this.FOnShowHeroInfo(param1,param2,param3);
      }
      
      protected function ProcessorOnShowHeroAchievement(param1:Object, param2:uint, param3:uint) : void
      {
         this.FOnShowHeroAchievement(param1,param2,param3);
      }
      
      protected function ProcessorOnChatWhisper(param1:Object, param2:Object) : void
      {
         this.FOnChatWhisper(param1,param2);
      }
      
      protected function ProcessorOnInterpersonalRelationships(param1:Object, param2:uint, param3:Object) : void
      {
         this.FOnInterpersonalRelationships(param1,param2,param3);
      }
      
      public function get OnOrgActivityMuyeBattleSignUp() : Function
      {
         return this.FOnOrgActivityMuyeBattleSignUp;
      }
      
      public function set OnOrgActivityMuyeBattleSignUp(param1:Function) : void
      {
         this.FOnOrgActivityMuyeBattleSignUp = param1;
      }
      
      public function get SetDailyActivityStatus() : Function
      {
         return this.FSetDailyActivityStatus;
      }
      
      public function set SetDailyActivityStatus(param1:Function) : void
      {
         this.FSetDailyActivityStatus = param1;
      }
      
      public function get UpdateHerosPower() : Function
      {
         return this.FUpdateHerosPower;
      }
      
      public function set UpdateHerosPower(param1:Function) : void
      {
         this.FUpdateHerosPower = param1;
      }
      
      public function get OnSetOrganizationName() : Function
      {
         return this.FOnSetOrganizationName;
      }
      
      public function set OnSetOrganizationName(param1:Function) : void
      {
         this.FOnSetOrganizationName = param1;
      }
      
      public function get OnSetOrganizationChannel() : Function
      {
         return this.FOnSetOrganizationChannel;
      }
      
      public function set OnSetOrganizationChannel(param1:Function) : void
      {
         this.FOnSetOrganizationChannel = param1;
      }
      
      public function get OnOrgActivityMuyeGuardStartBattle() : Function
      {
         return this.FOnOrgActivityMuyeGuardStartBattle;
      }
      
      public function set OnOrgActivityMuyeGuardStartBattle(param1:Function) : void
      {
         this.FOnOrgActivityMuyeGuardStartBattle = param1;
      }
      
      public function get OnOrgActivityMuyeBattleStartBattle() : Function
      {
         return this.FOnOrgActivityMuyeBattleStartBattle;
      }
      
      public function set OnOrgActivityMuyeBattleStartBattle(param1:Function) : void
      {
         this.FOnOrgActivityMuyeBattleStartBattle = param1;
      }
      
      public function get OnShowHeroInfo() : Function
      {
         return this.FOnShowHeroInfo;
      }
      
      public function set OnShowHeroInfo(param1:Function) : void
      {
         this.FOnShowHeroInfo = param1;
      }
      
      public function get OnChatWhisper() : Function
      {
         return this.FOnChatWhisper;
      }
      
      public function set OnChatWhisper(param1:Function) : void
      {
         this.FOnChatWhisper = param1;
      }
      
      public function get OnInterpersonalRelationships() : Function
      {
         return this.FOnInterpersonalRelationships;
      }
      
      public function set OnInterpersonalRelationships(param1:Function) : void
      {
         this.FOnInterpersonalRelationships = param1;
      }
      
      public function set OnShowHeroAchievement(param1:Function) : void
      {
         this.FOnShowHeroAchievement = param1;
      }
      
      public function set OnOrgGotoSinglePointMap(param1:Function) : void
      {
         this.FOnOrgGotoSinglePointMap = param1;
      }
      
      public function set OnOrgGotoGroupPointMap(param1:Function) : void
      {
         this.FOnOrgGotoGroupPointMap = param1;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FProcessorWindowOrgShopExchange.OnExchange = param1;
      }
      
      public function set SingleInitRetCall(param1:Function) : void
      {
         this.FSingleInitRetCall = param1;
      }
      
      public function set GroupInitRetCall(param1:Function) : void
      {
         this.FGroupInitRetCall = param1;
      }
      
      public function GetMountInfo() : ByteArray
      {
         return this.FMountInfo;
      }
      
      public function SetMountInfo(param1:ByteArray) : void
      {
         this.FMountInfo = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!(this.FMountInfo != null && param1 == null))
         {
            this.FMountInfo = param1;
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowOrganizationMain.Load();
            this.FProcessorWindowOrganizationActivity.Load();
            this.FProcessorWindowOrgShopExchange.Load();
            this.FProcessorWindowOrgCreate.Load();
            this.FProcessorWindowOrgApplyAndPower.Load();
            this.FProcessorWindowOrgDonate.Load();
            this.FProcessorWindowOrgPower.Load();
            return;
         }
         this.FOrgInitWindows = true;
         this.PerformPacket_CS_UpdateOrgBaseInfoReq();
         this.PerformPacket_CS_GetCampReq();
         this.FProcessorWindowOrganizationMain.Visible = true;
         this.FProcessorWindowOrganizationActivity.Visible = false;
         this.FProcessorWindowOrgShopExchange.Visible = false;
         this.FProcessorWindowOrgCreate.Visible = false;
         this.FProcessorWindowOrgApplyAndPower.Visible = false;
         this.FProcessorWindowOrgDonate.Visible = false;
         this.FProcessorWindowOrgPower.Visible = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ArmyGroup);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowOrganizationMain.Visible = false;
         this.FProcessorWindowOrganizationActivity.Visible = false;
         this.FProcessorWindowOrgShopExchange.Visible = false;
         this.FProcessorWindowOrgCreate.Visible = false;
         this.FProcessorWindowOrgApplyAndPower.Visible = false;
         this.FProcessorWindowOrgPower.Visible = false;
         this.FOrgInitWindows = false;
         this.FBOnBtnOrgListClick = false;
         this.FProcessorWindowOrganizationMain.Unmount();
         this.FProcessorWindowOrganizationActivity.Reset();
         super.Unmount();
      }
      
      public function GetOrgNameFromOrgID(param1:uint) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = int(this.FOrgListDataVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FOrgListDataVect[_loc2_].OrgID == param1)
            {
               _loc4_ = this.FOrgListDataVect[_loc2_].OrgName;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetActivityLevelByType(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         return this.FOrgBaseData.GetOrgActivityLevelByType(param1);
      }
      
      public function OnSetOrgActivity(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc4_ = int(this.FOrgActivityStatus.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FOrgActivityStatus[_loc3_].type)
            {
               _loc5_ = uint(this.FOrgActivityStatus[_loc3_].type);
               this.FOrgActivityStatus[_loc3_].status = param2;
               this.FOrgBaseData.OrgActivityStatus[_loc3_].status = param2;
               break;
            }
            _loc3_++;
         }
         if(param1 == TYPE_ORGACTIVITY_MUYEBATTLE && param2 == STATUS_ORGACTIVITY_Added)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_24));
         }
         SLogicsCore.Organization.OrgActivityStatus = this.FOrgActivityStatus;
         if(this.FSetDailyActivityStatus != null)
         {
            this.FSetDailyActivityStatus(this,param1,param2);
         }
         if(this.FOrgInitWindows)
         {
            this.FProcessorWindowOrganizationMain.UpDataUI_OrgActivityBtnStatus(_loc5_,param2);
         }
      }
      
      public function MallInforInitRet(param1:int, param2:TPacket) : void
      {
         this.FUnstreamizerOrganizationNew.MallInitRet(param1,param2.Data);
         this.FProcessorWindowOrganizationMain.OpenMallTab();
      }
      
      public function MallRefreshRet(param1:int, param2:TPacket) : void
      {
         this.FUnstreamizerOrganizationNew.MallRefreshRet(param1,param2.Data);
         if(param1 == this.FProcessorWindowOrganizationMain.CurrentMallType)
         {
            this.FProcessorWindowOrganizationMain.MallUpdate();
         }
      }
      
      public function MallBuyGoodRet(param1:int, param2:TPacket) : void
      {
         this.FUnstreamizerOrganizationNew.MallBuyGoodRet(param1,param2.Data);
         this.FProcessorWindowOrganizationMain.UpdateShopCurrentPage();
      }
      
      public function UpdateGroupMoney(param1:TPacket) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         _loc3_ = this.FNewOrgData.GroupMoney;
         this.FUnstreamizerOrganizationNew.UpdateGroupMoney(param1.Data);
         _loc2_ = this.FNewOrgData.NewOrgSystemLanguage.GetStr34(this.FNewOrgData.GroupMoney - _loc3_);
         this.FProcessorWindowOrganizationMain.UpdateShopCurrentPage();
      }
   }
}

