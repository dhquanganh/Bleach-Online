package Processors.Game.Lobby.HerosNew.HeroWakePopup
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.HerosNew.Component.THeroWakeAdvancedUI;
   import Processors.Game.Lobby.HerosNew.Component.THeroWakeStrengUI;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THeroWakeWin extends TProcessorLobbyWindow
   {
      
      protected const TabCount:uint = 2;
      
      protected var FMainUI:MovieClip;
      
      protected var FMask:Bitmap;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FTab:TUITab;
      
      protected var FAdvaUI:THeroWakeAdvancedUI;
      
      protected var FStrengUI:THeroWakeStrengUI;
      
      protected var FTabIndex:uint;
      
      protected var FHeroWakeEquipment:THeroWakeEquipment;
      
      public function THeroWakeWin(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_HeroWakeWin") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(this.FMask);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMask.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMask.height - this.FMainUI.height) / 2;
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI["Btn_Close"];
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         this.FTab = new TUITab(this);
         this.FTab.SetTabByIndex(this.FMainUI["Btn_Adva"],0);
         this.FTab.SetTabByIndex(this.FMainUI["Btn_Str"],1);
         this.FTab.OnSwitch = this.OnSwitchFunction;
         this.FTab.Init();
         this.FAdvaUI = new THeroWakeAdvancedUI(this);
         this.FAdvaUI.UIDispatch(this.FMainUI.MC_TabUI_0);
         this.FStrengUI = new THeroWakeStrengUI(this);
         this.FStrengUI.UIDispatch(this.FMainUI.MC_TabUI_1);
      }
      
      override protected function LogicsPerform() : void
      {
         if(this.FAdvaUI != null)
         {
            this.FAdvaUI.LogicsPerform();
            this.FStrengUI.LogicsPerform();
         }
         super.LogicsPerform();
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FTab.SwithTagManual(0);
         ProcessorWindowClose();
      }
      
      protected function OnSwitchFunction(param1:int) : void
      {
         this.FTabIndex = param1;
         this.UpdateTab();
      }
      
      protected function UpdateTab() : void
      {
         this.FAdvaUI.Visible = false;
         this.FStrengUI.Visible = false;
         switch(this.FTabIndex)
         {
            case 0:
               this.FAdvaUI.Visible = true;
               break;
            case 1:
               this.FStrengUI.Visible = true;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set HeroWakeEquipment(param1:THeroWakeEquipment) : void
      {
         this.FHeroWakeEquipment = param1;
         this.FAdvaUI.HeroWakeEquipment = param1;
         this.FStrengUI.HeroWakeEquipment = param1;
      }
      
      public function UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function UpdateUI() : void
      {
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         if(THeroWakeData.IsStone(this.FHeroWakeEquipment) || this.FHeroWakeEquipment.WakeUpConfig.WakeStage == 0)
         {
            this.FTab.SetTabEnabledByIndex(1,false);
         }
         else
         {
            this.FTab.SetTabEnabledByIndex(1,true);
         }
         this.UpdateTab();
      }
   }
}

