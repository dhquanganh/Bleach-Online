package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   
   public class TViewPartnerReadyGuide extends TProcessorLobbyWindow
   {
      
      protected static const ReadyReport_Num:int = 6;
      
      protected var FMainUI:Sprite;
      
      protected var FReportItems:Vector.<TItemReadyReport>;
      
      public function TViewPartnerReadyGuide(param1:TUIComponent, param2:Sprite)
      {
         this.FMainUI = param2;
         super(param1);
         this.InitView();
      }
      
      protected function InitView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TItemReadyReport = null;
         this.FReportItems = new Vector.<TItemReadyReport>();
         _loc2_ = ReadyReport_Num;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TItemReadyReport(this.FMainUI["MC_Report_" + _loc1_],_loc1_);
            _loc3_.OnLink = this.OnReportLink;
            this.FReportItems.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function OnReportLink(param1:int) : void
      {
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.FMainUI.visible = param1;
      }
   }
}

