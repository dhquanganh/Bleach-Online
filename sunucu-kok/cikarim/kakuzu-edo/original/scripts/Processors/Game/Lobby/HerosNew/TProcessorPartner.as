package Processors.Game.Lobby.HerosNew
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TWakeUp;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.Inventories.TCollectionInventory;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventoryReference;
   import Logics.Inventories.TInventoryWake;
   import Logics.SLogicsCore;
   import Logics.Signals.TSignal;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryHeroWake;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_COUNTER;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_HEROS;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_POPTIPS;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorPartner extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowHeros_Width:uint = 691;
      
      protected static const SIZE_WindowHeros_Height:uint = 624;
      
      protected static const SIZE_Exchange_Width:uint = 771;
      
      protected static const SIZE_Exchange_Height:uint = 560;
      
      protected static const SIZE_Renew_Width:uint = 332;
      
      protected static const SIZE_Renew_Height:uint = 432;
      
      protected static const INDEXEQUIPMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXEQUIPMENTMOUNTED;
      
      protected static const INDEXORNAMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXORNAMENTMOUNTED;
      
      protected static const INDEXTREASUREMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXTREASUREMOUNTED;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected static const TYPE_MOUNT:uint = 0;
      
      protected static const TYPE_DISMOUNT:uint = 1;
      
      protected static const BASEATTRIBUTENAMEINDEX:Vector.<uint> = Vector.<uint>([CONST_COMMON.BASEATTRIBUTENAME_Power,CONST_COMMON.BASEATTRIBUTENAME_Agility,CONST_COMMON.BASEATTRIBUTENAME_Intellect,CONST_COMMON.BASEATTRIBUTENAME_Life,CONST_COMMON.BASEATTRIBUTENAME_Speed,CONST_COMMON.BASEATTRIBUTENAME_MAXHP,CONST_COMMON.BASEATTRIBUTENAME_NearAttack,CONST_COMMON.BASEATTRIBUTENAME_StrategyAttack,CONST_COMMON.BASEATTRIBUTENAME_NearDefense,CONST_COMMON.BASEATTRIBUTENAME_StrategyDefense]);
      
      protected static const BASEATTRIBUTEINDEX:Vector.<uint> = Vector.<uint>([CONST_COMMON.BASEATTRIBUTEINDEX_Power,CONST_COMMON.BASEATTRIBUTEINDEX_Agile,CONST_COMMON.BASEATTRIBUTEINDEX_Intelligence,CONST_COMMON.BASEATTRIBUTEINDEX_Life,CONST_COMMON.BASEATTRIBUTEINDEX_Speed,CONST_COMMON.BASEATTRIBUTEINDEX_Health,CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalAttack,CONST_COMMON.BASEATTRIBUTEINDEX_MagicAttack,CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalDefends,CONST_COMMON.BASEATTRIBUTEINDEX_MagicDefends]);
      
      protected static const CAPACITY_BASEATTRIBUTESCACHE:uint = BASEATTRIBUTENAMEINDEX.length;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected var FOldHeroBaseAttribute:Vector.<int>;
      
      protected var FOldHero:THero;
      
      protected var FIsShowOldHero:Boolean;
      
      protected var FSystemLanguages:TBins;
      
      protected var FProcessorWindowHeros:TWindowMainUI;
      
      protected var FProcessorWindowOneKeySwap:TProcessorWindowOneKeySwap;
      
      protected var FProcessorHeroRenew:TProcessorWindowHeroRenew;
      
      protected var FBaseAttributesCache:Vector.<int>;
      
      protected var FNewBaseAttributesCache:Vector.<int>;
      
      protected var FCharacter:TCharacter;
      
      protected var FUseInventory:TInventory;
      
      protected var FBounds:TBounds;
      
      protected var FHeroID:uint;
      
      protected var FIsProcessorBaseAttributesEffect:Boolean;
      
      protected var FIsOneKeySwap:Boolean;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FUnstreamizerInventoryHeroWake:TUnstreamizerInventoryHeroWake;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FInitialization:Boolean;
      
      protected var FWakeAttribute:TWakeHeroAttributes;
      
      protected var FHeroWakeData:THeroWakeData;
      
      protected var FOnUpdateTalismanMount:Function;
      
      protected var FOnUseAppliance:Function;
      
      public function TProcessorPartner(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FWakeAttribute = new TWakeHeroAttributes();
         this.FHeroWakeData = SLogicsCore.HeroWakeData;
         this.FProcessorWindowHeros = new TWindowMainUI(this);
         this.FProcessorWindowHeros.OnClose = this.ProcessorWindowHerosOnClose;
         this.FProcessorWindowHeros.OnEffectHtmlText = ProcessorsOnEffectHtmlText;
         this.FProcessorWindowHeros.OnOneKeySwapOnClick = this.ProcessorOnAKeySwap;
         this.FProcessorWindowHeros.OpenRenewOnClick = this.OpenRenewOnClickHandler;
         this.FProcessorWindowHeros.WakeHeroAttributes = this.FWakeAttribute;
         this.FProcessorWindowHeros.HeroWakeData = this.FHeroWakeData;
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WindowHeros_Width;
         this.FBounds.Height = SIZE_WindowHeros_Height;
         ComponentBoundsCenter(this.FProcessorWindowHeros,this.FBounds);
         this.FProcessorWindowOneKeySwap = new TProcessorWindowOneKeySwap(FParameters.MountPointWindow);
         this.FProcessorWindowOneKeySwap.OnClose = this.ProcessorOnWindowExchangeClose;
         this.FProcessorWindowOneKeySwap.OnExchange = this.ProcessorOnExchange;
         this.FProcessorWindowOneKeySwap.OnEffectText = ProcessorsOnEffectText;
         this.FBounds.Width = SIZE_Exchange_Width;
         this.FBounds.Height = SIZE_Exchange_Height;
         ComponentBoundsCenter(this.FProcessorWindowOneKeySwap,this.FBounds);
         this.FBounds.Width = SIZE_Renew_Width;
         this.FBounds.Height = SIZE_Renew_Height;
         this.FProcessorHeroRenew = new TProcessorWindowHeroRenew(this);
         ComponentBoundsCenter(this.FProcessorHeroRenew,this.FBounds);
         this.FBounds = null;
         this.FBaseAttributesCache = new Vector.<int>(CAPACITY_BASEATTRIBUTESCACHE);
         this.FNewBaseAttributesCache = new Vector.<int>(CAPACITY_BASEATTRIBUTESCACHE);
         this.FHeroID = 0;
         this.FInitialization = false;
         this.FOldHeroBaseAttribute = new Vector.<int>();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Signals();
      }
      
      public function Perform_CS_ReceiveStateReq() : void
      {
         var _loc1_:Vector.<uint> = null;
         _loc1_ = new Vector.<uint>(1);
         _loc1_[0] = CONST_COUNTER.KEY_AddHeroSlotNum;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_HeroSlotNum_Req,0,0,_loc1_);
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(true)
         {
            _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_HeroSlotNum_Ret);
            if(_loc1_ == null)
            {
               break;
            }
            _loc2_ = _loc1_.Identifier;
            _loc3_ = uint(_loc1_.Value);
            if(_loc2_ == CONST_COUNTER.KEY_AddHeroSlotNum)
            {
               SLogicsCore.Character.HeroAddSlotNum = _loc3_;
            }
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HEROS.RESOURCESID_Swf_Heros);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.FUnstreamizerInventoryHeroWake = new TUnstreamizerInventoryHeroWake();
         this.FSystemLanguages = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_Dismount,this.PerformPacket_SC_Heros_Dismount);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_Mount,this.PerformPacket_SC_Heros_Mount);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_DeleteHero,this.PerformPacket_SC_Heros_DeleteHero);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_OneKeySwap,this.PerformPacket_SC_Heros_OneKeySwap);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_BuyHeroCountRet,this.PerformPacket_SC_Heros_BuyHeroCount);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Heros_RenewHero,this.PerformPacket_SC_Heros_RenewHero);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_WakeUp_DressRet,this.PerformPacket_SC_WakeUp_Dress);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_WakeUp_ComposeRet,this.PerformPacket_SC_WakeUp_Compose);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_WakeUp_DoneRet,this.PerformPacket_SC_WakeUp_Done);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_WakeUp_AdvancedOrStrengRet,this.PerformPacket_SC_WakeUp_AdvancedOrStrengRet);
      }
      
      protected function PerformPacket_SC_Heros_Dismount(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TInventory = null;
         var _loc8_:TInventories = null;
         var _loc9_:TCollectionInventory = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:Vector.<uint> = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         _loc2_ = param1.Data;
         _loc11_ = _loc2_.readUnsignedInt();
         if(_loc11_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc11_);
            return;
         }
         _loc5_ = int(_loc2_.readUnsignedInt());
         _loc6_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc5_);
         _loc4_ = int(_loc2_.readUnsignedShort());
         if(_loc4_ == 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = int(_loc2_.readUnsignedByte());
            _loc14_ = this.GetCategroyByMountIndex(_loc10_);
            switch(_loc14_)
            {
               case CATEGORY_Equipment:
                  _loc9_ = _loc6_.EquipmentsMounted;
                  _loc8_ = this.FCharacter.Equipments;
                  _loc12_ = INDEXEQUIPMENTMOUNTED;
                  break;
               case CATEGORY_Ornament:
                  _loc9_ = _loc6_.OrnamentsMounted;
                  _loc8_ = this.FCharacter.Ornaments;
                  _loc12_ = INDEXORNAMENTMOUNTED;
                  break;
               case CATEGORY_Treasure:
                  _loc9_ = _loc6_.TalismansMounted;
                  _loc8_ = this.FCharacter.Treasures;
                  _loc12_ = INDEXTREASUREMOUNTED;
            }
            _loc13_ = _loc12_.indexOf(_loc10_);
            _loc7_ = _loc9_.GetInventoryByIndex(_loc13_);
            _loc9_.SetInventoryByIndex(_loc13_,null);
            _loc3_++;
         }
         this.UpdateHeroBaseAttributeReq(_loc5_);
         switch(_loc7_.Category)
         {
            case CATEGORY_Ornament:
            case CATEGORY_Equipment:
               this.ProcessorHeroEquipmentMountedSuitCount(_loc6_,_loc7_,TYPE_DISMOUNT);
               break;
            case CATEGORY_Treasure:
               if(this.FOnUpdateTalismanMount != null)
               {
                  this.FOnUpdateTalismanMount(this);
               }
               this.ProcessorHeroTreasureMountedSuitCount(_loc6_,_loc7_,TYPE_DISMOUNT);
         }
      }
      
      protected function PerformPacket_SC_Heros_Mount(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:TInventory = null;
         var _loc7_:TInventory = null;
         var _loc8_:TInventories = null;
         var _loc9_:TCollectionInventory = null;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
         _loc10_ = _loc3_.readUnsignedInt();
         _loc6_ = this.FCharacter.Equipments.GetInventoryByIdentifier(_loc10_);
         if(_loc6_ == null)
         {
            _loc6_ = this.FCharacter.Ornaments.GetInventoryByIdentifier(_loc10_);
         }
         if(_loc6_ == null)
         {
            _loc6_ = this.FCharacter.Treasures.GetInventoryByIdentifier(_loc10_);
         }
         switch(_loc6_.Category)
         {
            case CATEGORY_Equipment:
               _loc9_ = _loc5_.EquipmentsMounted;
               _loc11_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc6_.CategorySecond);
               break;
            case CATEGORY_Ornament:
               _loc9_ = _loc5_.OrnamentsMounted;
               _loc11_ = INDEXORNAMENTMOUNTED.indexOf(_loc6_.CategorySecond);
               break;
            case CATEGORY_Treasure:
               _loc9_ = _loc5_.TalismansMounted;
               _loc11_ = INDEXTREASUREMOUNTED.indexOf(_loc6_.CategorySecond);
         }
         _loc7_ = _loc9_.GetInventoryByIndex(_loc11_);
         _loc9_.SetInventoryByIndex(_loc11_,_loc6_);
         this.UpdateHeroBaseAttributeReq(_loc4_);
         switch(_loc6_.Category)
         {
            case CATEGORY_Ornament:
            case CATEGORY_Equipment:
               if(_loc7_ != null)
               {
                  this.ProcessorHeroEquipmentMountedSuitCount(_loc5_,_loc7_,TYPE_DISMOUNT);
               }
               this.ProcessorHeroEquipmentMountedSuitCount(_loc5_,_loc6_,TYPE_MOUNT);
               break;
            case CATEGORY_Treasure:
               if(this.FOnUpdateTalismanMount != null)
               {
                  this.FOnUpdateTalismanMount(this);
               }
               if(_loc7_ != null)
               {
                  this.ProcessorHeroTreasureMountedSuitCount(_loc5_,_loc7_,TYPE_DISMOUNT);
               }
               this.ProcessorHeroTreasureMountedSuitCount(_loc5_,_loc6_,TYPE_MOUNT);
         }
      }
      
      protected function PerformPacket_SC_Heros_DeleteHero(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = uint(_loc2_.readInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readInt();
         _loc4_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc5_);
         this.FCharacter.Heros.Delete(_loc4_);
         this.FProcessorWindowHeros.UnlistHeroNotify();
         this.FWakeAttribute.DeletePropertiesByHeroId(_loc5_);
         _loc4_.WakeupStatus = 0;
         _loc4_.WakeupLevel = 0;
         _loc4_.AddQuality = 0;
      }
      
      protected function PerformPacket_SC_Heros_OneKeySwap(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THero = null;
         var _loc8_:THero = null;
         var _loc9_:TCollectionInventory = null;
         var _loc10_:TCollectionInventory = null;
         this.FProcessorWindowOneKeySwap.SetEable(true);
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         _loc6_ = _loc4_.readUnsignedInt();
         _loc7_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc6_);
         this.ClearHeroEquipmentMounted(_loc7_);
         _loc9_ = _loc7_.CrashJadeMounted;
         _loc3_ = _loc4_.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUnstreamizerReference.Unstreamize(_loc4_,this.FInventoryReference,null);
            this.SetHeroExchangeEquipmentMounted(_loc7_,this.FInventoryReference.Inventory);
            this.FInventoryReference.Inventory = null;
            _loc2_++;
         }
         _loc6_ = _loc4_.readUnsignedInt();
         _loc8_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc6_);
         this.ClearHeroEquipmentMounted(_loc8_);
         _loc10_ = _loc8_.CrashJadeMounted;
         _loc3_ = _loc4_.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUnstreamizerReference.Unstreamize(_loc4_,this.FInventoryReference,null);
            this.SetHeroExchangeEquipmentMounted(_loc8_,this.FInventoryReference.Inventory);
            this.FInventoryReference.Inventory = null;
            _loc2_++;
         }
         _loc8_.CrashJadeMounted = _loc9_;
         _loc7_.CrashJadeMounted = _loc10_;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_25));
         this.FProcessorWindowOneKeySwap.Update();
         this.ProcessorHerosBaseAttributeReq();
      }
      
      protected function PerformPacket_SC_Heros_BuyHeroCount(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         this.FCharacter.HeroAddSlotNum = _loc4_;
         this.FProcessorWindowHeros.Update();
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_37);
         EffectGenerateText(_loc5_);
      }
      
      protected function PerformPacket_SC_Heros_RenewHero(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         if(this.FProcessorHeroRenew.Visible)
         {
            this.FProcessorHeroRenew.RefreshView(_loc4_);
         }
      }
      
      protected function PerformPacket_SC_WakeUp_Dress(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:TCollectionInventory = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
         _loc5_.WakeupStatus = _loc3_.readUnsignedInt();
         this.UpdateHeroBaseAttributeReq(_loc4_);
         this.UpdateCharacterInventory();
      }
      
      protected function PerformPacket_SC_WakeUp_Done(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:TWakeUp = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TInventoryWake = null;
         var _loc9_:int = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_);
         _loc5_.WakeupStatus = 0;
         _loc5_.WakeupLevel = _loc3_.readUnsignedInt();
         this.FWakeAttribute.ClearHeroProperty(_loc4_);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,_loc5_.Identifier) as TWakeUp;
         if(_loc6_ == null)
         {
            return;
         }
         _loc7_ = _loc6_.GetIndexsByWakeLevel(_loc5_.WakeupLevel);
         _loc9_ = 0;
         while(_loc9_ < CONST_CHARACTER.CAPACITY_WakeEquipsMounted)
         {
            if(_loc7_.length <= _loc9_)
            {
               _loc5_.WakeEquipsNeed.SetInventoryByIndex(_loc9_,null);
               break;
            }
            _loc8_ = SLogicsCore.Character.InventoryWakes.GetInventoryByTempletID(_loc7_[_loc9_]) as TInventoryWake;
            _loc5_.WakeEquipsNeed.SetInventoryByIndex(_loc9_,_loc8_);
            _loc9_++;
         }
         this.UpdateCharacterInventory();
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_60);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = null;
      }
      
      protected function PerformPacket_SC_WakeUp_AdvancedOrStrengRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerInventoryHeroWake.AdvancedOrStrengRet(_loc3_,SLogicsCore.HeroWakeData);
         this.FProcessorWindowHeros.Update();
         this.UpdateHeroBaseAttributeReq(SLogicsCore.Character.MainHero.Identifier);
      }
      
      protected function PerformPacket_SC_WakeUp_Compose(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         this.FProcessorWindowHeros.BtnComposeAllUpdate(_loc4_);
         this.UpdateCharacterInventory();
      }
      
      protected function SetHeroExchangeEquipmentMounted(param1:THero, param2:TInventory) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TEquipment = null;
         var _loc5_:TCollectionInventory = null;
         var _loc6_:TCollectionInventory = null;
         var _loc7_:TCollectionInventory = null;
         var _loc8_:TCollectionInventory = null;
         _loc5_ = param1.EquipmentsMounted;
         _loc7_ = param1.TalismansMounted;
         _loc6_ = param1.OrnamentsMounted;
         _loc4_ = param2 as TEquipment;
         switch(_loc4_.Category)
         {
            case CATEGORY_Equipment:
               _loc3_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc4_.CategorySecond);
               _loc8_ = _loc5_;
               break;
            case CATEGORY_Ornament:
               _loc3_ = INDEXORNAMENTMOUNTED.indexOf(_loc4_.CategorySecond);
               _loc8_ = _loc6_;
               break;
            case CATEGORY_Treasure:
               _loc3_ = INDEXTREASUREMOUNTED.indexOf(_loc4_.CategorySecond);
               _loc8_ = _loc7_;
         }
         _loc8_.SetInventoryByIndex(_loc3_,_loc4_);
         if(_loc4_.Category == CATEGORY_Equipment)
         {
            this.ProcessorHeroEquipmentMountedSuitCount(param1,_loc4_,TYPE_MOUNT);
         }
         else if(_loc4_.Category == CATEGORY_Ornament)
         {
            this.ProcessorHeroEquipmentMountedSuitCount(param1,_loc4_,TYPE_MOUNT);
         }
         else if(_loc4_.Category == CATEGORY_Treasure)
         {
            if(this.FOnUpdateTalismanMount != null)
            {
               this.FOnUpdateTalismanMount(this);
            }
            this.ProcessorHeroTreasureMountedSuitCount(param1,_loc4_,TYPE_MOUNT);
         }
      }
      
      protected function ClearHeroEquipmentMounted(param1:THero) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TCollectionInventory = null;
         _loc4_ = param1.EquipmentsMounted;
         _loc3_ = INDEXEQUIPMENTMOUNTED.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_.SetInventoryByIndex(_loc2_,null);
            _loc2_++;
         }
         _loc4_ = param1.TalismansMounted;
         _loc3_ = INDEXTREASUREMOUNTED.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_.SetInventoryByIndex(_loc2_,null);
            _loc2_++;
         }
         _loc4_ = param1.OrnamentsMounted;
         _loc3_ = INDEXORNAMENTMOUNTED.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_.SetInventoryByIndex(_loc2_,null);
            _loc2_++;
         }
      }
      
      protected function ProcessorOnDismiss(param1:Object, param2:THero) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_DeleteHero);
         _loc4_ = _loc3_.Data;
         this.FHeroID = param2.Identifier;
         _loc4_.writeUnsignedInt(param2.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorOnAKeySwap(param1:Object) : void
      {
         BarrierActuateWindows(this.FProcessorWindowOneKeySwap);
         this.FProcessorWindowOneKeySwap.Update();
         this.FProcessorWindowOneKeySwap.Visible = true;
      }
      
      protected function OpenRenewOnClickHandler(param1:THero) : void
      {
         this.FProcessorHeroRenew.Visible = true;
         this.FProcessorHeroRenew.ShowViewInfo(param1);
      }
      
      protected function ProcessorHerosBaseAttributeReq() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         _loc4_ = this.FCharacter.Heros;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetHeroByIndex(_loc1_);
            this.UpdateHeroBaseAttributeReq(_loc3_.Identifier);
            _loc1_++;
         }
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
      
      protected function ProcessorOnExchange(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         if(param2 == null || param3 == null)
         {
            return;
         }
         this.FIsOneKeySwap = true;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_OneKeySwap);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt((param2 as THero).Identifier);
         _loc5_.writeUnsignedInt((param3 as THero).Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorAllHeroEquipmentMountedSuitCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:TCollectionInventory = null;
         var _loc8_:TEquipment = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         _loc9_ = new Vector.<uint>();
         _loc6_ = this.FCharacter.Heros;
         _loc2_ = _loc6_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc1_);
            _loc7_ = _loc5_.EquipmentsMounted;
            _loc4_ = _loc7_.Capacity;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc7_.GetInventoryByIndex(_loc3_) as TEquipment;
               if(_loc8_ != null)
               {
                  _loc10_ = _loc9_.indexOf(_loc8_.SuitID);
                  if(_loc10_ < 0)
                  {
                     _loc9_.push(_loc8_.SuitID);
                     _loc11_ = _loc5_.GetSuitCountByEquipment(_loc8_);
                     _loc5_.SetSuitCount(_loc8_,_loc11_);
                  }
               }
               _loc3_++;
            }
            _loc9_.length = 0;
            _loc7_ = _loc5_.OrnamentsMounted;
            _loc4_ = _loc7_.Capacity;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc7_.GetInventoryByIndex(_loc3_) as TEquipment;
               if(_loc8_ != null)
               {
                  _loc10_ = _loc9_.indexOf(_loc8_.SuitID);
                  if(_loc10_ < 0)
                  {
                     _loc9_.push(_loc8_.SuitID);
                     _loc11_ = _loc5_.GetSuitCountByOrnament(_loc8_);
                     _loc5_.SetOrnamentSuitCount(_loc8_,_loc11_);
                  }
               }
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorHeroEquipmentMountedSuitCount(param1:THero, param2:TInventory, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         _loc5_ = param2 as TEquipment;
         if(_loc5_.Category == CATEGORY_Equipment)
         {
            _loc4_ = param1.GetSuitCountByEquipment(_loc5_);
            param1.SetSuitCount(_loc5_,_loc4_);
         }
         else if(_loc5_.Category == CATEGORY_Ornament)
         {
            _loc4_ = param1.GetSuitCountByOrnament(_loc5_);
            param1.SetOrnamentSuitCount(_loc5_,_loc4_);
         }
         switch(param3)
         {
            case TYPE_MOUNT:
               break;
            case TYPE_DISMOUNT:
               _loc5_.SuitCount = 0;
         }
      }
      
      protected function ProcessorHeroTreasureMountedSuitCount(param1:THero, param2:TInventory, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         _loc5_ = param2 as TEquipment;
         if(_loc5_.Category == CATEGORY_Treasure)
         {
            _loc4_ = param1.GetSuitCountByTalisman(_loc5_);
            param1.SetTreasureSuitCount(_loc5_,_loc4_);
         }
         switch(param3)
         {
            case TYPE_MOUNT:
               break;
            case TYPE_DISMOUNT:
               _loc5_.SuitCount = 0;
         }
      }
      
      protected function ProcessorUseInventory() : void
      {
         if(this.FUseInventory != null)
         {
            switch(this.FUseInventory.CategorySecond)
            {
               case CATEGORY_Equipment:
            }
         }
         this.FUseInventory = null;
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_Heros);
         }
      }
      
      public function GetCategroyByMountIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = INDEXEQUIPMENTMOUNTED.indexOf(param1);
         if(_loc2_ != -1)
         {
            return CATEGORY_Equipment;
         }
         _loc2_ = INDEXORNAMENTMOUNTED.indexOf(param1);
         if(_loc2_ != -1)
         {
            return CATEGORY_Ornament;
         }
         _loc2_ = INDEXTREASUREMOUNTED.indexOf(param1);
         if(_loc2_ != -1)
         {
            return CATEGORY_Treasure;
         }
         return 0;
      }
      
      protected function ProcessorWindowHerosOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnWindowExchangeClose(param1:Object) : void
      {
         BarrierDeactuateWindows(this.FProcessorWindowOneKeySwap);
         this.FIsOneKeySwap = false;
         this.FProcessorWindowOneKeySwap.Reset();
         this.FProcessorWindowOneKeySwap.Visible = false;
      }
      
      protected function Perform_CS_MountEquipment(param1:Object, param2:uint, param3:Object) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:TEquipment = null;
         if(param3 is TEquipment)
         {
            _loc6_ = param3 as TEquipment;
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_Mount);
            _loc5_ = _loc4_.Data;
            _loc5_.writeUnsignedInt(param2);
            _loc5_.writeUnsignedInt(_loc6_.Identifier);
            _loc5_.writeUnsignedInt(_loc6_.IDTemplate);
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
            return;
         }
      }
      
      protected function Perform_CS_DismountEquipment(param1:Object, param2:uint, param3:uint, param4:uint, param5:TCollectionInventory = null) : void
      {
         var _loc6_:int = 0;
         var _loc7_:TPacket = null;
         var _loc8_:ByteArray = null;
         var _loc9_:TInventory = null;
         var _loc10_:uint = 0;
         _loc7_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_Dismount);
         _loc8_ = _loc7_.Data;
         _loc8_.writeUnsignedInt(param2);
         _loc8_.writeShort(param3);
         if(param4 == 0)
         {
            _loc10_ = uint(param5.Capacity);
            _loc6_ = 0;
            while(_loc6_ < _loc10_)
            {
               _loc9_ = param5.GetInventoryByIndex(_loc6_);
               if(_loc9_ != null)
               {
                  _loc8_.writeByte(_loc9_.CategorySecond);
               }
               _loc6_++;
            }
         }
         else
         {
            _loc8_.writeByte(param4);
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc7_);
      }
      
      protected function ProcessorOnUseAppliance(param1:Object, param2:TInventory, param3:uint, param4:THero, param5:int) : void
      {
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_UseAppliance);
         _loc7_ = _loc6_.Data;
         _loc7_.writeShort(1);
         _loc7_.writeUnsignedInt(param2.Identifier);
         _loc7_.writeUnsignedInt(param2.IDTemplate);
         _loc7_.writeShort(param3);
         _loc7_.writeUnsignedInt(param4.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
         if(this.FOnUseAppliance != null)
         {
            this.FOnUseAppliance(this,param5);
         }
      }
      
      public function RecordOldBaseAttribute(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         _loc3_ = int(BASEATTRIBUTEINDEX.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FOldHeroBaseAttribute[_loc2_] = param1.GetBaseAttributeByIndex(BASEATTRIBUTEINDEX[_loc2_]);
            _loc2_++;
         }
      }
      
      public function ShowAttributeDifference(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         _loc8_ = "";
         _loc4_ = BASEATTRIBUTEINDEX;
         _loc3_ = int(BASEATTRIBUTEINDEX.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.GetBaseAttributeByIndex(_loc4_[_loc2_]) - this.FOldHeroBaseAttribute[_loc2_];
            if(_loc5_ != 0)
            {
               _loc7_ = BASEATTRIBUTENAMES.indexOf(BASEATTRIBUTENAMEINDEX[_loc2_]);
               _loc6_ = TUtilityLobby.GetBaseAttributeNameByIndex(_loc7_);
            }
            if(_loc5_ > 0)
            {
               _loc8_ = _loc8_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_01),_loc6_,_loc5_);
            }
            else if(_loc5_ < 0)
            {
               _loc8_ = _loc8_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_02),_loc6_,-_loc5_);
            }
            _loc2_++;
         }
         EffectGenerateHtmlText(_loc8_);
      }
      
      public function get OnUpdateTalismanMount() : Function
      {
         return this.FOnUpdateTalismanMount;
      }
      
      public function set OnUpdateTalismanMount(param1:Function) : void
      {
         this.FOnUpdateTalismanMount = param1;
      }
      
      public function set OnUseAppliance(param1:Function) : void
      {
         this.FProcessorWindowHeros.OnUseApplianceNotify = param1;
      }
      
      public function set OnChangeSkillReq(param1:Function) : void
      {
         this.FProcessorWindowHeros.OnChangeSkillReq = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHeros.Load();
            this.FProcessorWindowOneKeySwap.Load();
            this.FProcessorHeroRenew.Load();
            return;
         }
         this.FHeroID = 0;
         this.ProcessorHerosBaseAttributeReq();
         this.ProcessorAllHeroEquipmentMountedSuitCount();
         this.ProcessorUseInventory();
         this.FProcessorWindowHeros.Show();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenHeros);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowHeros.Reset();
         this.ProcessorOnWindowExchangeClose(this);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseHeros);
      }
      
      public function UpdateAllHeroEquipmentMountedSuitCount() : void
      {
         this.ProcessorAllHeroEquipmentMountedSuitCount();
      }
      
      public function UpdateCharacterBaseAttributeRet() : void
      {
         if(this.Visible)
         {
            if(this.FProcessorWindowHeros != null && this.FProcessorWindowHeros.Visible)
            {
               this.FProcessorWindowHeros.Update();
            }
         }
         if(this.FOldHero != null)
         {
            if(this.FIsShowOldHero)
            {
               this.ShowAttributeDifference(this.FOldHero);
            }
            this.FOldHero = null;
         }
      }
      
      public function UpdateMainHeroSkill() : void
      {
         if(this.FProcessorWindowHeros != null && this.FProcessorWindowHeros.Visible)
         {
            this.FProcessorWindowHeros.Update();
         }
      }
      
      public function ProcessorOnMountTalisman(param1:Object, param2:uint, param3:Object) : void
      {
         this.Perform_CS_MountEquipment(param1,param2,param3);
      }
      
      public function ProcessorOnDismountTalisman(param1:Object, param2:uint, param3:uint, param4:uint) : void
      {
         this.Perform_CS_DismountEquipment(param1,param2,param3,param4);
      }
      
      public function InitHeroBaseAttributeReq(param1:uint) : void
      {
         this.ProcessorHeroBaseAttributeReq(param1);
      }
      
      public function UpdateHeroBaseAttributeReq(param1:uint, param2:Boolean = true) : void
      {
         this.FIsShowOldHero = param2;
         this.ProcessorHeroBaseAttributeReq(param1);
         this.FOldHero = this.FCharacter.Heros.GetHeroByIdentifier(param1);
         this.RecordOldBaseAttribute(this.FOldHero);
         if(this.FUnstreamizerReference != null)
         {
            this.FUnstreamizerReference.UnstreamizeWakeAttributes(this.FWakeAttribute,this.FOldHero);
         }
      }
      
      public function UpdateHerosBaseAttributeReq() : void
      {
         this.ProcessorHerosBaseAttributeReq();
      }
      
      public function UserUpdateCharBaseInfo() : void
      {
         if(this.FProcessorWindowHeros != null && this.FProcessorWindowHeros.Visible)
         {
            this.FProcessorWindowHeros.Update();
         }
      }
      
      public function UpdateCharacterInventory() : void
      {
         if(this.FProcessorWindowHeros != null && this.FProcessorWindowHeros.Visible)
         {
            this.FProcessorWindowHeros.Update();
         }
      }
      
      public function UpdateOrganizationData(param1:Object, param2:Boolean = true) : void
      {
         this.FProcessorWindowHeros.UpdateOrganizationData(param1,param2);
      }
   }
}

