package Processors.Game.Lobby.ADBox
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class TProcessorADBox extends TProcessorLobbyWindow
   {
      
      protected static var ResLoader:Loader;
      
      public static var LoadCompleteCall:Function;
      
      protected static var FLoadComplete:Boolean;
      
      protected static var FLoadFailure:Boolean;
      
      protected var FBackMask:Bitmap;
      
      protected var FMainUI:MovieClip;
      
      protected var FCloseBtn:TUIButton;
      
      public function TProcessorADBox(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected static function OnResLoadComplete(param1:Event) : void
      {
         FLoadComplete = true;
         LoadCompleteCall();
      }
      
      protected static function OnError(param1:IOErrorEvent) : void
      {
         FLoadComplete = FLoadFailure = true;
      }
      
      public static function LoadRes() : void
      {
      }
      
      public static function LoadBox() : void
      {
      }
      
      public static function get LoadComplete() : Boolean
      {
         return true;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         if(false && !FLoadFailure)
         {
            this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ADBox") as MovieClip;
            this.FBackMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
            addChild(this.FBackMask);
            addChild(this.FMainUI);
            this.FMainUI.x = (this.FBackMask.width - this.FMainUI.width) / 2;
            this.FMainUI.y = (this.FBackMask.height - this.FMainUI.height) / 2;
            this.FMainUI.MC_Img.addEventListener(MouseEvent.CLICK,this.OnImgMCClick);
            this.FMainUI.MC_Img.buttonMode = true;
            this.FCloseBtn = new TUIButton();
            this.FCloseBtn.Substrate = this.FMainUI.btn_close;
            this.FCloseBtn.OnClick = this.OnCloseBtnClick;
            this.FMainUI.MC_Img.addChild(ResLoader);
            super.ResourcesPerform_UIDispatch();
         }
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Visible = false;
      }
      
      protected function OnImgMCClick(param1:MouseEvent) : void
      {
         SExternalCore.OpenADURL();
      }
   }
}

