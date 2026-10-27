package Processors.Game.Lobby.DialogMsg
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowInformation;
   import Processors.TProcessor;
   import Resources.Constants.CONST_COMMON;
   
   public class TProcessorDialogMsg extends TProcessor
   {
      
      public static var STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static var STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected var FUIWindowInformation:TUIWindowInformation;
      
      public function TProcessorDialogMsg(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowInformation;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function ImportingPerform_Text(param1:String) : void
      {
         this.FUIWindowInformation.Text = param1;
         this.FUIWindowInformation.Visible = true;
      }
      
      public function ImportText(param1:String) : void
      {
         this.ImportingPerform_Text(param1);
      }
   }
}

