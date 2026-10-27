package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.TBaseOrganization;
   import Logics.Organization.VO.TOrgCopyVO;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TCompOrgGroupCopy extends TUIComponent
   {
      
      protected const EachShow_IconCount:uint = 3;
      
      protected const BtnType_Reset:uint = 0;
      
      protected const BtnType_Start:uint = 1;
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FTF_Info:TextField;
      
      protected var FScrollText:TScrollTextField;
      
      protected var FIntoBtns:Vector.<TUIButton>;
      
      protected var FResetOrStartBtns:Vector.<TUIButton>;
      
      protected var FIcons:Vector.<MovieClip>;
      
      protected var FTimeTexts:Vector.<TextField>;
      
      protected var FGlobalSelectIndex:uint;
      
      protected var FPageIndex:uint;
      
      protected var FSelectBox:MovieClip;
      
      protected var FSelectOffect:TCoordinate;
      
      protected var FHint:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FCurrentResetOrStartBtnIndex:uint;
      
      protected var FLastTick:Number;
      
      protected var FGetMountInfo:Function;
      
      protected var FSetMountInfo:Function;
      
      protected var FData:TNewOrgData;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FBaseData:TBaseOrganization;
      
      protected var FClickBtnGotoGroupPointMap:Function;
      
      protected var FMainValueUpdate:Function;
      
      public function TCompOrgGroupCopy(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UpdateCopyDes() : void
      {
         this.FTF_Info.htmlText = this.FData.NewOrgSystemLanguage.GetStr16();
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
      
      protected function UpdateTimeUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TextField = null;
         var _loc3_:TOrgCopyVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = this.FData.GroupCopys.length;
         _loc1_ = 0;
         while(_loc1_ < this.EachShow_IconCount)
         {
            _loc4_ = this.GetGlobalIconIndexByLocal(_loc1_);
            if(_loc4_ < _loc5_)
            {
               _loc3_ = this.FData.GroupCopys[_loc4_];
               if(_loc3_.Open)
               {
                  _loc2_ = this.FTimeTexts[_loc1_];
                  _loc2_.text = this.FData.NewOrgSystemLanguage.GetStr20(_loc3_.Day,_loc3_.Hours,_loc3_.Minute);
               }
            }
            _loc1_++;
         }
      }
      
      protected function CountDown() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = STimingCore.TickCount / 1000 - this.FLastTick;
         this.FLastTick += _loc1_;
         this.FData.UpdateGroupCopyRestTime(_loc1_);
         this.UpdateTimeUI();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TUIButton = null;
         var _loc7_:TOrgCopyVO = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         this.FPageIndex = param2;
         _loc9_ = this.FData.GroupCopys.length;
         _loc3_ = 0;
         while(_loc3_ < this.EachShow_IconCount)
         {
            _loc8_ = this.GetGlobalIconIndexByLocal(_loc3_);
            _loc4_ = this.FIcons[_loc3_];
            if(_loc8_ < _loc9_)
            {
               _loc5_ = this.FIntoBtns[_loc3_];
               _loc6_ = this.FResetOrStartBtns[_loc3_];
               _loc7_ = this.FData.GroupCopys[_loc8_];
               _loc4_.MC_Pic.gotoAndStop(_loc8_ + 1);
               _loc5_.Enabled = this.FData.GroupAllowInto(_loc8_);
               _loc6_.Enabled = this.FBaseData.OrgPower == TBaseOrganization.Power_Main || this.FBaseData.OrgPower == TBaseOrganization.Power_Second;
               _loc4_.visible = true;
               if(_loc7_.Open)
               {
                  _loc4_.MC_NotOpen.visible = false;
                  _loc4_.MC_RemainAndTime.visible = true;
                  _loc4_.MC_RemainAndTime.TF_Remain.text = this.FData.GetCopyRemainFight(_loc7_).toString();
                  _loc6_.Caption = this.FData.NewOrgSystemLanguage.GetStr10();
                  _loc6_.Tag = this.BtnType_Reset;
               }
               else
               {
                  _loc4_.MC_NotOpen.visible = true;
                  _loc4_.MC_RemainAndTime.visible = false;
                  _loc6_.Caption = this.FData.NewOrgSystemLanguage.GetStr9();
                  _loc6_.Tag = this.BtnType_Start;
               }
            }
            else
            {
               _loc4_.visible = false;
               _loc4_.MC_Pic.stop();
            }
            _loc3_++;
         }
         this.UpdateSelectBox();
         this.UpdateTimeUI();
      }
      
      protected function OnIntoBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnGotoGroupPointMap != null)
         {
            this.FData.SelectCopy(this.FData.CopyType_Group,this.GetGlobalIconIndexByLocal(this.FIntoBtns.indexOf(param1)));
            this.FClickBtnGotoGroupPointMap();
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
            this.FHint.Caption = this.FData.NewOrgSystemLanguage.GetStr8(_loc3_);
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
      
      protected function OnResetOrStartBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TOrgCopyVO = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         _loc7_ = true;
         this.FCurrentResetOrStartBtnIndex = this.GetGlobalIconIndexByLocal(this.FResetOrStartBtns.indexOf(param1));
         _loc3_ = param1 as TUIButton;
         if(_loc3_.Tag == this.BtnType_Start)
         {
            _loc5_ = this.FCurrentResetOrStartBtnIndex - 1;
            if(_loc5_ >= 0)
            {
               _loc4_ = this.FData.GroupCopys[_loc5_];
               if(!_loc4_.Open)
               {
                  _loc6_ = this.FData.NewOrgSystemLanguage.GetStr22();
                  _loc7_ = false;
               }
               if(!_loc7_)
               {
                  SToolReward.ShowMessage(_loc6_);
                  return;
               }
            }
            this.FUIWindowConfirmation.Text = this.FData.NewOrgSystemLanguage.GetStr11(this.FCurrentResetOrStartBtnIndex);
            this.FUIWindowConfirmation.OnOK = this.OnStartBtnOKClick;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowConfirmation.Text = this.FData.NewOrgSystemLanguage.GetStr13(this.FCurrentResetOrStartBtnIndex);
            this.FUIWindowConfirmation.OnOK = this.OnResetBtnOKClick;
            this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function OnStartBtnOKClick(param1:Object) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FData.OrgConfigValue.Legion_Open_Consumption[this.FCurrentResetOrStartBtnIndex];
         if(this.FBaseData.GroupActive >= _loc2_)
         {
            this.FUnstreamizerOrganizationNew.GroupOpenReq(this.FCurrentResetOrStartBtnIndex);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr12());
         }
      }
      
      protected function OnResetBtnOKClick(param1:Object) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FData.OrgConfigValue.Legion_Reset_Consumption[this.FCurrentResetOrStartBtnIndex];
         if(this.FBaseData.GroupActive >= _loc2_)
         {
            this.FUnstreamizerOrganizationNew.CopyRefreshReq(this.FCurrentResetOrStartBtnIndex);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr12());
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
         if(!Visible && param1)
         {
            this.FLastTick = STimingCore.TickCount / 1000;
         }
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
      
      public function set ClickBtnGotoGroupPointMap(param1:Function) : void
      {
         this.FClickBtnGotoGroupPointMap = param1;
      }
      
      public function set BaseData(param1:TBaseOrganization) : void
      {
         this.FBaseData = param1;
      }
      
      public function set MainValueUpdate(param1:Function) : void
      {
         this.FMainValueUpdate = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
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
         var _loc7_:MovieClip = null;
         var _loc8_:TUIButton = null;
         var _loc9_:MovieClip = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FGlobalSelectIndex = 0;
         this.FPageIndex = 0;
         this.FHint = new THint();
         this.FIcons = new Vector.<MovieClip>(this.EachShow_IconCount);
         this.FIntoBtns = new Vector.<TUIButton>(this.EachShow_IconCount);
         this.FResetOrStartBtns = new Vector.<TUIButton>(this.EachShow_IconCount);
         this.FTimeTexts = new Vector.<TextField>(this.EachShow_IconCount);
         this.FSelectOffect = new TCoordinate();
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.PageSize = this.EachShow_IconCount;
         this.FPage.TotalQuantity = this.FData.GroupCopys.length;
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
            _loc7_ = _loc5_["Btn_ResetOrStart"];
            this.FIcons[_loc4_] = _loc5_;
            _loc8_ = new TUIButton();
            _loc8_.Substrate = _loc6_;
            _loc8_.OnClick = this.OnIntoBtnClick;
            _loc8_.OnMove = this.OnIntoBtnOver;
            _loc8_.OnOut = this.OnIntoBtnOut;
            this.FIntoBtns[_loc4_] = _loc8_;
            _loc8_ = new TUIButton();
            _loc8_.Substrate = _loc7_;
            _loc8_.OnClick = this.OnResetOrStartBtnClick;
            this.FResetOrStartBtns[_loc4_] = _loc8_;
            _loc9_ = _loc5_["MC_Bg"];
            _loc9_.gotoAndStop(1);
            this.FTimeTexts[_loc4_] = _loc5_["MC_RemainAndTime"]["TF_Time"];
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,this.OnIconOver);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,this.OnIconOut);
            _loc5_.addEventListener(MouseEvent.CLICK,this.OnIconClick);
            _loc4_++;
         }
         this.FSelectBox = this.FMainUI["MC_Select"];
         this.FSelectBox.gotoAndStop(this.FSelectBox.totalFrames);
         this.FSelectBox.mouseChildren = this.FSelectBox.mouseEnabled = false;
         this.FSelectOffect.X = -6;
         this.FSelectOffect.Y = -6;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
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
         if(!Visible)
         {
            return;
         }
         if(this.FScorll != null)
         {
            this.FScorll.LogicsProcess();
         }
         this.CountDown();
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
      
      public function StartCopyUpdateUI() : void
      {
         if(this.FMainValueUpdate != null)
         {
            this.FMainValueUpdate();
         }
         this.Update();
         SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr14());
      }
      
      public function ResetCopyUpdateUI() : void
      {
         if(this.FMainValueUpdate != null)
         {
            this.FMainValueUpdate();
         }
         this.Update();
         SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr5());
      }
   }
}

