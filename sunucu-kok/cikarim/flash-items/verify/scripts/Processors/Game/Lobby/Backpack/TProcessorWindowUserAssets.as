package Processors.Game.Lobby.Backpack
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Spaces.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Backpack.Window.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.*;
   import Processors.Game.Windows.Editors.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorWindowUserAssets extends TProcessorLobbyWindow
   {
      
      protected static const STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const CAPACITY_MC_Tabs:uint = CONST_BACKPACK.CAPACITY_MC_Tabs;
      
      protected static const CAPACITY_Slots:uint = CONST_BACKPACK.CAPACITY_Slots;
      
      protected static const CAPACITY_INVENTORIES:uint = CONST_COMMON.CAPACITY_INVENTORIES;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const INVENTORIESINDEX_Appliances:uint = CONST_COMMON.INVENTORIESINDEX_Appliances;
      
      protected static const INVENTORIESINDEX_Equipments:uint = CONST_COMMON.INVENTORIESINDEX_Equipments;
      
      protected static const INVENTORIESINDEX_Ornament:uint = CONST_COMMON.INVENTORIESINDEX_Ornament;
      
      protected static const INVENTORIESINDEX_Materials:uint = CONST_COMMON.INVENTORIESINDEX_Materials;
      
      protected static const INVENTORIESINDEX_Gems:uint = CONST_COMMON.INVENTORIESINDEX_Gems;
      
      protected static const INVENTORIESINDEX_Treasures:uint = CONST_COMMON.INVENTORIESINDEX_Treasures;
      
      protected static const INVENTORIESINDEX_WakeEquip:uint = CONST_COMMON.INVENTORIESINDEX_WakeEquip;
      
      protected static const INVENTORIESINDEX_Temporary:uint = CONST_COMMON.INVENTORIESINDEX_Temporary;
      
      protected static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      protected static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      protected static const CATEGORY_TitleCard:uint = CONST_INVENTORY.CATEGORY_TitleCard;
      
      protected static const CATEGORY_WakeEquip:uint = CONST_INVENTORY.CATEGORY_WakeEquip;
      
      protected static const CATEGORYSECOND_ExperienceReel:uint = CONST_INVENTORY.CATEGORYSECOND_ExperienceReel;
      
      protected static const CATEGORYSECOND_PsychicReel:uint = CONST_INVENTORY.CATEGORYSECOND_PsychicReel;
      
      protected static const CATEGORYSECOND_RefiningSoul:uint = CONST_INVENTORY.CATEGORYSECOND_RefiningSoul;
      
      protected static const CATEGORYSECOND_TreasureUpgrade:uint = CONST_INVENTORY.CATEGORYSECOND_TreasureUpgrade;
      
      protected static const CATEGORYSECOND_TreasureTransform:uint = CONST_INVENTORY.CATEGORYSECOND_TreasureTransform;
      
      protected static const CATEGORYSECOND_BagExtend:uint = CONST_INVENTORY.CATEGORYSECOND_BagExtend;
      
      protected static const CATEGORYSECOND_LevelPacks:uint = CONST_INVENTORY.CATEGORYSECOND_LevelPacks;
      
      protected static const CATEGORYSECOND_MagicStone:uint = CONST_INVENTORY.CATEGORYSECOND_MagicStone;
      
      protected static const CATEGORYSECOND_HeroTitle:uint = CONST_INVENTORY.CATEGORYSECOND_HeroTitle;
      
      protected static const CATEGORYSECOND_FlushSpriteWater:uint = CONST_INVENTORY.CATEGORYSECOND_FlushSpriteWater;
      
      protected static const CATEGORYSECOND_MakeEquipMaterial:uint = CONST_INVENTORY.CATEGORYSECOND_MakeEquipMaterial;
      
      protected static const CATEGORYSECOND_ChangeName:uint = CONST_INVENTORY.CATEGORYSECOND_ChangeName;
      
      protected static const CATEGORYSECOND_ProfessionRefine:uint = CONST_INVENTORY.CATEGORYSECOND_ProfessionRefine;
      
      protected static const CATEGORYSECOND_ChangeCountry:uint = CONST_INVENTORY.CATEGORYSECOND_ChangeCountry;
      
      protected static const POPUPMENUINDEX_Use:uint = CONST_BACKPACK.POPUPMENUINDEX_Use;
      
      protected static const POPUPMENUINDEX_Reveal:uint = CONST_BACKPACK.POPUPMENUINDEX_Reveal;
      
      protected static const POPUPMENUINDEX_Sell:uint = CONST_BACKPACK.POPUPMENUINDEX_Sell;
      
      protected static const STRING_Capacity:String = CONST_COMMON.STRING_Capacity;
      
      protected var FVipData:TVip;
      
      protected var FHelpTips:THint;
      
      protected var TConfigValues:TBins;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowConfirmationSell:TUIWindowConfirmation;
      
      protected var FUIWindowConfirmationJadeSell:TUIWindowConfirmation;
      
      protected var FUIWindowEditor:TUIWindowEditor;
      
      protected var FTextFormatInformation:TextFormat;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtnExpand:TUIButton;
      
      protected var FBtnQuickPickUp:TUIButton;
      
      protected var FMC_Btn_Sell:TUIButton;
      
      protected var FTF_Capacity:TextField;
      
      protected var FCharacter:TCharacter;
      
      protected var FInventories:TInventories;
      
      protected var FWindowPopupMenu:TWindowPopupMenu;
      
      protected var FButtonPrevious:TUIButton;
      
      protected var FButtonNext:TUIButton;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FCurrentCapacity:int;
      
      protected var FBackpackCapacity:int;
      
      protected var FIsExpandBackpack:Boolean;
      
      protected var FIsSellInventories:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FExpandItemQuantity:uint;
      
      protected var FExpandCapacity:uint;
      
      protected var FExpandCount:uint;
      
      protected var FCostGold:uint;
      
      protected var FIsGoldEnough:Boolean;
      
      protected var FIsTemporaryLoaded:Boolean;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnButtonSell:Function;
      
      protected var FOnSellInventoryToList:Function;
      
      protected var FOnSellInventory:Function;
      
      protected var FOnQuertInventoryIDReq:Function;
      
      protected var FOnUseAppliance:Function;
      
      public function TProcessorWindowUserAssets(param1:TUIComponent)
      {
         super(param1);
         this.FTabIndex = 0;
         this.FIsExpandBackpack = true;
         this.FIsSellInventories = false;
         this.FInitialization = false;
         this.FIsGoldEnough = false;
         this.FIsTemporaryLoaded = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BACKPACK.RESOURCESID_Swf_Backpack);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:TUISlot = null;
         var _loc8_:Sprite = null;
         var _loc9_:Vector.<String> = null;
         this.FHelpTips = new THint();
         this.FTextFormatInformation = new TextFormat();
         this.FUISlots = new Vector.<TUISlot>(CAPACITY_Slots);
         this.FUITab = new TUITab(this);
         this.FUIPage = new TUIPage(this);
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FWindowPopupMenu = new TWindowPopupMenu(Parent);
         this.FInventories = new TInventories();
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_BACKPACK.RESOURCE_ClassName_MC_Backpack) as Sprite;
         addChild(_loc3_);
         this.FBtn_Close = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Help];
         _loc9_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_15);
         _loc2_ = int(CAPACITY_MC_Tabs);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc4_,_loc1_);
            this.FUITab.SetTabCaptionByIndex(_loc9_[_loc1_],_loc1_);
            _loc1_++;
         }
         _loc3_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_].visible = false;
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FBtnExpand = new TUIButton();
         this.FBtnExpand.Substrate = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_Btn_Expand];
         this.FBtnExpand.OnClick = this.BtnExpandOnClick;
         this.FBtnQuickPickUp = new TUIButton();
         this.FBtnQuickPickUp.Substrate = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_Btn_QuickPickUp];
         this.FBtnQuickPickUp.OnClick = this.BtnQuickPickUpOnClick;
         this.FBtnQuickPickUp.Visible = false;
         _loc5_ = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc5_;
         _loc5_ = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc5_;
         this.FTF_Capacity = _loc3_[CONST_BACKPACK.RESOURCE_Link_TF_Capacity];
         _loc6_ = _loc3_[CONST_BACKPACK.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc6_;
         this.FUIPage.PageSize = CAPACITY_Slots;
         this.FUIPage.Init();
         this.FButtonPrevious = this.FUIPage.ButtonPrevious;
         this.FButtonNext = this.FUIPage.ButtonNext;
         this.FMC_Btn_Sell = new TUIButton();
         this.FMC_Btn_Sell.Substrate = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_Btn_Sell];
         this.FMC_Btn_Sell.OnClick = this.ButtonSellOnClick;
         _loc2_ = int(CAPACITY_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = new TUISlot(this);
            _loc7_.Resource = _loc3_[CONST_BACKPACK.RESOURCE_Link_MC_Slots + _loc1_] as Sprite;
            _loc7_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc7_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc7_.Tag = _loc1_;
            _loc7_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc7_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc7_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc7_.OnClick = this.SlotsOnClick;
            _loc7_.OnOver = this.SlotsOnMove;
            _loc7_.OnOut = this.SlotsOnOut;
            _loc7_.OnQuerySelectedContext = this.SlotsOnSelectedContext;
            _loc7_.Init();
            this.FUISlots[_loc1_] = _loc7_;
            _loc1_++;
         }
         _loc8_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_BACKPACK.RESOURCE_ClassName_MC_PopupMenu) as Sprite;
         this.FWindowPopupMenu.SetSequenceButton(_loc8_);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowConfirmationSell = new TUIWindowConfirmation(this.Parent);
         this.FUIWindowConfirmationSell.OnOK = this.WindowConfirmationSellOnOK;
         this.FUIWindowConfirmationJadeSell = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowEditor = new TUIWindowEditor(this.Parent);
         this.FUIWindowEditor.OnOK = this.WindowEditorOnOK;
         this.FUIWindowEditor.OnCancel = this.WindowEditorOnCancel;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationSell);
         this.FUIWindowConfirmationSell.SetCheckBoxUsable(true);
         TUtilityUIWindow.SetupWindowEditor(this.FUIWindowEditor);
         this.TConfigValues = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:TConfigValue = null;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.UserAssetsOnDown,false,0,true);
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FWindowPopupMenu.addEventListener(MouseEvent.ROLL_OUT,this.PopupMenuOnOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.SlotsGroupOnWheel,false,0,true);
         this.FWindowPopupMenu.OnPopupMenu = this.PopupMenuOnClick;
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc1_ = this.TConfigValues.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BACKPACK_EXPEND_NUM) as TConfigValue;
         this.FExpandCapacity = _loc1_.Value as int;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!this.FInitialization)
         {
            return;
         }
         this.ProcessorUpdateSlotsRenderingState();
         this.ProcessorUpdateTemporaryInventoriesExpired();
         this.FUIWindowEditor.Update();
      }
      
      protected function ProcessorUpdateSlotsRenderingState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = int(CAPACITY_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUISlots[_loc1_];
            _loc3_.Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorUpdateTemporaryInventoriesExpired() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         var _loc5_:Boolean = false;
         if(this.FTabIndex != INVENTORIESINDEX_Temporary)
         {
            return;
         }
         _loc5_ = false;
         _loc4_ = this.FCharacter.TemporaryInventories;
         _loc2_ = _loc4_.Count;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = _loc4_.GetInventoryByIndex(_loc1_);
            if(_loc3_.TimingState == CONST_INVENTORY.TIMINGSTATE_Expired)
            {
               _loc4_.DeleteInventoryByIndex(_loc1_);
               _loc5_ = true;
            }
            _loc1_--;
         }
         if(_loc5_)
         {
            this.InventoriesUpdateSlotsByInventories(this.FUISlots,_loc4_);
         }
      }
      
      protected function InventoriesUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TInventories = null;
         this.FInventories.Clear();
         _loc1_ = this.FTabIndex;
         switch(_loc1_)
         {
            case INVENTORIESINDEX_Appliances:
               _loc2_ = this.FCharacter.Appliances;
               break;
            case INVENTORIESINDEX_Equipments:
               _loc2_ = this.FCharacter.Equipments;
               break;
            case INVENTORIESINDEX_Ornament:
               _loc2_ = this.FCharacter.Ornaments;
               break;
            case INVENTORIESINDEX_Materials:
               _loc2_ = this.FCharacter.Materials;
               break;
            case INVENTORIESINDEX_Gems:
               _loc2_ = this.FCharacter.Gems;
               break;
            case INVENTORIESINDEX_Treasures:
               _loc2_ = this.FCharacter.Treasures;
               break;
            case INVENTORIESINDEX_WakeEquip:
               _loc2_ = this.FCharacter.WakeEquip;
               break;
            case INVENTORIESINDEX_Temporary:
               _loc2_ = this.FCharacter.TemporaryInventories;
         }
         this.ProcessorInventories(_loc2_);
      }
      
      protected function ProcessorInventories(param1:TInventories) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetInventoryByIndex(_loc2_);
            this.FInventories.Add(_loc4_);
            _loc2_++;
         }
      }
      
      protected function InventoriesUpdateSlotsByInventories(param1:Vector.<TUISlot>, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUISlot = null;
         var _loc8_:Sprite = null;
         var _loc9_:TInventory = null;
         _loc6_ = this.FPageIndex;
         _loc4_ = int(CAPACITY_Slots);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param1[_loc3_];
            _loc7_.Context = null;
            _loc7_.Resource.visible = false;
            _loc7_.IsSelected = false;
            _loc3_++;
         }
         _loc4_ = param2.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc5_ = _loc6_ * CAPACITY_Slots;
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_Slots)
         {
            if(_loc3_ + _loc5_ >= _loc4_)
            {
               break;
            }
            _loc7_ = param1[_loc3_];
            _loc9_ = param2.GetInventoryByIndex(_loc3_ + _loc5_);
            _loc7_.Context = _loc9_;
            _loc7_.IsSelected = _loc9_.IsSelling;
            _loc7_.SelectBox = _loc9_.IsSelling;
            _loc7_.Resource.visible = true;
            _loc3_++;
         }
      }
      
      protected function UpdateBackpackCapacity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TConfigValue = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BACKPACK_InitCapacity) as TConfigValue;
         _loc3_ = _loc4_.Value as uint;
         this.FCharacter.BackpackCapacity = _loc3_ + this.FVipData.BagCount + this.FExpandCapacity * this.FCharacter.BackpackExpandCount;
         this.FBackpackCapacity = this.FCharacter.BackpackCapacity;
         if(this.FTabIndex == INVENTORIESINDEX_Temporary)
         {
            _loc1_ = int(this.GetBackpackTemporaryCapacity());
            _loc2_ = int(this.FCharacter.BackpackTemporaryCapacity);
            if(_loc1_ != 0)
            {
               this.FBtnQuickPickUp.Enabled = true;
            }
            else
            {
               this.FBtnQuickPickUp.Enabled = false;
            }
         }
         else
         {
            _loc1_ = int(this.GetBackpackCapacity());
            _loc2_ = this.FBackpackCapacity;
         }
         this.FUIPage.TotalQuantity = this.FInventories.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
         this.FTF_Capacity.text = TUtilityString.Format(STRING_Capacity,_loc1_,_loc2_);
      }
      
      protected function GetBackpackCapacity() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         _loc2_ = CAPACITY_INVENTORIES - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FCharacter.GetBackpackByIndex(_loc1_);
            _loc3_ += _loc4_.Count;
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function GetBackpackTemporaryCapacity() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:TInventories = null;
         _loc2_ = this.FCharacter.TemporaryInventories;
         return uint(_loc2_.Count);
      }
      
      protected function ProcessorPopupMenuUseInventories(param1:TInventory) : void
      {
         var _loc2_:TAppliance = null;
         var _loc3_:TArticle = null;
         var _loc4_:uint = 0;
         var _loc5_:TSystemLanguage = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.IDTemplate) as TArticle;
         if(this.FCharacter.GetMainLevel() < _loc3_.Level)
         {
            _loc4_ = CONST_SYSTEMLANGUAGE.BACKPACK_FORMAT_09;
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc4_) as TSystemLanguage;
            EffectGenerateText(_loc5_.Desc);
            return;
         }
         if(_loc3_.ItemFunction == 5 || _loc3_.ItemFunction == 0 && _loc3_.MinorType == 90 || [14100022,14100023,14100024,14100025,14100026,14100027,14100028,14100061,14100062,14100063,14100064].indexOf(param1.IDTemplate) >= 0)
         {
            _loc2_ = param1 as TAppliance;
            this.FUIWindowEditor.Label = _loc2_.Name;
            this.FUIWindowEditor.Context = _loc2_;
            this.FUIWindowEditor.Value = Math.min(32767,_loc2_.Quantity);
            this.FUIWindowEditor.Min = 1;
            this.FUIWindowEditor.Max = Math.min(32767,_loc2_.Quantity);
            this.FUIWindowEditor.Visible = true;
            this.FUIWindowEditor.SetFocus();
            return;
         }
         switch(param1.Category)
         {
            case CATEGORY_Normal:
               _loc2_ = param1 as TAppliance;
               switch(_loc2_.CategorySecond)
               {
                  case 55:
                  case CATEGORYSECOND_ExperienceReel:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros,1);
                     return;
                  case 81:
                  case 82:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
                     return;
                  case CATEGORYSECOND_PsychicReel:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeSoul);
                     return;
                  case CATEGORYSECOND_RefiningSoul:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeOfKillSoul,2);
                     return;
                  case CATEGORYSECOND_TreasureUpgrade:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure,1);
                     return;
                  case CATEGORYSECOND_TreasureTransform:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure,2);
                     return;
                  case CATEGORYSECOND_ChangeName:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_ChangeInfo,0);
                     return;
                  case CATEGORYSECOND_ChangeCountry:
                     if(param1.IDTemplate != 14100692)
                     {
                        if(param1.IDTemplate == 14100075 || param1.IDTemplate == 14100076)
                        {
                           SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TreasureMap);
                        }
                        else if(param1.IDTemplate >= 14100285 && param1.IDTemplate <= 14100291)
                        {
                           SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_SevenKing);
                        }
                        else
                        {
                           SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
                        }
                        return;
                     }
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_ChangeInfo,1);
                     return;
                     break;
                  case CATEGORYSECOND_ProfessionRefine:
                     if(param1.IDTemplate == 14100782)
                     {
                        SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure);
                        return;
                     }
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_ProfessionRefine,1);
                     return;
                     break;
                  case CATEGORYSECOND_BagExtend:
                     this.BtnExpandOnClick(this,null);
                     break;
                  case CATEGORYSECOND_LevelPacks:
                     this.FOnUseAppliance(this,_loc2_,1);
                     break;
                  case CATEGORYSECOND_MagicStone:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Strengthen,CONST_SMITHY.TAB_INDEX_GETSKILL);
                     return;
                  default:
                     _loc2_ = param1 as TAppliance;
                     this.FUIWindowEditor.Label = _loc2_.Name;
                     this.FUIWindowEditor.Context = _loc2_;
                     _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_10);
                     this.FUIWindowEditor.Quantity = TUtilityString.Format(_loc7_,_loc2_.Quantity);
                     this.FUIWindowEditor.Value = Math.min(32767,_loc2_.Quantity);
                     this.FUIWindowEditor.Min = 1;
                     this.FUIWindowEditor.Max = Math.min(32767,_loc2_.Quantity);
                     this.FUIWindowEditor.SetFocus();
                     this.FUIWindowEditor.Visible = true;
               }
               break;
            case CATEGORY_Equipment:
            case CATEGORY_Ornament:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
               return;
            case CATEGORY_Gem:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Jade);
               return;
            case CATEGORY_Treasure:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure);
               return;
            case CATEGORY_Material:
               _loc2_ = param1 as TAppliance;
               switch(_loc2_.CategorySecond)
               {
                  case CATEGORYSECOND_FlushSpriteWater:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Strengthen,5);
                     return;
                  case CATEGORYSECOND_MakeEquipMaterial:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros,1);
                     return;
                  default:
                     SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_MakeEquip);
                     return;
               }
               break;
            case CATEGORY_TitleCard:
               _loc2_ = param1 as TAppliance;
               switch(_loc2_.CategorySecond)
               {
                  case CATEGORYSECOND_HeroTitle:
                     this.FOnUseAppliance(this,_loc2_,1);
               }
         }
      }
      
      protected function ProcessorsInventoryReveal(param1:TInventory) : void
      {
         if(!param1.IsCanReveal)
         {
            return;
         }
         if(this.FOnQuertInventoryIDReq != null)
         {
            this.FOnQuertInventoryIDReq(this,param1);
            ProcessorWindowClose();
         }
      }
      
      protected function ProcessorDepotToBag(param1:uint, param2:TInventory = null) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_DepotToBag);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(param1);
         if(param1 == CONST_BACKPACK.TYPE_DEPOTTOBAG_Single)
         {
            _loc4_.writeUnsignedInt(param2.Identifier);
            _loc4_.writeUnsignedInt(param2.IDTemplate);
         }
         else
         {
            _loc4_.writeUnsignedInt(0);
            _loc4_.writeUnsignedInt(0);
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function CharacterLoadTemporaryInventories() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_LoadBag);
         _loc2_ = _loc1_.Data;
         _loc2_.writeByte(CONST_BACKPACK.TYPE_LOADBACKPACK_Temporary);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQueryAdvancedEquip(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsAdvancedEquip;
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         if(param2 is TAppliance || param2 is TInventoryWake)
         {
            _loc4_ = param2 as TInventory;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function SlotsOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:TInventory = null;
         var _loc6_:TAppliance = null;
         _loc5_ = param2 as TInventory;
         this.SlotsOnOut(param1,_loc5_);
         if(this.FTabIndex == INVENTORIESINDEX_Temporary)
         {
            this.ProcessorDepotToBag(CONST_BACKPACK.TYPE_DEPOTTOBAG_Single,_loc5_);
            return;
         }
         _loc4_ = _loc5_.IsCanSell;
         if(this.FIsSellInventories)
         {
            if(_loc4_)
            {
               if(this.FOnSellInventoryToList != null)
               {
                  _loc3_ = this.FOnSellInventoryToList(_loc5_);
               }
            }
            return;
         }
         this.FWindowPopupMenu.Context = _loc5_;
         this.FWindowPopupMenu.IsCanReveal = _loc5_.IsCanReveal;
         this.FWindowPopupMenu.IsCanSell = _loc4_;
         this.FWindowPopupMenu.Usable = true;
         if(_loc5_ is TAppliance)
         {
            _loc6_ = _loc5_ as TAppliance;
            switch(_loc6_.CategorySecond)
            {
               case CATEGORYSECOND_ExperienceReel:
               case CATEGORYSECOND_PsychicReel:
               case CATEGORYSECOND_RefiningSoul:
               case CATEGORYSECOND_TreasureUpgrade:
               case CATEGORYSECOND_TreasureTransform:
               case CATEGORYSECOND_BagExtend:
               case CATEGORYSECOND_LevelPacks:
                  this.FWindowPopupMenu.Usable = true;
                  break;
               default:
                  this.FWindowPopupMenu.Usable = _loc6_.Usable;
            }
         }
         else if(_loc5_ is TEquipment)
         {
            this.FWindowPopupMenu.Usable = true;
         }
         this.FWindowPopupMenu.X = FUICore.MouseCoordinate.X - 10;
         this.FWindowPopupMenu.Y = FUICore.MouseCoordinate.Y - 10;
         this.FWindowPopupMenu.Update();
         this.FWindowPopupMenu.Visible = !this.FWindowPopupMenu.Visible;
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(this,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,param2);
         }
      }
      
      protected function SlotsOnSelectedContext(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:TInventory = null;
         _loc4_ = param2 as TInventory;
         param3.Value = _loc4_.IsSelling;
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.FPageIndex = 0;
         this.InventoriesUpdate();
         this.UpdateBackpackCapacity();
         this.InventoriesUpdateSlotsByInventories(this.FUISlots,this.FInventories);
         this.FBtnQuickPickUp.Visible = false;
         this.FBtnQuickPickUp.Enabled = false;
         if(this.FTabIndex == INVENTORIESINDEX_Temporary)
         {
            if(!this.FIsTemporaryLoaded)
            {
               this.CharacterLoadTemporaryInventories();
               this.FIsTemporaryLoaded = true;
            }
            else
            {
               this.FBtnQuickPickUp.Visible = true;
               if(this.FInventories.Count != 0)
               {
                  this.FBtnQuickPickUp.Enabled = true;
               }
            }
         }
      }
      
      protected function SlotsGroupOnWheel(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.delta;
         _loc3_ = this.FPageIndex;
         _loc4_ = int(this.FUIPage.TotalPage);
         if(_loc2_ < 0)
         {
            if(this.FButtonNext.OnClick != null)
            {
               this.FButtonNext.OnClick(this,null);
            }
         }
         else if(this.FButtonPrevious.OnClick != null)
         {
            this.FButtonPrevious.OnClick(this,null);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         this.InventoriesUpdateSlotsByInventories(this.FUISlots,this.FInventories);
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.FIsSellInventories = false;
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Backpack);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function BtnExpandOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:TArticle = null;
         var _loc13_:TBins = null;
         var _loc14_:TConfigValue = null;
         var _loc15_:Boolean = false;
         var _loc16_:uint = 0;
         var _loc17_:TInventory = null;
         var _loc18_:uint = 0;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:TInventories = null;
         _loc15_ = this.FIsExpandBackpack;
         _loc18_ = 0;
         _loc7_ = this.FCharacter.BackpackExpandCount;
         this.FExpandCount = _loc7_;
         _loc14_ = this.TConfigValues.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BACKPACK_EXPEND_ITEM) as TConfigValue;
         _loc8_ = uint(_loc14_.Value as int);
         _loc14_ = this.TConfigValues.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BACKPACK_ITEMEXPEND_NEED) as TConfigValue;
         _loc9_ = _loc14_.Value as Vector.<uint>;
         _loc14_ = this.TConfigValues.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BACKPACK_Item_Gold) as TConfigValue;
         _loc16_ = uint(_loc14_.Value as int);
         _loc20_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_12);
         if(_loc7_ >= _loc9_.length)
         {
            EffectGenerateText(_loc20_);
            return;
         }
         _loc21_ = this.FCharacter.Appliances;
         _loc3_ = 0;
         while(_loc3_ < _loc21_.Count)
         {
            _loc17_ = _loc21_.GetInventoryByIndex(_loc3_);
            if(_loc17_.CategorySecond == CONST_INVENTORY.CATEGORYSECOND_BagExtend)
            {
               _loc18_ += _loc17_.Quantity;
            }
            _loc3_++;
         }
         _loc14_ = this.TConfigValues.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BACKPACK_EXPEND_NUM) as TConfigValue;
         _loc11_ = uint(_loc14_.Value as int);
         this.FExpandCapacity = _loc11_;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc8_) as TArticle;
         _loc10_ = _loc12_.Name;
         _loc3_ = int(_loc7_);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc18_ >= _loc9_[_loc7_])
         {
            this.FExpandItemQuantity = _loc9_[_loc7_];
            _loc19_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_20);
            _loc6_ = TUtilityString.Format(_loc19_,_loc7_,_loc10_,_loc9_[_loc3_],_loc11_);
            _loc4_ = _loc6_.indexOf(_loc10_);
            _loc5_ = _loc4_ + _loc10_.length;
            this.FTextFormatInformation.color = QUALITYCOLOR_INDEX[_loc12_.Quality];
            this.FIsGoldEnough = true;
         }
         else
         {
            this.FCostGold = (_loc9_[_loc7_] - _loc18_) * _loc16_;
            if(this.FCostGold <= this.FCharacter.CreditGiftCertificate + this.FCharacter.CreditGold)
            {
               this.FIsGoldEnough = true;
            }
            else
            {
               this.FIsGoldEnough = false;
            }
            if(this.FIsGoldEnough && _loc18_ > 0)
            {
               _loc19_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_21);
               _loc6_ = TUtilityString.Format(_loc19_,_loc7_,_loc10_,_loc18_,(_loc9_[_loc3_] - _loc18_) * _loc16_,_loc11_);
               _loc4_ = _loc6_.indexOf(_loc10_);
               _loc5_ = _loc4_ + _loc10_.length;
               this.FTextFormatInformation.color = QUALITYCOLOR_INDEX[_loc12_.Quality];
            }
            else
            {
               _loc19_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_22);
               _loc6_ = TUtilityString.Format(_loc19_,_loc7_,_loc9_[_loc3_] * _loc16_,_loc11_);
            }
            this.FExpandItemQuantity = _loc18_;
         }
         if(_loc7_ >= _loc9_.length)
         {
            _loc15_ = false;
         }
         if(_loc15_)
         {
            if(!TUtilityString.Empty(_loc6_))
            {
               this.FUIWindowConfirmation.Text = _loc6_;
            }
            if(_loc4_ != 0 && _loc5_ != 0)
            {
               this.FUIWindowConfirmation.SetTextFormat(this.FTextFormatInformation,_loc4_,_loc5_);
            }
         }
         else
         {
            this.FUIWindowConfirmation.Text = _loc20_;
         }
         this.FIsExpandBackpack = _loc15_;
         this.FBtnExpand.Enabled = false;
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.HindowInformationOnCancel;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BtnQuickPickUpOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorDepotToBag(CONST_BACKPACK.TYPE_DEPOTTOBAG_Batch);
      }
      
      protected function ButtonSellOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnButtonSell != null)
         {
            this.FIsSellInventories = !this.FIsSellInventories;
            this.FOnButtonSell(this);
         }
      }
      
      protected function PopupMenuOnClick(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         _loc3_ = this.FWindowPopupMenu.Context as TInventory;
         _loc2_ = param1 as int;
         switch(_loc2_)
         {
            case POPUPMENUINDEX_Use:
               this.ProcessorPopupMenuUseInventories(_loc3_);
               break;
            case POPUPMENUINDEX_Reveal:
               this.ProcessorsInventoryReveal(_loc3_);
               break;
            case POPUPMENUINDEX_Sell:
               if(!this.FUIWindowConfirmationSell.IsSelected)
               {
                  if(_loc3_ is TEquipment)
                  {
                     _loc4_ = _loc3_.SellValue + _loc3_.SellingValue;
                  }
                  else
                  {
                     _loc4_ = _loc3_.Quantity * _loc3_.SellValue;
                  }
                  _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_14);
                  this.FUIWindowConfirmationSell.Text = TUtilityString.Format(_loc5_,_loc3_.Name,_loc3_.Quantity,_loc4_);
                  this.FUIWindowConfirmationSell.Context = _loc3_;
                  this.FUIWindowConfirmationSell.Visible = true;
               }
               else if(this.FOnSellInventory != null)
               {
                  this.FOnSellInventory(this,_loc3_);
               }
         }
         this.PopupMenuOnOut(null);
      }
      
      protected function PopupMenuOnOut(param1:MouseEvent) : void
      {
         this.FWindowPopupMenu.Visible = false;
      }
      
      protected function UserAssetsOnDown(param1:MouseEvent) : void
      {
         if(this.FWindowPopupMenu.Visible)
         {
            this.FWindowPopupMenu.Visible = false;
         }
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         var _loc2_:TAppliance = null;
         if(this.FIsExpandBackpack && this.FIsGoldEnough)
         {
            _loc2_ = SLogicsCore.PoolInventory.AcquireAppliance();
            _loc2_.IDTemplate = CONST_BACKPACK.BagExtendIDTemplate;
            if(this.FOnUseAppliance != null)
            {
               this.FOnUseAppliance(this,_loc2_,this.FExpandItemQuantity);
            }
            ++this.FExpandCount;
         }
         else
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_16));
            this.FBtnExpand.Enabled = true;
         }
      }
      
      protected function HindowInformationOnCancel(param1:Object) : void
      {
         this.FBtnExpand.Enabled = true;
      }
      
      protected function WindowConfirmationJadeSellOnOK(param1:Object) : void
      {
         var _loc2_:TInventory = null;
         _loc2_ = this.FUIWindowConfirmationSell.Context as TInventory;
         if(this.FOnSellInventory != null)
         {
            this.FOnSellInventory(this,_loc2_);
         }
      }
      
      protected function WindowConfirmationSellOnOK(param1:Object) : void
      {
         var _loc2_:TInventory = null;
         _loc2_ = this.FUIWindowConfirmationSell.Context as TInventory;
         if(_loc2_ is TEquipment)
         {
            if((_loc2_ as TEquipment).GiftedStoneItems.Count > 0)
            {
               this.FUIWindowConfirmationJadeSell.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_17);
               this.FUIWindowConfirmationJadeSell.Context = _loc2_;
               this.FUIWindowConfirmationJadeSell.OnOK = this.WindowConfirmationJadeSellOnOK;
               this.FUIWindowConfirmationJadeSell.Visible = true;
            }
            else
            {
               this.WindowConfirmationJadeSellOnOK(null);
            }
         }
         else
         {
            this.WindowConfirmationJadeSellOnOK(null);
         }
      }
      
      protected function WindowEditorOnOK(param1:Object) : void
      {
         var _loc2_:TAppliance = null;
         _loc2_ = this.FUIWindowEditor.Context as TAppliance;
         if(this.FOnUseAppliance != null)
         {
            this.FOnUseAppliance(this,_loc2_,this.FUIWindowEditor.Value);
         }
         this.SetBtnLock(false);
      }
      
      protected function WindowEditorOnCancel(param1:Object) : void
      {
         this.FUIWindowEditor.Context = null;
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function get OnButtonSell() : Function
      {
         return this.FOnButtonSell;
      }
      
      public function set OnButtonSell(param1:Function) : void
      {
         this.FOnButtonSell = param1;
      }
      
      public function get OnSellInventoryToList() : Function
      {
         return this.FOnSellInventoryToList;
      }
      
      public function set OnSellInventoryToList(param1:Function) : void
      {
         this.FOnSellInventoryToList = param1;
      }
      
      public function get OnSellInventory() : Function
      {
         return this.FOnSellInventory;
      }
      
      public function set OnSellInventory(param1:Function) : void
      {
         this.FOnSellInventory = param1;
      }
      
      public function get OnQuertInventoryIDReq() : Function
      {
         return this.FOnQuertInventoryIDReq;
      }
      
      public function set OnQuertInventoryIDReq(param1:Function) : void
      {
         this.FOnQuertInventoryIDReq = param1;
      }
      
      public function get OnUseAppliance() : Function
      {
         return this.FOnUseAppliance;
      }
      
      public function set OnUseAppliance(param1:Function) : void
      {
         this.FOnUseAppliance = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = int(CAPACITY_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUISlots[_loc1_];
            _loc3_.Context = null;
            _loc3_.IsSelected = false;
            _loc1_++;
         }
         this.FPageIndex = 0;
      }
      
      public function Update() : void
      {
         this.InventoriesUpdate();
         this.UpdateBackpackCapacity();
         this.InventoriesUpdateSlotsByInventories(this.FUISlots,this.FInventories);
      }
      
      public function UserUpdateBackpackCapacity() : void
      {
         this.FCharacter.BackpackExpandCount = this.FExpandCount;
         this.UpdateBackpackCapacity();
      }
      
      public function UpdateSlotsSelecd() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TInventory = null;
         _loc2_ = CAPACITY_Slots;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUISlots[_loc1_];
            _loc4_ = _loc3_.Context as TInventory;
            if(_loc3_.IsSelected && !_loc4_.IsSelling)
            {
               _loc3_.IsSelected = false;
            }
            _loc1_++;
         }
      }
      
      public function ResetSellWindow() : void
      {
         this.FIsSellInventories = false;
      }
      
      public function SetBtnLock(param1:Boolean) : void
      {
         this.FBtnExpand.Enabled = param1;
         this.FBtnQuickPickUp.Enabled = param1;
      }
   }
}

