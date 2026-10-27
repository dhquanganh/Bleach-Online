package Processors.Game.Lobby.Jade
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventoryReference;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.Inventories.TUtilityInventory;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_JADE;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorJade extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_Jade:int = 696;
      
      protected static const SIZE_HEIGHT_Jade:int = 454;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const INDEXEQUIPMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXEQUIPMENTMOUNTED;
      
      protected var FCharacter:TCharacter;
      
      protected var FUtilityInventory:TUtilityInventory;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FProcessorWindowJade:TProcessorWindowJade;
      
      protected var FBoundsJade:TBounds;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorJade(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FProcessorWindowJade = new TProcessorWindowJade(this);
         this.FProcessorWindowJade.OnClose = this.ProcessorWindowJadeOnClose;
         this.FProcessorWindowJade.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowJade.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowJade.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowJade.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FBoundsJade = new TBounds();
         this.FBoundsJade.Width = SIZE_WIDTH_Jade;
         this.FBoundsJade.Height = SIZE_HEIGHT_Jade;
         ComponentBoundsCenter(this.FProcessorWindowJade,this.FBoundsJade);
         this.FBoundsJade = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_JADE.RESOURCESID_JADE);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUtilityInventory = new TUtilityInventory();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_JadeCombine,this.PacketPerform_SC_JadeCombine);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_JadeEquipMount,this.PacketPerform_SC_EquitJadeMount);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_JadeEquipUnMount,this.PacketPerform_SC_EquitJadeUnmount);
      }
      
      protected function PacketPerform_SC_JadeCombine(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedByte();
         if(_loc2_ != 0)
         {
            this.FProcessorWindowJade.ApplyCombineResult(_loc2_);
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FProcessorWindowJade.ApplyCombineResult(_loc2_);
      }
      
      protected function PacketPerform_SC_EquitJadeMount(param1:TPacket) : void
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
            this.FProcessorWindowJade.ApplyMosaicResult(_loc2_);
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
            _loc7_ = this.FInventoryReference.Inventory as TEquipment;
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         this.FProcessorWindowJade.ApplyMosaicResult(_loc2_);
      }
      
      protected function PacketPerform_SC_EquitJadeUnmount(param1:TPacket) : void
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
            this.FProcessorWindowJade.ApplyMosaicResult(_loc2_);
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
            _loc7_ = this.FInventoryReference.Inventory as TEquipment;
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         this.FProcessorWindowJade.ApplyMosaicResult(_loc2_);
      }
      
      protected function PacketPerform_CS_JadeCombine(param1:Object, param2:uint, param3:TAppliance, param4:uint, param5:uint) : void
      {
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_JadeCombine);
         _loc7_ = _loc6_.Data;
         if(param3 != null)
         {
            _loc8_ = param3.Identifier;
            _loc9_ = param3.IDTemplate;
         }
         else
         {
            _loc8_ = 0;
            _loc9_ = 0;
         }
         _loc7_.writeByte(param2);
         _loc7_.writeUnsignedInt(_loc8_);
         _loc7_.writeUnsignedInt(_loc9_);
         _loc7_.writeShort(param4);
         _loc7_.writeByte(param5);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function PacketPerform_C2S_EquipJadeMount(param1:Object, param2:uint, param3:TEquipment, param4:TAppliance) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_JadeEquipMount);
         _loc6_ = _loc5_.Data;
         if(param2 != 0)
         {
            _loc7_ = param3.CategorySecond;
         }
         else
         {
            _loc7_ = param3.Identifier;
         }
         _loc6_.writeUnsignedInt(param2);
         _loc6_.writeUnsignedInt(_loc7_);
         _loc6_.writeUnsignedInt(param3.IDTemplate);
         _loc6_.writeUnsignedInt(param4.Identifier);
         _loc6_.writeUnsignedInt(param4.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function PacketPerform_C2S_EquipJadeUnmount(param1:Object, param2:uint, param3:TEquipment, param4:TAppliance) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_JadeEquipUnMount);
         _loc6_ = _loc5_.Data;
         if(param2 != 0)
         {
            _loc7_ = param3.CategorySecond;
         }
         else
         {
            _loc7_ = param3.Identifier;
         }
         _loc6_.writeUnsignedInt(param2);
         _loc6_.writeUnsignedInt(_loc7_);
         _loc6_.writeUnsignedInt(param3.IDTemplate);
         _loc6_.writeByte(param4.CategorySecond);
         _loc6_.writeUnsignedInt(param4.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function ProcessorWindowJadeOnClose(param1:Object) : void
      {
         this.FProcessorWindowJade.Visible = false;
         try
         {
            ProcessorClose();
         }
         finally
         {
            Visible = false;
         }
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         FOnEffectText = param1;
         this.FProcessorWindowJade.OnEffectText = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FProcessorWindowJade.UpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowJade.Load();
            return;
         }
         this.FProcessorWindowJade.PrepareOpen();
         this.FProcessorWindowJade.OnCombine = this.PacketPerform_CS_JadeCombine;
         this.FProcessorWindowJade.OnMountJade = this.PacketPerform_C2S_EquipJadeMount;
         this.FProcessorWindowJade.OnUnmountJade = this.PacketPerform_C2S_EquipJadeUnmount;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenJade);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowJade.Visible = false;
         try
         {
            this.FProcessorWindowJade.Reset();
         }
         finally
         {
            super.Unmount();
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseJade);
      }
   }
}

