package Processors.Game.Lobby.Home.GirlFriend
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Home.GirlFriend.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGirlFriendMainBoard extends TProcessorLobbyWindow
   {
      
      protected static const TAB_NUM:int = 3;
      
      public static const WINDOW_WIDTH:int = 680;
      
      public static const WINDOW_HEIGHT:int = 405;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FMainUI:MovieClip;
      
      protected var FWindowGirlFriendBaseInfor:TProcessorWindowGirlFriendBaseInfor;
      
      protected var FWindowGirlFriendMakeTofu:TProcessorWindowGirlFriendMakeTofu;
      
      protected var FWindowGirlFriendSpriteCommunicate:TProcessorWindowGirlFriendSpriteCommunicate;
      
      protected var FWindowAllGirlFriend:TProcessorWindowShowAllGirl;
      
      protected var FWindowArray:Array;
      
      protected var FMC_GirlFriendPic:MovieClip;
      
      protected var FBitMap_GirlPic:Bitmap;
      
      protected var FTF_GirlFriendLevel:TextField;
      
      protected var FBTN_ShowAllGirlFriend:TUIButton;
      
      protected var FBTN_UpgradeGirlFriend:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FBTN_Help:SimpleButton;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FFunOnShowUpgradeGirlWindow:Function;
      
      protected var FHitMouseMove:Function;
      
      protected var FHitMouseOut:Function;
      
      protected var FApplianceOnOver:Function;
      
      protected var FApplianceOnOut:Function;
      
      public function TProcessorWindowGirlFriendMainBoard(param1:TUIComponent)
      {
         super(param1);
         this.FGirlFriend = SLogicsCore.Home.GirlFriend;
         this.FWindowArray = new Array();
         this.PreConstruct();
      }
      
      protected function PreConstruct() : void
      {
         this.ConstructWindowBaseInfor();
         this.ConstructWindowMakeTofu();
         this.ConstructWindowSpriteCommunicate();
         this.ConstructWindowShowAllGirlFriend();
      }
      
      protected function ConstructWindowBaseInfor() : void
      {
         this.FWindowGirlFriendBaseInfor = new TProcessorWindowGirlFriendBaseInfor(this);
         this.FWindowArray.push(this.FWindowGirlFriendBaseInfor);
      }
      
      protected function ConstructWindowMakeTofu() : void
      {
         this.FWindowGirlFriendMakeTofu = new TProcessorWindowGirlFriendMakeTofu(this);
         this.FWindowArray.push(this.FWindowGirlFriendMakeTofu);
      }
      
      protected function ConstructWindowSpriteCommunicate() : void
      {
         this.FWindowGirlFriendSpriteCommunicate = new TProcessorWindowGirlFriendSpriteCommunicate(this);
         this.FWindowArray.push(this.FWindowGirlFriendSpriteCommunicate);
      }
      
      protected function ConstructWindowShowAllGirlFriend() : void
      {
         this.FWindowAllGirlFriend = new TProcessorWindowShowAllGirl(this);
         this.FWindowAllGirlFriend.x = (CONST_COMMON.STAGE_Width - TProcessorWindowShowAllGirl.WINDOW_WIDTH) / 2 - (CONST_COMMON.STAGE_Width - WINDOW_WIDTH) / 2;
         this.FWindowAllGirlFriend.y = (CONST_COMMON.STAGE_Height - TProcessorWindowShowAllGirl.WINDOW_HEIGHT) / 2 - (CONST_COMMON.STAGE_Height - WINDOW_HEIGHT) / 2;
         this.FWindowAllGirlFriend.visible = false;
         this.FWindowArray.push(this.FWindowAllGirlFriend);
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FWindowAllGirlFriend.Load();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("GirlMainBoard") as MovieClip;
         addChildAt(this.FMainUI,0);
         this.ComponentResouceDispatch();
         this.LocalUIDispatch();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_GirlFreindView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_GirlFreindView,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.ComponentResouceLocation();
         this.LocalUILocation();
         super.ResourcesPerform_UILocations();
      }
      
      protected function ComponentResouceDispatch() : void
      {
         this.FWindowGirlFriendBaseInfor.UIDispatch(this.FMainUI["BaseInfor"]);
         this.FWindowGirlFriendMakeTofu.UIDispatch(this.FMainUI["MakeTofu"]);
         this.FWindowGirlFriendSpriteCommunicate.UIDispatch(this.FMainUI["SpriteCommunicate"]);
      }
      
      protected function ComponentResouceLocation() : void
      {
         this.FWindowGirlFriendBaseInfor.UILocation();
         this.FWindowGirlFriendMakeTofu.UILocation();
         this.FWindowGirlFriendSpriteCommunicate.UILocation();
      }
      
      protected function LocalUIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FMC_GirlFriendPic = this.FMainUI["GirlPic"];
         this.FBitMap_GirlPic = new Bitmap();
         this.FMC_GirlFriendPic["MC_Image"].addChild(this.FBitMap_GirlPic);
         this.FTF_GirlFriendLevel = this.FMC_GirlFriendPic["Girlevel"];
         this.FBTN_ShowAllGirlFriend = new TUIButton();
         this.FBTN_ShowAllGirlFriend.Substrate = this.FMainUI["Btn_All"];
         this.FBTN_UpgradeGirlFriend = new TUIButton();
         this.FBTN_UpgradeGirlFriend.Substrate = this.FMainUI["Btn_Upgrade"];
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < TAB_NUM)
         {
            this.FUITab.SetTabByIndex(this.FMainUI["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabSwitch;
         this.FUITab.Init();
         this.FBTN_Help = this.FMainUI["BTN_Help"];
         this.FBTN_Close = this.FMainUI["BTN_Close"];
      }
      
      protected function LocalUILocation() : void
      {
         this.FBTN_ShowAllGirlFriend.OnClick = this.OnShowAllGirlBtnClick;
         this.FBTN_UpgradeGirlFriend.OnClick = this.OnUpgradeGirlBtnClick;
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_OVER,this.OnHelpBtnOnMouseOver);
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         this.FUITab.SwithTagManual(0);
      }
      
      public function Update_Peform() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FWindowArray.length)
         {
            this.FWindowArray[_loc1_].Update();
            _loc1_++;
         }
         this.UpdateGirl();
      }
      
      public function UpdateGirl() : void
      {
         this.FTF_GirlFriendLevel.text = this.FGirlFriend.Name;
         this.FBitMap_GirlPic.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FGirlFriend.ImageID,this.ResourceSendInterface);
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FGirlFriend.ImageID)
         {
            this.FBitMap_GirlPic.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function TabSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < TAB_NUM)
         {
            this.FWindowArray[_loc2_].visible = false;
            _loc2_++;
         }
         this.FWindowArray[param1].visible = true;
         this.FWindowGirlFriendBaseInfor.x = 0;
         this.FWindowGirlFriendBaseInfor.y = 0;
         this.FWindowGirlFriendBaseInfor.visible = true;
         switch(param1)
         {
            case 1:
               TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickMakeTofuTab);
               break;
            case 2:
               TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickSpriteCommunicateTab);
         }
      }
      
      protected function OnShowAllGirlBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWindowAllGirlFriend.Update();
         this.FWindowAllGirlFriend.visible = true;
      }
      
      protected function OnUpgradeGirlBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.OnCloseBtnClick();
         if(this.FFunOnShowUpgradeGirlWindow != null)
         {
            this.FFunOnShowUpgradeGirlWindow(this);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGirlUpgradeInMainBoard);
      }
      
      protected function OnHelpBtnOnMouseOver(param1:MouseEvent) : void
      {
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent = null) : void
      {
         ProcessorWindowClose();
         this.FUITab.SwithTagManual(0);
         this.Reset();
      }
      
      public function set HitMouseMove(param1:Function) : void
      {
         this.FHitMouseMove = param1;
         this.FWindowGirlFriendMakeTofu.HitMouseMove = param1;
         this.FWindowGirlFriendSpriteCommunicate.HintOnOver = param1;
      }
      
      public function set HitMouseOut(param1:Function) : void
      {
         this.FHitMouseOut = param1;
         this.FWindowGirlFriendMakeTofu.HitMouseOut = param1;
         this.FWindowGirlFriendSpriteCommunicate.HintOnOut = param1;
      }
      
      public function set ApplianceOnOver(param1:Function) : void
      {
         this.FApplianceOnOver = param1;
      }
      
      public function set ApplianceOnOut(param1:Function) : void
      {
         this.FApplianceOnOut = param1;
      }
      
      public function set FunOnShowUpgradeGirlWindow(param1:Function) : void
      {
         this.FFunOnShowUpgradeGirlWindow = param1;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         var _loc2_:int = 0;
         super.OnEffectText = param1;
         _loc2_ = 0;
         while(_loc2_ < this.FWindowArray.length)
         {
            this.FWindowArray[_loc2_].OnEffectText = param1;
            _loc2_++;
         }
      }
      
      public function set OnHtmlEffectText(param1:Function) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FWindowArray.length)
         {
            this.FWindowArray[_loc2_].OnEffectHtmlText = param1;
            _loc2_++;
         }
      }
      
      public function set PlayRewardEffect(param1:Function) : void
      {
         this.FWindowGirlFriendSpriteCommunicate.PlayRewardEffect = param1;
      }
      
      public function Update() : void
      {
         this.Update_Peform();
      }
      
      public function Reset() : void
      {
         if(this.FBitMap_GirlPic != null)
         {
            this.FBitMap_GirlPic.bitmapData = null;
            this.FWindowGirlFriendMakeTofu.Reset();
            this.FWindowAllGirlFriend.Reset();
            this.FWindowGirlFriendSpriteCommunicate.Reset();
         }
      }
      
      public function GetMovieClipByMood(param1:int) : Sprite
      {
         return this.FWindowGirlFriendSpriteCommunicate.GetMovieClipByMood(param1);
      }
      
      public function SwithTagManual(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
      }
   }
}

