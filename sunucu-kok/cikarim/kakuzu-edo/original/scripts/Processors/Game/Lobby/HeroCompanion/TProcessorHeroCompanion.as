package Processors.Game.Lobby.HeroCompanion
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionData;
   import Logics.Streamization.HeroCompanion.TUnstreamizerHeroCompanion;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_HEROCOMPANION;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorHeroCompanion extends TProcessorLobbyWindows
   {
      
      protected static const Window_Width:int = CONST_HEROCOMPANION.COMPANION_WINDOW_WIDTH;
      
      protected static const Window_Height:int = CONST_HEROCOMPANION.COMPANION_WINDOW_HEIGHT;
      
      protected var FProcessorWindow:TProcessorCompanionWindow;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamization:TUnstreamizerHeroCompanion;
      
      protected var FCompanionData:THeroCompanionData;
      
      public function TProcessorHeroCompanion(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindow = new TProcessorCompanionWindow(param1,param2);
         this.FProcessorWindow.OnClose = this.WindowOnClose;
         this.FBounds = new TBounds();
         this.FBounds.Width = Window_Width;
         this.FBounds.Height = Window_Height;
         ComponentBoundsCenter(this.FProcessorWindow,this.FBounds);
         this.FUnstreamization = new TUnstreamizerHeroCompanion();
         this.FCompanionData = new THeroCompanionData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HEROCOMPANION.RESOURCESID_Swf_Companion);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_InfoRet,this.PacketPerform_SC_InfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_EmployRet,this.PacketPerform_SC_EmployRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_SeatedRet,this.PacketPerform_SC_SeatedRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_UnseatedRet,this.PacketPerform_SC_UnseatedRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_UpgrateRet,this.PacketPerform_SC_UpgrateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_ComposeRet,this.PacketPerform_SC_ComposeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_ReforgingRet,this.PacketPerform_SC_ReforgingRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_RefreshRet,this.PacketPerform_SC_RefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Companion_NewEncounterRet,this.PacketPerform_SC_NewEncounterRet);
      }
      
      protected function PacketPerform_SC_NewEncounterRet(param1:TPacket) : void
      {
         this.FUnstreamization.UnstreamizationEncounterRefresh(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_RefreshRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationCostRefresh(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_ReforgingRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationReforging(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_ComposeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationCompose(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_UpgrateRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationUpgrate(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_UnseatedRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationUnSeated(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_SeatedRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationSeated(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function PacketPerform_SC_EmployRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationEmploy(param1.Data,this.FCompanionData);
         this.FProcessorWindow.UpdateView(this.FCompanionData);
         this.FProcessorWindow.ShowEmployAnimation();
      }
      
      protected function PacketPerform_SC_InfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamization.UnstreamizationInfo(param1.Data,this.FCompanionData);
         this.FProcessorWindow.Visible = true;
         this.FProcessorWindow.UpdateView(this.FCompanionData);
      }
      
      protected function WindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindow.Load();
            this.FUnstreamization.UnstreamizationInitCard(this.FCompanionData);
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_InfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
   }
}

