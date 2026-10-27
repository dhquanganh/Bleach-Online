package Processors.Game.Utilities.OverLayer
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.TKnifePop;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Windows.Editors.TUIWindowEditorString;
   import Processors.Game.Windows.Information.TUIWindowBigInformation;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Processors.Game.Windows.Information.TUIWindowInformation;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Rendering.Overlayers.VoidSoulWorldFormation.TOverlayerVoidWorldForm;
   
   public class TUtilityOverLayer
   {
      
      protected var FUIOverLayerTip:TUIOverLayerTip;
      
      protected var FUIPopWindow:TUIPopWindow;
      
      protected var FInitialization:Boolean;
      
      public function TUtilityOverLayer()
      {
         super();
         this.FInitialization = false;
      }
      
      protected function LoadResource_Perform(param1:TUIComponent) : void
      {
         if(this.FUIPopWindow == null)
         {
            this.FUIPopWindow = new TUIPopWindow(param1);
            this.FUIPopWindow.LoadResource();
         }
         if(this.FUIOverLayerTip == null)
         {
            this.FUIOverLayerTip = new TUIOverLayerTip(param1);
            this.FUIOverLayerTip.LoadResource();
         }
         this.FInitialization = true;
      }
      
      public function get Initialization() : Boolean
      {
         return this.FInitialization;
      }
      
      public function get UIWindowRecharge() : TUIWindowRecharge
      {
         return this.FUIPopWindow.UIWindowRecharge;
      }
      
      public function get UIWindowInformation() : TUIWindowInformation
      {
         return this.FUIPopWindow.UIWindowInformation;
      }
      
      public function get UIWindowBigInformation() : TUIWindowBigInformation
      {
         return this.FUIPopWindow.UIWindowBigInformation;
      }
      
      public function get UIWindowConfirmation() : TUIWindowConfirmation
      {
         return this.FUIPopWindow.UIWindowConfirmation;
      }
      
      public function get UIWindowEditorString() : TUIWindowEditorString
      {
         return this.FUIPopWindow.UIWindowEditorString;
      }
      
      public function get WindowShowHero() : TProcessorWindowHeroDescription
      {
         return this.FUIPopWindow.WindowShowHero;
      }
      
      public function get KnifePop() : TKnifePop
      {
         return this.FUIPopWindow.KnifePop;
      }
      
      public function get OverlayerVoidWorldForm() : TOverlayerVoidWorldForm
      {
         return this.FUIOverLayerTip.OverlayerVoidWorldForm;
      }
      
      public function LoadResource(param1:TUIComponent) : void
      {
         this.LoadResource_Perform(param1);
      }
      
      public function UIComponentsHintOnOver(param1:Object, param2:Object, param3:Object = null) : void
      {
         this.FUIOverLayerTip.UIComponentsOnOver(param1,param2,param3);
      }
      
      public function UIComponentsHintOnOut(param1:Object, param2:Object, param3:Object = null) : void
      {
         this.FUIOverLayerTip.UIComponentsOnOut(param1,param2,param3);
      }
      
      public function HideTip() : void
      {
         this.FUIOverLayerTip.Hide();
      }
   }
}

