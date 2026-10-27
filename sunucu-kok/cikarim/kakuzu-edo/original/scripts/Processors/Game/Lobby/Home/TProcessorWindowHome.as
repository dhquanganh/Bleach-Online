package Processors.Game.Lobby.Home
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.*;
   import Logics.Organization.*;
   import Logics.TimeCoolDown.*;
   import Logics.Unlocks.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Home.Component.*;
   import Processors.Game.Lobby.Home.GirlFriend.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHome extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_MC_Items:uint = CONST_HOME.CAPACITY_MC_Items;
      
      public static const TIME_InteractiveTeaseTime:uint = CONST_HOME.TIME_InteractiveTeaseTime;
      
      public static const TYPE_Interactive_1:uint = CONST_HOME.TYPE_Interactive_1;
      
      public static const TYPE_Interactive_2:uint = CONST_HOME.TYPE_Interactive_2;
      
      public static const TYPE_Interactive_3:uint = CONST_HOME.TYPE_Interactive_3;
      
      protected static const FRAME_OpenEnd:uint = CONST_HOME.FRAME_OpenEnd;
      
      protected static const FRAME_CloseEnd:uint = CONST_HOME.FRAME_CloseEnd;
      
      protected static const FRAME_ShowEnd:uint = CONST_HOME.FRAME_ShowEnd;
      
      protected static const FRAME_HideEnd:uint = CONST_HOME.FRAME_HideEnd;
      
      protected static const POSITION_Home:uint = CONST_SHORTCUTS.POSITION_Home;
      
      protected static const TYPE_Home_HellButterfly:uint = CONST_SHORTCUTS.TYPE_Home_HellButterfly;
      
      protected static const TYPE_Home_Slave:uint = CONST_SHORTCUTS.TYPE_Home_Slave;
      
      protected static const TYPE_Home_Gamble:uint = CONST_SHORTCUTS.TYPE_Home_Gamble;
      
      protected var FUIWindowConfirmationClearCD:TUIWindowConfirmation;
      
      protected var FUIWindowConfirmationInteractiveGirlFriend:TUIWindowConfirmation;
      
      protected var FUIWindowConfirmationHomeSoul:TUIWindowConfirmation;
      
      protected var FConfigValueBin:TBins;
      
      protected var FHomeGirlAwards:TBins;
      
      protected var FArticles:TBins;
      
      protected var FHomeGirlInteracts:TBins;
      
      protected var FGlowFilter:GlowFilter;
      
      protected var FHint:THint;
      
      protected var FCharacter:TCharacter;
      
      protected var FHome:THome;
      
      protected var FHomeFriend:THome;
      
      protected var FFriendDigests:TFriendDigests;
      
      protected var FFriendsFilter:TFriendDigests;
      
      protected var FTimeCoolDownLuckycat:TTimeCoolDown;
      
      protected var FTimeCoolDownGirlFriendInteractive:TTimeCoolDown;
      
      protected var FBtns:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Return:TUIButton;
      
      protected var FBtnAddSilverCoin:SimpleButton;
      
      protected var FSubstratePoint:Sprite;
      
      protected var FFloatingIslandLeftPoint:Sprite;
      
      protected var FFloatingIslandRightPoint:Sprite;
      
      protected var FMC_FloatingIslandPoints:MovieClip;
      
      protected var FSP_FloatingIslandPoints:Sprite;
      
      protected var FSP_FloatingIslandHomeHallPoint:Sprite;
      
      protected var FSP_FloatingIslandGirlFriendPoint:Sprite;
      
      protected var FMountPointsRoleBounds:TBounds;
      
      protected var FMountPointsRolePivot:TCoordinate;
      
      protected var FGirlfriendAvatarCoordinate:TCoordinate;
      
      protected var FSP_HomeTag:Sprite;
      
      protected var FTF_HomeTag:TextField;
      
      protected var FMC_HomeEffect:MovieClip;
      
      protected var FMC_EffectMonster:MovieClip;
      
      protected var FSP_MonsterPopTip:Sprite;
      
      protected var FTF_MonsterName:TextField;
      
      protected var FTF_MonsterQuantity:TextField;
      
      protected var FMC_Monsters:MovieClip;
      
      protected var FMC_Monster:MovieClip;
      
      protected var FSP_LuckyCatPopTip:Sprite;
      
      protected var FTF_CDTime:TextField;
      
      protected var FBtn_ClearCD:TUIButton;
      
      protected var FTF_Count:TextField;
      
      protected var FSP_LuckyCatCursorHovering:Sprite;
      
      protected var FMC_LuckyCat:MovieClip;
      
      protected var FMC_LuckyCats:MovieClip;
      
      protected var FLuckyCatEffectCount:int;
      
      protected var FLuckyCatCoordinate:TCoordinate;
      
      protected var FUICredits:TUICredits;
      
      protected var FTFCaption:TextField;
      
      protected var FTFLevelTitle:TextField;
      
      protected var FTFInteractiveTitle:TextField;
      
      protected var FBtnInteractiveLog:TUIButton;
      
      protected var FBtnAKeyMonster:TUIButton;
      
      protected var FBtnReturnHome:TUIButton;
      
      protected var FTFGirlfriendCount:TextField;
      
      protected var FTFMyMonsterCount:TextField;
      
      protected var FTFFriendMonsterCount:TextField;
      
      protected var FTFCommunicateCount:TextField;
      
      protected var FTFMakeTofuCount:TextField;
      
      protected var FTFCommunicateLable:TextField;
      
      protected var FTFMakeTofuLable:TextField;
      
      protected var FSGirlFriend:Sprite;
      
      protected var FSP_GirlfriendInteractive:Sprite;
      
      protected var FSP_GirlfriendUpgrade:Sprite;
      
      protected var FBtnGirlfriendInteractive_0:TUIButton;
      
      protected var FBtnGirlfriendInteractive_1:TUIButton;
      
      protected var FBtnGirlfriendInteractive_2:TUIButton;
      
      protected var FBtnGirlfriendInteractiveUpgrade:TUIButton;
      
      protected var FMC_EffectGirlFriendPopTip:MovieClip;
      
      protected var FMC_GirlFriendPopTip:MovieClip;
      
      protected var FTF_GirlFriendPopTip:TextField;
      
      protected var FSGirlfriendAvatar:Sprite;
      
      protected var FBitmapGirlFriend:Bitmap;
      
      protected var FBitmapSubstrate:Bitmap;
      
      protected var FBitmapFloatingIslandLeft:Bitmap;
      
      protected var FBitmapFloatingIslandRight:Bitmap;
      
      protected var FMCPanelShortcuts:MovieClip;
      
      protected var FBtnHomeHall:TUIButton;
      
      protected var FBtnGirlfriend:TUIButton;
      
      protected var FBtnHellButterfly:TUIButton;
      
      protected var FBtnSlave:TUIButton;
      
      protected var FBtnGamble:TUIButton;
      
      protected var FMC_HellButterflyEffect1:MovieClip;
      
      protected var FMC_HellButterflyEffect2:MovieClip;
      
      protected var FMC_Title:MovieClip;
      
      protected var FMC_TitleSlave:MovieClip;
      
      protected var FMC_TitleLuckyCat:MovieClip;
      
      protected var FMC_TitleMonster:MovieClip;
      
      protected var FMC_TitleHomeHall:MovieClip;
      
      protected var FMC_TitleGirlFriend:MovieClip;
      
      protected var FMC_TitleGamble:MovieClip;
      
      protected var FMCFriend:Sprite;
      
      protected var FBtnCloseFriend:TUIButton;
      
      protected var FBtnOpenFriend:TUIButton;
      
      protected var FMCFriendList:MovieClip;
      
      protected var FSFriendList:Sprite;
      
      protected var FItemFriends:Vector.<TItemFriend>;
      
      protected var FUIPageFriend:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FHomeGirlFriendID:int;
      
      protected var FHomeSubstrateID:int;
      
      protected var FHomeFloatingIslandLeftID:int;
      
      protected var FHomeFloatingIslandRightID:int;
      
      protected var FHomeType:uint;
      
      protected var FAKeyMonsterCost:uint;
      
      protected var FGirlfriendInteractiveIndex:int;
      
      protected var FIsUpdateFriendUI:Boolean;
      
      protected var FCursorHoveringLuckyCat:Boolean;
      
      protected var FCursorClickedLuckyCat:Boolean;
      
      protected var FCursorHoveringMonster:Boolean;
      
      protected var FLastIsAlpah:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FOnVisit:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOverlayOnMove:Function;
      
      protected var FOverlayOnOut:Function;
      
      protected var FOnHomeHall:Function;
      
      protected var FOnMonster:Function;
      
      protected var FOnLuckyCat:Function;
      
      protected var FOnClearCD:Function;
      
      protected var FOnClickOpenGirlFriend:Function;
      
      protected var FOnClickUpgradeGirlFriend:Function;
      
      protected var FOnInteractionLog:Function;
      
      protected var FOnEffectSilverCoin:Function;
      
      public function TProcessorWindowHome(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FCharacter = SLogicsCore.Character;
         this.FHome = SLogicsCore.Home;
         this.FHomeFriend = SLogicsCore.HomeFriend;
         this.FFriendDigests = SLogicsCore.Friends;
         this.FFriendsFilter = new TFriendDigests();
         this.FTimeCoolDownLuckycat = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Home_LuckycatCD);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDownLuckycat);
         this.FTimeCoolDownGirlFriendInteractive = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Home_GirlFriendInteractive);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDownGirlFriendInteractive);
         this.FItemFriends = new Vector.<TItemFriend>(CAPACITY_MC_Items);
         this.FBitmapGirlFriend = new Bitmap();
         this.FBitmapSubstrate = new Bitmap();
         this.FBitmapFloatingIslandLeft = new Bitmap();
         this.FBitmapFloatingIslandRight = new Bitmap();
         this.FMountPointsRoleBounds = new TBounds();
         this.FMountPointsRolePivot = new TCoordinate();
         this.FGlowFilter = new GlowFilter(14216721,0.6,8,8,8);
         this.FPageIndex = 0;
         this.FHomeGirlFriendID = 0;
         this.FHomeSubstrateID = 0;
         this.FHomeFloatingIslandLeftID = 0;
         this.FHomeFloatingIslandRightID = 0;
         this.FIsUpdateFriendUI = true;
         this.FCursorHoveringLuckyCat = false;
         this.FCursorClickedLuckyCat = false;
         this.FCursorHoveringMonster = false;
         this.FLastIsAlpah = false;
         this.FInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HOME.RESOURCESID_Swf_Home);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:TItemFriend = null;
         var _loc7_:TextField = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_HOME.RESOURCE_ClassName_MC_Home) as Sprite;
         addChild(_loc3_);
         this.FBtns = _loc3_[CONST_HOME.RESOURCE_Link_Btns];
         this.FBtn_Close = this.FBtns[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FBtn_Help = this.FBtns[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Help.tabEnabled = false;
         this.FBtn_Return = new TUIButton();
         this.FBtn_Return.Substrate = _loc3_[CONST_HOME.RESOURCE_Link_Btn_Return];
         this.FBtn_Return.OnClick = this.ButtonReturnOnClick;
         this.FSubstratePoint = _loc3_[CONST_HOME.RESOURCE_Link_SP_SubstratePoint];
         this.FSubstratePoint.addChild(this.FBitmapSubstrate);
         this.FFloatingIslandLeftPoint = _loc3_[CONST_HOME.RESOURCE_Link_SP_FloatingIslandLeftPoint];
         this.FFloatingIslandLeftPoint.addChild(this.FBitmapFloatingIslandLeft);
         this.FFloatingIslandLeftPoint.buttonMode = true;
         this.FFloatingIslandRightPoint = _loc3_[CONST_HOME.RESOURCE_Link_SP_FloatingIslandRightPoint];
         this.FFloatingIslandRightPoint.addChild(this.FBitmapFloatingIslandRight);
         this.FFloatingIslandRightPoint.buttonMode = true;
         this.FMC_FloatingIslandPoints = _loc3_[CONST_HOME.RESOURCE_Link_MC_FloatingIslandPoints];
         this.FMC_FloatingIslandPoints.mouseEnabled = false;
         this.FMC_FloatingIslandPoints.alpha = 0;
         this.FSP_HomeTag = _loc3_[CONST_HOME.RESOURCE_Link_SP_HomeTag];
         this.FTF_HomeTag = this.FSP_HomeTag[CONST_HOME.RESOURCE_Link_TF_HomeTag];
         this.FSP_HomeTag.mouseEnabled = false;
         this.FSP_HomeTag.mouseChildren = false;
         this.FSP_HomeTag.visible = false;
         this.FMC_HomeEffect = _loc3_[CONST_HOME.RESOURCE_Link_MC_HomeEffect];
         this.FMC_HomeEffect.mouseEnabled = false;
         this.FMC_HomeEffect.mouseChildren = false;
         this.FMC_HomeEffect.stop();
         this.FMC_EffectMonster = _loc3_[CONST_HOME.RESOURCE_Link_MC_EffectMonster];
         this.FSP_MonsterPopTip = _loc3_[CONST_HOME.RESOURCE_Link_SP_MonsterPopTip];
         this.FSP_MonsterPopTip.mouseEnabled = false;
         this.FSP_MonsterPopTip.mouseChildren = false;
         this.FTF_MonsterName = this.FSP_MonsterPopTip[CONST_HOME.RESOURCE_Link_TF_Name];
         this.FTF_MonsterQuantity = this.FSP_MonsterPopTip[CONST_HOME.RESOURCE_Link_TF_Quantity];
         _loc4_ = _loc3_[CONST_HOME.RESOURCE_Link_SP_Monsters];
         this.FMC_Monsters = _loc4_[CONST_HOME.RESOURCE_Link_MC_Monsters];
         this.FMC_EffectMonster.mouseEnabled = false;
         this.FMC_EffectMonster.mouseChildren = false;
         this.FMC_EffectMonster.stop();
         this.FTF_MonsterName.text = "";
         this.FTF_MonsterQuantity.text = "";
         this.FMC_Monsters.stop();
         this.FSP_LuckyCatPopTip = _loc3_[CONST_HOME.RESOURCE_Link_SP_LuckyCatPopTip];
         this.FSP_LuckyCatPopTip.mouseEnabled = false;
         this.FTF_CDTime = this.FSP_LuckyCatPopTip[CONST_HOME.RESOURCE_Link_TF_CDTime];
         this.FBtn_ClearCD = new TUIButton();
         this.FBtn_ClearCD.Substrate = this.FSP_LuckyCatPopTip[CONST_HOME.RESOURCE_Link_Btn_ClearCD];
         this.FBtn_ClearCD.OnClick = this.ButtonClearCDOnClick;
         this.FTF_Count = this.FSP_LuckyCatPopTip[CONST_HOME.RESOURCE_Link_TF_Count];
         this.FSP_LuckyCatCursorHovering = _loc3_[CONST_HOME.RESOURCE_Link_SP_LuckyCatCursorHovering];
         this.FSP_LuckyCatCursorHovering.mouseEnabled = false;
         this.FSP_LuckyCatCursorHovering.mouseChildren = false;
         this.FSP_LuckyCatCursorHovering.visible = false;
         this.FLuckyCatCoordinate = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FSP_LuckyCatCursorHovering);
         this.FLuckyCatCoordinate.X += this.FSP_LuckyCatCursorHovering.width / 2;
         this.FLuckyCatCoordinate.Y += this.FSP_LuckyCatCursorHovering.height / 2;
         this.FMC_LuckyCat = _loc3_[CONST_HOME.RESOURCE_Link_MC_LuckyCat];
         this.FMC_LuckyCat.stop();
         this.FMC_LuckyCats = this.FMC_LuckyCat[CONST_HOME.RESOURCE_Link_MC_LuckyCats];
         this.FMC_LuckyCats.stop();
         this.FMC_LuckyCats.mouseEnabled = false;
         this.FMC_LuckyCats.mouseChildren = false;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = _loc3_[CONST_HOME.RESOURCE_Link_MC_PanelCredits];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         _loc4_ = _loc3_[CONST_HOME.RESOURCE_Link_MC_PanelHomeInfo];
         this.FTFCaption = _loc4_[CONST_HOME.RESOURCE_Link_TF_Caption];
         this.FTFLevelTitle = _loc4_[CONST_HOME.RESOURCE_Link_TF_Level];
         this.FTFInteractiveTitle = _loc4_[CONST_HOME.RESOURCE_Link_TF_InteractiveTitle];
         this.FBtnInteractiveLog = new TUIButton();
         this.FBtnInteractiveLog.Substrate = _loc4_[CONST_HOME.RESOURCE_Link_Btn_InteractiveRecord];
         this.FBtnInteractiveLog.OnClick = this.BtnInteractiveLogOnClick;
         this.FBtnInteractiveLog.OnMove = this.ButtonOnMove;
         this.FBtnInteractiveLog.OnOut = this.ButtonOnOut;
         this.FBtnInteractiveLog.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_05);
         this.FBtnInteractiveLog.Visible = false;
         this.FBtnReturnHome = new TUIButton();
         this.FBtnReturnHome.Substrate = _loc4_[CONST_HOME.RESOURCE_Link_Btn_ReturnHome];
         this.FBtnReturnHome.OnClick = this.BtnReturnHomeOnClick;
         this.FBtnReturnHome.OnMove = this.ButtonOnMove;
         this.FBtnReturnHome.OnOut = this.ButtonOnOut;
         this.FBtnReturnHome.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_04);
         this.FBtnReturnHome.Visible = false;
         this.FBtnAKeyMonster = new TUIButton();
         this.FBtnAKeyMonster.Substrate = _loc4_[CONST_HOME.RESOURCE_Link_Btn_AKeyMonster];
         this.FBtnAKeyMonster.OnClick = this.BtnAKeyMonsterOnClick;
         this.FBtnAKeyMonster.OnMove = this.ButtonOnMove;
         this.FBtnAKeyMonster.OnOut = this.ButtonOnOut;
         this.FBtnAKeyMonster.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_06);
         _loc4_ = _loc3_[CONST_HOME.RESOURCE_Link_MC_PanelInteractiveInfo];
         this.FTFGirlfriendCount = _loc4_[CONST_HOME.RESOURCE_Link_TF_GirlfriendCount];
         this.FTFMyMonsterCount = _loc4_[CONST_HOME.RESOURCE_Link_TF_MyMonsterCount];
         this.FTFFriendMonsterCount = _loc4_[CONST_HOME.RESOURCE_Link_TF_FriendMonsterCount];
         this.FTFCommunicateCount = _loc4_[CONST_HOME.RESOURCE_Link_TF_SpriteCommunicateCount];
         this.FTFMakeTofuCount = _loc4_[CONST_HOME.RESOURCE_Link_TF_MakeTofuCount];
         this.FTFCommunicateLable = _loc4_["CommunicateLable"];
         this.FTFMakeTofuLable = _loc4_["MakeTofuLable"];
         this.FSGirlFriend = _loc3_[CONST_HOME.RESOURCE_Link_MC_GirlFriend];
         this.FSP_GirlfriendInteractive = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_SP_GirlfriendInteractive];
         this.FSP_GirlfriendInteractive.mouseEnabled = false;
         this.FSP_GirlfriendInteractive.mouseChildren = false;
         this.FSP_GirlfriendUpgrade = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_SP_GirlfriendUpgrade];
         this.FSP_GirlfriendUpgrade.mouseEnabled = false;
         this.FSP_GirlfriendUpgrade.mouseChildren = false;
         this.FBtnGirlfriendInteractive_0 = new TUIButton();
         this.FBtnGirlfriendInteractive_0.Tag = TYPE_Interactive_1;
         this.FBtnGirlfriendInteractive_0.Substrate = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_Btn_GirlfriendInteractive_0];
         this.FBtnGirlfriendInteractive_0.OnClick = this.BtnGirlfriendInteractiveOnClick;
         this.FBtnGirlfriendInteractive_0.OnMove = this.ButtonOnMove;
         this.FBtnGirlfriendInteractive_0.OnOut = this.ButtonOnOut;
         this.FBtnGirlfriendInteractive_1 = new TUIButton();
         this.FBtnGirlfriendInteractive_1.Tag = TYPE_Interactive_2;
         this.FBtnGirlfriendInteractive_1.Substrate = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_Btn_GirlfriendInteractive_1];
         this.FBtnGirlfriendInteractive_1.OnClick = this.BtnGirlfriendInteractiveOnClick;
         this.FBtnGirlfriendInteractive_1.OnMove = this.ButtonOnMove;
         this.FBtnGirlfriendInteractive_1.OnOut = this.ButtonOnOut;
         this.FBtnGirlfriendInteractive_2 = new TUIButton();
         this.FBtnGirlfriendInteractive_2.Tag = TYPE_Interactive_3;
         this.FBtnGirlfriendInteractive_2.Substrate = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_Btn_GirlfriendInteractive_2];
         this.FBtnGirlfriendInteractive_2.OnClick = this.BtnGirlfriendInteractiveOnClick;
         this.FBtnGirlfriendInteractive_2.OnMove = this.ButtonOnMove;
         this.FBtnGirlfriendInteractive_2.OnOut = this.ButtonOnOut;
         this.FBtnGirlfriendInteractiveUpgrade = new TUIButton();
         this.FBtnGirlfriendInteractiveUpgrade.IsFilter = true;
         this.FBtnGirlfriendInteractiveUpgrade.Substrate = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_Btn_GirlfriendInteractive_Upgrade];
         this.FBtnGirlfriendInteractiveUpgrade.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_13);
         this.FBtnGirlfriendInteractiveUpgrade.OnClick = this.BtnGirlfriendInteractiveUpgradeOnClick;
         this.FBtnGirlfriendInteractiveUpgrade.OnMove = this.ButtonOnMove;
         this.FBtnGirlfriendInteractiveUpgrade.OnOut = this.ButtonOnOut;
         this.FMC_EffectGirlFriendPopTip = _loc3_[CONST_HOME.RESOURCE_Link_MC_EffectGirlFriendPopTip];
         this.FMC_EffectGirlFriendPopTip.mouseEnabled = false;
         this.FMC_EffectGirlFriendPopTip.mouseChildren = false;
         this.FMC_EffectGirlFriendPopTip.visible = false;
         this.FMC_EffectGirlFriendPopTip.stop();
         this.FMC_GirlFriendPopTip = this.FMC_EffectGirlFriendPopTip[CONST_HOME.RESOURCE_Link_MC_GirlFriendPopTip];
         this.FTF_GirlFriendPopTip = this.FMC_GirlFriendPopTip[CONST_HOME.RESOURCE_Link_TF_GirlFriendPopTip];
         this.FTF_GirlFriendPopTip.text = "";
         _loc4_ = this.FSGirlFriend[CONST_HOME.RESOURCE_Link_SP_GirlfriendAvatar];
         this.FSGirlfriendAvatar = _loc4_[CONST_HOME.RESOURCE_Link_SP_GirlfriendAvatar];
         this.FSGirlfriendAvatar.addChild(this.FBitmapGirlFriend);
         this.FMCPanelShortcuts = _loc3_[CONST_HOME.RESOURCE_Link_MC_PanelShortcuts];
         this.FBtnHomeHall = new TUIButton();
         this.FBtnHomeHall.Substrate = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_Btn_HomeHall];
         this.FBtnHomeHall.OnClick = this.BtnHomeHallOnClick;
         this.FBtnGirlfriend = new TUIButton();
         this.FBtnGirlfriend.Substrate = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_Btn_Girlfriend];
         this.FBtnGirlfriend.OnClick = this.BtnGirlfriendOnClick;
         _loc4_ = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_MC_HellButterfly];
         _loc4_.mouseEnabled = false;
         this.FBtnHellButterfly = new TUIButton();
         this.FBtnHellButterfly.Substrate = _loc4_[CONST_HOME.RESOURCE_Link_Btn_HellButterfly];
         this.FBtnHellButterfly.OnClick = this.BtnHellButterflyOnClick;
         this.FMC_HellButterflyEffect1 = this.FBtnHellButterfly.Substrate[CONST_HOME.RESOURCE_Link_MC_HellButterflyEffect1];
         this.FMC_HellButterflyEffect2 = this.FBtnHellButterfly.Substrate[CONST_HOME.RESOURCE_Link_MC_HellButterflyEffect2];
         this.FMC_HellButterflyEffect1.stop();
         this.FMC_HellButterflyEffect2.stop();
         this.FBtnSlave = new TUIButton();
         this.FBtnSlave.Substrate = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_Btn_Slave];
         this.FBtnSlave.OnClick = this.BtnSlaveOnClick;
         this.FBtnGamble = new TUIButton();
         this.FBtnGamble.Substrate = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_Btn_Gamble];
         this.FBtnGamble.OnClick = this.BtnGambleOnClick;
         _loc5_ = _loc3_[CONST_HOME.RESOURCE_Link_SP_Titles];
         _loc5_.mouseEnabled = false;
         _loc5_.mouseChildren = false;
         this.FMC_TitleSlave = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleSlave];
         this.FMC_TitleSlave.mouseEnabled = false;
         this.FMC_TitleSlave.mouseChildren = false;
         _loc4_ = this.FMC_TitleSlave[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleSlave);
         this.FMC_TitleLuckyCat = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleLuckyCat];
         this.FMC_TitleLuckyCat.mouseEnabled = false;
         this.FMC_TitleLuckyCat.mouseChildren = false;
         _loc4_ = this.FMC_TitleLuckyCat[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleLuckyCat);
         this.FMC_TitleMonster = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleMonster];
         this.FMC_TitleMonster.mouseEnabled = false;
         this.FMC_TitleMonster.mouseChildren = false;
         _loc4_ = this.FMC_TitleMonster[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleMonster);
         this.FMC_TitleHomeHall = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleHomeHall];
         this.FMC_TitleHomeHall.mouseEnabled = false;
         this.FMC_TitleHomeHall.mouseChildren = false;
         _loc4_ = this.FMC_TitleHomeHall[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleHomeHall);
         this.FMC_TitleGirlFriend = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleGirlFriend];
         this.FMC_TitleGirlFriend.mouseEnabled = false;
         this.FMC_TitleGirlFriend.mouseChildren = false;
         _loc4_ = this.FMC_TitleGirlFriend[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleGirlFriend);
         this.FMC_TitleGamble = _loc5_[CONST_HOME.RESOURCE_Link_MC_TitleGamble];
         this.FMC_TitleGamble.mouseEnabled = false;
         this.FMC_TitleGamble.mouseChildren = false;
         _loc4_ = this.FMC_TitleGamble[CONST_HOME.RESOURCE_Link_MC_Title];
         _loc4_.gotoAndStop(CONST_HOME.FRAME_TitleGamble);
         this.FMCFriend = _loc3_[CONST_HOME.RESOURCE_Link_MC_Friend];
         this.FBtnCloseFriend = new TUIButton();
         this.FBtnCloseFriend.Substrate = this.FMCFriend[CONST_HOME.RESOURCE_Link_Btn_CloseFriend];
         this.FBtnCloseFriend.OnClick = this.BtnCloseFriendOnClick;
         this.FBtnCloseFriend.Visible = false;
         this.FBtnOpenFriend = new TUIButton();
         this.FBtnOpenFriend.Substrate = this.FMCFriend[CONST_HOME.RESOURCE_Link_Btn_OpenFriend];
         this.FBtnOpenFriend.OnClick = this.BtnOpenFriendOnClick;
         this.FMCFriendList = _loc3_[CONST_HOME.RESOURCE_Link_MC_FriendList];
         this.FSFriendList = this.FMCFriendList[CONST_HOME.RESOURCE_Link_S_FriendList];
         _loc2_ = int(CAPACITY_MC_Items);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = new TItemFriend(this);
            _loc6_.Resource = this.FSFriendList[CONST_HOME.RESOURCE_Link_MC_Item + _loc1_];
            _loc6_.OnClick = this.BtnVisitOnClick;
            _loc6_.Context = null;
            _loc6_.Visible = false;
            this.FItemFriends[_loc1_] = _loc6_;
            _loc1_++;
         }
         this.FUIPageFriend = new TUIPage(this);
         _loc4_ = this.FSFriendList[CONST_HOME.RESOURCE_Link_MC_PageLeft];
         this.FUIPageFriend.ButtonPrevious.Substrate = _loc4_;
         _loc4_ = this.FSFriendList[CONST_HOME.RESOURCE_Link_MC_PageRight];
         this.FUIPageFriend.ButtonNext.Substrate = _loc4_;
         _loc7_ = this.FSFriendList[CONST_HOME.RESOURCE_Link_TF_Page];
         this.FUIPageFriend.LabelPage = _loc7_;
         _loc7_.text = "0/0";
         this.FUIPageFriend.PageSize = CAPACITY_MC_Items;
         this.FUIPageFriend.Init();
         this.FUIPageFriend.OnChangePage = this.PageOnChange;
         this.FUIWindowConfirmationClearCD = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowConfirmationInteractiveGirlFriend = new TUIWindowConfirmation(this.Parent);
         this.FUIWindowConfirmationInteractiveGirlFriend.OnOK = this.WindowConfirmationInteractiveGirlFriendOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationInteractiveGirlFriend);
         this.FUIWindowConfirmationInteractiveGirlFriend.SetCheckBoxUsable(true);
         this.FUIWindowConfirmationHomeSoul = SUtilityOverLayer.UIWindowConfirmation;
         this.FConfigValueBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FHomeGirlAwards = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlAward);
         this.FArticles = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FHomeGirlInteracts = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlInteract);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_HomeView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_HomeView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FTFInteractiveTitle.addEventListener(MouseEvent.MOUSE_MOVE,this.TFInteractiveTitleOnMove,false,0,true);
         this.FTFInteractiveTitle.addEventListener(MouseEvent.MOUSE_OUT,this.TFInteractiveTitleOnOut,false,0,true);
         this.FTFGirlfriendCount.addEventListener(MouseEvent.MOUSE_MOVE,this.TFOnMove,false,0,true);
         this.FTFGirlfriendCount.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FTFMyMonsterCount.addEventListener(MouseEvent.MOUSE_MOVE,this.TFOnMove,false,0,true);
         this.FTFMyMonsterCount.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FTFFriendMonsterCount.addEventListener(MouseEvent.MOUSE_MOVE,this.TFOnMove,false,0,true);
         this.FTFFriendMonsterCount.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FTFCommunicateCount.addEventListener(MouseEvent.MOUSE_MOVE,this.TFOnMove,false,0,true);
         this.FTFCommunicateCount.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FTFMakeTofuCount.addEventListener(MouseEvent.MOUSE_MOVE,this.TFOnMove,false,0,true);
         this.FTFMakeTofuCount.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FTFCommunicateLable.addEventListener(TextEvent.LINK,this.GirlFriendOnTextClick);
         this.FTFMakeTofuLable.addEventListener(TextEvent.LINK,this.GirlFriendOnTextClick);
         this.FMC_Monsters.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         this.FMC_Monsters.addEventListener(MouseEvent.MOUSE_MOVE,this.SpriteOnMove,false,0,true);
         this.FMC_Monsters.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FMC_Monsters.addEventListener(MouseEvent.MOUSE_OUT,this.SpriteOnOut,false,0,true);
         this.FMC_LuckyCat.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         this.FMC_LuckyCat.addEventListener(MouseEvent.MOUSE_MOVE,this.SpriteOnMove,false,0,true);
         this.FMC_LuckyCat.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FMC_LuckyCat.addEventListener(MouseEvent.MOUSE_OUT,this.SpriteOnOut,false,0,true);
         this.FFloatingIslandLeftPoint.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         this.FFloatingIslandLeftPoint.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FFloatingIslandLeftPoint.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         this.FFloatingIslandRightPoint.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         this.FFloatingIslandRightPoint.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FFloatingIslandRightPoint.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         this.FSGirlfriendAvatar.addEventListener(MouseEvent.CLICK,this.GirlfriendAvatarOnClick,false,0,true);
         this.FSGirlfriendAvatar.addEventListener(MouseEvent.MOUSE_MOVE,this.GirlfriendAvatarOnMove,false,0,true);
         this.FSGirlfriendAvatar.addEventListener(MouseEvent.MOUSE_OUT,this.GirlfriendAvatarOnOut,false,0,true);
         this.FTFCommunicateLable.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_37);
         this.FTFMakeTofuLable.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_38);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FInitialization)
         {
            if(this.Visible)
            {
               this.LogicsPerform_ShortcutsStatus();
               this.LogicsPerform_LuckyCatEffect();
               this.LogicsPerform_TitleEffect();
               this.LogicsPerform_UpdateLuckyCatCD();
               this.LogicsPerform_UpdateGirlFriendInteractiveCD();
               this.FUICredits.UpdateEffect();
            }
            this.LogicsPerform_FriendsEffect();
         }
      }
      
      protected function LogicsPerform_ShortcutsStatus() : void
      {
         var _loc1_:MovieClip = null;
         if(this.FMCPanelShortcuts.currentFrame == this.FMCPanelShortcuts.totalFrames - 1)
         {
            _loc1_ = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_MC_HellButterflyLight];
            _loc1_.mouseEnabled = false;
            _loc1_.mouseChildren = false;
            _loc1_ = this.FMCPanelShortcuts[CONST_HOME.RESOURCE_Link_MC_Titles];
            _loc1_.mouseEnabled = false;
            _loc1_.mouseChildren = false;
            this.FMC_HellButterflyEffect1.play();
            this.FMC_HellButterflyEffect2.play();
         }
      }
      
      protected function LogicsPerform_LuckyCatEffect() : void
      {
         if(this.FLuckyCatEffectCount <= 0)
         {
            return;
         }
         if(this.FMC_LuckyCat.currentFrame == 1)
         {
            if(this.FOnEffectSilverCoin != null)
            {
               this.FOnEffectSilverCoin(this,this.FLuckyCatCoordinate);
            }
            this.FMC_LuckyCat.play();
            this.FCursorHoveringLuckyCat = false;
            this.FCursorClickedLuckyCat = true;
         }
         if(this.FMC_LuckyCat.currentFrame == this.FMC_LuckyCat.totalFrames)
         {
            this.FMC_LuckyCat.gotoAndStop(1);
            --this.FLuckyCatEffectCount;
            this.FCursorClickedLuckyCat = false;
         }
         this.FSP_LuckyCatCursorHovering.visible = this.FCursorHoveringLuckyCat;
      }
      
      protected function LogicsPerform_TitleEffect() : void
      {
         if(this.FMC_Title == null)
         {
            return;
         }
         if(this.FMC_Title.currentFrame == FRAME_ShowEnd)
         {
            this.FMC_Title.gotoAndStop(FRAME_ShowEnd + 1);
         }
         if(this.FMC_Title.currentFrame == FRAME_HideEnd)
         {
            this.FMC_Title.gotoAndStop(FRAME_HideEnd + 1);
         }
      }
      
      protected function LogicsPerform_UpdateLuckyCatCD() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         _loc3_ = this.FTimeCoolDownLuckycat.TimingTime;
         _loc5_ = this.FHome.LuckyCatCDLimit;
         if(_loc3_ > 0)
         {
            _loc1_ = TUtilityTiming.fomatTime(_loc3_);
            if(this.FHome.LuckyCatCount >= this.FHome.LuckyCat.MaxLuckyCatCount)
            {
               _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_19);
            }
         }
         else if(_loc3_ == 0)
         {
            if(this.FHome.LuckyCatCount < this.FHome.LuckyCat.MaxLuckyCatCount)
            {
               _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_14);
            }
            else
            {
               _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_19);
            }
            this.FHome.LuckyCatCDLimit = false;
         }
         this.FTF_CDTime.text = _loc1_;
         _loc2_ = _loc5_ || this.FHome.LuckyCatCount >= this.FHome.LuckyCat.MaxLuckyCatCount;
         if(_loc2_)
         {
            _loc4_ = 16711680;
         }
         else
         {
            _loc4_ = 65280;
         }
         this.FTF_CDTime.textColor = _loc4_;
         _loc2_ = _loc5_ && this.FHome.LuckyCatCount < this.FHome.LuckyCat.MaxLuckyCatCount;
         if(this.FBtn_ClearCD.Enabled != _loc2_)
         {
            this.FBtn_ClearCD.Enabled = _loc2_;
            this.FBtn_ClearCD.Visible = _loc2_;
         }
      }
      
      protected function LogicsPerform_UpdateGirlFriendInteractiveCD() : void
      {
         var _loc1_:Boolean = false;
         if(this.FTimeCoolDownGirlFriendInteractive.TimingTime == 0)
         {
            if(this.FMC_EffectGirlFriendPopTip.visible)
            {
               this.FHome.GirlFriend.FriendTeaseType = 0;
               this.FMC_EffectGirlFriendPopTip.gotoAndStop(1);
               this.FMC_EffectGirlFriendPopTip.visible = false;
            }
         }
      }
      
      protected function LogicsPerform_FriendsEffect() : void
      {
         if(this.FMCFriendList.currentFrame != 1 && this.FMCFriendList.currentFrame != FRAME_OpenEnd + 1)
         {
            this.FMCFriend.x = this.FMCFriendList.x + this.FSFriendList.x - 27;
            this.FMCFriend.y = this.FMCFriendList.y - this.FSFriendList.y + 200;
         }
         if(this.FMCFriendList.currentFrame == FRAME_OpenEnd)
         {
            this.FMCFriendList.gotoAndStop(FRAME_OpenEnd + 1);
         }
         if(this.FMCFriendList.currentFrame == FRAME_CloseEnd)
         {
            this.FMCFriendList.gotoAndStop(1);
         }
      }
      
      protected function UpdateHome() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:THome = null;
         _loc1_ = this.IsMyHome();
         _loc2_ = this.GetHomeByType(this.FHomeType);
         this.FMC_FloatingIslandPoints.gotoAndStop(_loc2_.Level);
         this.FSP_FloatingIslandPoints = this.FMC_FloatingIslandPoints[CONST_HOME.RESOURCE_Link_SP_FloatingIslandPoints];
         this.FSP_FloatingIslandHomeHallPoint = this.FSP_FloatingIslandPoints[CONST_HOME.RESOURCE_Link_SP_FloatingIslandHomeHallPoint];
         this.FSP_FloatingIslandHomeHallPoint.buttonMode = _loc1_;
         this.FSP_FloatingIslandGirlFriendPoint = this.FSP_FloatingIslandPoints[CONST_HOME.RESOURCE_Link_SP_FloatingIslandGirlFriendPoint];
         this.FSP_FloatingIslandGirlFriendPoint.buttonMode = _loc1_;
         this.FFloatingIslandLeftPoint.buttonMode = _loc1_;
         this.FFloatingIslandRightPoint.buttonMode = _loc1_;
         if(!this.FSP_FloatingIslandHomeHallPoint.hasEventListener(MouseEvent.CLICK))
         {
            this.FSP_FloatingIslandHomeHallPoint.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         }
         if(!this.FSP_FloatingIslandHomeHallPoint.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.FSP_FloatingIslandHomeHallPoint.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         }
         if(!this.FSP_FloatingIslandHomeHallPoint.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this.FSP_FloatingIslandHomeHallPoint.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         }
         if(!this.FSP_FloatingIslandGirlFriendPoint.hasEventListener(MouseEvent.CLICK))
         {
            this.FSP_FloatingIslandGirlFriendPoint.addEventListener(MouseEvent.CLICK,this.TitleOnClick,false,0,true);
         }
         if(!this.FSP_FloatingIslandGirlFriendPoint.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.FSP_FloatingIslandGirlFriendPoint.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         }
         if(!this.FSP_FloatingIslandGirlFriendPoint.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this.FSP_FloatingIslandGirlFriendPoint.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         }
         this.FMC_HomeEffect.play();
      }
      
      protected function UpdatePanelCharacter() : void
      {
         var _loc1_:String = null;
         var _loc2_:TFriendDigest = null;
         var _loc3_:THome = null;
         _loc3_ = this.GetHomeByType(this.FHomeType);
         _loc1_ = "";
         this.FBtnInteractiveLog.Visible = false;
         this.FBtnReturnHome.Visible = false;
         this.FBtnGirlfriendInteractiveUpgrade.Enabled = false;
         if(_loc3_.Identifier0 == this.FCharacter.Identifier0 && _loc3_.Identifier1 == this.FCharacter.Identifier1)
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_02);
            this.FSP_HomeTag.visible = false;
            this.FBtnInteractiveLog.Visible = true;
            this.FBtnGirlfriendInteractiveUpgrade.Enabled = true;
         }
         else if(_loc3_.Identifier0 != 0 && _loc3_.Identifier1 != 0)
         {
            _loc2_ = this.FFriendsFilter.GetDigestByIdentifier(_loc3_.Identifier0,_loc3_.Identifier1);
            if(_loc2_ == null)
            {
               _loc1_ = "...";
            }
            else
            {
               _loc1_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_01),_loc2_.Name);
            }
            this.FTF_HomeTag.text = _loc1_;
            this.FSP_HomeTag.visible = true;
            this.FBtnReturnHome.Visible = true;
         }
         this.FTFCaption.text = _loc1_;
         this.FTFLevelTitle.text = _loc3_.Name;
         this.FTFLevelTitle.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Level + 1];
      }
      
      protected function UpdatePanelInteractive() : void
      {
         this.FTFGirlfriendCount.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.GirlFriend.CurrentTeaseTime,this.FHome.MaxGirlfriendInteractiveCount);
         this.FTFMyMonsterCount.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.MyMonsterCount,this.FHome.MaxMyMonsterCount);
         this.FTFFriendMonsterCount.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.FriendMonsterCount,this.FHome.MaxFriendMonsterCount);
         this.FTFCommunicateCount.htmlText = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.GirlFriend.CurrentSpriteCommunicateTime,this.FHome.GirlFriend.CanCommunicateTime);
         this.FTFMakeTofuCount.htmlText = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.GirlFriend.CurrentCostMakeTofuTime,this.FHome.GirlFriend.CanMakeTofuTime);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FHomeGirlFriendID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(this.FMountPointsRolePivot,this.FMountPointsRoleBounds);
               this.FBitmapGirlFriend.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmapGirlFriend.x = this.FMountPointsRoleBounds.X;
               this.FBitmapGirlFriend.y = this.FMountPointsRoleBounds.Y;
               this.FGirlfriendAvatarCoordinate = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FSGirlfriendAvatar);
               break;
            case this.FHomeSubstrateID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBitmapSubstrate.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               break;
            case this.FHomeFloatingIslandLeftID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(this.FMountPointsRolePivot,this.FMountPointsRoleBounds);
               this.FBitmapFloatingIslandLeft.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmapFloatingIslandLeft.x = this.FMountPointsRoleBounds.X;
               this.FBitmapFloatingIslandLeft.y = this.FMountPointsRoleBounds.Y;
               break;
            case this.FHomeFloatingIslandRightID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(this.FMountPointsRolePivot,this.FMountPointsRoleBounds);
               this.FBitmapFloatingIslandRight.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmapFloatingIslandRight.x = this.FMountPointsRoleBounds.X;
               this.FBitmapFloatingIslandRight.y = this.FMountPointsRoleBounds.Y;
         }
      }
      
      protected function LoadHomeSubstrate() : void
      {
         var _loc1_:THome = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         this.FHomeSubstrateID = _loc1_.MainImgID;
         this.FHomeFloatingIslandLeftID = _loc1_.FloatingIslandPointLeftID;
         this.FHomeFloatingIslandRightID = _loc1_.FloatingIslandPointRightID;
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FHomeSubstrateID,this.AutoLoadCallBack);
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FHomeFloatingIslandLeftID,this.AutoLoadCallBack);
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FHomeFloatingIslandRightID,this.AutoLoadCallBack);
      }
      
      protected function UpdateGirlFriendData() : void
      {
         var _loc1_:THome = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         if(_loc1_.Identifier0 == this.FCharacter.Identifier0 && _loc1_.Identifier1 == this.FCharacter.Identifier1)
         {
            if(_loc1_.GirlFriend.CurrentChangeShapeGirlID != 0)
            {
               _loc1_.ChangeShapeGirlID = _loc1_.GirlFriend.CurrentChangeShapeGirlID;
               _loc1_.ChangeShapeGirlImageID = _loc1_.GirlFriend.CurrentChangeShapeGirlImageID;
            }
            if(_loc1_.InteractiveScore != _loc1_.GirlFriend.TeaseScore)
            {
               _loc1_.InteractiveScore = _loc1_.GirlFriend.TeaseScore;
            }
         }
      }
      
      protected function LoadGirlFriendImage() : void
      {
         var _loc1_:THome = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         this.FHomeGirlFriendID = _loc1_.ChangeShapeGirlImageID;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FHomeGirlFriendID,this.AutoLoadCallBack);
      }
      
      protected function UpdateGirlFriendUI() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:THome = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:THomeGirlInteract = null;
         _loc5_ = "";
         this.FMC_EffectGirlFriendPopTip.gotoAndStop(1);
         this.FMC_EffectGirlFriendPopTip.visible = false;
         _loc3_ = this.GetHomeByType(this.FHomeType);
         if(_loc3_.Identifier0 == this.FCharacter.Identifier0 && _loc3_.Identifier1 == this.FCharacter.Identifier1)
         {
            _loc3_.InteractiveScore = this.FHome.GirlFriend.TeaseScore;
            _loc4_ = uint(_loc3_.GirlFriend.FriendTeaseType);
            switch(_loc4_)
            {
               case TYPE_Interactive_1:
                  _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_27);
                  break;
               case TYPE_Interactive_2:
                  _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_28);
                  break;
               case TYPE_Interactive_3:
                  _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_29);
            }
            if(!TUtilityString.Empty(_loc5_))
            {
               _loc6_ = _loc3_.GirlFriend.FriendTeaseTime + TIME_InteractiveTeaseTime;
               this.FTimeCoolDownGirlFriendInteractive.TimingTime = _loc6_ - STimingCore.ServerTick;
               this.FTF_GirlFriendPopTip.text = _loc5_;
               this.FMC_EffectGirlFriendPopTip.play();
               this.FMC_EffectGirlFriendPopTip.visible = true;
            }
         }
         _loc2_ = this.FHomeGirlInteracts.Count;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            _loc7_ = this.FHomeGirlInteracts.GetDatebaseByIndex(_loc1_) as THomeGirlInteract;
            if(_loc3_.InteractiveScore >= _loc7_.ScoreBlank)
            {
               _loc3_.InteractiveQuality = _loc7_.TitleColor;
               _loc3_.InteractiveTitle = _loc7_.NameTitle;
               break;
            }
            _loc1_--;
         }
         this.FTFInteractiveTitle.text = _loc3_.InteractiveTitle;
         this.FTFInteractiveTitle.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.InteractiveQuality];
      }
      
      protected function SetGirlFriendInteractive(param1:Boolean) : void
      {
         this.FSP_GirlfriendInteractive.visible = param1;
         this.FBtnGirlfriendInteractive_0.Visible = param1;
         this.FBtnGirlfriendInteractive_1.Visible = param1;
         this.FBtnGirlfriendInteractive_2.Visible = param1;
      }
      
      protected function SetGirlFriendUpgrade(param1:Boolean) : void
      {
         this.FSP_GirlfriendUpgrade.visible = param1;
         this.FBtnGirlfriendInteractiveUpgrade.Visible = param1;
      }
      
      protected function UpdateMonsterUI() : void
      {
         var _loc1_:THome = null;
         var _loc2_:String = null;
         var _loc3_:TEnemyArmy = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         if(_loc1_.Identifier0 == this.FCharacter.Identifier0 && _loc1_.Identifier1 == this.FCharacter.Identifier1)
         {
            this.FTF_MonsterQuantity.visible = false;
         }
         else
         {
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_22),_loc1_.MaxMyMonsterBeBeatenCount - _loc1_.MyMonsterBeBeatenCount);
            this.FTF_MonsterQuantity.text = _loc2_;
            this.FTF_MonsterQuantity.visible = true;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc1_.HomeSoul.MonsterID) as TEnemyArmy;
         this.FTF_MonsterName.text = _loc3_.Name;
         this.FTF_MonsterName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc1_.QualityMonster];
         this.FMC_Monsters.gotoAndStop(_loc1_.Level);
         if(this.FMC_Monster != null)
         {
            this.FMC_Monster.stop();
         }
         this.FMC_Monster = this.FMC_Monsters[CONST_HOME.RESOURCE_Link_MC_Monster];
         this.FMC_Monster.mouseEnabled = false;
         this.FMC_Monster.mouseChildren = false;
         this.FMC_Monster.play();
         this.FMC_EffectMonster.play();
      }
      
      protected function UpdateLuckyCatUI() : void
      {
         if(this.FHomeType == CONST_HOME.TYPE_HOME_MySelf)
         {
            this.FTimeCoolDownLuckycat.TimingTime = this.FHome.LuckyCatCD;
            this.FTF_Count.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FHome.LuckyCatCount,this.FHome.LuckyCat.MaxLuckyCatCount);
            this.FMC_LuckyCats.gotoAndStop(this.FHome.Level);
            this.FMC_LuckyCat.buttonMode = true;
            this.FSP_LuckyCatPopTip.visible = true;
         }
         else
         {
            this.FMC_LuckyCats.gotoAndStop(this.FHomeFriend.Level);
            this.FMC_LuckyCat.buttonMode = false;
            this.FSP_LuckyCatPopTip.visible = false;
         }
      }
      
      protected function UpdateFriendDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFriendDigest = null;
         this.FFriendsFilter.Clear();
         _loc2_ = this.FFriendDigests.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FFriendDigests.GetDigestByIndex(_loc1_);
            if(_loc3_.Type == TFriendDigest.TYPE_White)
            {
               this.FFriendsFilter.Add(_loc3_);
            }
            _loc1_++;
         }
         this.FFriendsFilter.SortLevel();
      }
      
      protected function UpdateFriendUIPage() : void
      {
         var _loc1_:Boolean = false;
         this.FPageIndex = 0;
         this.FUIPageFriend.TotalQuantity = this.FFriendsFilter.Count;
         this.FUIPageFriend.PageIndex = this.FPageIndex;
         this.FUIPageFriend.Update();
      }
      
      protected function UpdateUIFriends() : void
      {
         var _loc1_:THome = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         if(_loc1_.Identifier0 == this.FCharacter.Identifier0 && _loc1_.Identifier1 == this.FCharacter.Identifier1)
         {
            if(this.FBtnCloseFriend.Visible)
            {
               this.BtnCloseFriendOnClick(this,null);
            }
         }
      }
      
      protected function UpdatePanelFriends(param1:TFriendDigests) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TItemFriend = null;
         var _loc7_:TFriendDigest = null;
         _loc5_ = this.FPageIndex;
         _loc3_ = int(CAPACITY_MC_Items);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FItemFriends[_loc2_];
            _loc6_.Context = null;
            _loc6_.Resource.visible = false;
            _loc2_++;
         }
         _loc3_ = param1.Count;
         if(_loc3_ <= 0)
         {
            return;
         }
         _loc4_ = _loc5_ * CAPACITY_MC_Items;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_MC_Items)
         {
            if(_loc2_ + _loc4_ >= _loc3_)
            {
               break;
            }
            _loc6_ = this.FItemFriends[_loc2_];
            _loc7_ = param1.GetDigestByIndex(_loc2_ + _loc4_);
            _loc6_.Context = _loc7_;
            _loc6_.Resource.visible = true;
            _loc2_++;
         }
      }
      
      protected function PlayPanelShortcuts() : void
      {
         var _loc1_:THome = null;
         _loc1_ = this.GetHomeByType(this.FHomeType);
         if(_loc1_.Identifier0 == this.FCharacter.Identifier0 && _loc1_.Identifier1 == this.FCharacter.Identifier1)
         {
            this.FMCPanelShortcuts.play();
         }
         else
         {
            this.FMCPanelShortcuts.gotoAndStop(1);
         }
      }
      
      protected function ProcessorInteractiveGirlFriendReq(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:THome = null;
         var _loc6_:TPacket = null;
         _loc5_ = this.GetHomeByType(this.FHomeType);
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendTeaseReq);
         _loc6_.Data.writeByte(param1);
         _loc6_.Data.writeUnsignedInt(_loc5_.Identifier0);
         _loc6_.Data.writeUnsignedInt(_loc5_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
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
         this.FBtns.x = _loc1_ - this.FBtns.width;
         this.FBtn_Return.X = _loc1_ - this.FBtn_Return.Width - 4;
         this.FBtn_Return.Y = _loc2_ - this.FBtn_Return.Height - 4;
         this.FSGirlFriend.x = _loc1_ - this.FSGirlFriend.width + 50;
         this.FMCPanelShortcuts.y = _loc2_ - this.FMCPanelShortcuts.height + 2;
         this.FMCFriendList.x = _loc1_ - 15;
         this.FMCFriendList.y = _loc2_ - this.FMCFriendList.height - 48;
         this.FMCFriend.x = this.FMCFriendList.x + this.FSFriendList.x - 27;
         this.FMCFriend.y = this.FMCFriendList.y - this.FSFriendList.y + 200;
      }
      
      protected function IsMyHome() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:THome = null;
         _loc2_ = this.GetHomeByType(this.FHomeType);
         if(_loc2_.Identifier0 == this.FCharacter.Identifier0 && _loc2_.Identifier1 == this.FCharacter.Identifier1)
         {
            _loc1_ = true;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      protected function GetHomeByType(param1:uint) : THome
      {
         var _loc2_:THome = null;
         switch(param1)
         {
            case CONST_HOME.TYPE_HOME_MySelf:
               _loc2_ = this.FHome;
               break;
            default:
               _loc2_ = this.FHomeFriend;
         }
         return _loc2_;
      }
      
      protected function IsCanInteractive(param1:uint, param2:uint) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:THomeGirlAward = null;
         _loc5_ = true;
         _loc6_ = "";
         _loc8_ = "";
         _loc4_ = this.FHomeGirlAwards.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = this.FHomeGirlAwards.GetDatebaseByIndex(_loc3_) as THomeGirlAward;
            if(param1 == _loc10_.InteractiveType && param2 == _loc10_.TitleLevel)
            {
               _loc8_ = TUtilityLobby.GetItemName(_loc10_.InteractiveCost.Type,_loc10_.InteractiveCost.Code);
               break;
            }
            _loc3_++;
         }
         if(_loc10_.InteractiveCost.Code == 0)
         {
            if(this.FCharacter.CreditSilverCoin.ToNumber() < _loc10_.InteractiveCost.Amount)
            {
               _loc5_ = false;
            }
         }
         else if(_loc10_.InteractiveCost.Code == 1)
         {
            if(this.FCharacter.CreditGold < _loc10_.InteractiveCost.Amount)
            {
               _loc5_ = false;
            }
         }
         if(!_loc5_)
         {
            _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_26),_loc8_);
         }
         return _loc6_;
      }
      
      protected function GetInteractiveDesc(param1:uint, param2:uint) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:TArticle = null;
         var _loc11_:THomeGirlAward = null;
         _loc5_ = "";
         _loc6_ = "";
         _loc7_ = "";
         _loc4_ = this.FHomeGirlAwards.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc11_ = this.FHomeGirlAwards.GetDatebaseByIndex(_loc3_) as THomeGirlAward;
            if(param1 == _loc11_.InteractiveType && param2 == _loc11_.TitleLevel)
            {
               _loc6_ = TUtilityLobby.GetItemName(_loc11_.InteractiveCost.Type,_loc11_.InteractiveCost.Code);
               _loc9_ = _loc11_.InteractiveAward.Amount;
               _loc7_ = _loc11_.InteractiveCost.Amount.toString();
               _loc10_ = this.FArticles.GetDatebaseByIdentifier(_loc11_.InteractiveAward.Code) as TArticle;
               _loc8_ = _loc10_.Name;
               break;
            }
            _loc3_++;
         }
         switch(param1)
         {
            case TYPE_Interactive_1:
               _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_10),_loc7_,_loc6_,_loc9_,_loc8_);
               break;
            case TYPE_Interactive_2:
               _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_11),_loc7_,_loc6_,_loc9_,_loc8_);
               break;
            case TYPE_Interactive_3:
               _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_12),_loc7_,_loc6_,_loc9_,_loc8_);
         }
         return _loc5_;
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonReturnOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonClearCDOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:uint = 0;
         _loc3_ = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_CONFIGVALUE.LUCKYCAT_CLEARGOLD) as TConfigValue;
         _loc4_ = _loc3_.Value.value * Math.ceil(this.FTimeCoolDownLuckycat.TimingTime / 60);
         this.FUIWindowConfirmationClearCD.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_16),_loc4_);
         this.FUIWindowConfirmationClearCD.OnOK = this.WindowConfirmationClearCDOnOK;
         this.FUIWindowConfirmationClearCD.Visible = true;
      }
      
      protected function WindowConfirmationClearCDOnOK(param1:Object) : void
      {
         if(this.FOnClearCD != null)
         {
            this.FOnClearCD(this);
         }
      }
      
      protected function WindowConfirmationInteractiveGirlFriendOnOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THome = null;
         _loc3_ = this.GetHomeByType(this.FHomeType);
         _loc2_ = this.FUIWindowConfirmationInteractiveGirlFriend.Tag;
         this.ProcessorInteractiveGirlFriendReq(_loc2_,_loc3_.Identifier0,_loc3_.Identifier1);
      }
      
      protected function WindowCofirmationHomeSoulOk(param1:Object) : void
      {
         if(this.FCharacter.CreditGold < this.FAKeyMonsterCost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_11));
            }
            return;
         }
         if(this.FOnMonster != null)
         {
            this.FOnMonster(this,CONST_HOME.TYPE_AKeyMonster);
         }
      }
      
      protected function ButtonOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:TUIButton = null;
         var _loc5_:THint = null;
         var _loc6_:int = 0;
         _loc3_ = this.IsMyHome();
         _loc4_ = param1 as TUIButton;
         _loc5_ = _loc4_.Hint;
         switch(_loc4_)
         {
            case this.FBtnGirlfriendInteractive_0:
               _loc6_ = int(TYPE_Interactive_1);
               break;
            case this.FBtnGirlfriendInteractive_1:
               _loc6_ = int(TYPE_Interactive_2);
               break;
            case this.FBtnGirlfriendInteractive_2:
               _loc6_ = int(TYPE_Interactive_3);
               break;
            case this.FBtnGirlfriendInteractiveUpgrade:
               if(!_loc3_)
               {
                  return;
               }
         }
         if(TUtilityString.Empty(_loc5_.Caption) && _loc6_ != 0)
         {
            _loc5_.Caption = this.GetInteractiveDesc(_loc6_,this.FHome.GirlFriend.TitleQuality);
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,_loc4_.Hint);
         }
      }
      
      protected function ButtonOnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,_loc3_.Hint);
            _loc3_.Hint.Caption = "";
         }
      }
      
      protected function TFOnMove(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         _loc2_ = param1.currentTarget as TextField;
         switch(_loc2_)
         {
            case this.FTFGirlfriendCount:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_07);
               break;
            case this.FTFMyMonsterCount:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_08);
               break;
            case this.FTFFriendMonsterCount:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_09);
               break;
            case this.FTFCommunicateCount:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_35);
               break;
            case this.FTFMakeTofuCount:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_36);
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHint);
         }
      }
      
      protected function TFOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHint);
         }
      }
      
      protected function BtnInteractiveLogOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnInteractionLog != null)
         {
            this.FOnInteractionLog(this);
         }
      }
      
      protected function BtnReturnHomeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnVisit != null)
         {
            this.FOnVisit(this,this.FCharacter.Identifier0,this.FCharacter.Identifier1);
         }
      }
      
      protected function BtnAKeyMonsterOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TConfigValue = null;
         var _loc5_:int = 0;
         if(this.FHome.MyMonsterCount >= this.FHome.MaxMyMonsterCount && this.FHome.FriendMonsterCount >= this.FHome.MaxFriendMonsterCount)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_20));
            }
            return;
         }
         _loc3_ = this.FHome.MaxMyMonsterCount - this.FHome.MyMonsterCount + (this.FHome.MaxFriendMonsterCount - this.FHome.FriendMonsterCount);
         _loc4_ = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_HOME.ONE_KEY_SOUL) as TConfigValue;
         _loc5_ = int(_loc4_.Value.value);
         this.FAKeyMonsterCost = _loc5_ * _loc3_;
         this.FUIWindowConfirmationHomeSoul.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_30),this.FAKeyMonsterCost);
         this.FUIWindowConfirmationHomeSoul.OnOK = this.WindowCofirmationHomeSoulOk;
         this.FUIWindowConfirmationHomeSoul.Visible = true;
      }
      
      public function BtnGirlfriendInteractiveOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:THome = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_DallianceGirl);
         _loc4_ = "";
         _loc6_ = this.GetHomeByType(this.FHomeType);
         if(_loc6_.Identifier0 == this.FCharacter.Identifier0 && _loc6_.Identifier1 == this.FCharacter.Identifier1)
         {
            if(this.FHome.GirlFriend.MyTeaseTime >= this.FHome.MaxMyGirlfriendInteractive)
            {
               _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_31);
            }
         }
         else if(this.FHome.GirlFriend.CurrentTeaseTime >= this.FHome.MaxGirlfriendInteractiveCount)
         {
            _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_25);
         }
         if(!TUtilityString.Empty(_loc4_))
         {
            EffectGenerateText(_loc4_);
            return;
         }
         _loc4_ = "";
         _loc3_ = (param1 as TUIButton).Tag;
         _loc4_ = this.IsCanInteractive(_loc3_,this.FHome.GirlFriend.TitleQuality);
         if(!TUtilityString.Empty(_loc4_))
         {
            EffectGenerateText(_loc4_);
            return;
         }
         if(_loc3_ != TYPE_Interactive_1 && !this.FUIWindowConfirmationInteractiveGirlFriend.IsSelected)
         {
            _loc5_ = this.GetInteractiveDesc(_loc3_,this.FHome.GirlFriend.TitleQuality);
            this.FUIWindowConfirmationInteractiveGirlFriend.Tag = _loc3_;
            this.FUIWindowConfirmationInteractiveGirlFriend.Text = _loc5_;
            this.FUIWindowConfirmationInteractiveGirlFriend.Visible = true;
         }
         else
         {
            this.ProcessorInteractiveGirlFriendReq(_loc3_,_loc6_.Identifier0,_loc6_.Identifier1);
         }
         this.FGirlfriendInteractiveIndex = _loc3_;
      }
      
      public function BtnGirlfriendInteractiveUpgradeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClickUpgradeGirlFriend != null)
         {
            this.FOnClickUpgradeGirlFriend(this);
         }
      }
      
      protected function BtnHomeHallOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHomeHall != null)
         {
            this.FOnHomeHall(this);
         }
      }
      
      protected function BtnGirlfriendOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClickOpenGirlFriend != null)
         {
            this.FOnClickOpenGirlFriend(this);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGirlBtn);
      }
      
      protected function BtnHellButterflyOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
      }
      
      protected function BtnSlaveOnClick(param1:Object, param2:MouseEvent) : void
      {
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickSlaveView);
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Slave);
      }
      
      protected function TitleOnClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Sprite = null;
         _loc2_ = this.IsMyHome();
         if(param1.currentTarget is Sprite)
         {
            _loc3_ = param1.currentTarget as Sprite;
            switch(_loc3_)
            {
               case this.FFloatingIslandLeftPoint:
                  if(_loc2_)
                  {
                     this.BtnGambleOnClick(null,null);
                  }
                  break;
               case this.FFloatingIslandRightPoint:
                  if(_loc2_)
                  {
                     this.BtnSlaveOnClick(null,null);
                  }
                  break;
               case this.FSP_FloatingIslandHomeHallPoint:
                  if(_loc2_)
                  {
                     this.BtnHomeHallOnClick(null,null);
                  }
                  break;
               case this.FSP_FloatingIslandGirlFriendPoint:
                  if(_loc2_)
                  {
                     this.BtnGirlfriendOnClick(null,null);
                  }
                  break;
               case this.FMC_LuckyCat:
                  if(_loc2_)
                  {
                     this.MC_LuckyCatOnClick(param1);
                  }
                  break;
               case this.FMC_Monsters:
                  this.MC_MonsterOnClick(param1);
            }
         }
      }
      
      protected function TitleOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Sprite = null;
         _loc2_ = this.IsMyHome();
         if(this.FMC_Title != null)
         {
            this.FMC_Title.gotoAndStop(1);
            this.FMC_Title = null;
         }
         if(param1.currentTarget is Sprite)
         {
            _loc3_ = param1.currentTarget as Sprite;
            switch(_loc3_)
            {
               case this.FFloatingIslandLeftPoint:
                  if(_loc2_)
                  {
                     this.FMC_Title = this.FMC_TitleGamble;
                  }
                  break;
               case this.FFloatingIslandRightPoint:
                  if(_loc2_)
                  {
                     this.FMC_Title = this.FMC_TitleSlave;
                  }
                  break;
               case this.FSP_FloatingIslandHomeHallPoint:
                  if(_loc2_)
                  {
                     this.FMC_Title = this.FMC_TitleHomeHall;
                  }
                  break;
               case this.FSP_FloatingIslandGirlFriendPoint:
                  if(_loc2_)
                  {
                     this.FMC_Title = this.FMC_TitleGirlFriend;
                  }
                  break;
               case this.FMC_LuckyCat:
                  if(_loc2_)
                  {
                     if(!this.FCursorClickedLuckyCat)
                     {
                        this.FCursorHoveringLuckyCat = true;
                     }
                     this.FSP_LuckyCatCursorHovering.visible = true;
                  }
                  break;
               case this.FMC_Monsters:
                  this.FCursorHoveringMonster = true;
                  FUICore.MouseCaptureSet(this);
            }
            if(this.FMC_Title != null)
            {
               this.FMC_Title.gotoAndStop(1);
               this.FMC_Title.play();
            }
         }
      }
      
      protected function TitleOnOut(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Boolean = false;
         _loc3_ = this.IsMyHome();
         if(param1.currentTarget is Sprite)
         {
            _loc2_ = param1.currentTarget as Sprite;
            switch(_loc2_)
            {
               case this.FFloatingIslandLeftPoint:
                  if(_loc3_)
                  {
                     this.FMC_Title = this.FMC_TitleGamble;
                  }
                  break;
               case this.FFloatingIslandRightPoint:
                  if(_loc3_)
                  {
                     this.FMC_Title = this.FMC_TitleSlave;
                  }
                  break;
               case this.FSP_FloatingIslandHomeHallPoint:
                  if(_loc3_)
                  {
                     this.FMC_Title = this.FMC_TitleHomeHall;
                  }
                  break;
               case this.FSP_FloatingIslandGirlFriendPoint:
                  if(_loc3_)
                  {
                     this.FMC_Title = this.FMC_TitleGirlFriend;
                  }
                  break;
               case this.FMC_LuckyCat:
                  if(_loc3_)
                  {
                     this.FCursorHoveringLuckyCat = false;
                     this.FSP_LuckyCatCursorHovering.visible = false;
                  }
                  break;
               case this.FMC_Monsters:
                  this.FCursorHoveringMonster = false;
                  FUICore.MouseCaptureRelease(this);
            }
            if(this.FMC_Title != null)
            {
               this.FMC_Title.gotoAndStop(FRAME_ShowEnd + 1);
               this.FMC_Title.play();
            }
         }
      }
      
      protected function BtnGambleOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Gamble);
      }
      
      protected function BtnCloseFriendOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnCloseFriend.Visible = false;
         this.FBtnOpenFriend.Visible = true;
         this.FMCFriendList.play();
      }
      
      protected function BtnOpenFriendOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnCloseFriend.Visible = true;
         this.FBtnOpenFriend.Visible = false;
         this.FMCFriendList.gotoAndStop(1);
         this.FMCFriendList.play();
      }
      
      protected function BtnVisitOnClick(param1:Object, param2:TFriendDigest) : void
      {
         var _loc3_:String = null;
         var _loc4_:THome = null;
         _loc4_ = this.GetHomeByType(this.FHomeType);
         if(_loc4_.Identifier0 == param2.Identifier0 && _loc4_.Identifier1 == param2.Identifier1)
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_03),param2.Name);
            EffectGenerateText(_loc3_);
            return;
         }
         if(this.FOnVisit != null)
         {
            this.FOnVisit(this,param2.Identifier0,param2.Identifier1);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePanelFriends(this.FFriendsFilter);
      }
      
      protected function MC_MonsterOnClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickMonster);
         _loc2_ = this.IsMyHome();
         if(_loc2_)
         {
            if(this.FHome.MyMonsterCount >= this.FHome.MaxMyMonsterCount)
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_20));
               }
               return;
            }
         }
         else if(this.FHome.FriendMonsterCount >= this.FHome.MaxFriendMonsterCount)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_20));
            }
            return;
         }
         if(this.FOnMonster != null)
         {
            this.FOnMonster(this,CONST_HOME.TYPE_SingleMonster);
         }
      }
      
      protected function MC_LuckyCatOnClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         _loc2_ = this.IsMyHome();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickMoneyCat);
         if(!_loc2_)
         {
            return;
         }
         if(this.FHome.LuckyCatCDLimit)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_15));
            return;
         }
         if(this.FHome.LuckyCatCount >= this.FHome.LuckyCat.MaxLuckyCatCount)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_24));
            return;
         }
         if(this.FOverlayOnOut != null)
         {
            this.FOverlayOnOut(this,this.FHome.LuckyCat);
         }
         if(this.FOnLuckyCat != null)
         {
            this.FOnLuckyCat(this);
         }
      }
      
      protected function TFInteractiveTitleOnMove(param1:MouseEvent) : void
      {
         var _loc2_:THome = null;
         _loc2_ = this.GetHomeByType(this.FHomeType);
         if(this.FOverlayOnMove != null)
         {
            this.FOverlayOnMove(this,_loc2_);
         }
      }
      
      protected function TFInteractiveTitleOnOut(param1:MouseEvent) : void
      {
         var _loc2_:THome = null;
         _loc2_ = this.GetHomeByType(this.FHomeType);
         if(this.FOverlayOnOut != null)
         {
            this.FOverlayOnOut(this,_loc2_);
         }
      }
      
      protected function SpriteOnMove(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:THome = null;
         _loc2_ = this.IsMyHome();
         _loc5_ = this.GetHomeByType(this.FHomeType);
         _loc3_ = param1.currentTarget as MovieClip;
         switch(_loc3_)
         {
            case this.FMC_Monsters:
               _loc4_ = _loc5_.HomeSoul;
               break;
            case this.FMC_LuckyCat:
               if(!_loc2_)
               {
                  return;
               }
               this.FCursorHoveringLuckyCat = true;
               _loc4_ = this.FHome.LuckyCat;
         }
         if(this.FOverlayOnMove != null)
         {
            this.FOverlayOnMove(this,_loc4_);
         }
      }
      
      protected function SpriteOnOut(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:THome = null;
         _loc2_ = this.IsMyHome();
         _loc5_ = this.GetHomeByType(this.FHomeType);
         _loc3_ = param1.currentTarget as MovieClip;
         switch(_loc3_)
         {
            case this.FMC_Monsters:
               _loc4_ = _loc5_.HomeSoul;
               break;
            case this.FMC_LuckyCat:
               if(!_loc2_)
               {
                  return;
               }
               _loc4_ = this.FHome.LuckyCat;
         }
         if(this.FOverlayOnOut != null)
         {
            this.FOverlayOnOut(this,_loc4_);
         }
         this.TitleOnOut(param1);
      }
      
      protected function GirlfriendAvatarOnClick(param1:MouseEvent) : void
      {
         var _loc2_:THome = null;
         var _loc3_:Boolean = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGirlBigPic);
         if(!this.FSGirlfriendAvatar.buttonMode)
         {
            return;
         }
         _loc2_ = this.GetHomeByType(this.FHomeType);
         _loc3_ = !this.FSP_GirlfriendInteractive.visible;
         if(_loc2_.Identifier0 == this.FCharacter.Identifier0 && _loc2_.Identifier1 == this.FCharacter.Identifier1)
         {
            this.SetGirlFriendInteractive(_loc3_);
            this.SetGirlFriendUpgrade(_loc3_);
         }
         else
         {
            this.SetGirlFriendInteractive(_loc3_);
         }
      }
      
      protected function GirlfriendAvatarOnMove(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = TUtilityBitmap.IsMouseOnNoAlphaPixel(this.FBitmapGirlFriend.bitmapData,FUICore.MouseCoordinate.X - this.FGirlfriendAvatarCoordinate.X,FUICore.MouseCoordinate.Y - this.FGirlfriendAvatarCoordinate.Y);
         if(_loc2_ != this.FLastIsAlpah)
         {
            if(_loc2_)
            {
               this.FSGirlfriendAvatar.filters = [this.FGlowFilter];
            }
            else
            {
               this.FSGirlfriendAvatar.filters = [];
            }
         }
         if(this.FSGirlfriendAvatar.buttonMode != _loc2_)
         {
            this.FSGirlfriendAvatar.buttonMode = _loc2_;
         }
         if(this.FLastIsAlpah != _loc2_)
         {
            this.FLastIsAlpah = _loc2_;
         }
      }
      
      protected function GirlfriendAvatarOnOut(param1:MouseEvent) : void
      {
         this.FSGirlfriendAvatar.filters = [];
         this.FLastIsAlpah = false;
         this.FSGirlfriendAvatar.buttonMode = false;
      }
      
      protected function GirlFriendOnTextClick(param1:TextEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(param1.text);
         if(this.FOnClickOpenGirlFriend != null)
         {
            this.FOnClickOpenGirlFriend(this,_loc2_);
         }
      }
      
      override public function get Cursor() : uint
      {
         if(this.FCursorHoveringMonster)
         {
            return CONST_CURSOR.CURSORID_MONSTER;
         }
         return CONST_CURSOR.CURSORID_Default;
      }
      
      override public function get CursorDisplayObject() : TUIComponent
      {
         return this.Parent;
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
      
      public function get OverlayOnMove() : Function
      {
         return this.FOverlayOnMove;
      }
      
      public function set OverlayOnMove(param1:Function) : void
      {
         this.FOverlayOnMove = param1;
      }
      
      public function get OverlayOnOut() : Function
      {
         return this.FOverlayOnOut;
      }
      
      public function set OverlayOnOut(param1:Function) : void
      {
         this.FOverlayOnOut = param1;
      }
      
      public function get OnVisit() : Function
      {
         return this.FOnVisit;
      }
      
      public function set OnVisit(param1:Function) : void
      {
         this.FOnVisit = param1;
      }
      
      public function get OnHomeHall() : Function
      {
         return this.FOnHomeHall;
      }
      
      public function set OnHomeHall(param1:Function) : void
      {
         this.FOnHomeHall = param1;
      }
      
      public function get OnMonster() : Function
      {
         return this.FOnMonster;
      }
      
      public function set OnMonster(param1:Function) : void
      {
         this.FOnMonster = param1;
      }
      
      public function get OnLuckyCat() : Function
      {
         return this.FOnLuckyCat;
      }
      
      public function set OnLuckyCat(param1:Function) : void
      {
         this.FOnLuckyCat = param1;
      }
      
      public function get OnClearCD() : Function
      {
         return this.FOnClearCD;
      }
      
      public function set OnClearCD(param1:Function) : void
      {
         this.FOnClearCD = param1;
      }
      
      public function set OnClickOpenGirlFriend(param1:Function) : void
      {
         this.FOnClickOpenGirlFriend = param1;
      }
      
      public function set FOnTeaseWithGirlFriend(param1:Function) : void
      {
         this.FOnTeaseWithGirlFriend = param1;
      }
      
      public function set OnClickUpgradeGirlFriend(param1:Function) : void
      {
         this.FOnClickUpgradeGirlFriend = param1;
      }
      
      public function get OnInteractionLog() : Function
      {
         return this.FOnInteractionLog;
      }
      
      public function set OnInteractionLog(param1:Function) : void
      {
         this.FOnInteractionLog = param1;
      }
      
      public function get OnEffectSilverCoin() : Function
      {
         return this.FOnEffectSilverCoin;
      }
      
      public function set OnEffectSilverCoin(param1:Function) : void
      {
         this.FOnEffectSilverCoin = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FMC_EffectMonster.stop();
         if(this.FMC_Monster != null)
         {
            this.FMC_Monster.stop();
         }
         this.FMC_HomeEffect.stop();
         this.FMC_HellButterflyEffect1.stop();
         this.FMC_HellButterflyEffect2.stop();
         this.SetGirlFriendInteractive(false);
         this.SetGirlFriendUpgrade(false);
         if(this.FHomeType == CONST_HOME.TYPE_HOME_MySelf)
         {
            this.FIsUpdateFriendUI = true;
         }
         this.FAKeyMonsterCost = 0;
         this.FBitmapGirlFriend.bitmapData = null;
         this.FBitmapSubstrate.bitmapData = null;
         this.FBitmapFloatingIslandLeft.bitmapData = null;
         this.FBitmapFloatingIslandRight.bitmapData = null;
      }
      
      public function Update(param1:uint) : void
      {
         this.FHomeType = param1;
         this.LoadHomeSubstrate();
         if(this.FIsUpdateFriendUI)
         {
            this.UpdateFriendDigests();
            this.UpdateFriendUIPage();
            this.UpdatePanelFriends(this.FFriendsFilter);
            this.FIsUpdateFriendUI = false;
         }
         this.UpdateHome();
         this.UpdatePanelCharacter();
         this.UpdatePanelInteractive();
         this.UpdateGirlFriend();
         this.UpdateMonsterUI();
         this.UpdateLuckyCatUI();
         this.FUICredits.UpdatePanel();
         this.UpdateUIFriends();
         this.PlayPanelShortcuts();
         this.ProcessorResize();
      }
      
      public function UpdateHomeUpgrade() : void
      {
         this.LoadHomeSubstrate();
         this.UpdateMonsterUI();
         this.UpdateLuckyCatUI();
      }
      
      public function UpdateGirlFriend() : void
      {
         this.UpdateGirlFriendData();
         this.LoadGirlFriendImage();
         this.UpdatePanelInteractive();
         this.UpdateGirlFriendUI();
      }
      
      public function PlayEffectLuckyCat() : void
      {
         ++this.FLuckyCatEffectCount;
      }
      
      public function UpdateLuckyCat() : void
      {
         this.UpdateLuckyCatUI();
      }
      
      public function UpdateMonsterPanel() : void
      {
         this.UpdatePanelInteractive();
      }
      
      public function UpdateMonster() : void
      {
         this.UpdateMonsterUI();
      }
      
      public function QueryGirlfriendInteractiveCoordinate(param1:TQueryCoordinate) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:MovieClip = null;
         switch(this.FGirlfriendInteractiveIndex)
         {
            case TYPE_Interactive_1:
               _loc3_ = this.FBtnGirlfriendInteractive_0.Substrate;
               break;
            case TYPE_Interactive_2:
               _loc3_ = this.FBtnGirlfriendInteractive_1.Substrate;
               break;
            case TYPE_Interactive_3:
               _loc3_ = this.FBtnGirlfriendInteractive_2.Substrate;
         }
         if(_loc3_ != null)
         {
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
            _loc2_.X += _loc3_.width / 2;
            _loc2_.Y += _loc3_.height / 2;
            param1.Value.Assign(_loc2_);
         }
      }
      
      public function QueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:MovieClip = null;
         if(this.FMC_Monster != null)
         {
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FMC_Monster);
            _loc2_.X -= this.FMC_Monster.width / 3;
            _loc2_.Y -= this.FMC_Monster.height / 3;
            param1.Value.Assign(_loc2_);
         }
      }
      
      public function QueryCoordinateDestination(param1:TQueryCoordinate) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:MovieClip = null;
         if(this.FBtnHomeHall == null)
         {
            return;
         }
         if(this.FHomeType == CONST_HOME.TYPE_HOME_MySelf)
         {
            _loc3_ = this.FBtnHomeHall.Substrate;
         }
         else
         {
            _loc3_ = this.FBtnReturnHome.Substrate;
         }
         if(_loc3_ != null)
         {
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
            _loc2_.X += _loc3_.width / 2;
            _loc2_.Y += _loc3_.height / 2;
            param1.Value.Assign(_loc2_);
         }
      }
   }
}

