package Processors.Game.Lobby.Achievement
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Achievenment.TAchievementClassInfor;
   import Logics.Achievenment.TAchievementGroupInfor;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TTitles;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_ACHIEVEMENT;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowAchievement extends TProcessorLobbyWindow
   {
      
      protected static const GROUPNUM:int = 5;
      
      protected static const TABNUM:int = 5;
      
      protected var FMainScene:Sprite;
      
      protected var FTab:TUITab;
      
      protected var FCurrentTabIndex:int;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FTFSchedules:Vector.<TextField>;
      
      protected var FSPTabs:Vector.<Sprite>;
      
      protected var FTitleShine:Sprite;
      
      protected var FOtherUserName:TextField;
      
      protected var FWindowAchievementGroups:Vector.<TProcessorWindowAchievementGroup>;
      
      protected var FWindowSpecialAchievement:TProcessorWindowAchievementSpecial;
      
      protected var FWindowShowNormalAchievement:TProcessorWindowNormalAchievementInfor;
      
      protected var FWindowShowSepicalAchievement:TProcessorWindowSpecialAchievementInfor;
      
      protected var FWindowTitle:TProcessorWindowTitle;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FBtnTitle:TUIButton;
      
      protected var FToolHint:THint;
      
      protected var FCurrentMode:int;
      
      protected var FAchievementClassInfors:Vector.<TAchievementClassInfor>;
      
      protected var FUserName:String;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnFollowAchievement:Function;
      
      public function TProcessorWindowAchievement(param1:TUIComponent)
      {
         super(param1);
         this.FWindowShowNormalAchievement = new TProcessorWindowNormalAchievementInfor(this);
         this.FWindowShowSepicalAchievement = new TProcessorWindowSpecialAchievementInfor(this);
         this.FWindowSpecialAchievement = new TProcessorWindowAchievementSpecial(this);
         this.FWindowTitle = new TProcessorWindowTitle(this);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(Visible)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FTab.Count)
            {
               this.FTab.Update();
               _loc1_++;
            }
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc4_:TProcessorWindowAchievementGroup = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("AchievementBG") as Sprite;
         addChild(this.FMainScene);
         this.FTitleShine = this.FMainScene["BackGroud"]["TitleShine"];
         this.FOtherUserName = this.FMainScene["BackGroud"]["UserName"];
         this.FTFSchedules = new Vector.<TextField>();
         this.FSPTabs = new Vector.<Sprite>();
         this.FTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < TABNUM)
         {
            _loc2_ = this.FMainScene["Tab" + _loc1_];
            this.FSPTabs.push(_loc2_);
            _loc2_.mouseChildren = false;
            this.FTab.SetTabByIndex(_loc2_,_loc1_);
            _loc2_ = _loc2_["Board"];
            this.FTFSchedules.push(_loc2_["Schedule"]);
            _loc2_["Quality"].gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
         this.FTab.OnSwitch = this.SwitchTab;
         this.FTab.Init();
         this.FWindowAchievementGroups = new Vector.<TProcessorWindowAchievementGroup>();
         _loc1_ = 0;
         while(_loc1_ < GROUPNUM)
         {
            _loc4_ = new TProcessorWindowAchievementGroup(this);
            _loc4_.OnAchievementClick = this.AchievementIconOnClick;
            _loc4_.OnHintOver = this.FOnHintOver;
            _loc4_.OnHintOut = this.FOnHintOut;
            _loc3_ = this.FMainScene["AchievementGroup" + _loc1_];
            _loc4_.SendResource(_loc3_);
            this.FWindowAchievementGroups.push(_loc4_);
            _loc1_++;
         }
         this.FWindowSpecialAchievement.SendResource(this.FMainScene);
         this.FWindowSpecialAchievement.OnAchievementClick = this.SpecialAchievementIconOnClick;
         this.FWindowSpecialAchievement.OnHintOver = this.FOnHintOver;
         this.FWindowSpecialAchievement.OnHintOut = this.FOnHintOut;
         this.FBtnClose = this.FMainScene["BackGroud"]["BtnClose"];
         this.FBtnTitle = new TUIButton();
         this.FBtnTitle.Substrate = this.FMainScene["EquipTitle"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainScene["btn_left"];
         this.FUIPage.ButtonNext.Substrate = this.FMainScene["btn_right"];
         this.FUIPage.LabelPage = this.FMainScene["TF_Page"];
         this.FUIPage.PageSize = GROUPNUM;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FWindowShowNormalAchievement.Init();
         this.FWindowShowNormalAchievement.OnClose = this.NormalAchievementInforWindowOnClose;
         this.FWindowShowNormalAchievement.visible = false;
         this.FWindowShowNormalAchievement.x = this.FMainScene.x + (this.FMainScene.width - this.FWindowShowNormalAchievement.width) / 2;
         this.FWindowShowNormalAchievement.y = this.FMainScene.y + (this.FMainScene.height - this.FWindowShowNormalAchievement.height) / 2;
         addChild(this.FWindowShowNormalAchievement);
         this.FWindowShowSepicalAchievement.Init();
         this.FWindowShowSepicalAchievement.OnClose = this.NormalAchievementInforWindowOnClose;
         this.FWindowShowSepicalAchievement.visible = false;
         this.FWindowShowSepicalAchievement.x = this.FMainScene.x + (this.FMainScene.width - this.FWindowShowSepicalAchievement.width) / 2;
         this.FWindowShowSepicalAchievement.y = this.FMainScene.y + (this.FMainScene.height - this.FWindowShowSepicalAchievement.height) / 2;
         addChild(this.FWindowShowSepicalAchievement);
         this.FWindowTitle.Init();
         this.FWindowTitle.OnClose = this.WindowTitleOnClose;
         this.FWindowTitle.x = this.FMainScene.x + (this.FMainScene.width - this.FWindowTitle.width) / 2;
         this.FWindowTitle.y = this.FMainScene.y + (this.FMainScene.height - this.FWindowTitle.height) / 2;
         addChild(this.FWindowTitle);
         this.FToolHint = new THint();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         this.FBtnTitle.OnClick = this.BtnTitleOnClick;
         _loc3_ = int(this.FAchievementClassInfors[0].AchivementGroups.length);
         this.SetupPage(_loc3_,0);
         this.FCurrentPageIndex = 0;
         this.FCurrentTabIndex = 0;
         _loc1_ = 0;
         while(_loc1_ < TABNUM)
         {
            _loc2_ = this.FSPTabs[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.TabOnMouseMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
            _loc1_++;
         }
         this.FUserName = "";
         super.ResourcesPerform_UILocations();
      }
      
      protected function CheckIfAchievementCanGotReward(param1:TAchievementClassInfor) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementGroupInfor = null;
         var _loc7_:TAchievementInfor = null;
         _loc4_ = int(param1.AchivementGroups.length);
         _loc2_ = 0;
         loop0:
         while(_loc2_ < _loc4_)
         {
            _loc6_ = param1.AchivementGroups[_loc2_];
            _loc5_ = _loc6_.AchievementInfors.Count;
            _loc3_ = 0;
            while(true)
            {
               if(_loc3_ >= _loc5_)
               {
                  _loc2_++;
                  continue loop0;
               }
               _loc7_ = _loc6_.AchievementInfors.GetAchievementByIndex(_loc3_);
               if(_loc7_.IfComplete && !_loc7_.IfGotReward)
               {
                  break;
               }
               _loc3_++;
            }
            return true;
         }
         return false;
      }
      
      public function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAchievementClassInfor = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FTitleShine.visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWME;
         this.FOtherUserName.visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWOTHER;
         this.FBtnTitle.Visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWME;
         if(this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWOTHER)
         {
            this.FOtherUserName.text = this.FUserName;
         }
         _loc2_ = this.FAchievementClassInfors[this.FCurrentTabIndex];
         _loc3_ = this.FCurrentPageIndex * GROUPNUM;
         _loc4_ = _loc3_ + GROUPNUM;
         _loc4_ = _loc4_ > _loc2_.AchivementGroups.length ? int(_loc2_.AchivementGroups.length) : _loc4_;
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            _loc5_ = _loc1_ - _loc3_;
            this.FWindowAchievementGroups[_loc5_].AchievementGroupInfor = _loc2_.AchivementGroups[_loc1_];
            this.FWindowAchievementGroups[_loc5_].Reset();
            this.FWindowAchievementGroups[_loc5_].Update();
            this.FWindowAchievementGroups[_loc5_].Visible = true;
            _loc1_++;
         }
         _loc1_ -= _loc3_;
         while(_loc1_ < GROUPNUM)
         {
            this.FWindowAchievementGroups[_loc1_].Visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < TABNUM)
         {
            if(this.CheckIfAchievementCanGotReward(this.FAchievementClassInfors[_loc1_]))
            {
               this.FTab.StartTabShowGlowByIndex(_loc1_);
            }
            else
            {
               this.FTab.StopTabShowGlowByIndex(_loc1_);
            }
            _loc1_++;
         }
         this.FWindowSpecialAchievement.AchievementClassInfor = this.FAchievementClassInfors[this.FAchievementClassInfors.length - 1];
         this.FWindowSpecialAchievement.Update();
         _loc3_ = 0;
         _loc4_ = TABNUM < this.FAchievementClassInfors.length ? TABNUM : int(this.FAchievementClassInfors.length);
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = this.FAchievementClassInfors[_loc1_];
            this.FTFSchedules[_loc1_].text = _loc2_.CurrentSchedule + "/" + _loc2_.TotalSchedule;
            _loc1_++;
         }
         while(_loc1_ < TABNUM)
         {
            this.FTab.SetTabHideByIndex(_loc1_);
            _loc1_++;
         }
         if(this.FWindowTitle.visible)
         {
            this.FWindowTitle.Update();
         }
         if(this.FWindowShowNormalAchievement.visible)
         {
            this.FWindowShowNormalAchievement.ShowAchievementInfor();
         }
         if(this.FWindowShowSepicalAchievement.visible)
         {
            this.FWindowShowSepicalAchievement.ShowAchievementInfor();
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
         this.FCurrentPageIndex = param2;
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function SwitchTab(param1:int) : void
      {
         var _loc2_:int = 0;
         this.FCurrentTabIndex = param1;
         _loc2_ = int(this.FAchievementClassInfors[param1].AchivementGroups.length);
         this.SetupPage(_loc2_,0);
         this.Update_Perform();
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.Update_Perform();
      }
      
      protected function TabOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSPTabs.indexOf(param1.currentTarget as Sprite);
         this.FToolHint.Caption = this.FAchievementClassInfors[_loc2_].AchievementClassName;
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FToolHint);
         }
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FToolHint);
         }
      }
      
      protected function NormalAchievementInforWindowOnClose(param1:Object) : void
      {
         var _loc2_:TAchievementInfor = null;
         var _loc3_:TAchievementInfor = null;
         this.FMainScene.mouseChildren = true;
         this.FMainScene.mouseEnabled = true;
         this.FWindowShowNormalAchievement.visible = false;
         this.FWindowShowNormalAchievement.Reset();
         this.FWindowShowSepicalAchievement.visible = false;
         this.FWindowShowSepicalAchievement.Reset();
         this.FMainScene.filters = null;
         _loc2_ = param1 as TAchievementInfor;
         _loc3_ = SLogicsCore.Character.CurrentFollowAchievement;
         if(_loc2_.IfFollow)
         {
            if(_loc3_ != _loc2_)
            {
               if(_loc3_ != null)
               {
                  _loc3_.IfFollow = false;
               }
               SLogicsCore.Character.CurrentFollowAchievement = _loc2_;
               if(this.FOnFollowAchievement != null)
               {
                  this.FOnFollowAchievement(_loc2_);
               }
            }
         }
         else if(_loc2_ == SLogicsCore.Character.CurrentFollowAchievement)
         {
            SLogicsCore.Character.CurrentFollowAchievement = null;
            if(this.FOnFollowAchievement != null)
            {
               this.FOnFollowAchievement(null);
            }
         }
         this.Update_Perform();
      }
      
      protected function AchievementIconOnClick(param1:Object) : void
      {
         this.FWindowShowNormalAchievement.ShowAchievementInfor(param1 as TAchievementInfor);
         this.FMainScene.mouseChildren = false;
         this.FMainScene.mouseEnabled = false;
         this.FMainScene.filters = [TUtilityFilter.GaryColorFiltersMask];
         this.FWindowShowNormalAchievement.visible = true;
      }
      
      protected function SpecialAchievementIconOnClick(param1:Object) : void
      {
         this.FWindowShowSepicalAchievement.ShowAchievementInfor(param1 as TAchievementInfor);
         this.FMainScene.mouseChildren = false;
         this.FMainScene.mouseEnabled = false;
         this.FMainScene.filters = [TUtilityFilter.GaryColorFiltersMask];
         this.FWindowShowSepicalAchievement.visible = true;
      }
      
      protected function BtnTitleOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMainScene.mouseChildren = false;
         this.FMainScene.mouseEnabled = false;
         this.FMainScene.filters = [TUtilityFilter.GaryColorFiltersMask];
         this.FWindowTitle.Update();
         this.FWindowTitle.visible = true;
      }
      
      protected function WindowTitleOnClose(param1:Object) : void
      {
         this.FMainScene.mouseChildren = true;
         this.FMainScene.mouseEnabled = true;
         this.FMainScene.filters = null;
      }
      
      public function set AchievementClassInfors(param1:Vector.<TAchievementClassInfor>) : void
      {
         this.FAchievementClassInfors = param1;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         var _loc2_:int = 0;
         this.FOnHintOver = param1;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         var _loc2_:int = 0;
         this.FOnHintOut = param1;
      }
      
      public function set InventoryMouseOver(param1:Function) : void
      {
         this.FWindowShowNormalAchievement.InventoryMouseOver = param1;
         this.FWindowShowSepicalAchievement.InventoryMouseOver = param1;
      }
      
      public function set InventoryMouseOut(param1:Function) : void
      {
         this.FWindowShowNormalAchievement.InventoryMouseOut = param1;
         this.FWindowShowSepicalAchievement.InventoryMouseOut = param1;
      }
      
      public function set UserName(param1:String) : void
      {
         this.FUserName = param1;
      }
      
      public function set Mode(param1:int) : void
      {
         this.FCurrentMode = param1;
         this.FWindowShowNormalAchievement.Mode = param1;
         this.FWindowShowSepicalAchievement.Mode = param1;
      }
      
      public function set OnFollowAchievement(param1:Function) : void
      {
         this.FOnFollowAchievement = param1;
      }
      
      public function set AchievementTitles(param1:Vector.<TTitles>) : void
      {
         this.FWindowTitle.AchievementTitles = param1;
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(FIsResourcesLoadCompleted)
         {
            this.FTab.SwithTagManual(0);
         }
         this.FUserName = "";
         _loc1_ = 0;
         while(_loc1_ < this.FWindowAchievementGroups.length)
         {
            this.FWindowAchievementGroups[_loc1_].Reset();
            _loc1_++;
         }
         this.FWindowSpecialAchievement.Reset();
         this.FWindowShowNormalAchievement.Reset();
         this.FWindowShowSepicalAchievement.Reset();
         this.FWindowTitle.Reset();
         this.FTab.StopGlow();
      }
      
      public function ShowAchievementInfor(param1:TAchievementInfor) : void
      {
         if(param1.AchievementGroupInfor.AchievementClassInfor == this.FAchievementClassInfors[this.FAchievementClassInfors.length - 1])
         {
            this.SpecialAchievementIconOnClick(param1);
         }
         else
         {
            this.AchievementIconOnClick(param1);
         }
      }
   }
}

