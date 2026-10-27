package Processors.Game.Lobby.Activity.HDDayBack.windows
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.ActivityVO.THDShowAwardVO;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDayBack.TDayBackData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorDayBackView extends TProcessorHDSingleWindowBase
   {
      
      protected const EachMax:int = 3;
      
      protected var FData:TDayBackData;
      
      protected var FLoginGiftGetBtn:TUIButton;
      
      protected var FLoginGiftShowBtn:TUIButton;
      
      protected var FLinkBtn:TUIButton;
      
      protected var FRechGiftGetBtns:Vector.<TUIButton>;
      
      protected var FRechGiftFightBtns:Vector.<TUIButton>;
      
      protected var FFinalGiftGetBtn:TUIButton;
      
      protected var FFinalGiftFightBtn:TUIButton;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:int;
      
      protected var FRechShowAwardUIList:Vector.<TShowAwardUI>;
      
      protected var FFinalShowAwardUI:TShowAwardUI;
      
      public function TProcessorDayBackView(param1:TUIComponent)
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
         var _loc3_:THDShowAwardVO = null;
         var _loc4_:int = 0;
         if(this.FData == null)
         {
            return;
         }
         _loc4_ = int(this.FData.RechGifts.length);
         _loc1_ = 0;
         while(_loc1_ < this.EachMax)
         {
            _loc2_ = FScene["MC_RechGift_" + _loc1_];
            if(this.LocalIndexToGlobal(_loc1_) >= _loc4_)
            {
               _loc2_.visible = false;
            }
            else
            {
               _loc2_.visible = true;
               _loc3_ = this.FData.RechGifts[this.LocalIndexToGlobal(_loc1_)];
               _loc2_.TF_Condition.text = _loc3_.Condition[0].toString();
               this.FRechShowAwardUIList[_loc1_].SetData(_loc3_.AwardType,_loc3_.AwardID,_loc3_.ShowAwardID,_loc3_.GiftType);
               this.FRechGiftFightBtns[_loc1_].Visible = _loc3_.AwardType == TShowAwardUI.ArticalType_Hero;
               _loc2_.MC_Get.visible = _loc3_.State == Activity_AlreadyReceive;
               this.FRechGiftGetBtns[_loc1_].Enabled = _loc3_.State == Activity_CanReceive;
            }
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:MovieClip = null;
         this.FData = param1 as TDayBackData;
         if(this.FPageUI.TotalQuantity == 0)
         {
            this.FPageUI.SetupPage(this.FData.RechGifts.length,0);
            this.FCurrentPage = 0;
         }
         this.UpdateCurrentPage();
         _loc2_ = FScene["MC_LoginGift"];
         this.FLoginGiftGetBtn.Enabled = this.FData.LoginGiftVO.State == Activity_CanReceive;
         _loc2_.MC_Get.visible = this.FData.LoginGiftVO.State == Activity_AlreadyReceive;
         FScene["TF_Prog"].text = this.FData.Prog.toString();
         _loc2_ = FScene["MC_FinalGift"];
         this.FFinalShowAwardUI.SetData(this.FData.FinalGift.AwardType,this.FData.FinalGift.AwardID,this.FData.FinalGift.ShowAwardID,this.FData.FinalGift.GiftType);
         _loc2_.TF_Condition.text = this.FData.FinalGift.Condition[0].toString();
         this.FFinalGiftFightBtn.Visible = this.FData.FinalGift.AwardType == TShowAwardUI.ArticalType_Hero;
         _loc2_.MC_Get.visible = this.FData.FinalGift.State == Activity_AlreadyReceive;
         this.FFinalGiftGetBtn.Enabled = this.FData.FinalGift.State == Activity_CanReceive;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      protected function OnLoginGiftGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.LoginGiftVO.CS_Index);
      }
      
      protected function OnLoginGiftMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.LoginGiftVO.Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnLoginGiftOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnLinkBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(this.FData.Link);
      }
      
      protected function OnRechGiftGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THDShowAwardVO = null;
         _loc3_ = this.LocalIndexToGlobal((param1 as TUIButton).Tag);
         _loc4_ = this.FData.RechGifts[_loc3_];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc4_.CS_Index,0,Vector.<int>([_loc4_.CS_Bit]));
      }
      
      protected function OnRechGiftFightBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THDShowAwardVO = null;
         _loc3_ = this.LocalIndexToGlobal((param1 as TUIButton).Tag);
         _loc4_ = this.FData.RechGifts[_loc3_];
         SExternalCore.NavigateToLinkUrl(_loc4_.FightReportAddr);
      }
      
      protected function OnFinalGiftGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.FinalGift.CS_Index);
      }
      
      protected function OnFinalGiftFightBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.FinalGift.FightReportAddr);
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:TUIButton = null;
         var _loc6_:TShowAwardUI = null;
         super.InitWindow(param1);
         _loc2_ = FScene["MC_LoginGift"];
         this.FLoginGiftGetBtn = new TUIButton();
         this.FLoginGiftGetBtn.Substrate = _loc2_.Btn_Get;
         this.FLoginGiftGetBtn.OnClick = this.OnLoginGiftGetBtnClick;
         this.FLoginGiftShowBtn = new TUIButton();
         this.FLoginGiftShowBtn.Substrate = _loc2_.MC_Gift;
         this.FLoginGiftShowBtn.OnMove = this.OnLoginGiftMove;
         this.FLoginGiftShowBtn.OnOut = this.OnLoginGiftOut;
         this.FLinkBtn = new TUIButton();
         this.FLinkBtn.Substrate = FScene["Btn_Link"];
         this.FLinkBtn.OnClick = this.OnLinkBtnClick;
         this.FRechGiftGetBtns = new Vector.<TUIButton>(this.EachMax);
         this.FRechGiftFightBtns = new Vector.<TUIButton>(this.EachMax);
         this.FRechShowAwardUIList = new Vector.<TShowAwardUI>(this.EachMax);
         _loc4_ = 0;
         while(_loc4_ < this.EachMax)
         {
            _loc2_ = FScene["MC_RechGift_" + _loc4_];
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc2_.Btn_Get;
            _loc5_.OnClick = this.OnRechGiftGetBtnClick;
            _loc5_.Tag = _loc4_;
            this.FRechGiftGetBtns[_loc4_] = _loc5_;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc2_.Btn_FightReport;
            _loc5_.OnClick = this.OnRechGiftFightBtnClick;
            _loc5_.Tag = _loc4_;
            this.FRechGiftFightBtns[_loc4_] = _loc5_;
            _loc6_ = new TShowAwardUI(this);
            _loc6_.UIDispatch(_loc2_);
            this.FRechShowAwardUIList[_loc4_] = _loc6_;
            _loc4_++;
         }
         _loc2_ = FScene["MC_FinalGift"];
         this.FFinalGiftGetBtn = new TUIButton();
         this.FFinalGiftGetBtn.Substrate = _loc2_.Btn_Get;
         this.FFinalGiftGetBtn.OnClick = this.OnFinalGiftGetBtnClick;
         this.FFinalShowAwardUI = new TShowAwardUI(this);
         this.FFinalShowAwardUI.UIDispatch(_loc2_);
         this.FFinalGiftFightBtn = new TUIButton();
         this.FFinalGiftFightBtn.Substrate = _loc2_.Btn_FightReport;
         this.FFinalGiftFightBtn.OnClick = this.OnFinalGiftFightBtnClick;
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = FScene["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = FScene["MC_PageLeft"];
         this.FPageUI.LabelPage = FScene["TF_Page"];
         this.FPageUI.PageSize = this.EachMax;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
      }
   }
}

