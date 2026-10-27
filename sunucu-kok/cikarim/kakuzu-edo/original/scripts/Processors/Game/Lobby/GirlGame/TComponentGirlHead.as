package Processors.Game.Lobby.GirlGame
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.GirlGame.TGirlInfor;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComponentGirlHead extends TUIComponent
   {
      
      protected static const PageSize:int = 5;
      
      protected var FUIPage:TUIPage;
      
      protected var FMainUI:MovieClip;
      
      protected var FCurrentPageIndex:int;
      
      protected var FSelectBox:Vector.<MovieClip>;
      
      protected var FTFNames:Vector.<TextField>;
      
      protected var FPicMountPoint:Vector.<Bitmap>;
      
      protected var FButtons:Vector.<TUIButton>;
      
      protected var FPromptWindow:TUIWindowConfirmation;
      
      protected var FIfNeedPrompt:Boolean;
      
      protected var FCurrentShowGir:TGirlInfor;
      
      protected var FCurrentSelectGirl:TGirlInfor;
      
      protected var FCurrentSelectBox:MovieClip;
      
      protected var FCurrentSelectBoxIndex:int;
      
      protected var FHint:THint;
      
      protected var FGirls:Vector.<TGirlInfor>;
      
      protected var FOnSelectGirl:Function;
      
      public function TComponentGirlHead(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         var _loc4_:TUIButton = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("CharList") as MovieClip;
         addChild(this.FMainUI);
         this.FSelectBox = new Vector.<MovieClip>();
         this.FTFNames = new Vector.<TextField>();
         this.FPicMountPoint = new Vector.<Bitmap>();
         this.FButtons = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < PageSize)
         {
            _loc2_ = this.FMainUI["Slot" + _loc1_];
            this.FSelectBox.push(this.FMainUI["SelectBox" + _loc1_]);
            this.FMainUI["SelectBox" + _loc1_].visible = false;
            this.FTFNames.push(_loc2_["Name"]);
            _loc3_ = new Bitmap();
            _loc2_["PicMountPoint"].addChild(_loc3_);
            this.FPicMountPoint.push(_loc3_);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc2_;
            _loc4_.OnClick = this.CallBack_BtnClick;
            _loc4_.OnMove = this.CallBack_BtnMove;
            _loc4_.OnOut = this.CallBack_BtnOut;
            this.FButtons.push(_loc4_);
            _loc1_++;
         }
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["btn_left"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["btn_right"];
         this.FUIPage.PageSize = PageSize;
         this.FUIPage.OnChangePage = this.CallBack_ChangePage;
         this.FPromptWindow = new TUIWindowConfirmation(this);
         this.FPromptWindow.OnOK = this.PromptWindowOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FPromptWindow);
         this.FPromptWindow.SetCheckBoxUsable(true);
         this.FIfNeedPrompt = true;
         this.FPromptWindow.Visible = false;
         this.FHint = new THint();
      }
      
      protected function UILocation() : void
      {
         this.FMainUI.x = 0;
         this.FMainUI.y = 100;
         this.FPromptWindow.X = (FUICore.StageWidth - this.FPromptWindow.width) / 2;
         this.FPromptWindow.Y = (FUICore.StageHeight - this.FPromptWindow.height) / 2;
      }
      
      protected function PromptWindowOnOK(param1:Object) : void
      {
         this.FIfNeedPrompt = !this.FPromptWindow.IsSelected;
         this.FCurrentShowGir.CurrentSchedule = this.FCurrentShowGir.Clothes.length - 1;
         this.ReselectOneGirl(this.FCurrentSelectGirl,this.FCurrentSelectBoxIndex);
         this.FPromptWindow.Visible = false;
      }
      
      protected function CheckIfNeedPrompt(param1:TGirlInfor) : Boolean
      {
         var _loc2_:String = "切换美女将导致%0进度重置,是否切换？";
         if(!this.FIfNeedPrompt)
         {
            return false;
         }
         if(param1.CurrentSchedule != 0 && param1.CurrentSchedule != param1.Clothes.length - 1)
         {
            this.FPromptWindow.Visible = true;
            this.FPromptWindow.Text = TUtilityString.Format(_loc2_,param1.Name);
            return true;
         }
         return false;
      }
      
      protected function ReselectOneGirl(param1:TGirlInfor, param2:int) : void
      {
         this.FCurrentShowGir = param1;
         param1.CurrentSchedule = param1.Clothes.length - 1;
         if(this.FCurrentSelectBox != null)
         {
            this.FCurrentSelectBox.visible = false;
            this.FCurrentSelectBox.stop();
         }
         this.FCurrentSelectBox = this.FSelectBox[param2];
         this.FCurrentSelectBox.gotoAndPlay(1);
         this.FCurrentSelectBox.visible = true;
         if(this.FOnSelectGirl != null)
         {
            this.FOnSelectGirl(param1,param1.Clothes.length - 1);
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function LoadPic() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGirlInfor = null;
         var _loc5_:String = null;
         _loc2_ = this.FCurrentPageIndex * PageSize;
         _loc3_ += _loc2_ + PageSize;
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            SResourcesCore.TexturesSmallIcon.LoadAutoSecondary(this.FGirls[_loc1_].ID,this.PicArrive);
            _loc4_ = this.FGirls[_loc1_];
            if(_loc4_.IfOpen)
            {
               this.FTFNames[_loc1_].text = _loc4_.Name;
               this.FTFNames[_loc1_].textColor = CONST_COMMON.TEXT_White_Color;
            }
            else
            {
               _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_11);
               this.FTFNames[_loc1_].text = TUtilityString.Format(_loc5_,_loc4_.OpenCondition);
               this.FTFNames[_loc1_].textColor = CONST_COMMON.TEXT_Red_Color;
            }
            _loc1_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc5_ = this.FCurrentPageIndex * PageSize;
         _loc6_ += _loc5_ + PageSize;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            if(param3 == this.FGirls[_loc4_].ID)
            {
               this.FPicMountPoint[_loc4_ - _loc5_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function CallBack_ChangePage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
      }
      
      protected function CallBack_BtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function CallBack_BtnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FButtons.indexOf(param1 as TUIButton);
         _loc4_ = _loc3_ + this.FCurrentPageIndex * PageSize;
         this.FHint.Caption = this.FGirls[_loc4_].RewardString;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function CallBack_BtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.FCurrentSelectBoxIndex = this.FButtons.indexOf(param1 as TUIButton);
         _loc3_ = this.FCurrentSelectBoxIndex + this.FCurrentPageIndex * PageSize;
         this.FCurrentSelectGirl = this.FGirls[_loc3_];
         if(this.CheckIfNeedPrompt(this.FCurrentShowGir))
         {
            this.FPromptWindow.Visible = true;
            return;
         }
         this.ReselectOneGirl(this.FCurrentSelectGirl,this.FCurrentSelectBoxIndex);
      }
      
      public function set OnSelectGirl(param1:Function) : void
      {
         this.FOnSelectGirl = param1;
      }
      
      public function LoadResource() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function Reset() : void
      {
         if(this.FGirls == null)
         {
            this.SetupPage(0,0);
         }
         else
         {
            this.SetupPage(this.FGirls.length,0);
         }
      }
      
      public function ShowGirl(param1:Vector.<TGirlInfor>) : void
      {
         this.FGirls = param1;
         this.SetupPage(this.FGirls.length,0);
         this.LoadPic();
      }
      
      public function SelectFristGirl() : void
      {
         if(this.FCurrentSelectBox != null)
         {
            this.FCurrentSelectBox.visible = false;
            this.FCurrentSelectBox.stop();
         }
         this.FSelectBox[0].visible = true;
         this.FSelectBox[0].play();
         this.FCurrentSelectBox = this.FSelectBox[0];
         this.FCurrentSelectGirl = this.FGirls[0];
         this.FCurrentShowGir = this.FGirls[0];
      }
   }
}

