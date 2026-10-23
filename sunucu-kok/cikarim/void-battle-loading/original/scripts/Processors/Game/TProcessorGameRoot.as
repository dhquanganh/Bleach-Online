package Processors.Game
{
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Agent.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Battle.*;
   import Processors.Game.Common.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.CreateChar.*;
   import Processors.Game.Effects.*;
   import Processors.Game.Lobby.*;
   import Processors.Game.Lobby.ADBox.TProcessorADBox;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Login.*;
   import Processors.Game.Marquee.*;
   import Processors.Game.MiniBattle.*;
   import Processors.Game.Plot.*;
   import Processors.Game.SocketLoading.*;
   import Processors.Game.Sound.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class TProcessorGameRoot extends TProcessorGame
   {
      
      protected static const AFFAIRID_ConnectionDrop:uint = 4278190080;
      
      protected static const RESOURCESID_DATEBASE:Vector.<uint> = CONST_DATEBASEVO.RESOURCESID_DATEBASE;
      
      protected var FFontLibrary:TFontLibrary;
      
      protected var FUIWindowInformation:TUIWindowInformation;
      
      protected var FUIWindowAntiAddictionInformation:TUIWindowInformation;
      
      protected var FProcessorSounds:TProcessorSounds;
      
      protected var FProcessorEffect:TProcessorRootEffect;
      
      protected var FProcessorCreateChar:TProcessorCreateChar;
      
      protected var FProcessorLogin:TProcessorLogin;
      
      protected var FProcessorMiniBattle:TProcessorMiniBattle;
      
      protected var FProcessorBattle:TBattleHandle;
      
      protected var FProcessorLobby:TProcessorLobby;
      
      protected var FProcessorPlot:TProcessorPlot;
      
      protected var FProcessorMarquee:TProcessorMarquee;
      
      protected var FProcessorWindowSocketLoading:TProcessorWindowSocketLoading;
      
      protected var FIsLoggedIn:Boolean;
      
      public function TProcessorGameRoot(param1:TUIComponent)
      {
         super(param1);
         this.FProcessorLogin = new TProcessorLogin(this);
         this.FProcessorLogin.Load();
         this.FProcessorLogin.OnLogingError = this.ProcessorLoginOnLogingError;
         this.FProcessorLogin.OnLoggedIn = this.ProcessorLoginOnLoggedIn;
         this.FProcessorLogin.OnConnectionDrop = this.ProcessorLoginOnConnectionDrop;
         this.FProcessorLogin.Visible = false;
         this.FProcessorMiniBattle = new TProcessorMiniBattle(this);
         this.FProcessorMiniBattle.OnBattleShowChat = this.ProcessorOnBattleShowChat;
         this.FProcessorMiniBattle.OnMiniBattleReturn = this.ProcessorOnMiniBattleReturn;
         this.FProcessorMiniBattle.Visible = false;
         this.FProcessorBattle = new TBattleHandle(this);
         this.FProcessorBattle.OnErrorText = this.ProcessorsOnEffectText;
         this.FProcessorBattle.OnCheckPlot = this.ProcessorOnCheckPlot;
         this.FProcessorBattle.OnBattleShowChat = this.ProcessorOnBattleShowChat;
         this.FProcessorBattle.OnBattleReturn = this.ProcessorOnBattleReturn;
         this.FProcessorBattle.Visible = false;
         this.FProcessorLobby = new TProcessorLobby(this);
         this.FProcessorLobby.OnLoadFollowUp = this.ProcessorOnLoadFollowUp;
         this.FProcessorLobby.OnSetupBattle = this.ProcessorLobbyOnSetupBattle;
         this.FProcessorLobby.OnSetupMiniBattle = this.ProcessorLobbyOnSetupMiniBattle;
         this.FProcessorLobby.OnQueryBattleActive = this.ProcessorLobbyOnQueryBattleActive;
         this.FProcessorLobby.OnQueryBattleLoading = this.ProcessorLobbyOnQueryBattleLoading;
         this.FProcessorLobby.OnSetBattleBackground = this.ProcessorOnSetBattleBackground;
         this.FProcessorLobby.OnCheckPlot = this.ProcessorOnCheckPlot;
         this.FProcessorLobby.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorLobby.OnSetBattlePacket = this.ProcessorOnSetBattlePacket;
         this.FProcessorLobby.OnAntiAddiction = this.ProcessorOnAntiAddiction;
         this.FProcessorLobby.OnMarquee = this.ProcessorOnMarquee;
         this.FProcessorLobby.OnCloseSocketLoading = this.ProcessorOnCloseSocketLoading;
         this.FProcessorLobby.OnUnLoadBattleResources = this.ProcessorOnUnLoadBattleResources;
         this.FProcessorLobby.Visible = false;
         if(SParametersCore.IsNewUser)
         {
            this.FProcessorCreateChar = new TProcessorCreateChar(this);
            this.FProcessorCreateChar.Load();
            this.FProcessorCreateChar.OnEffectText = this.ProcessorsOnEffectText;
            this.FProcessorCreateChar.OnCharCreated = this.ProcessorOnCharCreated;
            this.FProcessorCreateChar.Visible = false;
         }
         this.ConstructProcessorsSocketLoading();
         this.FProcessorSounds = new TProcessorSounds(this);
         this.FProcessorSounds.Load();
         this.FProcessorSounds.mouseEnabled = false;
         this.FProcessorSounds.Visible = false;
         this.FProcessorPlot = new TProcessorPlot(this);
         this.FProcessorPlot.OnPlotNotify = this.ProcessorOnPlotNotify;
         this.FProcessorPlot.Visible = false;
         this.ConstructProcessorsOverview();
         this.FIsLoggedIn = false;
      }
      
      protected function ConstructProcessorsSocketLoading() : void
      {
         this.FProcessorWindowSocketLoading = new TProcessorWindowSocketLoading(this);
         this.FProcessorWindowSocketLoading.OnQueryLoginStates = this.ProcessorOnQueryLoginStates;
         this.FProcessorWindowSocketLoading.Load();
         this.FProcessorWindowSocketLoading.Visible = false;
      }
      
      protected function ConstructProcessorsOverview() : void
      {
         this.FProcessorMarquee = new TProcessorMarquee(this);
         this.FProcessorMarquee.Load();
         this.FProcessorMarquee.X = (CONST_COMMON.STAGE_Width - 800) / 2;
         this.FProcessorMarquee.Y = 130;
         this.FProcessorMarquee.Visible = true;
         this.FProcessorEffect = new TProcessorRootEffect(this);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(CONST_FONTLIBRARY.RESOURCESID_Fonts.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = CONST_FONTLIBRARY.RESOURCESID_Fonts[_loc1_];
            SResourcesCore.TexturesSwfFont.LoadPrimary(_loc3_);
            _loc1_++;
         }
         SResourcesCore.ResourceBin.LoadPackagePrimary(CONST_DATEBASEVO.RESOURCE_PACKAGEID);
         SResourcesCore.ResourceBin.LoadPackagePrimary(CONST_DATEBASEVO.RESOURCE_PACKAGEID_Activity);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Textures_CURSOR);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCEID_Textures_DefaultRole);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect_Green);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect_Blue);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect_Purple);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect_Gold);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect_Red);
         TProcessorADBox.LoadBox();
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FFontLibrary = new TFontLibrary();
         SUtilityOverLayer.LoadResource(this);
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowInformation;
         this.FUIWindowAntiAddictionInformation = SUtilityOverLayer.UIWindowInformation;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.RegisterRange(18382336,18382337,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CREATECHAR_CreateCharCmd,this.PacketPerform_SC_EnterCreateChar);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_CREATECHAR_Base,CONST_NETWORK.PACKETID_SC_LOBBY_CREATECHAR_End,this.PacketPerform_ProcessorCreateChar);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SOCKET_Base,CONST_NETWORK.PACKETID_SOCKET_End,this.PacketPerform_ProcessorLogin);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Login_StatusServerTransmitTokenRet,this.PacketPerform_ProcessorLogin);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BATTLE_Base,CONST_NETWORK.PACKETID_SC_BATTLE_End,this.PacketPerform_ProcessorBattle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_MiniBattle_Base,CONST_NETWORK.PACKETID_SC_MiniBattle_End,this.PacketPerform_ProcessorMiniBattle);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CHAT_Base,CONST_NETWORK.PACKETID_SC_CHAT_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_COMMON_Base,CONST_NETWORK.PACKETID_SC_LOBBY_COMMON_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_ACCOUNT_Base,CONST_NETWORK.PACKETID_SC_LOBBY_ACCOUNT_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_TOWN_Base,CONST_NETWORK.PACKETID_SC_LOBBY_TOWN_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_HURDLE_Base,CONST_NETWORK.PACKETID_SC_LOBBY_HURDLE_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_WORLDMAP_Base,CONST_NETWORK.PACKETID_SC_LOBBY_WORLDMAP_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Arena_Base,CONST_NETWORK.PACKETID_SC_Arena_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TreasureMap_Base,CONST_NETWORK.PACKETID_SC_TreasureMap_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Tavern_Base,CONST_NETWORK.PACKETID_SC_Tavern_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GENERALSTAR_Base,CONST_NETWORK.PACKETID_SC_GENERALSTAR_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_BACKPACK_Base,CONST_NETWORK.PACKETID_SC_LOBBY_BACKPACK_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_HEROS_Base,CONST_NETWORK.PACKETID_SC_LOBBY_HEROS_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_MILITARYRANK_Base,CONST_NETWORK.PACKETID_SC_MILITARYRANK_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Task_Base,CONST_NETWORK.PACKETID_SC_Task_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Smithy_Base,CONST_NETWORK.PACKETID_SC_Smithy_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_KILLHEROS_Base,CONST_NETWORK.PACKETID_SC_LOBBY_KILLHEROS_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TACTICALDEPLOYMENT_Base,CONST_NETWORK.PACKETID_SC_TACTICALDEPLOYMENT_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LOBBY_FRIEND_Base,CONST_NETWORK.PACKETID_SC_LOBBY_FRIEND_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_MAIL_Base,CONST_NETWORK.PACKETID_SC_MAIL_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_JADE_Base,CONST_NETWORK.PACKETID_SC_JADE_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Talisman_Base,CONST_NETWORK.PACKETID_SC_Talisman_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_EQUIP_Base,CONST_NETWORK.PACKETID_SC_EQUIP_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KnifeSoul_Base,CONST_NETWORK.PACKETID_SC_KnifeSoul_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KnifeOfKillSoul_Base,CONST_NETWORK.PACKETID_SC_KnifeOfKillSoul_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Purchase_Base,CONST_NETWORK.PACKETID_SC_Purchase_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Mall_Base,CONST_NETWORK.PACKETID_SC_Mall_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Sign_Base,CONST_NETWORK.PACKETID_SC_Sign_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_COUNTER_Base,CONST_NETWORK.PACKETID_SC_COUNTER_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyTask_Base,CONST_NETWORK.PACKETID_SC_DailyTask_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VIP_Base,CONST_NETWORK.PACKETID_SC_VIP_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Organization_Base,CONST_NETWORK.PACKETID_SC_Organization_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Mentorship_Base,CONST_NETWORK.PACKETID_SC_Mentorship_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_QianKunARoll_Base,CONST_NETWORK.PACKETID_SC_QianKunARoll_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NijiaStar_Base,CONST_NETWORK.PACKETID_SC_NijiaStar_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_SevenKing_Base,CONST_NETWORK.PACKETID_SC_SevenKing_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLE_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLE_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_INSPECTOR_Base,CONST_NETWORK.PACKETID_SC_INSPECTOR_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HellButterfly_Base,CONST_NETWORK.PACKETID_SC_HellButterfly_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ACTIVITY_Base,CONST_NETWORK.PACKETID_SC_ACTIVITY_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDACTIVITYOS_Base,CONST_NETWORK.PACKETID_SC_HDActivityOS_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDACTIVITYGB_Base,CONST_NETWORK.PACKETID_SC_HDActivityGB_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Post_Base,CONST_NETWORK.PACKETID_SC_Post_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CityDefend_Base,CONST_NETWORK.PACKETID_SC_CityDefend_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FightPet_Base,CONST_NETWORK.PACKETID_SC_FightPet_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_OrganizationWar_Base,CONST_NETWORK.PACKETID_SC_OrganizationWar_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FightingShow_Base,CONST_NETWORK.PACKETID_SC_FightingShow_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TraitorAttack_Base,CONST_NETWORK.PACKETID_SC_TraitorAttack_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Home_Base,CONST_NETWORK.PACKETID_SC_Home_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyActivity_Base,CONST_NETWORK.PACKETID_SC_DailyActivity_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDActivityRecharge_Base,CONST_NETWORK.PACKETID_SC_HDActivityRecharge_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HDActivityFund_Base,CONST_NETWORK.PACKETID_SC_HDActivityFund_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ORNAMENT_Base,CONST_NETWORK.PACKETID_SC_ORNAMENT_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_YellowDiamond_Base,CONST_NETWORK.PACKETID_SC_YellowDiamond_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_FreshGuide_Base,CONST_NETWORK.PACKETID_SC_FreshGuide_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Achievement_Base,CONST_NETWORK.PACKETID_SC_Achievement_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GirlGame_Base,CONST_NETWORK.PACKETID_SC_GirlGame_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ReveredBook_Base,CONST_NETWORK.PACKETID_SC_ReveredBook_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Welcome_Base,CONST_NETWORK.PACKETID_SC_Welcome_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachDailyRecord_Base,CONST_NETWORK.PACKETID_SC_BleachDailyRecord_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachTrain_Base,CONST_NETWORK.PACKETID_SC_BleachTrain_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_GongFuFight_Base,CONST_NETWORK.PACKETID_SC_GongFuFight_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_SkyTower_Base,CONST_NETWORK.PACKETID_SC_SkyTower_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Log_Base,CONST_NETWORK.PACKETID_SC_Log_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CrashJade_Base,CONST_NETWORK.PACKETID_SC_CrashJade_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_DailyWelfare_Base,CONST_NETWORK.PACKETID_SC_DailyWelfare_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TreasureAwake_Base,CONST_NETWORK.PACKETID_SC_TreasureAwake_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HeroChange_Base,CONST_NETWORK.PACKETID_SC_HeroChange_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BlackMarket_Base,CONST_NETWORK.PACKETID_SC_BlackMarket_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Pet_Base,CONST_NETWORK.PACKETID_SC_Pet_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetHouse_Base,CONST_NETWORK.PACKETID_SC_PetHouse_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetTrain_Base,CONST_NETWORK.PACKETID_SC_PetTrain_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetStudy_Base,CONST_NETWORK.PACKETID_SC_PetStudy_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_LikeUs_Base,CONST_NETWORK.PACKETID_SC_LikeUs_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VainTravel_Base,CONST_NETWORK.PACKETID_SC_VainTravel_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_HeroRecruit_Base,CONST_NETWORK.PACKETID_SC_HeroRecruit_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Companion_Base,CONST_NETWORK.PACKETID_SC_Companion_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_OrgPointMap_Base,CONST_NETWORK.PACKETID_SC_OrgPointMap_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_Base,CONST_NETWORK.PACKETID_SC_PointMapInfoUI_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TimeMall_Base,CONST_NETWORK.PACKETID_SC_TimeMall_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Related_Base,CONST_NETWORK.PACKETID_SC_Related_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NightmareTrial_Base,CONST_NETWORK.PACKETID_SC_NightmareTrial_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_NightmareTrialPointMap_Base,CONST_NETWORK.PACKETID_SC_NightmareTrialPointMap_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_BleachAgent_Base,CONST_NETWORK.PACKETID_SC_BleachAgent_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CustomHero_Base,CONST_NETWORK.PACKETID_SC_CustomHero_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_CollectSoul_Base,CONST_NETWORK.PACKETID_SC_CollectSoul_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ExpDuplicate_Base,CONST_NETWORK.PACKETID_SC_ExpDuplicate_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ChangeInfo_Base,CONST_NETWORK.PACKETID_SC_ChangeInfo_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Rebirth_Base,CONST_NETWORK.PACKETID_SC_Rebirth_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Smelt_Base,CONST_NETWORK.PACKETID_SC_Smelt_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_KingChallenge_Base,CONST_NETWORK.PACKETID_SC_KingChallenge_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_Base,CONST_NETWORK.PACKETID_SC_VoidSoulWorld_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_UltimateEquip_Base,CONST_NETWORK.PACKETID_SC_UltimateEquip_End,this.PacketPerform_ProcessorLobby);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_ProfessionRefine_Base,CONST_NETWORK.PACKETID_SC_ProfessionRefine_End,this.PacketPerform_ProcessorLobby);
      }
      
      protected function PacketPerform_SC_EnterCreateChar(param1:TPacket) : void
      {
         this.ProcessorOnHideSocketLoading(this);
         this.FProcessorCreateChar.Visible = true;
         this.FProcessorCreateChar.SubmitGameStatistical();
      }
      
      protected function PacketPerform_ProcessorCreateChar(param1:TPacket) : void
      {
         this.FProcessorCreateChar.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorLogin(param1:TPacket) : void
      {
         this.FProcessorLogin.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorBattle(param1:TPacket) : void
      {
         this.FProcessorBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorMiniBattle(param1:TPacket) : void
      {
         this.FProcessorMiniBattle.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorLobby(param1:TPacket) : void
      {
         this.FProcessorLobby.PacketProcess(param1);
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_ConnectionDrop,this.AffairPerform_ConnectionDrop);
      }
      
      protected function AffairPerform_ConnectionDrop(param1:TAffair) : void
      {
         var _loc2_:String = null;
         this.FUIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GAMEROOT_03);
         this.FUIWindowInformation.OnOK = this.WindowApprisalOnOK;
         this.FUIWindowInformation.Visible = true;
         _loc2_ = SParametersCore.AgentID + ";" + SParametersCore.ServerID + ";" + SParametersCore.OperatorUserID + ";" + SLogicsCore.Character.RoleSencePosition + ";" + SNetworkCore.Transceiver.ServerHost + ";" + SNetworkCore.Transceiver.ServerPort + ";" + STimingCore.TickCount + ";" + Capabilities.version + ";";
         SExternalCore.GameDropLog(_loc2_);
         this.ProcessorOnCloseSocketLoading(this);
      }
      
      protected function ProcessorOnQueryLoginStates(param1:Object, param2:TQueryBoolean) : void
      {
         param2.Value = this.FIsLoggedIn;
      }
      
      protected function WindowAntiAddictionInformationOnOK(param1:Object) : void
      {
         SExternalCore.ReloadGame();
      }
      
      protected function WindowApprisalOnOK(param1:Object) : void
      {
         SExternalCore.ReloadGame();
      }
      
      protected function ProcessorLoginOnLogingError(param1:Object) : void
      {
         this.ProcessorOnCloseSocketLoading(this);
      }
      
      protected function ProcessorLoginOnLoggedIn(param1:Object) : void
      {
         this.FProcessorLogin.Visible = false;
         this.FProcessorLobby.Visible = true;
         this.FProcessorBattle.Visible = false;
         this.FIsLoggedIn = true;
         if(!SParametersCore.IsNewUser && !SResourcesCore.LoadingPrimary)
         {
            this.ProcessorOnShowSocketLoading(this);
         }
      }
      
      protected function ProcessorLoginOnConnectionDrop(param1:Object) : void
      {
         FAffairGenerator.Generate(AFFAIRID_ConnectionDrop);
         this.FIsLoggedIn = false;
      }
      
      protected function ProcessorOnAntiAddiction(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:TSystemLanguage = null;
         _loc3_ = CONST_SYSTEMLANGUAGE.ANTIADDICTIONS[param2 - 1];
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc3_) as TSystemLanguage;
         _loc4_ = _loc5_.Desc;
         this.FUIWindowAntiAddictionInformation.Text = _loc4_;
         if(param2 == CONST_INSPECTOR.TIME_AntiAddictionUpperLimit)
         {
            this.FUIWindowAntiAddictionInformation.OnOK = this.WindowAntiAddictionInformationOnOK;
         }
         else
         {
            this.FUIWindowAntiAddictionInformation.OnOK = null;
         }
         this.FUIWindowAntiAddictionInformation.Visible = true;
      }
      
      protected function ProcessorsOnEffectText(param1:Object, param2:String, param3:TEffectTextParameters = null, param4:TEffectCoordinateParameters = null) : void
      {
         this.FProcessorEffect.ImportText(param2,param3,param4);
      }
      
      protected function ProcessorOnMiniBattleReturn(param1:Object) : void
      {
         this.FProcessorLobby.ProcessorOnMiniBattleReturn();
         this.FProcessorMiniBattle.Visible = false;
      }
      
      protected function ProcessorOnBattleShowChat(param1:Object) : void
      {
         this.FProcessorLobby.ProcessorOnBattleShowChat();
      }
      
      protected function ProcessorOnBattleReturn(param1:Object, param2:int, param3:int, param4:Boolean) : void
      {
         this.FProcessorLobby.ProcessorOnBattleReturn(param1,param2,param3,param4);
         this.FProcessorBattle.Visible = false;
      }
      
      protected function ProcessorOnSetBattleBackground(param1:Object, param2:Object) : void
      {
         this.FProcessorBattle.SetBattleBackground(param1,param2);
      }
      
      protected function ProcessorOnMarquee(param1:Object, param2:Object) : void
      {
         this.FProcessorMarquee.StartMarquee(param2);
      }
      
      protected function ProcessorOnShowSocketLoading(param1:Object) : void
      {
         this.FProcessorWindowSocketLoading.ShowLoading();
      }
      
      protected function ProcessorOnHideSocketLoading(param1:Object) : void
      {
         this.FProcessorWindowSocketLoading.HideLoading();
      }
      
      protected function ProcessorOnCloseSocketLoading(param1:Object) : void
      {
         this.FProcessorWindowSocketLoading.OnQueryLoginStates = null;
         this.FProcessorWindowSocketLoading.HideLoading();
         this.FProcessorWindowSocketLoading.Dispose();
      }
      
      protected function ProcessorOnUnLoadBattleResources(param1:Object, param2:Boolean = false) : void
      {
         this.FProcessorBattle.ProcessorUnLoadModelResources();
         this.FProcessorBattle.ProcessorUnLoadSkillResources();
         if(param2)
         {
            this.FProcessorBattle.ProcessorUnLoadModelRunResources();
         }
      }
      
      protected function ProcessorOnCheckPlot(param1:Object, param2:uint, param3:uint, param4:uint, param5:Function = null) : void
      {
         this.FProcessorPlot.CheckPlot(param2,param3,param4,param5);
      }
      
      protected function ProcessorOnPlotNotify(param1:Object, param2:Boolean) : void
      {
         this.FProcessorLobby.ProcessorOnPlotNotify(param1,param2);
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:int, param3:int) : void
      {
         this.FProcessorBattle.SetStatusType(param2,param3);
      }
      
      protected function ProcessorOnSetBattlePacket(param1:Object, param2:TPacket) : void
      {
         this.FProcessorBattle.SetBattlePacket(param1,param2);
      }
      
      protected function ProcessorOnLoadFollowUp(param1:Object) : void
      {
         if(SParametersCore.IsNewUser)
         {
            if(this.FProcessorCreateChar != null)
            {
               if(this.FProcessorCreateChar.Visible)
               {
                  this.FProcessorCreateChar.Visible = false;
               }
            }
         }
      }
      
      protected function ProcessorOnCharCreated(param1:Object) : void
      {
         this.FProcessorCreateChar.Visible = false;
         this.FProcessorCreateChar.OnEffectText = null;
         this.FProcessorCreateChar.OnCharCreated = null;
         this.FProcessorCreateChar.Dispose();
         this.FProcessorCreateChar.parent.removeChild(this.FProcessorCreateChar);
         this.FProcessorCreateChar.Parent = null;
         this.FProcessorCreateChar = null;
         if(!SResourcesCore.LoadingPrimary)
         {
            this.ProcessorOnShowSocketLoading(this);
         }
      }
      
      protected function ProcessorLobbyOnSetupMiniBattle(param1:Object) : void
      {
         this.FProcessorMiniBattle.Setup();
         this.FProcessorMiniBattle.Visible = true;
      }
      
      protected function ProcessorLobbyOnSetupBattle(param1:Object) : void
      {
         this.FProcessorBattle.Visible = true;
      }
      
      protected function ProcessorLobbyOnQueryBattleActive(param1:Object, param2:TQueryBoolean) : void
      {
         param2.Value = this.FProcessorBattle.Active;
      }
      
      protected function ProcessorLobbyOnQueryBattleLoading(param1:Object, param2:TQueryBoolean) : void
      {
         param2.Value = this.FProcessorBattle.Loading;
      }
      
      public function LoadingCompletedNtf() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = true;
         if(this.FProcessorCreateChar != null && this.FProcessorCreateChar.Visible)
         {
            _loc1_ = false;
         }
         if(_loc1_)
         {
            this.ProcessorOnShowSocketLoading(this);
         }
      }
   }
}

