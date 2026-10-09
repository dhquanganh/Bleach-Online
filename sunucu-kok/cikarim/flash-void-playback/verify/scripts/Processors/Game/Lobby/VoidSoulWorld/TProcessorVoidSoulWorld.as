package Processors.Game.Lobby.VoidSoulWorld
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.ChatOptions.TChatOptions;
   import Logics.SLogicsCore;
   import Logics.Streamization.VoidSoulWorld.TUnstreamizerVoidSoulWorld;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CHAT;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ORGANIZATION;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorVoidSoulWorld extends TProcessorLobbyPlate
   {
      
      protected const RESOURCE_ID:uint = 1040187392;
      
      protected var FMainWin:TProcessorVoidSoulWorldMainWin;
      
      protected var FData:TVoidSoulWorldData;
      
      protected var FUnstreamizer:TUnstreamizerVoidSoulWorld;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      public function TProcessorVoidSoulWorld(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorVoidSoulWorldMainWin(this);
         this.FMainWin.OnClose = this.OnClose;
         this.FMainWin.Visible = false;
         this.FData = SLogicsCore.VoidSoulWorldData;
         this.FUnstreamizer = new TUnstreamizerVoidSoulWorld(this.FData);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCE_ID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_InitRet,this.PacketPerform_SC_InitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_InfoSubmitRet,this.PacketPerform_SC_InfoSubmitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_FightEnterRet,this.PacketPerform_SC_FightEnterRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_ReviveRet,this.PacketPerform_SC_ReviveRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_DeadRet,this.PacketPerform_SC_DeadRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_RankRet,this.PacketPerform_SC_RankRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_ReportRet,this.PacketPerform_SC_ReportRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VoidSoulWorld_JoinAwardRet,this.PacketPerform_SC_JoinAwardRet);
      }
      
      protected function PacketPerform_SC_InitRet(param1:TPacket) : void
      {
         this.FUnstreamizer.InitRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.Visible = true;
            this.FMainWin.UpdateUI();
            this.FMainWin.UpdateAllPlayers();
         }
      }
      
      protected function PacketPerform_SC_InfoSubmitRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.InfoSubmitRet(param1.Data);
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_09));
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.UpdateUI();
         }
      }
      
      protected function PacketPerform_SC_FightEnterRet(param1:TPacket) : void
      {
         var debug:TPacket;
         var status:TPacket;
         var setup:TPacket;
         var failure:TPacket;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         debug = SNetworkCore.PacketAcquire(25293569);
         debug.Data.writeUTF("enter-native-v3");
         SNetworkCore.Transceiver.PacketTransmit(debug);
         try
         {
            if(this.FOnSetBattleStatus != null)
            {
               this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_VoidSoulWorld,CONST_MUSIC.ID_SCENE_OrganizationalWar);
            }
            status = SNetworkCore.PacketAcquire(25293569);
            status.Data.writeUTF("status-set-v3");
            SNetworkCore.Transceiver.PacketTransmit(status);
            if(this.FOnInitBattle != null)
            {
               this.FOnInitBattle(this);
            }
            setup = SNetworkCore.PacketAcquire(25293569);
            setup.Data.writeUTF("setup-done-v3");
            SNetworkCore.Transceiver.PacketTransmit(setup);
         }
         catch(e:Error)
         {
            failure = SNetworkCore.PacketAcquire(25293569);
            failure.Data.writeUTF("setup-error " + e.errorID + " " + e.message);
            SNetworkCore.Transceiver.PacketTransmit(failure);
            EffectGenerateText("Void: " + e.message);
         }
      }
      
      protected function PacketPerform_SC_ReviveRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.ReviveRet(param1.Data);
         this.FMainWin.UpdateUI();
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_12));
      }
      
      protected function PacketPerform_SC_DeadRet(param1:TPacket) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.FUnstreamizer.DeadRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            if(_loc2_.hasOwnProperty("Index1"))
            {
               this.FMainWin.UpdateUI();
               this.FMainWin.Death(_loc2_.Index1,_loc2_.Index2);
            }
            if(_loc2_.BossHurt > 0)
            {
               this.FMainWin.GoneBossHurt(_loc2_.BossHurt);
            }
         }
      }
      
      protected function PacketPerform_SC_RankRet(param1:TPacket) : void
      {
         this.FUnstreamizer.RankRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.UpdateUI();
         }
      }
      
      protected function PacketPerform_SC_ReportRet(param1:TPacket) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.FUnstreamizer.ReportRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.UpdateUI();
         }
         if(_loc2_.Silver > 0)
         {
            SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_10),_loc2_.Silver));
         }
      }
      
      protected function PacketPerform_SC_JoinAwardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.JoinAwardRet(param1.Data);
         this.FMainWin.UpdateUI();
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_01));
      }
      
      protected function GameStart() : void
      {
         this.FUnstreamizer.GameStart();
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.UpdateUI();
         }
      }
      
      protected function GameOver() : void
      {
         this.FUnstreamizer.GameOver();
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.UpdateUI();
            this.FMainWin.UpdateAllPlayers();
         }
      }
      
      protected function OnClose(param1:*) : void
      {
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(this);
         }
      }
      
      public function set OnReturnMainScene(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      override public function ChatOptionsSetup(param1:TChatOptions) : void
      {
         param1.ChatStatus = CONST_CHAT.MODE_Hidden;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_VoidSoulWorld;
         this.FUnstreamizer.InitReq();
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_OrganizationalWar,CONST_MUSIC.ID_SCENE_OrganizationalWar,false);
      }
      
      public function SetActivityStatus(param1:uint) : void
      {
         if(param1 == CONST_ORGANIZATION.STATUS_ORGACTIVITY_Battle)
         {
            this.GameStart();
         }
         else
         {
            this.GameOver();
         }
      }
      
      public function TurnBackTownSceneNtf() : void
      {
         this.OnClose(null);
      }
   }
}

