package Processors.Game.Lobby.Talisman
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventoryReference;
   import Logics.SLogicsCore;
   import Logics.Signals.TSignal;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Inventories.TUtilityInventory;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Inventories.TOverlayerTreasure;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_TALISMAN;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   import flash.utils.ByteArray;
   
   public class TProcessorTalisman extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowTalisman_Width:uint = 628;
      
      protected static const SIZE_WindowTalisman_Height:uint = 453;
      
      protected static const INDEXTREASUREMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXTREASUREMOUNTED;
      
      protected var FCharacter:TCharacter;
      
      protected var FUtilityInventory:TUtilityInventory;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FProcessorWindowTalisman:TProcessorWindowTalisman;
      
      protected var FBoundsBackpack:TBounds;
      
      protected var FOverlayerTreasure:TOverlayerTreasure;
      
      protected var FOverlayerEquipmentMounted:TOverlayerTreasure;
      
      protected var FTabIndex:int;
      
      protected var FOnMountTalisman:Function;
      
      protected var FOnDismountTalisman:Function;
      
      protected var FOnUpdateHerosBaseAttributeReq:Function;
      
      public function TProcessorTalisman(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FUtilityInventory = new TUtilityInventory();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.FProcessorWindowTalisman = new TProcessorWindowTalisman(this);
         this.FProcessorWindowTalisman.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowTalisman.OnEffectHtmlText = ProcessorsOnEffectHtmlText;
         this.FProcessorWindowTalisman.OnClose = this.ProcessorWindowTalismanOnClose;
         this.FProcessorWindowTalisman.OnEquip = this.ProcessorOnEquip;
         this.FProcessorWindowTalisman.OnUpgrade = this.ProcessorOnUpgrade;
         this.FProcessorWindowTalisman.OnTransition = this.ProcessorOnTransition;
         this.FProcessorWindowTalisman.OnLevelUp = this.ProcessorOnLevelUp;
         this.FProcessorWindowTalisman.UIComponentsHintOnOver = this.UIComponentsHintOnOver;
         this.FProcessorWindowTalisman.UIComponentsHintOnOut = this.UIComponentsHintOnOut;
         this.FProcessorWindowTalisman.OnUpdateHerosBaseAttributeReq = this.ProcessorOnUpdateHerosBaseAttributeReq;
         this.FProcessorWindowTalisman.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTalisman.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTalisman.HintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTalisman.HintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FBoundsBackpack = new TBounds();
         this.FBoundsBackpack.X = this.FProcessorWindowTalisman.x;
         this.FBoundsBackpack.Y = this.FProcessorWindowTalisman.y;
         this.FBoundsBackpack.Width = SIZE_WindowTalisman_Width;
         this.FBoundsBackpack.Height = SIZE_WindowTalisman_Height;
         ComponentBoundsCenter(this.FProcessorWindowTalisman,this.FBoundsBackpack);
         this.FBoundsBackpack = null;
         this.FTabIndex = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TALISMAN.RESOURCESID_Swf_Talisman);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FOverlayerTreasure = new TOverlayerTreasure(this);
         this.FOverlayerTreasure.Visible = false;
         this.FOverlayerEquipmentMounted = new TOverlayerTreasure(this);
         this.FOverlayerEquipmentMounted.IsEquiped = true;
         this.FOverlayerEquipmentMounted.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerTreasure);
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerEquipmentMounted);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TSignal = null;
         super.LogicsPerform();
         _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.TALISMAN_MakeSuccess);
         if(_loc1_ == null)
         {
            return;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_41));
         this.FProcessorWindowTalisman.MakeSuccess();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TalismanUpgradeResponse,this.PacketPerform_SC_TalismanUpgradeResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TalismanTransitionResponse,this.PacketPerform_SC_TalismanTransitionResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TalismanLevelUpResponse,this.PacketPerform_SC_TalismanLevelUpResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TalismanProductResponse,this.PacketPerform_SC_TalismanProductResponse);
      }
      
      protected function PacketPerform_SC_TalismanUpgradeResponse(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         var _loc7_:TEquipment = null;
         var _loc8_:TEquipment = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
            _loc7_ = this.FInventoryReference.Inventory as TEquipment;
            _loc6_ = INDEXTREASUREMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.TalismansMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
            this.FProcessorWindowTalisman.UpdateUpgradeEquip();
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_01));
         this.ProcessorOnUpdateHerosBaseAttributeReq(null);
      }
      
      protected function PacketPerform_SC_TalismanTransitionResponse(param1:TPacket) : void
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
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_02));
         this.FProcessorWindowTalisman.Update();
         this.FProcessorWindowTalisman.SetBtnLock();
      }
      
      protected function PacketPerform_SC_TalismanLevelUpResponse(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_03));
         this.FProcessorWindowTalisman.Update(3);
         this.FProcessorWindowTalisman.SetBtnLock();
      }
      
      protected function PacketPerform_SC_TalismanProductResponse(param1:TPacket) : void
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
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_40));
         this.FProcessorWindowTalisman.ProductSuccess();
      }
      
      protected function PerformPacket_CS_TalismanUpgradeRequest(param1:uint, param2:int, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TalismanUpgradeRequest);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function PerformPacket_CS_TalismanTransitionRequest(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TalismanTransitionRequest);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function PerformPacket_CS_TalismanLevelUpRequest(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TalismanLevelUpRequest);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorStreamData(param1:ByteArray) : void
      {
         if(param1.length != 0)
         {
            this.FTabIndex = param1.readUnsignedByte();
         }
      }
      
      protected function ProcessorOnEquip(param1:Object, param2:Object, param3:uint, param4:uint) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         _loc5_ = param2 as TInventory;
         switch(param3)
         {
            case 0:
               if(this.FOnMountTalisman != null)
               {
                  this.FOnMountTalisman(this,param4,_loc5_);
               }
               break;
            case 1:
               _loc6_ = int(_loc5_.CategorySecond);
               if(this.FOnDismountTalisman != null)
               {
                  this.FOnDismountTalisman(this,param4,1,_loc6_);
               }
         }
      }
      
      protected function ProcessorOnUpgrade(param1:Object, param2:uint, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc4_ = 0;
         _loc5_ = param3 as TInventory;
         if(param2 != 0)
         {
            _loc4_ = int(_loc5_.CategorySecond);
         }
         else
         {
            _loc4_ = int(_loc5_.Identifier);
         }
         this.PerformPacket_CS_TalismanUpgradeRequest(param2,_loc4_,_loc5_.IDTemplate);
      }
      
      protected function ProcessorOnTransition(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:TInventory = null;
         _loc4_ = param2 as TInventory;
         _loc5_ = param3 as TInventory;
         this.PerformPacket_CS_TalismanTransitionRequest(_loc4_.Identifier,_loc4_.IDTemplate,_loc5_.IDTemplate);
      }
      
      protected function ProcessorOnLevelUp(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         _loc3_ = param2 as TInventory;
         this.PerformPacket_CS_TalismanLevelUpRequest(_loc3_.Identifier);
      }
      
      protected function ProcessorWindowTalismanOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnUpdateHerosBaseAttributeReq(param1:Object) : void
      {
         if(this.FOnUpdateHerosBaseAttributeReq != null)
         {
            this.FOnUpdateHerosBaseAttributeReq(this);
         }
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:TInventory = null;
         var _loc6_:TOverlayer = null;
         _loc4_ = param2 as TInventory;
         _loc5_ = param3 as TInventory;
         _loc6_ = this.FOverlayerTreasure;
         if(_loc6_ != null)
         {
            _loc6_.Context = _loc4_;
            if(_loc5_ == null)
            {
               _loc6_.Render(FUICore.MouseCoordinate);
            }
            else
            {
               _loc6_.Render(FUICore.MouseCoordinate);
               _loc6_.CoordinateOverlay.X -= _loc6_.BoundsSubstrate.Width + 65;
            }
            _loc6_.Show();
         }
         if(_loc5_ != null && this.FOverlayerEquipmentMounted != null)
         {
            this.FOverlayerEquipmentMounted.Context = _loc5_;
            this.FOverlayerEquipmentMounted.Render(_loc6_.CoordinateOverlay);
            this.FOverlayerEquipmentMounted.CoordinateOverlay.X = _loc6_.CoordinateOverlay.X - this.FOverlayerEquipmentMounted.BoundsSubstrate.Width;
            this.FOverlayerEquipmentMounted.Show();
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:TInventory = null;
         var _loc6_:TOverlayer = null;
         var _loc7_:TOverlayer = null;
         _loc4_ = param2 as TInventory;
         _loc5_ = param3 as TInventory;
         _loc6_ = this.FOverlayerTreasure;
         if(_loc6_ != null)
         {
            _loc6_.Hide();
         }
         if(_loc5_ == null)
         {
            return;
         }
         _loc7_ = this.FOverlayerEquipmentMounted;
         if(_loc7_ != null)
         {
            _loc7_.Hide();
         }
      }
      
      public function get OnMountTalisman() : Function
      {
         return this.FOnMountTalisman;
      }
      
      public function set OnMountTalisman(param1:Function) : void
      {
         this.FOnMountTalisman = param1;
      }
      
      public function get OnDismountTalisman() : Function
      {
         return this.FOnDismountTalisman;
      }
      
      public function set OnDismountTalisman(param1:Function) : void
      {
         this.FOnDismountTalisman = param1;
      }
      
      public function get OnUpdateHerosBaseAttributeReq() : Function
      {
         return this.FOnUpdateHerosBaseAttributeReq;
      }
      
      public function set OnUpdateHerosBaseAttributeReq(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeReq = param1;
      }
      
      public function get TabIndex() : int
      {
         return this.FTabIndex;
      }
      
      public function set TabIndex(param1:int) : void
      {
         this.FTabIndex = param1;
      }
      
      public function get ProcessorWindowTalisman() : TProcessorWindowTalisman
      {
         return this.FProcessorWindowTalisman;
      }
      
      public function UpdateEquip() : void
      {
         if(FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowTalisman.UpdateEquip();
         }
      }
      
      public function UpdateCharacterBaseAttributeRet() : void
      {
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowTalisman.UpdateCharacterBaseAttribute();
      }
      
      public function UserUpdateInventories() : void
      {
         if(this.FProcessorWindowTalisman.Visible)
         {
            this.FProcessorWindowTalisman.Update();
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.ProcessorStreamData(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowTalisman.Load();
            return;
         }
         this.FProcessorWindowTalisman.Visible = true;
         this.FProcessorWindowTalisman.Update(0,0);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenTreasure);
      }
      
      override public function Unmount() : void
      {
         this.FTabIndex = -1;
         this.FProcessorWindowTalisman.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseTreasure);
      }
   }
}

