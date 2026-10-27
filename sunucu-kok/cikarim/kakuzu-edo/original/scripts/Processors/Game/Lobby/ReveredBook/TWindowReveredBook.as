package Processors.Game.Lobby.ReveredBook
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.ReveredBook.Decoder.TUnstreamizerReveredBook;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_FRESHGUIDE;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TWindowReveredBook extends TProcessorLobbyWindow
   {
      
      protected static const TabNum:int = 3;
      
      protected var FMainUI:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FBtnClose:TUIButton;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FComponentRecommand:TComponentRecommend;
      
      protected var FComponentStrategy:TComponentStrategy;
      
      protected var FComponentTeaching:TComponentTeaching;
      
      protected var FComponentTabs:TComponentTabs;
      
      protected var FUnstreamizerReveredBook:TUnstreamizerReveredBook;
      
      protected var FComponentsWindow:Vector.<DisplayObject>;
      
      protected var FCurrentTabIndex:int;
      
      protected var FOnShowEffectNotification:Function;
      
      public function TWindowReveredBook(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerReveredBook = new TUnstreamizerReveredBook();
         this.FComponentRecommand = new TComponentRecommend(this);
         this.FComponentRecommand.UnstreamizerReveredBook = this.FUnstreamizerReveredBook;
         this.FComponentStrategy = new TComponentStrategy(this);
         this.FComponentStrategy.UnstreamizerReveredBook = this.FUnstreamizerReveredBook;
         this.FComponentTeaching = new TComponentTeaching(this);
         this.FComponentTeaching.UnstreamizerReveredBook = this.FUnstreamizerReveredBook;
         this.FComponentTeaching.OnClose = this.SubWindowClose;
         this.FComponentTabs = new TComponentTabs(this);
         this.FComponentTabs.OnTabClick = this.ComponentTabsOnClick;
         this.FComponentsWindow = new Vector.<DisplayObject>();
         this.FComponentsWindow.push(this.FComponentRecommand);
         this.FComponentsWindow.push(this.FComponentStrategy);
         this.FComponentsWindow.push(this.FComponentTeaching);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("UIReveredBook") as MovieClip;
         addChildAt(this.FMainUI,0);
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < TabNum)
         {
            this.FUITab.SetTabByIndex(this.FMainUI["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FComponentRecommand.LoadResource(this.FMainUI["Recommand"]);
         this.FComponentStrategy.LoadResource(this.FMainUI["Strategy"]);
         this.FComponentTeaching.LoadResource(this.FMainUI["Teaching"]);
         this.FComponentTabs.LoadResource(this.FMainUI["TabGroup"]);
         this.FPicMountPoint = new Bitmap();
         this.FMainUI["PicMountPoint"].addChild(this.FPicMountPoint);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["BtnClose"];
         this.FBtnClose.StopPropagation();
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_ReveredBook,this);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_ReveredBook,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         _loc3_ = int(this.FComponentsWindow.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FComponentsWindow[_loc2_].visible = false;
            _loc2_++;
         }
         this.FComponentsWindow[param1].visible = true;
         this.FCurrentTabIndex = param1;
         _loc4_ = this.FComponentsWindow[this.FCurrentTabIndex];
         this.FComponentTabs.LoadTabInfor(_loc4_.TabInfor);
         this.FComponentTabs.Visible = _loc4_.TabInfor != null;
      }
      
      protected function ComponentTabsOnClick(param1:int) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = this.FComponentsWindow[this.FCurrentTabIndex];
         _loc2_.TabClickNotify(param1);
      }
      
      protected function SetupPicID(param1:uint) : void
      {
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(param1,this.CallBack_PicArrive);
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function TabOnClose(param1:Object) : void
      {
         ProcessorWindowClose();
      }
      
      public function set QustionID(param1:int) : void
      {
         this.FComponentTeaching.CurrentSeverQustionID = param1;
      }
      
      public function get QustionID() : int
      {
         return this.FComponentTeaching.CurrentSeverQustionID;
      }
      
      public function set OnShowEffectNotification(param1:Function) : void
      {
         this.FOnShowEffectNotification = param1;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function SubWindowClose(param1:Object) : void
      {
         ProcessorWindowClose();
      }
      
      public function ShowTabByIndex(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
         if(SLogicsCore.Character.GirlClothesID != 0)
         {
            this.SetupPicID(SLogicsCore.Character.GirlClothesID);
         }
      }
      
      public function Reset() : void
      {
      }
      
      public function AnswerQustionNotify() : void
      {
         this.FComponentTeaching.AnswerQustionNotify();
      }
      
      public function IfHaveQuestionCanAnswer() : Boolean
      {
         return this.FComponentTeaching.IfHaveQuestionCanAnswer();
      }
   }
}

