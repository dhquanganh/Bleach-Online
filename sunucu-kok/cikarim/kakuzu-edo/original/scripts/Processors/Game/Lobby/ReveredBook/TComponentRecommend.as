package Processors.Game.Lobby.ReveredBook
{
   import Components.Lists.Data.TListItemTextField;
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBar;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.ReveredBook.Decoder.TUnstreamizerReveredBook;
   import Logics.ReveredBook.TRecommandHeroInfor;
   import Logics.ReveredBook.TRecommandInfor;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TComponentRecommend extends TProcessorLobbyWindow
   {
      
      protected static const HeroHeadNum:int = 5;
      
      protected static const TFWidth:int = 340;
      
      protected static const TFOffsetX:int = 17;
      
      protected static const TFOffsetY:int = 105;
      
      protected var FMainUI:Sprite;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentHerosRecommendIndex:int;
      
      protected var FCurrentPageIndex:int;
      
      protected var FCurrentRecommandIndex:int;
      
      protected var FCurrentSelectHeadIndex:int;
      
      protected var FRoleHeadSP:Vector.<Sprite>;
      
      protected var FRoleHeadPosition:Vector.<MovieClip>;
      
      protected var FRoleHeadMountPoint:Vector.<Bitmap>;
      
      protected var FRoleHeadOverState:Vector.<Sprite>;
      
      protected var FRoleSelectBox:Vector.<Sprite>;
      
      protected var FRecommandInfor:TRecommandInfor;
      
      protected var FCurrentHerosInfor:Vector.<TRecommandHeroInfor>;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FTextField:TextField;
      
      protected var FListItem:TListItemTextField;
      
      protected var FUnstreamizerReveredBook:TUnstreamizerReveredBook;
      
      public function TComponentRecommend(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      protected function TraceObjCorrdinate(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            this.TraceObjCorrdinate(param1.parent);
         }
      }
      
      protected function UIDispatch() : void
      {
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FUIPage.OnChangePage = this.PageChanged;
         this.FUIPage.PageSize = HeroHeadNum;
         this.CreateRoleHeadInfor();
         this.CreateScroolBar();
         this.FRecommandInfor = new TRecommandInfor();
         this.FUnstreamizerReveredBook.UnstreamizationRecommandInfor(null,this.FRecommandInfor,null);
      }
      
      protected function CreateRoleHeadInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         this.FRoleHeadSP = new Vector.<Sprite>();
         this.FRoleHeadPosition = new Vector.<MovieClip>();
         this.FRoleHeadMountPoint = new Vector.<Bitmap>();
         this.FRoleHeadOverState = new Vector.<Sprite>();
         this.FRoleSelectBox = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < HeroHeadNum)
         {
            _loc2_ = this.FMainUI["mc_hero" + _loc1_];
            this.FRoleHeadSP.push(_loc2_);
            this.FRoleSelectBox.push(_loc2_["SelectBox"]);
            _loc2_["SelectBox"].visible = false;
            this.FRoleHeadPosition.push(_loc2_["mc_militaryType"]);
            this.FRoleHeadOverState.push(_loc2_["mc_over"]);
            _loc3_ = new Bitmap();
            _loc2_["mc_head"].addChild(_loc3_);
            this.FRoleHeadMountPoint.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function CreateScroolBar() : void
      {
         this.FScroolBar = new TScrollBar(this.FMainUI["ScroolBar"],350,true,1);
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextField.mouseEnabled = true;
         this.FTextField.selectable = false;
         this.FTextField.multiline = true;
         this.FTextField.wordWrap = true;
         this.FTextField.width = TFWidth;
         this.FTextField.condenseWhite = true;
      }
      
      protected function UILocation() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < HeroHeadNum)
         {
            _loc1_ = this.FRoleHeadSP[_loc2_];
            _loc1_.addEventListener(MouseEvent.CLICK,this.RoleOnMouseClick);
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.RoleOnMouseOver);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.RoleOnMouseOut);
            _loc1_.buttonMode = true;
            _loc2_++;
         }
      }
      
      protected function GetPositionIndexByHeroID(param1:uint) : int
      {
         var _loc2_:TBaseHero = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
         return this.GetStandPositionWithProfession(_loc2_.Profession);
      }
      
      protected function GetStandPositionWithProfession(param1:uint) : int
      {
         switch(param1)
         {
            case CONST_CHARACTER.PROFESSION_Agility:
            case CONST_CHARACTER.PROFESSION_Strength:
               return 2;
            case CONST_CHARACTER.PROFESSION_Defending:
               return 1;
            case CONST_CHARACTER.PROFESSION_Intellect:
               return 3;
            default:
               return 0;
         }
      }
      
      protected function RenderingRoleHeadInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRoleModel = null;
         _loc1_ = this.FCurrentPageIndex * HeroHeadNum;
         _loc2_ = _loc1_ + HeroHeadNum;
         _loc3_ = _loc1_;
         _loc4_ = int(this.FCurrentHerosInfor.length);
         _loc2_ = _loc2_ > _loc4_ ? _loc4_ : _loc2_;
         while(_loc1_ < _loc2_)
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FCurrentHerosInfor[_loc1_].SmallIconID,this.CallBack_RolePicArrive);
            this.FRoleHeadSP[_loc1_ - _loc3_].visible = true;
            this.FRoleHeadMountPoint[_loc1_ - _loc3_].bitmapData = null;
            this.FRoleHeadPosition[_loc1_ - _loc3_].gotoAndStop(this.GetPositionIndexByHeroID(this.FCurrentHerosInfor[_loc1_].HeroID));
            _loc1_++;
         }
         _loc1_ = _loc2_ - _loc3_;
         while(_loc1_ < HeroHeadNum)
         {
            this.FRoleHeadSP[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function CallBack_RolePicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TRoleModel = null;
         _loc4_ = this.FCurrentPageIndex * HeroHeadNum;
         _loc5_ = _loc4_ + HeroHeadNum;
         _loc6_ = _loc4_;
         _loc7_ = int(this.FCurrentHerosInfor.length);
         _loc5_ = _loc5_ > _loc7_ ? _loc7_ : _loc5_;
         while(_loc4_ < _loc5_)
         {
            if(this.FCurrentHerosInfor[_loc4_].SmallIconID == param3)
            {
               this.FRoleHeadMountPoint[_loc4_ - _loc6_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function PageChanged(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderingRoleHeadInfor();
      }
      
      protected function RoleOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleHeadSP.indexOf(param1.currentTarget as Sprite);
         this.FCurrentRecommandIndex = this.GetRoleIndexByRoleHeadIndex(_loc2_);
         this.ChangeHeroInforByIndex(this.FCurrentRecommandIndex,_loc2_);
      }
      
      protected function ChangeHeroInforByIndex(param1:int, param2:int) : void
      {
         var _loc3_:TRecommandHeroInfor = null;
         _loc3_ = this.FCurrentHerosInfor[param1];
         this.FRoleSelectBox[this.FCurrentSelectHeadIndex].visible = false;
         this.FCurrentSelectHeadIndex = param2;
         this.FRoleSelectBox[this.FCurrentSelectHeadIndex].visible = true;
         this.FTextField.htmlText = _loc3_.Description;
         this.FScroolBar.Clear();
         this.FScroolBar.AddItem(this.FTextField);
         this.FScroolBar.ScrollToUp();
      }
      
      protected function GetRoleIndexByRoleHeadIndex(param1:int) : int
      {
         return this.FCurrentPageIndex * HeroHeadNum + param1;
      }
      
      protected function ChangeHeroGroup(param1:int) : void
      {
         this.FCurrentHerosRecommendIndex = param1;
         this.FCurrentHerosInfor = this.FRecommandInfor.RecommandInfor[this.FCurrentHerosRecommendIndex];
         this.SetupPage(this.FCurrentHerosInfor.length,0);
         this.FCurrentPageIndex = 0;
         this.FCurrentRecommandIndex = 0;
         this.ChangeHeroInforByIndex(this.FCurrentRecommandIndex,0);
         this.RenderingRoleHeadInfor();
      }
      
      protected function RoleOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleHeadSP.indexOf(param1.currentTarget as Sprite);
         this.FRoleHeadOverState[_loc2_].visible = true;
      }
      
      protected function RoleOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleHeadSP.indexOf(param1.currentTarget as Sprite);
         this.FRoleHeadOverState[_loc2_].visible = false;
      }
      
      protected function TextLinkOnClick(param1:String) : void
      {
      }
      
      public function get TabInfor() : Vector.<String>
      {
         return this.FRecommandInfor.TabName;
      }
      
      public function set UnstreamizerReveredBook(param1:TUnstreamizerReveredBook) : void
      {
         this.FUnstreamizerReveredBook = param1;
      }
      
      public function LoadResource(param1:Sprite) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.UIDispatch();
         this.UILocation();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.ChangeHeroGroup(0);
         }
      }
      
      public function TabClickNotify(param1:int) : void
      {
         this.ChangeHeroGroup(param1);
      }
      
      public function Reset() : void
      {
      }
   }
}

