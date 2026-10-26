package Processors.Game.Lobby.Ornament
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventoryReference;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Inventories.TUtilityInventory;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ORNAMENT;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorOrnamentStrengthen extends TProcessorLobbyWindows
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const SIZE_WIDTH_WindowOrnament:uint = 599;
      
      protected static const SIZE_HEIGHT_WindowOrnament:uint = 453;
      
      protected static const INDEXORNAMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXORNAMENTMOUNTED;
      
      protected var FCharacter:TCharacter;
      
      protected var FUtilityInventory:TUtilityInventory;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FProcessorWindowOrnamentStrengthen:TProcessorWindowOrnamentStrengthen;
      
      protected var FBounds:TBounds;
      
      public function TProcessorOrnamentStrengthen(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FUtilityInventory = new TUtilityInventory();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.InitWindow();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORNAMENT.RESOURCESID_Swf_OrnamentStrengthen);
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
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Ornament_OrnamentGradeRet,this.PerformPacket_SC_OrnamentGradeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Ornament_OrnamentUpgradeRet,this.PerformPacket_SC_OrnamentUpgradeRet);
      }
      
      protected function PerformPacket_SC_OrnamentGradeRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:THero = null;
         var _loc7_:int = 0;
         var _loc8_:TEquipment = null;
         var _loc9_:TEquipment = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc2_,this.FInventoryReference,null);
            _loc8_ = this.FInventoryReference.Inventory as TEquipment;
            _loc7_ = INDEXORNAMENTMOUNTED.indexOf(_loc8_.CategorySecond);
            _loc6_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc5_);
            _loc9_ = _loc6_.OrnamentsMounted.GetInventoryByIndex(_loc7_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc8_,_loc9_);
            this.FInventoryReference.Inventory = null;
            this.ProcessorHeroBaseAttributeReq(_loc5_);
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_0));
         this.FProcessorWindowOrnamentStrengthen.UpdateUI();
      }
      
      protected function PerformPacket_SC_OrnamentUpgradeRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         var _loc7_:TEquipment = null;
         var _loc8_:TEquipment = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc2_,this.FInventoryReference,null);
            _loc7_ = this.FInventoryReference.Inventory as TEquipment;
            _loc6_ = INDEXORNAMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.OrnamentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
            this.ProcessorHeroBaseAttributeReq(_loc4_);
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_34));
         this.FProcessorWindowOrnamentStrengthen.UpdateUI();
      }
      
      protected function InitWindow() : void
      {
         this.FProcessorWindowOrnamentStrengthen = new TProcessorWindowOrnamentStrengthen(this);
         this.FProcessorWindowOrnamentStrengthen.OnBtnCloseClick = this.WindowOnClose;
         this.FProcessorWindowOrnamentStrengthen.OnBtnOkClick = this.WindowOnOKClick;
         this.FProcessorWindowOrnamentStrengthen.OnSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOrnamentStrengthen.OnSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOrnamentStrengthen.OnEffectText = EffectGenerateText;
         this.FProcessorWindowOrnamentStrengthen.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WIDTH_WindowOrnament;
         this.FBounds.Height = SIZE_HEIGHT_WindowOrnament;
         ComponentBoundsCenter(this.FProcessorWindowOrnamentStrengthen,this.FBounds);
      }
      
      protected function PerformPacket_CS_OrnamentStrengthen(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Ornament_OrnamentGradeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param2);
         if(param2 == 0)
         {
            _loc4_.writeUnsignedInt(param1.Identifier);
         }
         else
         {
            _loc4_.writeUnsignedInt(param1.CategorySecond);
         }
         _loc4_.writeUnsignedInt(param1.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function PerformPacket_CS_OrnamentAdvanced(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Ornament_OrnamentUpgradeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param2);
         if(param2 == 0)
         {
            _loc4_.writeUnsignedInt(param1.Identifier);
         }
         else
         {
            _loc4_.writeUnsignedInt(param1.CategorySecond);
         }
         _loc4_.writeUnsignedInt(param1.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorHeroBaseAttributeReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Account_CharBaseAttributeReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function WindowOnOKClick(param1:uint, param2:TEquipment, param3:uint) : void
      {
         switch(param1)
         {
            case CONST_ORNAMENT.TYPE_UIWINDOW_STRENGTHEN:
               this.PerformPacket_CS_OrnamentStrengthen(param2,param3);
               break;
            case CONST_ORNAMENT.TYPE_UIWINDOW_ADVANCED:
               this.PerformPacket_CS_OrnamentAdvanced(param2,param3);
         }
      }
      
      protected function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowOrnamentStrengthen.Load();
            return;
         }
         this.Visible = true;
         this.FProcessorWindowOrnamentStrengthen.Show();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Visible = false;
         this.FProcessorWindowOrnamentStrengthen.Hide();
      }
   }
}

