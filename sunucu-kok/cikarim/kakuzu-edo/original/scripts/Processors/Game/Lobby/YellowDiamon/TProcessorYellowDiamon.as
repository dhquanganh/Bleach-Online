package Processors.Game.Lobby.YellowDiamon
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Agent.SParametersCore;
   import Logics.SLogicsCore;
   import Logics.Streamization.YellowDiamon.TUnstreamizerYellowDiamon;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_YELLOWDIAMON;
   import flash.utils.ByteArray;
   
   public class TProcessorYellowDiamon extends TProcessorLobbyWindows
   {
      
      protected static const UIWIDTH:int = 645;
      
      protected static const UIHEIGHT:int = 607;
      
      protected var FYellowDiamondUnstreamizer:TUnstreamizerYellowDiamon;
      
      protected var FProcessorWindowYellowDiamon:TProcessorWindowYellowDiamon;
      
      protected var FBounds:TBounds;
      
      protected var FOnShowShortcutEffect:Function;
      
      public function TProcessorYellowDiamon(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FYellowDiamondUnstreamizer = new TUnstreamizerYellowDiamon();
         this.FBounds = new TBounds();
         this.FBounds.Width = UIWIDTH;
         this.FBounds.Height = UIHEIGHT;
         this.FProcessorWindowYellowDiamon = new TProcessorWindowYellowDiamon(this);
         this.FProcessorWindowYellowDiamon.OnClose = this.ProcessorWindowOnClose;
         ComponentBoundsCenter(this.FProcessorWindowYellowDiamon,this.FBounds);
         this.FBounds = null;
      }
      
      protected function CheckIfCanShowEffect() : void
      {
         if(SParametersCore.IfBaiDuGame)
         {
            this.FOnShowShortcutEffect(CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_YellowDiamond,this.FProcessorWindowYellowDiamon.CheckIfCanRecive());
         }
         else if(SParametersCore.IfTXGame)
         {
            this.FOnShowShortcutEffect(CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_TXYellowDiamond,this.FProcessorWindowYellowDiamon.CheckIfCanRecive());
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_YELLOWDIAMON.RESOURCESID_YELLOWDIAMON);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_YellowDiamondInfor_Ret,this.PerformPacket_SC_YellowDiamondInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_YellowDiamondState_Ret,this.PerformPacket_SC_YellowDiamondState);
      }
      
      protected function PerformPacket_SC_YellowDiamondInfor(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FYellowDiamondUnstreamizer.Unstreamize(param1.Data,SLogicsCore.Character.YellowDimondInfor,null);
         this.CheckIfCanShowEffect();
      }
      
      protected function PerformPacket_SC_YellowDiamondState(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FYellowDiamondUnstreamizer.UnstreamizationPerform_UpdateYellowDiamondGiftBagState(param1.Data,SLogicsCore.Character.YellowDimondInfor,null);
         SToolReward.ShowReward(param1.Data);
         this.FProcessorWindowYellowDiamon.Update();
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnShowShortcutEffect(param1:Function) : void
      {
         this.FOnShowShortcutEffect = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowYellowDiamon.Load();
            return;
         }
         this.FProcessorWindowYellowDiamon.visible = true;
         this.FProcessorWindowYellowDiamon.Update();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.CheckIfCanShowEffect();
         this.FProcessorWindowYellowDiamon.visible = false;
         this.FProcessorWindowYellowDiamon.Reset();
      }
   }
}

