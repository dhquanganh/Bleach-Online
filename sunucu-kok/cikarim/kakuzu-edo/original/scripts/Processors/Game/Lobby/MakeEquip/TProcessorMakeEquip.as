package Processors.Game.Lobby.MakeEquip
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.Coordinate.TQueryCoordinate;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_EQUIPMAKE;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SIGNAL;
   import flash.utils.ByteArray;
   
   public class TProcessorMakeEquip extends TProcessorLobbyWindows
   {
      
      protected var FProcessorWindowMakeEquip:TProcessorWindowMakeEquip;
      
      protected var FBoundsEquip:TBounds;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorMakeEquip(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowMakeEquip = new TProcessorWindowMakeEquip(this);
         this.FProcessorWindowMakeEquip.OnClose = this.ProcessorWindowTalismanOnClose;
         this.FProcessorWindowMakeEquip.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMakeEquip.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMakeEquip.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMakeEquip.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMakeEquip.EquipMake = this.EquipMake;
         this.FProcessorWindowMakeEquip.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FProcessorWindowMakeEquip.OnQueryShortcutCoordinate = this.ProcessorOnQueryShortcutCoordinate;
         this.FBoundsEquip = new TBounds();
         this.FBoundsEquip.Width = 620;
         this.FBoundsEquip.Height = 460;
         ComponentBoundsCenter(this.FProcessorWindowMakeEquip,this.FBoundsEquip);
         this.FBoundsEquip = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_EQUIPMAKE.RESOURCESID_EQUIP);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Equip_Make,this.PerformPacket_SC_Equip_Make);
      }
      
      protected function PerformPacket_SC_Equip_Make(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         this.FProcessorWindowMakeEquip.SetEnabled(true);
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowMakeEquip.UpdateMade();
         SLogicsCore.SignalPost(CONST_SIGNAL.TALISMAN_MakeSuccess,0);
      }
      
      protected function PerformPacket_CS_EquipMakeRequest(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Equip_Make);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartMakeEquip);
      }
      
      protected function EquipMake(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         var _loc4_:uint = 0;
         _loc3_ = param2 as TInventory;
         _loc4_ = _loc3_.IDTemplate;
         this.PerformPacket_CS_EquipMakeRequest(_loc4_);
      }
      
      protected function ProcessorWindowTalismanOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnEffectAcquireInventory(param1:Object, param2:Object, param3:TEffectCoordinateParameters) : void
      {
         if(this.FOnEffectAcquireInventory != null)
         {
            this.FOnEffectAcquireInventory(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnQueryShortcutCoordinate(param1:Object, param2:uint, param3:TQueryCoordinate) : void
      {
         if(this.FOnQueryShortcutCoordinate != null)
         {
            this.FOnQueryShortcutCoordinate(param1,CONST_SHORTCUTS.POSITION_MainFunction,param2,param3);
         }
      }
      
      override public function get OnEffectText() : Function
      {
         return FOnEffectText;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         FOnEffectText = param1;
         this.FProcessorWindowMakeEquip.OnEffectText = FOnEffectText;
      }
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryShortcutCoordinate() : Function
      {
         return this.FOnQueryShortcutCoordinate;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMakeEquip.Load();
            return;
         }
         this.FProcessorWindowMakeEquip.visible = true;
         this.FProcessorWindowMakeEquip.Update();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenMakeEquip);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowMakeEquip.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseMakeEquip);
      }
   }
}

