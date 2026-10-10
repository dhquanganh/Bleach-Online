package Processors.Game.Lobby.CrashJade
{
   import Components.Controls.*;
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.CrashJade.TCrashJadeData;
   import Logics.Inventories.TCrashJade;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Log.TLog;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SLogicsCore;
   import Logics.Streamization.CrashJade.TUnstreamizerCrashJadeData;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CRASHJADE;
   import Resources.Constants.CONST_LOG;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorCrashJade extends TProcessorLobbyPlate
   {
      
      protected static const AttributeFormat:String = "%0 +%1";
      
      protected static const UnloadEquipFormat:String = "%0 -%1";
      
      protected var WINDOW_WIDTH:int = 694;
      
      protected var WINDOW_HEIGHT:int = 441;
      
      protected var FProcessorWindowMakeJade:TProcessorWindowMakeJade;
      
      protected var FProcessorWindowEquipJade:TProcessorWindowEquipJade;
      
      protected var FProcessoeCrashJadeShop:TProcessoeCrashJadeShop;
      
      protected var FBounds:TBounds;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      protected var FUnstreamizerCrashJade:TUnstreamizerCrashJadeData;
      
      protected var FCharacter:TCharacter;
      
      protected var FLayerMask:Sprite;
      
      protected var FOnReturnMainScene:Function;
      
      protected var FOnLoadLog:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorCrashJade(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         this.FCrashJadeData = new TCrashJadeData();
         this.FUnstreamizerCrashJade = new TUnstreamizerCrashJadeData();
         this.FProcessorWindowMakeJade = new TProcessorWindowMakeJade(this);
         this.FProcessorWindowMakeJade.CrashJadeData = this.FCrashJadeData;
         this.FProcessorWindowMakeJade.OnEquipJade = this.JmpToWindowEquipJade;
         this.FProcessorWindowMakeJade.OnClose = this.CloseWindows;
         this.FProcessorWindowMakeJade.OnShop = this.OnShop;
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FProcessorWindowEquipJade = new TProcessorWindowEquipJade(this);
         this.FProcessorWindowEquipJade.CrashJadeData = this.FCrashJadeData;
         this.FProcessorWindowEquipJade.OnClose = this.CancleMask;
         this.FProcessoeCrashJadeShop = new TProcessoeCrashJadeShop(this);
         this.FProcessoeCrashJadeShop.Data = this.FCrashJadeData;
         this.FProcessoeCrashJadeShop.Visible = false;
         this.FProcessoeCrashJadeShop.OnExchange = this.ProcessorOnExchange;
         this.FProcessoeCrashJadeShop.ParentUIUpdate = this.UpdateMakeJade;
         this.FBounds = new TBounds();
         this.FBounds.Width = this.WINDOW_WIDTH;
         this.FBounds.Height = this.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowEquipJade,this.FBounds);
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function SellOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TInventories = null;
         _loc6_ = SLogicsCore.Character.CrashJadeTemporary;
         _loc4_ = _loc6_.Count;
         _loc2_ = new TPacket(0);
         _loc2_.Data.writeUnsignedInt(0);
         _loc2_.Data.writeShort(0);
         _loc2_.Data.writeUnsignedInt(0);
         _loc2_.Data.writeUnsignedInt(200);
         _loc2_.Data.writeShort(13);
         _loc3_ = 13;
         while(_loc3_ < 26)
         {
            _loc5_ = _loc6_.GetInventoryByIndex(_loc3_);
            _loc2_.Data.writeUnsignedInt(_loc5_.Identifier0);
            _loc2_.Data.writeUnsignedInt(_loc5_.Identifier1);
            _loc3_++;
         }
         _loc2_.Data.position = 0;
         this.PacketPerform_SC_PickUpOneKeyRet(_loc2_);
      }
      
      protected function TestOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         _loc2_ = new TPacket(0);
         _loc2_.Data.writeUnsignedInt(0);
         _loc2_.Data.writeUnsignedInt(90);
         _loc2_.Data.writeByte(0);
         _loc2_.Data.writeUnsignedInt(10);
         _loc2_.Data.writeShort(39);
         _loc3_ = 0;
         while(_loc3_ < 39)
         {
            _loc2_.Data.writeByte(0);
            _loc2_.Data.writeUnsignedInt(_loc3_);
            _loc2_.Data.writeUnsignedInt(10);
            _loc2_.Data.writeUnsignedInt(14500907);
            _loc2_.Data.writeUnsignedInt(10);
            _loc3_++;
         }
         _loc2_.Data.position = 0;
         this.PacketPerform_SC_MakeJadeOneKeyRet(_loc2_);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_CRASHJADE.ResourceID_CrashJade);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FUnstreamizerCrashJade.UnstreamizationPerform_FillShop(null,this.FCrashJadeData,null);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_InforRet,this.PacketPerform_SC_InforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_BuyTimeRet,this.PacketPerform_SC_BuyTimeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_SwallowPelletRet,this.PacketPerform_SC_SwallowPelletRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_MakeJadeRet,this.PacketPerform_SC_MakeJadeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_MakeJadeOneKeyRet,this.PacketPerform_SC_MakeJadeOneKeyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_PickUpRet,this.PacketPerform_SC_PickUpRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_PickUpOneKeyRet,this.PacketPerform_SC_PickUpOneKeyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_SellRet,this.PacketPerform_SC_SellRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_SellOneKeyRet,this.PacketPerform_SC_SellOneKeyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_OpenHighLevelRet,this.PacketPerform_SC_OpenHighLevelRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_UnlockSlotRet,this.PacketPerform_SC_UnlockSlotRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_SwallowRet,this.PacketPerform_SC_CrashJade_SwallowRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_ComposeRet,this.PacketPerform_SC_CrashJade_ComposeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_EquipJadeRet,this.PacketPerform_SC_CrashJade_EquipJadeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_InitBackPackRet,this.PacketPerform_SC_InitBackPackRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_UnloadJadeRet,this.PacketPerform_SC_UnloadJadeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_ShopInfoRet,this.PacketPerform_SC_ShopInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CrashJade_ShopBuyRet,this.PacketPerform_SC_ShopBuyRet);
      }
      
      protected function PacketPerform_SC_InforRet(param1:TPacket) : void
      {
         this.FCharacter.CrashJadeTemporary.Clear();
         this.FUnstreamizerCrashJade.UnstreamizationPerform_BaseInfor(param1.Data,this.FCrashJadeData,this.FCharacter.CrashJadeTemporary);
         this.FCrashJadeData.Inited = true;
         if(FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMakeJade.Visible = true;
            this.FProcessorWindowMakeJade.Update();
         }
      }
      
      protected function PacketPerform_SC_BuyTimeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FCrashJadeData.BuyTime = param1.Data.readUnsignedInt();
         this.FProcessorWindowMakeJade.UpdateLastTime();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_02));
      }
      
      protected function PacketPerform_SC_SwallowPelletRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:ByteArray = null;
         var _loc10_:TCrashJade = null;
         var _loc11_:THero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc9_ = param1.Data;
         _loc3_ = _loc9_.readUnsignedInt();
         _loc4_ = _loc9_.readUnsignedInt();
         _loc5_ = _loc9_.readUnsignedInt();
         _loc6_ = _loc9_.readUnsignedInt();
         _loc7_ = _loc9_.readUnsignedInt();
         this.FCrashJadeData.ExperiencePelletNum = _loc9_.readUnsignedInt();
         if(_loc7_ != 0)
         {
            _loc11_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc7_);
            _loc10_ = this.FindJadeFormHero(_loc11_,_loc3_,_loc4_) as TCrashJade;
         }
         else
         {
            _loc10_ = this.FCharacter.CrashJade.GetInventoryByLongIdentifier(_loc3_,_loc4_) as TCrashJade;
         }
         _loc10_.IDTemplate = _loc5_;
         _loc10_.Exp = _loc6_;
         this.FUnstreamizerCrashJade.UnstreamizationPerform_AdditionalData_CrashJade(null,_loc10_,null);
         this.FProcessorWindowEquipJade.SwallowPelletNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_03));
      }
      
      protected function PacketPerform_SC_MakeJadeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerCrashJade.UnstreamizationPerform_MakeJade(param1.Data,this.FCrashJadeData,this.FCharacter.CrashJadeTemporary);
         this.FProcessorWindowMakeJade.UpdateMakeJadeSingle();
         if(this.FCrashJadeData.IfGetChip)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_32));
         }
         if(this.FCrashJadeData.IfGetShopCoin)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_44));
         }
         this.FCrashJadeData.IfGetShopCoin = false;
         this.FCrashJadeData.IfGetChip = false;
      }
      
      protected function PacketPerform_SC_MakeJadeOneKeyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerCrashJade.UnstreamizationPerform_MakeJade(param1.Data,this.FCrashJadeData,this.FCharacter.CrashJadeTemporary);
         this.FProcessorWindowMakeJade.UpdateMakeJadeOneKey();
         if(this.FCrashJadeData.IfGetChip)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_32));
         }
         if(this.FCrashJadeData.IfGetShopCoin)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_44));
         }
         this.FCrashJadeData.IfGetChip = false;
         this.FCrashJadeData.IfGetShopCoin = false;
      }
      
      protected function PacketPerform_SC_PickUpRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventory = null;
         this.PacketPerform_SC_PickUpOneKeyRet(param1);
      }
      
      protected function PacketPerform_SC_PickUpOneKeyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TInventory = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FCrashJadeData.IDHigh.length = 0;
         this.FCrashJadeData.IDLow.length = 0;
         _loc6_ = int(param1.Data.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = param1.Data.readUnsignedInt();
            _loc4_ = param1.Data.readUnsignedInt();
            this.FCrashJadeData.IDHigh.push(_loc3_);
            this.FCrashJadeData.IDLow.push(_loc4_);
            _loc7_ = this.FCharacter.CrashJadeTemporary.GetInventoryByLongIdentifier(_loc3_,_loc4_);
            this.FCharacter.CrashJade.Add(_loc7_);
            _loc5_++;
         }
         this.FProcessorWindowMakeJade.UpdatePickUp();
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FCharacter.CrashJadeTemporary.DeleteInventoryByLongIdentifier(this.FCrashJadeData.IDHigh[_loc5_],this.FCrashJadeData.IDLow[_loc5_]);
            _loc5_++;
         }
      }
      
      protected function PacketPerform_SC_SellRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         this.FCharacter.CrashJadeTemporary.DeleteInventoryByLongIdentifier(_loc3_,_loc4_);
         SToolReward.ShowReward(param1.Data,false);
         this.FProcessorWindowMakeJade.Update();
      }
      
      protected function PacketPerform_SC_SellOneKeyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowReward(param1.Data,false);
         _loc6_ = int(param1.Data.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = param1.Data.readUnsignedInt();
            _loc4_ = param1.Data.readUnsignedInt();
            this.FCharacter.CrashJadeTemporary.DeleteInventoryByLongIdentifier(_loc3_,_loc4_);
            _loc5_++;
         }
         this.FProcessorWindowMakeJade.UpdateSellJade();
      }
      
      protected function PacketPerform_SC_OpenHighLevelRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FCrashJadeData.MakeJadeFlag = param1.Data.readUnsignedByte();
         this.FCrashJadeData.HightLevelMakeJadeTime = param1.Data.readUnsignedInt();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_02));
         _loc3_ = this.FCrashJadeData.ShopCoinCount;
         this.FCrashJadeData.ShopCoinCount = param1.Data.readUnsignedInt();
         _loc4_ = this.FCrashJadeData.ChipNum;
         this.FCrashJadeData.ChipNum = param1.Data.readUnsignedInt();
         if(this.FCrashJadeData.ChipNum > _loc4_)
         {
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_48),this.FCrashJadeData.ChipNum - _loc4_));
         }
         if(this.FCrashJadeData.ShopCoinCount > _loc3_)
         {
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_47),this.FCrashJadeData.ShopCoinCount - _loc3_));
         }
         this.FProcessorWindowMakeJade.UpdateDirectOpen();
      }
      
      protected function PacketPerform_SC_UnlockSlotRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FCrashJadeData.CurrentSlotNum = param1.Data.readUnsignedInt();
         this.FProcessorWindowEquipJade.UnlockSlotNotify();
         this.FProcessorWindowMakeJade.UnlockSlotNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_04));
      }
      
      protected function PacketPerform_SC_CrashJade_SwallowRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:TCrashJade = null;
         var _loc12_:THero = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc7_ = _loc3_.readUnsignedInt();
         _loc8_ = _loc3_.readUnsignedInt();
         _loc10_ = _loc3_.readUnsignedInt();
         _loc9_ = _loc3_.readUnsignedInt();
         _loc6_ = _loc3_.readUnsignedInt();
         if(_loc6_ == 0)
         {
            _loc11_ = this.FCharacter.CrashJade.GetInventoryByLongIdentifier(_loc7_,_loc8_) as TCrashJade;
         }
         else
         {
            _loc12_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc6_);
            _loc11_ = this.FindJadeFormHero(_loc12_,_loc7_,_loc8_) as TCrashJade;
         }
         _loc11_.IDTemplate = _loc10_;
         this.FUnstreamizerCrashJade.UnstreamizationPerform_AdditionalData_CrashJade(null,_loc11_,null);
         _loc11_.Exp = _loc9_;
         this.FCrashJadeData.IDHigh.length = 0;
         this.FCrashJadeData.IDLow.length = 0;
         this.FCrashJadeData.HeroID.length = 0;
         _loc5_ = int(_loc3_.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FCrashJadeData.IDHigh.push(_loc3_.readUnsignedInt());
            this.FCrashJadeData.IDLow.push(_loc3_.readUnsignedInt());
            this.FCrashJadeData.HeroID.push(_loc3_.readUnsignedInt());
            _loc4_++;
         }
         this.DeleteJadeByHeroID(this.FCrashJadeData.IDHigh,this.FCrashJadeData.IDLow,this.FCrashJadeData.HeroID);
         this.FProcessorWindowEquipJade.SwallowNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_03));
         if(_loc6_ != 0)
         {
            this.FUpdateHeroPower(this,_loc6_);
         }
      }
      
      protected function PacketPerform_SC_CrashJade_ComposeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FCrashJadeData.ChipNum = param1.Data.readUnsignedInt();
         this.FCrashJadeData.ExperiencePelletNum = param1.Data.readUnsignedInt();
         this.FProcessorWindowEquipJade.ComposeNotify();
         this.FProcessorWindowMakeJade.ComposeNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_01));
      }
      
      protected function PacketPerform_SC_CrashJade_EquipJadeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TCrashJade = null;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc8_ = _loc3_.readUnsignedInt();
         _loc9_ = _loc3_.readUnsignedByte() - 1;
         _loc6_ = _loc3_.readUnsignedInt();
         _loc7_ = _loc3_.readUnsignedInt();
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc8_);
         _loc4_ = SLogicsCore.Character.CrashJade.DeleteInventoryByLongIdentifier(_loc6_,_loc7_) as TCrashJade;
         _loc4_.MountedHeroID = _loc8_;
         _loc5_.CrashJadeMounted.SetInventoryByIndex(_loc9_,_loc4_);
         this.FProcessorWindowEquipJade.EquipJadeNotify();
         _loc11_ = _loc4_.AddAttributeType.length;
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            EffectGenerateText(TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(_loc4_.AddAttributeType[_loc10_]),_loc4_.AddAttributeValue[_loc10_] <= 1 ? Number(_loc4_.AddAttributeValue[_loc10_] * 100).toFixed(2) + "%" : _loc4_.AddAttributeValue[_loc10_]));
            _loc10_++;
         }
         if(_loc8_ != 0)
         {
            this.FUpdateHeroPower(this,_loc8_);
         }
      }
      
      protected function PacketPerform_SC_InitBackPackRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SLogicsCore.Character.CrashJade.Clear();
         this.FUnstreamizerCrashJade.UnstreamizationPerform_BackPack(param1.Data,this.FCrashJadeData,SLogicsCore.Character.CrashJade);
         this.FProcessorWindowEquipJade.Update();
         this.FProcessorWindowEquipJade.Visible = true;
         this.FLayerMask.visible = true;
      }
      
      protected function PacketPerform_SC_UnloadJadeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TCrashJade = null;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc6_ = _loc3_.readUnsignedInt();
         _loc7_ = _loc3_.readUnsignedByte() - 1;
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc6_);
         _loc4_ = _loc5_.CrashJadeMounted.GetInventoryByIndex(_loc7_) as TCrashJade;
         _loc5_.CrashJadeMounted.SetInventoryByIndex(_loc7_,null);
         _loc4_.MountedHeroID = 0;
         SLogicsCore.Character.CrashJade.Add(_loc4_);
         this.FProcessorWindowEquipJade.UnloadJadeNotify();
         _loc9_ = _loc4_.AddAttributeType.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            EffectGenerateText(TUtilityString.Format(UnloadEquipFormat,TUtilityLobby.GetAttributeName(_loc4_.AddAttributeType[_loc8_]),_loc4_.AddAttributeValue[_loc8_] <= 1 ? Number(_loc4_.AddAttributeValue[_loc8_] * 100).toFixed(2) + "%" : _loc4_.AddAttributeValue[_loc8_]));
            _loc8_++;
         }
         if(_loc6_ != 0)
         {
            this.FUpdateHeroPower(this,_loc6_);
         }
      }
      
      protected function PacketPerform_SC_ShopInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         this.FCrashJadeData.ShopInited = true;
         this.FUnstreamizerCrashJade.UnstreamizationPerform_ShopInfo(_loc3_,this.FCrashJadeData,null);
         this.FProcessoeCrashJadeShop.Visible = true;
      }
      
      protected function PacketPerform_SC_ShopBuyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerCrashJade.UnstreamizationPerform_ShopBuy(_loc3_,this.FCrashJadeData,null);
      }
      
      protected function RequstBaseInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_InforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function RequestBackPack() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_InitBackPackReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function LoadLog() : void
      {
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_CrashJade,this.LogArrive);
         }
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.FProcessorWindowMakeJade.UpdateLog(param1);
      }
      
      protected function FindJadeFormHero(param1:THero, param2:uint, param3:uint) : TInventory
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         _loc5_ = param1.CrashJadeMounted.Capacity;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.CrashJadeMounted.GetInventoryByIndex(_loc4_);
            if(_loc6_ != null)
            {
               if(_loc6_.Identifier0 == param2 && _loc6_.Identifier1 == param3)
               {
                  return _loc6_;
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      protected function DeleteJadeFormHero(param1:THero, param2:uint, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         _loc5_ = param1.CrashJadeMounted.Capacity;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.CrashJadeMounted.GetInventoryByIndex(_loc4_);
            if(_loc6_ != null)
            {
               if(_loc6_.Identifier0 == param2 && _loc6_.Identifier1 == param3)
               {
                  param1.CrashJadeMounted.SetInventoryByIndex(_loc4_,null);
                  return;
               }
            }
            _loc4_++;
         }
      }
      
      protected function DeleteJadeByHeroID(param1:Vector.<uint>, param2:Vector.<uint>, param3:Vector.<uint>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THero = null;
         _loc4_ = int(param1.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = int(param3[_loc5_]);
            if(_loc6_ != 0)
            {
               _loc7_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc6_);
               this.DeleteJadeFormHero(_loc7_,param1[_loc5_],param2[_loc5_]);
            }
            else
            {
               this.FCharacter.CrashJade.DeleteInventoryByLongIdentifier(param1[_loc5_],param2[_loc5_]);
            }
            _loc5_++;
         }
      }
      
      protected function UpdateMakeJade() : void
      {
         this.FProcessorWindowMakeJade.Update();
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      protected function JmpToWindowEquipJade(param1:Object) : void
      {
         if(this.FCrashJadeData.BackPackInited)
         {
            this.FProcessorWindowEquipJade.Update();
            this.FProcessorWindowEquipJade.Visible = true;
            this.FLayerMask.visible = true;
         }
         else
         {
            this.RequestBackPack();
         }
      }
      
      protected function OnShop() : void
      {
         var _loc1_:TPacket = null;
         if(!this.FCrashJadeData.ShopInited)
         {
            _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_ShopInfoReq);
            SNetworkCore.Transceiver.PacketTransmit(_loc1_);
            return;
         }
         this.FProcessoeCrashJadeShop.Visible = true;
      }
      
      protected function CloseWindows(param1:Object) : void
      {
         if(this.FOnReturnMainScene != null)
         {
            this.FOnReturnMainScene(this);
         }
      }
      
      protected function CancleMask(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      public function set OnReturnMainScene(param1:Function) : void
      {
         this.FOnReturnMainScene = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMakeJade.Load();
            this.FProcessorWindowEquipJade.Load();
            this.FProcessoeCrashJadeShop.Load();
            return;
         }
         this.LoadLog();
         this.RequstBaseInfor();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

