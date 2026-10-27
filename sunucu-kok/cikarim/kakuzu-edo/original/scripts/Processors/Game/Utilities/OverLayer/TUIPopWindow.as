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
   import Resources.Constants.CONST_COMMON;
   import Utilities.UI.Windows.TUtilityUIWindow;
   
   public class TUIPopWindow extends TUIComponent
   {
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FUIWindowInformation:TUIWindowInformation;
      
      protected var FUIWindowBigInformation:TUIWindowBigInformation;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowEditorString:TUIWindowEditorString;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FKnifePop:TKnifePop;
      
      public function TUIPopWindow(param1:TUIComponent)
      {
         super(param1);
         this.mouseEnabled = false;
      }
      
      protected function LoadResource_Pefrorm() : void
      {
         this.FUIWindowRecharge = new TUIWindowRecharge(this);
         this.FUIWindowInformation = new TUIWindowInformation(this);
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this);
         this.FUIWindowEditorString = new TUIWindowEditorString(this);
         this.FUIWindowBigInformation = new TUIWindowBigInformation(this);
         TUtilityUIWindow.SetupWindowRecharge(this.FUIWindowRecharge);
         TUtilityUIWindow.SetupWindowInformation(this.FUIWindowInformation);
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         TUtilityUIWindow.SetupWindowEditorString(this.FUIWindowEditorString);
         TUtilityUIWindow.SetupWindowBigInformation(this.FUIWindowBigInformation);
         this.FWindowShowHero = new TProcessorWindowHeroDescription(this);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (CONST_COMMON.STAGE_Width - 200) / 2;
         this.FKnifePop.Y = (CONST_COMMON.STAGE_Height - 300) / 2;
         this.FKnifePop.Visible = false;
      }
      
      public function get UIWindowRecharge() : TUIWindowRecharge
      {
         return this.FUIWindowRecharge;
      }
      
      public function get UIWindowInformation() : TUIWindowInformation
      {
         return this.FUIWindowInformation;
      }
      
      public function get UIWindowConfirmation() : TUIWindowConfirmation
      {
         return this.FUIWindowConfirmation;
      }
      
      public function get UIWindowEditorString() : TUIWindowEditorString
      {
         return this.FUIWindowEditorString;
      }
      
      public function get UIWindowBigInformation() : TUIWindowBigInformation
      {
         return this.FUIWindowBigInformation;
      }
      
      public function get WindowShowHero() : TProcessorWindowHeroDescription
      {
         return this.FWindowShowHero;
      }
      
      public function get KnifePop() : TKnifePop
      {
         return this.FKnifePop;
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Pefrorm();
      }
   }
}

