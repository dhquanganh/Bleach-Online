package Processors.Game.Lobby.ProfessionRefine
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.ProfessionRefine.Component.TUIChooseStoneMall;
   import Processors.Game.Lobby.ProfessionRefine.Component.TUIProfessionLevelup;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TUIProcessorWindowProfessionRefine extends TProcessorLobbyWindow
   {
      
      protected static const TAB_NUM:int = 2;
      
      protected var FResource:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FUIChooseStoneMall:TUIChooseStoneMall;
      
      protected var FUIProfessionLevelup:TUIProfessionLevelup;
      
      public function TUIProcessorWindowProfessionRefine(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FResource = TUtilityReflection.CreateDisplayObjectInstance("Asset_ProfessionRefine_Main") as Sprite;
         addChild(this.FResource);
         this.FUITab = new TUITab(this);
         _loc2_ = TAB_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FResource["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FTabIndex = 0;
         this.FUITab.TabIndex = 0;
         this.FUIChooseStoneMall = new TUIChooseStoneMall(this);
         this.FUIChooseStoneMall.Resource = this.FResource["MC_Mall"];
         this.FUIProfessionLevelup = new TUIProfessionLevelup(this);
         this.FUIProfessionLevelup.Resource = this.FResource["MC_LevelUp"];
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FResource["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FUIChooseStoneMall != null && this.FUIChooseStoneMall.Visible)
         {
            this.FUIChooseStoneMall.LogicsPerform();
         }
         if(this.FUIProfessionLevelup != null && this.FUIProfessionLevelup.Visible)
         {
            this.FUIProfessionLevelup.LogicsPerform();
         }
      }
      
      protected function UpdateUI() : void
      {
         switch(this.FUITab.TabIndex)
         {
            case 0:
               this.FUIChooseStoneMall.Show();
               this.FUIProfessionLevelup.Hide();
               break;
            case 1:
               this.FUIChooseStoneMall.Hide();
               this.FUIProfessionLevelup.Show();
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1);
         switch(_loc2_)
         {
            case 0:
               this.FUIChooseStoneMall.Show();
               this.FUIProfessionLevelup.Hide();
               break;
            case 1:
               this.FUIChooseStoneMall.Hide();
               this.FUIProfessionLevelup.Show();
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      public function Show() : void
      {
         this.Update();
         Visible = true;
      }
      
      public function Hide() : void
      {
         this.Reset();
         Visible = false;
      }
      
      public function Update() : void
      {
         this.UpdateUI();
      }
      
      public function Reset() : void
      {
         this.FUIChooseStoneMall.Reset();
         this.FUIProfessionLevelup.Reset();
      }
      
      public function MallSuccess() : void
      {
         this.FUIChooseStoneMall.MallSuccess();
      }
      
      public function LevelupSuccess(param1:int) : void
      {
         this.FUIProfessionLevelup.LevelupSuccess(param1);
      }
      
      public function SetTabIndex(param1:int) : void
      {
         this.FUITab.TabIndex = param1;
      }
   }
}

