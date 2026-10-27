package Processors.Game.Lobby.Shortcuts
{
   import Externals.SExternalCore;
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Queries.TQueryBoolean;
   import Foundation.Resources.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.BleachTrain.TBleachTrainData;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.TTask;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.Unlocks.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Processors.Game.Lobby.Shortcuts.Window.*;
   import Processors.Game.Lobby.SkyTower.TProcessorSkyTower;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.geom.Point;
   import flash.utils.*;
   import ghostcat.operation.RepeatOper;
   import ghostcat.operation.TweenOper;
   import ghostcat.util.easing.Cubic;
   
   public class TProcessorShortcuts extends TProcessorLobbyModule
   {
      
      protected static const TIME_INTERVAL_INVITE_PERIOD:int = 1000;
      
      protected static const POSITION_MainFunction:uint = CONST_SHORTCUTS.POSITION_MainFunction;
      
      protected static const POSITION_SecondaryFunction:uint = CONST_SHORTCUTS.POSITION_SecondaryFunction;
      
      protected static const POSITION_SecondaryFunctionA:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionA;
      
      protected static const POSITION_SecondaryFunctionB:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionB;
      
      protected static const POSITION_SecondaryFunctionC:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionC;
      
      protected static const POSITION_SecondaryFunctionD:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionD;
      
      protected static const POSITION_ActiveList:uint = CONST_SHORTCUTS.POSITION_ActiveList;
      
      protected static const POSITION_ActiveListSecondary:uint = CONST_SHORTCUTS.POSITION_ActiveListSecondary;
      
      protected static const POSITION_Avatar:uint = CONST_SHORTCUTS.POSITION_Avatar;
      
      protected static const POSITION_Constantly:uint = CONST_SHORTCUTS.POSITION_Constantly;
      
      protected static const POSITION_Map:uint = CONST_SHORTCUTS.POSITION_Map;
      
      protected static const POSITION_MainFunction_Special:uint = CONST_SHORTCUTS.POSITION_MainFunction_Special;
      
      protected static const POSITION_QuestGuide:uint = CONST_SHORTCUTS.POSITION_QuestGuide;
      
      protected static const POSITION_Home:uint = CONST_SHORTCUTS.POSITION_Home;
      
      protected static const POSITION_NPC:uint = CONST_SHORTCUTS.POSITION_NPC;
      
      protected static const TYPE_Whitelist_Add:uint = CONST_FRIEND.TYPE_Whitelist_Add;
      
      protected static const UNLOCK_CONDITION_QUEST_COMPLETED:uint = CONST_UNLOCK.UNLOCK_CONDITION_QUEST_COMPLETED;
      
      protected static const UNLOCK_CONDITION_LEVEL:uint = CONST_UNLOCK.UNLOCK_CONDITION_LEVEL;
      
      protected static const UNLOCK_CONDITION_QUEST_ACCEPT:uint = CONST_UNLOCK.UNLOCK_CONDITION_QUEST_ACCEPT;
      
      protected static const COORDINATE_Activity_X:int = 1022;
      
      protected static const COORDINATE_Activity_Y:int = 0;
      
      protected static const COORDINATE_ActiveList_X:int = 1022;
      
      protected static const COORDINATE_ActiveList_Y:int = 80;
      
      protected static const COORDINATE_ActiveListTwo_X:int = 1022;
      
      protected static const COORDINATE_ActiveListTwo_Y:int = 160;
      
      protected static const COORDINATE_Function_X:int = 574;
      
      protected static const COORDINATE_Function_Y:int = 566;
      
      protected static const COORDINATE_Function_Special_X:int = 617;
      
      protected static const COORDINATE_Function_Special_Y:int = 506;
      
      protected static const COORDINATE_Quest_X:int = 1050;
      
      protected static const COORDINATE_Quest_Y:int = 160;
      
      protected static const COORDINATE_Achievement_X:int = 1050;
      
      protected static const COORDINATE_Achievement_Y:int = 330;
      
      protected static const COORDINATE_BleachTrain_X:int = 1070;
      
      protected static const COORDINATE_BleachTrain_Y:int = 320;
      
      protected static const COORDINATE_Map_X:int = 1168;
      
      protected static const COORDINATE_Map_Y:int = 0;
      
      protected static const CONSTANTLY_Constantly_Y:int = 250;
      
      protected static const SHRINK_NUM:uint = 3;
      
      protected static const SHRINK_MAX:uint = 234;
      
      protected var FCharacter:TCharacter;
      
      protected var FUnlocks:TUnlocks;
      
      protected var FWindowAvatar:TWindowAvatar;
      
      protected var FWindowMainFunction:TWindowMainFunction;
      
      protected var FWindowMainFunctionSpecial:TWindowMainFunctionSpecial;
      
      protected var FWindowSecondaryFunction:TWindowSecondaryFunction;
      
      protected var FWindowActiveList:TWindowActiveList;
      
      protected var FWindowActiveListTwo:TWindowActiveListTwo;
      
      protected var FWindowMap:TWindowMap;
      
      protected var FWindowQuest:TWindowQuestGuide;
      
      protected var FWindowAchievement:TWindowAchievementFollow;
      
      protected var FWindowBleachTrain:TWindowBleachTrainFollow;
      
      protected var FWindowConstantly:TWindowConstantly;
      
      protected var FWindowHeroInfor:TWindowHeroInfor;
      
      protected var FRepeatOper:Vector.<RepeatOper>;
      
      protected var FTweenOperIn:Vector.<TweenOper>;
      
      protected var FTweenOperOut:Vector.<TweenOper>;
      
      protected var FRepeatObjList:Vector.<TUIComponent>;
      
      protected var FTickInvite:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnAvaterHead:Function;
      
      protected var FOnVip:Function;
      
      protected var FOnOpenDailySign:Function;
      
      protected var FOnKnifeSoulClick:Function;
      
      protected var FOnPromote:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FOnBleachAgent:Function;
      
      protected var FOnHeros:Function;
      
      protected var FOnGeneralStar:Function;
      
      protected var FOnTacticalDeployment:Function;
      
      protected var FOnBackpack:Function;
      
      protected var FOnTreasure:Function;
      
      protected var FOnKnifeOfKillSoul:Function;
      
      protected var FOnStrengthen:Function;
      
      protected var FOnOrnamentStrengthen:Function;
      
      protected var FOnOrganiZation:Function;
      
      protected var FOnSevenHeroMap:Function;
      
      protected var FOnReveredBook:Function;
      
      protected var FOnReturn:Function;
      
      protected var FOnHome:Function;
      
      protected var FOnMall:Function;
      
      protected var FOnPet:Function;
      
      protected var FOnRebirth:Function;
      
      protected var FOnSmelt:Function;
      
      protected var FOnYellowDiamond:Function;
      
      protected var FOnCDK:Function;
      
      protected var FOnBlackMarket:Function;
      
      protected var FOnExpDuplicate:Function;
      
      protected var FOnHeroChange:Function;
      
      protected var FOnLikeUs:Function;
      
      protected var FOnExportPlayer:Function;
      
      protected var FOnKingChallenge:Function;
      
      protected var FOnEquipForge:Function;
      
      protected var FOnSpecialFight:Function;
      
      protected var FOnVainTravel:Function;
      
      protected var FOnRelatedPartner:Function;
      
      protected var FOnNightmareTrial:Function;
      
      protected var FOnDailyQuest:Function;
      
      protected var FOnDailyActivity:Function;
      
      protected var FOnBleachDailyRecord:Function;
      
      protected var FOnSign:Function;
      
      protected var FOnAchievement:Function;
      
      protected var FOnCrashJade:Function;
      
      protected var FOnDailyWelfare:Function;
      
      protected var FOnArena:Function;
      
      protected var FOnTeamBattle:Function;
      
      protected var FOnKillHeros:Function;
      
      protected var FOnSevenKings:Function;
      
      protected var FOnSkyTower:Function;
      
      protected var FOnGongFuFight:Function;
      
      protected var FOnTreasureMap:Function;
      
      protected var FOnBleachTrain:Function;
      
      protected var FOnOfficeLady:Function;
      
      protected var FOnSuperMarket:Function;
      
      protected var FOnGoodAssess:Function;
      
      protected var FOnShareFriend:Function;
      
      protected var FOnPlatFormSync:Function;
      
      protected var FOnCustomHero:Function;
      
      protected var FOnCollectSoul:Function;
      
      protected var FOnProfessionRefine:Function;
      
      protected var FOnActiveListFirstRecharge:Function;
      
      protected var FOnActiveListRecharge:Function;
      
      protected var FOnActiveListWonderful:Function;
      
      protected var FOnActiveListReceivePacks:Function;
      
      protected var FOnActiveListReceiveOrderGift:Function;
      
      protected var FOnActiveListFund:Function;
      
      protected var FOnActiveListSuperTreasure:Function;
      
      protected var FOnActiveListRechargeCommon:Function;
      
      protected var FOnActiveListEspada:Function;
      
      protected var FOnActiveListMaskFright:Function;
      
      protected var FOnActiveListEquipmentShop:Function;
      
      protected var FOnActiveListSoulBox:Function;
      
      protected var FOnActiveListGambling:Function;
      
      protected var FOnActiveListLimitBuy:Function;
      
      protected var FOnActiveListIceHeros:Function;
      
      protected var FOnActiveListIceDragon:Function;
      
      protected var FOnActiveListSuperEggs:Function;
      
      protected var FOnActiveListJigsaw:Function;
      
      protected var FOnActiveListTeamBuy:Function;
      
      protected var FOnActiveListBigTurnTable:Function;
      
      protected var FOnActiveListVipFund:Function;
      
      protected var FOnActiveListServerPay:Function;
      
      protected var FOnActiveListRandCard:Function;
      
      protected var FOnActiveListBleachJigsaw:Function;
      
      protected var FOnActiveTreasureAwake:Function;
      
      protected var FOnActiveChess:Function;
      
      protected var FOnActiveWorldCup:Function;
      
      protected var FOnActiveHerosMarket:Function;
      
      protected var FOnActiveLottery:Function;
      
      protected var FOnActivePartner:Function;
      
      protected var FOnActiveLuckyJoy:Function;
      
      protected var FOnActiveSwiftChange:Function;
      
      protected var FOnActivePrivilegeLease:Function;
      
      protected var FOnActiveCombineActivity:Function;
      
      protected var FOnActiveHalloweenActivity:Function;
      
      protected var FOnActiveCircleTrialActivity:Function;
      
      protected var FOnActiveKingLegendActivity:Function;
      
      protected var FOnActiveChristmasActivity:Function;
      
      protected var FOnActiveNewYearDayActivity:Function;
      
      protected var FOnActiveUniteTaskActivity:Function;
      
      protected var FOnActiveDreamsComeTrueActivity:Function;
      
      protected var FOnActiveNewYearSheepActivity:Function;
      
      protected var FOnActiveGoldTurntableActivity:Function;
      
      protected var FOnActiveFeedbackActivity:Function;
      
      protected var FOnActiveDayBackActivity:Function;
      
      protected var FOnActiveGrowthPlanActivity:Function;
      
      protected var FOnActiveEasterActivity:Function;
      
      protected var FOnActiveBleachBagActivity:Function;
      
      protected var FOnActiveGalleryActivity:Function;
      
      protected var FOnActiveDailyHeroActivity:Function;
      
      protected var FOnActivePyramidActivity:Function;
      
      protected var FOnActiveRushInSeireitei:Function;
      
      protected var FOnActiveAstrologyActivity:Function;
      
      protected var FOnActiveKnifeHeroCollect:Function;
      
      protected var FOnActiveCoolSummer:Function;
      
      protected var FOnActiveEveryDayAward:Function;
      
      protected var FOnActiveFirstPayBag:Function;
      
      protected var FOnActiveBrushHappy:Function;
      
      protected var FOnActiveNewServerDraw:Function;
      
      protected var FOnActiveNewHalloween:Function;
      
      protected var FOnActiveThanksgivingDay:Function;
      
      protected var FOnActiveChristmas2015:Function;
      
      protected var FOnActiveNewYear2016:Function;
      
      protected var FOnActiveNewYear2016Two:Function;
      
      protected var FOnActiveEaster2016:Function;
      
      protected var FOnActiveGhostKingForg:Function;
      
      protected var FOnActiveLaborDay2016:Function;
      
      protected var FOnActiveDuanwujie2016:Function;
      
      protected var FOnActiveTreasureHunt:Function;
      
      protected var FOnActiveSoulCarnival:Function;
      
      protected var FOnActiveKnifeChess:Function;
      
      protected var FOnActiveNationalDay:Function;
      
      protected var FOnActiveHalloween2016:Function;
      
      protected var FOnActiveThanksGivingDay2016:Function;
      
      protected var FOnActiveNewYear2017:Function;
      
      protected var FOnActiveFoolsDay:Function;
      
      protected var FOnActiveChildrenDay:Function;
      
      protected var FOnActiveAnniversary:Function;
      
      protected var FOnActiveNationalDay2017:Function;
      
      protected var FOnActiveListSecondaryFirstDayGiftBag:Function;
      
      protected var FOnActiveListSecondaryOnLineGiftBag:Function;
      
      protected var FOnActiveListSecondaryGoldGiftBag:Function;
      
      protected var FOnActiveListSecondary7DayGiftBag:Function;
      
      protected var FOnActiveListSecondaryOrderGiftBag:Function;
      
      protected var FOnEnterWorldMap:Function;
      
      protected var FOnEnterCity:Function;
      
      protected var FOnViewRaiders:Function;
      
      protected var FOnMail:Function;
      
      protected var FOnQuest:Function;
      
      protected var FOnFriend:Function;
      
      protected var FOnSwitchDisplay:Function;
      
      protected var FOnGirlGame:Function;
      
      protected var FShowOtherHeroInfor:Function;
      
      protected var FRequestWhisper:Function;
      
      protected var FRequestAddFriend:Function;
      
      protected var FRequestSendMail:Function;
      
      protected var FOnHomeHellButterfly:Function;
      
      protected var FOnHomeSlave:Function;
      
      protected var FOnHomeGamble:Function;
      
      protected var FOnHomeGirl:Function;
      
      protected var FOnNpcTavern:Function;
      
      protected var FOnNpcJade:Function;
      
      protected var FOnNpcMakeEquip:Function;
      
      protected var FOnShowAchievement:Function;
      
      protected var FOnUnlockResponse:Function;
      
      protected var FOnNotificationLevelGiftBagState:Function;
      
      public function TProcessorShortcuts(param1:TUIComponent, param2:TUIComponent, param3:TLobbyParameters)
      {
         super(param1,param3);
         param2.mouseEnabled = false;
         this.FCharacter = SLogicsCore.Character;
         this.FUnlocks = SLogicsCore.Unlocks;
         this.FWindowAvatar = new TWindowAvatar(this);
         this.FWindowAvatar.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowAvatar.OnEffectGenerateText = this.ProcessorEffectGenerateTextOnClick;
         this.FWindowAvatar.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowAvatar.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowAvatar.OnHead = this.ProcessorAvaterHeadOnClick;
         this.FWindowAvatar.OnKnifeSoul = this.ProcessorAvaterKnifeSoulOnClick;
         this.FWindowAvatar.OnVIP = this.ProcessorAvaterVIPOnClick;
         this.FWindowAvatar.OnFightingPower = this.ProcessorOnFightingPower;
         this.FWindowAvatar.OnPurchase = this.ProcessorOnPurchase;
         this.FWindowAvatar.OnOpenDailySign = this.ProcessorDailySignOnClick;
         this.FWindowAvatar.OnBleachAgent = this.OnBleachAgentOpen;
         this.FWindowAvatar.Visible = false;
         this.FWindowMap = new TWindowMap(this);
         this.FWindowMap.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowMap.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowMap.OnWorldMap = this.ProcessorWorldMapOnClick;
         this.FWindowMap.OnReturnHome = this.ProcessorReturnHomeOnClick;
         this.FWindowMap.OnViewRaiders = this.ProcessorViewRaidersOnClick;
         this.FWindowMap.OnMail = this.ProcessorMapOnMail;
         this.FWindowMap.OnQuest = this.ProcessorMapOnQuest;
         this.FWindowMap.OnFriend = this.ProcessorMapOnFriend;
         this.FWindowMap.OnSwitchDisplay = this.ProcessorMapOnSwitchDisplay;
         this.FWindowMap.OnShowIcon = this.ProcessorMapOnShowIcon;
         this.FWindowMap.OnHideIcon = this.ProcessorMapOnHideIcon;
         this.FWindowMap.Visible = false;
         this.FWindowMap.x = COORDINATE_Map_X;
         this.FWindowMap.y = COORDINATE_Map_Y;
         this.FWindowQuest = new TWindowQuestGuide(this);
         this.FWindowQuest.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowQuest.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowQuest.Visible = false;
         this.FWindowQuest.x = COORDINATE_Quest_X;
         this.FWindowQuest.y = COORDINATE_Quest_Y;
         this.FWindowQuest.TutorialNextStep = TutorialNextStep;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_QuestGuideWindow,this.FWindowQuest);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_QuestGuideWindow,this);
         this.FWindowAchievement = new TWindowAchievementFollow(this);
         this.FWindowAchievement.OnClickAchievement = this.ProcessorAchievementOnClick;
         this.FWindowAchievement.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowAchievement.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowAchievement.Visible = false;
         this.FWindowAchievement.x = COORDINATE_Achievement_X;
         this.FWindowAchievement.y = COORDINATE_Achievement_Y;
         this.FWindowBleachTrain = new TWindowBleachTrainFollow(this);
         this.FWindowBleachTrain.X = COORDINATE_BleachTrain_X;
         this.FWindowBleachTrain.Y = COORDINATE_BleachTrain_Y;
         this.FWindowBleachTrain.OnClickTrainData = this.ProcessorSecondaryFunctionOnClick;
         this.FWindowBleachTrain.Visible = false;
         this.FWindowMainFunction = new TWindowMainFunction(this);
         this.FWindowMainFunction.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowMainFunction.ShortcutOnClick = this.ProcessorMainFunctionOnClick;
         this.FWindowMainFunction.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowMainFunction.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowMainFunction.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowMainFunction.Visible = false;
         this.FWindowMainFunction.x = COORDINATE_Function_X;
         this.FWindowMainFunction.y = COORDINATE_Function_Y;
         this.FWindowMainFunctionSpecial = new TWindowMainFunctionSpecial(this);
         this.FWindowMainFunctionSpecial.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowMainFunctionSpecial.ShortcutOnClick = this.ProcessorMainFunctionSpecialOnClick;
         this.FWindowMainFunctionSpecial.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowMainFunctionSpecial.Visible = false;
         this.FWindowMainFunctionSpecial.x = COORDINATE_Function_Special_X;
         this.FWindowMainFunctionSpecial.y = COORDINATE_Function_Special_Y;
         this.FWindowSecondaryFunction = new TWindowSecondaryFunction(this,param2);
         this.FWindowSecondaryFunction.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowSecondaryFunction.ShortcutOnClick = this.ProcessorSecondaryFunctionOnClick;
         this.FWindowSecondaryFunction.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowSecondaryFunction.SetDailySignIconFunction = this.SetDailySignIconStateFun;
         this.FWindowSecondaryFunction.Visible = false;
         this.FWindowSecondaryFunction.x = COORDINATE_Activity_X;
         this.FWindowSecondaryFunction.y = COORDINATE_Activity_Y;
         this.FWindowActiveList = new TWindowActiveList(this,param2);
         this.FWindowActiveList.ShortcutOnClick = this.ProcessorActiveListOnClick;
         this.FWindowActiveList.Visible = false;
         this.FWindowActiveList.x = COORDINATE_ActiveList_X;
         this.FWindowActiveList.y = COORDINATE_ActiveList_Y;
         this.FWindowActiveListTwo = new TWindowActiveListTwo(this,param2);
         this.FWindowActiveListTwo.ShortcutOnClick = this.ProcessorActiveListOnClick;
         this.FWindowActiveListTwo.OnNotificationLevelGiftBagState = this.ProcessorOnNotificationLevelGiftBagState;
         this.FWindowActiveListTwo.Visible = false;
         this.FWindowActiveListTwo.x = COORDINATE_ActiveListTwo_X;
         this.FWindowActiveListTwo.y = COORDINATE_ActiveListTwo_Y;
         this.FWindowConstantly = new TWindowConstantly(this);
         this.FWindowConstantly.OnOpenFunctionWindow = this.ProcessorConstantlyOnClick;
         this.FWindowConstantly.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowConstantly.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowConstantly.Visible = false;
         this.FWindowConstantly.Y = CONSTANTLY_Constantly_Y;
         this.FWindowHeroInfor = new TWindowHeroInfor(this);
         this.FWindowHeroInfor.HeroInforOnClick = this.ProcessorHeroInforOnClick;
         this.FWindowHeroInfor.Visible = false;
         this.FRepeatObjList = new Vector.<TUIComponent>();
         this.FRepeatObjList.push(this.FWindowSecondaryFunction);
         this.FRepeatObjList.push(this.FWindowActiveList);
         this.FRepeatObjList.push(this.FWindowActiveListTwo);
         this.ConstructTweens();
         this.mouseEnabled = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHORTCUTS.RESOURCESID_Shortcut);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHORTCUTS.RESOURCESID_ShortcutMainFunction);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHORTCUTS.RESOURCESID_ShortcutSecondaryFunction);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHORTCUTS.RESOURCESID_ShortcutActiveList);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Textures_ShortcutEffect);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FWindowAvatar.Perform_UIDispatch();
         this.FWindowSecondaryFunction.Perform_UIDispatch();
         this.FWindowActiveList.Perform_UIDispatch();
         this.FWindowActiveListTwo.Perform_UIDispatch();
         this.FWindowMap.Perform_UIDispatch();
         this.FWindowQuest.Perform_UIDispatch();
         this.FWindowAchievement.Perform_UIDispatch();
         this.FWindowBleachTrain.Perform_UIDispatch();
         this.FWindowMainFunction.Perform_UIDispatch();
         this.FWindowMainFunctionSpecial.Perform_UIDispatch();
         this.FWindowConstantly.Perform_UIDispatch();
         this.FWindowHeroInfor.Perform_UIDispatch();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         this.ProcessorResize();
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickInvite >= TIME_INTERVAL_INVITE_PERIOD)
         {
            this.FWindowMainFunctionSpecial.Update();
            this.FWindowConstantly.Update();
            this.FTickInvite = _loc1_;
         }
         this.FWindowQuest.Update();
         this.FWindowAvatar.Update();
         this.FWindowSecondaryFunction.Update();
         this.FWindowActiveList.Update();
         this.FWindowActiveListTwo.Update();
         this.FWindowMainFunction.Update();
         this.FWindowMap.Update();
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         if(this.FWindowSecondaryFunction.ShortcutWidth > 0)
         {
            this.FWindowSecondaryFunction.X = _loc1_ - this.FWindowMap.ShortcutWidth - this.FWindowSecondaryFunction.ShortcutWidth + this.FWindowMap.OffestWidth;
            if(!this.FWindowSecondaryFunction.Visible)
            {
               this.FWindowSecondaryFunction.Visible = true;
            }
         }
         else if(this.FWindowSecondaryFunction.Visible)
         {
            this.FWindowSecondaryFunction.Visible = false;
         }
         if(this.FWindowMap.ShortcutWidth > 0)
         {
            this.FWindowMap.X = _loc1_ - this.FWindowMap.ShortcutWidth;
            if(!this.FWindowMap.Visible)
            {
               this.FWindowMap.Visible = true;
            }
         }
         else if(this.FWindowMap.Visible)
         {
            this.FWindowMap.Visible = false;
         }
         if(this.FWindowMap.IsMainScene && this.FWindowActiveList.ShortcutWidth > 0)
         {
            this.FWindowActiveList.X = _loc1_ - this.FWindowMap.ShortcutWidth - this.FWindowActiveList.ShortcutWidth + this.FWindowMap.OffestWidth;
            if(!this.FWindowActiveList.Visible)
            {
               this.FWindowActiveList.Visible = true;
            }
         }
         else if(this.FWindowActiveList.Visible)
         {
            this.FWindowActiveList.Visible = false;
         }
         if(this.FWindowMap.IsMainScene && this.FWindowActiveListTwo.ShortcutWidth > 0)
         {
            this.FWindowActiveListTwo.X = _loc1_ - this.FWindowMap.ShortcutWidth - this.FWindowActiveListTwo.ShortcutWidth + this.FWindowMap.OffestWidth;
            if(!this.FWindowActiveListTwo.Visible)
            {
               this.FWindowActiveListTwo.Visible = true;
            }
         }
         else if(this.FWindowActiveListTwo.Visible)
         {
            this.FWindowActiveListTwo.Visible = false;
         }
         if(this.FWindowQuest.ShortcutWidth > 0)
         {
            this.FWindowQuest.X = _loc1_ - this.FWindowQuest.ShortcutWidth;
            if(!this.FWindowQuest.Visible)
            {
               this.FWindowQuest.Visible = true;
            }
         }
         else if(this.FWindowQuest.Visible)
         {
            this.FWindowQuest.Visible = false;
         }
         if(this.FWindowAchievement.ShortcutWidth > 0)
         {
            this.FWindowAchievement.X = _loc1_ - this.FWindowAchievement.ShortcutWidth;
            if(!this.FWindowAchievement.Visible)
            {
               this.FWindowAchievement.Visible = true;
            }
         }
         else if(this.FWindowAchievement.Visible)
         {
            this.FWindowAchievement.Visible = false;
         }
         if(this.FWindowBleachTrain.ShortcutWidth > 0)
         {
            this.FWindowBleachTrain.X = _loc1_ - this.FWindowBleachTrain.ShortcutWidth;
            if(!this.FWindowBleachTrain.Visible)
            {
               this.FWindowBleachTrain.Visible = true;
            }
         }
         else if(this.FWindowBleachTrain.Visible)
         {
            this.FWindowBleachTrain.Visible = false;
         }
         if(this.FWindowMainFunction.ShortcutWidth > 0)
         {
            this.FWindowMainFunction.X = _loc1_ - this.FWindowMainFunction.ShortcutWidth;
            this.FWindowMainFunction.Y = _loc2_ - this.FWindowMainFunction.ShortcutHeight;
            this.FWindowMainFunctionSpecial.X = _loc1_ - this.FWindowMainFunction.ShortcutWidth + this.FWindowMainFunctionSpecial.ShortcutWidth;
            this.FWindowMainFunctionSpecial.Y = _loc2_ - this.FWindowMainFunction.ShortcutHeight;
            if(!this.FWindowMainFunction.Visible)
            {
               this.FWindowMainFunction.Visible = true;
               this.FWindowMainFunctionSpecial.Visible = true;
            }
         }
         else if(this.FWindowMainFunction.Visible)
         {
            this.FWindowMainFunction.Visible = false;
            this.FWindowMainFunctionSpecial.Visible = false;
         }
         if(this.FWindowMap.IsMainScene && this.FWindowHeroInfor.Visible && this.FWindowHeroInfor.ShortcutWidth > 0)
         {
            this.FWindowHeroInfor.X = this.FWindowAvatar.X + this.FWindowAvatar.ShortcutWidth;
         }
         else
         {
            this.HideHeroContorlPanle();
         }
         if(this.FWindowConstantly.ShortcutWidth > 0)
         {
            this.FWindowConstantly.Y = this.FWindowAvatar.Y + this.FWindowAvatar.ShortcutHeight - 20;
            if(!this.FWindowConstantly.Visible)
            {
               this.FWindowConstantly.Visible = true;
            }
         }
         else if(this.FWindowConstantly.Visible)
         {
            this.FWindowConstantly.Visible = false;
         }
      }
      
      protected function ShortcutVerification(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         _loc3_ = this.VerificationLocaltionOperatingByPosition(param1,param2);
         if(!_loc3_)
         {
            _loc4_ = this.InquiryConditionLocaltionOperatingByPosition(param1,param2);
            EffectGenerateText(_loc4_);
            return false;
         }
         return true;
      }
      
      protected function ShortcutAvaterHeadOperating(param1:Object, param2:uint, param3:ByteArray = null) : void
      {
         switch(param2)
         {
            case CONST_SHORTCUTS.TYPE_Avatar_Hero:
            case CONST_SHORTCUTS.TYPE_Avatar_Military:
               this.ProcessorAvaterHeadOnClick(this,param3);
               break;
            case CONST_SHORTCUTS.TYPE_Avatar_VIP:
               this.ProcessorAvaterVIPOnClick(this);
               break;
            case CONST_SHORTCUTS.TYPE_Avatar_KnifeSoul:
               this.ProcessorAvaterKnifeSoulOnClick(this);
         }
      }
      
      protected function ShortcutMapOperating(param1:Object, param2:uint) : void
      {
         switch(param2)
         {
            case CONST_SHORTCUTS.TYPE_Map_EnterWorldMap:
               this.ProcessorWorldMapOnClick(param1);
               break;
            case CONST_SHORTCUTS.TYPE_Map_Friend:
               this.ProcessorMapOnFriend(param1);
         }
      }
      
      protected function VerificationLocaltionOperatingByPosition(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUnlock = null;
         var _loc6_:Boolean = false;
         _loc6_ = false;
         _loc4_ = this.FUnlocks.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FUnlocks.GetUnlockByIndex(_loc3_);
            if(param1 == _loc5_.Position && param2 == _loc5_.Index)
            {
               if(_loc5_.State == TUnlock.UNLOCKSTATE_Unlocked)
               {
                  _loc6_ = true;
                  break;
               }
            }
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function InquiryConditionLocaltionOperatingByPosition(param1:uint, param2:uint) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUnlock = null;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:TTask = null;
         _loc6_ = 0;
         _loc7_ = "";
         _loc4_ = this.FUnlocks.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FUnlocks.GetUnlockByIndex(_loc3_);
            if(param1 == _loc5_.Position && param2 == _loc5_.Index)
            {
               _loc6_ = _loc5_.ConditiontValue;
               _loc7_ = _loc5_.Name;
               break;
            }
            _loc3_++;
         }
         if(_loc5_.State == TUnlock.UNLOCKSTATE_ForcedOff)
         {
            return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_15);
         }
         switch(_loc5_.ConditiontType)
         {
            case UNLOCK_CONDITION_QUEST_ACCEPT:
               _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Task,_loc6_) as TTask;
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_35),_loc9_.Name);
               break;
            case UNLOCK_CONDITION_QUEST_COMPLETED:
               _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Task,_loc6_) as TTask;
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_36),_loc9_.Name);
               break;
            case UNLOCK_CONDITION_LEVEL:
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_37),_loc6_);
         }
         return _loc8_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_38),_loc7_);
      }
      
      protected function Unopened() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_15));
      }
      
      protected function ProcessorParameters(param1:Array) : ByteArray
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:ByteArray = null;
         _loc6_ = new ByteArray();
         _loc3_ = int(param1.length);
         if(_loc3_ == 0)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = TUtilityRTTI.GetClassNameByInstance(_loc4_);
            switch(_loc5_)
            {
               case TUtilityRTTI.CLASSNAME_INT:
                  _loc6_.writeInt(_loc4_);
                  break;
               case TUtilityRTTI.CLASSNAME_UINT:
                  _loc6_.writeUnsignedInt(_loc4_);
                  break;
               case TUtilityRTTI.CLASSNAME_NUMBER:
                  _loc6_.writeDouble(_loc4_);
                  break;
               case TUtilityRTTI.CLASSNAME_BOOLEAN:
                  _loc6_.writeBoolean(_loc4_);
                  break;
               case TUtilityRTTI.CLASSNAME_STRING:
                  TUtilityString.FlushUTF(_loc6_,_loc4_);
                  break;
               case TUtilityRTTI.CLASSNAME_NULL:
                  break;
               case TUtilityRTTI.CLASSNAME_VOID:
                  break;
               default:
                  _loc6_.writeObject(_loc4_);
            }
            _loc2_++;
         }
         _loc6_.position = 0;
         return _loc6_;
      }
      
      protected function ConstructTweens() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:RepeatOper = null;
         var _loc4_:TweenOper = null;
         var _loc5_:TweenOper = null;
         this.FTweenOperIn = new Vector.<TweenOper>(SHRINK_NUM);
         this.FTweenOperOut = new Vector.<TweenOper>(SHRINK_NUM);
         this.FRepeatOper = new Vector.<RepeatOper>(SHRINK_NUM);
         _loc2_ = SHRINK_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new RepeatOper();
            _loc4_ = new TweenOper();
            _loc5_ = new TweenOper();
            _loc4_.duration = 5;
            _loc5_.duration = 1000;
            this.FTweenOperIn[_loc1_] = _loc4_;
            this.FTweenOperOut[_loc1_] = _loc5_;
            _loc3_.loop = 1;
            _loc3_.children = [_loc4_,_loc5_];
            this.FRepeatOper[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      protected function SetDailySignIconStateFun(param1:Boolean) : void
      {
         if(this.FWindowAvatar != null)
         {
            this.FWindowAvatar.UpdateDailySignIconState(param1);
         }
      }
      
      protected function ProcessorOnUnlockResponse(param1:Object, param2:TBounds, param3:Object) : void
      {
         if(this.FOnUnlockResponse != null)
         {
            this.FOnUnlockResponse(param1,param2,param3);
         }
      }
      
      protected function ShortcutOnQueryUnlock(param1:Object, param2:uint, param3:uint, param4:TQueryBoolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUnlock = null;
         _loc6_ = this.FUnlocks.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.FUnlocks.GetUnlockByIndex(_loc5_);
            if(_loc7_.Position == param2 && _loc7_.Index == param3)
            {
               if(_loc7_.State == TUnlock.UNLOCKSTATE_Unlocked)
               {
                  param4.Value = true;
               }
               break;
            }
            _loc5_++;
         }
      }
      
      protected function ProcessorAvaterHeadOnClick(param1:Object, param2:ByteArray) : void
      {
         if(this.FOnAvaterHead != null)
         {
            this.FOnAvaterHead(param1,param2);
         }
      }
      
      protected function ProcessorAvaterKnifeSoulOnClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.ShortcutVerification(POSITION_Avatar,CONST_SHORTCUTS.TYPE_Avatar_KnifeSoul);
         if(_loc2_ && this.FOnKnifeSoulClick != null)
         {
            this.FOnKnifeSoulClick(param1);
         }
      }
      
      protected function ProcessorAvaterVIPOnClick(param1:Object) : void
      {
         if(this.FOnVip != null)
         {
            this.FOnVip(param1);
         }
      }
      
      protected function ProcessorDailySignOnClick(param1:Object) : void
      {
         if(this.FOnOpenDailySign != null)
         {
            this.FOnOpenDailySign(param1);
         }
      }
      
      protected function OnBleachAgentOpen() : void
      {
         if(this.FOnBleachAgent != null)
         {
            this.FOnBleachAgent();
         }
      }
      
      protected function ProcessorOnFightingPower(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.ShortcutVerification(POSITION_Avatar,CONST_SHORTCUTS.TYPE_Avatar_FightingPromote);
         if(_loc2_ && this.FOnPromote != null)
         {
            this.FOnPromote(param1);
         }
      }
      
      protected function ProcessorOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      protected function ProcessorMainFunctionOnClick(param1:Object, param2:int, param3:int, param4:Vector.<uint> = null, param5:ByteArray = null) : void
      {
         switch(param2)
         {
            case CONST_SHORTCUTS.TYPE_MainFunction_Heros:
               if(this.FOnHeros != null)
               {
                  this.FOnHeros(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Star:
               if(this.FOnGeneralStar != null)
               {
                  this.FOnGeneralStar(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_TacticalDeployment:
               if(this.FOnTacticalDeployment != null)
               {
                  this.FOnTacticalDeployment(this);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Backpack:
               if(this.FOnBackpack != null)
               {
                  this.FOnBackpack(this);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Treasure:
               if(this.FOnTreasure != null)
               {
                  this.FOnTreasure(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_KnifeOfKillSoul:
               if(this.FOnKnifeOfKillSoul != null)
               {
                  this.FOnKnifeOfKillSoul(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Strengthen:
               if(this.FOnStrengthen != null)
               {
                  this.FOnStrengthen(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_OrnamentStrengthen:
               if(this.FOnOrnamentStrengthen != null)
               {
                  this.FOnOrnamentStrengthen(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_ProfessionRefine:
               if(this.FOnProfessionRefine != null)
               {
                  this.FOnProfessionRefine(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Mail:
               if(this.FOnMail != null)
               {
                  this.FOnMail(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_Organization:
               if(this.FOnOrganiZation != null)
               {
                  this.FOnOrganiZation(this,param5);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_ReveredBook:
               if(this.FOnReveredBook != null)
               {
                  this.FOnReveredBook(this);
               }
               break;
            case CONST_SHORTCUTS.TYPE_MainFunction_ReturnCity:
               if(this.FOnReturn != null)
               {
                  this.FOnReturn(this);
               }
         }
      }
      
      protected function ProcessorMainFunctionSpecialOnClick(param1:Object, param2:int, param3:int, param4:Vector.<uint> = null, param5:ByteArray = null) : void
      {
         var _loc6_:Boolean = false;
         _loc6_ = this.ShortcutVerification(POSITION_MainFunction_Special,CONST_SHORTCUTS.TYPE_Function_Special_Home);
         if(_loc6_ && this.FOnHome != null)
         {
            this.FOnHome(this,param5);
         }
      }
      
      protected function ProcessorSecondaryFunctionOnClick(param1:Object, param2:int, param3:int, param4:Vector.<uint> = null, param5:ByteArray = null) : void
      {
         switch(param3)
         {
            case POSITION_SecondaryFunctionA:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CustomHero:
                     if(this.FOnCustomHero != null)
                     {
                        this.FOnCustomHero(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CollectSoul:
                     if(this.FOnCollectSoul != null)
                     {
                        this.FOnCollectSoul(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest:
                     if(this.FOnDailyQuest != null)
                     {
                        this.FOnDailyQuest(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyActivity:
                     if(this.FOnDailyActivity != null)
                     {
                        this.FOnDailyActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_BleachDailyRecord:
                     if(this.FOnBleachDailyRecord != null)
                     {
                        this.FOnBleachDailyRecord(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign:
                     if(this.FOnSign != null)
                     {
                        this.FOnSign(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Achievement:
                     if(this.FOnAchievement != null)
                     {
                        this.FOnAchievement(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyWelfare:
                     if(this.FOnDailyWelfare != null)
                     {
                        this.FOnDailyWelfare(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Announcement:
                     SExternalCore.OpenAnnouncement();
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CrashJade:
                     if(this.FOnCrashJade != null)
                     {
                        this.FOnCrashJade(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_SevenHeroMap:
                     if(this.FOnSevenHeroMap != null)
                     {
                        this.FOnSevenHeroMap(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_SpecialFight:
                     if(this.FOnSpecialFight != null)
                     {
                        this.FOnSpecialFight(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_HeroChange:
                     if(this.FOnHeroChange != null)
                     {
                        this.FOnHeroChange(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_BlackMarket:
                     if(this.FOnBlackMarket != null)
                     {
                        this.FOnBlackMarket(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_ExpDuplicate:
                     if(this.FOnExpDuplicate != null)
                     {
                        this.FOnExpDuplicate(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionA_ExpDuplicate:
                     if(this.FOnExpDuplicate != null)
                     {
                        this.FOnExpDuplicate(this);
                     }
               }
               break;
            case POSITION_SecondaryFunctionB:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_Arena:
                     if(this.FOnArena != null)
                     {
                        this.FOnArena(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TeamBattle:
                     if(this.FOnTeamBattle != null)
                     {
                        this.FOnTeamBattle(this,param5);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_KillHeros:
                     if(this.FOnKillHeros != null)
                     {
                        this.FOnKillHeros(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_SevenKing:
                     if(this.FOnSevenKings != null)
                     {
                        this.FOnSevenKings(this);
                     }
                     break;
                  case 10:
                     TProcessorSkyTower.GoldMode = true;
                     if(this.FOnSkyTower != null)
                     {
                        this.FOnSkyTower(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_SkyTower:
                     TProcessorSkyTower.GoldMode = false;
                     if(this.FOnSkyTower != null)
                     {
                        this.FOnSkyTower(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_GongFuFight:
                     if(this.FOnGongFuFight != null)
                     {
                        this.FOnGongFuFight(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TreasureMap:
                     if(this.FOnTreasureMap != null)
                     {
                        this.FOnTreasureMap(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_VainTravel:
                     if(this.FOnVainTravel != null)
                     {
                        this.FOnVainTravel(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_RelatedPartner:
                     if(this.FOnRelatedPartner != null)
                     {
                        this.FOnRelatedPartner(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionB_NightmareTrial:
                     if(this.FOnNightmareTrial != null)
                     {
                        this.FOnNightmareTrial(this);
                     }
               }
               break;
            case POSITION_SecondaryFunctionC:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionC_BleachTrain:
                     if(this.FOnBleachTrain != null)
                     {
                        this.FOnBleachTrain(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionC_OfficeLady:
                     if(this.FOnOfficeLady != null)
                     {
                        this.FOnOfficeLady(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionC_SuperMarket:
                     if(this.FOnSuperMarket != null)
                     {
                        this.FOnSuperMarket(this);
                     }
               }
               break;
            case POSITION_SecondaryFunctionD:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionD_GoodAssess:
                     if(this.FOnGoodAssess != null)
                     {
                        this.FOnGoodAssess(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionD_ShareFriend:
                     if(this.FOnShareFriend != null)
                     {
                        this.FOnShareFriend(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunctionD_PlatformSync:
                     if(this.FOnPlatFormSync != null)
                     {
                        this.FOnPlatFormSync(this);
                     }
               }
               break;
            default:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_Mall:
                     if(this.FOnMall != null)
                     {
                        this.FOnMall(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_Pet:
                     if(this.FOnPet != null)
                     {
                        this.FOnPet(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_Rebirth:
                     if(this.FOnRebirth != null)
                     {
                        this.FOnRebirth(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_Smelt:
                     if(this.FOnSmelt != null)
                     {
                        this.FOnSmelt(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_YellowDiamond:
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_TXYellowDiamond:
                     if(this.FOnYellowDiamond != null)
                     {
                        this.FOnYellowDiamond(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_CDK:
                     if(this.FOnCDK != null)
                     {
                        this.FOnCDK(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus:
                     if(this.FOnLikeUs != null)
                     {
                        this.FOnLikeUs(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_ExportPlayer:
                     if(this.FOnExportPlayer != null)
                     {
                        this.FOnExportPlayer(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_KingChallenge:
                     if(this.FOnKingChallenge != null)
                     {
                        this.FOnKingChallenge(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_SecondaryFunction_EquipForge:
                     if(this.FOnEquipForge != null)
                     {
                        this.FOnEquipForge(this);
                     }
               }
         }
      }
      
      protected function ProcessorActiveListOnClick(param1:Object, param2:int, param3:int, param4:Vector.<uint> = null) : void
      {
         var _loc5_:ByteArray = null;
         switch(param3)
         {
            case POSITION_ActiveListSecondary:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_FirstDayGiftBag:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_OpenServerGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_OnLineGiftBag:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_OnlineGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_GoldGiftBag:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_GoldGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_7DayGiftBag:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_SevenDayGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_CollectGame:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_CollectGameGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_LevelGiftBag:
                     if(this.FOnActiveListReceivePacks != null)
                     {
                        this.FOnActiveListReceivePacks(this,CONST_ACTIVITY_MODE.Activity_LevelGiftBag);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveListSecondary_OrderGiftBag:
                     if(this.FOnActiveListReceiveOrderGift != null)
                     {
                        this.FOnActiveListReceiveOrderGift(this);
                     }
               }
               break;
            default:
               switch(param2)
               {
                  case CONST_SHORTCUTS.TYPE_ActiveList_FirstRecharge:
                     if(this.FOnActiveListFirstRecharge != null)
                     {
                        this.FOnActiveListFirstRecharge(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Recharge:
                     if(this.FOnActiveListRecharge != null)
                     {
                        this.FOnActiveListRecharge(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Wonderful:
                     if(this.FOnActiveListWonderful != null)
                     {
                        this.FOnActiveListWonderful(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Fund:
                     if(this.FOnActiveListFund != null)
                     {
                        this.FOnActiveListFund(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_SuperTreasure:
                     if(this.FOnActiveListSuperTreasure != null)
                     {
                        this.FOnActiveListSuperTreasure(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_RechargeCommon_2:
                     _loc5_ = new ByteArray();
                     _loc5_.writeUnsignedInt(param2);
                     _loc5_.position = 0;
                     if(this.FOnActiveListRechargeCommon != null)
                     {
                        this.FOnActiveListRechargeCommon(this,_loc5_);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Espada:
                     if(this.FOnActiveListEspada != null)
                     {
                        this.FOnActiveListEspada(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_MaskFright:
                     if(this.FOnActiveListMaskFright != null)
                     {
                        this.FOnActiveListMaskFright(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_EquipmentShop:
                     if(this.FOnActiveListEquipmentShop != null)
                     {
                        this.FOnActiveListEquipmentShop(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_SoulBox:
                     if(this.FOnActiveListSoulBox != null)
                     {
                        this.FOnActiveListSoulBox(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Gambling:
                     if(this.FOnActiveListGambling != null)
                     {
                        this.FOnActiveListGambling(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy:
                     if(this.FOnActiveListLimitBuy != null)
                     {
                        this.FOnActiveListLimitBuy(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_IceHeros:
                     if(this.FOnActiveListIceHeros != null)
                     {
                        this.FOnActiveListIceHeros(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_IceDragon:
                     if(this.FOnActiveListIceDragon != null)
                     {
                        this.FOnActiveListIceDragon(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs:
                     if(this.FOnActiveListSuperEggs != null)
                     {
                        this.FOnActiveListSuperEggs(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Jigsaw:
                     if(this.FOnActiveListJigsaw != null)
                     {
                        this.FOnActiveListJigsaw(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy:
                     if(this.FOnActiveListTeamBuy != null)
                     {
                        this.FOnActiveListTeamBuy(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_BigTurnTable:
                     if(this.FOnActiveListBigTurnTable != null)
                     {
                        this.FOnActiveListBigTurnTable(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_ServerPay:
                     if(this.FOnActiveListServerPay != null)
                     {
                        this.FOnActiveListServerPay(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_RandCard:
                     if(this.FOnActiveListRandCard != null)
                     {
                        this.FOnActiveListRandCard(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_BleachJigsaw:
                     if(this.FOnActiveListBleachJigsaw != null)
                     {
                        this.FOnActiveListBleachJigsaw(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_TreasureAwake:
                     if(this.FOnActiveTreasureAwake != null)
                     {
                        this.FOnActiveTreasureAwake(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Chess:
                     if(this.FOnActiveChess != null)
                     {
                        this.FOnActiveChess(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_WorldCup:
                     if(this.FOnActiveWorldCup != null)
                     {
                        this.FOnActiveWorldCup(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_HerosMarket:
                     if(this.FOnActiveHerosMarket != null)
                     {
                        this.FOnActiveHerosMarket(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Lottery:
                     if(this.FOnActiveLottery != null)
                     {
                        this.FOnActiveLottery(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Partner:
                     if(this.FOnActivePartner != null)
                     {
                        this.FOnActivePartner(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_LuckyJoy:
                     if(this.FOnActiveLuckyJoy != null)
                     {
                        this.FOnActiveLuckyJoy(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_SwiftChange:
                     if(this.FOnActiveSwiftChange != null)
                     {
                        this.FOnActiveSwiftChange(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_PrivilegeLease:
                     if(this.FOnActivePrivilegeLease != null)
                     {
                        this.FOnActivePrivilegeLease(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_CombineActivity:
                     if(this.FOnActiveCombineActivity != null)
                     {
                        this.FOnActiveCombineActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPay:
                     if(this.FOnActiveHalloweenActivity != null)
                     {
                        this.FOnActiveHalloweenActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_CircleTrial:
                     if(this.FOnActiveCircleTrialActivity != null)
                     {
                        this.FOnActiveCircleTrialActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_KingLegend:
                     if(this.FOnActiveKingLegendActivity != null)
                     {
                        this.FOnActiveKingLegendActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Christmas:
                     if(this.FOnActiveChristmasActivity != null)
                     {
                        this.FOnActiveChristmasActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewYearDay:
                     if(this.FOnActiveNewYearDayActivity != null)
                     {
                        this.FOnActiveNewYearDayActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_UniteTask:
                     if(this.FOnActiveUniteTaskActivity != null)
                     {
                        this.FOnActiveUniteTaskActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Dreams:
                     if(this.FOnActiveDreamsComeTrueActivity != null)
                     {
                        this.FOnActiveDreamsComeTrueActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewYearSheep:
                     if(this.FOnActiveNewYearSheepActivity != null)
                     {
                        this.FOnActiveNewYearSheepActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_GoldTurntable:
                     if(this.FOnActiveGoldTurntableActivity != null)
                     {
                        this.FOnActiveGoldTurntableActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Feedback:
                     if(this.FOnActiveFeedbackActivity != null)
                     {
                        this.FOnActiveFeedbackActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_DayBack:
                     if(this.FOnActiveDayBackActivity != null)
                     {
                        this.FOnActiveDayBackActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_GrowthPlan:
                     if(this.FOnActiveGrowthPlanActivity != null)
                     {
                        this.FOnActiveGrowthPlanActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Easter:
                     if(this.FOnActiveEasterActivity != null)
                     {
                        this.FOnActiveEasterActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_BleachBag:
                     if(this.FOnActiveBleachBagActivity != null)
                     {
                        this.FOnActiveBleachBagActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Gallery:
                     if(this.FOnActiveGalleryActivity != null)
                     {
                        this.FOnActiveGalleryActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_DailyHero:
                     if(this.FOnActiveDailyHeroActivity != null)
                     {
                        this.FOnActiveDailyHeroActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Pyramid:
                     if(this.FOnActivePyramidActivity != null)
                     {
                        this.FOnActivePyramidActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_RushInSeireitei:
                     if(this.FOnActiveRushInSeireitei != null)
                     {
                        this.FOnActiveRushInSeireitei(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_AstrologyHouse:
                     if(this.FOnActiveAstrologyActivity != null)
                     {
                        this.FOnActiveAstrologyActivity(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_KnifeHeroCollect:
                     if(this.FOnActiveKnifeHeroCollect != null)
                     {
                        this.FOnActiveKnifeHeroCollect(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_CoolSummer:
                     if(this.FOnActiveCoolSummer != null)
                     {
                        this.FOnActiveCoolSummer(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_EveryDayAward:
                     if(this.FOnActiveEveryDayAward != null)
                     {
                        this.FOnActiveEveryDayAward(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_FirstPayBag:
                     if(this.FOnActiveFirstPayBag != null)
                     {
                        this.FOnActiveFirstPayBag(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_BrushHappy:
                     if(this.FOnActiveBrushHappy != null)
                     {
                        this.FOnActiveBrushHappy(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewServerDraw:
                     if(this.FOnActiveNewServerDraw != null)
                     {
                        this.FOnActiveNewServerDraw(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewHalloween:
                     if(this.FOnActiveNewHalloween != null)
                     {
                        this.FOnActiveNewHalloween(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_ThanksgivingDay:
                     if(this.FOnActiveThanksgivingDay != null)
                     {
                        this.FOnActiveThanksgivingDay(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Christmas2015:
                     if(this.FOnActiveChristmas2015 != null)
                     {
                        this.FOnActiveChristmas2015(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewYear2016:
                     if(this.FOnActiveNewYear2016 != null)
                     {
                        this.FOnActiveNewYear2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewYear2016Two:
                     if(this.FOnActiveNewYear2016Two != null)
                     {
                        this.FOnActiveNewYear2016Two(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Easter2016:
                     if(this.FOnActiveEaster2016 != null)
                     {
                        this.FOnActiveEaster2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_GhostKingForg:
                     if(this.FOnActiveGhostKingForg != null)
                     {
                        this.FOnActiveGhostKingForg(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_LaborDay2016:
                     if(this.FOnActiveLaborDay2016 != null)
                     {
                        this.FOnActiveLaborDay2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Duanwujie2016:
                     if(this.FOnActiveDuanwujie2016 != null)
                     {
                        this.FOnActiveDuanwujie2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_TreasureHunt:
                     if(this.FOnActiveTreasureHunt != null)
                     {
                        this.FOnActiveTreasureHunt(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_SoulCarnival:
                     if(this.FOnActiveSoulCarnival != null)
                     {
                        this.FOnActiveSoulCarnival(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_KnifeChess:
                     if(this.FOnActiveKnifeChess != null)
                     {
                        this.FOnActiveKnifeChess(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NationalDay:
                     if(this.FOnActiveNationalDay != null)
                     {
                        this.FOnActiveNationalDay(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Halloween2016:
                     if(this.FOnActiveHalloween2016 != null)
                     {
                        this.FOnActiveHalloween2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_ThanksGivingDay2016:
                     if(this.FOnActiveThanksGivingDay2016 != null)
                     {
                        this.FOnActiveThanksGivingDay2016(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NewYear2017:
                     if(this.FOnActiveNewYear2017 != null)
                     {
                        this.FOnActiveNewYear2017(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_FoolsDay:
                     if(this.FOnActiveFoolsDay != null)
                     {
                        this.FOnActiveFoolsDay(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_ChildrenDay:
                     if(this.FOnActiveChildrenDay != null)
                     {
                        this.FOnActiveChildrenDay(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_Anniversary:
                     if(this.FOnActiveAnniversary != null)
                     {
                        this.FOnActiveAnniversary(this);
                     }
                     break;
                  case CONST_SHORTCUTS.TYPE_ActiveList_NationalDay2017:
                     if(this.FOnActiveNationalDay2017 != null)
                     {
                        this.FOnActiveNationalDay2017(this);
                     }
               }
         }
      }
      
      protected function ProcessorWorldMapOnClick(param1:Object) : void
      {
         if(this.FOnEnterWorldMap != null)
         {
            this.FOnEnterWorldMap(param1);
         }
      }
      
      protected function ProcessorReturnHomeOnClick(param1:Object) : void
      {
         if(this.FOnEnterCity != null)
         {
            this.FOnEnterCity(param1);
         }
      }
      
      protected function ProcessorViewRaidersOnClick(param1:Object) : void
      {
         this.Unopened();
         if(this.FOnViewRaiders != null)
         {
            this.FOnViewRaiders(param1);
         }
      }
      
      protected function ProcessorMapOnMail(param1:Object) : void
      {
         if(this.FOnMail != null)
         {
            this.FOnMail(param1);
         }
      }
      
      protected function ProcessorMapOnQuest(param1:Object) : void
      {
         if(this.FOnQuest != null)
         {
            this.FOnQuest(param1);
         }
      }
      
      protected function ProcessorMapOnFriend(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.ShortcutVerification(POSITION_Map,CONST_SHORTCUTS.TYPE_Map_Friend);
         if(_loc2_ && this.FOnFriend != null)
         {
            this.FOnFriend(param1);
         }
      }
      
      protected function ProcessorMapOnSwitchDisplay(param1:Object, param2:Boolean) : void
      {
         if(this.FOnSwitchDisplay != null)
         {
            this.FOnSwitchDisplay(param1,param2);
         }
      }
      
      protected function ProcessorMapOnHideIcon(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:RepeatOper = null;
         var _loc6_:TweenOper = null;
         var _loc7_:TweenOper = null;
         _loc2_ = this.FWindowSecondaryFunction.Height + this.FWindowActiveList.Height + this.FWindowActiveListTwo.Height;
         _loc4_ = SHRINK_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRepeatOper[_loc3_];
            _loc6_ = this.FTweenOperIn[_loc3_];
            _loc7_ = this.FTweenOperOut[_loc3_];
            _loc6_.target = this.FRepeatObjList[_loc3_];
            _loc6_.params = {
               "y":this.FRepeatObjList[_loc3_].Y,
               "ease":Cubic.easeIn
            };
            _loc7_.target = this.FRepeatObjList[_loc3_];
            _loc7_.params = {
               "y":this.FRepeatObjList[_loc3_].Y - _loc2_,
               "ease":Cubic.easeOut
            };
            _loc5_.execute();
            _loc3_++;
         }
      }
      
      protected function ProcessorMapOnShowIcon(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:RepeatOper = null;
         var _loc6_:TweenOper = null;
         var _loc7_:TweenOper = null;
         var _loc8_:int = 0;
         _loc2_ = this.FWindowSecondaryFunction.Height + this.FWindowActiveList.Height + this.FWindowActiveListTwo.Height;
         _loc4_ = SHRINK_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRepeatOper[_loc3_];
            _loc6_ = this.FTweenOperIn[_loc3_];
            _loc7_ = this.FTweenOperOut[_loc3_];
            _loc8_ = this.FRepeatObjList[_loc3_].Y + _loc2_ > SHRINK_MAX ? int(SHRINK_MAX - this.FRepeatObjList[_loc3_].Height) : int(this.FRepeatObjList[_loc3_].Y + _loc2_);
            _loc6_.target = this.FRepeatObjList[_loc3_];
            _loc6_.params = {
               "y":this.FRepeatObjList[_loc3_].Y,
               "ease":Cubic.easeIn
            };
            _loc7_.target = this.FRepeatObjList[_loc3_];
            _loc7_.params = {
               "y":_loc8_,
               "ease":Cubic.easeOut
            };
            _loc5_.execute();
            _loc3_++;
         }
      }
      
      protected function ProcessorHomeOnClick(param1:Object, param2:uint, param3:ByteArray = null) : void
      {
         switch(param2)
         {
            case CONST_SHORTCUTS.TYPE_Home_HellButterfly:
               if(this.FOnHomeHellButterfly != null)
               {
                  this.FOnHomeHellButterfly(param1,param3);
               }
               break;
            case CONST_SHORTCUTS.TYPE_Home_Slave:
               if(this.FOnHomeSlave != null)
               {
                  this.FOnHomeSlave(param1,param3);
               }
               break;
            case CONST_SHORTCUTS.TYPE_Home_Gamble:
               if(this.FOnHomeGamble != null)
               {
                  this.FOnHomeGamble(param1,param3);
               }
               break;
            case CONST_SHORTCUTS.TYPE_Home_GirlFriend:
               if(this.FOnHomeGamble != null)
               {
                  this.FOnHomeGirl(param1,param3);
               }
               break;
            default:
               if(this.FOnHome != null)
               {
                  this.FOnHome(param1,param3);
               }
         }
      }
      
      protected function ProcessorNPCOnClick(param1:Object, param2:uint, param3:ByteArray = null) : void
      {
         switch(param2)
         {
            case CONST_SHORTCUTS.TYPE_NPC_Jade:
               if(this.FOnNpcJade != null)
               {
                  this.FOnNpcJade(param1);
               }
               break;
            case CONST_SHORTCUTS.TYPE_NPC_Tavern:
               if(this.FOnNpcTavern != null)
               {
                  this.FOnNpcTavern(param1);
               }
               break;
            case CONST_SHORTCUTS.TYPE_NPC_MakeEquip:
               if(this.FOnNpcMakeEquip != null)
               {
                  this.FOnNpcMakeEquip(param1);
               }
         }
      }
      
      protected function ProcessorAchievementOnClick(param1:Object, param2:uint, param3:ByteArray = null) : void
      {
         if(this.FOnShowAchievement != null)
         {
            this.FOnShowAchievement(param1);
         }
      }
      
      protected function ProcessorConstantlyOnClick(param1:Object, param2:int, param3:int) : void
      {
         switch(param2)
         {
            case POSITION_MainFunction:
               this.ProcessorMainFunctionOnClick(param1,param3,param2);
               break;
            case POSITION_SecondaryFunctionB:
               this.ProcessorSecondaryFunctionOnClick(param1,param3,param2);
               break;
            case POSITION_Home:
               this.PerformShortcutHyperlinks(param1,POSITION_Home,param3,null,[param3]);
               break;
            case POSITION_NPC:
               this.ProcessorNPCOnClick(param1,param3);
               break;
            case POSITION_Constantly:
               if(this.FOnGirlGame != null)
               {
                  this.FOnGirlGame(this);
               }
               break;
            case POSITION_SecondaryFunction:
               this.PerformShortcutHyperlinks(param1,param2,param3,null,[param3]);
               break;
            case POSITION_SecondaryFunctionA:
               this.PerformShortcutHyperlinks(param1,param2,param3,null,[param3]);
         }
      }
      
      protected function ProcessorHeroInforOnClick(param1:Object, param2:String, param3:TDigest, param4:TFriendDigest) : void
      {
         var _loc5_:Vector.<String> = null;
         _loc5_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_34);
         switch(param2)
         {
            case _loc5_[0]:
               if(this.FShowOtherHeroInfor != null)
               {
                  this.FShowOtherHeroInfor(this,param3.Identifier0,param3.Identifier1);
               }
               break;
            case _loc5_[1]:
               if(this.FRequestWhisper != null)
               {
                  this.FRequestWhisper(this,param3);
               }
               break;
            case _loc5_[2]:
               if(this.FRequestSendMail != null)
               {
                  this.FRequestSendMail(this,param3);
               }
               break;
            case _loc5_[3]:
               if(this.FRequestAddFriend != null)
               {
                  this.FRequestAddFriend(this,TYPE_Whitelist_Add,param4);
               }
         }
      }
      
      protected function ProcessorEffectGenerateTextOnClick(param1:Object) : void
      {
         EffectGenerateText(param1 as String);
      }
      
      protected function ProcessorOnNotificationLevelGiftBagState(param1:Object, param2:Boolean) : void
      {
         if(this.FOnNotificationLevelGiftBagState != null)
         {
            this.FOnNotificationLevelGiftBagState(param1,param2);
         }
      }
      
      public function set OnAvaterHead(param1:Function) : void
      {
         this.FOnAvaterHead = param1;
      }
      
      public function get OnAvaterHead() : Function
      {
         return this.FOnAvaterHead;
      }
      
      public function get OnVip() : Function
      {
         return this.FOnVip;
      }
      
      public function set OnVip(param1:Function) : void
      {
         this.FOnVip = param1;
      }
      
      public function get OnOpenDailySign() : Function
      {
         return this.FOnOpenDailySign;
      }
      
      public function set OnOpenDailySign(param1:Function) : void
      {
         this.FOnOpenDailySign = param1;
      }
      
      public function get OnKnifeSoulClick() : Function
      {
         return this.FOnKnifeSoulClick;
      }
      
      public function set OnKnifeSoulClick(param1:Function) : void
      {
         this.FOnKnifeSoulClick = param1;
      }
      
      public function get OnPromote() : Function
      {
         return this.FOnPromote;
      }
      
      public function set OnPromote(param1:Function) : void
      {
         this.FOnPromote = param1;
      }
      
      public function get OnHeros() : Function
      {
         return this.FOnHeros;
      }
      
      public function set OnHeros(param1:Function) : void
      {
         this.FOnHeros = param1;
      }
      
      public function get OnGeneralStar() : Function
      {
         return this.FOnGeneralStar;
      }
      
      public function set OnGeneralStar(param1:Function) : void
      {
         this.FOnGeneralStar = param1;
      }
      
      public function get OnTacticalDeployment() : Function
      {
         return this.FOnTacticalDeployment;
      }
      
      public function set OnTacticalDeployment(param1:Function) : void
      {
         this.FOnTacticalDeployment = param1;
      }
      
      public function get OnBackpack() : Function
      {
         return this.FOnBackpack;
      }
      
      public function set OnBackpack(param1:Function) : void
      {
         this.FOnBackpack = param1;
      }
      
      public function get OnTreasure() : Function
      {
         return this.FOnTreasure;
      }
      
      public function set OnTreasure(param1:Function) : void
      {
         this.FOnTreasure = param1;
      }
      
      public function get OnKnifeOfKillSoul() : Function
      {
         return this.FOnKnifeOfKillSoul;
      }
      
      public function set OnKnifeOfKillSoul(param1:Function) : void
      {
         this.FOnKnifeOfKillSoul = param1;
      }
      
      public function get OnStrengthen() : Function
      {
         return this.FOnStrengthen;
      }
      
      public function set OnStrengthen(param1:Function) : void
      {
         this.FOnStrengthen = param1;
      }
      
      public function get OnOrnamentStrengthen() : Function
      {
         return this.FOnOrnamentStrengthen;
      }
      
      public function set OnOrnamentStrengthen(param1:Function) : void
      {
         this.FOnOrnamentStrengthen = param1;
      }
      
      public function get OnOrganiZation() : Function
      {
         return this.FOnOrganiZation;
      }
      
      public function set OnOrganiZation(param1:Function) : void
      {
         this.FOnOrganiZation = param1;
      }
      
      public function get OnSevenHeroMap() : Function
      {
         return this.FOnSevenHeroMap;
      }
      
      public function set OnSevenHeroMap(param1:Function) : void
      {
         this.FOnSevenHeroMap = param1;
      }
      
      public function get OnReturn() : Function
      {
         return this.FOnReturn;
      }
      
      public function set OnReturn(param1:Function) : void
      {
         this.FOnReturn = param1;
      }
      
      public function get OnHome() : Function
      {
         return this.FOnHome;
      }
      
      public function set OnHome(param1:Function) : void
      {
         this.FOnHome = param1;
      }
      
      public function get OnMall() : Function
      {
         return this.FOnMall;
      }
      
      public function set OnMall(param1:Function) : void
      {
         this.FOnMall = param1;
      }
      
      public function get OnPet() : Function
      {
         return this.FOnPet;
      }
      
      public function set OnPet(param1:Function) : void
      {
         this.FOnPet = param1;
      }
      
      public function get OnTreasureMap() : Function
      {
         return this.FOnTreasureMap;
      }
      
      public function set OnTreasureMap(param1:Function) : void
      {
         this.FOnTreasureMap = param1;
      }
      
      public function get OnCDK() : Function
      {
         return this.FOnCDK;
      }
      
      public function set OnCDK(param1:Function) : void
      {
         this.FOnCDK = param1;
      }
      
      public function get OnDailyQuest() : Function
      {
         return this.FOnDailyQuest;
      }
      
      public function set OnDailyQuest(param1:Function) : void
      {
         this.FOnDailyQuest = param1;
      }
      
      public function get OnDailyActivity() : Function
      {
         return this.FOnDailyActivity;
      }
      
      public function set OnDailyActivity(param1:Function) : void
      {
         this.FOnDailyActivity = param1;
      }
      
      public function get OnBleachDailyRecord() : Function
      {
         return this.FOnBleachDailyRecord;
      }
      
      public function set OnBleachDailyRecord(param1:Function) : void
      {
         this.FOnBleachDailyRecord = param1;
      }
      
      public function get OnSign() : Function
      {
         return this.FOnSign;
      }
      
      public function set OnSign(param1:Function) : void
      {
         this.FOnSign = param1;
      }
      
      public function get OnAchievement() : Function
      {
         return this.FOnAchievement;
      }
      
      public function set OnAchievement(param1:Function) : void
      {
         this.FOnAchievement = param1;
      }
      
      public function get OnArena() : Function
      {
         return this.FOnArena;
      }
      
      public function set OnArena(param1:Function) : void
      {
         this.FOnArena = param1;
      }
      
      public function get OnTeamBattle() : Function
      {
         return this.FOnTeamBattle;
      }
      
      public function set OnTeamBattle(param1:Function) : void
      {
         this.FOnTeamBattle = param1;
      }
      
      public function get OnKillHeros() : Function
      {
         return this.FOnKillHeros;
      }
      
      public function set OnKillHeros(param1:Function) : void
      {
         this.FOnKillHeros = param1;
      }
      
      public function get OnSevenKings() : Function
      {
         return this.FOnSevenKings;
      }
      
      public function set OnSevenKings(param1:Function) : void
      {
         this.FOnSevenKings = param1;
      }
      
      public function get OnSkyTower() : Function
      {
         return this.FOnSkyTower;
      }
      
      public function set OnSkyTower(param1:Function) : void
      {
         this.FOnSkyTower = param1;
      }
      
      public function get OnGongFuFight() : Function
      {
         return this.FOnGongFuFight;
      }
      
      public function set OnGongFuFight(param1:Function) : void
      {
         this.FOnGongFuFight = param1;
      }
      
      public function get OnBleachTrain() : Function
      {
         return this.FOnBleachTrain;
      }
      
      public function set OnBleachTrain(param1:Function) : void
      {
         this.FOnBleachTrain = param1;
      }
      
      public function get OnOfficeLady() : Function
      {
         return this.FOnOfficeLady;
      }
      
      public function set OnOfficeLady(param1:Function) : void
      {
         this.FOnOfficeLady = param1;
      }
      
      public function get OnSuperMarket() : Function
      {
         return this.FOnSuperMarket;
      }
      
      public function set OnSuperMarket(param1:Function) : void
      {
         this.FOnSuperMarket = param1;
      }
      
      public function set OnGoodAssess(param1:Function) : void
      {
         this.FOnGoodAssess = param1;
      }
      
      public function set OnShareFriend(param1:Function) : void
      {
         this.FOnShareFriend = param1;
      }
      
      public function set OnPlatFormSync(param1:Function) : void
      {
         this.FOnPlatFormSync = param1;
      }
      
      public function get OnActiveListFirstRecharge() : Function
      {
         return this.FOnActiveListFirstRecharge;
      }
      
      public function set OnActiveListFirstRecharge(param1:Function) : void
      {
         this.FOnActiveListFirstRecharge = param1;
      }
      
      public function get OnActiveListRecharge() : Function
      {
         return this.FOnActiveListRecharge;
      }
      
      public function set OnActiveListRecharge(param1:Function) : void
      {
         this.FOnActiveListRecharge = param1;
      }
      
      public function get OnActiveListWonderful() : Function
      {
         return this.FOnActiveListWonderful;
      }
      
      public function set OnActiveListWonderful(param1:Function) : void
      {
         this.FOnActiveListWonderful = param1;
      }
      
      public function get OnActiveListReceivePacks() : Function
      {
         return this.FOnActiveListReceivePacks;
      }
      
      public function set OnActiveListReceivePacks(param1:Function) : void
      {
         this.FOnActiveListReceivePacks = param1;
      }
      
      public function get OnActiveListSecondaryFirstDayGiftBag() : Function
      {
         return this.FOnActiveListSecondaryFirstDayGiftBag;
      }
      
      public function set OnActiveListSecondaryFirstDayGiftBag(param1:Function) : void
      {
         this.FOnActiveListSecondaryFirstDayGiftBag = param1;
      }
      
      public function get OnActiveListSecondaryOnLineGiftBag() : Function
      {
         return this.FOnActiveListSecondaryOnLineGiftBag;
      }
      
      public function set OnActiveListSecondaryOnLineGiftBag(param1:Function) : void
      {
         this.FOnActiveListSecondaryOnLineGiftBag = param1;
      }
      
      public function get OnActiveListSecondaryGoldGiftBag() : Function
      {
         return this.FOnActiveListSecondaryGoldGiftBag;
      }
      
      public function set OnActiveListSecondaryGoldGiftBag(param1:Function) : void
      {
         this.FOnActiveListSecondaryGoldGiftBag = param1;
      }
      
      public function get OnActiveListSecondary7DayGiftBag() : Function
      {
         return this.FOnActiveListSecondary7DayGiftBag;
      }
      
      public function set OnActiveListSecondary7DayGiftBag(param1:Function) : void
      {
         this.FOnActiveListSecondary7DayGiftBag = param1;
      }
      
      public function get OnEnterWorldMap() : Function
      {
         return this.FOnEnterWorldMap;
      }
      
      public function set OnEnterWorldMap(param1:Function) : void
      {
         this.FOnEnterWorldMap = param1;
      }
      
      public function get OnEnterCity() : Function
      {
         return this.FOnEnterCity;
      }
      
      public function set OnEnterCity(param1:Function) : void
      {
         this.FOnEnterCity = param1;
      }
      
      public function get OnViewRaiders() : Function
      {
         return this.FOnViewRaiders;
      }
      
      public function set OnViewRaiders(param1:Function) : void
      {
         this.FOnViewRaiders = param1;
      }
      
      public function get OnMail() : Function
      {
         return this.FOnMail;
      }
      
      public function set OnMail(param1:Function) : void
      {
         this.FOnMail = param1;
      }
      
      public function get OnQuest() : Function
      {
         return this.FOnQuest;
      }
      
      public function set OnQuest(param1:Function) : void
      {
         this.FOnQuest = param1;
      }
      
      public function get OnFriend() : Function
      {
         return this.FOnFriend;
      }
      
      public function set OnFriend(param1:Function) : void
      {
         this.FOnFriend = param1;
      }
      
      public function get OnSwitchDisplay() : Function
      {
         return this.FOnSwitchDisplay;
      }
      
      public function set OnSwitchDisplay(param1:Function) : void
      {
         this.FOnSwitchDisplay = param1;
      }
      
      public function get OnNpcJade() : Function
      {
         return this.FOnNpcJade;
      }
      
      public function set OnNpcJade(param1:Function) : void
      {
         this.FOnNpcJade = param1;
      }
      
      public function get OnNpcTavern() : Function
      {
         return this.FOnNpcTavern;
      }
      
      public function set OnNpcTavern(param1:Function) : void
      {
         this.FOnNpcTavern = param1;
      }
      
      public function get OnNpcMakeEquip() : Function
      {
         return this.FOnNpcMakeEquip;
      }
      
      public function set OnNpcMakeEquip(param1:Function) : void
      {
         this.FOnNpcMakeEquip = param1;
      }
      
      public function set OnGirlGame(param1:Function) : void
      {
         this.FOnGirlGame = param1;
      }
      
      public function get OnUnlockResponse() : Function
      {
         return this.FOnUnlockResponse;
      }
      
      public function set OnUnlockResponse(param1:Function) : void
      {
         this.FOnUnlockResponse = param1;
      }
      
      public function set ShowOtherHeroInfor(param1:Function) : void
      {
         this.FShowOtherHeroInfor = param1;
      }
      
      public function set RequestWhisper(param1:Function) : void
      {
         this.FRequestWhisper = param1;
      }
      
      public function set RequestAddFriend(param1:Function) : void
      {
         this.FRequestAddFriend = param1;
      }
      
      public function set RequestSendMail(param1:Function) : void
      {
         this.FRequestSendMail = param1;
      }
      
      public function get OnHomeHellButterfly() : Function
      {
         return this.FOnHomeHellButterfly;
      }
      
      public function set OnHomeHellButterfly(param1:Function) : void
      {
         this.FOnHomeHellButterfly = param1;
      }
      
      public function get OnHomeSlave() : Function
      {
         return this.FOnHomeSlave;
      }
      
      public function set OnHomeSlave(param1:Function) : void
      {
         this.FOnHomeSlave = param1;
      }
      
      public function get OnHomeGamble() : Function
      {
         return this.FOnHomeGamble;
      }
      
      public function set OnHomeGamble(param1:Function) : void
      {
         this.FOnHomeGamble = param1;
      }
      
      public function get OnYellowDiamond() : Function
      {
         return this.FOnYellowDiamond;
      }
      
      public function set OnYellowDiamond(param1:Function) : void
      {
         this.FOnYellowDiamond = param1;
      }
      
      public function get OnActiveListFund() : Function
      {
         return this.FOnActiveListFund;
      }
      
      public function set OnActiveListFund(param1:Function) : void
      {
         this.FOnActiveListFund = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function get OnActiveListSuperTreasure() : Function
      {
         return this.FOnActiveListSuperTreasure;
      }
      
      public function set OnActiveListSuperTreasure(param1:Function) : void
      {
         this.FOnActiveListSuperTreasure = param1;
      }
      
      public function get OnActiveListRechargeCommon() : Function
      {
         return this.FOnActiveListRechargeCommon;
      }
      
      public function set OnActiveListRechargeCommon(param1:Function) : void
      {
         this.FOnActiveListRechargeCommon = param1;
      }
      
      public function get OnActiveListEspada() : Function
      {
         return this.FOnActiveListEspada;
      }
      
      public function set OnActiveListEspada(param1:Function) : void
      {
         this.FOnActiveListEspada = param1;
      }
      
      public function get OnActiveListMaskFright() : Function
      {
         return this.FOnActiveListMaskFright;
      }
      
      public function set OnActiveListMaskFright(param1:Function) : void
      {
         this.FOnActiveListMaskFright = param1;
      }
      
      public function get OnActiveListEquipmentShop() : Function
      {
         return this.FOnActiveListEquipmentShop;
      }
      
      public function set OnActiveListEquipmentShop(param1:Function) : void
      {
         this.FOnActiveListEquipmentShop = param1;
      }
      
      public function get OnActiveListSoulBox() : Function
      {
         return this.FOnActiveListSoulBox;
      }
      
      public function set OnActiveListSoulBox(param1:Function) : void
      {
         this.FOnActiveListSoulBox = param1;
      }
      
      public function set OnReveredBook(param1:Function) : void
      {
         this.FOnReveredBook = param1;
      }
      
      public function get OnActiveListGambling() : Function
      {
         return this.FOnActiveListGambling;
      }
      
      public function set OnActiveListGambling(param1:Function) : void
      {
         this.FOnActiveListGambling = param1;
      }
      
      public function get OnActiveListLimitBuy() : Function
      {
         return this.FOnActiveListLimitBuy;
      }
      
      public function set OnActiveListLimitBuy(param1:Function) : void
      {
         this.FOnActiveListLimitBuy = param1;
      }
      
      public function get OnActiveListIceHeros() : Function
      {
         return this.FOnActiveListIceHeros;
      }
      
      public function set OnActiveListIceHeros(param1:Function) : void
      {
         this.FOnActiveListIceHeros = param1;
      }
      
      public function get OnActiveListIceDragon() : Function
      {
         return this.FOnActiveListIceDragon;
      }
      
      public function set OnActiveListIceDragon(param1:Function) : void
      {
         this.FOnActiveListIceDragon = param1;
      }
      
      public function get OnActiveListSuperEggs() : Function
      {
         return this.FOnActiveListSuperEggs;
      }
      
      public function set OnActiveListSuperEggs(param1:Function) : void
      {
         this.FOnActiveListSuperEggs = param1;
      }
      
      public function get OnActiveListJigsaw() : Function
      {
         return this.FOnActiveListJigsaw;
      }
      
      public function set OnActiveListJigsaw(param1:Function) : void
      {
         this.FOnActiveListJigsaw = param1;
      }
      
      public function get OnActiveListTeamBuy() : Function
      {
         return this.FOnActiveListTeamBuy;
      }
      
      public function set OnActiveListTeamBuy(param1:Function) : void
      {
         this.FOnActiveListTeamBuy = param1;
      }
      
      public function set OnShowAchievement(param1:Function) : void
      {
         this.FOnShowAchievement = param1;
      }
      
      public function get OnActiveListBigTurnTable() : Function
      {
         return this.FOnActiveListBigTurnTable;
      }
      
      public function set OnActiveListBigTurnTable(param1:Function) : void
      {
         this.FOnActiveListBigTurnTable = param1;
      }
      
      public function set OnActiveListSecondaryOrderGiftBag(param1:Function) : void
      {
         this.FOnActiveListSecondaryOrderGiftBag = param1;
      }
      
      public function set OnActiveListReceiveOrderGift(param1:Function) : void
      {
         this.FOnActiveListReceiveOrderGift = param1;
      }
      
      public function get OnActiveListVipFund() : Function
      {
         return this.FOnActiveListVipFund;
      }
      
      public function set OnActiveListVipFund(param1:Function) : void
      {
         this.FOnActiveListVipFund = param1;
      }
      
      public function get OnNotificationLevelGiftBagState() : Function
      {
         return this.FOnNotificationLevelGiftBagState;
      }
      
      public function set OnNotificationLevelGiftBagState(param1:Function) : void
      {
         this.FOnNotificationLevelGiftBagState = param1;
      }
      
      public function get OnActiveListServerPay() : Function
      {
         return this.FOnActiveListServerPay;
      }
      
      public function set OnActiveListServerPay(param1:Function) : void
      {
         this.FOnActiveListServerPay = param1;
      }
      
      public function set OnHomeGirl(param1:Function) : void
      {
         this.FOnHomeGirl = param1;
      }
      
      public function get OnCrashJade() : Function
      {
         return this.FOnCrashJade;
      }
      
      public function set OnCrashJade(param1:Function) : void
      {
         this.FOnCrashJade = param1;
      }
      
      public function get OnDailyWelfare() : Function
      {
         return this.FOnDailyWelfare;
      }
      
      public function set OnDailyWelfare(param1:Function) : void
      {
         this.FOnDailyWelfare = param1;
      }
      
      public function get OnActiveListRandCard() : Function
      {
         return this.FOnActiveListRandCard;
      }
      
      public function set OnActiveListRandCard(param1:Function) : void
      {
         this.FOnActiveListRandCard = param1;
      }
      
      public function get OnActiveListBleachJigsaw() : Function
      {
         return this.FOnActiveListBleachJigsaw;
      }
      
      public function set OnActiveListBleachJigsaw(param1:Function) : void
      {
         this.FOnActiveListBleachJigsaw = param1;
      }
      
      public function set OnActiveTreasureAwake(param1:Function) : void
      {
         this.FOnActiveTreasureAwake = param1;
      }
      
      public function get OnActiveChess() : Function
      {
         return this.FOnActiveChess;
      }
      
      public function set OnActiveChess(param1:Function) : void
      {
         this.FOnActiveChess = param1;
      }
      
      public function get OnActiveWorldCup() : Function
      {
         return this.FOnActiveWorldCup;
      }
      
      public function set OnActiveWorldCup(param1:Function) : void
      {
         this.FOnActiveWorldCup = param1;
      }
      
      public function get OnHeroChange() : Function
      {
         return this.FOnHeroChange;
      }
      
      public function set OnHeroChange(param1:Function) : void
      {
         this.FOnHeroChange = param1;
      }
      
      public function get OnLikeUs() : Function
      {
         return this.FOnLikeUs;
      }
      
      public function set OnLikeUs(param1:Function) : void
      {
         this.FOnLikeUs = param1;
      }
      
      public function get OnSpecialFight() : Function
      {
         return this.FOnSpecialFight;
      }
      
      public function set OnSpecialFight(param1:Function) : void
      {
         this.FOnSpecialFight = param1;
      }
      
      public function get OnActiveHerosMarket() : Function
      {
         return this.FOnActiveHerosMarket;
      }
      
      public function set OnActiveHerosMarket(param1:Function) : void
      {
         this.FOnActiveHerosMarket = param1;
      }
      
      public function set OnBlackMarket(param1:Function) : void
      {
         this.FOnBlackMarket = param1;
      }
      
      public function set OnExpDuplicate(param1:Function) : void
      {
         this.FOnExpDuplicate = param1;
      }
      
      public function set OnActiveLottery(param1:Function) : void
      {
         this.FOnActiveLottery = param1;
      }
      
      public function set OnActivePartner(param1:Function) : void
      {
         this.FOnActivePartner = param1;
      }
      
      public function set OnActiveLuckyJoy(param1:Function) : void
      {
         this.FOnActiveLuckyJoy = param1;
      }
      
      public function set OnActiveSwiftChange(param1:Function) : void
      {
         this.FOnActiveSwiftChange = param1;
      }
      
      public function set OnVainTravel(param1:Function) : void
      {
         this.FOnVainTravel = param1;
      }
      
      public function set OnActivePrivilegeLease(param1:Function) : void
      {
         this.FOnActivePrivilegeLease = param1;
      }
      
      public function set OnActiveCombineActivity(param1:Function) : void
      {
         this.FOnActiveCombineActivity = param1;
      }
      
      public function set OnActiveHalloweenActivity(param1:Function) : void
      {
         this.FOnActiveHalloweenActivity = param1;
      }
      
      public function set OnActiveCircleTrialActivity(param1:Function) : void
      {
         this.FOnActiveCircleTrialActivity = param1;
      }
      
      public function set OnActiveKingLegendActivity(param1:Function) : void
      {
         this.FOnActiveKingLegendActivity = param1;
      }
      
      public function set OnActiveChristmasActivity(param1:Function) : void
      {
         this.FOnActiveChristmasActivity = param1;
      }
      
      public function set OnActiveNewYearDayActivity(param1:Function) : void
      {
         this.FOnActiveNewYearDayActivity = param1;
      }
      
      public function set OnActiveUniteTaskActivity(param1:Function) : void
      {
         this.FOnActiveUniteTaskActivity = param1;
      }
      
      public function set OnActiveDreamsComeTrueActivity(param1:Function) : void
      {
         this.FOnActiveDreamsComeTrueActivity = param1;
      }
      
      public function set OnActiveNewYearSheepActivity(param1:Function) : void
      {
         this.FOnActiveNewYearSheepActivity = param1;
      }
      
      public function set OnActiveGoldTurntableActivity(param1:Function) : void
      {
         this.FOnActiveGoldTurntableActivity = param1;
      }
      
      public function set OnActiveFeedbackActivity(param1:Function) : void
      {
         this.FOnActiveFeedbackActivity = param1;
      }
      
      public function set OnActiveDayBackActivity(param1:Function) : void
      {
         this.FOnActiveDayBackActivity = param1;
      }
      
      public function set OnActiveGrowthPlanActivity(param1:Function) : void
      {
         this.FOnActiveGrowthPlanActivity = param1;
      }
      
      public function set OnActiveEasterActivity(param1:Function) : void
      {
         this.FOnActiveEasterActivity = param1;
      }
      
      public function set OnActiveBleachBagActivity(param1:Function) : void
      {
         this.FOnActiveBleachBagActivity = param1;
      }
      
      public function set OnActiveGalleryActivity(param1:Function) : void
      {
         this.FOnActiveGalleryActivity = param1;
      }
      
      public function set OnActiveDailyHeroActivity(param1:Function) : void
      {
         this.FOnActiveDailyHeroActivity = param1;
      }
      
      public function get OnRelatedPartner() : Function
      {
         return this.FOnRelatedPartner;
      }
      
      public function set OnRelatedPartner(param1:Function) : void
      {
         this.FOnRelatedPartner = param1;
      }
      
      public function get OnNightmareTrial() : Function
      {
         return this.FOnNightmareTrial;
      }
      
      public function set OnNightmareTrial(param1:Function) : void
      {
         this.FOnNightmareTrial = param1;
      }
      
      public function set OnActivePyramidActivity(param1:Function) : void
      {
         this.FOnActivePyramidActivity = param1;
      }
      
      public function set OnActiveRushInSeireitei(param1:Function) : void
      {
         this.FOnActiveRushInSeireitei = param1;
      }
      
      public function set OnActiveKnifeHeroCollect(param1:Function) : void
      {
         this.FOnActiveKnifeHeroCollect = param1;
      }
      
      public function set OnActiveAstrologyActivity(param1:Function) : void
      {
         this.FOnActiveAstrologyActivity = param1;
      }
      
      public function set OnActiveCoolSummer(param1:Function) : void
      {
         this.FOnActiveCoolSummer = param1;
      }
      
      public function set OnActiveEveryDayAward(param1:Function) : void
      {
         this.FOnActiveEveryDayAward = param1;
      }
      
      public function set OnActiveFirstPayBag(param1:Function) : void
      {
         this.FOnActiveFirstPayBag = param1;
      }
      
      public function set OnActiveBrushHappy(param1:Function) : void
      {
         this.FOnActiveBrushHappy = param1;
      }
      
      public function set OnExportPlayer(param1:Function) : void
      {
         this.FOnExportPlayer = param1;
      }
      
      public function set OnKingChallenge(param1:Function) : void
      {
         this.FOnKingChallenge = param1;
      }
      
      public function set OnActiveNewHalloween(param1:Function) : void
      {
         this.FOnActiveNewHalloween = param1;
      }
      
      public function set OnBleachAgent(param1:Function) : void
      {
         this.FOnBleachAgent = param1;
      }
      
      public function set OnActiveNewServerDraw(param1:Function) : void
      {
         this.FOnActiveNewServerDraw = param1;
      }
      
      public function set OnActiveThanksgivingDay(param1:Function) : void
      {
         this.FOnActiveThanksgivingDay = param1;
      }
      
      public function set OnActiveChristmas2015(param1:Function) : void
      {
         this.FOnActiveChristmas2015 = param1;
      }
      
      public function set OnActiveNewYear2016(param1:Function) : void
      {
         this.FOnActiveNewYear2016 = param1;
      }
      
      public function set OnActiveNewYear2016Two(param1:Function) : void
      {
         this.FOnActiveNewYear2016Two = param1;
      }
      
      public function set OnCustomHero(param1:Function) : void
      {
         this.FOnCustomHero = param1;
      }
      
      public function set OnCollectSoul(param1:Function) : void
      {
         this.FOnCollectSoul = param1;
      }
      
      public function get OnRebirth() : Function
      {
         return this.FOnRebirth;
      }
      
      public function set OnRebirth(param1:Function) : void
      {
         this.FOnRebirth = param1;
      }
      
      public function get OnSmelt() : Function
      {
         return this.FOnSmelt;
      }
      
      public function set OnSmelt(param1:Function) : void
      {
         this.FOnSmelt = param1;
      }
      
      public function get OnActiveEaster2016() : Function
      {
         return this.FOnActiveEaster2016;
      }
      
      public function set OnActiveEaster2016(param1:Function) : void
      {
         this.FOnActiveEaster2016 = param1;
      }
      
      public function set OnActiveGhostKingForg(param1:Function) : void
      {
         this.FOnActiveGhostKingForg = param1;
      }
      
      public function set OnActiveLaborDay2016(param1:Function) : void
      {
         this.FOnActiveLaborDay2016 = param1;
      }
      
      public function set OnActiveDuanwujie2016(param1:Function) : void
      {
         this.FOnActiveDuanwujie2016 = param1;
      }
      
      public function set OnActiveTreasureHunt(param1:Function) : void
      {
         this.FOnActiveTreasureHunt = param1;
      }
      
      public function set OnActiveSoulCarnival(param1:Function) : void
      {
         this.FOnActiveSoulCarnival = param1;
      }
      
      public function set OnActiveKnifeChess(param1:Function) : void
      {
         this.FOnActiveKnifeChess = param1;
      }
      
      public function set OnActiveNationalDay(param1:Function) : void
      {
         this.FOnActiveNationalDay = param1;
      }
      
      public function set OnActiveHalloween2016(param1:Function) : void
      {
         this.FOnActiveHalloween2016 = param1;
      }
      
      public function set OnActiveThanksGivingDay2016(param1:Function) : void
      {
         this.FOnActiveThanksGivingDay2016 = param1;
      }
      
      public function set OnActiveNewYear2017(param1:Function) : void
      {
         this.FOnActiveNewYear2017 = param1;
      }
      
      public function set OnActiveFoolsDay(param1:Function) : void
      {
         this.FOnActiveFoolsDay = param1;
      }
      
      public function set OnActiveChildrenDay(param1:Function) : void
      {
         this.FOnActiveChildrenDay = param1;
      }
      
      public function set OnActiveAnniversary(param1:Function) : void
      {
         this.FOnActiveAnniversary = param1;
      }
      
      public function set OnActiveNationalDay2017(param1:Function) : void
      {
         this.FOnActiveNationalDay2017 = param1;
      }
      
      public function set OnEquipForge(param1:Function) : void
      {
         this.FOnEquipForge = param1;
      }
      
      public function set OnProfessionRefine(param1:Function) : void
      {
         this.FOnProfessionRefine = param1;
      }
      
      public function SetupShortcutsShow(param1:Vector.<uint>, param2:Vector.<uint>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FWindowMainFunction.HideAllShortcuts();
         this.FWindowSecondaryFunction.HideAllShortcuts();
         this.FWindowAvatar.HideAllShortcuts();
         this.FWindowMap.HideAllShortcuts();
         this.FWindowMainFunctionSpecial.HideAllShortcuts();
         this.FWindowConstantly.HideAllShortcuts();
         this.FWindowQuest.HideAllShortcuts();
         this.FWindowAchievement.HideAllShortcuts();
         this.FWindowBleachTrain.HideAllShortcuts();
         if(param1 == null)
         {
            return;
         }
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            switch(param1[_loc3_])
            {
               case POSITION_MainFunction:
                  this.FWindowMainFunction.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_SecondaryFunction:
               case POSITION_SecondaryFunctionA:
               case POSITION_SecondaryFunctionB:
               case POSITION_SecondaryFunctionC:
               case POSITION_SecondaryFunctionD:
                  this.FWindowSecondaryFunction.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_Avatar:
                  this.FWindowAvatar.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_Map:
                  this.FWindowMap.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_MainFunction_Special:
                  this.FWindowMainFunctionSpecial.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_Constantly:
                  this.FWindowConstantly.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  break;
               case POSITION_QuestGuide:
                  switch(param2[_loc3_])
                  {
                     case CONST_SHORTCUTS.TYPE_QuestGuide_Quest:
                        this.FWindowQuest.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                        break;
                     case CONST_SHORTCUTS.TYPE_QuestGuide_Achievement:
                        this.FWindowAchievement.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                        break;
                     case CONST_SHORTCUTS.TYPE_QuestGuide_BleachTrain:
                        this.FWindowBleachTrain.SetupShortcutsShow(param1[_loc3_],param2[_loc3_]);
                  }
            }
            _loc3_++;
         }
      }
      
      public function InitSystemSetup() : void
      {
         this.FWindowMap.InitSystemSetup();
      }
      
      public function UpdateShortcutsState(param1:Object, param2:Object) : void
      {
         this.FWindowSecondaryFunction.UpdateShortcutsState(param2);
         this.FWindowMainFunction.UpdateShortcutsState(param2);
         this.FWindowMainFunctionSpecial.UpdateShortcutsState(param2);
         this.FWindowConstantly.UpdateShortcutsState(param2);
      }
      
      public function UnlockingNotification(param1:Object, param2:Object) : void
      {
         var _loc3_:TUnlock = null;
         _loc3_ = param2 as TUnlock;
         switch(_loc3_.Position)
         {
            case POSITION_SecondaryFunction:
            case POSITION_SecondaryFunctionA:
            case POSITION_SecondaryFunctionB:
            case POSITION_SecondaryFunctionC:
            case POSITION_SecondaryFunctionD:
               this.FWindowSecondaryFunction.UnlockingNotification(_loc3_);
               this.FWindowConstantly.UnlockingNotification(_loc3_);
               break;
            case POSITION_MainFunction:
               this.FWindowMainFunction.UnlockingNotification(_loc3_);
               this.FWindowConstantly.UnlockingNotification(_loc3_);
               break;
            case POSITION_MainFunction_Special:
               this.FWindowMainFunctionSpecial.UnlockingNotification(_loc3_);
               break;
            case POSITION_Constantly:
               this.FWindowConstantly.UnlockingNotification(_loc3_);
         }
      }
      
      public function UserUpdateCharBaseInfo() : void
      {
         this.FWindowAvatar.UserUpdateCharBaseInfo();
         this.FWindowMainFunction.UserUpdateCharBaseInfo();
      }
      
      public function UserUpdateCharacterCountry() : void
      {
         this.FWindowAvatar.UserUpdateCharacterCountry();
      }
      
      public function UserUpdateFightingPower() : void
      {
         this.FWindowAvatar.UserUpdateFightingPower();
      }
      
      public function UserUpdatePet() : void
      {
         this.FWindowAvatar.UserUpdatePet();
      }
      
      public function ShowEffectNotification(param1:uint, param2:uint, param3:Boolean) : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         switch(param1)
         {
            case POSITION_MainFunction:
               this.FWindowMainFunction.ShowEffectNotification(param1,param2,param3);
               if(param2 == CONST_SHORTCUTS.TYPE_MainFunction_Mail)
               {
                  this.FWindowMap.ShowEffectNotification(CONST_SHORTCUTS.TYPE_Map_Mail,param3);
               }
               break;
            case POSITION_SecondaryFunction:
            case POSITION_SecondaryFunctionA:
            case POSITION_SecondaryFunctionB:
            case POSITION_SecondaryFunctionC:
            case POSITION_SecondaryFunctionD:
               this.FWindowSecondaryFunction.ShowEffectNotification(param1,param2,param3);
               break;
            case POSITION_ActiveList:
            case POSITION_ActiveListSecondary:
               this.FWindowActiveList.ShowEffectNotification(param1,param2,param3);
               this.FWindowActiveListTwo.ShowEffectNotification(param1,param2,param3);
               break;
            case POSITION_Avatar:
               this.FWindowAvatar.ShowEffectNotification(param2,param3);
               break;
            case POSITION_MainFunction_Special:
               this.FWindowMainFunctionSpecial.ShowEffectNotification(param1,param2,param3);
         }
      }
      
      public function ChangeShortcutIcon(param1:uint, param2:uint) : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         switch(param1)
         {
            case POSITION_SecondaryFunction:
            case POSITION_SecondaryFunctionA:
            case POSITION_SecondaryFunctionB:
            case POSITION_SecondaryFunctionC:
            case POSITION_SecondaryFunctionD:
               this.FWindowSecondaryFunction.ChangeShortcutIcon(param1,param2);
         }
      }
      
      public function PerformShortcutHyperlinks(param1:Object, param2:uint, param3:uint, param4:Function, param5:Array) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:ByteArray = null;
         if(param2 == POSITION_ActiveList || param2 == POSITION_ActiveListSecondary)
         {
            _loc6_ = true;
         }
         else
         {
            _loc6_ = this.ShortcutVerification(param2,param3);
         }
         if(!_loc6_)
         {
            return;
         }
         if(param4 != null)
         {
            param4(param1);
         }
         _loc7_ = this.ProcessorParameters(param5);
         switch(param2)
         {
            case POSITION_MainFunction:
               this.ProcessorMainFunctionOnClick(param1,param3,param2,null,_loc7_);
               break;
            case POSITION_MainFunction_Special:
               this.ProcessorMainFunctionSpecialOnClick(param1,param3,param2,null,_loc7_);
               break;
            case POSITION_SecondaryFunction:
            case POSITION_SecondaryFunctionA:
            case POSITION_SecondaryFunctionB:
            case POSITION_SecondaryFunctionC:
            case POSITION_SecondaryFunctionD:
               this.ProcessorSecondaryFunctionOnClick(param1,param3,param2,null,_loc7_);
               break;
            case POSITION_Avatar:
               this.ShortcutAvaterHeadOperating(param1,param3,_loc7_);
               break;
            case POSITION_Constantly:
               this.ProcessorConstantlyOnClick(this,param2,param3);
               break;
            case POSITION_Map:
               this.ShortcutMapOperating(this,param3);
               break;
            case POSITION_Home:
               this.ProcessorHomeOnClick(param1,param3,_loc7_);
               break;
            case POSITION_NPC:
               this.ProcessorNPCOnClick(param1,param3,_loc7_);
               break;
            case POSITION_ActiveList:
            case POSITION_ActiveListSecondary:
               this.ProcessorActiveListOnClick(param1,param3,param2);
         }
      }
      
      public function EffectBaseGlowVIP(param1:Object, param2:Boolean) : void
      {
         if(this.FWindowAvatar != null)
         {
            this.FWindowAvatar.TerminationButtonEffect(param2);
         }
      }
      
      public function QueryShortcutCoordinate(param1:Object, param2:uint, param3:uint, param4:TQueryCoordinate) : void
      {
         switch(param2)
         {
            case POSITION_SecondaryFunction:
               this.FWindowSecondaryFunction.QueryShortcutCoordinate(param1,param3,param4);
               break;
            case POSITION_MainFunction:
               this.FWindowMainFunction.QueryShortcutCoordinate(param1,param3,param4);
               break;
            case POSITION_MainFunction_Special:
               this.FWindowMainFunctionSpecial.QueryShortcutCoordinate(param1,param3,param4);
         }
      }
      
      public function ShowHeroContorlPanle(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         this.FWindowHeroInfor.ShowHeroInforPanle(param1);
      }
      
      public function HideHeroContorlPanle() : void
      {
         this.FWindowHeroInfor.HideHeroInforPanle();
      }
      
      public function QuestUpdate() : void
      {
         this.FWindowQuest.QuestUpdate();
      }
      
      public function OpenActivityListStatusNotification() : void
      {
         this.FWindowActiveList.OpenStatusNotification();
         this.FWindowActiveListTwo.OpenStatusNotification();
      }
      
      public function BuyMilitary() : void
      {
         this.FWindowAvatar.BuyMilitary();
      }
      
      public function FollowAchievement(param1:TAchievementInfor) : void
      {
         this.FWindowAchievement.FollowAchievement(param1);
      }
      
      public function AchievementInforNotify(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = param1 as Boolean;
         this.FWindowSecondaryFunction.ShowEffectNotification(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Achievement,_loc2_);
      }
      
      public function BleachTrainInforNotify(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = param1 as Boolean;
         this.FWindowSecondaryFunction.ShowEffectNotification(CONST_SHORTCUTS.POSITION_SecondaryFunctionC,CONST_SHORTCUTS.TYPE_SecondaryFunctionC_BleachTrain,_loc2_);
      }
      
      public function FollowBleachTrain(param1:TBleachTrainData) : void
      {
         this.FWindowBleachTrain.FollowBelachTrain(param1);
      }
      
      public function IllusionAnchor() : Point
      {
         if(!this.Visible || this.FWindowActiveListTwo == null)
         {
            return null;
         }
         return this.FWindowActiveListTwo.IllusionAnchor();
      }
   }
}

