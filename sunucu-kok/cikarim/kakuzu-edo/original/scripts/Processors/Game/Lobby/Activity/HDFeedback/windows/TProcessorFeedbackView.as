package Processors.Game.Lobby.Activity.HDFeedback.windows
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFeedback.TFeedbackData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDFeedback.components.TFeedbackPage1Com;
   import Processors.Game.Lobby.Activity.HDFeedback.components.TFeedbackPage2Com;
   import Processors.Game.Lobby.Activity.HDFeedback.components.TFeedbackPage3Com;
   import flash.display.Sprite;
   
   public class TProcessorFeedbackView extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TFeedbackData;
      
      protected var FPage1:TFeedbackPage1Com;
      
      protected var FPage2:TFeedbackPage2Com;
      
      protected var FPage3:TFeedbackPage3Com;
      
      protected var FCurrentPage:int;
      
      protected var FUITab:TUITab;
      
      public function TProcessorFeedbackView(param1:TUIComponent)
      {
         super(param1);
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
         this.FData = param1 as TFeedbackData;
         this.UpdatePage(this.FCurrentPage);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      protected function OnSwitchPage(param1:int) : void
      {
         if(this.FCurrentPage == param1)
         {
            return;
         }
         this.FCurrentPage = param1;
         this.FPage1.Visible = false;
         this.FPage2.Visible = false;
         this.FPage3.Visible = false;
         switch(this.FCurrentPage)
         {
            case 0:
               this.FPage1.Visible = true;
               break;
            case 1:
               this.FPage2.GotoPage1(this.FData.PageVO2.ShowAwardList.length);
               this.FPage2.Visible = true;
               break;
            case 2:
               this.FPage2.GotoPage1(this.FData.PageVO3.ShowAwardList.length);
               this.FPage2.Visible = true;
               break;
            case 3:
               this.FPage3.Visible = true;
         }
         this.UpdatePage(this.FCurrentPage);
      }
      
      protected function UpdatePage(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this.FPage1.UpdateDataBase(this.FData.PageVO1);
               break;
            case 1:
               this.FPage2.UpdateDataBase(this.FData.PageVO2);
               break;
            case 2:
               this.FPage2.UpdateDataBase(this.FData.PageVO3);
               break;
            case 3:
               this.FPage3.UpdateDataBase(this.FData.PageVO4);
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.FPage1 = new TFeedbackPage1Com(this);
         this.FPage2 = new TFeedbackPage2Com(this);
         this.FPage3 = new TFeedbackPage3Com(this);
         this.FPage1.InitWindow(FScene["MC_Page1"]);
         this.FPage2.InitWindow(FScene["MC_Page2"]);
         this.FPage3.InitWindow(FScene["MC_Page3"]);
         this.FPage1.Visible = true;
         this.FPage2.Visible = false;
         this.FPage3.Visible = false;
         this.FPage1.CS = Perform_CS_ActivityOperateReq;
         this.FPage1.ProcessorOnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FPage1.ProcessorOnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FPage2.CS = Perform_CS_ActivityOperateReq;
         this.FPage2.ProcessorOnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FPage2.ProcessorOnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FPage3.CS = Perform_CS_ActivityOperateReq;
         this.FPage3.ProcessorOnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FPage3.ProcessorOnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(FScene["MC_Tab0"],0);
         this.FUITab.SetTabByIndex(FScene["MC_Tab1"],1);
         this.FUITab.SetTabByIndex(FScene["MC_Tab2"],2);
         this.FUITab.SetTabByIndex(FScene["MC_Tab3"],3);
         this.FUITab.OnSwitch = this.OnSwitchPage;
         this.FUITab.Init();
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.FPage1.ActivityID = FActivityAtoms.Identifier;
         this.FPage2.ActivityID = FActivityAtoms.Identifier;
         this.FPage3.ActivityID = FActivityAtoms.Identifier;
      }
   }
}

