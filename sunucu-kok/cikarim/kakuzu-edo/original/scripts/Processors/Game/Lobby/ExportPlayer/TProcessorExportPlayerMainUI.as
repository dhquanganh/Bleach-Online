package Processors.Game.Lobby.ExportPlayer
{
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorExportPlayerMainUI extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      public function TProcessorExportPlayerMainUI(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ExportPlayerMainUI") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.Btn_GO.addEventListener(MouseEvent.CLICK,this.OnGoBtnClick);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function OnGoBtnClick(param1:MouseEvent) : void
      {
         SExternalCore.ExportPlayer();
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
   }
}

