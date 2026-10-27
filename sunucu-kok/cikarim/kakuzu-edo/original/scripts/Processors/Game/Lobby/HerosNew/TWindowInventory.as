package Processors.Game.Lobby.HerosNew
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryBoolean;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TCollectionInventory;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventoryWake;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Editors.TUIWindowEditor;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TWindowInventory extends TProcessorLobbyWindow
   {
      
      protected static const ShowType_Equipment:int = 0;
      
      protected static const ShowType_Decoration:int = 1;
      
      protected static const ShowType_WakeUp:int = 2;
      
      protected static const ShowType_Appliance:int = 3;
      
      protected static const ShowTypeFreamIndex_ShowAll:int = 1;
      
      protected static const ShowTypeFreamIndex_ShowSpecial:int = 2;
      
      protected static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected static const CATEGORY_WakeEquip:uint = CONST_INVENTORY.CATEGORY_WakeEquip;
      
      protected static const CATEGORYSECOND_ExperienceReel:uint = CONST_INVENTORY.CATEGORYSECOND_ExperienceReel;
      
      protected static const BackPackSlotNum:int = 35;
      
      protected static const InventoryTab_Equipment:int = 0;
      
      protected static const InventoryTab_Appliance:int = 1;
      
      protected static const SecondType_WakeEquip:int = 1;
      
      protected static const SecondType_WakeChip:int = 2;
      
      protected var FShowSubType:int;
      
      protected var FInventoryFilterFunctions:Vector.<Vector.<Function>>;
      
      protected var FInventories:TInventories;
      
      protected var FSlotsUserAssets:Vector.<TUISlot>;
      
      protected var FIfShowAll:Boolean;
      
      protected var FMCShowAll:MovieClip;
      
      protected var FBtnWakeMap:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FExperienceReelValue:int;
      
      protected var FUIWindowEditor:TUIWindowEditor;
      
      protected var FInventoryMountedForTip:TInventory;
      
      protected var FRebirthData:TRebirthData;
      
      protected var FSuperExpBookID:uint;
      
      protected var FPlatformMaxLevel:uint;
      
      protected var FHero:THero;
      
      protected var FShowType:int;
      
      protected var FShowTypeRequest:int;
      
      protected var FOnSlotOnClick:Function;
      
      protected var FCharacter:TCharacter;
      
      protected var FOnUseApplianceNotify:Function;
      
      protected var FWakeOnClick:Function;
      
      public function TWindowInventory(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TConfigValue = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_ExpBookID) as TConfigValue;
         this.FSuperExpBookID = int(_loc3_.Value);
         _loc3_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.VERSION_PALYER_LEVEL) as TConfigValue;
         this.FPlatformMaxLevel = uint(_loc3_.Value);
         this.FInventoryFilterFunctions = new Vector.<Vector.<Function>>();
         this.FInventoryFilterFunctions.push(Vector.<Function>([this.FilterEquipmentRequirementLevel,this.FilterEquipmentRequirementCareer]));
         this.FInventoryFilterFunctions.push(Vector.<Function>([this.FilterDecoration]));
         this.FInventoryFilterFunctions.push(Vector.<Function>([this.FilterWakeUpRequipment]));
         this.FInventoryFilterFunctions.push(Vector.<Function>([this.FilterApplianceExperienceReel]));
         this.FInventories = new TInventories();
         this.FUIWindowEditor = new TUIWindowEditor(this.Parent.Parent);
         this.FUIWindowEditor.OnOK = this.WindowEditorOnOK;
         this.FUIWindowEditor.OnCancel = this.WindowEditorOnCancel;
         TUtilityUIWindow.SetupWindowEditor(this.FUIWindowEditor);
         this.FMCShowAll = param1["MC_ShowAllEquip"]["Btn_ShowALLEquip"];
         this.FMCShowAll.addEventListener(MouseEvent.CLICK,this.MCShowTypeOnClick);
         this.FIfShowAll = false;
         this.FMCShowAll.gotoAndStop(ShowTypeFreamIndex_ShowSpecial);
         this.FBtnWakeMap = new TUIButton();
         this.FBtnWakeMap.Substrate = param1["MC_Btn_WakeMap"];
         this.FBtnWakeMap.OnClick = this.BtnWakeOnClick;
         this.FBtnWakeMap.Enabled = false;
         this.UIDispatchSlots(param1);
      }
      
      protected function UIDispatchSlots(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         this.FSlotsUserAssets = new Vector.<TUISlot>();
         _loc3_ = BackPackSlotNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc4_.Tag = _loc2_;
            _loc4_.Resource = param1["MC_Slot_" + _loc2_];
            _loc4_.OnOver = this.SlotOnMove;
            _loc4_.OnOut = this.SlotOnOut;
            _loc4_.OnQueryAdvancedEquip = this.SlotsOnQueryAdvancedEquip;
            _loc4_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc4_.OnClick = this.SlotsUserAssetsOnClick;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FSlotsUserAssets.push(_loc4_);
            _loc2_++;
         }
         this.SetupSlotsQuerySubscript(this.FSlotsUserAssets,null);
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(param1["MC_Tab_Equipment"],InventoryTab_Equipment);
         this.FUITab.SetTabByIndex(param1["MC_Tab_Appliance"],InventoryTab_Appliance);
         this.FUITab.Init();
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = param1["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = param1["MC_PageRight"];
         this.FUIPage.LabelPage = param1["TF_Page"];
         this.FUIPage.PageSize = BackPackSlotNum;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.SetupSlotsQuerySubscript(this.FSlotsUserAssets,this.SlotsOnQuerySubscript);
      }
      
      protected function RenderSelector() : void
      {
         this.FBtnWakeMap.Visible = false;
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               this.RenderEquipment_Equipment();
               break;
            case ShowType_Decoration:
               this.RenderDecoration_Equipment();
               break;
            case ShowType_WakeUp:
               this.RenderWakeUp_Equipment();
               this.FBtnWakeMap.Visible = true;
               break;
            case ShowType_Appliance:
               this.RenderAppliance();
         }
      }
      
      protected function RenderEquipment_Equipment() : void
      {
         this.FInventories.Clear();
         if(this.FIfShowAll)
         {
            this.CopyInventories(SLogicsCore.Character.Equipments,this.FInventories);
         }
         else
         {
            this.ExecuteFilter(SLogicsCore.Character.Equipments,ShowType_Equipment,this.FInventories);
         }
         this.FUIPage.SetupPage(this.FInventories.Count,this.FCurrentPageIndex);
         this.RenderInventoryCommon();
      }
      
      protected function RenderDecoration_Equipment() : void
      {
         this.FInventories.Clear();
         if(this.FIfShowAll)
         {
            this.CopyInventories(SLogicsCore.Character.Ornaments,this.FInventories);
         }
         else
         {
            this.ExecuteFilter(SLogicsCore.Character.Ornaments,ShowType_Decoration,this.FInventories);
         }
         this.FUIPage.SetupPage(this.FInventories.Count,this.FCurrentPageIndex);
         this.RenderInventoryCommon();
      }
      
      protected function RenderWakeUp_Equipment() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TInventories = null;
         var _loc3_:TInventory = null;
         this.FInventories.Clear();
         _loc2_ = new TInventories();
         _loc1_ = 0;
         while(_loc1_ < SLogicsCore.Character.WakeEquip.Count)
         {
            _loc3_ = SLogicsCore.Character.WakeEquip.GetInventoryByIndex(_loc1_);
            if(_loc3_.CategorySecond == SecondType_WakeEquip)
            {
               _loc2_.Add(_loc3_);
            }
            _loc1_++;
         }
         if(this.FIfShowAll)
         {
            this.CopyInventories(_loc2_,this.FInventories);
         }
         else
         {
            this.ExecuteFilter(_loc2_,ShowType_WakeUp,this.FInventories);
         }
         this.FUIPage.SetupPage(this.FInventories.Count,this.FCurrentPageIndex);
         this.RenderInventoryCommon();
      }
      
      protected function RenderAppliance() : void
      {
         this.FInventories.Clear();
         this.ExecuteFilter(SLogicsCore.Character.Appliances,ShowType_Appliance,this.FInventories);
         this.FUIPage.SetupPage(this.FInventories.Count,this.FCurrentPageIndex);
         this.RenderInventoryCommon();
      }
      
      protected function RenderInventoryCommon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FCurrentPageIndex * BackPackSlotNum;
         _loc4_ = Math.min(_loc3_ + BackPackSlotNum,this.FInventories.Count);
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            this.FSlotsUserAssets[_loc5_].Context = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
            _loc5_++;
         }
         _loc1_ = _loc5_;
         while(_loc1_ < BackPackSlotNum)
         {
            this.FSlotsUserAssets[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function ExecuteFilter(param1:TInventories, param2:int, param3:TInventories) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<Function> = null;
         var _loc9_:Function = null;
         var _loc10_:Boolean = false;
         var _loc11_:TInventory = null;
         _loc8_ = this.FInventoryFilterFunctions[param2];
         _loc5_ = param1.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = true;
            _loc11_ = param1.GetInventoryByIndex(_loc4_);
            _loc7_ = int(_loc8_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc9_ = _loc8_[_loc6_];
               if(!_loc9_(_loc11_,this.FHero))
               {
                  _loc10_ = false;
                  break;
               }
               _loc6_++;
            }
            if(_loc10_)
            {
               param3.Add(_loc11_);
            }
            _loc4_++;
         }
      }
      
      protected function FilterEquipmentRequirementLevel(param1:TInventory, param2:THero) : Boolean
      {
         var _loc3_:TEquipment = null;
         _loc3_ = param1 as TEquipment;
         if(param2.Level >= _loc3_.RequirementLevel)
         {
            return true;
         }
         return false;
      }
      
      protected function FilterEquipmentRequirementCareer(param1:TInventory, param2:THero) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEquipment = null;
         _loc6_ = param1 as TEquipment;
         _loc4_ = int(_loc6_.RequirementCareer.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc6_.RequirementCareer[_loc3_];
            if(_loc5_ == 0 || param2.Profession == _loc5_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function FilterDecoration(param1:TEquipment, param2:THero) : Boolean
      {
         return true;
      }
      
      protected function FilterWakeUpRequipment(param1:TInventoryWake, param2:THero) : Boolean
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:Vector.<TInventory> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(param2 == SLogicsCore.Character.MainHero)
         {
            return false;
         }
         _loc3_ = param2.WakeEquipsNeed.GetIndexsByIDTemplate(param1.IDTemplate);
         _loc4_ = param2.WakeEquipsNeed.GetInventorysByIDTemplate(param1.IDTemplate);
         _loc6_ = int(_loc3_.length);
         if(_loc6_ == 0)
         {
            return false;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = (param2.WakeupStatus & 1 << _loc3_[_loc5_]) == 0;
            _loc8_ = _loc4_[_loc5_].RequirementLevel <= param2.Level;
            if(_loc7_ && _loc8_)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function FilterApplianceExperienceReel(param1:TAppliance, param2:THero) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = param1.Category;
         _loc4_ = param1.CategorySecond;
         if(_loc3_ == CATEGORY_Normal && _loc4_ == CATEGORYSECOND_ExperienceReel)
         {
            return true;
         }
         return false;
      }
      
      protected function CopyInventories(param1:TInventories, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.Add(param1.GetInventoryByIndex(_loc3_));
            _loc3_++;
         }
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotsUserAssets.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotsUserAssets[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function GetBinExp(param1:uint) : Number
      {
         var _loc2_:THeroExp = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,param1) as THeroExp;
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.AllExp.ToNumber();
      }
      
      protected function GetNextExp(param1:uint) : Number
      {
         var _loc2_:THeroExp = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,param1) as THeroExp;
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.NeedExp.ToNumber();
      }
      
      protected function ProcessorOnUseAppliance(param1:TInventory, param2:uint, param3:int = 0) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_UseAppliance);
         _loc5_ = _loc4_.Data;
         _loc5_.writeShort(1);
         _loc5_.writeUnsignedInt(param1.Identifier);
         _loc5_.writeUnsignedInt(param1.IDTemplate);
         _loc5_.writeShort(param2);
         _loc5_.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function GetShowType(param1:int) : int
      {
         if(this.FShowType != ShowType_Appliance)
         {
            return param1;
         }
         return ShowType_Appliance;
      }
      
      protected function BtnWakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FWakeOnClick != null)
         {
            this.FWakeOnClick();
         }
      }
      
      protected function SlotsOnQueryAdvancedEquip(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = false;
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
      
      public function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         if(param2 is TEquipment)
         {
            return;
         }
         _loc4_ = param2 as TInventory;
         param3.Value = _loc4_.Quantity.toString();
      }
      
      public function SetupSlotsQuerySubscript(param1:Vector.<TUISlot>, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param1[_loc3_].OnQuerySubscript = param2;
            _loc3_++;
         }
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         switch(param1)
         {
            case InventoryTab_Equipment:
               this.FShowType = this.FShowTypeRequest;
               break;
            case InventoryTab_Appliance:
               this.FShowType = ShowType_Appliance;
         }
         this.SetupSlotsQuerySubscript(this.FSlotsUserAssets,this.SlotsOnQuerySubscript);
         this.FCurrentPageIndex = 0;
         this.RenderSelector();
      }
      
      protected function SlotOnClick(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOnClick != null)
         {
            this.FOnSlotOnClick(this,param2);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderInventoryCommon();
      }
      
      protected function SlotsUserAssetsOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         _loc3_ = param2 as TInventory;
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               this.ProcessorSlotEquipmentOnClick(_loc3_ as TEquipment);
               break;
            case ShowType_Decoration:
               this.ProcessorSlotEquipmentOnClick(_loc3_ as TEquipment);
               break;
            case ShowType_WakeUp:
               this.ProcessorSlotWakeEquipOnClick(_loc3_ as TInventoryWake);
               break;
            case ShowType_Appliance:
               this.ProcessorSlotApplianceOnClick(_loc3_);
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this,_loc3_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_Equip);
      }
      
      protected function ProcessorSlotEquipmentOnClick(param1:TEquipment) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_Mount);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FHero.Identifier);
         _loc3_.writeUnsignedInt(param1.Identifier);
         _loc3_.writeUnsignedInt(param1.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorSlotApplianceOnClick(param1:TInventory) : void
      {
         var _loc2_:TArticle = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(this.FCharacter.MainHero == this.FHero)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_08));
            return;
         }
         if(this.FHero.RebirthLevel > this.FCharacter.MainHero.Level)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_09));
            return;
         }
         if(this.FHero.RebirthLevel == this.FCharacter.MainHero.Level)
         {
            _loc6_ = this.GetNextExp(this.FHero.RebirthLevel);
            _loc6_ = this.FRebirthData.CalNeedExpByNumber(_loc6_,this.FHero.RebirthNum);
            _loc6_ = Math.floor(_loc6_);
            _loc7_ = this.FHero.Experience.ToNumber();
            if(_loc7_ >= _loc6_ - 1)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_09));
               return;
            }
         }
         _loc5_ = this.GetMaxExp(Math.min(this.FCharacter.GetMainLevel(),this.FPlatformMaxLevel),this.FHero);
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.IDTemplate) as TArticle;
         _loc3_ = Math.ceil(_loc5_ / _loc2_.FunctionValue);
         this.FUIWindowEditor.Label = param1.Name;
         this.FUIWindowEditor.Quantity = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_13),param1.Quantity);
         _loc4_ = Math.min(_loc3_,param1.Quantity);
         this.FExperienceReelValue = _loc2_.FunctionValue;
         this.FUIWindowEditor.Value = _loc4_;
         this.FUIWindowEditor.Min = 1;
         this.FUIWindowEditor.Max = _loc4_;
         this.FUIWindowEditor.Context = param1;
         this.FUIWindowEditor.SetFocus();
         this.FUIWindowEditor.Visible = true;
      }
      
      protected function ProcessorSlotWakeEquipOnClick(param1:TInventoryWake) : void
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         if(this.FCharacter.MainHero == this.FHero)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_49));
            return;
         }
         _loc2_ = this.FHero.WakeEquipsNeed.GetIndexsByIDTemplate(param1.IDTemplate);
         _loc6_ = true;
         _loc5_ = int(_loc2_.length);
         if(_loc5_ == 0)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((this.FHero.WakeupStatus & 1 << _loc2_[_loc4_]) == 0)
            {
               _loc6_ = false;
               _loc3_ = _loc2_[_loc4_];
               break;
            }
            _loc4_++;
         }
         if(_loc6_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_50));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.HtmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_51),CONST_COMMON.QUALITYCOLOR_INDEX[param1.Quality].toString(16),param1.Name);
         SUtilityOverLayer.UIWindowConfirmation.Context = _loc3_;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.PerformPacket_CS_WakeUp_Dress;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function PerformPacket_CS_WakeUp_Dress(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         _loc4_ = int(param1.Context);
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_WakeUp_DressReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FHero.Identifier);
         _loc3_.writeUnsignedInt(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function WindowEditorOnOK(param1:Object) : void
      {
         var _loc2_:TInventory = null;
         _loc2_ = this.FUIWindowEditor.Context as TInventory;
         this.ProcessorOnUseAppliance(_loc2_,this.FUIWindowEditor.Value);
         if(this.FOnUseApplianceNotify != null)
         {
            this.FOnUseApplianceNotify(this,this.FExperienceReelValue * this.FUIWindowEditor.Value);
         }
         this.FUIWindowEditor.Context = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_UseStage);
      }
      
      protected function WindowEditorOnCancel(param1:Object) : void
      {
         this.FUIWindowEditor.Context = null;
      }
      
      private function MCShowTypeOnClick(param1:MouseEvent) : void
      {
         if(this.FIfShowAll)
         {
            this.FMCShowAll.gotoAndStop(ShowTypeFreamIndex_ShowSpecial);
         }
         else
         {
            this.FMCShowAll.gotoAndStop(ShowTypeFreamIndex_ShowAll);
         }
         this.FIfShowAll = !this.FIfShowAll;
         this.FCurrentPageIndex = 0;
         this.RenderSelector();
      }
      
      protected function SlotOnMove(param1:Object, param2:Object) : void
      {
         var _loc3_:TCollectionInventory = null;
         var _loc4_:TInventory = null;
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = param2 as TInventory;
         this.FInventoryMountedForTip = null;
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               _loc3_ = this.FHero.EquipmentsMounted;
               break;
            case ShowType_Decoration:
               _loc3_ = this.FHero.OrnamentsMounted;
               break;
            case ShowType_WakeUp:
            case ShowType_Appliance:
               this.FInventoryMountedForTip = null;
               SUtilityOverLayer.UIComponentsHintOnOver(this,param2);
               return;
         }
         _loc7_ = _loc3_.Capacity;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = _loc3_.GetInventoryByIndex(_loc6_);
            if(_loc4_ != null && _loc4_.CategorySecond == _loc5_.CategorySecond)
            {
               this.FInventoryMountedForTip = _loc4_;
               break;
            }
            _loc6_++;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,param2,this.FInventoryMountedForTip);
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,param2,this.FInventoryMountedForTip);
         this.FInventoryMountedForTip = null;
      }
      
      protected function GetMaxExp(param1:uint, param2:THero) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc3_ = this.GetBinExp(param1) - 1;
         _loc4_ = this.GetBinExp(param2.RebirthLevel - 1);
         _loc5_ = _loc3_ - _loc4_;
         _loc5_ = this.FRebirthData.CalNeedExpByNumber(_loc5_,param2.RebirthNum);
         _loc6_ = param2.Experience.ToNumber();
         return _loc5_ - _loc6_;
      }
      
      public function set OnSlotOnClick(param1:Function) : void
      {
         this.FOnSlotOnClick = param1;
      }
      
      public function set OnUseApplianceNotify(param1:Function) : void
      {
         this.FOnUseApplianceNotify = param1;
      }
      
      public function set WakeOnClick(param1:Function) : void
      {
         this.FWakeOnClick = param1;
      }
      
      public function get WakeOnClick() : Function
      {
         return this.FWakeOnClick;
      }
      
      public function SwitchInventory(param1:THero, param2:int) : void
      {
         this.FHero = param1;
         this.FShowTypeRequest = param2;
         this.FShowType = this.GetShowType(param2);
         this.FCurrentPageIndex = 0;
         this.RenderSelector();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FShowType = ShowType_Equipment;
         this.FIfShowAll = false;
         this.FMCShowAll.gotoAndStop(ShowTypeFreamIndex_ShowSpecial);
         this.FUITab.SwithTagManual(0);
         this.FInventories.Clear();
         _loc2_ = BackPackSlotNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotsUserAssets[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      public function Running() : void
      {
         this.UpdateSlots();
         this.FUIWindowEditor.Update();
      }
      
      public function Update() : void
      {
         this.RenderSelector();
      }
   }
}

