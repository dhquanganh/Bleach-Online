package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.TOrgCopyVO;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TCompOrgSingleCopy extends TUIComponent
   {
      
      protected const EachShow_IconCount:uint = 3;
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FTF_Info:TextField;
      
      protected var FScrollText:TScrollTextField;
      
      protected var FIntoBtns:Vector.<TUIButton>;
      
      protected var FIcons:Vector.<MovieClip>;
      
      protected var FGlobalSelectIndex:uint;
      
      protected var FPageIndex:uint;
      
      protected var FSelectBox:MovieClip;
      
      protected var FSelectOffect:TCoordinate;
      
      protected var FHint:THint;
      
      protected var FGetMountInfo:Function;
      
      protected var FSetMountInfo:Function;
      
      protected var FData:TNewOrgData;
      
      protected var FClickBtnGotoSinglePointMap:Function;
      
      public function TCompOrgSingleCopy(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UpdateCopyDes() : void
      {
         this.FTF_Info.htmlText = this.FData.NewOrgSystemLanguage.GetStr15();
      }
      
      protected function GetGlobalIconIndexByLocal(param1:uint) : uint
      {
         return this.FPageIndex * this.EachShow_IconCount + param1;
      }
      
      protected function UpdateSelectBox() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FSelectBox.visible = false;
         _loc2_ = 0;
         while(_loc2_ < this.EachShow_IconCount)
         {
            _loc1_ = this.GetGlobalIconIndexByLocal(_loc2_);
            if(this.FGlobalSelectIndex == _loc1_)
            {
               _loc3_ = this.FIcons[_loc2_];
               this.FSelectBox.x = _loc3_.x + this.FSelectOffect.X;
               this.FSelectBox.y = _loc3_.y + this.FSelectOffect.Y;
               this.FSelectBox.visible = true;
            }
            _loc2_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TOrgCopyVO = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         this.FPageIndex = param2;
         _loc8_ = this.FData.SingleCopys.length;
         _loc3_ = 0;
         while(_loc3_ < this.EachShow_IconCount)
         {
            _loc7_ = this.GetGlobalIconIndexByLocal(_loc3_);
            _loc4_ = this.FIcons[_loc3_];
            if(_loc7_ < _loc8_)
            {
               _loc5_ = this.FIntoBtns[_loc3_];
               _loc6_ = this.FData.SingleCopys[_loc7_];
               _loc4_.MC_Pic.gotoAndStop(_loc7_ + 1);
               _loc4_.TF_Level.text = _loc6_.City.OpenLevel;
               _loc5_.Enabled = this.FData.SingleAllowInto(_loc7_);
               _loc4_.visible = true;
            }
            else
            {
               _loc4_.visible = false;
               _loc4_.MC_Pic.stop();
            }
            _loc3_++;
         }
         this.UpdateSelectBox();
      }
      
      protected function OnIntoBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnGotoSinglePointMap != null)
         {
            this.FData.SelectCopy(this.FData.CopyType_Single,this.GetGlobalIconIndexByLocal(this.FIntoBtns.indexOf(param1)));
            this.FClickBtnGotoSinglePointMap();
         }
      }
      
      protected function OnIntoBtnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         _loc4_ = param1 as TUIButton;
         if(!_loc4_.Enabled)
         {
            _loc3_ = this.GetGlobalIconIndexByLocal(this.FIntoBtns.indexOf(param1));
            this.FHint.Caption = this.FData.NewOrgSystemLanguage.GetStr35(_loc3_);
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnIntoBtnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(!_loc3_.Enabled)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnIconOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.target as MovieClip;
         _loc2_.MC_Bg.gotoAndStop(1);
      }
      
      protected function OnIconOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.target as MovieClip;
         _loc2_.MC_Bg.gotoAndStop(2);
      }
      
      protected function OnIconClick(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:Array = _loc2_.split("_");
         var _loc4_:uint = uint(_loc3_[2]);
         this.FGlobalSelectIndex = this.GetGlobalIconIndexByLocal(_loc4_);
         this.UpdateSelectBox();
         this.UpdateCopyDes();
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         super.Visible = param1;
         this.Update();
         if(this.FGetMountInfo == null)
         {
            return;
         }
         if(Visible)
         {
            _loc2_ = this.FGetMountInfo();
            if(_loc2_ != null)
            {
               _loc3_ = Math.floor(this.FData.LinkGlobalIndex / this.EachShow_IconCount);
               this.FPage.SetupPage(this.FPage.TotalQuantity,_loc3_);
               this.FPageIndex = _loc3_;
               this.PageOnSwitch(null,this.FPageIndex);
               this.FGlobalSelectIndex = this.FData.LinkGlobalIndex;
               this.UpdateSelectBox();
               this.UpdateCopyDes();
               this.FSetMountInfo(null);
            }
         }
      }
      
      public function set Data(param1:TNewOrgData) : void
      {
         this.FData = param1;
      }
      
      public function set ClickBtnGotoSinglePointMap(param1:Function) : void
      {
         this.FClickBtnGotoSinglePointMap = param1;
      }
      
      public function set GetMountInfo(param1:Function) : void
      {
         this.FGetMountInfo = param1;
      }
      
      public function set SetMountInfo(param1:Function) : void
      {
         this.FSetMountInfo = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TUIButton = null;
         var _loc8_:MovieClip = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FGlobalSelectIndex = 0;
         this.FPageIndex = 0;
         this.FHint = new THint();
         this.FIcons = new Vector.<MovieClip>(this.EachShow_IconCount);
         this.FIntoBtns = new Vector.<TUIButton>(this.EachShow_IconCount);
         this.FSelectOffect = new TCoordinate();
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.PageSize = this.EachShow_IconCount;
         this.FPage.TotalQuantity = this.FData.SingleCopys.length;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         _loc3_ = this.FMainUI["MC_Des"];
         this.FTF_Info = _loc3_["TF_Info"];
         this.FScrollText = new TScrollTextField(this.FTF_Info);
         _loc3_.addChild(this.FScrollText);
         this.FScorll = new TScrollBarSimple(this,_loc3_.mc_bar,_loc3_.btn_up,_loc3_.btn_down,55,this.FScrollText);
         _loc4_ = 0;
         while(_loc4_ < this.EachShow_IconCount)
         {
            _loc5_ = this.FMainUI["MC_Icon_" + _loc4_];
            _loc6_ = _loc5_["Btn_Into"];
            this.FIcons[_loc4_] = _loc5_;
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_;
            _loc7_.OnClick = this.OnIntoBtnClick;
            _loc7_.OnMove = this.OnIntoBtnOver;
            _loc7_.OnOut = this.OnIntoBtnOut;
            this.FIntoBtns[_loc4_] = _loc7_;
            _loc8_ = _loc5_["MC_Bg"];
            _loc8_.gotoAndStop(1);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,this.OnIconOver);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,this.OnIconOut);
            _loc5_.addEventListener(MouseEvent.CLICK,this.OnIconClick);
            _loc4_++;
         }
         this.FSelectBox = this.FMainUI["MC_Select"];
         this.FSelectBox.gotoAndStop(this.FSelectBox.totalFrames);
         this.FSelectBox.mouseEnabled = this.FSelectBox.mouseChildren = false;
         this.FSelectOffect.X = -6;
         this.FSelectOffect.Y = -6;
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.PageOnSwitch(null,this.FPageIndex);
            this.UpdateCopyDes();
         }
      }
      
      public function LogicsPerform() : void
      {
         if(Visible)
         {
            if(this.FScorll != null)
            {
               this.FScorll.LogicsProcess();
            }
         }
      }
      
      public function removeEventAll() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < this.EachShow_IconCount)
         {
            _loc2_ = this.FMainUI["MC_Icon_" + _loc1_];
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.OnIconOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.OnIconOut);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.OnIconClick);
            _loc1_++;
         }
      }
   }
}

