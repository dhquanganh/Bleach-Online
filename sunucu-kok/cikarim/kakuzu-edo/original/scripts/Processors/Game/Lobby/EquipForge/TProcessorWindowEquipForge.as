package Processors.Game.Lobby.EquipForge
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.EquipForge.TEquipForge;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowEquipForge extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FHelpBtn:TUIButton;
      
      protected var FHint:THint;
      
      protected var FTab:TUITab;
      
      protected var FMC_MakeEquip:TProcessorWinMakeEquip;
      
      protected var FMC_UpgradeEquip:TProcessorWinUpgradeEquip;
      
      protected var FMC_Shop:TProcessorWinShop;
      
      protected var FData:TEquipForge;
      
      public function TProcessorWindowEquipForge(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FMC_MakeEquip != null)
         {
            this.FMC_MakeEquip.LogicsPerform();
            this.FMC_UpgradeEquip.LogicsPerform();
            this.FMC_Shop.LogicsPerform();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_EquipForge") as MovieClip;
         addChild(this.FMainUI);
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.btn_close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         this.FHelpBtn = new TUIButton();
         this.FHelpBtn.Substrate = this.FMainUI.StrengthenHelp;
         this.FHelpBtn.OnMove = this.ProcessorHelpOnMove;
         this.FHelpBtn.OnOut = this.ProcessorHelpOnOut;
         this.FTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this.FTab.SetTabByIndex(this.FMainUI["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTab.OnSwitch = this.SwitchTab;
         this.FTab.Init();
         this.FMC_MakeEquip = new TProcessorWinMakeEquip(this);
         this.FMC_MakeEquip.UIDispatch(this.FMainUI["MC_MakeEquip"]);
         this.FMC_UpgradeEquip = new TProcessorWinUpgradeEquip(this);
         this.FMC_UpgradeEquip.UIDispatch(this.FMainUI["MC_UpgradeEquip"]);
         this.FMC_Shop = new TProcessorWinShop(this);
         this.FMC_Shop.UIDispatch(this.FMainUI["MC_Shop"]);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ProcessorHelpOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(70950006);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ProcessorHelpOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.FMainUI["MC_MakeEquip"].visible = false;
         this.FMainUI["MC_UpgradeEquip"].visible = false;
         this.FMainUI["MC_Shop"].visible = false;
         switch(param1)
         {
            case 0:
               this.FMainUI["MC_MakeEquip"].visible = true;
               this.FMC_MakeEquip.Update();
               this.ResetMake();
               break;
            case 1:
               this.FMainUI["MC_UpgradeEquip"].visible = true;
               this.FMC_UpgradeEquip.Update();
               this.ResetAdvance();
               break;
            case 2:
               this.FMainUI["MC_Shop"].visible = true;
               this.FMC_Shop.Update(this.FData);
         }
      }
      
      public function SetData(param1:TEquipForge) : void
      {
         this.FData = param1;
         this.FMC_MakeEquip.Update();
         this.FMC_UpgradeEquip.Update();
         this.FMC_Shop.Update(this.FData);
      }
      
      public function ResetMake() : void
      {
         this.FMC_MakeEquip.Reset();
      }
      
      public function ResetAdvance() : void
      {
         this.FMC_UpgradeEquip.Reset();
      }
   }
}

