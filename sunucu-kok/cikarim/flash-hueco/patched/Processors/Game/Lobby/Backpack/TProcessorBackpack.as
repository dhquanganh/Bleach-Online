package Processors.Game.Lobby.Backpack
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Inventories.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.utils.*;
   
   public class TProcessorBackpack extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowUserAssets_Width:uint = 520;
      
      protected static const SIZE_WindowUserAssets_Height:uint = 494;
      
      protected static const SIZE_WindowSell_X:uint = 520;
      
      protected static const SIZE_WindowSell_Y:uint = 16;
      
      protected static const STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const TYPE_BACKPACK:uint = 0;
      
      protected static const TYPE_TEMP_BACKPACK:uint = 1;
      
      protected static const CAPACITY_INVENTORIES:uint = CONST_COMMON.CAPACITY_INVENTORIES;
      
      protected static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      protected static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      protected static const CATEGORY_WakeEquip:uint = CONST_INVENTORY.CATEGORY_WakeEquip;
      
      protected static const EffectMulti_DelayTicks:int = 2000;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FUnstreamizerInventories:TUnstreamizerInventories;
      
      protected var FPoolInventory:TPoolInventory;
      
      protected var FUtilityInventory:TUtilityInventory;
      
      protected var FProcessorUserAssets:TProcessorWindowUserAssets;
      
      protected var FProcessorWindowSell:TProcessorWindowSell;
      
      protected var FBoundsBackpack:TBounds;
      
      protected var FCharacter:TCharacter;
      
      protected var FEffectTexts:Vector.<String>;
      
      protected var FInit:Boolean;
      
      protected var FStringID:uint;
      
      protected var FSystemLanguage:TSystemLanguage;
      
      protected var FEffDelayReferenceTick:int;
      
      protected var FIsEndPushText:Boolean;
      
      protected var FInventory:TInventory;
      
      protected var FQuantity:uint;
      
      protected var FExperience:uint;
      
      protected var FSilverCoin:uint;
      
      protected var FUIWindowConfirmationSell:TUIWindowConfirmation;
      
      protected var FInventories:TInventories;
      
      protected var FInventoryReveal:TInventory;
      
      protected var FOnUpdateInventories:Function;
      
      protected var FOnQuertInventoryIDReq:Function;
      
      protected var FOnInventoryReveal:Function;
      
      protected var FOnAddPopTips:Function;
      
      public function TProcessorBackpack(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FUnstreamizerInventories = new TUnstreamizerInventories();
         this.FUtilityInventory = new TUtilityInventory();
         this.FProcessorUserAssets = new TProcessorWindowUserAssets(this);
         this.FProcessorUserAssets.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorUserAssets.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorUserAssets.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorUserAssets.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorUserAssets.OnClose = this.ProcessorUserAssetsOnClose;
         this.FProcessorUserAssets.OnButtonSell = this.ProcessorButtonSellOnClick;
         this.FProcessorUserAssets.OnSellInventoryToList = this.ProcessorAddInventoryToSellList;
         this.FProcessorUserAssets.OnSellInventory = this.ProcessorSellOnClick;
         this.FProcessorUserAssets.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorUserAssets.OnQuertInventoryIDReq = this.ProcessorsOnQuertInventoryIDReq;
         this.FProcessorUserAssets.OnUseAppliance = this.ProcessorUseAppliance;
         this.FBoundsBackpack = new TBounds();
         this.FBoundsBackpack.X = this.FProcessorUserAssets.x;
         this.FBoundsBackpack.Y = this.FProcessorUserAssets.y;
         this.FBoundsBackpack.Width = SIZE_WindowUserAssets_Width;
         this.FBoundsBackpack.Height = SIZE_WindowUserAssets_Height;
         ComponentBoundsCenter(this.FProcessorUserAssets,this.FBoundsBackpack);
         this.FBoundsBackpack = null;
         this.FProcessorUserAssets.X -= 100;
         this.FProcessorWindowSell = new TProcessorWindowSell(this);
         this.FProcessorWindowSell.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSell.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSell.OnClose = this.ProcessorCloseOnClick;
         this.FProcessorWindowSell.OnAllSell = this.ProcessorAllSellOnClick;
         this.FProcessorWindowSell.OnInventoryClick = this.ProcessorInventoryClick;
         this.FProcessorWindowSell.X = this.FProcessorUserAssets.X + SIZE_WindowSell_X;
         this.FProcessorWindowSell.Y = this.FProcessorUserAssets.Y + SIZE_WindowSell_Y;
         this.FCharacter = SLogicsCore.Character;
         this.FPoolInventory = SLogicsCore.PoolInventory;
         this.FEffectTexts = new Vector.<String>();
         this.FIsEndPushText = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BACKPACK.RESOURCESID_Swf_Backpack);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         super.ResourcesPerform_UIWait();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUIWindowConfirmationSell = new TUIWindowConfirmation(this.Parent);
         this.FUIWindowConfirmationSell.OnOK = this.WindowConfirmationSellOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationSell);
         this.FUIWindowConfirmationSell.SetCheckBoxUsable(true);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_LoadBagResult,this.PerformPacket_SC_LoadBagResult);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_SendThings,this.PerformPacket_SC_SendThings);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_InventoryNtf,this.PerformPacket_SC_InventoryNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_ReduceThings,this.PerformPacket_SC_ReduceThings);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_InventoryExpire,this.PerformPacket_SC_InventoryExpire);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_UseAppliance,this.PerformPacket_SC_UseAppliance);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_SellItem,this.PerformPacket_SC_SellItem);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Backpack_DepotToBag,this.PerformPacket_SC_DepotToBag);
      }
      
      protected function PerformPacket_SC_LoadBagResult(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedByte();
         if(_loc4_ == CONST_BACKPACK.TYPE_LOADBACKPACK_NORMAL)
         {
            this.FCharacter.Inventories.Clear();
            this.FCharacter.Equipments.Clear();
            this.FCharacter.Ornaments.Clear();
            this.FCharacter.Appliances.Clear();
            this.FCharacter.Gems.Clear();
            this.FCharacter.Treasures.Clear();
            this.FCharacter.WakeEquip.Clear();
            this.FCharacter.Materials.Clear();
            this.FUnstreamizerCharacter.UnstreamizeInventories(_loc2_,this.FCharacter.Inventories,null);
            this.FUnstreamizerCharacter.UnstreamizeClassificationInventories(_loc2_,this.FCharacter,null);
         }
         else if(_loc4_ == CONST_BACKPACK.TYPE_LOADBACKPACK_Temporary)
         {
            this.FCharacter.Inventories.Clear();
            this.FCharacter.TemporaryInventories.Clear();
            this.FUnstreamizerCharacter.UnstreamizeTemporaryInventories(_loc2_,this.FCharacter.TemporaryInventories,null);
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
         }
      }
      
      protected function PerformPacket_SC_SendThings(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedByte();
         _loc4_ = uint(this.FCharacter.Equipments.Count);
         _loc5_ = this.GetKnifeCountByFCategorySecond();
         if(_loc3_ == TYPE_TEMP_BACKPACK)
         {
            this.FUnstreamizerCharacter.UnstreamizeTemporaryInventories(_loc2_,this.FCharacter.TemporaryInventories,null);
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_PacketFull);
            }
         }
         else
         {
            this.FUnstreamizerCharacter.UnstreamizeInventories(_loc2_,this.FCharacter.Inventories,null);
            this.FUnstreamizerCharacter.UnstreamizeClassificationInventories(_loc2_,this.FCharacter,null);
         }
         if(this.FCharacter.Equipments.Count > _loc4_)
         {
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_ObtainedForbearance);
            }
         }
         _loc6_ = this.GetKnifeCountByFCategorySecond();
         if(_loc6_ > _loc5_)
         {
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_KnifeOfKillSoul);
            }
         }
         if(this.FOnUpdateInventories != null)
         {
            this.FOnUpdateInventories(this);
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function GetKnifeCountByFCategorySecond() : uint
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc1_ = SLogicsCore.Character.GetBackpackByIndex(CONST_COMMON.INVENTORIESINDEX_Appliances);
         _loc4_ = uint(_loc1_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc3_);
            if(_loc2_.CategorySecond == CONST_INVENTORY.CATEGORYSECOND_KnifeBook)
            {
               _loc5_++;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      protected function PerformPacket_SC_InventoryNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:ByteArray = null;
         var _loc6_:uint = 0;
         var _loc7_:TInventory = null;
         var _loc8_:TInventories = null;
         _loc5_ = param1.Data;
         _loc6_ = _loc5_.readUnsignedByte();
         _loc8_ = this.FCharacter.Inventories;
         this.FUnstreamizerInventories.Unstreamize(_loc5_,_loc8_,null);
         _loc3_ = _loc8_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = _loc8_.GetInventoryByIndex(_loc2_);
            _loc4_ = this.ProcessorInventoryUpdateByBackpack(_loc6_,_loc7_);
            if(!_loc4_)
            {
               _loc4_ = this.ProcessorInventoryUpdateByEquipmentsMounted(_loc7_);
               if(!_loc4_)
               {
                  _loc4_ = this.ProcessorInventoryUpdateByTalismansMounted(_loc7_);
                  if(!_loc4_)
                  {
                     _loc4_ = this.ProcessorInventoryUpdateByOrnamentsMounted(_loc7_);
                     if(_loc4_)
                     {
                     }
                  }
               }
            }
            if(!_loc4_ && _loc7_.Quantity > 0)
            {
               this.ProcessorInventoryAddByBackpack(_loc6_,_loc7_);
            }
            _loc2_++;
         }
         _loc8_.Clear();
         if(_loc3_ == 0)
         {
            return;
         }
         if(this.FOnUpdateInventories != null)
         {
            this.FOnUpdateInventories(this);
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function PerformPacket_SC_ReduceThings(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TInventories = null;
         var _loc9_:TInventory = null;
         var _loc10_:ByteArray = null;
         var _loc11_:uint = 0;
         _loc10_ = param1.Data;
         _loc11_ = _loc10_.readUnsignedByte();
         _loc3_ = int(_loc10_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc10_.readUnsignedInt();
            _loc5_ = int(CAPACITY_INVENTORIES);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc11_ == TYPE_BACKPACK && _loc4_ < _loc5_ - 1)
               {
                  _loc8_ = this.FCharacter.GetBackpackByIndex(_loc4_);
               }
               else
               {
                  _loc8_ = this.FCharacter.GetBackpackByIndex(_loc5_ - 1);
               }
               _loc9_ = _loc8_.GetInventoryByIdentifier(_loc6_);
               if(_loc9_ != null)
               {
                  _loc8_.DeleteInventoryByIdentifier(_loc6_);
                  break;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         if(this.FOnUpdateInventories != null)
         {
            this.FOnUpdateInventories(this);
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function PerformPacket_SC_InventoryExpire(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TInventories = null;
         var _loc9_:TInventory = null;
         var _loc10_:ByteArray = null;
         _loc10_ = param1.Data;
         _loc3_ = int(_loc10_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc10_.readUnsignedInt();
            _loc7_ = _loc10_.readUnsignedShort();
            _loc5_ = int(CAPACITY_INVENTORIES);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc8_ = this.FCharacter.GetBackpackByIndex(_loc4_);
               _loc9_ = _loc8_.GetInventoryByIdentifier(_loc6_);
               if(_loc9_ != null)
               {
                  _loc8_.DeleteInventoryByIdentifier(_loc6_);
                  break;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function PerformPacket_SC_UseAppliance(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:TAppliance = null;
         var _loc10_:TInventories = null;
         var _loc11_:TArticle = null;
         var _loc12_:TArticle = null;
         var _loc13_:uint = 0;
         var _loc14_:Vector.<uint> = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.SetBtnLock(true);
         }
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc6_ = "";
         _loc8_ = "";
         _loc7_ = "";
         _loc14_ = new Vector.<uint>();
         _loc13_ = _loc2_.readUnsignedInt();
         _loc5_ = uint(_loc2_.readShort());
         _loc10_ = this.FCharacter.Inventories;
         _loc10_.Clear();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = this.FPoolInventory.AcquireAppliance();
            _loc9_.Type = _loc2_.readShort();
            _loc9_.IDTemplate = _loc2_.readUnsignedInt();
            _loc9_.Quantity = _loc2_.readUnsignedInt();
            _loc10_.Add(_loc9_);
            _loc4_++;
         }
         if(_loc5_ == 0)
         {
            _loc14_.push(_loc13_);
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc10_,_loc14_);
         }
         _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc13_) as TArticle;
         switch(_loc11_.MinorType)
         {
            case CONST_INVENTORY.CATEGORYSECOND_BagExtend:
               this.FStringID = CONST_SYSTEMLANGUAGE.BACKPACK_STRING_06;
               _loc6_ = this.GetEffectText(this.FStringID);
               EffectGenerateText(_loc6_);
               this.FProcessorUserAssets.UserUpdateBackpackCapacity();
               break;
            case CONST_INVENTORY.CATEGORYSECOND_ExperienceReel:
               this.PlayEffectTexts(_loc11_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Exp));
               this.FIsEndPushText = true;
               break;
            case CONST_INVENTORY.CATEGORYSECOND_SilverCard:
               this.PlayEffectTexts(_loc11_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin));
               this.FIsEndPushText = true;
               break;
            case CONST_INVENTORY.CATEGORYSECOND_ActivityChargeCard:
               this.FStringID = CONST_SYSTEMLANGUAGE.STRING_ACTITITYCHARGECARD;
               _loc6_ = this.GetEffectText(this.FStringID);
               EffectGenerateText(_loc6_);
               this.FProcessorUserAssets.UserUpdateBackpackCapacity();
               break;
            case CONST_INVENTORY.CATEGORYSECOND_LevelPacks:
            case CONST_INVENTORY.CATEGORYSECOND_SpecialMaterial:
            case CONST_INVENTORY.CATEGORYSECOND_CommenMaterial:
            case CONST_INVENTORY.CATEGORYSECOND_GemTreasure:
            case CONST_INVENTORY.CATEGORYSECOND_FiveGhostTreasure:
               this.FStringID = CONST_SYSTEMLANGUAGE.BACKPACK_FORMAT_02;
               _loc7_ = this.GetEffectText(this.FStringID);
               _loc6_ = _loc7_.split("\n")[1] + "\n";
               _loc5_ = uint(_loc10_.Count);
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc9_ = _loc10_.GetInventoryByIndex(_loc4_) as TAppliance;
                  _loc7_ = TUtilityLobby.GetItemName(_loc9_.Type,_loc9_.IDTemplate);
                  if(_loc7_ == "")
                  {
                     _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc9_.IDTemplate) as TArticle;
                     _loc8_ += TUtilityString.Format(_loc6_,_loc12_.Name,_loc9_.Quantity);
                  }
                  else
                  {
                     _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc9_.IDTemplate) as TArticle;
                     if(_loc9_.IDTemplate >= 14820001 && _loc9_.IDTemplate <= 14820030)
                     {
                        this.PlayEffectTexts(_loc12_,_loc7_);
                     }
                     else
                     {
                        _loc8_ += TUtilityString.Format(_loc6_,_loc7_,_loc9_.Quantity);
                     }
                  }
                  this.FEffectTexts.push(_loc8_);
                  _loc8_ = "";
                  _loc4_++;
               }
               this.FIsEndPushText = true;
         }
         _loc14_.length = 0;
         _loc14_ = null;
         _loc10_.Clear();
      }
      
      protected function PerformPacket_SC_SellItem(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:UInt64 = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc6_ = _loc2_.readUnsignedInt();
         _loc7_ = _loc2_.readUnsignedInt();
         _loc8_ = new UInt64(_loc7_,_loc6_);
         this.FProcessorUserAssets.Update();
         this.FProcessorWindowSell.Reset();
         this.FStringID = CONST_SYSTEMLANGUAGE.BACKPACK_FORMAT_01;
         _loc5_ = this.GetEffectText(this.FStringID);
         _loc4_ = TUtilityString.Format(_loc5_,_loc8_.ToNumber());
         EffectGenerateText(_loc4_);
         this.FSilverCoin = 0;
         _loc8_ = null;
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function PerformPacket_SC_DepotToBag(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
         }
         if(this.FProcessorUserAssets.Visible)
         {
            this.FProcessorUserAssets.Update();
            this.FProcessorUserAssets.SetBtnLock(true);
         }
      }
      
      protected function GetEffectText(param1:uint) : String
      {
         this.FSystemLanguage = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,this.FStringID) as TSystemLanguage;
         if(this.FSystemLanguage != null)
         {
            return this.FSystemLanguage.Desc;
         }
         return "";
      }
      
      protected function PlayEffectTexts(param1:TArticle, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.FStringID = CONST_SYSTEMLANGUAGE.BACKPACK_STRING_19;
         _loc3_ = this.GetEffectText(this.FStringID);
         if(param1.MinorType == CONST_INVENTORY.CATEGORYSECOND_ExperienceReel)
         {
            _loc4_ = TUtilityString.Format(_loc3_,param2,this.FExperience);
         }
         else
         {
            _loc4_ = TUtilityString.Format(_loc3_,param2,param1.FunctionValue * this.FQuantity);
         }
         this.FEffectTexts.push(_loc4_);
      }
      
      protected function ProcessorInventoryUpdateByBackpack(param1:uint, param2:TInventory) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:TInventory = null;
         var _loc5_:TInventories = null;
         var _loc6_:TEquipment = null;
         var _loc7_:TEquipment = null;
         var _loc8_:TAppliance = null;
         var _loc9_:TAppliance = null;
         _loc3_ = false;
         if(param1 == TYPE_TEMP_BACKPACK)
         {
            _loc5_ = this.FCharacter.TemporaryInventories;
         }
         else
         {
            switch(param2.Category)
            {
               case CATEGORY_Normal:
                  _loc5_ = this.FCharacter.Appliances;
                  break;
               case CATEGORY_Equipment:
                  _loc5_ = this.FCharacter.Equipments;
                  break;
               case CATEGORY_Ornament:
                  _loc5_ = this.FCharacter.Ornaments;
                  break;
               case CATEGORY_Gem:
                  _loc5_ = this.FCharacter.Gems;
                  break;
               case CATEGORY_Treasure:
                  _loc5_ = this.FCharacter.Treasures;
                  break;
               case CATEGORY_Material:
                  _loc5_ = this.FCharacter.Materials;
                  break;
               case CATEGORY_WakeEquip:
                  _loc5_ = this.FCharacter.WakeEquip;
            }
         }
         if(param2.Quantity != 0)
         {
            _loc4_ = _loc5_.GetInventoryByIdentifier(param2.Identifier);
         }
         if(param1 == TYPE_TEMP_BACKPACK)
         {
            _loc5_.SortTime();
         }
         else
         {
            _loc5_.Sort();
         }
         if(_loc4_ != null)
         {
            switch(param2.Category)
            {
               case CATEGORY_Ornament:
               case CATEGORY_Equipment:
               case CATEGORY_Treasure:
                  _loc6_ = param2 as TEquipment;
                  _loc7_ = _loc4_ as TEquipment;
                  this.FUtilityInventory.EquipmentAssign(_loc6_,_loc7_);
                  break;
               case CATEGORY_Normal:
               case CATEGORY_Material:
               case CATEGORY_Gem:
               case CATEGORY_WakeEquip:
                  _loc8_ = param2 as TAppliance;
                  _loc9_ = _loc4_ as TAppliance;
                  this.FUtilityInventory.ApplianceAssign(_loc8_,_loc9_);
            }
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      protected function ProcessorInventoryAddByBackpack(param1:uint, param2:TInventory) : void
      {
         var _loc5_:TInventories = null;
         if(param1 == TYPE_TEMP_BACKPACK)
         {
            _loc5_ = this.FCharacter.TemporaryInventories;
         }
         else
         {
            switch(param2.Category)
            {
               case CATEGORY_Normal:
                  _loc5_ = this.FCharacter.Appliances;
                  break;
               case CATEGORY_Equipment:
                  _loc5_ = this.FCharacter.Equipments;
                  break;
               case CATEGORY_Ornament:
                  _loc5_ = this.FCharacter.Ornaments;
                  break;
               case CATEGORY_Gem:
                  _loc5_ = this.FCharacter.Gems;
                  break;
               case CATEGORY_Treasure:
                  _loc5_ = this.FCharacter.Treasures;
                  break;
               case CATEGORY_Material:
                  _loc5_ = this.FCharacter.Materials;
                  break;
               case CATEGORY_WakeEquip:
                  _loc5_ = this.FCharacter.WakeEquip;
            }
         }
         if(_loc5_ == null || _loc5_.GetInventoryByIdentifier(param2.Identifier) != null)
         {
            return;
         }
         _loc5_.Add(param2);
         if(param1 == TYPE_TEMP_BACKPACK) _loc5_.SortTime();
         else _loc5_.Sort();
      }

      protected function ProcessorInventoryUpdateByEquipmentsMounted(param1:TInventory) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         var _loc6_:Boolean = false;
         var _loc7_:TInventory = null;
         var _loc8_:TCollectionInventory = null;
         var _loc9_:TEquipment = null;
         var _loc10_:TEquipment = null;
         _loc6_ = false;
         _loc5_ = this.FCharacter.Heros;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc2_);
            _loc8_ = _loc4_.EquipmentsMounted;
            _loc7_ = _loc8_.GetInventoryByIdentifier(param1.Identifier);
            if(_loc7_ != null)
            {
               _loc9_ = param1 as TEquipment;
               _loc10_ = _loc7_ as TEquipment;
               this.FUtilityInventory.EquipmentAssign(_loc9_,_loc10_);
               _loc6_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function ProcessorInventoryUpdateByOrnamentsMounted(param1:TInventory) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         var _loc6_:Boolean = false;
         var _loc7_:TInventory = null;
         var _loc8_:TCollectionInventory = null;
         var _loc9_:TEquipment = null;
         var _loc10_:TEquipment = null;
         _loc6_ = false;
         _loc5_ = this.FCharacter.Heros;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc2_);
            _loc8_ = _loc4_.OrnamentsMounted;
            _loc7_ = _loc8_.GetInventoryByIdentifier(param1.Identifier);
            if(_loc7_ != null)
            {
               _loc9_ = param1 as TEquipment;
               _loc10_ = _loc7_ as TEquipment;
               this.FUtilityInventory.EquipmentAssign(_loc9_,_loc10_);
               _loc6_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function ProcessorInventoryUpdateByTalismansMounted(param1:TInventory) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         var _loc6_:Boolean = false;
         var _loc7_:TInventory = null;
         var _loc8_:TCollectionInventory = null;
         var _loc9_:TEquipment = null;
         var _loc10_:TEquipment = null;
         _loc6_ = false;
         _loc5_ = this.FCharacter.Heros;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc2_);
            _loc8_ = _loc4_.TalismansMounted;
            _loc7_ = _loc8_.GetInventoryByIdentifier(param1.Identifier);
            if(_loc7_ != null)
            {
               _loc9_ = param1 as TEquipment;
               _loc10_ = _loc7_ as TEquipment;
               this.FUtilityInventory.EquipmentAssign(_loc9_,_loc10_);
               _loc6_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_EffectText();
      }
      
      protected function LogicsPerform_EffectText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(this.FIsEndPushText)
         {
            if(this.FEffectTexts.length == 0)
            {
               return;
            }
            _loc6_ = "";
            _loc4_ = "";
            this.FStringID = CONST_SYSTEMLANGUAGE.BACKPACK_FORMAT_02;
            _loc2_ = int(this.FEffectTexts.length);
            _loc3_ = 8;
            _loc5_ = STimingCore.TickCount - this.FEffDelayReferenceTick;
            if(_loc5_ < EffectMulti_DelayTicks)
            {
               return;
            }
            _loc7_ = this.GetEffectText(this.FStringID);
            _loc6_ = _loc7_.split("\n")[0] + "\n";
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               if(_loc2_ <= _loc1_)
               {
                  break;
               }
               _loc4_ += this.FEffectTexts.shift();
               _loc1_++;
            }
            _loc6_ += _loc4_;
            this.FEffDelayReferenceTick = STimingCore.TickCount;
            EffectGenerateText(_loc6_);
         }
      }
      
      protected function ProcessorAddInventoryToSellList(param1:TInventory) : Boolean
      {
         return this.FProcessorWindowSell.AddInventory(param1);
      }
      
      protected function ProcessorsOnQuertInventoryIDReq(param1:Object, param2:TInventory) : void
      {
         this.FInventoryReveal = param2;
         if(this.FOnQuertInventoryIDReq != null)
         {
            this.FOnQuertInventoryIDReq(param1,param2);
         }
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_Backpack);
         }
      }
      
      protected function WindowConfirmationSellOnOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:TInventory = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_SellItem);
         _loc5_ = _loc4_.Data;
         _loc3_ = this.FInventories.Count;
         _loc5_.writeShort(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FInventories.GetInventoryByIndex(_loc2_);
            _loc5_.writeUnsignedInt(_loc6_.Identifier);
            _loc5_.writeUnsignedInt(_loc6_.IDTemplate);
            _loc5_.writeShort(_loc6_.Quantity);
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorUserAssetsOnClose(param1:Object) : void
      {
         ProcessorClose();
         this.FProcessorWindowSell.Reset();
      }
      
      protected function ProcessorButtonSellOnClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = !this.FProcessorWindowSell.Visible;
         this.FProcessorWindowSell.Visible = _loc2_;
         if(_loc2_)
         {
            this.FProcessorWindowSell.Reset();
         }
         else
         {
            this.FProcessorWindowSell.Reset();
            this.FProcessorUserAssets.UpdateSlotsSelecd();
            this.FProcessorUserAssets.ResetSellWindow();
         }
      }
      
      protected function ProcessorCloseOnClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = !this.FProcessorWindowSell.Visible;
         this.FProcessorWindowSell.Visible = _loc2_;
         this.FProcessorWindowSell.Reset();
         this.FProcessorUserAssets.UpdateSlotsSelecd();
         this.FProcessorUserAssets.ResetSellWindow();
      }
      
      protected function ProcessorSellOnClick(param1:Object, param2:TInventory) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_SellItem);
         this.FInventory = param2;
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(1);
         _loc4_.writeUnsignedInt(param2.Identifier);
         _loc4_.writeUnsignedInt(param2.IDTemplate);
         _loc4_.writeShort(param2.Quantity);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorAllSellOnClick(param1:Object, param2:TInventories) : void
      {
         this.FInventories = param2;
         if(this.FUIWindowConfirmationSell.IsSelected)
         {
            this.WindowConfirmationSellOnOK(null);
         }
         else if(this.CheckEquipAndJade())
         {
            this.FUIWindowConfirmationSell.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_18);
            this.FUIWindowConfirmationSell.Visible = true;
         }
         else
         {
            this.WindowConfirmationSellOnOK(null);
         }
      }
      
      protected function CheckEquipAndJade() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         _loc2_ = uint(this.FInventories.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FInventories.GetInventoryByIndex(_loc1_);
            if(_loc3_.Category == CATEGORY_Equipment || _loc3_.Category == CATEGORY_Gem || _loc3_.Category == CATEGORY_Treasure || _loc3_.Category == CATEGORY_Ornament)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function ProcessorInventoryClick(param1:Object, param2:TInventories) : void
      {
         this.FProcessorUserAssets.UpdateSlotsSelecd();
      }
      
      protected function ProcessorUseAppliance(param1:Object, param2:TAppliance, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_UseAppliance);
         _loc5_ = _loc4_.Data;
         _loc5_.writeShort(1);
         _loc5_.writeUnsignedInt(param2.Identifier);
         _loc5_.writeUnsignedInt(param2.IDTemplate);
         _loc5_.writeShort(param3);
         _loc5_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         this.FQuantity = param3;
      }
      
      public function get OnUpdateInventories() : Function
      {
         return this.FOnUpdateInventories;
      }
      
      public function set OnUpdateInventories(param1:Function) : void
      {
         this.FOnUpdateInventories = param1;
      }
      
      public function get OnQuertInventoryIDReq() : Function
      {
         return this.FOnQuertInventoryIDReq;
      }
      
      public function set OnQuertInventoryIDReq(param1:Function) : void
      {
         this.FOnQuertInventoryIDReq = param1;
      }
      
      public function get OnInventoryReveal() : Function
      {
         return this.FOnInventoryReveal;
      }
      
      public function set OnInventoryReveal(param1:Function) : void
      {
         this.FOnInventoryReveal = param1;
      }
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorUserAssets.Load();
            this.FProcessorWindowSell.Load();
            return;
         }
         this.FProcessorUserAssets.Update();
         this.FProcessorUserAssets.Visible = true;
         this.FProcessorWindowSell.Visible = false;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorUserAssets.Reset();
         this.FProcessorWindowSell.Reset();
      }
      
      public function SetExperience(param1:uint) : void
      {
         this.FExperience = param1;
      }
      
      public function QuertInventoryIDRet(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         if(this.FInventoryReveal == null)
         {
            return;
         }
         if(this.FInventoryReveal.Identifier == param1 && this.FInventoryReveal.IDTemplate == param2)
         {
            this.FInventoryReveal.Identifier0 = param3;
            this.FInventoryReveal.Identifier1 = param4;
            if(this.FOnInventoryReveal != null)
            {
               this.FOnInventoryReveal(this,this.FInventoryReveal);
            }
         }
         this.FInventoryReveal = null;
      }
   }
}

