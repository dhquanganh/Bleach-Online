package Processors.Game.Lobby.Smithy
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Smithy.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowSmithy extends TProcessorLobbyWindow
   {
      
      protected static const TAB_INDEX_STRENGTHEN:int = 0;
      
      protected static const TAB_INDEX_REFINED:int = 1;
      
      protected static const TAB_INDEX_INHERIT:int = 2;
      
      protected static const TAB_INDEX_ADVANCED:int = 3;
      
      protected static const TAB_INDEX_GETSKILL:int = 4;
      
      protected static const TAB_INDEX_FLUSHSPIRIT:int = 5;
      
      protected static const TAB_INDEX_PUNCH:int = 6;
      
      protected static const LAYER_X:int = 112;
      
      protected static const LAYER_Y:int = 87;
      
      protected static const LAYER_WIDTH:int = 501;
      
      protected static const LAYER_HEIGHT:int = 347;
      
      protected var FHelpTips:THint;
      
      protected var FUI_Smithy:MovieClip;
      
      protected var FProcessorWindowEquipShow:TProcessorWindowEquipShow;
      
      protected var FProcessorWindowStrengthen:TProcessorWindowStrengthen;
      
      protected var FProcessorWindowRefined:TProcessorWindowRefined;
      
      protected var FProcessorWindowInherit:TProcessorWindowInherit;
      
      protected var FProcessorWindowAdvanced:TProcessorWindowAdvanced;
      
      protected var FProcessorWindowGetSkill:TProcessorWindowGetSkill;
      
      protected var FProcessorWindowFlushSpirit:TProcessorWindowFlushSpirit;
      
      protected var FProcessorWindowPunch:TProcessorWindowPunch;
      
      protected var FProcessorLobbyWindows:Vector.<TProcessorLobbyWindow>;
      
      protected var FTabs:TUITab;
      
      protected var FCurrentVisibleWindowIndex:int;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FTabIndex:uint;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FEquipmentAdvanced:Function;
      
      public function TProcessorWindowSmithy(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FProcessorWindowEquipShow = new TProcessorWindowEquipShow(this);
         this.FProcessorWindowEquipShow.visible = true;
         this.FProcessorWindowStrengthen = new TProcessorWindowStrengthen(this);
         this.FProcessorWindowRefined = new TProcessorWindowRefined(this);
         this.FProcessorWindowInherit = new TProcessorWindowInherit(this);
         this.FProcessorWindowAdvanced = new TProcessorWindowAdvanced(this);
         this.FProcessorWindowAdvanced.OnGoto = this.OnClickGoto;
         this.FProcessorWindowAdvanced.OnAdvanced = this.ProcessorOnAdvanced;
         this.FProcessorWindowGetSkill = new TProcessorWindowGetSkill(this);
         this.FProcessorWindowFlushSpirit = new TProcessorWindowFlushSpirit(this);
         this.FProcessorWindowPunch = new TProcessorWindowPunch(this);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SMITHY.RESOURCESID_SMITHY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc5_:BitmapData = null;
         var _loc6_:Bitmap = null;
         var _loc7_:TConfigValue = null;
         this.FUI_Smithy = TUtilityReflection.CreateDisplayObjectInstance(CONST_SMITHY.RESOURCESID_ClassName_Strengthen) as MovieClip;
         addChild(this.FUI_Smithy);
         addChild(this.FProcessorWindowStrengthen);
         this.FUI_Smithy.gotoAndStop("FrameStrengthen");
         this.FProcessorWindowStrengthen.Perform_UIDispatch(this.FUI_Smithy["UIStrengthen"]);
         addChild(this.FProcessorWindowEquipShow);
         this.FProcessorWindowEquipShow.Perform_UIDispatch(this.FUI_Smithy["MainUI"]);
         addChild(this.FProcessorWindowRefined);
         this.FUI_Smithy.gotoAndStop("FrameRefined");
         this.FProcessorWindowRefined.Perform_UIDispatch(this.FUI_Smithy["UIRefined"]);
         addChild(this.FProcessorWindowInherit);
         this.FUI_Smithy.gotoAndStop("FrameInherit");
         this.FProcessorWindowInherit.Perform_UIDispatch(this.FUI_Smithy["UIInherit"]);
         addChild(this.FProcessorWindowAdvanced);
         this.FUI_Smithy.gotoAndStop("FrameAdvanced");
         this.FProcessorWindowAdvanced.Perform_UIDispatch(this.FUI_Smithy["UIAdvanced"]);
         addChild(this.FProcessorWindowGetSkill);
         this.FUI_Smithy.gotoAndStop("FrameGetSkill");
         this.FProcessorWindowGetSkill.Perform_UIDispatch(this.FUI_Smithy["UIGetSkill"]);
         addChild(this.FProcessorWindowFlushSpirit);
         this.FUI_Smithy.gotoAndStop("FrameFlushSpirit");
         this.FProcessorWindowFlushSpirit.Perform_UIDispatch(this.FUI_Smithy["UIFlushSpirit"]);
         addChild(this.FProcessorWindowPunch);
         this.FUI_Smithy.gotoAndStop("FramePunch");
         this.FProcessorWindowPunch.Perform_UIDispatch(this.FUI_Smithy["UIPunch"]);
         this.FProcessorLobbyWindows = new Vector.<TProcessorLobbyWindow>();
         this.FProcessorLobbyWindows.push(this.FProcessorWindowStrengthen);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowRefined);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowInherit);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowAdvanced);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowGetSkill);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowFlushSpirit);
         this.FProcessorLobbyWindows.push(this.FProcessorWindowPunch);
         this.FTabs = new TUITab(this);
         _loc3_ = CONST_SMITHY.Tab_Names;
         _loc4_ = int(_loc3_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = this.FUI_Smithy[_loc3_[_loc2_]];
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = false;
            this.FTabs.SetTabByIndex(_loc1_,_loc2_);
            _loc2_++;
         }
         this.FTabs.OnSwitch = this.TabClick;
         this.FTabs.Init();
         this.FBtn_Close = this.FUI_Smithy["MainUI"]["StrengthenClose"];
         this.FBtn_Help = this.FUI_Smithy["MainUI"]["StrengthenHelp"];
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_StrengthenView,this.FUI_Smithy);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_StrengthenView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FProcessorWindowEquipShow.Perform_UILocation();
         this.FProcessorWindowEquipShow.OnEquipmentClick = this.OnEquipmentClick;
         this.FProcessorWindowEquipShow.OnChangeHeroPage = this.OnChangeHeroPage;
         this.FProcessorWindowStrengthen.Perform_UILocation();
         this.FProcessorWindowRefined.Perform_UILocation();
         this.FProcessorWindowInherit.Perform_UILocation();
         this.FProcessorWindowPunch.Perform_UILocation();
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.SwitchTab(TAB_INDEX_STRENGTHEN);
         super.ResourcesPerform_UILocations();
      }
      
      protected function SwitchTab(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         _loc3_ = 0;
         while(_loc3_ < CONST_SMITHY.SMITHY_TAB_NUM)
         {
            this.FProcessorLobbyWindows[_loc3_].visible = false;
            _loc5_ = this.FProcessorLobbyWindows[_loc3_];
            _loc5_.Reset();
            _loc3_++;
         }
         if(param1 == TAB_INDEX_GETSKILL)
         {
            this.FProcessorWindowEquipShow.CurrentState = TProcessorWindowEquipShow.State_SelectJustArm;
         }
         else
         {
            this.FProcessorWindowEquipShow.CurrentState = TProcessorWindowEquipShow.State_SelectAllEquit;
         }
         this.FCurrentVisibleWindowIndex = param1;
         this.FProcessorLobbyWindows[this.FCurrentVisibleWindowIndex].visible = true;
         this.Update();
      }
      
      protected function OnEquipmentClick(param1:TEquipment, param2:uint) : void
      {
         switch(this.FCurrentVisibleWindowIndex)
         {
            case TAB_INDEX_STRENGTHEN:
               this.FProcessorWindowStrengthen.ReciveEquipment(param1,param2);
               break;
            case TAB_INDEX_REFINED:
               this.FProcessorWindowRefined.ReciveEquipment(param1,param2);
               this.FProcessorWindowRefined.Update();
               break;
            case TAB_INDEX_INHERIT:
               this.FProcessorWindowInherit.ReciveEquipment(param1,param2);
               this.FProcessorWindowInherit.Update();
               break;
            case TAB_INDEX_ADVANCED:
               this.FProcessorWindowAdvanced.UpdateUI(param1,param2);
               break;
            case TAB_INDEX_GETSKILL:
               this.FProcessorWindowGetSkill.UpdateUI(param1,param2);
               break;
            case TAB_INDEX_FLUSHSPIRIT:
               this.FProcessorWindowFlushSpirit.ReciveEquipment(param1,param2);
               break;
            case TAB_INDEX_PUNCH:
               this.FProcessorWindowPunch.ReciveEquipment(param1,param2);
         }
      }
      
      protected function OnChangeHeroPage() : void
      {
         switch(this.FCurrentVisibleWindowIndex)
         {
            case TAB_INDEX_STRENGTHEN:
               this.FProcessorWindowStrengthen.Reset();
               break;
            case TAB_INDEX_REFINED:
               this.FProcessorWindowRefined.Reset();
               break;
            case TAB_INDEX_INHERIT:
            case TAB_INDEX_ADVANCED:
            case TAB_INDEX_GETSKILL:
            case TAB_INDEX_PUNCH:
         }
      }
      
      private function OnClickGoto(param1:Object, param2:uint) : void
      {
         this.Reset();
         ProcessorWindowClose();
         SUtilityHyperLink.ShortcutHyperlink(param2);
      }
      
      protected function ProcessorOnAdvanced(param1:Object, param2:uint, param3:TEquipment) : void
      {
         if(this.FEquipmentAdvanced != null)
         {
            this.FEquipmentAdvanced(param1,param2,param3);
         }
      }
      
      protected function TabClick(param1:Object) : void
      {
         this.SwitchTab(param1 as int);
      }
      
      protected function OnCloseWindow(param1:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Smithy);
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
      
      public function set StrengthenNetWork(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.StrengthenNetwork = param1;
      }
      
      public function set PunchNetWork(param1:Function) : void
      {
         this.FProcessorWindowPunch.PunchNetwork = param1;
      }
      
      public function set StrengthenLevel(param1:int) : void
      {
         this.FProcessorWindowStrengthen.StrengthenLevel = param1;
      }
      
      public function set StrengthenCDTime(param1:uint) : void
      {
         this.FProcessorWindowStrengthen.StrengthenCDTime = param1;
      }
      
      public function set StrengthenColdTimeRequest(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.StrengthenColdTimeRequest = param1;
      }
      
      public function set RefinedNetwork(param1:Function) : void
      {
         this.FProcessorWindowRefined.RefinedNetwork = param1;
      }
      
      public function set RefinedExchange(param1:Function) : void
      {
         this.FProcessorWindowRefined.RefinedExchange = param1;
      }
      
      public function set CurrentSmithyAttributeList(param1:TSmithyRefinedPakcetUnstreamizerData) : void
      {
         this.FProcessorWindowRefined.CurrentSmithyAttributeList = param1;
      }
      
      public function set OnInheritNetwork(param1:Function) : void
      {
         this.FProcessorWindowInherit.OnInheritNetwork = param1;
      }
      
      public function set UIComponentsHintOnOver(param1:Function) : void
      {
         this.FProcessorWindowEquipShow.OnSlotMouseOver = param1;
         this.FProcessorWindowStrengthen.OnSlotMouseOver = param1;
         this.FProcessorWindowRefined.OnSlotMouseOver = param1;
         this.FProcessorWindowInherit.OnSlotMouseOver = param1;
         this.FProcessorWindowAdvanced.OnSlotMouseOver = param1;
         this.FProcessorWindowGetSkill.OnSlotMouseOver = param1;
         this.FProcessorWindowPunch.OnSlotMouseOver = param1;
      }
      
      public function set UIComponentsHintOnOut(param1:Function) : void
      {
         this.FProcessorWindowEquipShow.OnSlotMouseOut = param1;
         this.FProcessorWindowStrengthen.OnSlotMouseOut = param1;
         this.FProcessorWindowRefined.OnSlotMouseOut = param1;
         this.FProcessorWindowInherit.OnSlotMouseOut = param1;
         this.FProcessorWindowAdvanced.OnSlotMouseOut = param1;
         this.FProcessorWindowGetSkill.OnSlotMouseOut = param1;
         this.FProcessorWindowPunch.OnSlotMouseOut = param1;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         super.OnEffectText = param1;
         this.FProcessorWindowStrengthen.OnEffectText = param1;
         this.FProcessorWindowRefined.OnEffectText = param1;
         this.FProcessorWindowInherit.OnEffectText = param1;
         this.FProcessorWindowAdvanced.OnEffectText = param1;
         this.FProcessorWindowGetSkill.OnEffectText = param1;
         this.FProcessorWindowFlushSpirit.OnEffectText = param1;
         this.FProcessorWindowPunch.OnEffectText = param1;
      }
      
      public function set ResultCode(param1:uint) : void
      {
         switch(this.FCurrentVisibleWindowIndex)
         {
            case TAB_INDEX_STRENGTHEN:
               this.FProcessorWindowStrengthen.StrengthenResult = param1;
               break;
            case TAB_INDEX_REFINED:
               this.FProcessorWindowRefined.StrengthenResult = param1;
               break;
            case TAB_INDEX_INHERIT:
               this.FProcessorWindowInherit.StrengthenResult = param1;
               break;
            case TAB_INDEX_PUNCH:
               this.FProcessorWindowPunch.PunchStage = param1;
         }
      }
      
      public function set ClearTime(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.OnClearTime = param1;
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
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.UpdateHeroPower = param1;
         this.FProcessorWindowRefined.UpdateHeroPower = param1;
         this.FProcessorWindowAdvanced.UpdateHeroPower = param1;
         this.FProcessorWindowGetSkill.UpdateHeroPower = param1;
         this.FProcessorWindowFlushSpirit.UpdateHeroPower = param1;
         this.FProcessorWindowPunch.UpdateHeroPower = param1;
      }
      
      public function set UpdateHerosPower(param1:Function) : void
      {
         this.FProcessorWindowInherit.UpdateHerosPower = param1;
      }
      
      public function set UIComponentsBtnOnOver(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.HintOnOver = param1;
         this.FProcessorWindowRefined.HintOnOver = param1;
         this.FProcessorWindowGetSkill.HintOnOver = param1;
      }
      
      public function set UIComponentsBtnOnOut(param1:Function) : void
      {
         this.FProcessorWindowStrengthen.HintOnOut = param1;
         this.FProcessorWindowRefined.HintOnOut = param1;
         this.FProcessorWindowGetSkill.HintOnOut = param1;
      }
      
      public function get EquipmentAdvanced() : Function
      {
         return this.FEquipmentAdvanced;
      }
      
      public function set EquipmentAdvanced(param1:Function) : void
      {
         this.FEquipmentAdvanced = param1;
      }
      
      public function set EquipmentGetSkill(param1:Function) : void
      {
         this.FProcessorWindowGetSkill.OnClickEnchanting = param1;
      }
      
      public function set ProtecedStoneFlag(param1:uint) : void
      {
         this.FProcessorWindowFlushSpirit.ProtecedStoneFlag = param1;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentVisibleWindowIndex)
         {
            case TAB_INDEX_STRENGTHEN:
               this.FProcessorWindowStrengthen.Update();
               break;
            case TAB_INDEX_REFINED:
               this.FProcessorWindowRefined.Update();
               break;
            case TAB_INDEX_INHERIT:
               this.FProcessorWindowInherit.Update();
               break;
            case TAB_INDEX_ADVANCED:
               this.FProcessorWindowAdvanced.Update();
               break;
            case TAB_INDEX_GETSKILL:
               this.FProcessorWindowGetSkill.Update();
               break;
            case TAB_INDEX_FLUSHSPIRIT:
               this.FProcessorWindowFlushSpirit.Update();
               break;
            case TAB_INDEX_PUNCH:
               this.FProcessorWindowPunch.Update();
         }
         this.FProcessorWindowEquipShow.Update();
      }
      
      public function Reset() : void
      {
         this.FTabs.SwithTagManual(TAB_INDEX_STRENGTHEN);
         this.FProcessorWindowEquipShow.Reset();
         this.FProcessorWindowStrengthen.Reset();
         this.FProcessorWindowRefined.Reset();
         this.FProcessorWindowInherit.Reset();
         this.FProcessorWindowAdvanced.Reset();
         this.FProcessorWindowGetSkill.Reset();
         this.FProcessorWindowFlushSpirit.Reset();
         this.FProcessorWindowPunch.Reset();
         this.FTabIndex = 0;
         visible = false;
      }
      
      public function OpenTabManual(param1:int) : void
      {
         this.FTabs.SwithTagManual(param1);
      }
      
      public function BuyStoneRet() : void
      {
         this.FProcessorWindowFlushSpirit.BuyStoneRet();
      }
   }
}

