package Processors.Game.Lobby.Smithy
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Smithy.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.Smithy.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Inventories.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorSmithy extends TProcessorLobbyWindows
   {
      
      protected static const BuyStoneSuccess:String = "获得保护石";
      
      protected static const FlushSpiritSuccess:String = "注灵成功";
      
      protected static const FlushSpiritFailed:String = "注灵失败";
      
      protected static const UIWIDTH:int = 628;
      
      protected static const UIHEIGHT:int = 453;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const INDEXEQUIPMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXEQUIPMENTMOUNTED;
      
      protected var FCharacter:TCharacter;
      
      protected var FUtilityInventory:TUtilityInventory;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FProcessorWindowSmithy:TProcessorWindowSmithy;
      
      protected var FBoundsSmithy:TBounds;
      
      protected var FSmithyRefinedPakcetUnstreamizerData:TSmithyRefinedPakcetUnstreamizerData;
      
      protected var FUnstreamizerStrengthenAttribute:TUnstreamizerStrengthenAttribute;
      
      protected var FClearTimeWating:Boolean;
      
      protected var FWindowWaitToOpen:int;
      
      public function TProcessorSmithy(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FUtilityInventory = new TUtilityInventory();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.FProcessorWindowSmithy = new TProcessorWindowSmithy(this);
         this.FProcessorWindowSmithy.OnClose = this.ProcessorWindowJadeOnClose;
         this.FProcessorWindowSmithy.UIComponentsHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSmithy.UIComponentsHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSmithy.ClearTime = this.PerformPacket_CS_ClearTime;
         this.FProcessorWindowSmithy.UIComponentsBtnOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSmithy.UIComponentsBtnOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSmithy.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSmithy.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSmithy.EquipmentAdvanced = this.EquipmentAdvanced;
         this.FProcessorWindowSmithy.EquipmentGetSkill = this.PerformPacket_CS_GetSkill;
         this.FProcessorWindowSmithy.OnEffectText = ProcessorsOnEffectText;
         this.FBoundsSmithy = new TBounds();
         this.FBoundsSmithy.Width = UIWIDTH;
         this.FBoundsSmithy.Height = UIHEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowSmithy,this.FBoundsSmithy);
         this.FBoundsSmithy = null;
         this.FSmithyRefinedPakcetUnstreamizerData = new TSmithyRefinedPakcetUnstreamizerData(10);
         this.FUnstreamizerStrengthenAttribute = new TUnstreamizerStrengthenAttribute();
      }
      
      public static function GetStrengthValue(param1:TEquipment, param2:int = 0) : int
      {
         var _loc3_:TArticle = null;
         var _loc4_:int = 0;
         var _loc5_:TBuildValue = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.IDTemplate) as TArticle;
         _loc4_ = _loc3_.MinorType * 10000 + _loc3_.Quality * 1000 + param1.UpgradingLevel + param2;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildValue,_loc4_) as TBuildValue;
         if(_loc5_ == null)
         {
            return 0;
         }
         return _loc5_.Value;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SMITHY.RESOURCESID_SMITHY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VERSION_PALYER_LEVEL) as TConfigValue;
         CONST_SMITHY.StrengthenMaxLevel = _loc1_.Value as int;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FProcessorWindowSmithy.OnInheritNetwork = this.PerformPacket_CS_Inherited;
         this.FProcessorWindowSmithy.RefinedNetwork = this.PerformPacket_CS_Refined;
         this.FProcessorWindowSmithy.RefinedExchange = this.PerformPacket_CS_RefinedExchange;
         this.FProcessorWindowSmithy.StrengthenNetWork = this.PerformPacket_CS_Strengthen;
         this.FProcessorWindowSmithy.PunchNetWork = this.PerformPacket_CS_Punch;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SmithyStrengthenResponse,this.PerformPacket_SC_Strengthen);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SmithyRefinedResponse,this.PerformPacket_SC_Refined);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SmithyInheritResponse,this.PerformPacket_SC_Inherited);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SmithyRefinedConfirmResponse,this.PerformPacket_SC_RefinedExchange);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SmithyStrengthClearTime,this.PerformPacket_SC_ClearTime);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Equip_Advanced,this.PerformPacket_SC_Equip_Advanced);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Equip_GetSkill,this.PerformPacket_SC_Equip_GetSkill);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FlushSpirit_Ret,this.PerformPacket_SC_FlushSpiritInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FlushSpiritBuyStone_Ret,this.PerformPacket_SC_FlushSpiritBuyStone);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FlushSpiritFlush_Ret,this.PerformPacket_SC_FlushSpiritFlush);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Punch_Ret,this.PerformPacket_SC_Punch);
      }
      
      protected function PerformPacket_SC_FlushSpiritInforRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         _loc4_ = param1.Data;
         _loc2_ = _loc4_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = _loc4_.readUnsignedInt();
         this.FProcessorWindowSmithy.ProtecedStoneFlag = _loc3_;
      }
      
      protected function PerformPacket_SC_FlushSpiritBuyStone(param1:TPacket) : void
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
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_69));
         _loc4_ = _loc3_.readUnsignedInt();
         this.FProcessorWindowSmithy.ProtecedStoneFlag = _loc4_;
         this.FProcessorWindowSmithy.BuyStoneRet();
      }
      
      protected function PerformPacket_SC_FlushSpiritFlush(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         var _loc7_:int = 0;
         var _loc8_:THero = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ == CONST_SMITHY.FlushSpiritSuccessFailed)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_71));
         }
         else
         {
            _loc4_ = _loc3_.readUnsignedInt();
            if(_loc4_ != 0)
            {
               this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
               _loc5_ = this.FInventoryReference.Inventory as TEquipment;
               _loc7_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc5_.CategorySecond);
               _loc8_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
               _loc6_ = _loc8_.EquipmentsMounted.GetInventoryByIndex(_loc7_) as TEquipment;
               this.FUtilityInventory.EquipmentAssign(_loc5_,_loc6_);
               this.FInventoryReference.Inventory = null;
            }
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_70));
         }
         if(Visible)
         {
            this.FProcessorWindowSmithy.Update();
         }
      }
      
      protected function PerformPacket_SC_Strengthen(param1:TPacket) : void
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
         this.FProcessorWindowSmithy.ResultCode = _loc3_;
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowSmithy.StrengthenLevel = _loc2_.readUnsignedShort();
         _loc4_ = _loc2_.readUnsignedInt() - STimingCore.ServerTick;
         this.FProcessorWindowSmithy.StrengthenCDTime = _loc4_ < 0 ? 0 : uint(_loc4_);
         SLogicsCore.Character.IfArriveLimitTime = _loc2_.readUnsignedByte() == 1;
         _loc5_ = _loc2_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            this.FUnstreamizerReference.Unstreamize(_loc2_,this.FInventoryReference,null);
            _loc8_ = this.FInventoryReference.Inventory as TEquipment;
            _loc7_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc8_.CategorySecond);
            _loc6_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc5_);
            _loc9_ = _loc6_.EquipmentsMounted.GetInventoryByIndex(_loc7_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc8_,_loc9_);
            this.FInventoryReference.Inventory = null;
         }
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_CS_Strengthen(param1:Object, param2:uint, param3:TEquipment, param4:Vector.<int>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPacket = null;
         var _loc8_:ByteArray = null;
         var _loc9_:uint = 0;
         _loc7_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyStrengthenRequest);
         _loc8_ = _loc7_.Data;
         if(param2 == 0)
         {
            _loc9_ = param3.Identifier;
         }
         else
         {
            _loc9_ = param3.CategorySecond;
         }
         _loc8_.writeUnsignedInt(param2);
         _loc8_.writeUnsignedInt(_loc9_);
         _loc8_.writeUnsignedInt(param3.IDTemplate);
         _loc6_ = int(param4.length);
         _loc7_.Data.writeShort(_loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_.writeByte(param4[_loc5_]);
            _loc5_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc7_);
      }
      
      protected function PerformPacket_CS_Punch(param1:Object, param2:TEquipment, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Punch_Req);
         _loc7_ = _loc6_.Data;
         if(param3 == 0)
         {
            _loc8_ = param2.Identifier;
         }
         else
         {
            _loc8_ = param2.CategorySecond;
         }
         _loc7_.writeUnsignedInt(param3);
         _loc7_.writeUnsignedInt(param2.IDTemplate);
         _loc7_.writeUnsignedInt(_loc8_);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function PerformPacket_SC_Punch(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         var _loc7_:int = 0;
         var _loc8_:THero = null;
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
            _loc5_ = this.FInventoryReference.Inventory as TEquipment;
            _loc7_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc5_.CategorySecond);
            _loc8_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc6_ = _loc8_.EquipmentsMounted.GetInventoryByIndex(_loc7_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc5_,_loc6_);
            this.FInventoryReference.Inventory = null;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_59));
         if(Visible)
         {
            this.FProcessorWindowSmithy.Update();
         }
      }
      
      protected function PerformPacket_CS_InitInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyRequestColdTime);
         _loc1_.Data.writeShort(1);
         _loc1_.Data.writeByte(6);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FlushSpirit_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_SC_Refined(param1:TPacket) : void
      {
         this.FUnstreamizerStrengthenAttribute.UnstreamizeStrengthenAttributes(param1.Data,this.FSmithyRefinedPakcetUnstreamizerData,null);
         this.FProcessorWindowSmithy.ResultCode = this.FSmithyRefinedPakcetUnstreamizerData.ResultCode;
         this.FProcessorWindowSmithy.CurrentSmithyAttributeList = this.FSmithyRefinedPakcetUnstreamizerData;
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_CS_Refined(param1:Object, param2:uint, param3:TEquipment, param4:int, param5:int) : void
      {
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyRefinedRequest);
         _loc7_ = _loc6_.Data;
         if(param2 == 0)
         {
            _loc8_ = param3.Identifier;
         }
         else
         {
            _loc8_ = param3.CategorySecond;
         }
         _loc7_.writeUnsignedInt(param2);
         _loc7_.writeUnsignedInt(_loc8_);
         _loc7_.writeUnsignedInt(param3.IDTemplate);
         _loc7_.writeByte(param4);
         _loc7_.writeByte(param5);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function PerformPacket_SC_RefinedExchange(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         var _loc7_:TEquipment = null;
         var _loc8_:TEquipment = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         this.FProcessorWindowSmithy.ResultCode = _loc2_;
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
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_SC_ClearTime(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         this.FProcessorWindowSmithy.ResultCode = _loc2_;
         if(_loc2_ == 0)
         {
            if(this.FClearTimeWating)
            {
               this.FProcessorWindowSmithy.Update();
            }
            SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Strengthen).TimingTime = 0;
         }
         this.FClearTimeWating = false;
      }
      
      protected function PerformPacket_SC_Equip_Advanced(param1:TPacket) : void
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
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_34));
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_SC_Equip_GetSkill(param1:TPacket) : void
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
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_33));
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_CS_ClearTime() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyStrengthClearTime);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FClearTimeWating = true;
      }
      
      protected function PerformPacket_CS_RefinedExchange(param1:Object, param2:uint, param3:TEquipment, param4:int) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyRefinedConfirmRequest);
         _loc6_ = _loc5_.Data;
         if(param2 == 0)
         {
            _loc7_ = param3.Identifier;
         }
         else
         {
            _loc7_ = param3.CategorySecond;
         }
         _loc6_.writeUnsignedInt(param2);
         _loc6_.writeUnsignedInt(_loc7_);
         _loc6_.writeUnsignedInt(param3.IDTemplate);
         _loc6_.writeShort(param4);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function PerformPacket_SC_Inherited(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         var _loc7_:TEquipment = null;
         var _loc8_:TEquipment = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         this.FProcessorWindowSmithy.ResultCode = _loc2_;
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
            _loc6_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc7_.CategorySecond);
            _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
            _loc8_ = _loc5_.EquipmentsMounted.GetInventoryByIndex(_loc6_) as TEquipment;
            this.FUtilityInventory.EquipmentAssign(_loc7_,_loc8_);
            this.FInventoryReference.Inventory = null;
         }
         else
         {
            this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
            this.FInventoryReference.Inventory = null;
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
         this.FProcessorWindowSmithy.Update();
      }
      
      protected function PerformPacket_CS_Inherited(param1:Object, param2:uint, param3:TEquipment, param4:uint, param5:TEquipment, param6:int) : void
      {
         var _loc7_:TPacket = null;
         var _loc8_:ByteArray = null;
         var _loc9_:uint = 0;
         _loc7_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyInheritRequest);
         _loc8_ = _loc7_.Data;
         if(param2 == 0)
         {
            _loc9_ = param3.Identifier;
         }
         else
         {
            _loc9_ = param3.CategorySecond;
         }
         _loc8_.writeUnsignedInt(param2);
         _loc8_.writeUnsignedInt(_loc9_);
         _loc8_.writeUnsignedInt(param3.IDTemplate);
         if(param4 == 0)
         {
            _loc9_ = param5.Identifier;
         }
         else
         {
            _loc9_ = param5.CategorySecond;
         }
         _loc8_.writeUnsignedInt(param4);
         _loc8_.writeUnsignedInt(_loc9_);
         _loc8_.writeUnsignedInt(param5.IDTemplate);
         _loc8_.writeByte(param6);
         SNetworkCore.Transceiver.PacketTransmit(_loc7_);
      }
      
      private function PerformPacket_CS_GetSkill(param1:Object, param2:uint, param3:TEquipment, param4:TInventory) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Equip_GetSkill);
         _loc6_ = _loc5_.Data;
         if(param2 == 0)
         {
            _loc7_ = param3.Identifier;
         }
         else
         {
            _loc7_ = param3.CategorySecond;
         }
         _loc6_.writeUnsignedInt(param2);
         _loc6_.writeUnsignedInt(_loc7_);
         _loc6_.writeUnsignedInt(param3.IDTemplate);
         _loc6_.writeUnsignedInt(param4.Identifier);
         _loc6_.writeUnsignedInt(param4.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function PerformPacket_CS_EquipAdvancedRequest(param1:uint, param2:TEquipment) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Equip_Advanced);
         _loc4_ = _loc3_.Data;
         if(param1 == 0)
         {
            _loc5_ = param2.Identifier;
         }
         else
         {
            _loc5_ = param2.CategorySecond;
         }
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(_loc5_);
         _loc4_.writeUnsignedInt(param2.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_Strengthen);
         }
      }
      
      private function InitStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         this.FWindowWaitToOpen = 0;
         if(param1.length == 0)
         {
            return;
         }
         _loc2_ = uint(param1.readInt());
         this.FWindowWaitToOpen = _loc2_;
      }
      
      protected function ProcessorWindowJadeOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      private function EquipmentAdvanced(param1:Object, param2:uint, param3:TEquipment) : void
      {
         this.PerformPacket_CS_EquipAdvancedRequest(param2,param3);
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         super.OnEffectText = param1;
         this.FProcessorWindowSmithy.OnEffectText = param1;
      }
      
      public function get ProcessorWindowSmithy() : TProcessorWindowSmithy
      {
         return this.FProcessorWindowSmithy;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FProcessorWindowSmithy.UpdateHeroPower = param1;
      }
      
      public function set UpdateHerosPower(param1:Function) : void
      {
         this.FProcessorWindowSmithy.UpdateHerosPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.InitStream(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowSmithy.Load();
            return;
         }
         this.PerformPacket_CS_InitInfor();
         this.FProcessorWindowSmithy.visible = true;
         this.FProcessorWindowSmithy.OpenTabManual(this.FWindowWaitToOpen);
         this.FProcessorWindowSmithy.Update();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenStrengthen);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowSmithy.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseStrengthen);
      }
      
      public function UpdateCDTime() : void
      {
         this.PerformPacket_CS_InitInfor();
      }
   }
}

