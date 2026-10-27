package Processors.Game.Lobby.Activity.HDFeedback.components
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.HDFeedback.VO.TFeedbackPageVO;
   import Logics.HDFeedback.VO.TFeedbackShowAwardVO;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TFeedbackPage2Com extends TProcessorLobbyWindow
   {
      
      protected const EachMax:int = 4;
      
      protected var FData:TFeedbackPageVO;
      
      protected var FScene:MovieClip;
      
      protected var FShowAwardUIList:Vector.<TShowAwardUI>;
      
      protected var FPageUI:TUIPage;
      
      protected var FFightReportBtns:Vector.<TUIButton>;
      
      protected var FGetBtns:Vector.<TUIButton>;
      
      protected var FLinkBtn:TUIButton;
      
      protected var FCurrentPage:int;
      
      protected var FActivityID:int;
      
      protected var FCS:Function;
      
      protected var FProcessorOnGiftBoxMove:Function;
      
      protected var FProcessorOnGiftBoxOut:Function;
      
      public function TFeedbackPage2Com(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function LocalIndexToGlobal(param1:int) : int
      {
         return this.FCurrentPage * this.EachMax + param1;
      }
      
      protected function UpdateCurrentPage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TFeedbackShowAwardVO = null;
         var _loc6_:int = 0;
         if(this.FData == null)
         {
            return;
         }
         _loc6_ = int(this.FData.ShowAwardList.length);
         _loc1_ = 0;
         while(_loc1_ < this.EachMax)
         {
            _loc2_ = this.FScene["MC_Gift_" + _loc1_];
            if(this.LocalIndexToGlobal(_loc1_) >= _loc6_)
            {
               _loc2_.visible = false;
            }
            else
            {
               _loc2_.visible = true;
               _loc5_ = this.FData.ShowAwardList[this.LocalIndexToGlobal(_loc1_)];
               _loc4_ = _loc2_.TF_Condition1;
               _loc4_.text = _loc5_.Title1;
               this.FShowAwardUIList[_loc1_].SetData(_loc5_.AwardType,_loc5_.AwardID,_loc5_.ShowAwardID,_loc5_.GiftType);
               this.FFightReportBtns[_loc1_].Visible = _loc5_.AwardType == TShowAwardUI.ArticalType_Hero;
               _loc2_.MC_Get.visible = _loc5_.GiftState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
               this.FGetBtns[_loc1_].Enabled = _loc5_.GiftState == CONST_ACTIVITY_MODE.Activity_CanReceive;
            }
            _loc1_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      protected function OnFightReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TFeedbackShowAwardVO = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FData.ShowAwardList[this.LocalIndexToGlobal(_loc3_.Tag)];
         SExternalCore.NavigateToLinkUrl(_loc4_.FightReportAddr);
      }
      
      protected function OnGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIButton = null;
         _loc5_ = param1 as TUIButton;
         _loc3_ = this.FData.ShowAwardList[this.LocalIndexToGlobal(_loc5_.Tag)].CS_Index;
         _loc4_ = this.FData.ShowAwardList[this.LocalIndexToGlobal(_loc5_.Tag)].CS_Bit;
         this.FCS(this.FActivityID,_loc3_,0,Vector.<int>([_loc4_]));
      }
      
      protected function OnLinkBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(this.FData.LinkID);
      }
      
      public function set ActivityID(param1:int) : void
      {
         this.FActivityID = param1;
      }
      
      public function set CS(param1:Function) : void
      {
         this.FCS = param1;
      }
      
      public function set ProcessorOnGiftBoxOut(param1:Function) : void
      {
         this.FProcessorOnGiftBoxOut = param1;
      }
      
      public function set ProcessorOnGiftBoxMove(param1:Function) : void
      {
         this.FProcessorOnGiftBoxMove = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FScene != null)
         {
            this.FScene.visible = param1;
         }
      }
      
      public function UpdateDataBase(param1:TFeedbackPageVO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TextField = null;
         var _loc6_:TFeedbackShowAwardVO = null;
         this.FData = param1;
         if(Visible)
         {
            if(this.FPageUI.TotalQuantity == 0)
            {
               this.FPageUI.SetupPage(this.FData.ShowAwardList.length,0);
               this.FCurrentPage = 0;
            }
            this.UpdateCurrentPage();
            this.FScene.TF_ProgDesc.text = this.FData.ProgressDesc;
            this.FScene.TF_Prog.text = this.FData.Progress;
         }
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TShowAwardUI = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUIButton = null;
         this.FScene = param1;
         this.FShowAwardUIList = new Vector.<TShowAwardUI>(this.EachMax);
         this.FFightReportBtns = new Vector.<TUIButton>(this.EachMax);
         this.FGetBtns = new Vector.<TUIButton>(this.EachMax);
         _loc2_ = 0;
         while(_loc2_ < this.EachMax)
         {
            _loc4_ = this.FScene["MC_Gift_" + _loc2_];
            _loc3_ = new TShowAwardUI(this);
            _loc3_.UIDispatch(_loc4_);
            this.FShowAwardUIList[_loc2_] = _loc3_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_.Btn_FightReport;
            _loc6_.OnClick = this.OnFightReportBtnClick;
            _loc6_.Tag = _loc2_;
            this.FFightReportBtns[_loc2_] = _loc6_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_.Btn_Get;
            _loc6_.OnClick = this.OnGetBtnClick;
            _loc6_.Tag = _loc2_;
            this.FGetBtns[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = this.FScene.MC_PageRight;
         this.FPageUI.ButtonPrevious.Substrate = this.FScene.MC_PageLeft;
         this.FPageUI.LabelPage = this.FScene.TF_Page;
         this.FPageUI.PageSize = this.EachMax;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
         this.FLinkBtn = new TUIButton();
         this.FLinkBtn.Substrate = this.FScene.Btn_Link;
         this.FLinkBtn.OnClick = this.OnLinkBtnClick;
      }
      
      public function GotoPage1(param1:uint) : void
      {
         this.FPageUI.SetupPage(param1,0);
         this.FCurrentPage = 0;
         this.UpdateCurrentPage();
      }
   }
}

