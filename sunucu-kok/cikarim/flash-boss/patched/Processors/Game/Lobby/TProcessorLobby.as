package Processors.Game.Lobby
{
   import Components.Controls.*;
   import Components.Standard.*;
   import Debugging.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Affairs.*;
   import Logics.Agent.SParametersCore;
   import Logics.BleachTrain.*;
   import Logics.Campaign.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HyperStrings.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.Purchases.*;
   import Processors.Game.*;
   import Processors.Game.Battle.*;
   import Processors.Game.Common.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Common.Effects.Transition.*;
   import Processors.Game.Lobby.ADBox.TProcessorADBox;
   import Processors.Game.Lobby.Account.*;
   import Processors.Game.Lobby.Achievement.*;
   import Processors.Game.Lobby.Activity.BRLikeUs.TProcessorBRLikeUs;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.TProcessorHDActivityChristmas;
   import Processors.Game.Lobby.Activity.HDActivityEquipmentShop.*;
   import Processors.Game.Lobby.Activity.HDActivityEspada.*;
   import Processors.Game.Lobby.Activity.HDActivityFund.TProcessorHDActivityFund;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Processors.Game.Lobby.Activity.HDActivityLimitBuy.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.TProcessorHDOS;
   import Processors.Game.Lobby.Activity.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.*;
   import Processors.Game.Lobby.Activity.HDActivitySwiftChange.*;
   import Processors.Game.Lobby.Activity.HDAnniversary2017.TProcessorHDAnniversary;
   import Processors.Game.Lobby.Activity.HDAstrology.TProcessorHDAstrology;
   import Processors.Game.Lobby.Activity.HDBigTurnTable.*;
   import Processors.Game.Lobby.Activity.HDBleachBag.TProcessorHDBleachBag;
   import Processors.Game.Lobby.Activity.HDBleachJigsaw.*;
   import Processors.Game.Lobby.Activity.HDBrushHappy.TProcessorHDBrushHappy;
   import Processors.Game.Lobby.Activity.HDCDK.*;
   import Processors.Game.Lobby.Activity.HDChess.*;
   import Processors.Game.Lobby.Activity.HDChildrenDay.TProcessorHDChildrenDay;
   import Processors.Game.Lobby.Activity.HDChristmas2015.TProcessorHDChristmas2015;
   import Processors.Game.Lobby.Activity.HDCircleTrial.TProcessorHDActivityCircleTrial;
   import Processors.Game.Lobby.Activity.HDCoolSummer.TProcessorHDCoolSummer;
   import Processors.Game.Lobby.Activity.HDDailyHero.TProcessorHDDailyHero;
   import Processors.Game.Lobby.Activity.HDDayBack.TProcessorHDDayBack;
   import Processors.Game.Lobby.Activity.HDDreamComeTrue.TProcessorHDDreamComeTrue;
   import Processors.Game.Lobby.Activity.HDDuanwujie.TProcessorHDDuanwujie;
   import Processors.Game.Lobby.Activity.HDEaster.TProcessorHDEaster;
   import Processors.Game.Lobby.Activity.HDEaster2016.TProcessorHDEaster2016;
   import Processors.Game.Lobby.Activity.HDEveryDayAward.TProcessorHDEveryDayAward;
   import Processors.Game.Lobby.Activity.HDFeedback.TProcessorHDFeedback;
   import Processors.Game.Lobby.Activity.HDFirstPay.*;
   import Processors.Game.Lobby.Activity.HDFirstPayGift.TProcessorHDFirstPayGift;
   import Processors.Game.Lobby.Activity.HDFoolsDay.TProcessorHDFoolsDay;
   import Processors.Game.Lobby.Activity.HDGallery.TProcessorHDGallery;
   import Processors.Game.Lobby.Activity.HDGambling.*;
   import Processors.Game.Lobby.Activity.HDGeneralSell.*;
   import Processors.Game.Lobby.Activity.HDGhostKingForg.TProcessorHDGhostKingForg;
   import Processors.Game.Lobby.Activity.HDGrowthPlan.TProcessorHDGrowthPlan;
   import Processors.Game.Lobby.Activity.HDHalloween.TProcessorHDActivityHalloween;
   import Processors.Game.Lobby.Activity.HDHalloween2016.TProcessorHDHalloween2016;
   import Processors.Game.Lobby.Activity.HDHerosMarket.TProcessorHerosMarket;
   import Processors.Game.Lobby.Activity.HDIceDragon.*;
   import Processors.Game.Lobby.Activity.HDJigSaw.*;
   import Processors.Game.Lobby.Activity.HDKingLegend.TProcessorHDActivityKingLegend;
   import Processors.Game.Lobby.Activity.HDKnifeChess.TProcessorHDKnifeChess;
   import Processors.Game.Lobby.Activity.HDLaborDay2016.TProcessorHDLaborDay2016;
   import Processors.Game.Lobby.Activity.HDLikeUs.*;
   import Processors.Game.Lobby.Activity.HDLottery.*;
   import Processors.Game.Lobby.Activity.HDLuckyJoy.*;
   import Processors.Game.Lobby.Activity.HDMaskFright.*;
   import Processors.Game.Lobby.Activity.HDNationalDay.TProcessorHDNationalDay;
   import Processors.Game.Lobby.Activity.HDNationalDay2017.TProcessorHDNationalDay2017;
   import Processors.Game.Lobby.Activity.HDNewHalloween.TProcessorHDNewHalloween;
   import Processors.Game.Lobby.Activity.HDNewServerDraw.TProcessorHDNewServerDraw;
   import Processors.Game.Lobby.Activity.HDNewYear2016.TProcessorHDNewYear2016;
   import Processors.Game.Lobby.Activity.HDNewYear2016Two.TProcessorHDNewYear2016Two;
   import Processors.Game.Lobby.Activity.HDNewYear2017.TProcessorHDNewYear2017;
   import Processors.Game.Lobby.Activity.HDNewYearDay.TProcessorHDNewYearDay;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.TProcessorHDNewYearSheep;
   import Processors.Game.Lobby.Activity.HDPartner.*;
   import Processors.Game.Lobby.Activity.HDPrivilegeLease.TprocessorHDPrivilegeLease;
   import Processors.Game.Lobby.Activity.HDPyramid.TProsessorHDPyramid;
   import Processors.Game.Lobby.Activity.HDRandCard.*;
   import Processors.Game.Lobby.Activity.HDRechargeSuit.*;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.TProcessorHDRushInSeireitei;
   import Processors.Game.Lobby.Activity.HDServerPay.*;
   import Processors.Game.Lobby.Activity.HDSoulBox.*;
   import Processors.Game.Lobby.Activity.HDSoulCarnival.TProcessorHDSoulCarnival;
   import Processors.Game.Lobby.Activity.HDSuperEgg.*;
   import Processors.Game.Lobby.Activity.HDTeamBuy.*;
   import Processors.Game.Lobby.Activity.HDThanksGivingDay2016.TProcessorHDThanksGivingDay2016;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.TProcessorHDThanksgivingDay;
   import Processors.Game.Lobby.Activity.HDTimeLimitTurntable.TProcessorHDTimeLimitTurntable;
   import Processors.Game.Lobby.Activity.HDTreasureAwake.*;
   import Processors.Game.Lobby.Activity.HDTreasurehunt.TProcessorHDTreasureHunt;
   import Processors.Game.Lobby.Activity.HDUniteTask.TProcessorHDUniteTask;
   import Processors.Game.Lobby.Activity.HDWorldCup.*;
   import Processors.Game.Lobby.Activity.KnifeHeroCollect.TProcessorHDKnifeHeroCollect;
   import Processors.Game.Lobby.ActivityManager.*;
   import Processors.Game.Lobby.Arena.*;
   import Processors.Game.Lobby.Backpack.*;
   import Processors.Game.Lobby.BlackMarket.*;
   import Processors.Game.Lobby.BleachAgent.TProcessorBleachAgent;
   import Processors.Game.Lobby.BleachDailyRecord.*;
   import Processors.Game.Lobby.BleachTrain.*;
   import Processors.Game.Lobby.ChangePlayerInfo.TProcessorChangeInfo;
   import Processors.Game.Lobby.Chat.*;
   import Processors.Game.Lobby.CheatChecker.*;
   import Processors.Game.Lobby.CityDefend.*;
   import Processors.Game.Lobby.CollectSoul.TProcessorCollectSoul;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Counter.*;
   import Processors.Game.Lobby.CrashJade.*;
   import Processors.Game.Lobby.CustomHero.TProcessorCustomHero;
   import Processors.Game.Lobby.DailyActivity.*;
   import Processors.Game.Lobby.DailyQuest.*;
   import Processors.Game.Lobby.DailyWelfare.*;
   import Processors.Game.Lobby.DialogMsg.*;
   import Processors.Game.Lobby.Effects.*;
   import Processors.Game.Lobby.EquipForge.TProcessorEquipForge;
   import Processors.Game.Lobby.ExpDuplicate.TProcessorExpDuplicate;
   import Processors.Game.Lobby.ExportPlayer.TProcessorExportPlayer;
   import Processors.Game.Lobby.FBBuyGold.TProcessorFBBuyGold;
   import Processors.Game.Lobby.FamilyMovie.*;
   import Processors.Game.Lobby.FightPet.*;
   import Processors.Game.Lobby.FreshGuide.*;
   import Processors.Game.Lobby.Friends.*;
   import Processors.Game.Lobby.GeneralStar.*;
   import Processors.Game.Lobby.GirlGame.*;
   import Processors.Game.Lobby.GongFuFight.*;
   import Processors.Game.Lobby.GongFuFightWindow.*;
   import Processors.Game.Lobby.HellButterfly.*;
   import Processors.Game.Lobby.HeroChange.*;
   import Processors.Game.Lobby.HeroCompanion.TProcessorHeroCompanion;
   import Processors.Game.Lobby.Heros.*;
   import Processors.Game.Lobby.HerosNew.TProcessorPartner;
   import Processors.Game.Lobby.Home.*;
   import Processors.Game.Lobby.Inspector.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.KillHeros.*;
   import Processors.Game.Lobby.KingChallenge.TProcessorKingChallenge;
   import Processors.Game.Lobby.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.KnifeSoul.*;
   import Processors.Game.Lobby.Mail.*;
   import Processors.Game.Lobby.MainScene.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Processors.Game.Lobby.MakeEquip.*;
   import Processors.Game.Lobby.Mall.*;
   import Processors.Game.Lobby.Mentorship.*;
   import Processors.Game.Lobby.ModuleLoader.*;
   import Processors.Game.Lobby.NightmareTrial.TProcessorNightmareTrialMain;
   import Processors.Game.Lobby.NightmareTrial.TProcessorNightmareTrialMap;
   import Processors.Game.Lobby.NijiaStar.*;
   import Processors.Game.Lobby.NpcDialog.*;
   import Processors.Game.Lobby.OfficeLady.*;
   import Processors.Game.Lobby.Organization.*;
   import Processors.Game.Lobby.OrganizationPointMap.TProcessorWindowOrgPointMap;
   import Processors.Game.Lobby.OrganizationalWar.*;
   import Processors.Game.Lobby.Ornament.*;
   import Processors.Game.Lobby.Pet.*;
   import Processors.Game.Lobby.PopTips.*;
   import Processors.Game.Lobby.Post.*;
   import Processors.Game.Lobby.ProfessionRefine.TUIProcessorProfessionRefine;
   import Processors.Game.Lobby.Protagonist.*;
   import Processors.Game.Lobby.Purchase.*;
   import Processors.Game.Lobby.QianKunARoll.*;
   import Processors.Game.Lobby.Quests.*;
   import Processors.Game.Lobby.Rebirth.TProcessorRebirth;
   import Processors.Game.Lobby.RelatedPartner.*;
   import Processors.Game.Lobby.ReveredBook.*;
   import Processors.Game.Lobby.SevenKing.*;
   import Processors.Game.Lobby.ShinobidoPractise.*;
   import Processors.Game.Lobby.Shortcuts.*;
   import Processors.Game.Lobby.Sign.*;
   import Processors.Game.Lobby.SkyTower.*;
   import Processors.Game.Lobby.Smelt.TProcessorSmelt;
   import Processors.Game.Lobby.Smithy.*;
   import Processors.Game.Lobby.Spaces.*;
   import Processors.Game.Lobby.SpecialCombatPower.*;
   import Processors.Game.Lobby.StoneShop.*;
   import Processors.Game.Lobby.SuperHero.*;
   import Processors.Game.Lobby.SuperMarket.*;
   import Processors.Game.Lobby.TacticalDeployment.*;
   import Processors.Game.Lobby.Talisman.*;
   import Processors.Game.Lobby.Tavern.*;
   import Processors.Game.Lobby.TeamBattle.*;
   import Processors.Game.Lobby.TokenShop.*;
   import Processors.Game.Lobby.TraitorAttack.*;
   import Processors.Game.Lobby.TreasureMap.*;
   import Processors.Game.Lobby.Unlock.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Lobby.VIP.*;
   import Processors.Game.Lobby.VainTravel.*;
   import Processors.Game.Lobby.VoidSoulWorld.TProcessorVoidSoulWorld;
   import Processors.Game.Lobby.Welcome.*;
   import Processors.Game.Lobby.WorldMapBleach.*;
   import Processors.Game.Lobby.WorldMapBleach.BarrierAutoBattle.*;
   import Processors.Game.Lobby.WorldMapBleach.LargeWorldMap.*;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.*;
   import Processors.Game.Lobby.YellowDiamon.*;
   import Processors.Game.Lobby.YellowVipBuyBox.*;
   import Processors.Game.Log.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.events.*;
   import flash.display.*;
   import flash.text.*;
   import flash.geom.Point;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.system.*;
   import flash.utils.*;
   
   use namespace LobbySpace;
   
   public class TProcessorLobby extends TProcessorGame
   {
      
      protected static const AFFAIRID_TimingWaitBattleActive:uint = 1;
      
      protected static const AFFAIRID_TimingWaitBattleLoading:uint = 2;
      
      protected static const AFFAIRID_ChatOptionsSetup:uint = 16777216;
      
      protected static const AFFAIRID_ChatOptionsApply:uint = 16777217;
      
      protected static const AFFAIRID_GameStateExternalize:uint = 33554432;
      
      protected static const AFFAIRID_CloseSocketLoading:uint = 50331649;
      
      protected static const TYPE_EFFECTTEXT:uint = 1;
      
      protected static const TYPE_DIALOGMSG:uint = 2;
      
      protected var FParameters:TLobbyParameters;
      
      protected var FChatOptions:TChatOptions;
      
      protected var FQueryBoolean:TQueryBoolean;
      
      protected var FMountPointPlate:TProcessorMountPoint;
      
      protected var FMountPointChat:TProcessorMountPoint;
      
      protected var FMountPointShortcuts:TProcessorMountPoint;
      
      protected var FMountPointShortcutsSpecial:TProcessorMountPoint;
      
      protected var FMountPointIcons:TProcessorMountPoint;
      
      protected var FMountPointBarrier:TProcessorMountPoint;
      
      protected var FMountPointBarrierAddition:TProcessorMountPoint;
      
      protected var FMountPointWindows:TProcessorMountPoint;
      
      protected var FMountPointOverview:TProcessorMountPoint;
      
      protected var FMountPointWindow:TProcessorMountPoint;
      
      protected var FMountPointLogicModule:TProcessorMountPoint;
      
      protected var FBarrier:TUIBarrier;
      
      protected var FBarrierAddition:TUIBarrier;
      
      protected var FProcessorAccount:TProcessorAccount;
      
      protected var FProcessorMainSceneTwo:TProcessorMainScene;
      
      protected var FProcessorTavern:TProcessorTavern;
      
      protected var FProcessorLargeWorldMap:TProcessorLargeWorldMap;
      
      protected var FProcessorArena:TProcessorArena;
      
      protected var FProcessorTreasureMap:TProcessorTreasureMap;
      
      protected var FOrganizationalWar:TProcessorOrganizationalWar;
      
      protected var FProcessorCityDefend:TProcessorCityDefend;
      
      protected var FProcessorFightPet:TProcessorFightPet;
      
      protected var FProcessorMonsterMap:TProcessorMonsterMap;
      
      protected var FProcessorWindowOrgPointMap:TProcessorWindowOrgPointMap;
      
      protected var FProcessorHome:TProcessorHome;
      
      protected var FProcessorTraitorAttack:TProcessorTraitorAttack;
      
      protected var FProcessorSevenKing:TProcessorSevenKing;
      
      protected var FProcessorNijiaStar:TProcessorNijiaStar;
      
      protected var FProcessorTeamBattle:TProcessorTeamBattle;
      
      protected var FProcessorSkyTower:TProcessorSkyTower;
      
      protected var FProcessorCrashJade:TProcessorCrashJade;
      
      protected var FProcessorGongFuFight:TProcessorPlateGongFuFight;
      
      protected var FProcessorPet:TProcessorPet;
      
      protected var FProcessorSuperHero:TProcessorSuperHero;
      
      protected var FProcessorVoidSoulWorld:TProcessorVoidSoulWorld;
      
      protected var FProcessorProtagonist:TProcessorProtagonist;
      
      protected var FProcessorHeros:TProcessorPartner;
      
      protected var FProcessorTacticalDeployment:TProcessorTacticalDeployment;
      
      protected var FProcessorBackpack:TProcessorBackpack;
      
      protected var FProcessorKnifeSoul:TProcessorKnifeSoul;
      
      protected var FProcessorSmithy:TProcessorSmithy;
      
      protected var FProcessorQuest:TProcessorQuest;
      
      protected var FProcessorMakeEquip:TProcessorMakeEquip;
      
      protected var FProcessorKillHeros:TProcessorKillHeros;
      
      protected var FProcessorGeneralStar:TProcessorGeneralStar;
      
      protected var FProcessorJade:TProcessorJade;
      
      protected var FProcessorTalisman:TProcessorTalisman;
      
      protected var FProcessorMail:TProcessorMail;
      
      protected var FProcessorHellButterfly:TProcessorHellButterfly;
      
      protected var FProcessorFriend:TProcessorFriend;
      
      protected var FProcessorVIP:TProcessorVIP;
      
      protected var FProcessorMall:TProcessorMall;
      
      protected var FProcessorDailySign:TProcessorDailySign;
      
      protected var FProcessorDailyQuest:TProcessorDailyQuest;
      
      protected var FProcessorPurchase:TProcessorPurchase;
      
      protected var FProcessorDailyActivity:TProcessorDailyActivity;
      
      protected var FProcessorOrganization:TProcessorOrganization;
      
      protected var FProcessorShinobidoPractise:TProcessorShinobidoPractise;
      
      protected var FProcessorNpcDialog:TProcessorNpcDialog;
      
      protected var FProcessorKnifeOfKillSoul:TProcessorKnifeOfKillSoul;
      
      protected var FProcessorBarrierAutoBattle:TProcessorBarrierAutoBattle;
      
      protected var FProcessorMentorship:TProcessorMentorship;
      
      protected var FProcessorQianKunARoll:TProcessorQianKunARoll;
      
      protected var FProcessorHDOS:TProcessorHDOS;
      
      protected var FProcessorHDActivityRecharge:TProcessorHDActivityRecharge;
      
      protected var FProcessorHDGiftBag:TProcessorHDGiftBag;
      
      protected var FProcessorHDFirstPay:TProcessorHDFirstPay;
      
      protected var FProcessorHDCDK:TProcessorHDCDK;
      
      protected var FProcessorFamilyMovie:TProcessorFamilyMovie;
      
      protected var FProcessorSuperMarket:TProcessorSuperMarket;
      
      protected var FProcessorOffceLady:TProcessorOfficeLady;
      
      protected var FProcessorAchievement:TProcessorAchievement;
      
      protected var FProcessorHDActivityFund:TProcessorHDActivityFund;
      
      protected var FProcessorHDActivitySuperTreature:TProcessorHDSuperTreasure;
      
      protected var FProcessorHDRechargeSuit:TProcessorHDRechargeSuit;
      
      protected var FProcessorHDEspada:TProcessorHDEspada;
      
      protected var FProcessorOrnamentStrengthen:TProcessorOrnamentStrengthen;
      
      protected var FProcessorHDMaskFright:TProcessorHDMaskFright;
      
      protected var FProcessorGirlGame:TProcessorGirlGame;
      
      protected var FProcessorHDEquipmentShop:TProcessorHDEquipmentShop;
      
      protected var FProcessorWelcome:TProcessorWelcome;
      
      protected var FProcessorHDSoulBox:TProcessorHDSoulBox;
      
      protected var FProcessorReveredBook:TProcessorReveredBook;
      
      protected var FProcessorHDGambling:TProcessorHDGambling;
      
      protected var FProcessorHDLimitBuy:TProcessorHDLimitBuy;
      
      protected var FProcessorHDIceHeros:TProcessorHDGeneralSellHeros;
      
      protected var FProcessorHDIceDragon:TProcessorHDIceDragon;
      
      protected var FProcessorHDSuperEggs:TProcessorHDSuperEggs;
      
      protected var FProcessorHDTeamBuy:TProcessorHDTeamBuy;
      
      protected var FProcessorHDJigsaw:TProcessorHDJigSaw;
      
      protected var FProcessorHDBigTurnTable:TProcessorHDBigTurnTable;
      
      protected var FProcessorHDServerPay:TProcessorHDServerPay;
      
      protected var FProcessorHDRandCard:TProcessorHDRandCard;
      
      protected var FProcessorHDTreasureAwake:TProcessorHDTreasureAwake;
      
      protected var FProcessorHeroChange:TProcessorHeroChange;
      
      protected var FProcessorBlackMarket:TProcessorBlackMarket;
      
      protected var FProcessorExpDuplicate:TProcessorExpDuplicate;
      
      protected var FProcessorExportPlayer:TProcessorExportPlayer;
      
      protected var FProcessorBleachDailyRecord:TProcessorBleachDailyRecord;
      
      protected var FProcessorBleachTrain:TProcessorBleachTrain;
      
      protected var FProcessorGongFuFightApply:TProcessorGongFuFightWindow;
      
      protected var FProcessorTokenShop:TProcessorTokenShop;
      
      protected var FProcessorStoneShop:TProcessorStoneShop;
      
      protected var FProcessorDailyWelfare:TProcessorDailyWelfare;
      
      protected var FProcessorBleachJigsaw:TProcessorBleachJigsaw;
      
      protected var FProcessorBleachJigsawOld:TProcessorBleachJigsawOld;
      
      protected var FProcessorChess:TProcessorChess;
      
      protected var FProcessorWorldCup:TProcessorWorldCup;
      
      protected var FProcessorHerosMarket:TProcessorHerosMarket;
      
      protected var FProcessorLottery:TProcessorHDLottery;
      
      protected var FProcessorLikeUs:TProcessorLikeUs;
      
      protected var FProcessorBRLikeUs:TProcessorBRLikeUs;
      
      protected var FProcessorPartner:TProcessorHDPartner;
      
      protected var FProcessorLuckyJoy:TProcessorHDLuckyJoy;
      
      protected var FProcessorVainTravel:TProcessorVainTravel;
      
      protected var FProcessorSpecialCombatPower:TProcessorSpecialCombatPower;
      
      protected var FProcessorSwiftChange:TProcessorHDSwiftChange;
      
      protected var FProcessorPrivilegeLease:TprocessorHDPrivilegeLease;
      
      protected var FProcessorHDHalloween:TProcessorHDActivityHalloween;
      
      protected var FProcessorHDCircleTrial:TProcessorHDActivityCircleTrial;
      
      protected var FTimeMalls:Vector.<InterfaceTimeMarket>;
      
      protected var FProcessorHDKingLegend:TProcessorHDActivityKingLegend;
      
      protected var FProcessorHDChristmas:TProcessorHDActivityChristmas;
      
      protected var FProcessorFBBuyGold:TProcessorFBBuyGold;
      
      protected var FProcessorHDNewYearDay:TProcessorHDNewYearDay;
      
      protected var FProcessorHDUniteTask:TProcessorHDUniteTask;
      
      protected var FProcessorHDDreams:TProcessorHDDreamComeTrue;
      
      protected var FProcessorHDNewYearSheep:TProcessorHDNewYearSheep;
      
      protected var FProcessorHDFeedback:TProcessorHDFeedback;
      
      protected var FProcessorHDGoldTurntable:TProcessorHDTimeLimitTurntable;
      
      protected var FProcessorHeroCompanion:TProcessorHeroCompanion;
      
      protected var FProcessorHDDayBack:TProcessorHDDayBack;
      
      protected var FProcessorHDGrowthPlan:TProcessorHDGrowthPlan;
      
      protected var FProcessorHDEaster:TProcessorHDEaster;
      
      protected var FProcessorHDBleachBag:TProcessorHDBleachBag;
      
      protected var FProcessorHDGallery:TProcessorHDGallery;
      
      protected var FProcessorHDDailyHero:TProcessorHDDailyHero;
      
      protected var FProcessorHDPyramid:TProsessorHDPyramid;
      
      protected var FProcessorHDRushInSeireitei:TProcessorHDRushInSeireitei;
      
      protected var FProcessorHDAstrology:TProcessorHDAstrology;
      
      protected var FProcessorHDKnifeHeroCollect:TProcessorHDKnifeHeroCollect;
      
      protected var FProcessorHDCoolSummer:TProcessorHDCoolSummer;
      
      protected var FProcessorHDEveryDayAward:TProcessorHDEveryDayAward;
      
      protected var FProcessorRelatedPartner:TProcessorRelatedPartner;
      
      protected var FProcessorRelatedAssistance:TProcessorRelatedAssistance;
      
      protected var FProcessorNightmareTrial:TProcessorNightmareTrialMain;
      
      protected var FProcessorNightmareMap:TProcessorNightmareTrialMap;
      
      protected var FProcessorHDFirstPayBag:TProcessorHDFirstPayGift;
      
      protected var FProcessorHDBrushHappy:TProcessorHDBrushHappy;
      
      protected var FProcessorBleachAgent:TProcessorBleachAgent;
      
      protected var FProcessorRebirth:TProcessorRebirth;
      
      protected var FProcessorKingChallenge:TProcessorKingChallenge;
      
      protected var FProcessorHDNewServerDraw:TProcessorHDNewServerDraw;
      
      protected var FProcessorHDNewHallowen:TProcessorHDNewHalloween;
      
      protected var FProcessorHDThanksgivingDay:TProcessorHDThanksgivingDay;
      
      protected var FProcessorHDChristmas2015:TProcessorHDChristmas2015;
      
      protected var FProcessorHDNewYear2016:TProcessorHDNewYear2016;
      
      protected var FProcessorHDNewYear2016Two:TProcessorHDNewYear2016Two;
      
      protected var FProcessorHDEaster2016:TProcessorHDEaster2016;
      
      protected var FProcessorHDGhostKingForg:TProcessorHDGhostKingForg;
      
      protected var FProcessorHDLaborDay2016:TProcessorHDLaborDay2016;
      
      protected var FProcessorHDDuanwujie2016:TProcessorHDDuanwujie;
      
      protected var FProcessorHDTreasureHunt:TProcessorHDTreasureHunt;
      
      protected var FProcessorHDSoulCarnival:TProcessorHDSoulCarnival;
      
      protected var FProcessorHDKnifeChess:TProcessorHDKnifeChess;
      
      protected var FProcessorHDNationalDay:TProcessorHDNationalDay;
      
      protected var FProcessorHDHalloween2016:TProcessorHDHalloween2016;
      
      protected var FProcessorHDThanksGivingDay2016:TProcessorHDThanksGivingDay2016;
      
      protected var FProcessorHDNewYear2017:TProcessorHDNewYear2017;
      
      protected var FProcessorHDFoolsDay:TProcessorHDFoolsDay;
      
      protected var FProcessorHDChildrenDay:TProcessorHDChildrenDay;
      
      protected var FProcessorHDAnniversary:TProcessorHDAnniversary;
      
      protected var FProcessorHDNationalDay2017:TProcessorHDNationalDay2017;
      
      protected var FProcessorYellowDiamon:TProcessorYellowDiamon;
      
      protected var FProcessorYellowDiamondBuyGold:TProcessorYellowVipBuyGold;
      
      protected var FProcessorChangeInfo:TProcessorChangeInfo;
      
      protected var FProcessorCustomHero:TProcessorCustomHero;
      
      protected var FProcessorCollectSoul:TProcessorCollectSoul;
      
      protected var FProcessorEquipForge:TProcessorEquipForge;
      
      protected var FProcessorSmelt:TProcessorSmelt;
      
      protected var FProcessorShortcuts:TProcessorShortcuts;
      
      protected var FProcessorChat:TProcessorChat;
      
      protected var FProcessorPopTips:TProcessorPopTips;
      
      protected var FProcessorADBox:TProcessorADBox;
      
      protected var FProcessorFreshGuide:TProcessorFreshGuide;
      
      protected var FProcessorPost:TProcessorPost;
      
      protected var FProcessorCheatChecker:TProcessorCheatChecker;
      
      protected var FProcessorCounter:TProcessorCounter;
      
      protected var FProcessorActivityManager:TProcessorActivityManager;
      
      protected var FProcessorInspector:TProcessorInspector;
      
      protected var FProcessorModuleLoader:TProcessorModuleLoader;
      
      protected var FProcessorUnlock:TProcessorUnlock;
      
      protected var FProcessorLog:TProcessorLog;
      
      protected var FProcessorEffect:TProcessorLobbyEffect;
      
      protected var FEffectTransition:TEffectTransition;
      
      protected var FProcessorDialogMsg:TProcessorDialogMsg;
      
      protected var FProcessorsPlate:Vector.<TProcessorLobbyPlate>;
      
      protected var FProcessorsWindows:Vector.<TProcessorLobbyWindows>;
      
      protected var FProcessorPlateActive:TProcessorLobbyPlate;
      
      protected var FProcessorWindowsActive:TProcessorLobbyWindows;
      
      protected var FUIProcessorProfessionRefine:TUIProcessorProfessionRefine;
      
      protected var FOnLoadFollowUp:Function;
      
      protected var FOnSetupBattle:Function;
      
      protected var FOnSetupMiniBattle:Function;
      
      protected var FOnQueryBattleActive:Function;
      
      protected var FOnQueryBattleLoading:Function;
      
      protected var FOnPurchaseQuery:Function;
      
      protected var FOnMarquee:Function;
      
      protected var FOnLogout:Function;
      
      protected var FOnLogin:Function;
      
      protected var FOnLoginDirSever:Function;
      
      protected var FOnSetBattleBackground:Function;
      
      protected var FOnCheckPlot:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnSetBattlePacket:Function;
      
      protected var FOnAntiAddiction:Function;
      
      protected var FOnCloseSocketLoading:Function;
      
      protected var FOnUnLoadBattleResources:Function;
      
      public function TProcessorLobby(param1:TUIComponent)
      {
         super(param1);
         this.FParameters = new TLobbyParameters();
         this.FChatOptions = new TChatOptions();
         this.FQueryBoolean = new TQueryBoolean();
         this.ConstructMountPoints();
         this.FParameters.ActuatorBarrier.OnUpdate = this.ActuatorBarrierOnUpdate;
         this.FParameters.ActuatorBarrier.OnUpdateAddition = this.ActuatorBarrierOnUpdateAddition;
         this.FParameters.CoerceProperties(this.FMountPointIcons,this.FMountPointWindow);
         this.ConstructBarrier();
         this.ConstructBarrierAddition();
         this.ConstructProcessorFreshGuide();
         this.ConstructProcessorsPlate();
         this.ConstructProcessorsWindows();
         this.ConstructProcessorShortcuts();
         this.IllusionConstruct();
         this.ConstructProcessorChat();
         this.ConstructProcessorPopTips();
         this.ConstructProcessorLogicModule();
         this.ConstructProcessorsOverview();
         this.ConstructADBox();
         this.FProcessorDialogMsg = new TProcessorDialogMsg(this);
         this.FEffectTransition = new TEffectTransition(this);
         this.FProcessorEffect = new TProcessorLobbyEffect(this);
         this.ProcessorPlateSwitch(null);
         this.ProcessorWindowsSwitch(null);
         SLogicsCore.QuestAutoSearchWay.OnGotoNpc = this.FProcessorMainSceneTwo.GotoNpc;
         SLogicsCore.QuestAutoSearchWay.OnEnterMonsterMap = this.ProcessorShortcutsOnEnterLargeWorldMap;
         SLogicsCore.QuestAutoSearchWay.OnEnterMainCity = this.ProcessorsOnEnterTown;
         SLogicsCore.QuestAutoSearchWay.OnShortcutHyperlinks = this.ProcessorShortcutHyperlinks;
         SLogicsCore.QuestAutoSearchWay.OnEnterHome = this.ProcessorShortcutsOnHome;
         SToolReward.OnEffectText = this.ProcessorsOnEffectText;
         SUtilityHyperLink.OnHyperLink = this.ProcessorShortcutHyperlinks;
         SUtilityHyperLink.OnHyperLinkEx = this.ProcessorHyperlinks;
         TUtilityLobby.OnCreateKnifeOfSkillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         FResourcesState = RESOURCESSTATE_Ready;
      }
      
      protected function ConstructMountPoints() : void
      {
         this.FMountPointPlate = new TProcessorMountPoint(this);
         this.FMountPointShortcuts = new TProcessorMountPoint(this);
         this.FMountPointChat = new TProcessorMountPoint(this);
         this.FMountPointIcons = new TProcessorMountPoint(this);
         this.FMountPointShortcutsSpecial = new TProcessorMountPoint(this);
         this.FMountPointBarrier = new TProcessorMountPoint(this);
         this.FMountPointWindows = new TProcessorMountPoint(this);
         this.FMountPointBarrierAddition = new TProcessorMountPoint(this);
         this.FMountPointOverview = new TProcessorMountPoint(this);
         this.FMountPointWindow = new TProcessorMountPoint(this);
         this.FMountPointLogicModule = new TProcessorMountPoint(this);
      }
      
      protected function ConstructProcessorsPlate() : void
      {
         var _loc1_:uint = 0;
         this.FProcessorAccount = new TProcessorAccount(this.FMountPointPlate);
         this.FProcessorAccount.Visible = false;
         this.FProcessorAccount.OnLoadFollowUp = this.ProcessorOnLoadFollowUp;
         this.FProcessorAccount.OnStartFreshGuide = this.ProcessorsOnStartFreshGuide;
         this.FProcessorAccount.OnUserUpdateBaseInfo = this.ProcessorAccountOnUserUpdateBaseInfo;
         this.FProcessorAccount.OnUpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorAccount.OnUpdateVipInfo = this.ProcessorAccountOnUserUpdateVipInfo;
         this.FProcessorAccount.OnUserUpdateStrengthenCD = this.ProcessorAccountOnUserUpdateStrengthenCD;
         this.FProcessorAccount.OnUserLevelUpEffect = this.ProcessorAccountOnUserLevelUpEffect;
         this.FProcessorAccount.OnUserLevelUp = this.ProcessorAccountOnUserLevelUp;
         this.FProcessorAccount.OnCharacterBaseAttributeRet = this.ProcessorOnCharacterBaseAttributeRet;
         this.FProcessorAccount.OnInitMilitaryInfor = this.ProcessorOnLoadMilitaryInfor;
         this.FProcessorAccount.OnInitQuests = this.ProcessorOnInitQuests;
         this.FProcessorAccount.OnUpdataSeverTime = this.ProcessorInspectorUpdataSeverTime;
         this.FProcessorAccount.OnCheckAntiAddiction = this.ProcessorOnCheckAntiAddiction;
         this.FProcessorAccount.OnInitAllNpc = this.ProcessorInitAllNpc;
         this.FProcessorAccount.OnInitMall = this.ProcessorOnInitMall;
         this.FProcessorAccount.OnInitVip = this.ProcessorOnInitVip;
         this.FProcessorAccount.OnInitAddHeroSlotTime = this.ProcessorOnInitAddHeroNum;
         this.FProcessorAccount.OnEnterFamily = this.ProcessorOnEnterFamily;
         this.FProcessorAccount.OnUpdateAllHeroEquipmentMountedSuitCount = this.ProcessorAllHeroEquipmentMountedSuitCount;
         this.FProcessorAccount.OnEnabledCheckSpeedUp = this.ProcessorOnEnabledCheckSpeedUp;
         this.FProcessorAccount.OnCloseSocketLoading = this.ProcessorOnCloseSocketLoading;
         this.FProcessorAccount.OnDailyQusetInfoReq = this.ProcessorOnDailyQusetInfoReq;
         this.FProcessorAccount.OnActivityInfoReq = this.ProcessorOnActiveInfoReq;
         this.FProcessorAccount.OnHeroQualityChange = this.ProcessorOnHeroQualityChange;
         this.FProcessorAccount.OnMilitaryInfoReq = this.ProcessorOnMilitaryInfoReq;
         this.FProcessorAccount.OnLoadAchievementInfor = this.ProcessorOnLoadAchievementInfor;
         this.FProcessorAccount.OnLoadBleachTrainInfor = this.ProcessorOnLoadBleachTrainInfor;
         this.FProcessorAccount.OnLoadDailyWelfareInfor = this.ProcessorOnLoadDailyWelfareInfor;
         this.FProcessorAccount.OnInitHeroChangeInfor = this.ProcessorOnInitHeroChangeInfor;
         this.FProcessorMainSceneTwo = new TProcessorMainScene(this.FMountPointPlate,this.FParameters);
         this.FProcessorMainSceneTwo.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMainSceneTwo.OnOpenNpcDialog = this.ProcessorOnShowNpcDialog;
         this.FProcessorMainSceneTwo.OnOpenWorldMap = this.ProcessorShortcutsOnEnterLargeWorldMap;
         this.FProcessorMainSceneTwo.ShowHeroContorlPanle = this.ProcessorOnShowHeroInforPanle;
         this.FProcessorMainSceneTwo.HideHeroContorlPanle = this.ProcessorOnHideHeroInforPanle;
         this.FProcessorMainSceneTwo.OnProcessorCheckPopTips = this.ProcessorOnCheckPopTips;
         this.FProcessorMainSceneTwo.OnAutoSearchWayEffect = this.ProcessorAccountOnAutoSearchWayEffect;
         this.FProcessorMainSceneTwo.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.MainSceneShortcutsPosition;
         this.FProcessorMainSceneTwo.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.MainSceneShortcutsLocation;
         if(SParametersCore.IfTXGame)
         {
            _loc1_ = uint(CONST_SHORTCUTS_SHOW.GetIndexByPosAndLoc(CONST_SHORTCUTS_SHOW.MainSceneShortcutsPosition,CONST_SHORTCUTS_SHOW.MainSceneShortcutsLocation,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_YellowDiamond));
            CONST_SHORTCUTS_SHOW.MainSceneShortcutsLocation[_loc1_] = CONST_SHORTCUTS.TYPE_SecondaryFunction_TXYellowDiamond;
         }
         this.FProcessorMonsterMap = new TProcessorMonsterMap(this.FMountPointPlate,this.FParameters);
         this.FProcessorMonsterMap.Visible = false;
         this.FProcessorMonsterMap.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorMonsterMap.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorMonsterMap.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMonsterMap.OnBackLargeWorldMap = this.ProcessorOnBackLargeWorld;
         this.FProcessorMonsterMap.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorMonsterMap.OnProcessorCheckPlot = this.ProcessorOnCheckPlot;
         this.FProcessorMonsterMap.OnAutoBattle = this.ProcessorOnBarrierAutoBattle;
         this.FProcessorMonsterMap.OnPassInstanceAutoBattle = this.ProcessorOnPassInstanceAutoBattle;
         this.FProcessorMonsterMap.OnMonsterMainUISet = this.ProcessorOnMonsterMainUISet;
         this.FProcessorMonsterMap.OnAddPopTips = this.ProcessorOnAddPopTips;
         this.FProcessorMonsterMap.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.MonsterMapShortcutsPosition;
         this.FProcessorMonsterMap.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.MonsterMapShortcutsLocation;
         this.FProcessorWindowOrgPointMap = new TProcessorWindowOrgPointMap(this.FMountPointPlate,this.FParameters);
         this.FProcessorWindowOrgPointMap.Visible = false;
         this.FProcessorWindowOrgPointMap.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorWindowOrgPointMap.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorWindowOrgPointMap.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorWindowOrgPointMap.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorWindowOrgPointMap.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorWindowOrgPointMap.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.OrgPointMapShortcutsPosition;
         this.FProcessorWindowOrgPointMap.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.OrgPointMapShortcutsLocation;
         this.FProcessorTavern = new TProcessorTavern(this.FMountPointPlate,this.FParameters);
         this.FProcessorTavern.visible = false;
         this.FProcessorTavern.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTavern.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTavern.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTavern.OnUpdatePopTipsModes = this.ProcessorsOnUpdatePopTipsModes;
         this.FProcessorTavern.OnReturnTown = this.ProcessorsOnReturnTown;
         this.FProcessorTavern.OnEffectSoul = this.ProcessorOnEffectSoul;
         this.FProcessorTavern.OnUpdateHerosBaseAttributeReq = this.ProcessorOnHeroInitBaseAttribute;
         this.FProcessorTavern.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.TavernShortcutsPosition;
         this.FProcessorTavern.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.TavernShortcutsLocation;
         this.FProcessorArena = new TProcessorArena(this.FMountPointPlate,this.FParameters);
         this.FProcessorArena.Visible = false;
         this.FProcessorArena.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorArena.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorArena.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorArena.OnReturnTown = this.ProcessorsOnReturnTown;
         this.FProcessorArena.OnUpdatePopTipsModes = this.ProcessorsOnUpdatePopTipsModes;
         this.FProcessorArena.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorArena.OnSetBattlePacket = this.ProcessorOnSetBattlePacket;
         this.FProcessorArena.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorArena.OnShowOtherHeroInfor = this.ProcessorOnShowHeroInfor;
         this.FProcessorArena.OnSetBattleBackground = this.ProcessorOnSetBattleBackground;
         this.FProcessorArena.ShowShortcutsPosition = null;
         this.FProcessorArena.ShowShortcutsLocation = null;
         this.FProcessorTreasureMap = new TProcessorTreasureMap(this.FMountPointPlate,this.FParameters);
         this.FProcessorTreasureMap.Visible = false;
         this.FProcessorTreasureMap.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTreasureMap.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTreasureMap.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTreasureMap.OnReturnMainScene = this.ProcessorsOnReturnTown;
         this.FProcessorTreasureMap.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorTreasureMap.OnSetBattlePacket = this.ProcessorOnSetBattlePacket;
         this.FProcessorTreasureMap.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorTreasureMap.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorTreasureMap.ShowShortcutsPosition = null;
         this.FProcessorTreasureMap.ShowShortcutsLocation = null;
         this.FOrganizationalWar = new TProcessorOrganizationalWar(this.FMountPointPlate,this.FParameters);
         this.FOrganizationalWar.Visible = false;
         this.FOrganizationalWar.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FOrganizationalWar.OnEffectText = this.ProcessorsOnEffectText;
         this.FOrganizationalWar.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FOrganizationalWar.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FOrganizationalWar.GetOrganizationalName = this.ProcessorOnOrgGetNameFromID;
         this.FOrganizationalWar.SetDailyActivityStatus = this.ProcessorOnSetOrgActivityEnd;
         this.FOrganizationalWar.ActivityStatusCallBack = this.ProcessorOnSetOrgActivityEnd;
         this.FOrganizationalWar.GetOrgainizatinoLevel = this.ProcessorOnOrgGetActivityLevelByType;
         this.FOrganizationalWar.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.OrganizationWarShortcutsPosition;
         this.FOrganizationalWar.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.OrganizationWarShortcutsLocation;
         this.FProcessorCityDefend = new TProcessorCityDefend(this.FMountPointPlate,this.FParameters);
         this.FProcessorCityDefend.Visible = false;
         this.FProcessorCityDefend.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorCityDefend.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorCityDefend.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorCityDefend.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorCityDefend.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorCityDefend.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorCityDefend.OnSetDailyActivityStatus = this.ProcessorOnSetOrgActivityEnd;
         this.FProcessorCityDefend.OnUnLoadBattleResources = this.ProcessorOnUnLoadBattleResources;
         this.FProcessorCityDefend.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.CityDefendShortcutsPosition;
         this.FProcessorCityDefend.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.CityDefendShortcutsLocation;
         this.FProcessorFightPet = new TProcessorFightPet(this.FMountPointPlate,this.FParameters);
         this.FProcessorFightPet.Visible = false;
         this.FProcessorFightPet.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorFightPet.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorFightPet.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorFightPet.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorFightPet.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorFightPet.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorFightPet.OnSetBattleBackground = this.ProcessorOnSetBattleBackground;
         this.FProcessorFightPet.OnUnLoadBattleResources = this.ProcessorOnUnLoadBattleResources;
         this.FProcessorFightPet.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.FightPetShortcutsPosition;
         this.FProcessorFightPet.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.FightPetShortcutsLocation;
         this.FProcessorTraitorAttack = new TProcessorTraitorAttack(this.FMountPointPlate,this.FParameters);
         this.FProcessorTraitorAttack.Visible = false;
         this.FProcessorTraitorAttack.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTraitorAttack.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTraitorAttack.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTraitorAttack.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorTraitorAttack.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorTraitorAttack.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorTraitorAttack.OnSetBattleBackground = this.ProcessorOnSetBattleBackground;
         this.FProcessorTraitorAttack.OnUnLoadBattleResources = this.ProcessorOnUnLoadBattleResources;
         this.FProcessorTraitorAttack.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.TraitorAttackShortcutsPosition;
         this.FProcessorTraitorAttack.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.TraitorAttackShortcutsLocation;
         this.FProcessorHome = new TProcessorHome(this.FMountPointPlate,this.FParameters);
         this.FProcessorHome.Visible = false;
         this.FProcessorHome.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHome.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHome.OnEffectHtmlText = this.ProcessorsOnEffectHtmlText;
         this.FProcessorHome.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHome.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorHome.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorHome.OnEnterBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorHome.OnHomeResetNtf = this.ProcessorOnHomeResetNtf;
         this.FProcessorHome.OnAddFriend = this.ProcessorOnInterpersonalRelationshipsReq;
         this.FProcessorHome.OnEffectSilverCoin = this.ProcessorOnEffectSilverCoin;
         this.FProcessorHome.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorHome.ShowShortcutsPosition = null;
         this.FProcessorHome.ShowShortcutsLocation = null;
         this.FProcessorNijiaStar = new TProcessorNijiaStar(this.FMountPointPlate,this.FParameters);
         this.FProcessorNijiaStar.Visible = false;
         this.FProcessorNijiaStar.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorNijiaStar.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorNijiaStar.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorNijiaStar.OnReturnTown = this.ProcessorsOnReturnTown;
         this.FProcessorNijiaStar.GetKingSoulOnClick = this.ProcessorGetKingSoulonClick;
         this.FProcessorNijiaStar.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorNijiaStar.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.NijiaStarShortcutsPosition;
         this.FProcessorNijiaStar.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.NijiaStarShortcutsLocation;
         this.FProcessorSevenKing = new TProcessorSevenKing(this.FMountPointPlate,this.FParameters);
         this.FProcessorSevenKing.Visible = false;
         this.FProcessorSevenKing.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSevenKing.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSevenKing.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSevenKing.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorSevenKing.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorSevenKing.OnReturnTown = this.ProcessorsOnReturnTown;
         this.FProcessorSevenKing.OnToStarsMap = this.ProcessorOnToStarsMap;
         this.FProcessorSevenKing.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.SevenKingShortcutsPosition;
         this.FProcessorSevenKing.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.SevenKingShortcutsLocation;
         this.FProcessorTeamBattle = new TProcessorTeamBattle(this.FMountPointPlate,this.FParameters);
         this.FProcessorTeamBattle.Visible = false;
         this.FProcessorTeamBattle.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTeamBattle.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTeamBattle.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTeamBattle.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorTeamBattle.OnWhisper = this.ProcessorsOnRequestWhisper;
         this.FProcessorTeamBattle.OnAddFriend = this.ProcessorOnInterpersonalRelationshipsReq;
         this.FProcessorTeamBattle.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorTeamBattle.OnStartMiniBattleNtf = this.ProcessorOnStartMiniBattleNtf;
         this.FProcessorTeamBattle.OnTeamBattleMainUISet = this.ProcessorOnTeamBattleMainUISet;
         this.FProcessorTeamBattle.OnActivatingChannel = this.ProcessorOnActivatingChannel;
         this.FProcessorTeamBattle.OnEffectTeamBattlePvp = this.ProcessorShortcutEffectNotification;
         this.FProcessorTeamBattle.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.TeamBattleShortcutsPosition;
         this.FProcessorTeamBattle.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.TeamBattleShortcutsLocation;
         this.FProcessorSkyTower = new TProcessorSkyTower(this.FMountPointPlate,this.FParameters);
         this.FProcessorSkyTower.Visible = false;
         this.FProcessorSkyTower.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSkyTower.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSkyTower.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSkyTower.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorSkyTower.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorSkyTower.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorSkyTower.ShowShortcutsPosition = null;
         this.FProcessorSkyTower.ShowShortcutsLocation = null;
         this.FProcessorGongFuFight = new TProcessorPlateGongFuFight(this.FMountPointPlate,this.FParameters);
         this.FProcessorGongFuFight.Visible = false;
         this.FProcessorGongFuFight.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorGongFuFight.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorGongFuFight.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorGongFuFight.OnReturnMainScene = this.ProcessorsOnReturnTown;
         this.FProcessorGongFuFight.OnSendMessageToWindow = this.ProcessorsOnSendMessageToWindow;
         this.FProcessorGongFuFight.OnOpenGongFuFightWindow = this.ProcessorsOnOpenGongFuFightWindow;
         this.FProcessorGongFuFight.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorGongFuFight.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorGongFuFight.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorGongFuFight.OnOpenTokenShop = this.ProcessorShortcutsOnTokenShop;
         this.FProcessorGongFuFight.OnOpenStoneShop = this.ProcessorShortcutsOnStoneShop;
         this.FProcessorGongFuFight.OnSetBattlePacket = this.ProcessorOnSetBattlePacket;
         this.FProcessorGongFuFight.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.GongfuShortcutsPosition;
         this.FProcessorGongFuFight.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.GongfuShortcutsLocation;
         this.FProcessorCrashJade = new TProcessorCrashJade(this.FMountPointPlate,this.FParameters);
         this.FProcessorCrashJade.Visible = false;
         this.FProcessorCrashJade.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorCrashJade.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorCrashJade.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorCrashJade.OnReturnMainScene = this.ProcessorsOnReturnTown;
         this.FProcessorCrashJade.OnLoadLog = this.ProcessorOnLoadLog;
         this.FProcessorCrashJade.ShowShortcutsPosition = null;
         this.FProcessorCrashJade.ShowShortcutsLocation = null;
         this.FProcessorCrashJade.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorCrashJade.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorPet = new TProcessorPet(this.FMountPointPlate,this.FParameters);
         this.FProcessorPet.Visible = false;
         this.FProcessorPet.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorPet.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorPet.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorPet.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorPet.ShowShortcutsPosition = null;
         this.FProcessorPet.ShowShortcutsLocation = null;
         this.FProcessorPet.OnUpdateHeroFightNum = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorSuperHero = new TProcessorSuperHero(this.FMountPointPlate,this.FParameters);
         this.FProcessorSuperHero.Visible = false;
         this.FProcessorSuperHero.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSuperHero.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSuperHero.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSuperHero.ShowShortcutsPosition = null;
         this.FProcessorSuperHero.ShowShortcutsLocation = null;
         this.FProcessorNightmareMap = new TProcessorNightmareTrialMap(this.FMountPointPlate,this.FParameters);
         this.FProcessorNightmareMap.Visible = false;
         this.FProcessorNightmareMap.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorNightmareMap.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorNightmareMap.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorNightmareMap.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorNightmareMap.OnShowHeroDescription = this.ProcessorOnShowHeroDescription;
         this.FProcessorNightmareMap.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.NightmareMapShortcutsPosition;
         this.FProcessorNightmareMap.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.NightmareMapShortcutsLocation;
         this.FProcessorKingChallenge = new TProcessorKingChallenge(this.FMountPointPlate,this.FParameters);
         this.FProcessorKingChallenge.Visible = false;
         this.FProcessorKingChallenge.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorKingChallenge.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorKingChallenge.OnEnterTown = this.ProcessorsOnReturnTown;
         this.FProcessorKingChallenge.OnSetKingChallengeNpc = this.ProcessorOnKingChallengeNpc;
         this.FProcessorVoidSoulWorld = new TProcessorVoidSoulWorld(this.FMountPointPlate,this.FParameters);
         this.FProcessorVoidSoulWorld.Visible = false;
         this.FProcessorVoidSoulWorld.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorVoidSoulWorld.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorVoidSoulWorld.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorVoidSoulWorld.OnReturnMainScene = this.VoidSoulWorldReturn;
         this.FProcessorVoidSoulWorld.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorVoidSoulWorld.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorVoidSoulWorld.ShowShortcutsPosition = CONST_SHORTCUTS_SHOW.VoidSoulWorldShortcutsPosition;
         this.FProcessorVoidSoulWorld.ShowShortcutsLocation = CONST_SHORTCUTS_SHOW.VoidSoulWorldShortcutsLocation;
         this.FProcessorsPlate = Vector.<TProcessorLobbyPlate>([this.FProcessorMainSceneTwo,this.FProcessorTavern,this.FProcessorArena,this.FProcessorTreasureMap,this.FOrganizationalWar,this.FProcessorCityDefend,this.FProcessorFightPet,this.FProcessorTraitorAttack,this.FProcessorMonsterMap,this.FProcessorWindowOrgPointMap,this.FProcessorHome,this.FProcessorNijiaStar,this.FProcessorSevenKing,this.FProcessorTeamBattle,this.FProcessorSkyTower,this.FProcessorGongFuFight,this.FProcessorCrashJade,this.FProcessorPet,this.FProcessorSuperHero,this.FProcessorNightmareMap,this.FProcessorKingChallenge,this.FProcessorVoidSoulWorld]);
      }
      
      protected function ConstructProcessorsWindows() : void
      {
         this.FProcessorProtagonist = new TProcessorProtagonist(this.FMountPointWindows,this.FParameters);
         this.FProcessorProtagonist.Visible = false;
         this.FProcessorProtagonist.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorProtagonist.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorProtagonist.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorProtagonist.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorProtagonist.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorProtagonist.OnMilitaryRankChange = this.ProcessorWindowsOnMilitary;
         this.FProcessorProtagonist.OnUserUpdateBaseInfo = this.ProcessorAccountOnUserUpdateBaseInfo;
         this.FProcessorProtagonist.CheckCanUpgradeMilitary = this.ProcessorShortcutEffectNotification;
         this.FProcessorProtagonist.OnAddPopTips = this.ProcessorOnAddPopTips;
         this.FProcessorProtagonist.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorProtagonist.CloseList = this.OnCloseList;
         this.FProcessorHeros = new TProcessorPartner(this.FMountPointWindows,this.FParameters);
         this.FProcessorHeros.Visible = false;
         this.FProcessorHeros.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHeros.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHeros.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHeros.OnEffectHtmlText = this.ProcessorsOnEffectHtmlText;
         this.FProcessorHeros.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHeros.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorHeros.OnUpdateTalismanMount = this.ProcessorOnUpdateTalismanMount;
         this.FProcessorHeros.OnChangeSkillReq = this.ProcessorOnChangeSkillReq;
         this.FProcessorHeros.OnUseAppliance = this.ProcessorOnUseAppliance;
         this.FProcessorTacticalDeployment = new TProcessorTacticalDeployment(this.FMountPointWindows,this.FParameters);
         this.FProcessorTacticalDeployment.Visible = false;
         this.FProcessorTacticalDeployment.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorTacticalDeployment.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTacticalDeployment.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTacticalDeployment.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTacticalDeployment.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorTacticalDeployment.OnChangePosition = this.ProcessorOnChangePosition;
         this.FProcessorTacticalDeployment.OnEnterMilitary = this.ProcessorShortcutsOnAvaterHead;
         this.FProcessorTacticalDeployment.UpdateHeroPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorTacticalDeployment.OnSetBackToDepoly = this.ProcessorOnSetBackToDepolyment;
         this.FProcessorBackpack = new TProcessorBackpack(this.FMountPointWindows,this.FParameters);
         this.FProcessorBackpack.Visible = false;
         this.FProcessorBackpack.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBackpack.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBackpack.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBackpack.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBackpack.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorBackpack.OnUpdateInventories = this.ProcessorOnUpdateInventories;
         this.FProcessorBackpack.OnQuertInventoryIDReq = this.ProcessorsOnQuertInventoryIDReq;
         this.FProcessorBackpack.OnInventoryReveal = this.ProcessorsOnInventoryReveal;
         this.FProcessorBackpack.OnAddPopTips = this.ProcessorOnAddPopTips;
         this.FProcessorKnifeSoul = new TProcessorKnifeSoul(this.FMountPointWindows,this.FParameters);
         this.FProcessorKnifeSoul.Visible = false;
         this.FProcessorKnifeSoul.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorKnifeSoul.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorKnifeSoul.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorKnifeSoul.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorKnifeSoul.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorKnifeSoul.OnKnifeChange = this.ProcessorsOnChangeKnifeShape;
         this.FProcessorKnifeSoul.UpdateHeroPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorSmithy = new TProcessorSmithy(this.FMountPointWindows,this.FParameters);
         this.FProcessorSmithy.Visible = false;
         this.FProcessorSmithy.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorSmithy.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSmithy.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSmithy.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSmithy.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorSmithy.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorSmithy.UpdateHerosPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorQuest = new TProcessorQuest(this.FMountPointWindows,this.FParameters);
         this.FProcessorQuest.Visible = false;
         this.FProcessorQuest.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorQuest.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorQuest.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorQuest.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorQuest.OnAcceptTaskEffect = this.ProcessorAccountOnAcceptTaskEffect;
         this.FProcessorQuest.OnCompleteTaskEffect = this.ProcessorAccountOnCompleteEffect;
         this.FProcessorQuest.OnLoadQuestOver = this.ProcessorsOnLoadingQuestOver;
         this.FProcessorQuest.OnQuestUpdate = this.ProcessorOnQuestUpdate;
         this.FProcessorQuest.OnProcessorCheckPlot = this.ProcessorOnCheckPlot;
         this.FProcessorMakeEquip = new TProcessorMakeEquip(this.FMountPointWindows,this.FParameters);
         this.FProcessorMakeEquip.Visible = false;
         this.FProcessorMakeEquip.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorMakeEquip.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorMakeEquip.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorMakeEquip.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMakeEquip.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorMakeEquip.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorKillHeros = new TProcessorKillHeros(this.FMountPointWindows,this.FParameters);
         this.FProcessorKillHeros.Visible = false;
         this.FProcessorKillHeros.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorKillHeros.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorKillHeros.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorKillHeros.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorKillHeros.OnEnterTown = this.ProcessorsOnEnterTown;
         this.FProcessorKillHeros.OnAddPopTips = this.ProcessorOnAddPopTips;
         this.FProcessorKillHeros.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorKillHeros.OnOpenTacticalDeployment = this.ProcessorShortcutsOnTacticalDeployment;
         this.FProcessorGeneralStar = new TProcessorGeneralStar(this.FMountPointWindows,this.FParameters);
         this.FProcessorGeneralStar.Visible = false;
         this.FProcessorGeneralStar.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorGeneralStar.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorGeneralStar.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorGeneralStar.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorGeneralStar.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorGeneralStar.MainHeroQualityOnChange = this.ProcessorOnHeroQualityChange;
         this.FProcessorGeneralStar.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorGeneralStar.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorGeneralStar.OnAddPopTips = this.ProcessorOnAddPopTips;
         this.FProcessorGeneralStar.OnUpdateChangeSkill = this.ProcessorOnUpdateChangeSkill;
         this.FProcessorGeneralStar.OnUpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorJade = new TProcessorJade(this.FMountPointWindows,this.FParameters);
         this.FProcessorJade.Visible = false;
         this.FProcessorJade.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorJade.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorJade.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorJade.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorJade.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorTalisman = new TProcessorTalisman(this.FMountPointWindows,this.FParameters);
         this.FProcessorTalisman.Visible = false;
         this.FProcessorTalisman.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorTalisman.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTalisman.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTalisman.OnEffectHtmlText = this.ProcessorsOnEffectHtmlText;
         this.FProcessorTalisman.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTalisman.OnMountTalisman = this.ProcessorOnMountTalisman;
         this.FProcessorTalisman.OnDismountTalisman = this.ProcessorOnDismountTalisman;
         this.FProcessorTalisman.OnUpdateHerosBaseAttributeReq = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorMail = new TProcessorMail(this.FMountPointWindows,this.FParameters);
         this.FProcessorMail.Visible = false;
         this.FProcessorMail.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorMail.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorMail.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorMail.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMail.OnEffectNewMail = this.ProcessorShortcutEffectNotification;
         this.FProcessorHellButterfly = new TProcessorHellButterfly(this.FMountPointWindows,this.FParameters);
         this.FProcessorHellButterfly.Visible = false;
         this.FProcessorHellButterfly.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHellButterfly.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHellButterfly.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHellButterfly.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorFriend = new TProcessorFriend(this.FMountPointWindows,this.FParameters);
         this.FProcessorFriend.Visible = false;
         this.FProcessorFriend.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorFriend.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorFriend.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorFriend.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorFriend.OnCheckPopTipsModes = this.ProcessorOnCheckPopTipsModes;
         this.FProcessorFriend.OnInquiryRet = this.ProcessorOnInquiryCharacterIDRet;
         this.FProcessorFriend.OnWhisper = this.ProcessorOnChatWhisper;
         this.FProcessorFriend.OnMail = this.ProcessorOnOpenWriteMail;
         this.FProcessorFriend.OnProcessFriendNtf = this.ProcessorOnProcessFriendNtf;
         this.FProcessorMall = new TProcessorMall(this.FMountPointWindows,this.FParameters);
         this.FProcessorMall.Visible = false;
         this.FProcessorMall.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorMall.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorMall.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorMall.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMall.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorMall.OnSendPacketToSuperMarket = this.PacketPerform_ProcessorSuperMarket;
         this.FProcessorMall.OnPacketHonorShopInitRet = this.PacketPerform_ProcessorHonorShopInitRet;
         this.FProcessorMall.OnPacketHonorShopNotifyRet = this.PacketPerform_ProcessorHonorShopNotifyRet;
         this.FProcessorDailySign = new TProcessorDailySign(this.FMountPointWindows,this.FParameters);
         this.FProcessorDailySign.Visible = false;
         this.FProcessorDailySign.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorDailySign.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorDailySign.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorDailySign.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorDailySign.OnEffectSign = this.ProcessorShortcutEffectNotification;
         this.FProcessorDailySign.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorVIP = new TProcessorVIP(this.FMountPointWindows,this.FParameters);
         this.FProcessorVIP.Visible = false;
         this.FProcessorVIP.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorVIP.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorVIP.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorVIP.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorVIP.OnEffectBaseGlowVIP = this.ProcessorOnEffectBaseGlowVIP;
         this.FProcessorDailyQuest = new TProcessorDailyQuest(this.FMountPointWindows,this.FParameters);
         this.FProcessorDailyQuest.Visible = false;
         this.FProcessorDailyQuest.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorDailyQuest.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorDailyQuest.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorDailyQuest.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorDailyQuest.OnGotoBigMap = this.ProcessorOnGotoCityDoor;
         this.FProcessorDailyQuest.OnPlayEffect = this.ProcessorShortcutEffectNotification;
         this.FProcessorMentorship = new TProcessorMentorship(this.FMountPointWindows,this.FParameters);
         this.FProcessorMentorship.Visible = false;
         this.FProcessorMentorship.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorMentorship.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorMentorship.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorMentorship.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorMentorship.OnShowOtherPlayerInfor = this.ProcessorOnShowHeroInfor;
         this.FProcessorMentorship.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorMentorship.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorDailyActivity = new TProcessorDailyActivity(this.FMountPointWindows,this.FParameters);
         this.FProcessorDailyActivity.Visible = false;
         this.FProcessorDailyActivity.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorDailyActivity.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorDailyActivity.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorDailyActivity.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorDailyActivity.OnEnterFightPet = this.ProcessorOnEnterFightPetReq;
         this.FProcessorDailyActivity.OnEnterCityDefend = this.ProcessorOnEnterCityDefendReq;
         this.FProcessorDailyActivity.OnEnterTraitorAttack = this.ProcessorOnEnterTraitorAttackReq;
         this.FProcessorDailyActivity.OnEnterVoidSoulWorld = this.ProcessorOnEnterOnEnterVoidSoulWorldReq;
         this.FProcessorDailyActivity.OnTraitorAttackEnd = this.ProcessorTraitorAttackEnd;
         this.FProcessorDailyActivity.OnEnterOrganizationWar = this.ProcessorOnEnterOrganizationWarReq;
         this.FProcessorDailyActivity.OnShortcutEffect = this.ProcessorShortcutEffectNotification;
         this.FProcessorDailyActivity.OnJoinOrganizationWar = this.ProcessorOnOrganizationalWarCommandRequest;
         this.FProcessorOrganization = new TProcessorOrganization(this.FMountPointWindows,this.FParameters);
         this.FProcessorOrganization.Visible = false;
         this.FProcessorOrganization.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorOrganization.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorOrganization.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorOrganization.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorOrganization.SetDailyActivityStatus = this.ProcessorOnSetDailyActivityStatus;
         this.FProcessorOrganization.OnSetOrganizationName = this.ProcessorOnSetOrganizationalName;
         this.FProcessorOrganization.OnSetOrganizationChannel = this.ProcessorOnActivatingChannel;
         this.FProcessorOrganization.OnShowHeroInfo = this.ProcessorOnShowHeroInfor;
         this.FProcessorOrganization.OnShowHeroAchievement = this.ProcessorOnShowHeroAchievement;
         this.FProcessorOrganization.OnChatWhisper = this.ProcessorOnChatWhisper;
         this.FProcessorOrganization.UpdateHerosPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorOrganization.OnOrgActivityMuyeBattleSignUp = this.ProcessorOnOrganizationalWarCommandRequest;
         this.FProcessorOrganization.OnOrgActivityMuyeBattleStartBattle = this.ProcessorOnEnterOrganizationWarReq;
         this.FProcessorOrganization.OnOrgActivityMuyeGuardStartBattle = this.ProcessorOnEnterCityDefendReq;
         this.FProcessorOrganization.OnInterpersonalRelationships = this.ProcessorOnInterpersonalRelationshipsReq;
         this.FProcessorOrganization.OnOrgGotoSinglePointMap = this.ProcessorOnOrgGotoSinglePointMap;
         this.FProcessorOrganization.OnOrgGotoGroupPointMap = this.ProcessorOnOrgGotoGroupPointMap;
         this.FProcessorOrganization.OnExchange = this.ProcessorsOnPurchase;
         this.FProcessorOrganization.SingleInitRetCall = this.ProcessorSingleInitRetCall;
         this.FProcessorOrganization.GroupInitRetCall = this.ProcessorGroupInitRetCall;
         this.FProcessorShinobidoPractise = new TProcessorShinobidoPractise(this.FMountPointWindows,this.FParameters);
         this.FProcessorShinobidoPractise.Visible = false;
         this.FProcessorShinobidoPractise.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorShinobidoPractise.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorShinobidoPractise.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorShinobidoPractise.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorNpcDialog = new TProcessorNpcDialog(this.FMountPointWindows,this.FParameters);
         this.FProcessorNpcDialog.Visible = false;
         this.FProcessorNpcDialog.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorNpcDialog.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorNpcDialog.OpenDialog = this.ProcessorOnShowNpcDialog;
         this.FProcessorNpcDialog.OpenNpcUserTypeWindow = this.ProcessorShortcutsOnNpcUserType;
         this.FProcessorNpcDialog.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorNpcDialog.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorLargeWorldMap = new TProcessorLargeWorldMap(this.FMountPointWindows,this.FParameters);
         this.FProcessorLargeWorldMap.Visible = false;
         this.FProcessorLargeWorldMap.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorLargeWorldMap.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorLargeWorldMap.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorLargeWorldMap.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorLargeWorldMap.OnBarrierEnter = this.ProcessorOnEnterMonsterWorld;
         this.FProcessorLargeWorldMap.OnBarrierAutoBattleInfo = this.ProcessorOnContinueAutoBattleInfo;
         this.FProcessorLargeWorldMap.OnBarrierContinueAutoInfo = this.ProcessorOnContinueBarrierAutoBattleCount;
         this.FProcessorBarrierAutoBattle = new TProcessorBarrierAutoBattle(this.FMountPointWindows,this.FParameters);
         this.FProcessorBarrierAutoBattle.Visible = false;
         this.FProcessorBarrierAutoBattle.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBarrierAutoBattle.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBarrierAutoBattle.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBarrierAutoBattle.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBarrierAutoBattle.Load();
         this.FProcessorKnifeOfKillSoul = new TProcessorKnifeOfKillSoul(this.FMountPointWindows,this.FParameters);
         this.FProcessorKnifeOfKillSoul.Visible = false;
         this.FProcessorKnifeOfKillSoul.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorKnifeOfKillSoul.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorKnifeOfKillSoul.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorKnifeOfKillSoul.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorKnifeOfKillSoul.OnChangeShape = this.ProcessorsOnChangeKnifeShape;
         this.FProcessorKnifeOfKillSoul.UpdateHeroPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorQianKunARoll = new TProcessorQianKunARoll(this.FMountPointWindows,this.FParameters);
         this.FProcessorQianKunARoll.Visible = false;
         this.FProcessorQianKunARoll.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorQianKunARoll.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorQianKunARoll.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorQianKunARoll.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDOS = new TProcessorHDOS(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDOS.Visible = false;
         this.FProcessorHDOS.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDOS.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDOS.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDOS.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDOS.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDOS.CheckEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDOS.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDOS.OnLookInfo = this.ProcessorOnShowHeroInfor;
         this.FProcessorHDActivityRecharge = new TProcessorHDActivityRecharge(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDActivityRecharge.Visible = false;
         this.FProcessorHDActivityRecharge.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDActivityRecharge.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDActivityRecharge.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDActivityRecharge.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDActivityRecharge.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDActivityRecharge.CheckEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDActivityRecharge.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDActivityRecharge.OnBuyMilitary = this.ProcessorShortcutBuyMilitary;
         this.FProcessorHDHalloween = new TProcessorHDActivityHalloween(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDHalloween.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDHalloween.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDHalloween.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDHalloween.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDHalloween.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDHalloween.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDHalloween.OnLoadLog = this.ProcessorOnLoadLog;
         this.FProcessorHDGiftBag = new TProcessorHDGiftBag(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGiftBag.Visible = false;
         this.FProcessorHDGiftBag.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGiftBag.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGiftBag.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGiftBag.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGiftBag.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGiftBag.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGiftBag.CheckActivityOnOffNotification = this.ProcessorOnOpenActivityListStatusNotification;
         this.FProcessorHDGiftBag.SecondEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDGiftBag.LoadWindowResources();
         this.FProcessorHDFirstPay = new TProcessorHDFirstPay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDFirstPay.Visible = false;
         this.FProcessorHDFirstPay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDFirstPay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDFirstPay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDFirstPay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDFirstPay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDFirstPay.OnUpdateFirstPayIcon = this.ProcessorUpdateFirstPayIcon;
         this.FProcessorHDFirstPay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDCDK = new TProcessorHDCDK(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDCDK.Visible = false;
         this.FProcessorHDCDK.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDCDK.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDCDK.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDCDK.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSuperMarket = new TProcessorSuperMarket(this.FMountPointWindows,this.FParameters);
         this.FProcessorSuperMarket.Visible = false;
         this.FProcessorSuperMarket.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorSuperMarket.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSuperMarket.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSuperMarket.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSuperMarket.OnShutDownFunction = this.ProcessorShortcutShutdownFunction;
         this.FProcessorSuperMarket.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorFamilyMovie = new TProcessorFamilyMovie(this.FMountPointWindows,this.FParameters);
         this.FProcessorFamilyMovie.Visible = false;
         this.FProcessorFamilyMovie.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorFamilyMovie.OnCheckPlot = this.ProcessorOnCheckPlot;
         this.FProcessorOffceLady = new TProcessorOfficeLady(this.FMountPointWindows,this.FParameters);
         this.FProcessorOffceLady.Visible = false;
         this.FProcessorOffceLady.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorOffceLady.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorOffceLady.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorOffceLady.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorOffceLady.OnShutDownFunction = this.ProcessorShortcutShutdownFunction;
         this.FProcessorAchievement = new TProcessorAchievement(this.FMountPointWindows,this.FParameters);
         this.FProcessorAchievement.Visible = false;
         this.FProcessorAchievement.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorAchievement.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorAchievement.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorAchievement.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorAchievement.OnCompleteNewAchievement = this.ProcessorOnNewAchievementComplete;
         this.FProcessorAchievement.OnFollowAchievement = this.ProcessorShortcutFollowAchievement;
         this.FProcessorAchievement.OnUpdateAchievementState = this.ProcessorOnAchievementStateUpdate;
         this.FProcessorAchievement.UpdateHeroPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorAchievement.OnChangeTitle = this.ProcessorOnChangeTitle;
         this.FProcessorAchievement.OnAchievmentCanGetRewardNotify = this.ProcessorOnShortcutsFlashNotify;
         this.FProcessorHDActivityFund = new TProcessorHDActivityFund(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDActivityFund.Visible = false;
         this.FProcessorHDActivityFund.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDActivityFund.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDActivityFund.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDActivityFund.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDActivityFund.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDActivityFund.CheckEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDActivityFund.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDActivitySuperTreature = new TProcessorHDSuperTreasure(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDActivitySuperTreature.Visible = false;
         this.FProcessorHDActivitySuperTreature.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDActivitySuperTreature.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDActivitySuperTreature.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDActivitySuperTreature.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDActivitySuperTreature.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDActivitySuperTreature.CheckEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDActivitySuperTreature.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDRechargeSuit = new TProcessorHDRechargeSuit(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDRechargeSuit.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDRechargeSuit.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDRechargeSuit.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDRechargeSuit.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDRechargeSuit.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDRechargeSuit.CheckEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorHDRechargeSuit.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDRechargeSuit.Visible = false;
         this.FProcessorHDEspada = new TProcessorHDEspada(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDEspada.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDEspada.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDEspada.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDEspada.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDEspada.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDEspada.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDEspada.Visible = false;
         this.FProcessorOrnamentStrengthen = new TProcessorOrnamentStrengthen(this.FMountPointWindows,this.FParameters);
         this.FProcessorOrnamentStrengthen.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorOrnamentStrengthen.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorOrnamentStrengthen.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorOrnamentStrengthen.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorOrnamentStrengthen.Visible = false;
         this.FProcessorHDMaskFright = new TProcessorHDMaskFright(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDMaskFright.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDMaskFright.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDMaskFright.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDMaskFright.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDMaskFright.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDMaskFright.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDMaskFright.Visible = false;
         this.FProcessorGirlGame = new TProcessorGirlGame(this.FMountPointWindows,this.FParameters);
         this.FProcessorGirlGame.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorGirlGame.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorGirlGame.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorGirlGame.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorGirlGame.Visible = false;
         this.FProcessorHDEquipmentShop = new TProcessorHDEquipmentShop(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDEquipmentShop.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDEquipmentShop.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDEquipmentShop.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDEquipmentShop.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDEquipmentShop.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDEquipmentShop.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDEquipmentShop.Visible = false;
         this.FProcessorWelcome = new TProcessorWelcome(this.FMountPointWindows,this.FParameters);
         this.FProcessorWelcome.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorWelcome.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorWelcome.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorWelcome.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorWelcome.Visible = false;
         this.FProcessorWelcome.OnChangeClothesComplete = this.ProcessorShortcutsOnReveredBook;
         this.FProcessorHDSoulBox = new TProcessorHDSoulBox(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDSoulBox.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDSoulBox.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDSoulBox.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDSoulBox.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDSoulBox.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDSoulBox.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDSoulBox.Visible = false;
         this.FProcessorReveredBook = new TProcessorReveredBook(this.FMountPointWindows,this.FParameters);
         this.FProcessorReveredBook.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorReveredBook.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorReveredBook.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorReveredBook.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorReveredBook.OnShowEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorBleachDailyRecord = new TProcessorBleachDailyRecord(this.FMountPointWindows,this.FParameters);
         this.FProcessorBleachDailyRecord.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBleachDailyRecord.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBleachDailyRecord.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBleachDailyRecord.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBleachTrain = new TProcessorBleachTrain(this.FMountPointWindows,this.FParameters);
         this.FProcessorBleachTrain.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBleachTrain.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBleachTrain.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBleachTrain.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBleachTrain.OnShowEffect = this.ProcessorShortcutBleachTrainInforNotify;
         this.FProcessorBleachTrain.OnFollowBleachTrain = this.ProcessorShortcutFollowBleachTrain;
         this.FProcessorBleachTrain.OnShutDownFunction = this.ProcessorShortcutShutdownFunction;
         this.FProcessorHDGambling = new TProcessorHDGambling(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGambling.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGambling.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGambling.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGambling.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGambling.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGambling.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGambling.Visible = false;
         this.FProcessorHDLimitBuy = new TProcessorHDLimitBuy(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDLimitBuy.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDLimitBuy.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDLimitBuy.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDLimitBuy.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDLimitBuy.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDLimitBuy.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDLimitBuy.Visible = false;
         this.FProcessorHDIceHeros = new TProcessorHDGeneralSellHeros(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDIceHeros.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDIceHeros.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDIceHeros.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDIceHeros.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDIceHeros.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDIceHeros.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDIceHeros.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDIceHeros.Visible = false;
         this.FProcessorGongFuFightApply = new TProcessorGongFuFightWindow(this.FMountPointWindows,this.FParameters);
         this.FProcessorGongFuFightApply.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorGongFuFightApply.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorGongFuFightApply.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorGongFuFightApply.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorGongFuFightApply.OnOpenTokenShop = this.ProcessorShortcutsOnTokenShop;
         this.FProcessorGongFuFightApply.OnOpenStoneShop = this.ProcessorShortcutsOnStoneShop;
         this.FProcessorHDIceDragon = new TProcessorHDIceDragon(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDIceDragon.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDIceDragon.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDIceDragon.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDIceDragon.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDIceDragon.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDIceDragon.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDIceDragon.Visible = false;
         this.FProcessorHDSuperEggs = new TProcessorHDSuperEggs(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDSuperEggs.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDSuperEggs.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDSuperEggs.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDSuperEggs.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDSuperEggs.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDSuperEggs.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDSuperEggs.Visible = false;
         this.FProcessorHDTeamBuy = new TProcessorHDTeamBuy(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDTeamBuy.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDTeamBuy.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDTeamBuy.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDTeamBuy.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDTeamBuy.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDTeamBuy.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDTeamBuy.Visible = false;
         this.FProcessorHDJigsaw = new TProcessorHDJigSaw(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDJigsaw.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDJigsaw.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDJigsaw.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDJigsaw.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDJigsaw.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDJigsaw.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDJigsaw.Visible = false;
         this.FProcessorHDBigTurnTable = new TProcessorHDBigTurnTable(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDBigTurnTable.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDBigTurnTable.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDBigTurnTable.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDBigTurnTable.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDBigTurnTable.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDBigTurnTable.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDBigTurnTable.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDBigTurnTable.OnLoadLog = this.ProcessorOnLoadLog;
         this.FProcessorHDBigTurnTable.Visible = false;
         this.FProcessorHDServerPay = new TProcessorHDServerPay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDServerPay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDServerPay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDServerPay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDServerPay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDServerPay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDServerPay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDServerPay.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDServerPay.Visible = false;
         this.FProcessorHDRandCard = new TProcessorHDRandCard(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDRandCard.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDRandCard.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDRandCard.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDRandCard.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDRandCard.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDRandCard.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDRandCard.OnLoadLog = this.ProcessorOnLoadPersonalLog;
         this.FProcessorHDRandCard.Visible = false;
         this.FProcessorHDTreasureAwake = new TProcessorHDTreasureAwake(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDTreasureAwake.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDTreasureAwake.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDTreasureAwake.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDTreasureAwake.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDTreasureAwake.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDTreasureAwake.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDTreasureAwake.Visible = false;
         this.FProcessorTokenShop = new TProcessorTokenShop(this.FMountPointWindows,this.FParameters);
         this.FProcessorTokenShop.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorTokenShop.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorTokenShop.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorTokenShop.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorTokenShop.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorStoneShop = new TProcessorStoneShop(this.FMountPointWindows,this.FParameters);
         this.FProcessorStoneShop.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorStoneShop.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorStoneShop.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorStoneShop.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorStoneShop.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorDailyWelfare = new TProcessorDailyWelfare(this.FMountPointWindows,this.FParameters);
         this.FProcessorDailyWelfare.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorDailyWelfare.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorDailyWelfare.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorDailyWelfare.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorDailyWelfare.OnEffectShortcut = this.ProcessorShortcutEffectNotification;
         this.FProcessorBleachJigsaw = new TProcessorBleachJigsaw(this.FMountPointWindows,this.FParameters);
         this.FProcessorBleachJigsaw.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBleachJigsaw.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBleachJigsaw.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBleachJigsaw.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBleachJigsaw.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorBleachJigsaw.GetActivityAtoms = this.PorcessorActivityOnGetAtoms;
         this.FProcessorChess = new TProcessorChess(this.FMountPointWindows,this.FParameters);
         this.FProcessorChess.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorChess.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorChess.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorChess.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorChess.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorChess.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorChess.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorChess.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorChess.Visible = false;
         this.FProcessorWorldCup = new TProcessorWorldCup(this.FMountPointWindows,this.FParameters);
         this.FProcessorWorldCup.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorWorldCup.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorWorldCup.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorWorldCup.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorWorldCup.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorWorldCup.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorWorldCup.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorWorldCup.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorWorldCup.Visible = false;
         this.FProcessorHerosMarket = new TProcessorHerosMarket(this.FMountPointWindows,this.FParameters);
         this.FProcessorHerosMarket.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHerosMarket.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHerosMarket.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHerosMarket.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHerosMarket.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHerosMarket.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHerosMarket.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorHerosMarket.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorHerosMarket.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHerosMarket.Visible = false;
         this.FProcessorLottery = new TProcessorHDLottery(this.FMountPointWindows,this.FParameters);
         this.FProcessorLottery.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorLottery.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorLottery.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorLottery.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorLottery.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorLottery.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorLottery.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorLottery.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FProcessorLottery.Visible = false;
         this.FProcessorBleachJigsawOld = new TProcessorBleachJigsawOld(this.FMountPointWindows,this.FParameters);
         this.FProcessorBleachJigsawOld.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBleachJigsawOld.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBleachJigsawOld.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBleachJigsawOld.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBleachJigsawOld.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorBleachJigsawOld.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorBleachJigsawOld.Visible = false;
         this.FProcessorHeroChange = new TProcessorHeroChange(this.FMountPointWindows,this.FParameters);
         this.FProcessorHeroChange.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHeroChange.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHeroChange.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHeroChange.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHeroChange.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorHeroChange.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorBleachAgent = new TProcessorBleachAgent(this.FMountPointWindows,this.FParameters);
         this.FProcessorBleachAgent.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBleachAgent.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBleachAgent.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBleachAgent.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBleachAgent.UpdateBleachIcon = this.ProcessorOnChangeBleachAgentIcon;
         this.FProcessorCustomHero = new TProcessorCustomHero(this.FMountPointWindows,this.FParameters);
         this.FProcessorCustomHero.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorCustomHero.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorCustomHero.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorCollectSoul = new TProcessorCollectSoul(this.FMountPointWindows,this.FParameters);
         this.FProcessorCollectSoul.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorCollectSoul.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorCollectSoul.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorEquipForge = new TProcessorEquipForge(this.FMountPointWindows,this.FParameters);
         this.FProcessorEquipForge.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorEquipForge.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorEquipForge.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorRebirth = new TProcessorRebirth(this.FMountPointWindows,this.FParameters);
         this.FProcessorRebirth.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorRebirth.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorRebirth.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorRebirth.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorRebirth.OnUserUpdateBaseInfo = this.ProcessorAccountOnUserUpdateBaseInfo;
         this.FProcessorRebirth.OnUpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorRebirth.UpdateRebirthNum = this.ProcessorOnMainHeroRebirthNum;
         this.FProcessorSmelt = new TProcessorSmelt(this.FMountPointWindows,this.FParameters);
         this.FProcessorSmelt.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorSmelt.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSmelt.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSmelt.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSmelt.UpdateRebirthNum = this.ProcessorOnMainHeroRebirthNum;
         this.FProcessorSmelt.OnUpdateHeroPower = this.ProcessorOnHerosUpdateBaseAttributeReq;
         this.FProcessorBlackMarket = new TProcessorBlackMarket(this.FMountPointWindows,this.FParameters);
         this.FProcessorBlackMarket.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorBlackMarket.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorBlackMarket.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorBlackMarket.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorBlackMarket.EffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorBlackMarket.OnOpenSecretMallNotify = this.ProcessorsOnOpenSecretMallNotify;
         this.FProcessorExpDuplicate = new TProcessorExpDuplicate(this.FMountPointWindows,this.FParameters);
         this.FProcessorExpDuplicate.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorExpDuplicate.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorExpDuplicate.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorExpDuplicate.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorExpDuplicate.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorExpDuplicate.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorChangeInfo = new TProcessorChangeInfo(this.FMountPointWindows,this.FParameters);
         this.FProcessorChangeInfo.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorChangeInfo.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorChangeInfo.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorExportPlayer = new TProcessorExportPlayer(this.FMountPointWindows,this.FParameters);
         this.FProcessorExportPlayer.Visible = false;
         this.FProcessorExportPlayer.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorExportPlayer.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorExportPlayer.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorExportPlayer.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorYellowDiamon = new TProcessorYellowDiamon(this.FMountPointWindows,this.FParameters);
         this.FProcessorYellowDiamon.Visible = false;
         this.FProcessorYellowDiamon.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorYellowDiamon.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorYellowDiamon.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorYellowDiamon.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorYellowDiamon.OnShowShortcutEffect = this.ProcessorShortcutEffectNotification;
         this.FProcessorYellowDiamondBuyGold = new TProcessorYellowVipBuyGold(this.FMountPointWindows,this.FParameters);
         this.FProcessorYellowDiamondBuyGold.Visible = false;
         this.FProcessorYellowDiamondBuyGold.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorYellowDiamondBuyGold.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorYellowDiamondBuyGold.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorYellowDiamondBuyGold.OnEffectTransition = this.ProcessorOnEffectTransition;
         false;
         this.FProcessorLikeUs = new TProcessorLikeUs(this.FMountPointWindows,this.FParameters);
         this.FProcessorLikeUs.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorLikeUs.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorLikeUs.OnShutDownFunction = this.ProcessorShortcutShutdownFunction;
         this.FProcessorLikeUs.OnChangeShortcutIcon = this.ProcessorShortcutChangeShortcutIcon;
         this.FProcessorPartner = new TProcessorHDPartner(this.FMountPointWindows,this.FParameters);
         this.FProcessorPartner.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorPartner.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorPartner.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorPartner.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorPartner.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorPartner.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorLuckyJoy = new TProcessorHDLuckyJoy(this.FMountPointWindows,this.FParameters);
         this.FProcessorLuckyJoy.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorLuckyJoy.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorLuckyJoy.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorLuckyJoy.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorLuckyJoy.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorLuckyJoy.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorLuckyJoy.OnLoadLog = this.ProcessorOnLoadPersonalLog;
         this.FProcessorVainTravel = new TProcessorVainTravel(this.FMountPointWindows,this.FParameters);
         this.FProcessorVainTravel.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorVainTravel.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorVainTravel.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorVainTravel.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorVainTravel.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorVainTravel.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorSpecialCombatPower = new TProcessorSpecialCombatPower(this.FMountPointWindows,this.FParameters);
         this.FProcessorSpecialCombatPower.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSpecialCombatPower.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSpecialCombatPower.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorSpecialCombatPower.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSpecialCombatPower.OnUpdateHerosBaseAttributeReq = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorSwiftChange = new TProcessorHDSwiftChange(this.FMountPointWindows,this.FParameters);
         this.FProcessorSwiftChange.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorSwiftChange.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorSwiftChange.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorSwiftChange.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorSwiftChange.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorSwiftChange.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorPrivilegeLease = new TprocessorHDPrivilegeLease(this.FMountPointWindows,this.FParameters);
         this.FProcessorPrivilegeLease.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorPrivilegeLease.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorPrivilegeLease.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorPrivilegeLease.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorPrivilegeLease.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorPrivilegeLease.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDCircleTrial = new TProcessorHDActivityCircleTrial(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDCircleTrial.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDCircleTrial.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDCircleTrial.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDCircleTrial.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDCircleTrial.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDCircleTrial.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDCircleTrial.OnLoadLog = this.ProcessorOnLoadPersonalLog;
         this.FProcessorHDCircleTrial.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDKingLegend = new TProcessorHDActivityKingLegend(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDKingLegend.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDKingLegend.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDKingLegend.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDKingLegend.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDKingLegend.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDKingLegend.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDKingLegend.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDChristmas = new TProcessorHDActivityChristmas(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDChristmas.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDChristmas.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDChristmas.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDChristmas.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDChristmas.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDChristmas.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorFBBuyGold = new TProcessorFBBuyGold(this.FMountPointWindows,this.FParameters);
         this.FProcessorFBBuyGold.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorFBBuyGold.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorFBBuyGold.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorFBBuyGold.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYearDay = new TProcessorHDNewYearDay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewYearDay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewYearDay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewYearDay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewYearDay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYearDay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewYearDay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDUniteTask = new TProcessorHDUniteTask(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDUniteTask.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDUniteTask.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDUniteTask.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDUniteTask.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDUniteTask.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDUniteTask.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDUniteTask.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDDreams = new TProcessorHDDreamComeTrue(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDDreams.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDDreams.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDDreams.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDDreams.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDDreams.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDDreams.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDDreams.OnCreateKnifeOfKillSoulData = this.ProcessorOnCreateKnifeOfKillSoulData;
         this.FProcessorHDNewYearSheep = new TProcessorHDNewYearSheep(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewYearSheep.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewYearSheep.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewYearSheep.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewYearSheep.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYearSheep.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewYearSheep.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGoldTurntable = new TProcessorHDTimeLimitTurntable(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGoldTurntable.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGoldTurntable.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGoldTurntable.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGoldTurntable.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGoldTurntable.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGoldTurntable.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGoldTurntable.OnLoadLog = this.ProcessorOnLoadLog;
         this.FProcessorHDFeedback = new TProcessorHDFeedback(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDFeedback.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDFeedback.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDFeedback.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDFeedback.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDFeedback.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDFeedback.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDDayBack = new TProcessorHDDayBack(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDDayBack.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDDayBack.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDDayBack.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDDayBack.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDDayBack.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDDayBack.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGrowthPlan = new TProcessorHDGrowthPlan(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGrowthPlan.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGrowthPlan.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGrowthPlan.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGrowthPlan.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGrowthPlan.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGrowthPlan.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGrowthPlan.OnHideHDIcon = this.ProcessorUpdateFirstPayIcon;
         this.FProcessorHDEaster = new TProcessorHDEaster(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDEaster.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDEaster.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDEaster.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDEaster.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDEaster.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDEaster.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDBleachBag = new TProcessorHDBleachBag(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDBleachBag.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDBleachBag.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDBleachBag.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDBleachBag.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDBleachBag.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDBleachBag.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGallery = new TProcessorHDGallery(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGallery.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGallery.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGallery.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGallery.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGallery.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGallery.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDDailyHero = new TProcessorHDDailyHero(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDDailyHero.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDDailyHero.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDDailyHero.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDDailyHero.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDDailyHero.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDDailyHero.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDPyramid = new TProsessorHDPyramid(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDPyramid.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDPyramid.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDPyramid.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDPyramid.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDPyramid.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDPyramid.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDPyramid.OnLoadLog = this.ProcessorOnLoadLog;
         this.FProcessorHDRushInSeireitei = new TProcessorHDRushInSeireitei(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDRushInSeireitei.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDRushInSeireitei.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDRushInSeireitei.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDRushInSeireitei.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDRushInSeireitei.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDRushInSeireitei.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDKnifeHeroCollect = new TProcessorHDKnifeHeroCollect(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDKnifeHeroCollect.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDKnifeHeroCollect.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDKnifeHeroCollect.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDKnifeHeroCollect.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDKnifeHeroCollect.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDKnifeHeroCollect.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDCoolSummer = new TProcessorHDCoolSummer(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDCoolSummer.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDCoolSummer.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDCoolSummer.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDCoolSummer.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDCoolSummer.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDCoolSummer.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDEveryDayAward = new TProcessorHDEveryDayAward(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDEveryDayAward.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDEveryDayAward.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDEveryDayAward.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDEveryDayAward.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDEveryDayAward.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDEveryDayAward.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorRelatedPartner = new TProcessorRelatedPartner(this.FMountPointWindows,this.FParameters);
         this.FProcessorRelatedPartner.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorRelatedPartner.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorRelatedPartner.OnAssistanceView = this.ProcessorsAssistanceViewShow;
         this.FProcessorRelatedPartner.OnAssistanceViewClose = this.ProcessorsAssistanceViewClose;
         this.FProcessorRelatedPartner.OnUpdateAssistanceView = this.ProcessorsAssistanceViewUpdate;
         this.FProcessorRelatedPartner.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorRelatedPartner.OnInitBattle = this.ProcessorLobbyOnInitBattle;
         this.FProcessorRelatedPartner.OnShowHeroDescription = this.ProcessorOnShowHeroDescription;
         this.FProcessorRelatedAssistance = new TProcessorRelatedAssistance(this.FMountPointOverview,this.FParameters);
         this.FProcessorRelatedAssistance.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorRelatedAssistance.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorRelatedAssistance.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorNightmareTrial = new TProcessorNightmareTrialMain(this.FMountPointWindows,this.FParameters);
         this.FProcessorNightmareTrial.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorNightmareTrial.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorNightmareTrial.OnOpenMapInfoViewFun = this.OpenNightmareMapPointView;
         this.FProcessorHeroCompanion = new TProcessorHeroCompanion(this.FMountPointWindows,this.FParameters);
         this.FProcessorHeroCompanion.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDAstrology = new TProcessorHDAstrology(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDAstrology.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDAstrology.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDAstrology.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDAstrology.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDAstrology.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDAstrology.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDFirstPayBag = new TProcessorHDFirstPayGift(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDFirstPayBag.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDFirstPayBag.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDFirstPayBag.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDFirstPayBag.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDFirstPayBag.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDFirstPayBag.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDFirstPayBag.OnHideHDIcon = this.ProcessorUpdateFirstPayIcon;
         this.FProcessorHDBrushHappy = new TProcessorHDBrushHappy(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDBrushHappy.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDBrushHappy.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDBrushHappy.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDBrushHappy.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDBrushHappy.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDBrushHappy.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDNewServerDraw = new TProcessorHDNewServerDraw(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewServerDraw.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewServerDraw.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewServerDraw.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewServerDraw.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewServerDraw.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewServerDraw.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDNewHallowen = new TProcessorHDNewHalloween(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewHallowen.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewHallowen.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewHallowen.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewHallowen.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewHallowen.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewHallowen.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDThanksgivingDay = new TProcessorHDThanksgivingDay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDThanksgivingDay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDThanksgivingDay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDThanksgivingDay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDThanksgivingDay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDThanksgivingDay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDThanksgivingDay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDChristmas2015 = new TProcessorHDChristmas2015(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDChristmas2015.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDChristmas2015.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDChristmas2015.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDChristmas2015.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDChristmas2015.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDChristmas2015.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDChristmas2015.OnLoadLog = this.ProcessorOnLoadPersonalLog;
         this.FProcessorHDNewYear2016 = new TProcessorHDNewYear2016(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewYear2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewYear2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewYear2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewYear2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYear2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewYear2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDNewYear2016Two = new TProcessorHDNewYear2016Two(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewYear2016Two.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewYear2016Two.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewYear2016Two.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewYear2016Two.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYear2016Two.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewYear2016Two.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDEaster2016 = new TProcessorHDEaster2016(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDEaster2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDEaster2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDEaster2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDEaster2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDEaster2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDEaster2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDGhostKingForg = new TProcessorHDGhostKingForg(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDGhostKingForg.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDGhostKingForg.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDGhostKingForg.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDGhostKingForg.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDGhostKingForg.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDGhostKingForg.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDLaborDay2016 = new TProcessorHDLaborDay2016(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDLaborDay2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDLaborDay2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDLaborDay2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDLaborDay2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDLaborDay2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDLaborDay2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDDuanwujie2016 = new TProcessorHDDuanwujie(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDDuanwujie2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDDuanwujie2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDDuanwujie2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDDuanwujie2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDDuanwujie2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDDuanwujie2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDTreasureHunt = new TProcessorHDTreasureHunt(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDTreasureHunt.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDTreasureHunt.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDTreasureHunt.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDTreasureHunt.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDTreasureHunt.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDTreasureHunt.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDSoulCarnival = new TProcessorHDSoulCarnival(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDSoulCarnival.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDSoulCarnival.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDSoulCarnival.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDSoulCarnival.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDSoulCarnival.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDSoulCarnival.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDKnifeChess = new TProcessorHDKnifeChess(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDKnifeChess.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDKnifeChess.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDKnifeChess.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDKnifeChess.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDKnifeChess.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDKnifeChess.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDNationalDay = new TProcessorHDNationalDay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNationalDay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNationalDay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNationalDay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNationalDay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNationalDay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNationalDay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDHalloween2016 = new TProcessorHDHalloween2016(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDHalloween2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDHalloween2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDHalloween2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDHalloween2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDHalloween2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDHalloween2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDThanksGivingDay2016 = new TProcessorHDThanksGivingDay2016(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDThanksGivingDay2016.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDThanksGivingDay2016.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDThanksGivingDay2016.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDThanksGivingDay2016.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDThanksGivingDay2016.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDThanksGivingDay2016.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDNewYear2017 = new TProcessorHDNewYear2017(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNewYear2017.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNewYear2017.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNewYear2017.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNewYear2017.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNewYear2017.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNewYear2017.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDFoolsDay = new TProcessorHDFoolsDay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDFoolsDay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDFoolsDay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDFoolsDay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDFoolsDay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDFoolsDay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDFoolsDay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDChildrenDay = new TProcessorHDChildrenDay(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDChildrenDay.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDChildrenDay.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDChildrenDay.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDChildrenDay.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDChildrenDay.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDChildrenDay.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDAnniversary = new TProcessorHDAnniversary(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDAnniversary.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDAnniversary.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDAnniversary.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDAnniversary.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDAnniversary.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDAnniversary.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FProcessorHDAnniversary.OnLoadLog = this.ProcessorOnLoadPersonalLog;
         this.FProcessorHDNationalDay2017 = new TProcessorHDNationalDay2017(this.FMountPointWindows,this.FParameters);
         this.FProcessorHDNationalDay2017.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorHDNationalDay2017.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorHDNationalDay2017.OnClose = this.ProcessorsWindowsOnClose;
         this.FProcessorHDNationalDay2017.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorHDNationalDay2017.GetActivityConfig = this.ProcessorActivityOnGetConfig;
         this.FProcessorHDNationalDay2017.EffectNotification = this.ProcessorActivityListEffectNotification;
         this.FUIProcessorProfessionRefine = new TUIProcessorProfessionRefine(this.FMountPointWindows,this.FParameters);
         this.FUIProcessorProfessionRefine.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FUIProcessorProfessionRefine.OnEffectText = this.ProcessorsOnEffectText;
         this.FUIProcessorProfessionRefine.OnClose = this.ProcessorsWindowsOnClose;
         this.FUIProcessorProfessionRefine.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FUIProcessorProfessionRefine.UpdateHeroPower = this.ProcessorOnHeroUpdateBaseAttribute;
         this.FProcessorsWindows = Vector.<TProcessorLobbyWindows>([this.FProcessorProtagonist,this.FProcessorHeros,this.FProcessorTacticalDeployment,this.FProcessorBackpack,this.FProcessorKnifeSoul,this.FProcessorSmithy,this.FProcessorKillHeros,this.FProcessorJade,this.FProcessorGeneralStar,this.FProcessorQuest,this.FProcessorMakeEquip,this.FProcessorTalisman,this.FProcessorMail,this.FProcessorHellButterfly,this.FProcessorFriend,this.FProcessorVIP,this.FProcessorMall,this.FProcessorDailySign,this.FProcessorDailyQuest,this.FProcessorOrganization,this.FProcessorDailyActivity,this.FProcessorShinobidoPractise,this.FProcessorLargeWorldMap,this.FProcessorBarrierAutoBattle,this.FProcessorNpcDialog,this.FProcessorKnifeOfKillSoul,this.FProcessorMentorship,this.FProcessorQianKunARoll,this.FProcessorHDOS,this.FProcessorHDActivityRecharge,this.FProcessorHDGiftBag,this.FProcessorHDFirstPay,this.FProcessorHDCDK,this.FProcessorSuperMarket,this.FProcessorOffceLady,this.FProcessorAchievement,this.FProcessorHDActivityFund
         ,this.FProcessorHDRechargeSuit,this.FProcessorHDEspada,this.FProcessorGirlGame,this.FProcessorHDMaskFright,this.FProcessorHDEquipmentShop,this.FProcessorWelcome,this.FProcessorHDSoulBox,this.FProcessorReveredBook,this.FProcessorBleachDailyRecord,this.FProcessorBleachTrain,this.FProcessorHDGambling,this.FProcessorHDLimitBuy,this.FProcessorHDIceHeros,this.FProcessorHDIceDragon,this.FProcessorHDSuperEggs,this.FProcessorGongFuFightApply,this.FProcessorHDIceDragon,this.FProcessorTokenShop,this.FProcessorStoneShop,this.FProcessorHDTeamBuy,this.FProcessorHDJigsaw,this.FProcessorHDBigTurnTable,this.FProcessorDailyWelfare,this.FProcessorHDServerPay,this.FProcessorHDRandCard,this.FProcessorHeroChange,this.FProcessorBleachJigsawOld,this.FProcessorHDTreasureAwake,this.FProcessorChess,this.FProcessorWorldCup,this.FProcessorHerosMarket,this.FProcessorBlackMarket,this.FProcessorLottery,this.FProcessorPartner,this.FProcessorLuckyJoy,this.FProcessorVainTravel,this.FProcessorSpecialCombatPower,this.FProcessorSwiftChange
         ,this.FProcessorPrivilegeLease,this.FProcessorHDHalloween,this.FProcessorHDCircleTrial,this.FProcessorHDKingLegend,this.FProcessorHDChristmas,this.FProcessorFBBuyGold,this.FProcessorHDNewYearDay,this.FProcessorRelatedPartner,this.FProcessorRelatedAssistance,this.FProcessorHDUniteTask,this.FProcessorHDDreams,this.FProcessorHDNewYearSheep,this.FProcessorHDGoldTurntable,this.FProcessorHDFeedback,this.FProcessorHeroCompanion,this.FProcessorHDDayBack,this.FProcessorHDGrowthPlan,this.FProcessorHDEaster,this.FProcessorHDBleachBag,this.FProcessorHDGallery,this.FProcessorHDDailyHero,this.FProcessorHDPyramid,this.FProcessorHDRushInSeireitei,this.FProcessorHDAstrology,this.FProcessorHDKnifeHeroCollect,this.FProcessorHDCoolSummer,this.FProcessorHDEveryDayAward,this.FProcessorNightmareTrial,this.FProcessorExportPlayer,this.FProcessorHDFirstPayBag,this.FProcessorHDBrushHappy,this.FProcessorBleachAgent,this.FProcessorHDNewServerDraw,this.FProcessorHDNewHallowen,this.FProcessorHDThanksgivingDay,this.FProcessorExpDuplicate
         ,this.FProcessorChangeInfo,this.FProcessorCustomHero,this.FProcessorCollectSoul,this.FProcessorHDChristmas2015,this.FProcessorHDNewYear2016,this.FProcessorHDNewYear2016Two,this.FProcessorRebirth,this.FProcessorHDEaster2016,this.FProcessorSmelt,this.FProcessorHDGhostKingForg,this.FProcessorHDLaborDay2016,this.FProcessorHDDuanwujie2016,this.FProcessorHDTreasureHunt,this.FProcessorEquipForge,this.FProcessorHDSoulCarnival,this.FProcessorHDKnifeChess,this.FProcessorHDNationalDay,this.FProcessorHDHalloween2016,this.FProcessorHDThanksGivingDay2016,this.FProcessorHDNewYear2017,this.FProcessorHDFoolsDay,this.FProcessorHDChildrenDay,this.FProcessorHDAnniversary,this.FProcessorHDNationalDay2017,this.FUIProcessorProfessionRefine]);
         false;
         this.FProcessorsWindows.push(this.FProcessorLikeUs);
         this.FTimeMalls = Vector.<InterfaceTimeMarket>([this.FProcessorBlackMarket,this.FProcessorBlackMarket,this.FProcessorVainTravel,this.FProcessorOrganization,this.FProcessorOrganization]);
      }
      
      protected function ConstructProcessorShortcuts() : void
      {
         this.FProcessorShortcuts = new TProcessorShortcuts(this.FMountPointShortcuts,this.FMountPointShortcutsSpecial,this.FParameters);
         this.FProcessorShortcuts.Load();
         this.FProcessorShortcuts.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorShortcuts.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FProcessorShortcuts.OnAvaterHead = this.ProcessorShortcutsOnAvaterHead;
         this.FProcessorShortcuts.OnVip = this.ProcessorShortcutsOnVip;
         this.FProcessorShortcuts.OnOpenDailySign = this.ProcessorShortcutsOnSign;
         this.FProcessorShortcuts.OnPromote = this.ProcessorOnPromote;
         this.FProcessorShortcuts.OnKnifeSoulClick = this.ProcessorShortcutsOnKnifeSoul;
         this.FProcessorShortcuts.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorShortcuts.OnMall = this.ProcessorShortcutsOnMall;
         this.FProcessorShortcuts.OnPet = this.ProcessorShortcutsOnPet;
         this.FProcessorShortcuts.OnRebirth = this.ProcessorShortcutsOnRebirth;
         this.FProcessorShortcuts.OnSmelt = this.ProcessorShortcutsOnSmelt;
         this.FProcessorShortcuts.OnTreasureMap = this.ProcessorShortcutsOnTreasureMap;
         this.FProcessorShortcuts.OnCDK = this.ProcessorShortcutsOnCDK;
         this.FProcessorShortcuts.OnHeroChange = this.ProcessorShortcutsOnHeroChange;
         this.FProcessorShortcuts.OnBlackMarket = this.ProcessorShortcutsOnBlackMarket;
         this.FProcessorShortcuts.OnExpDuplicate = this.ProcessorShortcutsOnExpDuplicate;
         this.FProcessorShortcuts.OnExportPlayer = this.ProcessorShortcutsOnExportPlayer;
         this.FProcessorShortcuts.OnDailyQuest = this.ProcessorShortcutsOnDailyQuest;
         this.FProcessorShortcuts.OnDailyActivity = this.ProcessorShortcutsOnDailyActivity;
         this.FProcessorShortcuts.OnBleachDailyRecord = this.ProcessorShortcutsOnBleachDailyRecord;
         this.FProcessorShortcuts.OnSign = this.ProcessorShortcutsOnSign;
         this.FProcessorShortcuts.OnAchievement = this.ProcessorShortcutsOnAchievement;
         this.FProcessorShortcuts.OnCrashJade = this.ProcessorShortcutsOnCrashJade;
         this.FProcessorShortcuts.OnArena = this.ProcessorShortcutsOnArena;
         this.FProcessorShortcuts.OnTeamBattle = this.ProcessorShortcutsOnTeamBattle;
         this.FProcessorShortcuts.OnKillHeros = this.ProcessorShortcutsOnKillHeros;
         this.FProcessorShortcuts.OnSevenKings = this.ProcessorShortcutsOnSevenKings;
         this.FProcessorShortcuts.OnSkyTower = this.ProcessorShortcutsOnActiveSpecialSkyTower;
         this.FProcessorShortcuts.OnGongFuFight = this.ProcessorShortcutsOnActiveSpecialGongFuFight;
         this.FProcessorShortcuts.OnBleachTrain = this.ProcessorShortcutsOnBleachTrain;
         this.FProcessorShortcuts.OnOfficeLady = this.ProcessorShortcutsOnOfficeLady;
         this.FProcessorShortcuts.OnSuperMarket = this.ProcessorShortcutsOnSuperMarket;
         this.FProcessorShortcuts.OnDailyWelfare = this.ProcessorShortcutsOnDailyWelfare;
         this.FProcessorShortcuts.OnLikeUs = this.ProcessorShortcutsOnLikeUs;
         this.FProcessorShortcuts.OnSpecialFight = this.ProcessorShortcutsOnSpecialFighter;
         this.FProcessorShortcuts.OnVainTravel = this.ProcessorShortcutsOnVainTravel;
         this.FProcessorShortcuts.OnRelatedPartner = this.ProcessorShortcutsOnRelatedPartner;
         this.FProcessorShortcuts.OnYellowDiamond = this.ProcessorShortcutsOnYellowDiamond;
         this.FProcessorShortcuts.OnGoodAssess = this.ProcessorShortcutsOnGoodAssess;
         this.FProcessorShortcuts.OnShareFriend = this.ProcessorShortcutsOnShareFriend;
         this.FProcessorShortcuts.OnPlatFormSync = this.ProcessorShortcutsOnPlatformSync;
         this.FProcessorShortcuts.OnNightmareTrial = this.ProcessorShortcutsOnNightmareTrial;
         this.FProcessorShortcuts.OnCustomHero = this.ProcessorShortcutsOnCustomHero;
         this.FProcessorShortcuts.OnCollectSoul = this.ProcessorShortcutsOnCollectSoul;
         this.FProcessorShortcuts.OnKingChallenge = this.ProcessorShortcutsOnKingChallenge;
         this.FProcessorShortcuts.OnEquipForge = this.ProcessorShortcutsOnEquipForge;
         this.FProcessorShortcuts.OnProfessionRefine = this.ProcessorShortcutsOnProfessionRefine;
         this.FProcessorShortcuts.OnActiveListWonderful = this.ProcessorShortcutsOnActiveListWonderful;
         this.FProcessorShortcuts.OnActiveCombineActivity = this.ProcessorShortcutsOnActiveListWonderful;
         this.FProcessorShortcuts.OnActiveListRecharge = this.ProcessorShortcutsOnActiveListRecharge;
         this.FProcessorShortcuts.OnActiveListFirstRecharge = this.ProcessorShortcutsOnActiveListFirstRecharge;
         this.FProcessorShortcuts.OnActiveListFund = this.ProcessorShortcutsOnFund;
         this.FProcessorShortcuts.OnActiveListSuperTreasure = this.ProcessorShortcutsOnSuperTreature;
         this.FProcessorShortcuts.OnActiveListRechargeCommon = this.ProcessorShortcutsOnActiveListRechargeCommon;
         this.FProcessorShortcuts.OnActiveListEspada = this.ProcessorShortcutsOnActiveListEspada;
         this.FProcessorShortcuts.OnActiveListMaskFright = this.ProcessorShortcutsOnActiveListMaskFright;
         this.FProcessorShortcuts.OnActiveListEquipmentShop = this.ProcessorShortcutsOnActiveListEquipmentShop;
         this.FProcessorShortcuts.OnActiveListSoulBox = this.ProcessorShortcutsOnActiveListSoulBox;
         this.FProcessorShortcuts.OnActiveListGambling = this.ProcessorShortcutsOnActiveListGambling;
         this.FProcessorShortcuts.OnActiveListLimitBuy = this.ProcessorShortcutsOnActiveListLimitBuy;
         this.FProcessorShortcuts.OnActiveListIceHeros = this.ProcessorShortcutsOnActiveListIceHeros;
         this.FProcessorShortcuts.OnActiveListIceDragon = this.ProcessorShortcutsOnActiveListIceDragon;
         this.FProcessorShortcuts.OnActiveListSuperEggs = this.ProcessorShortcutsOnActiveListSuperEggs;
         this.FProcessorShortcuts.OnActiveListTeamBuy = this.ProcessorShortcutsOnActiveListTeamBuy;
         this.FProcessorShortcuts.OnActiveListJigsaw = this.ProcessorShortcutsOnActiveListJigsaw;
         this.FProcessorShortcuts.OnActiveListBigTurnTable = this.ProcessorShortcutsOnActiveBigTurnTable;
         this.FProcessorShortcuts.OnActiveTreasureAwake = this.ProcessorShortcutsOnActiveTreasureAwake;
         this.FProcessorShortcuts.OnActiveListServerPay = this.ProcessorShortcutsOnActiveServerPay;
         this.FProcessorShortcuts.OnActiveListRandCard = this.ProcessorShortcutsOnActiveRandCard;
         this.FProcessorShortcuts.OnActiveListBleachJigsaw = this.ProcessorShortcutsOnActiveBleachJigsaw;
         this.FProcessorShortcuts.OnActiveChess = this.ProcessorShortcutsOnActiveChess;
         this.FProcessorShortcuts.OnActiveWorldCup = this.ProcessorShortcutsOnActiveWorldCup;
         this.FProcessorShortcuts.OnActiveHerosMarket = this.ProcessorShortcutsOnActiveHerosMarket;
         this.FProcessorShortcuts.OnActiveLottery = this.ProcessorShortcutsOnActiveLottery;
         this.FProcessorShortcuts.OnActivePartner = this.ProcessorShortcutsOnActivePartner;
         this.FProcessorShortcuts.OnActiveLuckyJoy = this.ProcessorShortcutsOnActiveLuckyJoy;
         this.FProcessorShortcuts.OnActiveSwiftChange = this.ProcessorShortcutsOnActiveSwiftChange;
         this.FProcessorShortcuts.OnActivePrivilegeLease = this.ProcessorShortcutsOnActivePrivilegeLease;
         this.FProcessorShortcuts.OnActiveHalloweenActivity = this.ProcessorShortcutsOnActiveHalloween;
         this.FProcessorShortcuts.OnActiveCombineActivity = this.ProcessorShortcutsOnActiveListWonderful;
         this.FProcessorShortcuts.OnActiveCircleTrialActivity = this.ProcessorShortcutsOnActiveCircleTrial;
         this.FProcessorShortcuts.OnActiveKingLegendActivity = this.ProcessorShortcutsOnActiveKingLegend;
         this.FProcessorShortcuts.OnActiveChristmasActivity = this.ProcessorShortcutsOnActiveChristmas;
         this.FProcessorShortcuts.OnActiveNewYearDayActivity = this.ProcessorShortcutsOnNewYearDay;
         this.FProcessorShortcuts.OnActiveUniteTaskActivity = this.ProcessorShortcutsOnUniteTask;
         this.FProcessorShortcuts.OnActiveDreamsComeTrueActivity = this.ProcessorShortcutsOnActiveDreams;
         this.FProcessorShortcuts.OnActiveNewYearSheepActivity = this.ProcessorShortcutsOnActiveNewYearSheep;
         this.FProcessorShortcuts.OnActiveFeedbackActivity = this.ProcessorShortcutsOnActiveFeedback;
         this.FProcessorShortcuts.OnActiveDayBackActivity = this.ProcessorShortcutsOnActiveDayBack;
         this.FProcessorShortcuts.OnActiveGoldTurntableActivity = this.ProcessorShortcutsOnActiveGoldTurntable;
         this.FProcessorShortcuts.OnActiveGrowthPlanActivity = this.ProcessorShortcutsOnActiveGrowthPlan;
         this.FProcessorShortcuts.OnActiveEasterActivity = this.ProcessorShortcutsOnActiveEaster;
         this.FProcessorShortcuts.OnActiveBleachBagActivity = this.ProcessorShortcutsOnActiveBleachBag;
         this.FProcessorShortcuts.OnActiveGalleryActivity = this.ProcessorShortcutsOnActiveGallery;
         this.FProcessorShortcuts.OnActiveDailyHeroActivity = this.ProcessorShortcutsOnActiveDailyHero;
         this.FProcessorShortcuts.OnActivePyramidActivity = this.ProcessorShortcutsOnActivePyramid;
         this.FProcessorShortcuts.OnActiveRushInSeireitei = this.ProcessorShortcutsOnActiveRushInSeireitei;
         this.FProcessorShortcuts.OnActiveAstrologyActivity = this.ProcessorShortcutsOnActiveAstrology;
         this.FProcessorShortcuts.OnActiveKnifeHeroCollect = this.ProcessorShortcutsOnActiveKnifeHeroCollect;
         this.FProcessorShortcuts.OnActiveCoolSummer = this.ProcessorShortcutsOnActiveCoolSummer;
         this.FProcessorShortcuts.OnActiveEveryDayAward = this.ProcessorShortcutsOnActiveEveryDayAward;
         this.FProcessorShortcuts.OnActiveFirstPayBag = this.ProcessorShortcutsOnActiveFirstPayBag;
         this.FProcessorShortcuts.OnActiveBrushHappy = this.ProcessorShortcutsOnActiveBrushHappy;
         this.FProcessorShortcuts.OnActiveNewServerDraw = this.ProcessorShortcutsOnActiveNewServerDraw;
         this.FProcessorShortcuts.OnActiveNewHalloween = this.ProcessorShortcutsOnActiveNewHalloween;
         this.FProcessorShortcuts.OnActiveThanksgivingDay = this.ProcessorShortcutsOnActiveThanksgivingDay;
         this.FProcessorShortcuts.OnActiveChristmas2015 = this.ProcessorShortcutsOnActiveChristmas2015;
         this.FProcessorShortcuts.OnActiveNewYear2016 = this.ProcessorShortcutsOnActiveNewYear2016;
         this.FProcessorShortcuts.OnActiveNewYear2016Two = this.ProcessorShortcutsOnActiveNewYear2016Two;
         this.FProcessorShortcuts.OnActiveEaster2016 = this.ProcessorShortcutsOnActiveEaster2016;
         this.FProcessorShortcuts.OnActiveGhostKingForg = this.ProcessorShortcutsOnActiveGhostKingForg;
         this.FProcessorShortcuts.OnActiveLaborDay2016 = this.ProcessorShortcutsOnActiveLaborDay2016;
         this.FProcessorShortcuts.OnActiveDuanwujie2016 = this.ProcessorShortcutsOnActiveDuanwujie2016;
         this.FProcessorShortcuts.OnActiveTreasureHunt = this.ProcessorShortcutsOnActiveTreasureHunt;
         this.FProcessorShortcuts.OnActiveSoulCarnival = this.ProcessorShortcutsOnActiveSoulCarnival;
         this.FProcessorShortcuts.OnActiveKnifeChess = this.ProcessorShortcutsOnActiveKnifeChess;
         this.FProcessorShortcuts.OnActiveNationalDay = this.ProcessorShortcutsOnActiveNationalDay;
         this.FProcessorShortcuts.OnActiveHalloween2016 = this.ProcessorShortcutsOnActiveHalloween2016;
         this.FProcessorShortcuts.OnActiveThanksGivingDay2016 = this.ProcessorShortcutsOnActiveThanksGivingDay2016;
         this.FProcessorShortcuts.OnActiveNewYear2017 = this.ProcessorShortcutsOnActiveNewYear2017;
         this.FProcessorShortcuts.OnActiveFoolsDay = this.ProcessorShortcutsOnActiveFoolsDay;
         this.FProcessorShortcuts.OnActiveChildrenDay = this.ProcessorShortcutsOnActiveChildrenDay;
         this.FProcessorShortcuts.OnActiveAnniversary = this.ProcessorShortcutsOnActiveAnniversary;
         this.FProcessorShortcuts.OnActiveNationalDay2017 = this.ProcessorShortcutsOnActiveNationalDay2017;
         this.FProcessorShortcuts.OnActiveListReceivePacks = this.ProcessorShortcutsOnActiveListGiftBag;
         this.FProcessorShortcuts.OnActiveListReceiveOrderGift = this.ProcessorShortcutsOnActiveListOrderGift;
         this.FProcessorShortcuts.OnEnterWorldMap = this.ProcessorShortcutsOnEnterLargeWorldMap;
         this.FProcessorShortcuts.OnEnterCity = this.ProcessorsTurnBackTownSceneNtf;
         this.FProcessorShortcuts.OnFriend = this.ProcessorShortcutsOnFriend;
         this.FProcessorShortcuts.OnMail = this.ProcessorShortcutsOnMail;
         this.FProcessorShortcuts.OnQuest = this.ProcessorShortcutsOnQuest;
         this.FProcessorShortcuts.OnSwitchDisplay = this.ProcessorOnShowAndHideMainSceneRoles;
         this.FProcessorShortcuts.OnHeros = this.ProcessorShortcutsOnHeros;
         this.FProcessorShortcuts.OnGeneralStar = this.ProcessorShortcutsOnGeneralStar;
         this.FProcessorShortcuts.OnTacticalDeployment = this.ProcessorShortcutsOnTacticalDeployment;
         this.FProcessorShortcuts.OnBackpack = this.ProcessorShortcutsOnBackpack;
         this.FProcessorShortcuts.OnTreasure = this.ProcessorShortcutsOnTreasure;
         this.FProcessorShortcuts.OnKnifeOfKillSoul = this.ProcessorShortcutsOnKnifeOfKillSoul;
         this.FProcessorShortcuts.OnStrengthen = this.ProcessorShortcutsOnStrengthen;
         this.FProcessorShortcuts.OnOrnamentStrengthen = this.ProcessorShortcutsOnOrnamentStrengthen;
         this.FProcessorShortcuts.OnOrganiZation = this.ProcessorShortcutsOnOrganiZation;
         this.FProcessorShortcuts.OnSevenHeroMap = this.ProcessorShortcutsOnSevenHeroMap;
         this.FProcessorShortcuts.OnReveredBook = this.ProcessorShortcutsOnReveredBook;
         this.FProcessorShortcuts.OnReturn = this.ProcessorsOnEnterTown;
         this.FProcessorShortcuts.OnHome = this.ProcessorShortcutsOnHome;
         this.FProcessorShortcuts.OnNpcTavern = this.ProcessorShortcutsOnTavern;
         this.FProcessorShortcuts.OnNpcJade = this.ProcessorShortcutsOnJade;
         this.FProcessorShortcuts.OnNpcMakeEquip = this.ProcessorShortcutsOnMakeEquip;
         this.FProcessorShortcuts.OnGirlGame = this.ProcessorShortcutsOnGirlGame;
         this.FProcessorShortcuts.ShowOtherHeroInfor = this.ProcessorOnShowHeroInfor;
         this.FProcessorShortcuts.RequestSendMail = this.ProcessorOnOpenWriteMail;
         this.FProcessorShortcuts.RequestWhisper = this.ProcessorsOnRequestWhisper;
         this.FProcessorShortcuts.RequestAddFriend = this.ProcessorOnInterpersonalRelationshipsReq;
         this.FProcessorShortcuts.OnHomeSlave = this.ProcessorShortcutsOnSlave;
         this.FProcessorShortcuts.OnHomeGamble = this.ProcessorShortcutsOnGamble;
         this.FProcessorShortcuts.OnHomeHellButterfly = this.ProcessorShortcutsOnHellButterfly;
         this.FProcessorShortcuts.OnHomeGirl = this.ProcessorsOnOpenGirlFriendWindow;
         this.FProcessorShortcuts.OnShowAchievement = this.ProcessorShowAchievementInfor;
         this.FProcessorShortcuts.OnNotificationLevelGiftBagState = this.ProcessorOnNotificationLevelGiftBagState;
         this.FProcessorShortcuts.OnBleachAgent = this.ProcessorShortcutsOnBleachAgent;
      }
      
      protected function ConstructProcessorChat() : void
      {
         this.FProcessorChat = new TProcessorChat(this.FMountPointChat);
         this.FProcessorChat.visible = false;
         this.FProcessorChat.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorChat.OnInquiryReq = this.ProcessorOnInquiryCharacterIDReq;
         this.FProcessorChat.OnMarquee = this.ProcessorOnMarquee;
         this.FProcessorChat.OnInterpersonalRelationships = this.ProcessorOnInterpersonalRelationshipsReq;
         this.FProcessorChat.OnHackWarningResponse = this.ProcessorOnHackWarningResponse;
         this.FProcessorChat.OnShortcutHyperlinks = this.ProcessorShortcutHyperlinks;
         this.FProcessorChat.OnShowHeroInfor = this.ProcessorOnShowHeroInfor;
         this.FProcessorChat.OnShowInventoryInfor = this.ProcessorOnShowInventoryInfor;
         this.FProcessorChat.OnShowHeroAchievement = this.ProcessorOnShowHeroAchievement;
         this.FProcessorChat.OnShowHeroDescription = this.ProcessorOnShowHeroDescription;
         this.FProcessorChat.OnTeamBattleChatPopNtf = this.ProcessorOnTeamBattleChatPopNtf;
         this.FProcessorChat.Load();
      }
      
      protected function ConstructProcessorLogicModule() : void
      {
         this.FProcessorCheatChecker = new TProcessorCheatChecker(this.FMountPointLogicModule);
         this.FProcessorCheatChecker.OnHackNotification = this.ProcessorsOnHackWarning;
         this.FProcessorCheatChecker.Visible = false;
         this.FProcessorCounter = new TProcessorCounter(this.FMountPointLogicModule);
         this.FProcessorCounter.Visible = false;
         this.FProcessorActivityManager = new TProcessorActivityManager(this.FMountPointLogicModule);
         this.FProcessorActivityManager.Visible = false;
         this.FProcessorActivityManager.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorActivityManager.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorActivityManager.UpdateActivityNotification = this.ProcessorOnOpenActivityListStatusNotification;
         this.FProcessorActivityManager.ShortcutEffectNotification = this.ProcessorShortcutEffectNotification;
         this.FProcessorActivityManager.CDKRetNotification = this.ProcessorOnCDKRetNotification;
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_SuperTreasure,this.FProcessorHDActivitySuperTreature);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_RechargeCommon_2,this.FProcessorHDRechargeSuit);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Espada,this.FProcessorHDEspada);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_ReceivePacks,this.FProcessorHDGiftBag);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_CombineActivity,this.FProcessorHDOS);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Wonderful,this.FProcessorHDOS);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Recharge,this.FProcessorHDActivityRecharge);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_FirstRecharge,this.FProcessorHDFirstPay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Fund,this.FProcessorHDActivityFund);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_MaskFright,this.FProcessorHDMaskFright);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_EquipmentShop,this.FProcessorHDEquipmentShop);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_SoulBox,this.FProcessorHDSoulBox);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Gambling,this.FProcessorHDGambling);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy,this.FProcessorHDLimitBuy);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_IceHeros,this.FProcessorHDIceHeros);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_IceDragon,this.FProcessorHDIceDragon);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs,this.FProcessorHDSuperEggs);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy,this.FProcessorHDTeamBuy);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Jigsaw,this.FProcessorHDJigsaw);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Jigsaw,this.FProcessorHDJigsaw);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_BigTurnTable,this.FProcessorHDBigTurnTable);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_TreasureAwake,this.FProcessorHDTreasureAwake);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_ServerPay,this.FProcessorHDServerPay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_RandCard,this.FProcessorHDRandCard);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_BleachJigsaw,this.FProcessorBleachJigsawOld);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Chess,this.FProcessorChess);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_WorldCup,this.FProcessorWorldCup);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_HerosMarket,this.FProcessorHerosMarket);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Lottery,this.FProcessorLottery);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Partner,this.FProcessorPartner);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_LuckyJoy,this.FProcessorLuckyJoy);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_SwiftChange,this.FProcessorSwiftChange);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_PrivilegeLease,this.FProcessorPrivilegeLease);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPay,this.FProcessorHDHalloween);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenTree,this.FProcessorHDHalloween);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPumpkin,this.FProcessorHDHalloween);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenShop,this.FProcessorHDHalloween);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_CircleTrial,this.FProcessorHDCircleTrial);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_KingLegend,this.FProcessorHDKingLegend);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Christmas,this.FProcessorHDChristmas);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewYearDay,this.FProcessorHDNewYearDay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_UniteTask,this.FProcessorHDUniteTask);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Dreams,this.FProcessorHDDreams);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewYearSheep,this.FProcessorHDNewYearSheep);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_GoldTurntable,this.FProcessorHDGoldTurntable);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Feedback,this.FProcessorHDFeedback);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_DayBack,this.FProcessorHDDayBack);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_GrowthPlan,this.FProcessorHDGrowthPlan);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Easter,this.FProcessorHDEaster);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_BleachBag,this.FProcessorHDBleachBag);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Gallery,this.FProcessorHDGallery);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_RushInSeireitei,this.FProcessorHDRushInSeireitei);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_DailyHero,this.FProcessorHDDailyHero);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Pyramid,this.FProcessorHDPyramid);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_AstrologyHouse,this.FProcessorHDAstrology);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_KnifeHeroCollect,this.FProcessorHDKnifeHeroCollect);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_CoolSummer,this.FProcessorHDCoolSummer);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_EveryDayAward,this.FProcessorHDEveryDayAward);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_FirstPayBag,this.FProcessorHDFirstPayBag);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_BrushHappy,this.FProcessorHDBrushHappy);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewServerDraw,this.FProcessorHDNewServerDraw);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewHalloween,this.FProcessorHDNewHallowen);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_ThanksgivingDay,this.FProcessorHDThanksgivingDay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Christmas2015,this.FProcessorHDChristmas2015);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewYear2016,this.FProcessorHDNewYear2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewYear2016Two,this.FProcessorHDNewYear2016Two);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Easter2016,this.FProcessorHDEaster2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_GhostKingForg,this.FProcessorHDGhostKingForg);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_LaborDay2016,this.FProcessorHDLaborDay2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Duanwujie2016,this.FProcessorHDDuanwujie2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_TreasureHunt,this.FProcessorHDTreasureHunt);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_SoulCarnival,this.FProcessorHDSoulCarnival);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_KnifeChess,this.FProcessorHDKnifeChess);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NationalDay,this.FProcessorHDNationalDay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Halloween2016,this.FProcessorHDHalloween2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_ThanksGivingDay2016,this.FProcessorHDThanksGivingDay2016);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NewYear2017,this.FProcessorHDNewYear2017);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_FoolsDay,this.FProcessorHDFoolsDay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_ChildrenDay,this.FProcessorHDChildrenDay);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_Anniversary,this.FProcessorHDAnniversary);
         this.FProcessorActivityManager.AddListener(CONST_SHORTCUTS.TYPE_ActiveList_NationalDay2017,this.FProcessorHDNationalDay2017);
         this.FProcessorPost = new TProcessorPost(this.FMountPointLogicModule);
         this.FProcessorPost.Visible = false;
         this.FProcessorPost.OnPost = this.ProcessorOnPost;
         this.FProcessorPost.Load();
      }
      
      protected function ConstructProcessorPopTips() : void
      {
         this.FProcessorPopTips = new TProcessorPopTips(this.FMountPointChat);
         this.FProcessorPopTips.Visible = false;
         this.FProcessorPopTips.OnOpenPlantWindowByIndex = this.ProcessorOnOpenModel;
         this.FProcessorPopTips.Load();
      }
      
      protected function ConstructADBox() : void
      {
         this.FProcessorADBox = new TProcessorADBox(this.FMountPointWindows);
         this.FProcessorADBox.Visible = true;
         this.FProcessorADBox.Load();
      }
      
      protected function ConstructProcessorFreshGuide() : void
      {
         this.FProcessorFreshGuide = new TProcessorFreshGuide(this.FMountPointWindows,this.FParameters);
         this.FProcessorFreshGuide.visible = true;
         this.FProcessorFreshGuide.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorFreshGuide.AutoSetDeployment = this.ProcessorsOnGetAutoSetDeployment;
         this.FProcessorFreshGuide.OnActivatingChannel = this.ProcessorOnActivatingChannel;
         this.FProcessorFreshGuide.OnPromotFreshGuide = this.ProcessorOnPromotFreshGuide;
         this.FProcessorFreshGuide.OnPromotDeplymentFreshGuide = this.ProcessorOnDeploymentPromotFreshGuide;
         this.FProcessorFreshGuide.OnPromotKnifeOfKillSoulFreshGuide = this.ProcessorOnKnifeOfKillSoulPromotFreshGuide;
         this.FProcessorFreshGuide.OnShowWindowWelcome = this.ProcessorShortcutsOnWelcome;
         this.FProcessorFreshGuide.OnPromotTraven = this.ProcessorOnPromotTraven;
         SLogicsCore.ProcessorFreshGuide = this.FProcessorFreshGuide;
         this.FProcessorFreshGuide.Load();
      }
      
      protected function ConstructProcessorsOverview() : void
      {
         this.FProcessorInspector = new TProcessorInspector(this.FMountPointOverview,this.FParameters);
         this.FProcessorInspector.Visible = true;
         this.FProcessorInspector.OnDialogMsg = this.ProcessorOnDialogMsg;
         this.FProcessorInspector.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorInspector.OnEffectTransition = this.ProcessorOnEffectTransition;
         this.FProcessorInspector.OnChatAnnouncement = this.ProcessorOnChatAnnouncement;
         this.FProcessorInspector.OnAntiAddiction = this.ProcessorOnAntiAddiction;
         this.FProcessorInspector.OnQuertInventoryIDRet = this.ProcessorOnQuertInventoryIDRet;
         this.FProcessorPurchase = new TProcessorPurchase(this.FMountPointOverview);
         this.FProcessorPurchase.Visible = false;
         this.FProcessorPurchase.OnEffectText = this.ProcessorsOnEffectText;
         this.FProcessorPurchase.OnOpenVIP = this.ProcessorShortcutsOnVip;
         this.FProcessorPurchase.Load();
         this.FProcessorUnlock = new TProcessorUnlock(this.FMountPointOverview,this.FParameters);
         this.FProcessorUnlock.Visible = false;
         this.FProcessorUnlock.OnUpdateShortcutsState = this.ProcessorOnUpdateShortcutsState;
         this.FProcessorUnlock.OnUnlockingNotification = this.ProcessorOnUnlockingNotification;
         this.FProcessorUnlock.OnUnlockedNotification = this.ProcessorOnUnlockedNotification;
         this.FProcessorUnlock.Load();
         this.FProcessorLog = new TProcessorLog(this);
         this.FProcessorModuleLoader = new TProcessorModuleLoader(this.FMountPointOverview,this.FParameters);
         this.FProcessorModuleLoader.Visible = false;
         this.FProcessorModuleLoader.Load();
      }
      
      protected function ConstructBarrier() : void
      {
         this.FBarrier = new TUIBarrier(this.FMountPointBarrier);
         this.FBarrier.Width = CONST_COMMON.STAGE_Width;
         this.FBarrier.Height = CONST_COMMON.STAGE_Height;
         this.FBarrier.Color = 2147483648;
         this.FBarrier.Visible = false;
         this.FBarrier.Init();
      }
      
      protected function ConstructBarrierAddition() : void
      {
         this.FBarrierAddition = new TUIBarrier(this.FMountPointBarrierAddition);
         this.FBarrierAddition.Width = CONST_COMMON.STAGE_Width;
         this.FBarrierAddition.Height = CONST_COMMON.STAGE_Height;
         this.FBarrierAddition.Color = 268435456;
         this.FBarrierAddition.Visible = false;
         this.FBarrierAddition.Init();
      }
      
      protected function PreProcessorPlateSwitch(param1:TProcessorLobbyPlate) : void
      {
         if(this.FProcessorPlateActive != null && this.FProcessorPlateActive == this.FProcessorWindowOrgPointMap && param1 == this.FProcessorMainSceneTwo)
         {
            this.ProcessorWindowsSwitch(this.FProcessorOrganization);
         }
         else if(this.FProcessorPlateActive != null && this.FProcessorPlateActive == this.FProcessorNightmareMap && param1 == this.FProcessorMainSceneTwo)
         {
            this.ProcessorWindowsSwitch(this.FProcessorNightmareTrial);
         }
      }
      
      protected function ProcessorPlateSwitch(param1:TProcessorLobbyPlate, param2:ByteArray = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TProcessorLobbyPlate = null;
         this.PreProcessorPlateSwitch(param1);
         if(this.FProcessorPlateActive != null)
         {
            this.FProcessorPlateActive.Unmount();
         }
         _loc3_ = int(this.FProcessorsPlate.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FProcessorsPlate[_loc4_];
            if(param1 == _loc5_)
            {
               _loc5_.Visible = true;
            }
            else
            {
               _loc5_.Visible = false;
            }
            _loc4_++;
         }
         this.FProcessorPlateActive = param1;
         if(param1 != null)
         {
            this.FProcessorShortcuts.SetupShortcutsShow(param1.ShowShortcutsPosition,param1.ShowShortcutsLocation);
            param1.Mount(param2);
            FAffairGenerator.Generate(AFFAIRID_TimingWaitBattleActive);
            FAffairGenerator.Generate(AFFAIRID_ChatOptionsSetup);
            FAffairGenerator.Generate(AFFAIRID_ChatOptionsApply);
            FAffairGenerator.Generate(AFFAIRID_GameStateExternalize);
         }
      }
      
      protected function ProcessorWindowsSwitch(param1:TProcessorLobbyWindows, param2:ByteArray = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TProcessorLobbyWindows = null;
         if(this.FProcessorWindowsActive != null)
         {
            this.FProcessorWindowsActive.Unmount();
         }
         _loc3_ = int(this.FProcessorsWindows.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FProcessorsWindows[_loc4_];
            if(param1 == _loc5_)
            {
               _loc5_.visible = true;
            }
            else
            {
               _loc5_.visible = false;
            }
            _loc4_++;
         }
         if(param1 != null)
         {
            param1.Mount(param2);
            this.FParameters.ActuatorBarrier.Actuate(param1);
         }
         if(this.FProcessorWindowsActive != null)
         {
            this.FParameters.ActuatorBarrier.Deactuate(this.FProcessorWindowsActive);
         }
         this.FProcessorWindowsActive = param1;
      }
      
      protected function BattleQueryActive() : Boolean
      {
         this.FQueryBoolean.Value = false;
         if(this.FOnQueryBattleActive != null)
         {
            this.FOnQueryBattleActive(this,this.FQueryBoolean);
         }
         return this.FQueryBoolean.Value;
      }
      
      protected function BattleQueryLoading() : Boolean
      {
         this.FQueryBoolean.Value = false;
         if(this.FOnQueryBattleLoading != null)
         {
            this.FOnQueryBattleLoading(this,this.FQueryBoolean);
         }
         return this.FQueryBoolean.Value;
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(0x01187E00,this.IllusionInfoRet);
         FPacketRoutines.Register(0x01187E01,this.IllusionFightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Town,this.PacketPerform_SC_Enter_Town);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_WorldMap,this.PacketPerform_SC_Enter_WorldMap);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Hurdle,this.PacketPerform_SC_Enter_Hurdle);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_KillHeros,this.PacketPerform_SC_Enter_KillHeros);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Tavern,this.PacketPerform_SC_Enter_Tavern);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Arena,this.PacketPerform_SC_Enter_Arena);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TreasureMap,this.PacketPerform_SC_Enter_TreasureMap);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_CityDefend,this.PacketPerform_SC_Enter_CityDefend);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_FightPet,this.PacketPerform_SC_Enter_FightPet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_OrganizationWar,this.PacketPerform_SC_Enter_OrganizationalWar);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Home,this.PacketPerform_SC_Enter_Home);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TraitorAttack,this.PacketPerform_SC_Enter_TraitorAttack);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_SevenKing,this.PacketPerform_SC_Enter_SevenKing);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TeamBattle,this.PacketPerform_SC_Enter_TeamBattle);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TeamBattle_PVP,this.PacketPerform_SC_Enter_TeamBattle_PVP);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TeamBattle_PVE,this.PacketPerform_SC_Enter_TeamBattle_PVE);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_PlayerRoom,this.PacketPerform_SC_Enter_PlayerRoom);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_SkyTower,this.PacketPerform_SC_Enter_SkyTower);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_GongFuFight,this.PacketPerform_SC_Enter_GongFuFight);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_CrashJade,this.PacketPerform_SC_Enter_CrashJade);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_Pet,this.PacketPerform_SC_Enter_Pet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_GroupMoney,this.PacketPerform_SC_Enter_GroupMoney);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CHAT_Base,CONST_NETWORK.PACKETID_SC_CHAT_End,this.PacketPerform_ProcessorChat);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_ACCOUNT_Base,CONST_NETWORK.PACKETID_SC_LOBBY_ACCOUNT_End,this.PacketPerform_ProcessorAccount);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_TOWN_Base,CONST_NETWORK.PACKETID_SC_LOBBY_TOWN_End,this.PacketPerform_SC_SceneRoleContorl);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_WORLDMAP_Base,CONST_NETWORK.PACKETID_SC_LOBBY_WORLDMAP_End,this.PacketPerform_ProcessorWorldMap);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_HURDLE_Base,CONST_NETWORK.PACKETID_SC_LOBBY_HURDLE_End,this.PacketPerform_ProcessorHurdle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Arena_Base,CONST_NETWORK.PACKETID_SC_Arena_End,this.PacketPerform_ProcessorArena);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TreasureMap_Base,CONST_NETWORK.PACKETID_SC_TreasureMap_End,this.PacketPerform_ProcessorTreasureMap);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TACTICALDEPLOYMENT_Base,CONST_NETWORK.PACKETID_SC_TACTICALDEPLOYMENT_End,this.PacketPerform_ProcessorTacticalDeployment);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_JADE_Base,CONST_NETWORK.PACKETID_SC_JADE_End,this.PacketPerform_ProcessorJade);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GENERALSTAR_Base,CONST_NETWORK.PACKETID_SC_GENERALSTAR_End,this.PacketPerform_ProcessorGeneralStar);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Task_Base,CONST_NETWORK.PACKETID_SC_Task_End,this.PacketPerform_ProcessorTask);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Smithy_Base,CONST_NETWORK.PACKETID_SC_Smithy_End,this.PacketPerform_ProcessorSmithy);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_MILITARYRANK_Base,CONST_NETWORK.PACKETID_SC_MILITARYRANK_End,this.PacketPerform_ProcessorMilitary);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_KILLHEROS_Base,CONST_NETWORK.PACKETID_SC_LOBBY_KILLHEROS_End,this.PacketPerform_ProcessorKillHeros);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_BACKPACK_Base,CONST_NETWORK.PACKETID_SC_LOBBY_BACKPACK_End,this.PacketPerform_ProcessorBackpack);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_HEROS_Base,CONST_NETWORK.PACKETID_SC_LOBBY_HEROS_End,this.PacketPerform_ProcessorHeros);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Tavern_Base,CONST_NETWORK.PACKETID_SC_Tavern_End,this.PacketPerform_ProcessorTavern);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Talisman_Base,CONST_NETWORK.PACKETID_SC_Talisman_End,this.PacketPerform_ProcessorTalisman);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_MAIL_Base,CONST_NETWORK.PACKETID_SC_MAIL_End,this.PacketPerform_ProcessorMail);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_EQUIP_Base,CONST_NETWORK.PACKETID_SC_EQUIP_End,this.PacketPerform_ProcessorEquipMake);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KnifeSoul_Base,CONST_NETWORK.PACKETID_SC_KnifeSoul_End,this.PacketPerform_ProcessorKnifeSoul);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KnifeOfKillSoul_Base,CONST_NETWORK.PACKETID_SC_KnifeOfKillSoul_End,this.PacketPerform_ProcessorKnifeOfKillSoul);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_FRIEND_Base,CONST_NETWORK.PACKETID_SC_LOBBY_FRIEND_End,this.PacketPerform_ProcessorFriend);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Purchase_Base,CONST_NETWORK.PACKETID_SC_Purchase_End,this.PacketPerform_ProcessorPurchase);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Mall_Base,CONST_NETWORK.PACKETID_SC_Mall_End,this.PacketPerform_ProcessorMall);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Sign_Base,CONST_NETWORK.PACKETID_SC_Sign_End,this.PacketPerform_ProcessorSign);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyTask_Base,CONST_NETWORK.PACKETID_SC_DailyTask_End,this.PacketPerform_ProcessorDailyTask);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HellButterfly_Base,CONST_NETWORK.PACKETID_SC_HellButterfly_End,this.PacketPerform_ProcessorHellButterfly);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NijiaStar_Base,CONST_NETWORK.PACKETID_SC_NijiaStar_End,this.PacketPerform_ProcessorNijiastar);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_SevenKing_Base,CONST_NETWORK.PACKETID_SC_SevenKing_End,this.PacketPerform_ProcessorSevenKing);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_INSPECTOR_Base,CONST_NETWORK.PACKETID_SC_INSPECTOR_End,this.PacketPerform_ProcessorInspector);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VIP_Base,CONST_NETWORK.PACKETID_SC_VIP_End,this.PacketPerform_ProcessorVIP);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Organization_Base,CONST_NETWORK.PACKETID_SC_Organization_End,this.PacketPerform_ProcessorOrganization);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Mentorship_Base,CONST_NETWORK.PACKETID_SC_Mentorship_End,this.PacketPerform_ProcessorMentorship);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_QianKunARoll_Base,CONST_NETWORK.PACKETID_SC_QianKunARoll_End,this.PacketPerform_ProcessorQianKunARoll);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ACTIVITY_Base,CONST_NETWORK.PACKETID_SC_ACTIVITY_End,this.PacketPerform_ProcessorActivityList);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDACTIVITYOS_Base,CONST_NETWORK.PACKETID_SC_HDActivityOS_End,this.PacketPerform_ProcessorActivityListOS);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDACTIVITYGB_Base,CONST_NETWORK.PACKETID_SC_HDActivityGB_End,this.PacketPerform_ProcessorActivityListGB);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyActivity_Base,CONST_NETWORK.PACKETID_SC_DailyActivity_End,this.PacketPerform_ProcessorDailyActivity);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDActivityRecharge_Base,CONST_NETWORK.PACKETID_SC_HDActivityRecharge_End,this.PacketPerform_ProcessorHDActivityRecharge);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDActivityFund_Base,CONST_NETWORK.PACKETID_SC_HDActivityFund_End,this.PacketPerform_ProcessorHDActivityFund);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Post_Base,CONST_NETWORK.PACKETID_SC_Post_End,this.PacketPerform_ProcessorPost);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_OrganizationWar_Base,CONST_NETWORK.PACKETID_SC_OrganizationWar_End,this.PacketPerform_ProcessorOrganizationalWar);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CityDefend_Base,CONST_NETWORK.PACKETID_SC_CityDefend_End,this.PacketPerform_ProcessorCityDefend);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FightPet_Base,CONST_NETWORK.PACKETID_SC_FightPet_End,this.PacketPerform_ProcessorFightPet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TraitorAttack_Base,CONST_NETWORK.PACKETID_SC_TraitorAttack_End,this.PacketPerform_ProcessorTraitorAttack);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FightingShow_Base,CONST_NETWORK.PACKETID_SC_FightingShow_End,this.PacketPerform_ProcessorFightingShow);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Home_Base,CONST_NETWORK.PACKETID_SC_Home_End,this.PacketPerform_ProcessorHome);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_YellowDiamond_Base,CONST_NETWORK.PACKETID_SC_YellowDiamond_End,this.PacketPerform_ProcessorYellowDiamond);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_COUNTER_Base,CONST_NETWORK.PACKETID_SC_COUNTER_End,this.PacketPerform_ProcessorLimit);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FreshGuide_Base,CONST_NETWORK.PACKETID_SC_FreshGuide_End,this.PacketPerform_ProcessorFreshGuide);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Achievement_Base,CONST_NETWORK.PACKETID_SC_Achievement_End,this.PacketPerform_ProcessorAchievement);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLE_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLE_End,this.PacketPerform_ProcessorTeamBattle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_End,this.PacketPerform_ProcessorTeamBattle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_End,this.PacketPerform_ProcessorTeamBattle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ORNAMENT_Base,CONST_NETWORK.PACKETID_SC_ORNAMENT_End,this.PacketPerform_ProcessorOrnamentStrengthen);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GirlGame_Base,CONST_NETWORK.PACKETID_SC_GirlGame_End,this.PacketPerform_ProcessorGirlGame);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ReveredBook_Base,CONST_NETWORK.PACKETID_SC_ReveredBook_End,this.PacketPerform_ProcessorReveredBook);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Welcome_Base,CONST_NETWORK.PACKETID_SC_Welcome_End,this.PacketPerform_ProcessorWelcome);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachDailyRecord_Base,CONST_NETWORK.PACKETID_SC_BleachDailyRecord_End,this.PacketPerform_ProcessorBleachDailyRecord);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachTrain_Base,CONST_NETWORK.PACKETID_SC_BleachTrain_End,this.PacketPerform_ProcessorBleachTrain);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_SkyTower_Base,CONST_NETWORK.PACKETID_SC_SkyTower_End,this.PacketPerform_ProcessorSkyTower);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GongFuFight_Base,CONST_NETWORK.PACKETID_SC_GongFuFight_End,this.PacketPerform_ProcessorGongFuFight);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Log_Base,CONST_NETWORK.PACKETID_SC_Log_End,this.PacketPerform_ProcessorLog);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CrashJade_Base,CONST_NETWORK.PACKETID_SC_CrashJade_End,this.PacketPerform_ProcessorCrashJade);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyWelfare_Base,CONST_NETWORK.PACKETID_SC_DailyWelfare_End,this.PacketPerform_ProcessorWelfare);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TreasureAwake_Base,CONST_NETWORK.PACKETID_SC_TreasureAwake_End,this.PacketPerform_ProcessorTreasureAwake);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HeroChange_Base,CONST_NETWORK.PACKETID_SC_HeroChange_End,this.PacketPerform_ProcessorHeroChange);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BlackMarket_Base,CONST_NETWORK.PACKETID_SC_BlackMarket_End,this.PacketPerform_ProcessorBlackMarket);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Pet_Base,CONST_NETWORK.PACKETID_SC_Pet_End,this.PacketPerform_ProcessorPet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetHouse_Base,CONST_NETWORK.PACKETID_SC_PetHouse_End,this.PacketPerform_ProcessorPet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetTrain_Base,CONST_NETWORK.PACKETID_SC_PetTrain_End,this.PacketPerform_ProcessorPet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetStudy_Base,CONST_NETWORK.PACKETID_SC_PetStudy_End,this.PacketPerform_ProcessorPet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LikeUs_Base,CONST_NETWORK.PACKETID_SC_LikeUs_End,this.PacketPerform_ProcessorLikeUs);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VainTravel_Base,CONST_NETWORK.PACKETID_SC_VainTravel_End,this.PacketPerform_ProcessorVainTravel);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HeroRecruit_Base,CONST_NETWORK.PACKETID_SC_HeroRecruit_End,this.PacketPerform_ProcessorRecruitHero);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Companion_Base,CONST_NETWORK.PACKETID_SC_Companion_End,this.PacketPerform_ProcessorHeroCompanion);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_OrgPointMap_Base,CONST_NETWORK.PACKETID_SC_OrgPointMap_End,this.PacketPerform_ProcessorOrgPointMap);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_Base,CONST_NETWORK.PACKETID_SC_PointMapInfoUI_End,this.PacketPerform_ProcessorOrgPointMap);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TimeMall_InitDataRet,this.PacketPerform_ProcessorTimeMallInitDataRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TimeMall_RefreshRet,this.PacketPerform_ProcessorTimeMallRefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TimeMall_BuyGoodRet,this.PacketPerform_ProcessorTimeMallBuyGoodRet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Related_Base,CONST_NETWORK.PACKETID_SC_Related_End,this.PacketPerform_ProcessorRelatedPartner);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NightmareTrial_Base,CONST_NETWORK.PACKETID_SC_NightmareTrial_End,this.PacketPerform_ProcessorNightmaeTrial);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NightmareTrialPointMap_Base,CONST_NETWORK.PACKETID_SC_NightmareTrialPointMap_End,this.PacketPerform_ProcessorNightmaePointMap);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachAgent_Base,CONST_NETWORK.PACKETID_SC_BleachAgent_End,this.PacketPerform_ProcessorBleachAgent);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ExpDuplicate_Base,CONST_NETWORK.PACKETID_SC_ExpDuplicate_End,this.PacketPerform_ProcessorExpDuplicate);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ChangeInfo_Base,CONST_NETWORK.PACKETID_SC_ChangeInfo_End,this.PacketPerform_ProcessorChangeInfo);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CustomHero_Base,CONST_NETWORK.PACKETID_SC_CustomHero_End,this.PacketPerform_ProcessorCustomHero);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CollectSoul_Base,CONST_NETWORK.PACKETID_SC_CollectSoul_End,this.PacketPerform_ProcessorCollectSoul);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Rebirth_Base,CONST_NETWORK.PACKETID_SC_Rebirth_End,this.PacketPerform_ProcessorRebirth);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KingChallenge_Base,CONST_NETWORK.PACKETID_SC_KingChallenge_End,this.PacketPerform_ProcessorKingChallenge);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_Base,CONST_NETWORK.PACKETID_SC_VoidSoulWorld_End,this.PacketPerform_VoidSoulWorld);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Smelt_Base,CONST_NETWORK.PACKETID_SC_Smelt_End,this.PacketPerform_ProcessorSmelt);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_UltimateEquip_Base,CONST_NETWORK.PACKETID_SC_UltimateEquip_End,this.PacketPerform_ProcessorEquipForge);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ProfessionRefine_Base,CONST_NETWORK.PACKETID_SC_ProfessionRefine_End,this.PacketPerform_ProcessorProfessionRefine);
      }
      
      protected function PacketPerform_SC_Enter_Town(param1:TPacket) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorMainSceneTwo,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_WorldMap(param1:TPacket) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorLargeWorldMap,param1.Data);
         SLogicsCore.SinalPostFreshGuide(CONST_FRESHGUIDE.EVENTID_OpenWorldMap);
      }
      
      protected function PacketPerform_SC_Enter_Hurdle(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorLobbyOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_SC_Enter_KillHeros(param1:TPacket) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorKillHeros,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_Tavern(param1:TPacket) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorTavern,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_Arena(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorArena,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_TreasureMap(param1:TPacket) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorTreasureMap,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_CityDefend(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorCityDefend,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_FightPet(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorFightPet,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_TraitorAttack(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorTraitorAttack,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_OrganizationalWar(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            this.ProcessorsOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_6));
            return;
         }
         this.ProcessorPlateSwitch(this.FOrganizationalWar,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_Home(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorHome,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_SevenKing(param1:TPacket) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorSevenKing,param1.Data);
      }
      
      protected function PacketPerform_SC_Enter_TeamBattle(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorTeamBattle,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_TeamBattle_PVP(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_SC_Enter_TeamBattle_PVE(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_SC_Enter_PlayerRoom(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_SC_Enter_SkyTower(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorSkyTower,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_GongFuFight(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ == 1)
         {
            this.ProcessorPlateSwitch(this.FProcessorGongFuFight,param1.Data);
            SLogicsCore.GongFuFightData.GongFuFightBaseInfor.GongFuFightState = CONST_GONGFUFIGHT.GongFuFightState_CanFight;
         }
         else if(_loc2_ == 0)
         {
            this.ProcessorWindowsSwitch(this.FProcessorGongFuFightApply,null);
            SLogicsCore.GongFuFightData.GongFuFightBaseInfor.GongFuFightState = CONST_GONGFUFIGHT.GongFuFightState_NotFight;
         }
         else if(this.FProcessorGongFuFight.Visible)
         {
            this.ProcessorsOnEnterTown(this);
         }
         else if(this.FProcessorGongFuFightApply.Visible)
         {
            this.ProcessorWindowsSwitch(null);
         }
      }
      
      protected function PacketPerform_SC_Enter_CrashJade(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorCrashJade,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_Pet(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.ProcessorPlateSwitch(this.FProcessorPet,param1.Data);
         }
      }
      
      protected function PacketPerform_SC_Enter_GroupMoney(param1:TPacket) : void
      {
         if(this.VerificationPacketRet(param1.Data))
         {
            this.FProcessorOrganization.UpdateGroupMoney(param1);
         }
      }
      
      protected function PacketPerform_ProcessorAccount(param1:TPacket) : void
      {
         this.FProcessorAccount.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorWorldMap(param1:TPacket) : void
      {
         this.FProcessorLargeWorldMap.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHurdle(param1:TPacket) : void
      {
         this.FProcessorMonsterMap.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorKillHeros(param1:TPacket) : void
      {
         this.FProcessorKillHeros.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorArena(param1:TPacket) : void
      {
         this.FProcessorArena.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTreasureMap(param1:TPacket) : void
      {
         this.FProcessorTreasureMap.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorGeneralStar(param1:TPacket) : void
      {
         this.FProcessorGeneralStar.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTask(param1:TPacket) : void
      {
         this.FProcessorQuest.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorSmithy(param1:TPacket) : void
      {
         this.FProcessorSmithy.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorMilitary(param1:TPacket) : void
      {
         this.FProcessorProtagonist.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorPost(param1:TPacket) : void
      {
         this.FProcessorPost.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorFightPet(param1:TPacket) : void
      {
         this.FProcessorFightPet.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTraitorAttack(param1:TPacket) : void
      {
         this.FProcessorTraitorAttack.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorFightingShow(param1:TPacket) : void
      {
         this.FProcessorShinobidoPractise.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorOrganizationalWar(param1:TPacket) : void
      {
         this.FOrganizationalWar.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorCityDefend(param1:TPacket) : void
      {
         this.FProcessorCityDefend.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorHome(param1:TPacket) : void
      {
         this.FProcessorHome.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorYellowDiamond(param1:TPacket) : void
      {
         this.FProcessorYellowDiamon.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorFreshGuide(param1:TPacket) : void
      {
         this.FProcessorFreshGuide.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorAchievement(param1:TPacket) : void
      {
         this.FProcessorAchievement.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorTeamBattle(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorOrnamentStrengthen(param1:TPacket) : void
      {
         this.FProcessorOrnamentStrengthen.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorGirlGame(param1:TPacket) : void
      {
         this.FProcessorGirlGame.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorReveredBook(param1:TPacket) : void
      {
         this.FProcessorReveredBook.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorWelcome(param1:TPacket) : void
      {
         this.FProcessorWelcome.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorBleachDailyRecord(param1:TPacket) : void
      {
         this.FProcessorBleachDailyRecord.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorBleachTrain(param1:TPacket) : void
      {
         this.FProcessorBleachTrain.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorSkyTower(param1:TPacket) : void
      {
         this.FProcessorSkyTower.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorGongFuFight(param1:TPacket) : void
      {
         this.FProcessorGongFuFight.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorLog(param1:TPacket) : void
      {
         this.FProcessorLog.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorCrashJade(param1:TPacket) : void
      {
         this.FProcessorCrashJade.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorWelfare(param1:TPacket) : void
      {
         this.FProcessorDailyWelfare.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorBleachJigsaw(param1:TPacket) : void
      {
         this.FProcessorBleachJigsawOld.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorChess(param1:TPacket) : void
      {
         this.FProcessorChess.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorWorldCup(param1:TPacket) : void
      {
         this.FProcessorWorldCup.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorHeorsMarket(param1:TPacket) : void
      {
         this.FProcessorHerosMarket.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorLottery(param1:TPacket) : void
      {
         this.FProcessorLottery.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorTreasureAwake(param1:TPacket) : void
      {
         this.FProcessorHDTreasureAwake.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorHeroChange(param1:TPacket) : void
      {
         this.FProcessorHeroChange.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorBleachAgent(param1:TPacket) : void
      {
         this.FProcessorBleachAgent.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorCustomHero(param1:TPacket) : void
      {
         this.FProcessorCustomHero.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorCollectSoul(param1:TPacket) : void
      {
         this.FProcessorCollectSoul.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorBlackMarket(param1:TPacket) : void
      {
         this.FProcessorBlackMarket.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorExpDuplicate(param1:TPacket) : void
      {
         this.FProcessorExpDuplicate.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorPet(param1:TPacket) : void
      {
         this.FProcessorPet.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorLikeUs(param1:TPacket) : void
      {
         this.FProcessorLikeUs.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorVainTravel(param1:TPacket) : void
      {
         this.FProcessorVainTravel.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorRecruitHero(param1:TPacket) : void
      {
         if(param1.Identifier == CONST_NETWORK.PACKETID_SC_TavernAddQuality_Ret)
         {
            this.FProcessorTavern.PacketProcess(param1);
         }
         else
         {
            this.FProcessorSpecialCombatPower.PacketProcess(param1);
         }
      }
      
      public function PacketPerform_ProcessorHeroCompanion(param1:TPacket) : void
      {
         this.FProcessorHeroCompanion.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorOrgPointMap(param1:TPacket) : void
      {
         this.FProcessorWindowOrgPointMap.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorChangeInfo(param1:TPacket) : void
      {
         this.FProcessorChangeInfo.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorRebirth(param1:TPacket) : void
      {
         this.FProcessorRebirth.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorSmelt(param1:TPacket) : void
      {
         this.FProcessorSmelt.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorEquipForge(param1:TPacket) : void
      {
         this.FProcessorEquipForge.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorKingChallenge(param1:TPacket) : void
      {
         this.FProcessorKingChallenge.PacketProcess(param1);
      }
      
      public function PacketPerform_VoidSoulWorld(param1:TPacket) : void
      {
         this.FProcessorVoidSoulWorld.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTimeMallInitDataRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:InterfaceTimeMarket = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            this.EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = CONST_BLACKMARKET.TIMEMALLTYPES.indexOf(_loc3_);
         _loc5_ = this.FTimeMalls[_loc4_];
         _loc5_.MallInforInitRet(_loc3_,param1);
      }
      
      protected function PacketPerform_ProcessorTimeMallRefreshRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:InterfaceTimeMarket = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            this.EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = CONST_BLACKMARKET.TIMEMALLTYPES.indexOf(_loc3_);
         _loc5_ = this.FTimeMalls[_loc4_];
         _loc5_.MallRefreshRet(_loc3_,param1);
      }
      
      protected function PacketPerform_ProcessorTimeMallBuyGoodRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:InterfaceTimeMarket = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            this.EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = CONST_BLACKMARKET.TIMEMALLTYPES.indexOf(_loc3_);
         _loc5_ = this.FTimeMalls[_loc4_];
         _loc5_.MallBuyGoodRet(_loc3_,param1);
      }
      
      public function PacketPerform_ProcessorRelatedPartner(param1:TPacket) : void
      {
         this.FProcessorRelatedPartner.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorNightmaeTrial(param1:TPacket) : void
      {
         this.FProcessorNightmareTrial.PacketProcess(param1);
      }
      
      public function PacketPerform_ProcessorNightmaePointMap(param1:TPacket) : void
      {
         this.FProcessorNightmareMap.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorMentorship(param1:TPacket) : void
      {
         this.FProcessorMentorship.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorDailyActivity(param1:TPacket) : void
      {
         this.FProcessorDailyActivity.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHDActivityRecharge(param1:TPacket) : void
      {
         this.FProcessorHDActivityRecharge.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHDActivityFund(param1:TPacket) : void
      {
         this.FProcessorHDActivityFund.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorQianKunARoll(param1:TPacket) : void
      {
         this.FProcessorQianKunARoll.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorActivityList(param1:TPacket) : void
      {
         this.FProcessorActivityManager.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorActivityListOS(param1:TPacket) : void
      {
         this.FProcessorHDOS.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorActivityListGB(param1:TPacket) : void
      {
         this.FProcessorHDGiftBag.PacketProcess(param1);
      }
      
      protected function ProcessorInspectorUpdataSeverTime(param1:Object) : void
      {
         this.FProcessorInspector.UpdataServerTime();
      }
      
      protected function ProcessorOnCheckAntiAddiction(param1:Object) : void
      {
         this.FProcessorInspector.UpdateCharacterCheckAntiAddiction();
         this.FProcessorShortcuts.InitSystemSetup();
      }
      
      protected function ProcessorInitAllNpc(param1:Object) : void
      {
         this.FProcessorMainSceneTwo.MainSceneInit();
      }
      
      protected function ProcessorOnInitMall(param1:Object) : void
      {
         this.FProcessorMall.InitMallData();
      }
      
      protected function ProcessorOnInitVip(param1:Object) : void
      {
         this.FProcessorVIP.InitVipInfo();
      }
      
      protected function ProcessorOnInitAddHeroNum(param1:Object) : void
      {
         this.FProcessorHeros.Perform_CS_ReceiveStateReq();
      }
      
      protected function ProcessorOnEnterFamily(param1:Object) : void
      {
         this.FProcessorFreshGuide.UpdateFamily();
         this.ProcessorOnUserUpdateCharacterCountry(param1);
         this.ProcessorWindowsSwitch(this.FProcessorFamilyMovie);
      }
      
      private function ProcessorOnHeroQualityChange(param1:Object) : void
      {
         this.FProcessorMainSceneTwo.UpdateQuality();
         this.FProcessorShortcuts.UserUpdateCharBaseInfo();
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_FIGHTPET)
         {
            this.FProcessorFightPet.ChangeMainHeroQuality();
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TRAITORATTACK)
         {
            this.FProcessorTraitorAttack.ChangeMainHeroQuality();
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_CITYDEFEND)
         {
            this.FProcessorCityDefend.ChangeMainHeroQuality();
         }
      }
      
      private function ProcessorOnMilitaryInfoReq(param1:Object) : void
      {
         this.FProcessorProtagonist.RequestMilitaryBaseInfor();
      }
      
      private function ProcessorOnLoadAchievementInfor(param1:Object) : void
      {
         this.FProcessorAchievement.LoadAchivementInfor();
      }
      
      private function ProcessorOnLoadBleachTrainInfor(param1:Object) : void
      {
         this.FProcessorBleachTrain.LoadBleahTrainInfor();
      }
      
      private function ProcessorOnLoadDailyWelfareInfor(param1:Object) : void
      {
         this.FProcessorDailyWelfare.InitDatas();
      }
      
      private function ProcessorOnInitHeroChangeInfor(param1:Object) : void
      {
         this.FProcessorHeroChange.ConstructHeroChange();
      }
      
      protected function VerificationPacketRet(param1:ByteArray) : Boolean
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         if(_loc2_ != 0)
         {
            this.EffectGenerateTextByErrorCode(_loc2_);
            return false;
         }
         return true;
      }
      
      protected function EffectGenerateTextByErrorCode(param1:uint) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TErrorCode = null;
         var _loc4_:String = null;
         _loc4_ = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ErrorCode);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.GetDatebaseByIdentifier(param1) as TErrorCode;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.Desc;
            }
         }
         if(_loc4_ == null)
         {
            _loc4_ = "Error Code: " + param1.toString();
            this.ProcessorOnDialogMsg(this,_loc4_);
         }
         if(_loc3_ != null)
         {
            switch(_loc3_.Type)
            {
               case TYPE_EFFECTTEXT:
                  this.ProcessorsOnEffectText(this,_loc4_);
                  break;
               case TYPE_DIALOGMSG:
                  this.ProcessorOnDialogMsg(this,_loc4_);
            }
         }
      }
      
      protected function ProcessorsOnEffectText(param1:Object, param2:String, param3:TEffectTextParameters = null, param4:TEffectCoordinateParameters = null) : void
      {
         this.FProcessorEffect.ImportText(param2,param3,param4);
      }
      
      protected function ProcessorsOnEffectHtmlText(param1:Object, param2:String, param3:TEffectCoordinateParameters = null) : void
      {
         this.FProcessorEffect.ImportHtmlText(param2,param3);
      }
      
      protected function ProcessorOnDialogMsg(param1:Object, param2:String) : void
      {
         this.FProcessorDialogMsg.ImportText(param2);
      }
      
      protected function ProcessorOnEffectSilverCoin(param1:Object, param2:uint, param3:TEffectCoordinateParameters) : void
      {
         this.FProcessorEffect.ImportSilverCoin(param2,param3);
      }
      
      protected function ProcessorOnEffectSoul(param1:Object, param2:uint, param3:uint, param4:TEffectCoordinateParameters) : void
      {
         this.FProcessorEffect.ImportSoul(param2,param3,param4);
      }
      
      protected function ProcessorOnEffectSugar(param1:Object, param2:uint, param3:uint, param4:TEffectCoordinateParameters) : void
      {
         this.FProcessorEffect.ImportSugar(param2,param3,param4);
      }
      
      protected function ProcessorOnEffectAcquireInventory(param1:Object, param2:Object, param3:TEffectCoordinateParameters) : void
      {
         this.FProcessorEffect.ImportAcquireInventory(param2,param3);
      }
      
      protected function ProcessorAccountOnUserLevelUpEffect(param1:Object) : void
      {
         this.FProcessorEffect.ImportUserLevelUp();
      }
      
      protected function ProcessorAccountOnAutoSearchWayEffect(param1:Object, param2:Boolean) : void
      {
         this.FProcessorEffect.ImportUserAutomaticallyFind(param2);
      }
      
      protected function ProcessorAccountOnAcceptTaskEffect(param1:Object) : void
      {
         this.FProcessorEffect.ImportUserAcceptTask();
      }
      
      protected function ProcessorAccountOnCompleteEffect(param1:Object) : void
      {
         this.FProcessorEffect.ImportUserCompleteTask();
      }
      
      protected function ProcessorAccountOnUserLevelUp(param1:Object) : void
      {
         this.FProcessorQuest.RoleLevelUp();
         this.FProcessorPopTips.CheckAddFriends();
         this.FProcessorBleachTrain.RoleLevelUpNotify();
         this.FProcessorReveredBook.RoleLevelUpNotify();
         this.FProcessorDailyWelfare.RoleLevelUpNotify();
      }
      
      protected function PacketPerform_SC_SceneRoleContorl(param1:TPacket) : void
      {
         switch(SLogicsCore.Character.RoleSencePosition)
         {
            case CONST_COMMON.SCENEPOSITION_MAINCITY:
               this.FProcessorMainSceneTwo.PacketProcess(param1);
               break;
            case CONST_COMMON.SCENEPOSITION_FIGHTPET:
               this.FProcessorFightPet.PacketProcess(param1);
               break;
            case CONST_COMMON.SCENEPOSITION_TRAITORATTACK:
               this.FProcessorTraitorAttack.PacketProcess(param1);
         }
      }
      
      protected function PacketPerform_ProcessorBattle(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_ProcessorTacticalDeployment(param1:TPacket) : void
      {
         this.FProcessorTacticalDeployment.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorJade(param1:TPacket) : void
      {
         this.FProcessorJade.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorChat(param1:TPacket) : void
      {
         this.FProcessorChat.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorBackpack(param1:TPacket) : void
      {
         this.FProcessorBackpack.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHeros(param1:TPacket) : void
      {
         this.FProcessorHeros.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTavern(param1:TPacket) : void
      {
         this.FProcessorTavern.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorQuest(param1:TPacket) : void
      {
         this.FProcessorQuest.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTalisman(param1:TPacket) : void
      {
         this.FProcessorTalisman.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorMail(param1:TPacket) : void
      {
         this.FProcessorMail.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorEquipMake(param1:TPacket) : void
      {
         this.FProcessorMakeEquip.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorKnifeSoul(param1:TPacket) : void
      {
         this.FProcessorKnifeSoul.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorKnifeOfKillSoul(param1:TPacket) : void
      {
         this.FProcessorKnifeOfKillSoul.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorFriend(param1:TPacket) : void
      {
         this.FProcessorFriend.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorInspector(param1:TPacket) : void
      {
         this.FProcessorInspector.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorVIP(param1:TPacket) : void
      {
         this.FProcessorVIP.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorOrganization(param1:TPacket) : void
      {
         this.FProcessorOrganization.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorPurchase(param1:TPacket) : void
      {
         this.FProcessorPurchase.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorMall(param1:TPacket) : void
      {
         this.FProcessorMall.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorSuperMarket(param1:TPacket) : void
      {
         this.FProcessorSuperMarket.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHonorShopInitRet(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHonorShopNotifyRet(param1:TPacket) : void
      {
         this.FProcessorTeamBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorSign(param1:TPacket) : void
      {
         this.FProcessorDailySign.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorDailyTask(param1:TPacket) : void
      {
         this.FProcessorDailyQuest.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorHellButterfly(param1:TPacket) : void
      {
         this.FProcessorHellButterfly.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorLimit(param1:TPacket) : void
      {
         this.FProcessorCounter.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorNijiastar(param1:TPacket) : void
      {
         this.FProcessorNijiaStar.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorSevenKing(param1:TPacket) : void
      {
         this.FProcessorSevenKing.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorProfessionRefine(param1:TPacket) : void
      {
         this.FUIProcessorProfessionRefine.PacketProcess(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_MountPoints();
         this.IllusionUpdate();
      }
      
      protected function LogicsPerform_MountPoints() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = !this.BattleQueryActive();
         this.FMountPointPlate.Visible = _loc1_;
         this.FMountPointShortcuts.Visible = _loc1_;
         this.FMountPointBarrier.Visible = _loc1_;
         this.FMountPointWindows.Visible = _loc1_;
         this.FMountPointOverview.Visible = _loc1_;
         this.FMountPointWindow.Visible = _loc1_;
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitBattleActive,this.AffairPerform_TimingWaitBattleActive);
         FAffairRoutines.Register(AFFAIRID_TimingWaitBattleLoading,this.AffairPerform_TimingWaitBattleLoading);
         FAffairRoutines.Register(AFFAIRID_ChatOptionsSetup,this.AffairPerform_ChatOptionsSetup);
         FAffairRoutines.Register(AFFAIRID_ChatOptionsApply,this.AffairPerform_ChatOptionsApply);
         FAffairRoutines.Register(AFFAIRID_GameStateExternalize,this.AffairPerform_GameStateExternalize);
         FAffairRoutines.Register(AFFAIRID_CloseSocketLoading,this.AffairPerform_CloseSocketLoading);
      }
      
      protected function AffairPerform_TimingWaitBattleActive(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.BattleQueryActive();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerform_TimingWaitBattleLoading(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.BattleQueryLoading();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerform_ChatOptionsSetup(param1:TAffair) : void
      {
         if(this.FProcessorPlateActive != null)
         {
            this.FProcessorPlateActive.ChatOptionsSetup(this.FChatOptions);
         }
      }
      
      protected function AffairPerform_ChatOptionsApply(param1:TAffair) : void
      {
         this.FProcessorChat.SetChatOptions(this.FChatOptions);
      }
      
      protected function AffairPerform_GameStateExternalize(param1:TAffair) : void
      {
         switch(this.FProcessorPlateActive)
         {
            case this.FProcessorMainSceneTwo:
               this.FProcessorPopTips.CheckLevelGiftBag();
               this.FProcessorInspector.UpdateAchievementEffect();
               break;
            case this.FProcessorMonsterMap:
               this.FProcessorPopTips.CheckLevelGiftBag();
               break;
            default:
               this.FProcessorPopTips.Hide();
         }
      }
      
      protected function AffairPerform_CloseSocketLoading(param1:TAffair) : void
      {
         if(this.FOnCloseSocketLoading != null)
         {
            this.FOnCloseSocketLoading(this);
         }
      }
      
      protected function ProcessorShowChat() : void
      {
         this.FChatOptions.ChatStatus = CONST_CHAT.MODE_None;
         FAffairGenerator.Generate(AFFAIRID_ChatOptionsApply);
      }
      
      protected function ProcessorHideChat() : void
      {
         this.FChatOptions.ChatStatus = CONST_CHAT.MODE_Hidden;
         FAffairGenerator.Generate(AFFAIRID_ChatOptionsApply);
      }
      
      protected function ActuatorBarrierOnUpdate(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FParameters.ActuatorBarrier.Count;
         if(_loc2_ > 0)
         {
            this.FBarrier.Visible = true;
         }
         else
         {
            this.FBarrier.Visible = false;
         }
      }
      
      protected function ActuatorBarrierOnUpdateAddition(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FParameters.ActuatorBarrier.CountAddition;
         if(_loc2_ > 0)
         {
            this.FBarrierAddition.Visible = true;
         }
         else
         {
            this.FBarrierAddition.Visible = false;
         }
      }
      
      protected function ProcessorsOnQueryBattleActive(param1:Object, param2:TQueryBoolean) : void
      {
         param2.Value = this.BattleQueryActive();
      }
      
      protected function ProcessorsOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters, param4:TInventorySample = null) : void
      {
         this.FProcessorPurchase.Purchase(param2,param3,param4);
      }
      
      protected function ProcessorSingleInitRetCall(param1:Object) : void
      {
         this.FProcessorHeros.UpdateOrganizationData(param1);
      }
      
      protected function ProcessorGroupInitRetCall(param1:Object) : void
      {
         this.FProcessorHeros.UpdateOrganizationData(param1,false);
      }
      
      protected function ProcessorOnMonsterMainUISet(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.FProcessorShortcuts.SetupShortcutsShow(CONST_SHORTCUTS_SHOW.MonsterMapShortcutsPosition,CONST_SHORTCUTS_SHOW.MonsterMapShortcutsLocation);
            this.ProcessorShowChat();
         }
         else
         {
            this.FProcessorShortcuts.SetupShortcutsShow(null,null);
            this.ProcessorHideChat();
         }
      }
      
      protected function ProcessorOnTeamBattleMainUISet(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         if(param3)
         {
            this.ProcessorShowChat();
         }
         else
         {
            this.ProcessorHideChat();
         }
         if(param2)
         {
            this.FProcessorShortcuts.SetupShortcutsShow(CONST_SHORTCUTS_SHOW.TeamBattleShortcutsPosition,CONST_SHORTCUTS_SHOW.TeamBattleShortcutsLocation);
         }
         else
         {
            this.FProcessorShortcuts.SetupShortcutsShow(null,null);
         }
      }
      
      protected function ProcessorsOnUpdatePopTipsModes(param1:Object) : void
      {
         this.FProcessorPopTips.Hide();
      }
      
      protected function ProcessorOnCheckPopTipsModes(param1:Object, param2:int) : void
      {
         this.FProcessorPopTips.CheckPopTipsByPanelId(param2);
      }
      
      protected function ProcessorOnAddPopTips(param1:Object, param2:uint) : void
      {
         if(!this.FProcessorHeros.Visible)
         {
            this.FProcessorPopTips.AddPopTips(param2);
         }
      }
      
      protected function ProcessorOnLoadLog(param1:uint, param2:Function) : void
      {
         this.FProcessorLog.LoadLog(param1,param2);
      }
      
      protected function ProcessorOnLoadPersonalLog(param1:uint, param2:Function) : void
      {
         this.FProcessorLog.LoadPersonLog(param1,param2);
      }
      
      protected function ProcessorsWindowsOnClose(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Class = null;
         _loc2_ = getQualifiedClassName(param1);
         _loc3_ = getDefinitionByName(_loc2_) as Class;
         if(!TUtilityLobby.ReturnWindows(_loc3_))
         {
            this.ProcessorWindowsSwitch(null);
         }
      }
      
      protected function ProcessorsOnGetAutoSetDeployment(param1:Object, param2:uint, param3:uint, param4:Function) : void
      {
         this.FProcessorTacticalDeployment.AutoSetDeployment(param2,param3,param4);
      }
      
      protected function ProcessorsTurnBackTownSceneNtf(param1:Object) : void
      {
         switch(SLogicsCore.Character.RoleSencePosition)
         {
            case CONST_COMMON.SCENEPOSITION_FIGHTPET:
               this.FProcessorFightPet.TurnBackTownSceneNtf();
               break;
            case CONST_COMMON.SCENEPOSITION_CITYDEFEND:
               this.FProcessorCityDefend.TurnBackTownSceneNtf();
               break;
            case CONST_COMMON.SCENEPOSITION_ORGANIZATIONWAR:
               this.FOrganizationalWar.TurnBackTownSceneNtf();
               break;
            case CONST_COMMON.SCENEPOSITION_TRAITORATTACK:
               this.FProcessorTraitorAttack.TurnBackTownSceneNtf();
               break;
            case CONST_COMMON.SCENEPOSITION_MONSTERMAP:
            case CONST_COMMON.SCENEPOSITION_WORLDMAP:
               this.FProcessorMonsterMap.TurnBackTownSceneNtf();
               break;
            case CONST_COMMON.SCENEPOSITION_VoidSoulWorld:
               this.FProcessorVoidSoulWorld.TurnBackTownSceneNtf();
         }
      }
      
      protected function ProcessorShortcutsOnMail(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorMail,param2);
      }
      
      protected function ProcessorShortcutsOnCrashJade(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorCrashJade,null);
      }
      
      protected function ProcessorShortcutsOnRelatedPartner(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorRelatedAssistance.Mount();
         this.ProcessorWindowsSwitch(this.FProcessorRelatedPartner,null);
      }
      
      protected function ProcessorShortcutsOnNightmareTrial(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorNightmareTrial,null);
      }
      
      protected function ProcessorShortcutsOnCustomHero(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorCustomHero,null);
      }
      
      protected function ProcessorShortcutsOnCollectSoul(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorCollectSoul,null);
      }
      
      protected function ProcessorShortcutsOnKingChallenge(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorKingChallenge,null);
      }
      
      protected function ProcessorShortcutsOnEquipForge(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorEquipForge,null);
      }
      
      protected function ProcessorsOnOpenGirlFriendWindow(param1:Object, param2:int) : void
      {
         this.FProcessorHome.OpenGirlWindowByTabIndex(param2);
      }
      
      protected function ProcessorsOnEnterTown(param1:Object, param2:uint = 0) : void
      {
         this.FProcessorAccount.UserEnterTownRequest(param2);
      }
      
      protected function ProcessorsOnReturnTown(param1:Object) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorMainSceneTwo);
      }
      
      protected function VoidSoulWorldReturn(param1:Object) : void
      {
         this.ProcessorsOnReturnTown(param1);
         this.ProcessorOnSetDailyActivityStatus(param1,CONST_ORGANIZATION.TYPE_ORGACTIVITY_VoidSoulWorld,SLogicsCore.Organization.GetOrgActivityStatusByType(CONST_ORGANIZATION.TYPE_ORGACTIVITY_VoidSoulWorld));
      }
      
      protected function ProcessorsOnSendMessageToWindow(param1:Object, param2:uint, param3:Object) : void
      {
         this.FProcessorGongFuFightApply.MessageNotify(param2,param3);
      }
      
      protected function ProcessorsOnOpenGongFuFightWindow(param1:Object, param2:uint) : void
      {
         var _loc3_:ByteArray = null;
         _loc3_ = new ByteArray();
         _loc3_.writeUnsignedInt(param2);
         _loc3_.position = 0;
         this.ProcessorWindowsSwitch(this.FProcessorGongFuFightApply,_loc3_);
      }
      
      protected function ProcessorOnEnterHomeReq(param1:Object, param2:ByteArray) : void
      {
         this.FProcessorHome.EnterHomeReq(param2);
      }
      
      protected function ProcessorShortcutsOnHome(param1:Object, param2:ByteArray) : void
      {
         this.ProcessorOnEnterHomeReq(param1,param2);
      }
      
      protected function ProcessorsOnStartFreshGuide(param1:Object) : void
      {
         this.FProcessorFreshGuide.StartFreshGuide();
      }
      
      protected function ProcessorsOnOpenSecretMallNotify(param1:Object) : void
      {
         this.FProcessorInspector.SecretMallOpenNotify();
      }
      
      protected function ProcessorShortcutsOnKillHeros(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorKillHeros);
      }
      
      protected function ProcessorShortcutsOnArena(param1:Object) : void
      {
         this.FProcessorArena.EnterArenaReq();
      }
      
      protected function ProcessorShortcutsOnTeamBattle(param1:Object, param2:ByteArray) : void
      {
         this.FProcessorTeamBattle.EnterTeamBattleReq(param2);
      }
      
      protected function ProcessorShortcutsOnCDK(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDCDK);
      }
      
      protected function ProcessorShortcutsOnHeroChange(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHeroChange);
      }
      
      protected function ProcessorShortcutsOnBleachAgent() : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBleachAgent);
      }
      
      protected function ProcessorShortcutsOnBlackMarket(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBlackMarket);
      }
      
      protected function ProcessorShortcutsOnExpDuplicate(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorExpDuplicate);
      }
      
      protected function ProcessorShortcutsOnExportPlayer(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorExportPlayer);
      }
      
      protected function ProcessorShortcutsOnFund(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDActivityFund);
      }
      
      protected function ProcessorShortcutsOnSuperTreature(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDActivitySuperTreature);
      }
      
      protected function ProcessorShortcutsOnActiveListRechargeCommon(param1:Object, param2:ByteArray) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDRechargeSuit);
      }
      
      protected function ProcessorShortcutsOnActiveListEspada(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDEspada);
      }
      
      protected function ProcessorShortcutsOnActiveListMaskFright(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDMaskFright);
      }
      
      protected function ProcessorShortcutsOnActiveListEquipmentShop(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDEquipmentShop);
      }
      
      protected function ProcessorShortcutsOnGirlGame(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorGirlGame);
      }
      
      protected function ProcessorShortcutsOnWelcome(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorWelcome);
      }
      
      protected function ProcessorShortcutsOnActiveListSoulBox(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDSoulBox);
      }
      
      protected function ProcessorShortcutsOnActiveListGambling(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDGambling);
      }
      
      protected function ProcessorShortcutsOnActiveListLimitBuy(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDLimitBuy);
      }
      
      protected function ProcessorShortcutsOnActiveListIceHeros(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDIceHeros);
      }
      
      protected function ProcessorShortcutsOnActiveListIceDragon(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDIceDragon);
      }
      
      protected function ProcessorShortcutsOnActiveListSuperEggs(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDSuperEggs);
      }
      
      protected function ProcessorShortcutsOnActiveListTeamBuy(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDTeamBuy);
      }
      
      protected function ProcessorShortcutsOnActiveListJigsaw(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDJigsaw);
      }
      
      protected function ProcessorShortcutsOnActiveListVipFund(param1:Object) : void
      {
      }
      
      protected function ProcessorShortcutsOnActiveBigTurnTable(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDBigTurnTable);
      }
      
      protected function ProcessorShortcutsOnActiveTreasureAwake(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDTreasureAwake,null);
      }
      
      protected function ProcessorShortcutsOnActiveServerPay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDServerPay);
      }
      
      protected function ProcessorShortcutsOnActiveRandCard(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDRandCard);
      }
      
      protected function ProcessorShortcutsOnActiveBleachJigsaw(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBleachJigsawOld);
      }
      
      protected function ProcessorShortcutsOnActiveChess(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorChess);
      }
      
      protected function ProcessorShortcutsOnActiveWorldCup(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorWorldCup);
      }
      
      protected function ProcessorShortcutsOnActiveHerosMarket(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHerosMarket);
      }
      
      protected function ProcessorShortcutsOnActiveLottery(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorLottery);
      }
      
      protected function ProcessorShortcutsOnActivePartner(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorPartner);
      }
      
      protected function ProcessorShortcutsOnActiveLuckyJoy(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorLuckyJoy);
      }
      
      protected function ProcessorShortcutsOnActiveSwiftChange(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorSwiftChange);
      }
      
      protected function ProcessorShortcutsOnActivePrivilegeLease(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorPrivilegeLease);
      }
      
      protected function ProcessorShortcutsOnFBBuyGold(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorFBBuyGold);
      }
      
      protected function ProcessorShortcutsOnNewYearDay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewYearDay);
      }
      
      protected function ProcessorShortcutsOnUniteTask(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDUniteTask);
      }
      
      protected function ProcessorShortcutsOnActiveHalloween(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDHalloween);
      }
      
      protected function ProcessorShortcutsOnActiveCircleTrial(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDCircleTrial);
      }
      
      protected function ProcessorShortcutsOnActiveKingLegend(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDKingLegend);
      }
      
      protected function ProcessorShortcutsOnActiveChristmas(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDChristmas);
      }
      
      protected function ProcessorShortcutsOnActiveDreams(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDDreams);
      }
      
      protected function ProcessorShortcutsOnActiveNewYearSheep(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewYearSheep);
      }
      
      protected function ProcessorShortcutsOnActiveFeedback(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDFeedback);
      }
      
      protected function ProcessorShortcutsOnActiveDayBack(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDDayBack);
      }
      
      protected function ProcessorShortcutsOnActiveGoldTurntable(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDGoldTurntable);
      }
      
      protected function ProcessorShortcutsOnActiveGrowthPlan(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDGrowthPlan);
      }
      
      protected function ProcessorShortcutsOnActiveEaster(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDEaster);
      }
      
      protected function ProcessorShortcutsOnActiveBleachBag(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDBleachBag);
      }
      
      protected function ProcessorShortcutsOnActiveGallery(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDGallery);
      }
      
      protected function ProcessorShortcutsOnActiveDailyHero(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDDailyHero);
      }
      
      protected function ProcessorShortcutsOnActiveRushInSeireitei(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDRushInSeireitei);
      }
      
      protected function ProcessorShortcutsOnActivePyramid(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDPyramid);
      }
      
      protected function ProcessorShortcutsOnActiveAstrology(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDAstrology);
      }
      
      protected function ProcessorShortcutsOnActiveKnifeHeroCollect(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDKnifeHeroCollect);
      }
      
      protected function ProcessorShortcutsOnActiveCoolSummer(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDCoolSummer);
      }
      
      protected function ProcessorShortcutsOnActiveEveryDayAward(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDEveryDayAward);
      }
      
      protected function ProcessorShortcutsOnActiveFirstPayBag(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDFirstPayBag);
      }
      
      protected function ProcessorShortcutsOnActiveBrushHappy(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDBrushHappy);
      }
      
      protected function ProcessorShortcutsOnActiveNewServerDraw(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewServerDraw);
      }
      
      protected function ProcessorShortcutsOnActiveNewHalloween(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewHallowen);
      }
      
      protected function ProcessorShortcutsOnActiveThanksgivingDay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDThanksgivingDay);
      }
      
      protected function ProcessorShortcutsOnActiveChristmas2015(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDChristmas2015);
      }
      
      protected function ProcessorShortcutsOnActiveNewYear2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewYear2016);
      }
      
      protected function ProcessorShortcutsOnActiveNewYear2016Two(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewYear2016Two);
      }
      
      protected function ProcessorShortcutsOnActiveEaster2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDEaster2016);
      }
      
      protected function ProcessorShortcutsOnActiveGhostKingForg(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDGhostKingForg);
      }
      
      protected function ProcessorShortcutsOnActiveLaborDay2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDLaborDay2016);
      }
      
      protected function ProcessorShortcutsOnActiveDuanwujie2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDDuanwujie2016);
      }
      
      protected function ProcessorShortcutsOnActiveTreasureHunt(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDTreasureHunt);
      }
      
      protected function ProcessorShortcutsOnActiveSoulCarnival(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDSoulCarnival);
      }
      
      protected function ProcessorShortcutsOnActiveKnifeChess(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDKnifeChess);
      }
      
      protected function ProcessorShortcutsOnActiveNationalDay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNationalDay);
      }
      
      protected function ProcessorShortcutsOnActiveHalloween2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDHalloween2016);
      }
      
      protected function ProcessorShortcutsOnActiveThanksGivingDay2016(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDThanksGivingDay2016);
      }
      
      protected function ProcessorShortcutsOnActiveNewYear2017(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNewYear2017);
      }
      
      protected function ProcessorShortcutsOnActiveFoolsDay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDFoolsDay);
      }
      
      protected function ProcessorShortcutsOnActiveChildrenDay(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDChildrenDay);
      }
      
      protected function ProcessorShortcutsOnActiveAnniversary(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDAnniversary);
      }
      
      protected function ProcessorShortcutsOnActiveNationalDay2017(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDNationalDay2017);
      }
      
      protected function ProcessorShortcutsOnTokenShop(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorTokenShop);
      }
      
      protected function ProcessorShortcutsOnStoneShop(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorStoneShop);
      }
      
      protected function ProcessorShortcutsOnSign(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorDailySign);
      }
      
      protected function ProcessorShortcutsOnPet(param1:Object) : void
      {
         this.FProcessorPet.EnterPetReq();
      }
      
      protected function ProcessorShortcutsOnRebirth(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorRebirth);
      }
      
      protected function ProcessorShortcutsOnSmelt(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorSmelt);
      }
      
      protected function ProcessorShortcutsOnTreasureMap(param1:Object) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorTreasureMap);
      }
      
      protected function ProcessorShortcutsOnSevenKing(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorSevenKing,param2);
      }
      
      protected function ProcessorShortcutsOnMall(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorMall);
      }
      
      protected function ProcessorShortcutsOnDailyQuest(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorDailyQuest);
      }
      
      protected function ProcessorShortcutsOnDailyActivity(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorDailyActivity);
      }
      
      protected function ProcessorShortcutsOnSevenKings(param1:Object) : void
      {
         this.FProcessorSevenKing.EnterReq();
      }
      
      protected function ProcessorShortcutsOnYellowDiamond(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorYellowDiamon);
         if(!SParametersCore.IfTXGame)
         {
            SExternalCore.onMemberIcon();
         }
      }
      
      protected function ProcessorShortcutsOnBleachTrain(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBleachTrain);
      }
      
      protected function ProcessorShortcutsOnBleachDailyRecord(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBleachDailyRecord);
      }
      
      protected function ProcessorShortcutsOnHeroCompanion(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHeroCompanion);
      }
      
      protected function ProcessorShortcutsOnProfessionRefine(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FUIProcessorProfessionRefine,param2);
      }
      
      protected function ProcessorShortcutsOnActiveSpecialSkyTower(param1:Object) : void
      {
         this.FProcessorSkyTower.EnterSkyTowerReq();
      }
      
      protected function ProcessorShortcutsOnActiveSpecialGongFuFight(param1:Object) : void
      {
         this.FProcessorGongFuFight.EnterGongFuFight();
      }
      
      protected function ProcessorShortcutsOnEnterLargeWorldMap(param1:Object, param2:Boolean = false, param3:uint = 1, param4:int = 0) : void
      {
         var _loc5_:int = 0;
         if(param2 && param4 > 0)
         {
            if(this.FProcessorMonsterMap.Visible == true)
            {
               if(this.FProcessorMonsterMap.CheckBattleType(param4))
               {
                  this.FProcessorMonsterMap.FlashCurrentQuestMonster(param4);
                  return;
               }
               this.ProcessorsOnEnterTown(param1);
            }
         }
         this.ProcessorWindowsSwitch(this.FProcessorLargeWorldMap);
         this.FProcessorLargeWorldMap.Open(param2,param3,param4);
      }
      
      protected function ProcessorShortcutsOnEnterMonsterMap(param1:Object) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorMonsterMap);
      }
      
      protected function ProcessorShortcutsOnActiveListWonderful(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDOS);
      }
      
      protected function ProcessorShortcutsOnActiveListRecharge(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDActivityRecharge);
      }
      
      protected function ProcessorShortcutsOnActiveListFirstRecharge(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHDFirstPay);
      }
      
      protected function ProcessorShortcutsOnActiveListGiftBag(param1:Object, param2:uint) : void
      {
         var _loc3_:ByteArray = null;
         _loc3_ = new ByteArray();
         _loc3_.writeUnsignedInt(param2);
         this.ProcessorWindowsSwitch(this.FProcessorHDGiftBag,_loc3_);
      }
      
      protected function ProcessorShortcutsOnActiveListOrderGift(param1:Object) : void
      {
         this.FProcessorHDGiftBag.ReciveOrderGiftBag();
      }
      
      protected function ProcessorWindowsOnMilitary(param1:Object) : void
      {
         this.FProcessorMainSceneTwo.UpdateMilitaryRank();
      }
      
      protected function OnCloseList() : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorProtagonist);
      }
      
      protected function ProcessorsOnChangePet() : void
      {
         this.FProcessorMainSceneTwo.UpdatePet();
      }
      
      protected function ProcessorsOnChangeKnifeShape(param1:Object) : void
      {
         this.FProcessorShortcuts.UserUpdatePet();
         this.FProcessorMainSceneTwo.UpdateKnifeOfKillSoul();
         this.ProcessorOnHerosUpdateBaseAttributeReq(this);
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_FIGHTPET)
         {
            this.FProcessorFightPet.UpdatePet();
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TRAITORATTACK)
         {
            this.FProcessorTraitorAttack.UpdatePet();
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_CITYDEFEND)
         {
            this.FProcessorCityDefend.UpdatePet();
         }
      }
      
      protected function ProcessorOnGotoCityDoor(param1:Object, param2:Object) : void
      {
         SLogicsCore.QuestAutoSearchWay.AutoSearyWay(param2);
      }
      
      protected function ProcessorAccountOnUserUpdateBaseInfo(param1:Object) : void
      {
         this.FProcessorShortcuts.UserUpdateCharBaseInfo();
         this.FProcessorHeros.UserUpdateCharBaseInfo();
      }
      
      protected function ProcessorAccountOnUserUpdateVipInfo(param1:Object) : void
      {
         this.FProcessorVIP.UserUpdateCharVipInfo();
         this.FProcessorShortcuts.UserUpdateCharBaseInfo();
      }
      
      protected function ProcessorOnLoadMilitaryInfor(param1:Object) : void
      {
         this.FProcessorProtagonist.LoadMilitaryInfor();
      }
      
      protected function ProcessorOnInitQuests(param1:Object) : void
      {
         this.FProcessorQuest.InitQuests();
      }
      
      protected function ProcessorOnShowNpcDialog(param1:Object) : void
      {
         this.FProcessorNpcDialog.UINpc = param1 as TSceneSpriteMoudleInMapNpc;
         this.ProcessorWindowsSwitch(this.FProcessorNpcDialog);
      }
      
      protected function ProcessorOnSetDailyActivityStatus(param1:Object, param2:uint, param3:uint) : void
      {
         this.FProcessorDailyActivity.SetActivityStatus(param2,param3);
         if(param2 == CONST_ORGANIZATION.TYPE_ORGACTIVITY_VoidSoulWorld)
         {
            this.FProcessorVoidSoulWorld.SetActivityStatus(param3);
         }
      }
      
      protected function ProcessorOnSetOrgActivityEnd(param1:Object, param2:uint, param3:uint) : void
      {
         this.FProcessorOrganization.OnSetOrgActivity(param2,param3);
      }
      
      protected function ProcessorAccountOnUserUpdateStrengthenCD(param1:Object) : void
      {
         this.FProcessorSmithy.UpdateCDTime();
         this.FProcessorArena.UpdateCDTime();
      }
      
      protected function ProcessorShortcutsOnQuest(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorQuest);
      }
      
      protected function ProcessorShortcutsOnAvaterHead(param1:Object, param2:ByteArray = null) : void
      {
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_BATTLESENCE_AUTO)
         {
            return;
         }
         this.ProcessorWindowsSwitch(this.FProcessorProtagonist,param2);
      }
      
      protected function ProcessorShortcutsOnHeros(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHeros,param2);
      }
      
      protected function ProcessorShortcutsOnGeneralStar(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorGeneralStar,param2);
      }
      
      protected function ProcessorShortcutsOnTacticalDeployment(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorTacticalDeployment,param2);
      }
      
      protected function ProcessorShortcutsLandlordsOnClick(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(null);
      }
      
      protected function ProcessorShortcutsOnBackpack(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBackpack,param2);
      }
      
      protected function ProcessorShortcutsOnGongFuFight(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorGongFuFight.EnterGongFuFight();
      }
      
      protected function ProcessorShortcutsOnTreasure(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorTalisman,param2);
      }
      
      protected function ProcessorShortcutsOnKnifeSoul(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorKnifeSoul,param2);
      }
      
      protected function ProcessorShortcutsOnKnifeOfKillSoul(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorKnifeOfKillSoul,param2);
      }
      
      protected function ProcessorShortcutsOnVip(param1:Object = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorVIP);
      }
      
      protected function ProcessorOnPromote(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorShinobidoPractise);
      }
      
      protected function ProcessorShortcutsOnStrengthen(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorSmithy,param2);
      }
      
      protected function ProcessorShortcutsOnOrnamentStrengthen(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorOrnamentStrengthen,param2);
      }
      
      protected function ProcessorShortcutsOnSuperMarket(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorSuperMarket,param2);
      }
      
      protected function ProcessorShortcutsOnDailyWelfare(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorDailyWelfare,param2);
      }
      
      protected function ProcessorShortcutsOnLikeUs(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorLikeUs.ProcessorLikeUs();
      }
      
      protected function ProcessorShortcutsOnGoodAssess(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorBRLikeUs.GoodAssess();
      }
      
      protected function ProcessorShortcutsOnShareFriend(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorBRLikeUs.ShareFriend();
      }
      
      protected function ProcessorShortcutsOnPlatformSync(param1:Object, param2:ByteArray = null) : void
      {
         this.FProcessorBRLikeUs.PlatformSync();
      }
      
      protected function ProcessorShortcutsOnSpecialFighter(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorSpecialCombatPower,param2);
      }
      
      protected function ProcessorShortcutsOnVainTravel(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorVainTravel,param2);
      }
      
      protected function ProcessorShortcutsOnBleachJigsaw(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBleachJigsaw,param2);
      }
      
      protected function ProcessorShortcutsOnChess(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorChess,param2);
      }
      
      protected function ProcessorShortcutsOnWorldCup(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorWorldCup,param2);
      }
      
      protected function ProcessorShortcutsOnHerosMarket(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHerosMarket,param2);
      }
      
      protected function ProcessorShortcutsOnLottery(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorLottery,param2);
      }
      
      protected function ProcessorShortcutsOnOfficeLady(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorOffceLady,param2);
      }
      
      protected function ProcessorShortcutsOnAchievement(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorAchievement,param2);
      }
      
      protected function ProcessorShortcutsOnOrganiZation(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorOrganization,param2);
      }
      
      protected function ProcessorShortcutsOnSevenHeroMap(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorNijiaStar,param2);
      }
      
      protected function ProcessorShortcutsOnReveredBook(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorReveredBook);
      }
      
      protected function ProcessorShortcutsOnJade(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorJade,param2);
      }
      
      protected function ProcessorShortcutsOnFriend(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorFriend,param2);
      }
      
      protected function ProcessorShortcutsOnTavern(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorTavern,param2);
      }
      
      protected function ProcessorShortcutsOnMakeEquip(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorMakeEquip,param2);
      }
      
      protected function ProcessorShortcutsOnHellButterfly(param1:Object, param2:ByteArray = null) : void
      {
         if(!this.FProcessorHome.Visible)
         {
            this.FProcessorHome.EnterHomeReq(param2);
         }
         else
         {
            this.ProcessorWindowsSwitch(this.FProcessorHellButterfly);
         }
      }
      
      protected function ProcessorShowAchievementInfor(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorShortcutsOnAchievement(this);
         this.FProcessorAchievement.ShowAchievementInfor(param1 as TAchievementInfor);
      }
      
      protected function ProcessorOnNotificationLevelGiftBagState(param1:Object, param2:Boolean) : void
      {
         this.FProcessorPopTips.LevelGiftBagState = param2;
      }
      
      protected function ProcessorShortcutsOnSlave(param1:Object, param2:ByteArray = null) : void
      {
         if(!this.FProcessorHome.Visible)
         {
            this.FProcessorHome.EnterHomeReq(param2);
         }
         else
         {
            this.ProcessorWindowsSwitch(this.FProcessorMentorship);
         }
      }
      
      protected function ProcessorShortcutsOnGamble(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorQianKunARoll,param2);
      }
      
      protected function ProcessorShortcutsOnNpcUserType(param1:int) : void
      {
         if(param1 == CONST_NPC.NPC_FUNCTION_PUB)
         {
            this.ProcessorWindowsSwitch(null);
            this.ProcessorPlateSwitch(this.FProcessorTavern);
         }
         else if(param1 == CONST_NPC.NPC_FUNCTION_MADE)
         {
            this.ProcessorWindowsSwitch(this.FProcessorMakeEquip);
         }
         else if(param1 == CONST_NPC.NPC_FUNCTION_STONE)
         {
            this.ProcessorWindowsSwitch(this.FProcessorJade);
         }
         else if(param1 == CONST_NPC.NPC_FUNCTION_SUPERMARKET)
         {
            this.ProcessorWindowsSwitch(this.FProcessorSuperMarket);
         }
         else if(param1 == CONST_NPC.NPC_FUNCTION_KINGCHALLENG)
         {
            this.ProcessorWindowsSwitch(null);
            this.ProcessorPlateSwitch(this.FProcessorKingChallenge);
         }
      }
      
      protected function ProcessorShortcutEffectNotification(param1:uint, param2:uint, param3:Boolean) : void
      {
         this.FProcessorShortcuts.ShowEffectNotification(param1,param2,param3);
      }
      
      protected function ProcessorShortcutOnRelatedAssistance(param1:Object, param2:ByteArray = null) : void
      {
         this.ProcessorsAssistanceViewShow();
      }
      
      protected function ProcessorOnGotoHellButterfly(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorHellButterfly);
      }
      
      protected function ProcessorOnOrgGetNameFromID(param1:Object, param2:uint) : String
      {
         return this.FProcessorOrganization.GetOrgNameFromOrgID(param2);
      }
      
      protected function ProcessorOnOrgGetActivityLevelByType(param1:uint) : uint
      {
         return this.FProcessorOrganization.GetActivityLevelByType(param1);
      }
      
      protected function ProcessorShortcutHyperlinks(param1:Object, param2:uint, param3:uint, ... rest) : void
      {
         this.FProcessorShortcuts.PerformShortcutHyperlinks(param1,param2,param3,this.ProcessorShortcutCloseWindows,rest);
      }
      
      protected function ProcessorHyperlinks(param1:uint, param2:int, param3:int) : void
      {
         var _loc4_:ByteArray = null;
         if(param2 != -1 || param3 != -1)
         {
            _loc4_ = new ByteArray();
            if(param2 != -1)
            {
               _loc4_.writeInt(param2);
            }
            if(param3 != -1)
            {
               _loc4_.writeInt(param3);
            }
            _loc4_.position = 0;
         }
         switch(param1)
         {
            case TUtilityHyperLink.HyperLink_ChangeInfo:
               this.ProcessorWindowsSwitch(this.FProcessorChangeInfo,_loc4_);
         }
      }
      
      protected function ProcessorShortcutBuyMilitary(param1:Object) : void
      {
         this.FProcessorShortcuts.BuyMilitary();
      }
      
      public function ProcessorShortcutShutdownFunction(param1:Object, param2:int, param3:int) : void
      {
         this.FProcessorUnlock.ShutdownFunction(param2,param3);
      }
      
      public function ProcessorShortcutChangeShortcutIcon(param1:Object, param2:int, param3:int) : void
      {
         this.FProcessorShortcuts.ChangeShortcutIcon(param2,param3);
      }
      
      public function ProcessorShortcutFollowAchievement(param1:Object) : void
      {
         this.FProcessorShortcuts.FollowAchievement(param1 as TAchievementInfor);
      }
      
      public function ProcessorShortcutFollowBleachTrain(param1:Object) : void
      {
         this.FProcessorShortcuts.FollowBleachTrain(param1 as TBleachTrainData);
      }
      
      public function ProcessorShortcutBleachTrainInforNotify(param1:Object, param2:Object) : void
      {
         this.FProcessorShortcuts.BleachTrainInforNotify(param2);
      }
      
      protected function ProcessorShortcutCloseWindows(param1:Object) : void
      {
         if(param1 is TProcessorLobbyWindows || param1 is TProcessorLobbyWindow)
         {
            this.ProcessorWindowsSwitch(null);
         }
      }
      
      protected function ProcessorOnUpdateInventories(param1:Object) : void
      {
         this.FProcessorTalisman.UserUpdateInventories();
         this.FProcessorHeros.UpdateCharacterInventory();
      }
      
      protected function ProcessorOnCreateKnifeOfKillSoulData(param1:Object) : TKnifeOfKillSoulData
      {
         return this.FProcessorKnifeOfKillSoul.CreateKnifeOfSkillSoulData(param1 as uint);
      }
      
      protected function ProcessorsOnQuertInventoryIDReq(param1:Object, param2:Object) : void
      {
         this.FProcessorInspector.QuertInventoryID(param2);
      }
      
      protected function ProcessorsOnInventoryReveal(param1:Object, param2:Object) : void
      {
         this.FProcessorChat.ProcessorInventoryReveal(param2);
      }
      
      protected function ProcessorsOnRequestWhisper(param1:Object, param2:Object) : void
      {
         this.FProcessorChat.ChatWhisperByDigest(param2);
      }
      
      protected function ProcessorOnChangeSkillReq(param1:Object, param2:Object) : void
      {
         this.FProcessorGeneralStar.ProcessorChangeSkillReq(param1,param2);
      }
      
      protected function ProcessorOnChangePosition(param1:Object, param2:uint) : void
      {
         this.ProcessorOnHeroUpdateBaseAttribute(param1,param2);
         this.FProcessorMonsterMap.ProcessorChangePosition(param1);
         this.FProcessorKillHeros.ProcessorChangePosition(param1);
         this.FProcessorWindowOrgPointMap.ProcessorChangePosition(param1);
         this.FProcessorExpDuplicate.ProcessorChangePosition(param1);
         this.FProcessorVainTravel.ProcessorChangePosition(param1);
         this.FProcessorRelatedPartner.ProcessorChangePosition(param1);
         this.FProcessorNightmareMap.ProcessorChangePosition(param1);
      }
      
      protected function ProcessorOnUpdateChangeSkill(param1:Object) : void
      {
         this.FProcessorHeros.UpdateMainHeroSkill();
      }
      
      protected function ProcessorOnPromotFreshGuide(param1:Object, param2:Boolean) : void
      {
         this.FProcessorGeneralStar.SetupForcePromptFreshGuide(param2);
      }
      
      protected function ProcessorOnPromotTraven(param1:Object, param2:Boolean) : void
      {
         this.FProcessorTavern.SetForcePromot(param1,param2);
      }
      
      protected function ProcessorOnDeploymentPromotFreshGuide(param1:Object, param2:Boolean) : void
      {
         this.FProcessorTacticalDeployment.SetupForcePromptFreshGuide(param2);
      }
      
      protected function ProcessorOnKnifeOfKillSoulPromotFreshGuide(param1:Object, param2:Boolean) : void
      {
         this.FProcessorKnifeOfKillSoul.SetupForcePromptFreshGuide(param2);
      }
      
      protected function ProcessorGetKingSoulonClick(param1:Object) : void
      {
         this.FProcessorSevenKing.EnterReq();
      }
      
      protected function ProcessorOnToStarsMap(param1:Object) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorNijiaStar);
      }
      
      protected function ProcessorOnSetBackToDepolyment(param1:Object) : void
      {
         this.FProcessorKnifeOfKillSoul.IfGoBackToDeployment = true;
      }
      
      protected function ProcessorOnLoadFollowUp(param1:Object) : void
      {
         if(this.FOnLoadFollowUp != null)
         {
            this.FOnLoadFollowUp(this);
         }
         this.FProcessorModuleLoader.IsStart = true;
         this.FProcessorInspector.Load();
         this.FProcessorEffect.Load();
         this.FProcessorChat.CheckChannelsState();
      }
      
      protected function ProcessorOnEnterMonsterWorld(param1:Object, param2:TNodal, param3:int, param4:int, param5:int = 0, param6:Boolean = true) : void
      {
         this.FProcessorMonsterMap.SetData(param1,param2,param3,param4,param5);
         if(param6)
         {
            this.ProcessorWindowsSwitch(null);
            this.ProcessorPlateSwitch(this.FProcessorMonsterMap);
         }
      }
      
      protected function ProcessorOnBackLargeWorld(param1:Object, param2:uint) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorLargeWorldMap);
         this.FProcessorLargeWorldMap.Open(true,param2);
      }
      
      protected function ProcessorOnOrganizationalWarCommandRequest(param1:Object, param2:uint, param3:uint, param4:Function) : void
      {
         this.FOrganizationalWar.CommandRequest(param2,param3,param4);
      }
      
      protected function ProcessorTraitorAttackEnd(param1:Object) : void
      {
         this.FProcessorTraitorAttack.TraitorAttackEnd();
      }
      
      protected function ProcessorOnCharacterBaseAttributeRet(param1:Object) : void
      {
         this.FProcessorHeros.UpdateCharacterBaseAttributeRet();
         this.FProcessorTalisman.UpdateCharacterBaseAttributeRet();
         this.ProcessorOnHerosUpdateBaseAttributeRet(param1);
         this.FProcessorPet.UpdateCharacterBaseAttributeRet();
      }
      
      protected function ProcessorOnMountTalisman(param1:Object, param2:uint, param3:Object) : void
      {
         this.FProcessorHeros.ProcessorOnMountTalisman(param1,param2,param3);
      }
      
      protected function ProcessorOnDismountTalisman(param1:Object, param2:uint, param3:uint, param4:uint) : void
      {
         this.FProcessorHeros.ProcessorOnDismountTalisman(param1,param2,param3,param4);
      }
      
      protected function ProcessorOnUpdateTalismanMount(param1:Object) : void
      {
         this.FProcessorTalisman.UpdateEquip();
      }
      
      protected function ProcessorOnHerosUpdateBaseAttributeReq(param1:Object) : void
      {
         this.FProcessorHeros.UpdateHerosBaseAttributeReq();
      }
      
      protected function ProcessorOnChangeTitle(param1:Object) : void
      {
         this.FProcessorMainSceneTwo.UpdateTitle();
      }
      
      protected function ProcessorOnChangeBleachAgentIcon() : void
      {
         this.FProcessorMainSceneTwo.UpdateBleachAgentIcon();
      }
      
      protected function ProcessorOnHerosUpdateBaseAttributeRet(param1:Object) : void
      {
         this.FProcessorShortcuts.UserUpdateFightingPower();
         this.FProcessorTacticalDeployment.UserUpdateFightingPower();
      }
      
      protected function ProcessorOnUserUpdateCharacterCountry(param1:Object) : void
      {
         this.FProcessorShortcuts.UserUpdateCharacterCountry();
      }
      
      protected function ProcessorOnSetOrganizationalName(param1:Object, param2:String) : void
      {
         this.FProcessorProtagonist.SetPlayerOrganizationalName(param2);
      }
      
      protected function ProcessorOnDismissHero(param1:Object, param2:uint) : void
      {
      }
      
      protected function ProcessorOnUseAppliance(param1:Object, param2:uint) : void
      {
         this.FProcessorBackpack.SetExperience(param2);
      }
      
      protected function ProcessorOnCheckPopTips(param1:Object) : void
      {
         this.FProcessorGeneralStar.CheckPopTip();
         this.FProcessorProtagonist.UpdatePrestige();
      }
      
      protected function ProcessorOnShowHeroInforPanle(param1:Object, param2:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         this.FProcessorShortcuts.ShowHeroContorlPanle(param2);
      }
      
      protected function ProcessorOnHideHeroInforPanle(param1:Object) : void
      {
         this.FProcessorShortcuts.HideHeroContorlPanle();
      }
      
      protected function ProcessorOnHeroInitBaseAttribute(param1:Object, param2:uint) : void
      {
         this.FProcessorHeros.InitHeroBaseAttributeReq(param2);
      }
      
      protected function ProcessorOnHeroUpdateBaseAttribute(param1:Object, param2:uint, param3:Boolean = true) : void
      {
         this.FProcessorHeros.UpdateHeroBaseAttributeReq(param2,param3);
      }
      
      protected function ProcessorOnMainHeroRebirthNum(param1:int) : void
      {
         this.FProcessorMainSceneTwo.UpdateRebirthNum(param1);
      }
      
      protected function ProcessorOnKingChallengeNpc(param1:String, param2:uint) : void
      {
         this.FProcessorMainSceneTwo.UpdateKingChallengeNpc(param1,param2);
      }
      
      protected function ProcessorOnInquiryCharacterIDReq(param1:Object, param2:String) : void
      {
         this.FProcessorFriend.ProcessorInquiryCharacterIDByNickname(param2);
      }
      
      protected function ProcessorOnInterpersonalRelationshipsReq(param1:Object, param2:uint, param3:Object) : void
      {
         this.FProcessorFriend.ProcessorInterpersonalRelationshipsReq(param2,param3);
      }
      
      protected function ProcessorOnOrgGotoSinglePointMap() : void
      {
         this.ProcessorWindowsSwitch(null);
         this.FProcessorWindowOrgPointMap.BattleType = CONST_BATTLE.BattleType_OrgSingle;
         this.FProcessorWindowOrgPointMap.UIDispatch();
         this.ProcessorPlateSwitch(this.FProcessorWindowOrgPointMap);
      }
      
      protected function ProcessorOnOrgGotoGroupPointMap() : void
      {
         this.ProcessorWindowsSwitch(null);
         this.FProcessorWindowOrgPointMap.BattleType = CONST_BATTLE.BattleType_OrgGroup;
         this.FProcessorWindowOrgPointMap.UIDispatch();
         this.ProcessorPlateSwitch(this.FProcessorWindowOrgPointMap);
      }
      
      protected function ProcessorOnHackWarningResponse(param1:Object) : void
      {
         this.FProcessorCheatChecker.HackWarningResponse();
      }
      
      protected function ProcessorOnActivatingChannel(param1:Object, param2:uint, param3:Boolean) : void
      {
         this.FProcessorChat.ProcessorActivatingChannel(param2,param3);
      }
      
      protected function ProcessorOnInquiryCharacterIDRet(param1:Object, param2:uint, param3:uint) : void
      {
         this.FProcessorChat.ProcessorInquiryCharacterIDRet(param2,param3);
      }
      
      protected function ProcessorOnChatWhisper(param1:Object, param2:Object) : void
      {
         this.FProcessorChat.ChatWhisperByDigest(param2);
      }
      
      protected function ProcessorOnOpenWriteMail(param1:Object, param2:Object) : void
      {
         this.FProcessorMail.SetWriteMail(param2);
         this.ProcessorWindowsSwitch(this.FProcessorMail);
      }
      
      protected function ProcessorOnProcessFriendNtf(param1:Object, param2:Object) : void
      {
         this.FProcessorHome.ProcessFriendNtf(param1,param2);
      }
      
      protected function ProcessorOnChatAnnouncement(param1:Object, param2:Object) : void
      {
         this.FProcessorChat.ProcessorAntiAddiction(param2);
      }
      
      protected function ProcessorOnAntiAddiction(param1:Object, param2:int) : void
      {
         if(this.FOnAntiAddiction != null)
         {
            this.FOnAntiAddiction(param1,param2);
         }
      }
      
      protected function ProcessorOnQuertInventoryIDRet(param1:Object, param2:uint, param3:uint, param4:uint, param5:uint) : void
      {
         this.FProcessorBackpack.QuertInventoryIDRet(param2,param3,param4,param5);
      }
      
      protected function ProcessorsOnHackWarning(param1:Object, param2:int) : void
      {
         this.FProcessorChat.HackWarning(param2);
      }
      
      protected function ProcessorOnOpenActivityListStatusNotification(param1:Object) : void
      {
         this.FProcessorShortcuts.OpenActivityListStatusNotification();
         this.FProcessorHDOS.UpDateActivityAtoms();
         this.FProcessorHDActivityRecharge.UpDateActivityAtoms();
         this.FProcessorHDMaskFright.UpDateActivityAtoms();
         this.FProcessorHDFirstPay.UpdateAtomState();
         this.FProcessorHDSoulBox.UpDateActivityAtoms();
         this.FProcessorHDRechargeSuit.UpDateActivityAtoms();
         this.FProcessorHDEspada.ProcessorEffectNotify();
         this.FProcessorHDEquipmentShop.ProcessorEffectNotify();
         this.FProcessorHDGambling.ProcessorEffectNotify();
         this.FProcessorHDLimitBuy.ProcessorEffectNotify();
         this.FProcessorHDIceHeros.ProcessorEffectNotify();
         this.FProcessorHDIceDragon.ProcessorEffectNotify();
         this.FProcessorHDSuperEggs.ProcessorEffectNotify();
         this.FProcessorHDServerPay.ProcessorEffectNotify();
         this.FProcessorHDTreasureAwake.ProcessorEffectNotify();
      }
      
      protected function ProcessorUpdateFirstPayIcon(param1:Object) : void
      {
         this.FProcessorShortcuts.OpenActivityListStatusNotification();
      }
      
      protected function ProcessorOnCDKRetNotification(param1:Object) : void
      {
         this.FProcessorHDCDK.CDKRet();
      }
      
      protected function ProcessorOnPost(param1:Object, param2:THyperString, param3:TPost) : void
      {
         this.FProcessorChat.ProcessorPost(param2,param3);
      }
      
      protected function ProcessorOnCheckPlot(param1:Object, param2:int, param3:int, param4:uint, param5:Function = null) : void
      {
         if(this.FOnCheckPlot != null)
         {
            this.FOnCheckPlot(param1,param2,param3,param4,param5);
         }
      }
      
      protected function ProcessorOnDailyQusetInfoReq(param1:Object) : void
      {
         this.FProcessorDailyQuest.InfoReq();
      }
      
      protected function ProcessorOnActiveInfoReq(param1:Object) : void
      {
         this.FProcessorActivityManager.ProcessorOnActiveInfoReq();
      }
      
      protected function ProcessorOnNewAchievementComplete(param1:Object, param2:Object) : void
      {
         this.FProcessorInspector.ShowNewCompleteAchievment(param2);
      }
      
      protected function ProcessorOnShortcutsFlashNotify(param1:Object, param2:Object) : void
      {
         this.FProcessorShortcuts.AchievementInforNotify(param2);
      }
      
      protected function ProcessorOnEnterCityDefendReq(param1:Object) : void
      {
         if(this.FProcessorOrganization.Visible == true)
         {
            this.FProcessorOrganization.Visible = false;
         }
         this.FProcessorCityDefend.EnterCityDefendReq();
      }
      
      protected function ProcessorOnEnterFightPetReq(param1:Object, param2:uint) : void
      {
         this.FProcessorFightPet.EnterFightPetReq(param2);
      }
      
      protected function ProcessorOnEnterTraitorAttackReq(param1:Object) : void
      {
         this.FProcessorTraitorAttack.EnterTraitorAttackReq();
      }
      
      protected function ProcessorOnEnterOnEnterVoidSoulWorldReq(param1:Object) : void
      {
         this.ProcessorPlateSwitch(this.FProcessorVoidSoulWorld,null);
      }
      
      protected function ProcessorOnEnterOrganizationWarReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_OrganizationWar);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnSetBattlePacket(param1:Object, param2:TPacket) : void
      {
         if(this.FOnSetBattlePacket != null)
         {
            this.FOnSetBattlePacket(param1,param2);
         }
      }
      
      protected function ProcessorsOnLoadingQuestOver(param1:Object) : void
      {
         this.FProcessorUnlock.CheckUnlockShortcutsState();
         this.FProcessorSuperMarket.RequestMarketState();
         this.FProcessorAchievement.ProcessorOnLoadAchievementServerData();
      }
      
      protected function ProcessorOnEffectTransition(param1:Object) : void
      {
         this.FEffectTransition.SetEffectByDisplayObject(param1);
      }
      
      protected function ProcessorOnOpenModel(param1:Object, param2:uint, param3:uint = 0, param4:uint = 0) : void
      {
         switch(param2)
         {
            case CONST_POPTIPS.POPTIP_Goto_Strengthen:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Strengthen);
               break;
            case CONST_POPTIPS.POPTIP_Goto_AvaterHead:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Military);
               break;
            case CONST_POPTIPS.POPTIP_Goto_TacticalDeployment:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
               break;
            case CONST_POPTIPS.POPTIP_Goto_GeneralStar:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Backpack:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Backpack);
               break;
            case CONST_POPTIPS.POPTIP_Goto_HellButterfly:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Organization:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Organization);
               break;
            case CONST_POPTIPS.POPTIP_Goto_KnifeOfKillSoul:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeOfKillSoul);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Friend:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Friend);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Heros:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Arena:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Arena);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Tavern:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
               break;
            case CONST_POPTIPS.POPTIP_Goto_KillHeros:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KillHeros);
               break;
            case CONST_POPTIPS.POPTIP_Goto_WorldMap:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_WorldMap);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Treasure:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Jade:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Jade);
               break;
            case CONST_POPTIPS.POPTIP_Goto_TreasureMap:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TreasureMap);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Sign:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Sign);
               break;
            case CONST_POPTIPS.POPTIP_Goto_DailyQuest:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_DailyQuest);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Mall:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Mall);
               break;
            case CONST_POPTIPS.POPTIP_Goto_KnifeSoul:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeSoul);
               break;
            case CONST_POPTIPS.POPTIP_Goto_Skill:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,param3,param4);
               break;
            case CONST_POPTIPS.POPTIP_Goto_LevelGiftBag:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_LevelGiftBag);
         }
      }
      
      protected function ProcessorOnOpenShinobidoPractise(param1:Object) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorShinobidoPractise);
      }
      
      protected function ProcessorOnUpdateShortcutsState(param1:Object, param2:Object) : void
      {
         this.FProcessorShortcuts.UpdateShortcutsState(param1,param2);
      }
      
      protected function ProcessorOnUnlockingNotification(param1:Object, param2:Object) : void
      {
         this.FProcessorShortcuts.UnlockingNotification(param1,param2);
      }
      
      protected function ProcessorOnUnlockedNotification(param1:Object, param2:int, param3:int) : void
      {
      }
      
      protected function ProcessorOnUnlockResponse(param1:Object, param2:TBounds, param3:Object) : void
      {
         this.FProcessorUnlock.UnlockResponse(param1,param2,param3);
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnSetBattleBackground(param1:Object, param2:Object) : void
      {
         if(this.FOnSetBattleBackground != null)
         {
            this.FOnSetBattleBackground(param1,param2);
         }
      }
      
      protected function ProcessorAllHeroEquipmentMountedSuitCount(param1:Object) : void
      {
         this.FProcessorHeros.UpdateAllHeroEquipmentMountedSuitCount();
      }
      
      protected function ProcessorOnEnabledCheckSpeedUp(param1:Object) : void
      {
         this.FProcessorCheatChecker.EnabledCheatCheck();
      }
      
      protected function ProcessorOnQuestUpdate() : void
      {
         this.FProcessorShortcuts.QuestUpdate();
         this.FProcessorMainSceneTwo.QuestUpdate();
         this.FProcessorNpcDialog.QuestUpdate();
         this.FProcessorMonsterMap.UpdateQuest();
      }
      
      protected function ProcessorOnAchievementStateUpdate(param1:Object, param2:TAchievementInfor) : void
      {
         this.FProcessorOffceLady.AchievementStateChangeNotify(param2);
         this.FProcessorSuperMarket.AchievementInforUpdateNotify(param2);
         this.FProcessorDailySign.AchievementInforUpdateNotify(param2);
         this.FProcessorMall.AchievementInforUpdateNotify(param2);
      }
      
      protected function ProcessorOnShowHeroInfor(param1:Object, param2:uint, param3:uint) : void
      {
         this.FProcessorInspector.RequestShowHero(param2,param3);
      }
      
      protected function ProcessorOnShowHeroAchievement(param1:Object, param2:uint, param3:uint) : void
      {
         this.FProcessorAchievement.ShowOther = true;
         this.FProcessorAchievement.RequestShowAchievement(param2,param3);
         this.ProcessorShortcutsOnAchievement(this);
      }
      
      protected function ProcessorOnShowInventoryInfor(param1:Object, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : void
      {
         this.FProcessorInspector.RequestInventoryInfor(param2,param3,param4,param5,param6);
      }
      
      protected function ProcessorOnShowHeroDescription(param1:Object, param2:uint) : void
      {
         this.FProcessorInspector.RequestShowHeroDescription(param2);
      }
      
      protected function ProcessorOnTeamBattleChatPopNtf(param1:Object, param2:uint, param3:uint, param4:Object) : void
      {
         this.FProcessorTeamBattle.TeamBattleChatPopNtf(param2,param3,param4);
      }
      
      protected function ProcessorOnCloseSocketLoading(param1:Object) : void
      {
         FAffairGenerator.Generate(AFFAIRID_CloseSocketLoading);
      }
      
      protected function ProcessorOnMarquee(param1:Object, param2:Object) : void
      {
         if(this.FOnMarquee != null)
         {
            this.FOnMarquee(param1,param2);
         }
      }
      
      protected function ProcessorOnShowAndHideMainSceneRoles(param1:Object, param2:Boolean) : void
      {
         SLogicsCore.IsShowAllUser = param2;
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_MAINCITY)
         {
            this.FProcessorMainSceneTwo.ShowAndHideMainSceneRoles(param2);
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_CITYDEFEND)
         {
            this.FProcessorCityDefend.ShowAndHide(param2);
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_FIGHTPET)
         {
            this.FProcessorFightPet.ShowAndHide(param2);
         }
         else if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TRAITORATTACK)
         {
            this.FProcessorTraitorAttack.ShowAndHide(param2);
         }
      }
      
      protected function ProcessorOnQueryShortcutCoordinate(param1:Object, param2:uint, param3:uint, param4:TQueryCoordinate) : void
      {
         this.FProcessorShortcuts.QueryShortcutCoordinate(param1,param2,param3,param4);
      }
      
      protected function ProcessorOnEffectBaseGlowVIP(param1:Object, param2:Boolean) : void
      {
         this.FProcessorShortcuts.EffectBaseGlowVIP(param1,param2);
      }
      
      protected function ProcessorInitBattleCommon() : void
      {
         this.ProcessorPlateSwitch(null);
         this.ProcessorWindowsSwitch(null);
         this.FChatOptions.ChatStatus = CONST_CHAT.MODE_Hidden;
         this.FProcessorChat.SetChatOptions(this.FChatOptions);
         FAffairGenerator.Generate(AFFAIRID_GameStateExternalize);
         FAffairGenerator.Generate(AFFAIRID_TimingWaitBattleLoading);
         FAffairGenerator.Generate(AFFAIRID_ChatOptionsApply);
      }
      
      protected function ProcessorOnStartMiniBattleNtf(param1:Object) : void
      {
         if(this.FOnSetupMiniBattle != null)
         {
            this.ProcessorInitBattleCommon();
            this.FOnSetupMiniBattle(this);
         }
      }
      
      protected function ProcessorLobbyOnInitBattle(param1:Object) : void
      {
         if(this.FOnSetupBattle != null)
         {
            this.ProcessorInitBattleCommon();
            this.FOnSetupBattle(this);
         }
      }
      
      protected function ProcessorOnHomeResetNtf(param1:Object) : void
      {
         this.FProcessorQianKunARoll.ResetData();
      }
      
      protected function ProcessorOnUnLoadBattleResources(param1:Object, param2:Boolean = false) : void
      {
         if(this.FOnUnLoadBattleResources != null)
         {
            this.FOnUnLoadBattleResources(param1,param2);
         }
      }
      
      protected function ProcessorOnBarrierAutoBattle(param1:Object, param2:TNodalAutoMonsterInfo) : void
      {
         this.FProcessorBarrierAutoBattle.OpenWindow(param2);
         this.ProcessorWindowsSwitch(this.FProcessorBarrierAutoBattle);
      }
      
      protected function ProcessorOnContinueBarrierAutoBattleCount(param1:Object, param2:int, param3:int, param4:Boolean, param5:int, param6:int, param7:TNodalAutoMonsterInfo) : void
      {
         this.ProcessorWindowsSwitch(this.FProcessorBarrierAutoBattle);
         this.FProcessorBarrierAutoBattle.ContinueAutoBattleCount(param2,param3,param4,param5,param6);
      }
      
      protected function ProcessorOnContinueAutoBattleInfo(param1:Object, param2:TPacket) : void
      {
         if(this.FProcessorBarrierAutoBattle.Visible == false)
         {
            return;
         }
         this.FProcessorBarrierAutoBattle.PacketPerform_SC_AutoBattleInfo(param2);
      }
      
      protected function ProcessorOnPassInstanceAutoBattle(param1:Object, param2:TPacket) : void
      {
         this.FProcessorLargeWorldMap.PassInstanceAutoBattleWindow(param2);
      }
      
      protected function PorcessorActivityOnGetAtoms(param1:Object, param2:uint) : Vector.<TActivityAtoms>
      {
         var _loc3_:Vector.<TActivityAtoms> = null;
         return this.FProcessorActivityManager.GetActivityAtomsByMainType(param2);
      }
      
      protected function ProcessorActivityOnGetConfig(param1:Object, param2:uint) : TDatebaseVO
      {
         return this.FProcessorActivityManager.GetConfigByActivityNumber(param2);
      }
      
      protected function ProcessorActivityListEffectNotification(param1:Object, param2:uint) : void
      {
         this.FProcessorActivityManager.ActivityListEffectNotification(param2);
      }
      
      protected function ProcessorsAssistanceViewShow(param1:Object = null) : void
      {
         this.FProcessorRelatedAssistance.Visible = true;
         if(param1 != null)
         {
            param1.addChild(this.FProcessorRelatedAssistance);
            this.FProcessorRelatedAssistance.SetCenter(false);
            this.FProcessorRelatedAssistance.SetHeroData();
         }
         else
         {
            this.FMountPointOverview.addChild(this.FProcessorRelatedAssistance);
            this.FProcessorRelatedAssistance.SetCenter(true);
            this.FProcessorRelatedAssistance.Mount();
         }
      }
      
      protected function ProcessorsAssistanceViewClose() : void
      {
         this.FProcessorRelatedAssistance.Visible = false;
      }
      
      protected function ProcessorsAssistanceViewUpdate(param1:int, param2:Object = null) : void
      {
         TRelatedPartnerCommon.AssistanceOperation(this.FProcessorRelatedAssistance,param1,param2);
      }
      
      protected function OpenNightmareMapPointView(param1:int, param2:int) : void
      {
         this.ProcessorWindowsSwitch(null);
         this.FProcessorNightmareMap.BattleType = CONST_BATTLE.BattleType_NightmareTrial;
         this.FProcessorNightmareMap.UIDispatch(param1,param2);
         this.FProcessorNightmareMap.ShowPassAward();
         this.ProcessorPlateSwitch(this.FProcessorNightmareMap);
      }
      
      public function get OnLoadFollowUp() : Function
      {
         return this.FOnLoadFollowUp;
      }
      
      public function set OnLoadFollowUp(param1:Function) : void
      {
         this.FOnLoadFollowUp = param1;
      }
      
      public function get OnSetupBattle() : Function
      {
         return this.FOnSetupBattle;
      }
      
      public function set OnSetupBattle(param1:Function) : void
      {
         this.FOnSetupBattle = param1;
      }
      
      public function get OnSetupMiniBattle() : Function
      {
         return this.FOnSetupMiniBattle;
      }
      
      public function set OnSetupMiniBattle(param1:Function) : void
      {
         this.FOnSetupMiniBattle = param1;
      }
      
      public function get OnQueryBattleActive() : Function
      {
         return this.FOnQueryBattleActive;
      }
      
      public function set OnQueryBattleActive(param1:Function) : void
      {
         this.FOnQueryBattleActive = param1;
      }
      
      public function get OnQueryBattleLoading() : Function
      {
         return this.FOnQueryBattleLoading;
      }
      
      public function set OnQueryBattleLoading(param1:Function) : void
      {
         this.FOnQueryBattleLoading = param1;
      }
      
      public function get OnLogout() : Function
      {
         return this.FOnLogout;
      }
      
      public function set OnLogout(param1:Function) : void
      {
         this.FOnLogout = param1;
      }
      
      public function get OnLoginDirSever() : Function
      {
         return this.FOnLoginDirSever;
      }
      
      public function set OnLoginDirSever(param1:Function) : void
      {
         this.FOnLoginDirSever = param1;
      }
      
      public function get OnPurchaseQuery() : Function
      {
         return this.FOnPurchaseQuery;
      }
      
      public function set OnPurchaseQuery(param1:Function) : void
      {
         this.FOnPurchaseQuery = param1;
      }
      
      public function get OnMarquee() : Function
      {
         return this.FOnMarquee;
      }
      
      public function set OnMarquee(param1:Function) : void
      {
         this.FOnMarquee = param1;
      }
      
      public function set OnSetBattleBackground(param1:Function) : void
      {
         this.FOnSetBattleBackground = param1;
      }
      
      public function get OnSetBattleBackground() : Function
      {
         return this.FOnSetBattleBackground;
      }
      
      public function set OnCheckPlot(param1:Function) : void
      {
         this.FOnCheckPlot = param1;
      }
      
      public function get OnCheckPlot() : Function
      {
         return this.FOnCheckPlot;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnSetBattlePacket() : Function
      {
         return this.FOnSetBattlePacket;
      }
      
      public function set OnSetBattlePacket(param1:Function) : void
      {
         this.FOnSetBattlePacket = param1;
      }
      
      public function get OnAntiAddiction() : Function
      {
         return this.FOnAntiAddiction;
      }
      
      public function set OnAntiAddiction(param1:Function) : void
      {
         this.FOnAntiAddiction = param1;
      }
      
      public function get OnUnLoadBattleResources() : Function
      {
         return this.FOnUnLoadBattleResources;
      }
      
      public function set OnUnLoadBattleResources(param1:Function) : void
      {
         this.FOnUnLoadBattleResources = param1;
      }
      
      public function get OnCloseSocketLoading() : Function
      {
         return this.FOnCloseSocketLoading;
      }
      
      public function set OnCloseSocketLoading(param1:Function) : void
      {
         this.FOnCloseSocketLoading = param1;
      }
      
      public function ProcessorOnBattleShowChat() : void
      {
         this.ProcessorShowChat();
      }
      
      public function ProcessorOnMiniBattleReturn() : void
      {
         this.FProcessorTeamBattle.BattleBack = true;
         this.ProcessorPlateSwitch(this.FProcessorTeamBattle);
      }
      
      public function ProcessorOnBattleReturn(param1:Object, param2:int, param3:int, param4:Boolean) : void
      {
         switch(param2)
         {
            case CONST_BATTLE.BattleType_KillHero:
               this.ProcessorsOnReturnTown(param1);
               this.FProcessorKillHeros.UpdateKillHero(param4,param3);
               this.ProcessorWindowsSwitch(this.FProcessorKillHeros);
               break;
            case CONST_BATTLE.BattleType_SkyTowerPVE:
            case CONST_BATTLE.BattleType_SkyTowerPVP:
               this.FProcessorSkyTower.BattleBack = true;
               this.FProcessorSkyTower.UpdateBattleResult(param4);
               this.ProcessorPlateSwitch(this.FProcessorSkyTower);
               break;
            case CONST_BATTLE.BattleType_GongFuFight:
               this.FProcessorGongFuFight.BattleResult = param4;
               this.ProcessorPlateSwitch(this.FProcessorGongFuFight);
               break;
            case CONST_BATTLE.BattleType_HeroChange:
               this.ProcessorsOnReturnTown(param1);
               this.ProcessorWindowsSwitch(this.FProcessorHeroChange);
               this.FProcessorHeroChange.BattleResult(param4);
               break;
            case CONST_BATTLE.BattleType_Arena:
               this.FProcessorProtagonist.UpdatePrestige();
               this.ProcessorPlateSwitch(this.FProcessorArena);
               break;
            case CONST_BATTLE.BattleType_VoidSoulWorld:
               this.ProcessorPlateSwitch(this.FProcessorVoidSoulWorld);
               break;
            case CONST_BATTLE.BattleType_TreasureMap:
               this.FProcessorTreasureMap.RobberyResult(param4);
               this.ProcessorPlateSwitch(this.FProcessorTreasureMap);
               break;
            case CONST_BATTLE.BattleType_Slave:
               this.ProcessorPlateSwitch(this.FProcessorHome);
               this.ProcessorWindowsSwitch(this.FProcessorMentorship);
               break;
            case CONST_BATTLE.BattleType_SevenKing:
               this.FProcessorSevenKing.BattleBack = true;
               this.ProcessorPlateSwitch(this.FProcessorSevenKing);
               break;
            case CONST_BATTLE.BattleType_SoulMonster:
               this.ProcessorOnEnterHomeReq(this,null);
               break;
            case CONST_BATTLE.BattleType_CityDefend:
               this.FProcessorCityDefend.BattleBack = true;
               this.ProcessorPlateSwitch(this.FProcessorCityDefend);
               break;
            case CONST_BATTLE.BattleType_TraitorAttack:
               this.FProcessorTraitorAttack.BattleBack = true;
               this.ProcessorPlateSwitch(this.FProcessorTraitorAttack);
               break;
            case CONST_BATTLE.BattleType_FightPet:
               this.ProcessorPlateSwitch(this.FProcessorFightPet);
               this.FProcessorFightPet.BattleEnd();
               break;
            case CONST_BATTLE.BattleType_OrganizationWar:
               break;
            case CONST_BATTLE.BattleType_VainTravel:
               this.ProcessorsOnReturnTown(param1);
               this.ProcessorWindowsSwitch(this.FProcessorVainTravel);
               break;
            case CONST_BATTLE.BattleType_OrgSingle:
            case CONST_BATTLE.BattleType_OrgGroup:
               this.FProcessorWindowOrgPointMap.BattleReturn(param2,param3,param4);
               this.ProcessorPlateSwitch(this.FProcessorWindowOrgPointMap);
               break;
            case CONST_BATTLE.BattleType_RelatedPartner:
               this.ProcessorsOnReturnTown(param1);
               this.ProcessorWindowsSwitch(this.FProcessorRelatedPartner);
               break;
            case CONST_BATTLE.BattleType_NightmareTrial:
               this.ProcessorPlateSwitch(this.FProcessorNightmareMap);
               break;
            case CONST_BATTLE.BattleType_ExpDuplicate:
               this.ProcessorsOnReturnTown(param1);
               this.ProcessorWindowsSwitch(this.FProcessorExpDuplicate);
               break;
            default:
               this.ProcessorPlateSwitch(this.FProcessorMonsterMap);
               this.FProcessorMonsterMap.TurnBackMonsterMap(param1,param3,param4);
         }
      }
      
      public function ProcessorOnPlotNotify(param1:Object, param2:Boolean) : void
      {
         this.FProcessorNpcDialog.PlotNotify(param2);
      }
      protected var FIllusionWindow:Sprite;
      protected var FIllusionIcon:Sprite;
      protected var FIllusionRows:Sprite;
      protected var FIllusionMine:Sprite;
      protected var FIllusionCountdown:TextField;
      protected var FIllusionStatus:TextField;
      protected var FIllusionData:Object;
      protected var FIllusionOffset:int = 0;
      protected var FIllusionPending:Boolean = false;
      protected var FIllusionSweep:Boolean = false;
      protected var FIllusionRequestedAt:int = 0;
      protected var FIllusionReceivedAt:int = 0;
      protected var FIllusionResume:Boolean = false;

      protected function IllusionText(parent:Sprite, text:String, x:Number, y:Number, width:Number, size:int = 14, color:uint = 0xFFFFFF, bold:Boolean = false) : TextField
      {
         var field:TextField = new TextField();
         field.defaultTextFormat = new TextFormat("Arial",size,color,bold);
         field.text = text; field.x = x; field.y = y; field.width = width; field.height = size * 3;
         field.selectable = false; field.mouseEnabled = false;
         field.filters = [new DropShadowFilter(2,90,0,1,3,3,2)];
         parent.addChild(field); return field;
      }

      protected function IllusionBox(parent:Sprite,x:Number,y:Number,w:Number,h:Number,fill:uint,alpha:Number = 1) : Sprite
      {
         var box:Sprite = new Sprite(); box.x=x; box.y=y;
         box.graphics.lineStyle(2,0xB7A76D); box.graphics.beginFill(fill,alpha);
         box.graphics.drawRoundRect(0,0,w,h,8,8); box.graphics.endFill(); parent.addChild(box); return box;
      }

      protected function IllusionImage(parent:Sprite,name:String,x:Number,y:Number,w:Number,h:Number) : void
      {
         var loader:Loader = new Loader(); loader.x=x;loader.y=y; loader.mouseEnabled=false;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void {loader.width=w;loader.height=h;});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void {});
         parent.addChild(loader);loader.load(new URLRequest("/gorsel/"+name));
      }

      protected function IllusionButton(parent:Sprite,label:String,x:Number,y:Number,w:Number,h:Number,action:Function,fill:uint = 0x7E3519) : Sprite
      {
         var button:Sprite = this.IllusionBox(parent,x,y,w,h,fill);
         this.IllusionText(button,label,6,(h-22)/2,w-8,18,0xFFF6CE,true);
         button.buttonMode=true; button.mouseChildren=false;
         button.addEventListener(MouseEvent.CLICK,action);
         button.addEventListener(MouseEvent.ROLL_OVER,function(event:MouseEvent):void {button.alpha=0.85;});
         button.addEventListener(MouseEvent.ROLL_OUT,function(event:MouseEvent):void {button.alpha=1;}); return button;
      }

      protected function IllusionConstruct() : void
      {
         this.FIllusionIcon=this.IllusionBox(this.FMountPointIcons,-100,0,64,70,0x20253C);
         this.IllusionImage(this.FIllusionIcon,"aizen-head.png",8,3,48,48);
         this.IllusionText(this.FIllusionIcon,"Đánh Boss",0,50,68,11,0xFFE48B,true);
         this.FIllusionIcon.buttonMode=true;this.FIllusionIcon.mouseChildren=false;
         this.FIllusionIcon.addEventListener(MouseEvent.CLICK,this.IllusionOpen);
         this.FIllusionIcon.visible=false;
         this.FIllusionWindow = new Sprite();
         this.FMountPointWindow.addChild(this.FIllusionWindow);
         this.FIllusionWindow.graphics.beginFill(0x071923);this.FIllusionWindow.graphics.drawRect(0,0,1250,650);this.FIllusionWindow.graphics.endFill();
         this.IllusionImage(this.FIllusionWindow,"infinite-illusion.png",0,0,1250,650);
         this.IllusionText(this.FIllusionWindow,"INFINITE\nILLUSION",42,15,300,48,0xFFFFFF,true);
         var trial:Sprite=this.IllusionBox(this.FIllusionWindow,320,20,85,130,0x632576,0.9);trial.rotation=12;
         this.IllusionText(trial,"TRIAL OF\nSTRENGTH",5,30,90,19,0xFFF0FA,true);
         var heart:Sprite=this.IllusionBox(this.FIllusionWindow,410,30,85,120,0x194965,0.8);heart.rotation=12;
         this.IllusionText(heart,"MUKEN\nAIZEN",5,28,85,19,0xB8D2E9,true);
         var will:Sprite=this.IllusionBox(this.FIllusionWindow,500,30,85,120,0x742A1A,0.8);will.rotation=12;
         this.IllusionText(will,"DAILY\nRANKING",5,28,85,18,0xE7C2A2,true);
         this.IllusionButton(this.FIllusionWindow,"?",1178,8,28,28,this.IllusionHelp,0x1A3D59);
         this.IllusionButton(this.FIllusionWindow,"X",1214,8,28,28,this.IllusionClose,0x8C271D);
         this.IllusionText(this.FIllusionWindow,"RANKING",242,183,200,25,0xFFFFFF,true);
         var board:Sprite=this.IllusionBox(this.FIllusionWindow,60,215,500,400,0x102235,0.94);
         this.IllusionText(board,"Hạng    Người chơi                 Sát thương      Thưởng",12,9,495,14,0xEED4A1,true);
         this.FIllusionRows=new Sprite();this.FIllusionRows.x=10;this.FIllusionRows.y=40;board.addChild(this.FIllusionRows);
         this.FIllusionMine=new Sprite();this.FIllusionMine.x=10;this.FIllusionMine.y=326;board.addChild(this.FIllusionMine);
         this.FIllusionCountdown=this.IllusionText(board,"Trao thưởng sau: --:--:--",12,370,480,14,0xFFC35A,true);
         board.addEventListener(MouseEvent.MOUSE_WHEEL,this.IllusionScroll);
         this.IllusionButton(board,"▲",470,38,24,24,this.IllusionScrollUp,0x173A54);
         this.IllusionButton(board,"▼",470,290,24,24,this.IllusionScrollDown,0x173A54);
         this.IllusionText(this.FIllusionWindow,"MUKEN AIZEN",744,415,480,36,0xFFCB38,true);
         this.IllusionText(this.FIllusionWindow,"10.000.000.000 HP",773,461,420,24,0xFFF0B3,true);
         this.IllusionText(this.FIllusionWindow,"HP hồi đầy mỗi lượt · Xếp hạng sát thương cao nhất",656,494,590,14,0xFFFFFF,true);
         var rewards:Sprite=this.IllusionBox(this.FIllusionWindow,744,544,250,68,0x57331E,0.9);
         this.IllusionText(rewards,"THƯỞNG XẾP HẠNG",8,3,240,13,0xFFD784,true);
         this.IllusionText(rewards,"Vàng  +",12,30,100,18,0xFFDC60,true);
         this.IllusionImage(rewards,"nguyen-thach.png",110,24,36,36);
         this.IllusionText(rewards,"Nguyên thạch",149,32,115,12,0xFFF2C1,true);
         this.IllusionButton(this.FIllusionWindow,"Sweep",1006,548,85,38,this.IllusionSweepClick);
         var challenge:Sprite=this.IllusionButton(this.FIllusionWindow,"CHALLENGE",1100,535,140,78,this.IllusionChallenge);
         this.FIllusionStatus=this.IllusionText(this.FIllusionWindow,"Đang tải bảng xếp hạng...",745,615,500,12,0xFFF4D8,true);
         this.FIllusionWindow.visible=false;
      }

      protected function IllusionOpen(event:MouseEvent = null) : void
      {
         this.FIllusionWindow.visible=true;this.FMountPointWindow.setChildIndex(this.FIllusionWindow,this.FMountPointWindow.numChildren-1);
         this.FIllusionOffset=0;this.IllusionRequest(0);
      }
      protected function IllusionClose(event:MouseEvent) : void {this.FIllusionWindow.visible=false;}
      protected function IllusionHelp(event:MouseEvent) : void
      {
         this.FIllusionStatus.text="Mỗi lượt hồi đầy HP. Lưu lượt cao nhất. Bot đánh mỗi 5 phút. Thưởng tự động lúc 00:00 UTC+7.";
      }
      protected function IllusionRequest(mode:int) : void
      {
         var packet:TPacket=SNetworkCore.PacketAcquire(mode==0?0x01817E00:0x01817E01);
         if(mode!=0)packet.Data.writeByte(mode==2?1:0);
         SNetworkCore.Transceiver.PacketTransmit(packet);
      }
      protected function IllusionChallenge(event:MouseEvent) : void {this.IllusionStart(false);}
      protected function IllusionSweepClick(event:MouseEvent) : void {this.IllusionStart(true);}
      protected function IllusionStart(sweep:Boolean) : void
      {
         if(this.FIllusionPending||TBattleHandle.IsInBattle)return;
         if(this.FIllusionData!=null&&this.FIllusionData.nextFight>this.FIllusionData.now+(getTimer()-this.FIllusionReceivedAt)/1000)return;
         this.FIllusionPending=true;this.FIllusionSweep=sweep;this.FIllusionRequestedAt=getTimer();
         this.FIllusionStatus.text="Đang chiến đấu...";this.IllusionRequest(sweep?2:1);
      }
      protected function IllusionFightRet(packet:TPacket) : void
      {
         var pending:Boolean=this.FIllusionPending;this.FIllusionPending=false;
         if(packet.Data.readUnsignedInt()!=0){this.FIllusionStatus.text="Chưa thể đánh boss. Hãy chờ lượt hồi và thử lại.";return;}
         if(!pending)return;
         if(!this.FIllusionSweep){
            this.FIllusionWindow.visible=false;this.FIllusionResume=true;
            this.ProcessorOnSetBattleStatus(this,CONST_BATTLE.BattleType_Replay,0);
            TBattleHandle.IsInBattle=false;TBattleHandle.AutoCloseBattle(false);
            this.ProcessorLobbyOnInitBattle(this);
         }
      }
      protected function IllusionInfoRet(packet:TPacket) : void
      {
         try {var data:Object=JSON.parse(packet.Data.readUTF());if(data.error!=null)return;this.FIllusionData=data;this.FIllusionReceivedAt=getTimer();this.IllusionRender();}
         catch(error:Error){this.FIllusionStatus.text="Không tải được bảng xếp hạng.";}
      }
      protected function IllusionDamage(value:Number) : String
      {
         if(value>=1000000000)return (value/1000000000).toFixed(2)+"B";
         if(value>=1000000)return (value/1000000).toFixed(2)+"M";
         if(value>=1000)return (value/1000).toFixed(2)+"K";return value.toFixed(0);
      }
      protected function IllusionRow(parent:Sprite,row:Object,y:Number,mine:Boolean = false) : void
      {
         var colors:Array=[0xB58A22,0x7A858D,0x936345];
         var fill:uint=mine?0x663740:(row.rank<=3?colors[row.rank-1]:(row.rank%2==0?0x3B4A5B:0x27364A));
         var item:Sprite=this.IllusionBox(parent,0,y,453,25,fill,0.93);item.graphics.lineStyle();
         this.IllusionText(item,String(row.rank),8,3,32,15,row.rank<=3?0xFFE995:0xC5E0F1,true);
         this.IllusionText(item,String(row.name),43,4,152,12,0xFFFFFF,true);
         this.IllusionText(item,this.IllusionDamage(row.damage),202,4,88,12,0xFFFFFF,true);
         this.IllusionText(item,String(row.reward.gold)+" vàng",289,1,90,11,0xFFE099,true);
         this.IllusionText(item,String(row.reward.stones)+" thạch",373,5,85,11,0x83F5E2,true);
      }
      protected function IllusionRender() : void
      {
         if(this.FIllusionRows==null||this.FIllusionData==null)return;
         while(this.FIllusionRows.numChildren)this.FIllusionRows.removeChildAt(0);
         while(this.FIllusionMine.numChildren)this.FIllusionMine.removeChildAt(0);
         var rows:Array=this.FIllusionData.rows as Array;
         this.FIllusionOffset=Math.max(0,Math.min(this.FIllusionOffset,Math.max(0,rows.length-10)));
         for(var i:int=0;i<10&&i+this.FIllusionOffset<rows.length;i++)this.IllusionRow(this.FIllusionRows,rows[i+this.FIllusionOffset],i*28);
         if(rows.length==0)this.IllusionText(this.FIllusionRows,"Hãy đánh boss để ghi tên lên bảng xếp hạng!",12,60,440,15,0xDBEAF0);
         if(this.FIllusionData.mine!=null)this.IllusionRow(this.FIllusionMine,this.FIllusionData.mine,0,true);
         else this.IllusionText(this.FIllusionMine,"Bạn chưa có sát thương trong hôm nay",12,0,440,13,0xFFDDA4);
         this.FIllusionStatus.text="Số lượt: "+this.FIllusionData.battles+"  ·  Lượt vừa đánh: "+this.IllusionDamage(this.FIllusionData.lastDamage);
      }
      protected function IllusionScroll(event:MouseEvent) : void {this.FIllusionOffset-=event.delta;this.IllusionRender();}
      protected function IllusionScrollUp(event:MouseEvent) : void {this.FIllusionOffset--;this.IllusionRender();}
      protected function IllusionScrollDown(event:MouseEvent) : void {this.FIllusionOffset++;this.IllusionRender();}
      protected function IllusionUpdate() : void
      {
         if(this.FIllusionIcon==null)return;
         var anchor:Point=this.FProcessorShortcuts.IllusionAnchor();
         this.FIllusionIcon.visible=anchor!=null;
         if(anchor!=null){anchor=this.FMountPointIcons.globalToLocal(anchor);this.FIllusionIcon.x=anchor.x;this.FIllusionIcon.y=anchor.y;}
         if(this.FIllusionPending&&getTimer()-this.FIllusionRequestedAt>15000){this.FIllusionPending=false;this.FIllusionStatus.text="Yêu cầu quá hạn. Hãy thử lại.";}
         if(this.FIllusionResume&&!TBattleHandle.IsInBattle&&!this.BattleQueryActive()){this.FIllusionResume=false;this.IllusionOpen();}
         if(this.FIllusionData!=null){
            var remaining:int=Math.max(0,this.FIllusionData.resetAt-this.FIllusionData.now-(getTimer()-this.FIllusionReceivedAt)/1000);
            this.FIllusionCountdown.text="Trao thưởng sau: "+int(remaining/3600)+":"+("0"+int(remaining/60)%60).substr(-2)+":"+("0"+remaining%60).substr(-2)+"  (00:00 UTC+7)";
         }
      }

   }
}

