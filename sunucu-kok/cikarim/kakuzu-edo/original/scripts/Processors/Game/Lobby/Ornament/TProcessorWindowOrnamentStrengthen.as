package Processors.Game.Lobby.Ornament
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TCollectionInventory;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Ornament.Component.TUIAdvanced;
   import Processors.Game.Lobby.Ornament.Component.TUIStrengthen;
   import Processors.Game.Lobby.Talisman.TSingleEquip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_ORNAMENT;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TProcessorWindowOrnamentStrengthen extends TProcessorLobbyWindow
   {
      
      protected static const COUNT_TAB_HEROLIST:uint = 9;
      
      protected static const COUNT_TAB_UIWINDOW:uint = 2;
      
      protected static const COUNT_HERO_MaxList:uint = 9;
      
      protected static const TYPE_UIWINDOW_STRENGTHEN:uint = CONST_ORNAMENT.TYPE_UIWINDOW_STRENGTHEN;
      
      protected static const TYPE_UIWINDOW_ADVANCED:uint = CONST_ORNAMENT.TYPE_UIWINDOW_ADVANCED;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FMC_Scene:Sprite;
      
      protected var FMC_Main:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnHelp:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FUITabHeroList:TUITab;
      
      protected var FMC_TabHeroList:Sprite;
      
      protected var FUIPage:TUIPage;
      
      protected var FMC_Page:Sprite;
      
      protected var FMC_Scroll:MovieClip;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FWindowAdvanced:TUIAdvanced;
      
      protected var FWindowStrengthen:TUIStrengthen;
      
      protected var FTabIndex:int;
      
      protected var FTabHeroListIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FMC_SingleEquipList:Vector.<TSingleEquip>;
      
      protected var FCurrentClickSingleEquip:TSingleEquip;
      
      protected var FCurrentShowTagIndex:int;
      
      protected var FCurrentShowEquipmentBag:TInventories;
      
      protected var FCurrentShowOrnament:TEquipment;
      
      protected var FCurrentHero:THero;
      
      protected var FCurrentStateStore:int;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnBtnCloseClick:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowOrnamentStrengthen(param1:TUIComponent)
      {
         super(param1);
         this.FTabIndex = 0;
         this.FTabHeroListIndex = 0;
         this.FPageIndex = 0;
         this.FCurrentShowTagIndex = -1;
         this.FMC_SingleEquipList = new Vector.<TSingleEquip>();
         this.FCurrentShowEquipmentBag = new TInventories();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORNAMENT.RESOURCESID_Swf_OrnamentStrengthen);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FMC_SingleEquipList != null && this.FMC_SingleEquipList.length > 0)
         {
            _loc2_ = int(this.FMC_SingleEquipList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FMC_SingleEquipList[_loc1_].UpdateSingleEquip();
               _loc1_++;
            }
         }
         if(this.FWindowAdvanced.Visible)
         {
            this.FWindowAdvanced.UpdateSlot();
         }
         if(this.FWindowStrengthen.Visible)
         {
            this.FWindowStrengthen.UpdateSlot();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitWindow();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORNAMENT.RESOURCE_ClassName_MC_OrnamentStrengthen) as Sprite;
         addChild(this.FMC_Scene);
         this.FMC_Main = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_MC_Main];
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMC_Main[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.FOnBtnCloseClick;
         this.FBtnHelp = new TUIButton();
         this.FBtnHelp.Substrate = this.FMC_Main[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FUITab = new TUITab(this);
         _loc2_ = int(COUNT_TAB_UIWINDOW);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMC_Main[CONST_ORNAMENT.RESOURCE_Link_Btn_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.UITabOnSwitch;
         this.FUITab.Init();
         this.FMC_TabHeroList = this.FMC_Main[CONST_ORNAMENT.RESOURCE_Link_MC_TabList];
         this.FUITabHeroList = new TUITab(this);
         _loc2_ = int(COUNT_TAB_HEROLIST);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITabHeroList.SetTabByIndex(this.FMC_TabHeroList[CONST_ORNAMENT.RESOURCE_Link_Btn_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITabHeroList.OnSwitch = this.UITabHeroListOnSwitch;
         this.FUITabHeroList.Init();
         this.FMC_Page = this.FMC_Main[CONST_ORNAMENT.RESOURCE_Link_MC_HeroPage];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonNext.Substrate = this.FMC_Page[CONST_ORNAMENT.RESOURCE_Link_Btn_Right];
         this.FUIPage.ButtonPrevious.Substrate = this.FMC_Page[CONST_ORNAMENT.RESOURCE_Link_Btn_Left];
         this.FUIPage.LabelPage = this.FMC_Page[CONST_ORNAMENT.RESOURCE_Link_TF_Page];
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.PageSize = COUNT_TAB_HEROLIST;
         this.FUIPage.Init();
         this.FMC_Scroll = this.FMC_Main[CONST_ORNAMENT.RESOURCE_Link_MC_List];
         this.FUIScrollBar = new TScrollBar(this.FMC_Scroll,336,false,0,56);
         this.FUIScrollBar.ScrollToUp();
         this.FWindowAdvanced = new TUIAdvanced(this);
         this.FWindowAdvanced.OnBtnOKClick = this.BtnOkOnClick;
         this.FWindowAdvanced.OnSlotOver = this.ProcessorOnSlotOver;
         this.FWindowAdvanced.OnSlotOut = this.ProcessorOnSlotOut;
         this.FWindowAdvanced.OnEffectText = FOnEffectText;
         this.FWindowAdvanced.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FWindowAdvanced.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FWindowAdvanced.ResourcesPerform_UIDispatch(this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_MC_UIAdvanced],TYPE_UIWINDOW_ADVANCED);
         this.FWindowAdvanced.Hide();
         this.FWindowStrengthen = new TUIStrengthen(this);
         this.FWindowStrengthen.OnBtnOKClick = this.BtnOkOnClick;
         this.FWindowStrengthen.OnSlotOver = this.ProcessorOnSlotOver;
         this.FWindowStrengthen.OnSlotOut = this.ProcessorOnSlotOut;
         this.FWindowStrengthen.OnEffectText = FOnEffectText;
         this.FWindowStrengthen.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FWindowStrengthen.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FWindowStrengthen.ResourcesPerform_UIDispatch(this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_MC_UIStrengthen],TYPE_UIWINDOW_STRENGTHEN);
         this.FWindowStrengthen.Hide();
      }
      
      protected function SelectEquipmentsIntoBag(param1:int, param2:TInventories) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TCollectionInventory = null;
         var _loc6_:TInventory = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc8_ = param1 + this.FPageIndex * COUNT_HERO_MaxList;
         if(_loc8_ < SLogicsCore.Character.Heros.Count)
         {
            _loc3_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc8_);
            _loc5_ = _loc3_.OrnamentsMounted;
            param2.Clear();
            _loc4_ = 0;
            while(_loc4_ < _loc5_.Capacity)
            {
               _loc6_ = _loc5_.GetInventoryByIndex(_loc4_);
               if(_loc6_ != null)
               {
                  param2.Add(_loc6_);
               }
               _loc4_++;
            }
         }
         else
         {
            _loc7_ = int(SLogicsCore.Character.Ornaments.Count);
            param2.Clear();
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               _loc6_ = SLogicsCore.Character.Ornaments.GetInventoryByIndex(_loc4_);
               if(_loc6_ != null)
               {
                  param2.Add(_loc6_);
               }
               _loc4_++;
            }
         }
      }
      
      protected function UpdateUIHeroList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeros = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         this.HideAndShowTagByHeroNum(SLogicsCore.Character.Heros.Count + 1);
         _loc3_ = SLogicsCore.Character.Heros;
         _loc3_.Sort();
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < COUNT_HERO_MaxList)
         {
            _loc5_ = _loc1_ + this.FPageIndex * COUNT_HERO_MaxList;
            if(_loc5_ == _loc2_)
            {
               break;
            }
            _loc4_ = _loc3_.GetHeroByIndex(_loc5_);
            this.FUITabHeroList.SetTabCaptionByIndex(_loc4_.Name,_loc1_,QUALITYCOLOR_INDEX[_loc4_.Quality]);
            _loc1_++;
         }
         if(_loc1_ < COUNT_HERO_MaxList)
         {
            this.FUITabHeroList.SetTabCaptionByIndex(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_36),_loc1_,16775109);
         }
         this.UpdateUIPage(SLogicsCore.Character.Heros.Count + 1,this.FPageIndex);
      }
      
      protected function HideAndShowTagByHeroNum(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FPageIndex;
         if(param1 > COUNT_HERO_MaxList)
         {
            _loc5_ = int(uint(param1 / COUNT_HERO_MaxList));
            if(_loc3_ == _loc5_)
            {
               _loc4_ = param1 - _loc5_ * COUNT_HERO_MaxList;
            }
            else
            {
               _loc4_ = int(COUNT_HERO_MaxList);
            }
         }
         else
         {
            _loc4_ = param1;
         }
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < COUNT_HERO_MaxList)
         {
            if(_loc2_ < _loc4_)
            {
               this.FUITabHeroList.SetTabShowByIndex(_loc2_);
            }
            else
            {
               this.FUITabHeroList.SetTabHideByIndex(_loc2_);
            }
            _loc2_++;
         }
      }
      
      protected function UpdateItemList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FMC_SingleEquipList.length = 0;
         this.FCurrentClickSingleEquip = null;
         this.FUIScrollBar.Clear();
         _loc5_ = this.FCurrentShowEquipmentBag.Count;
         if(_loc5_ < CONST_ORNAMENT.MinSingleEquipmentNum)
         {
            _loc2_ = int(CONST_ORNAMENT.MinSingleEquipmentNum);
         }
         else
         {
            _loc2_ = _loc5_;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
            _loc3_.StubReferences.Reference(this);
            _loc3_.OnClick = this.EquipmentClick;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc3_.OnOut = this.ProcessorOnSlotOut;
            _loc3_.OnOver = this.ProcessorOnSlotOver;
            this.FUIScrollBar.AddItem(_loc3_);
            this.FMC_SingleEquipList.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function UpdateEquipmentInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:int = 0;
         var _loc5_:TSingleEquip = null;
         var _loc6_:String = null;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_61);
         _loc4_ = this.FCurrentShowEquipmentBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = this.FCurrentShowEquipmentBag.GetInventoryByIndex(_loc1_) as TEquipment;
            _loc5_ = this.FMC_SingleEquipList[_loc1_];
            _loc5_.SetEquip(_loc3_,_loc3_.Name,_loc6_ + _loc3_.UpgradingLevel,_loc3_.Quality);
            _loc1_++;
         }
      }
      
      protected function EquipmentClick(param1:Object, param2:Object) : void
      {
         var _loc3_:THeros = null;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TSingleEquip = null;
         _loc6_ = param1 as TSingleEquip;
         _loc5_ = param2 as TEquipment;
         this.FCurrentShowOrnament = _loc5_;
         if(this.FCurrentClickSingleEquip != null)
         {
            this.FCurrentClickSingleEquip.BClick = false;
         }
         this.FCurrentClickSingleEquip = _loc6_;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc4_ = 0;
         if(_loc3_.Count > this.FCurrentShowTagIndex + this.FPageIndex * COUNT_HERO_MaxList)
         {
            _loc4_ = _loc3_.GetHeroByIndex(this.FCurrentShowTagIndex + this.FPageIndex * COUNT_HERO_MaxList).Identifier;
         }
         this.SendShowEquipment(_loc5_,_loc4_);
      }
      
      protected function SendShowEquipment(param1:TEquipment, param2:uint) : void
      {
         switch(this.FTabIndex)
         {
            case TYPE_UIWINDOW_STRENGTHEN:
               this.FWindowStrengthen.ProcessorUpdateUI(param1,param2);
               break;
            case TYPE_UIWINDOW_ADVANCED:
               this.FWindowAdvanced.ProcessorUpdateUI(param1,param2);
         }
      }
      
      protected function ChangeWindows() : void
      {
         switch(this.FTabIndex)
         {
            case TYPE_UIWINDOW_STRENGTHEN:
               this.FWindowStrengthen.Show();
               this.FWindowAdvanced.Hide();
               break;
            case TYPE_UIWINDOW_ADVANCED:
               this.FWindowStrengthen.Hide();
               this.FWindowAdvanced.Show();
         }
      }
      
      protected function UpdateUIWindows() : void
      {
         var _loc1_:uint = 0;
         if(this.FCurrentShowOrnament == null)
         {
            return;
         }
         if(this.FCurrentShowTagIndex + this.FPageIndex * COUNT_HERO_MaxList >= SLogicsCore.Character.Heros.Count)
         {
            _loc1_ = 0;
         }
         else
         {
            _loc1_ = uint(SLogicsCore.Character.Heros.GetHeroByIndex(this.FPageIndex * COUNT_TAB_HEROLIST + this.FCurrentShowTagIndex).Identifier);
         }
         switch(this.FTabIndex)
         {
            case TYPE_UIWINDOW_STRENGTHEN:
               this.FWindowStrengthen.ProcessorUpdateUI(this.FCurrentShowOrnament,_loc1_);
               break;
            case TYPE_UIWINDOW_ADVANCED:
               this.FWindowAdvanced.ProcessorUpdateUI(this.FCurrentShowOrnament,_loc1_);
         }
      }
      
      protected function UpdateUIPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function DoClear() : void
      {
         if(this.FWindowAdvanced != null)
         {
            this.FWindowAdvanced.Clear();
         }
         if(this.FWindowStrengthen != null)
         {
            this.FWindowStrengthen.Clear();
         }
         if(this.FUIScrollBar != null)
         {
            this.FUIScrollBar.Clear();
         }
         this.FTabIndex = 0;
         this.FTabHeroListIndex = 0;
         this.FPageIndex = 0;
         this.FCurrentShowTagIndex = -1;
         if(this.FUITab != null)
         {
            this.FUITab.SwithTagManual(0);
         }
         if(this.FUITabHeroList != null)
         {
            this.FUITabHeroList.SwithTagManual(0);
         }
         this.FCurrentShowOrnament = null;
      }
      
      protected function BtnOkOnClick(param1:uint, param2:TEquipment, param3:uint) : void
      {
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(param1,param2,param3);
         }
      }
      
      protected function UITabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.SelectEquipmentsIntoBag(0,this.FCurrentShowEquipmentBag);
         this.ChangeWindows();
      }
      
      protected function UITabHeroListOnSwitch(param1:Object) : void
      {
         this.FWindowStrengthen.Clear();
         this.FWindowAdvanced.Clear();
         this.FTabHeroListIndex = param1 as int;
         this.SelectEquipmentsIntoBag(this.FTabHeroListIndex,this.FCurrentShowEquipmentBag);
         this.UpdateItemList();
         this.UpdateEquipmentInfor();
         this.FCurrentShowTagIndex = this.FTabHeroListIndex;
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUIHeroList();
         this.SelectEquipmentsIntoBag(0,this.FCurrentShowEquipmentBag);
         this.UpdateItemList();
         this.UpdateEquipmentInfor();
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnBtnCloseClick() : Function
      {
         return this.FOnBtnCloseClick;
      }
      
      public function set OnBtnCloseClick(param1:Function) : void
      {
         this.FOnBtnCloseClick = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function UpdateUI() : void
      {
         if(this.FCurrentShowTagIndex == -1)
         {
            this.UpdateUIHeroList();
            this.UITabOnSwitch(0);
            this.UITabHeroListOnSwitch(0);
         }
         else
         {
            this.UpdateUIHeroList();
            this.UITabHeroListOnSwitch(this.FCurrentShowTagIndex);
            if(this.FCurrentClickSingleEquip != null)
            {
               this.FCurrentClickSingleEquip.BClick = true;
            }
            this.UpdateUIWindows();
         }
      }
      
      public function Show() : void
      {
         this.Visible = true;
         if(this.FMC_Scene != null)
         {
            this.FMC_Scene.visible = true;
         }
         this.UpdateUI();
      }
      
      public function Hide() : void
      {
         this.Visible = false;
         if(this.FMC_Scene != null)
         {
            this.FMC_Scene.visible = false;
         }
         this.DoClear();
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

