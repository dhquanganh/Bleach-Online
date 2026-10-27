package Processors.Game.Lobby.Activity.HDFeedback.components
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.HDFeedback.VO.TFeedbackPageVO;
   import Logics.HDFeedback.VO.TFeedbackShowAwardVO;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TFeedbackPage3Com extends TProcessorLobbyWindow
   {
      
      protected var FData:TFeedbackPageVO;
      
      protected var FScene:MovieClip;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FFightReportBtn:TUIButton;
      
      protected var FGetBtn:TUIButton;
      
      protected var FActivityID:int;
      
      protected var FCS:Function;
      
      protected var FProcessorOnGiftBoxMove:Function;
      
      protected var FProcessorOnGiftBoxOut:Function;
      
      public function TFeedbackPage3Com(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnFightReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TFeedbackShowAwardVO = null;
         _loc3_ = this.FData.ShowAwardList[0];
         SExternalCore.NavigateToLinkUrl(_loc3_.FightReportAddr);
      }
      
      protected function OnGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FData.ShowAwardList[0].CS_Index;
         _loc4_ = this.FData.ShowAwardList[0].CS_Bit;
         this.FCS(this.FActivityID,_loc3_,0,Vector.<int>([_loc4_]));
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
         var _loc2_:MovieClip = null;
         var _loc3_:TFeedbackShowAwardVO = null;
         this.FData = param1;
         if(Visible)
         {
            _loc3_ = this.FData.ShowAwardList[0];
            _loc2_ = this.FScene.MC_Gift;
            _loc2_.TF_Condition1.text = _loc3_.Title1;
            _loc2_.TF_Condition2.text = _loc3_.Title2;
            this.FShowAwardUI.SetData(_loc3_.AwardType,_loc3_.AwardID,_loc3_.ShowAwardID,_loc3_.GiftType);
            if(false)
            {
               this.FFightReportBtn.Visible = false;
            }
            else
            {
               this.FFightReportBtn.Visible = _loc3_.AwardType == TShowAwardUI.ArticalType_Hero;
            }
            _loc2_.MC_Get.visible = _loc3_.GiftState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            this.FGetBtn.Enabled = _loc3_.GiftState == CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         this.FScene = param1;
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(this.FScene.MC_Gift);
         this.FFightReportBtn = new TUIButton();
         this.FFightReportBtn.Substrate = this.FScene.MC_Gift.Btn_FightReport;
         this.FFightReportBtn.OnClick = this.OnFightReportBtnClick;
         this.FGetBtn = new TUIButton();
         this.FGetBtn.Substrate = this.FScene.MC_Gift.Btn_Get;
         this.FGetBtn.OnClick = this.OnGetBtnClick;
      }
   }
}

