package Processors.Game.Lobby.Talisman
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Talisman.Panel.TProcessorWindowMake;
   import Processors.Game.Lobby.Talisman.Panel.TProcessorWindowProduct;
   import Processors.Game.Lobby.Talisman.Panel.TProcessorWindowTalismanEquip;
   import Processors.Game.Lobby.Talisman.Panel.TProcessorWindowTalismanTransition;
   import Processors.Game.Lobby.Talisman.Panel.TProcessorWindowTalismanUpgrade;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTalisman extends TProcessorLobbyWindow
   {
      
      public static const INDEX_MC_Tab_Use:uint = 0;
      
      public static const INDEX_MC_Tab_LevelUp:uint = 1;
      
      public static const INDEX_MC_Tab_Transition:uint = 2;
      
      public static const INDEX_MC_Tab_Product:uint = 3;
      
      public static const INDEX_MC_Tab_Make:uint = 4;
      
      protected static const TAB_NUM:int = 10;
      
      protected static const CAPACITY_MC_Tabs:uint = 10;
      
      protected var FHelpTips:THint;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FUITab:TUITab;
      
      protected var FMCTab:TUITab;
      
      protected var FUIPageHeroList:TUIPage;
      
      protected var FPageIndexHeroList:int;
      
      protected var FItemIndex:uint;
      
      protected var FRoleIndex:uint;
      
      protected var FMC_UIList:Array;
      
      protected var FProcessorWindowTalismanEquip:TProcessorWindowTalismanEquip;
      
      protected var FProcessorWindowTalismanUpgrade:TProcessorWindowTalismanUpgrade;
      
      protected var FProcessorWindowTalismanTransition:TProcessorWindowTalismanTransition;
      
      protected var FProcessorWindowProduct:TProcessorWindowProduct;
      
      protected var FProcessorWindowMake:TProcessorWindowMake;
      
      protected var FRoleTabs:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FUpgradeBin:TBins;
      
      protected var FLevelUpBin:TBins;
      
      protected var FUIComponentsHintOnOver:Function;
      
      protected var FUIComponentsHintOnOut:Function;
      
      protected var FOnEquip:Function;
      
      protected var FOnUpgrade:Function;
      
      protected var FOnTransition:Function;
      
      protected var FOnLevelUp:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnUpdateHerosBaseAttributeReq:Function;
      
      public function TProcessorWindowTalisman(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FMC_UIList = [];
         this.FProcessorWindowTalismanEquip = new TProcessorWindowTalismanEquip(this);
         this.FMC_UIList.push(this.FProcessorWindowTalismanEquip);
         this.FProcessorWindowTalismanUpgrade = new TProcessorWindowTalismanUpgrade(this);
         this.FMC_UIList.push(this.FProcessorWindowTalismanUpgrade);
         this.FProcessorWindowTalismanTransition = new TProcessorWindowTalismanTransition(this);
         this.FMC_UIList.push(this.FProcessorWindowTalismanTransition);
         this.FProcessorWindowProduct = new TProcessorWindowProduct(this);
         this.FMC_UIList.push(this.FProcessorWindowProduct);
         this.FProcessorWindowMake = new TProcessorWindowMake(this);
         this.FMC_UIList.push(this.FProcessorWindowMake);
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TALISMAN.RESOURCESID_Swf_Talisman);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Talisman") as MovieClip;
         addChild(_loc3_);
         this.FBtn_Close = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Help];
         _loc2_ = int(this.FMC_UIList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            addChild(this.FMC_UIList[_loc1_]);
            _loc1_++;
         }
         this.FUITab = new TUITab(this);
         addChild(this.FUITab);
         this.FMCTab = new TUITab(this);
         addChild(this.FMCTab);
         _loc2_ = int(CAPACITY_MC_Tabs);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc4_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.RoleTabOnSwitch;
         this.FUITab.Init();
         this.FUIPageHeroList = new TUIPage(this);
         this.FUIPageHeroList.ButtonPrevious.Substrate = _loc3_["MC_HeroPage"]["btn_left"];
         this.FUIPageHeroList.ButtonNext.Substrate = _loc3_["MC_HeroPage"]["btn_right"];
         this.FUIPageHeroList.LabelPage = _loc3_["MC_HeroPage"]["TF_Page"];
         this.FUIPageHeroList.PageSize = TAB_NUM;
         this.FUIPageHeroList.OnChangePage = this.HeroListPageOnChange;
         this.FUIPageHeroList.Init();
         _loc2_ = int(CONST_TALISMAN.RESOURCE_Link_MC_Tab_Vector.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[CONST_TALISMAN.RESOURCE_Link_MC_Tab_Vector[_loc1_]];
            this.FMCTab.SetTabByIndex(_loc4_,_loc1_);
            _loc1_++;
         }
         this.FMCTab.OnSwitch = this.ItemTabOnSwitch;
         this.FMCTab.Init();
         this.FUpgradeBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TreasureUpgrade);
         this.FLevelUpBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TreasureLevelup);
         this.FProcessorWindowTalismanEquip.SlotOnClick = this.FOnEquip;
         this.FProcessorWindowTalismanEquip.OnInventoryOver = this.FUIComponentsHintOnOver;
         this.FProcessorWindowTalismanEquip.OnInventoryOut = this.FUIComponentsHintOnOut;
         this.FProcessorWindowTalismanEquip.OnEffectText = OnEffectText;
         this.FProcessorWindowTalismanEquip.OnEffectHtmlText = OnEffectHtmlText;
         this.FProcessorWindowTalismanUpgrade.Bin = this.FUpgradeBin;
         this.FProcessorWindowTalismanUpgrade.OnUpgrade = this.FOnUpgrade;
         this.FProcessorWindowTalismanUpgrade.OnInventoryOver = this.FUIComponentsHintOnOver;
         this.FProcessorWindowTalismanUpgrade.OnInventoryOut = this.FUIComponentsHintOnOut;
         this.FProcessorWindowTalismanUpgrade.OnEffectText = OnEffectText;
         this.FProcessorWindowTalismanTransition.TransitionOnClick = this.FOnTransition;
         this.FProcessorWindowTalismanTransition.OnInventoryOver = this.FUIComponentsHintOnOver;
         this.FProcessorWindowTalismanTransition.OnInventoryOut = this.FUIComponentsHintOnOut;
         this.FProcessorWindowTalismanTransition.OnEffectText = OnEffectText;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_TreasureView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_TreasureView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function SetupHeroListPage(param1:int, param2:int) : void
      {
         this.FUIPageHeroList.TotalQuantity = param1;
         this.FUIPageHeroList.Update();
         this.FUIPageHeroList.PageIndex = param2;
      }
      
      protected function RoleTabOnSwitch(param1:Object) : void
      {
         if(param1 is int)
         {
            this.FRoleIndex = param1 as int;
         }
         this.FRoleIndex += this.FPageIndexHeroList * TAB_NUM;
         this.UpdateRole(this.FRoleIndex,this.FItemIndex);
      }
      
      protected function ItemTabOnSwitch(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 is int)
         {
            this.FItemIndex = param1 as int;
            _loc3_ = this.FCharacter.Heros.Count % TAB_NUM;
            if(this.FItemIndex > 0)
            {
               if(this.FUIPageHeroList.TotalPage == this.FPageIndexHeroList + 1 && _loc3_ != 0)
               {
                  this.FUITab.SetTabShowByIndex(this.FCharacter.Heros.Count % TAB_NUM);
                  this.FUITab.SetTabCaptionByIndex(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Backpack),this.FCharacter.Heros.Count % TAB_NUM,16775109);
               }
               _loc2_ = this.FCharacter.Heros.Count + 1;
            }
            else
            {
               if(this.FUIPageHeroList.TotalPage == this.FPageIndexHeroList + 1)
               {
                  this.FUITab.SetTabHideByIndex(_loc3_);
               }
               this.HeroListPageOnChange(this,0);
               _loc2_ = uint(this.FCharacter.Heros.Count);
            }
         }
         this.FUIPageHeroList.TotalQuantity = _loc2_;
         this.FUIPageHeroList.Update();
         this.FUIPageHeroList.PageIndex = this.FPageIndexHeroList;
         this.UpdateUI(this.FItemIndex);
         this.UpdateRole(this.FRoleIndex,this.FItemIndex);
      }
      
      protected function UpdateUI(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = this.FMC_UIList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == param1)
            {
               this.FMC_UIList[_loc2_].visible = true;
            }
            else
            {
               this.FMC_UIList[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function UpdateRole(param1:uint, param2:uint) : void
      {
         switch(param2)
         {
            case INDEX_MC_Tab_Use:
            case INDEX_MC_Tab_LevelUp:
            case INDEX_MC_Tab_Transition:
               this.FMC_UIList[param2].Update(param1,param2);
               break;
            case INDEX_MC_Tab_Product:
               (this.FMC_UIList[param2] as TProcessorWindowProduct).Show();
               break;
            case INDEX_MC_Tab_Make:
               (this.FMC_UIList[param2] as TProcessorWindowMake).Show();
         }
      }
      
      protected function UpdateRoleTab() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         this.FRoleTabs = this.FCharacter.Heros.Count;
         _loc4_ = int(CAPACITY_MC_Tabs);
         _loc1_ = this.FPageIndexHeroList * TAB_NUM;
         _loc2_ = _loc1_ + TAB_NUM;
         _loc2_ = _loc2_ > this.FRoleTabs ? int(this.FRoleTabs) : _loc2_;
         _loc3_ = _loc1_;
         _loc3_ = _loc1_;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.FCharacter.Heros.GetHeroByIndex(_loc3_);
            _loc6_ = CONST_COMMON.QUALITYCOLOR_INDEX[_loc5_.Quality + TUtilityLobby.GetConfigValue(60104009)[_loc5_.AddQuality - 1 < 0 ? 0 : _loc5_.AddQuality - 1]];
            this.FUITab.SetTabShowByIndex(_loc3_ - _loc1_);
            this.FUITab.SetTabCaptionByIndex(_loc5_.Name,_loc3_ - _loc1_,_loc6_);
            _loc3_++;
         }
         if(this.FItemIndex > 0)
         {
            if(_loc3_ - _loc1_ < TAB_NUM)
            {
               this.FUITab.SetTabShowByIndex(_loc3_ - _loc1_);
               this.FUITab.SetTabCaptionByIndex(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_24),_loc3_ - _loc1_,16775109);
               _loc3_++;
            }
            if(this.FRoleTabs % TAB_NUM == 0)
            {
               this.SetupHeroListPage(SLogicsCore.Character.Heros.Count + 1,this.FPageIndexHeroList);
            }
         }
         _loc3_ -= _loc1_;
         while(_loc3_ < CAPACITY_MC_Tabs)
         {
            this.FUITab.SetTabHideByIndex(_loc3_);
            _loc3_++;
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         if(!this.FBtn_Close.hasEventListener(MouseEvent.CLICK))
         {
            this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseHandler,false,0,true);
         }
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      private function HeroListPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndexHeroList = param2;
         this.UpdateRoleTab();
         this.FUITab.SwithTagManual(0);
         this.RoleTabOnSwitch(0);
      }
      
      protected function BtnCloseHandler(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Treasure);
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
      
      public function get OnEquip() : Function
      {
         return this.FOnEquip;
      }
      
      public function set OnEquip(param1:Function) : void
      {
         this.FOnEquip = param1;
      }
      
      public function get OnUpgrade() : Function
      {
         return this.FOnUpgrade;
      }
      
      public function set OnUpgrade(param1:Function) : void
      {
         this.FOnUpgrade = param1;
      }
      
      public function get OnTransition() : Function
      {
         return this.FOnTransition;
      }
      
      public function set OnTransition(param1:Function) : void
      {
         this.FOnTransition = param1;
      }
      
      public function get OnLevelUp() : Function
      {
         return this.FOnLevelUp;
      }
      
      public function set OnLevelUp(param1:Function) : void
      {
         this.FOnLevelUp = param1;
      }
      
      public function get UIComponentsHintOnOver() : Function
      {
         return this.FUIComponentsHintOnOver;
      }
      
      public function set UIComponentsHintOnOver(param1:Function) : void
      {
         this.FUIComponentsHintOnOver = param1;
      }
      
      public function get UIComponentsHintOnOut() : Function
      {
         return this.FUIComponentsHintOnOut;
      }
      
      public function set UIComponentsHintOnOut(param1:Function) : void
      {
         this.FUIComponentsHintOnOut = param1;
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
      
      public function get OnUpdateHerosBaseAttributeReq() : Function
      {
         return this.FOnUpdateHerosBaseAttributeReq;
      }
      
      public function set OnUpdateHerosBaseAttributeReq(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeReq = param1;
      }
      
      public function set HintOver(param1:Function) : void
      {
         this.FProcessorWindowTalismanUpgrade.HintOnOver = param1;
      }
      
      public function set HintOut(param1:Function) : void
      {
         this.FProcessorWindowTalismanUpgrade.HintOnOut = param1;
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FProcessorWindowTalismanEquip.Load();
         this.FProcessorWindowTalismanUpgrade.Load();
         this.FProcessorWindowTalismanTransition.Load();
         this.FProcessorWindowProduct.Load();
         this.FProcessorWindowMake.Load();
      }
      
      public function Init() : void
      {
      }
      
      public function Update(param1:int = -1, param2:int = -1) : void
      {
         if(param1 > -1)
         {
            if(param1 > 0)
            {
               this.SetupHeroListPage(SLogicsCore.Character.Heros.Count + 1,0);
            }
            else
            {
               this.SetupHeroListPage(SLogicsCore.Character.Heros.Count,0);
            }
         }
         if(param1 > -1)
         {
            this.FItemIndex = param1;
            this.FMCTab.SwithTagManual(this.FItemIndex);
         }
         if(param2 > -1)
         {
            this.FRoleIndex = param2;
            this.FUITab.SwithTagManual(this.FRoleIndex);
         }
         this.UpdateRoleTab();
         this.UpdateUI(this.FItemIndex);
         this.UpdateRole(this.FRoleIndex,this.FItemIndex);
      }
      
      public function UpdateEquip() : void
      {
         this.FProcessorWindowTalismanEquip.UpdateEquipSlots();
      }
      
      public function UpdateCharacterBaseAttribute() : void
      {
         this.FProcessorWindowTalismanEquip.UpdateCharacterBaseAttributes();
      }
      
      public function UpdateUpgradeEquip() : void
      {
         this.FProcessorWindowTalismanUpgrade.UpdateUpgradeEquip();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FMC_UIList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_UIList[_loc1_].Reset();
            _loc1_++;
         }
         this.FPageIndexHeroList = 0;
      }
      
      public function SetBtnLock() : void
      {
         this.FMC_UIList[this.FItemIndex].SetBtnLock(true);
      }
      
      public function ProductSuccess() : void
      {
         this.FProcessorWindowProduct.Update();
      }
      
      public function MakeSuccess() : void
      {
         this.FProcessorWindowMake.Update();
      }
   }
}

