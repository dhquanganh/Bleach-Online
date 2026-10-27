package Processors.Game.Lobby.ReveredBook
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   
   public class TComponentTabs extends TProcessorLobbyWindow
   {
      
      protected static const TabNum:int = 11;
      
      protected var FMainUI:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FTabInfor:Vector.<String>;
      
      protected var FCurrentPageIndex:int;
      
      protected var FOnTabClick:Function;
      
      public function TComponentTabs(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         this.FUITab = new TUITab(this);
         _loc2_ = this.FMainUI["TabGroup"];
         _loc1_ = 0;
         while(_loc1_ < TabNum)
         {
            this.FUITab.SetTabByIndex(_loc2_["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc3_ = this.FMainUI["MC_HeroPage"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc3_["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = _loc3_["MC_PageRight"];
         this.FUIPage.LabelPage = _loc3_["TF_Page"];
         this.FUIPage.PageSize = TabNum;
         this.FUIPage.OnChangePage = this.SwitchPage;
      }
      
      protected function UILocation() : void
      {
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
         this.FCurrentPageIndex = param2;
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         if(this.FOnTabClick != null)
         {
            this.FOnTabClick(param1 + this.FCurrentPageIndex * TabNum);
         }
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FCurrentPageIndex = param2;
         _loc3_ = this.FCurrentPageIndex * TabNum;
         _loc4_ = _loc3_ + TabNum < this.FTabInfor.length ? int(_loc3_ + TabNum) : int(this.FTabInfor.length);
         _loc5_ = _loc3_;
         while(_loc5_ < _loc4_)
         {
            this.FUITab.SetTabCaptionByIndex(this.FTabInfor[_loc5_],_loc5_ - _loc3_);
            this.FUITab.SetTabShowByIndex(_loc5_ - _loc3_);
            _loc5_++;
         }
         _loc5_ -= _loc3_;
         while(_loc5_ < TabNum)
         {
            this.FUITab.SetTabHideByIndex(_loc5_);
            _loc5_++;
         }
         this.FUITab.SwithTagManual(0);
      }
      
      public function set OnTabClick(param1:Function) : void
      {
         this.FOnTabClick = param1;
      }
      
      public function LoadResource(param1:Sprite) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.UIDispatch();
         this.UILocation();
      }
      
      public function LoadTabInfor(param1:Vector.<String>) : void
      {
         this.FTabInfor = param1;
         if(this.FTabInfor == null)
         {
            return;
         }
         this.SetupPage(param1.length,0);
         this.SwitchPage(null,0);
      }
   }
}

