package Processors.Game.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TUIWindow extends TProcessorLobbyWindow
   {
      
      protected static var STAGE_Width:uint = CONST_COMMON.STAGE_Width;
      
      protected static var STAGE_Height:uint = CONST_COMMON.STAGE_Height;
      
      protected var FModalLayer:Sprite;
      
      protected var FResource:Sprite;
      
      protected var FTextField:TextField;
      
      protected var FButtonOK:TUIButton;
      
      protected var FButtonCancel:TUIButton;
      
      protected var FOnOK:Function;
      
      protected var FOnCancel:Function;
      
      protected var FButtonOkCaption:String;
      
      protected var FButtonCancelCaption:String;
      
      protected var FContext:Object;
      
      public function TUIWindow(param1:TUIComponent)
      {
         super(param1);
         this.FModalLayer = new Sprite();
         addChild(this.FModalLayer);
         Visible = false;
      }
      
      public function ConstructComponents() : void
      {
         addChild(this.FResource);
         this.SetWindowCenter();
         this.FModalLayer.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.ConstruceComponentTextfield();
         this.ConstructComponentButtons();
         this.ConstructComponentMovieClip();
      }
      
      protected function ConstruceComponentTextfield() : void
      {
      }
      
      protected function ConstructComponentButtons() : void
      {
      }
      
      protected function ConstructComponentMovieClip() : void
      {
      }
      
      protected function SetWindowCenter() : void
      {
         if(this.FResource != null)
         {
            this.FResource.x = (STAGE_Width - this.FResource.width) / 2;
            this.FResource.y = (STAGE_Height - this.FResource.height) / 2;
         }
      }
      
      protected function Reset() : void
      {
         this.Text = "";
         this.SetWindowCenter();
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get WindowWidth() : int
      {
         return this.FResource.width;
      }
      
      public function get WindowHeight() : int
      {
         return this.FResource.height;
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
      }
      
      public function get Text() : String
      {
         return this.FTextField.text;
      }
      
      public function set Text(param1:String) : void
      {
         this.FTextField.text = param1;
      }
      
      public function get HtmlText() : String
      {
         return this.FTextField.htmlText;
      }
      
      public function set HtmlText(param1:String) : void
      {
         this.FTextField.htmlText = param1;
      }
      
      public function get OnOK() : Function
      {
         return this.FOnOK;
      }
      
      public function set OnOK(param1:Function) : void
      {
         this.FOnOK = param1;
      }
      
      public function get OnCancel() : Function
      {
         return this.FOnCancel;
      }
      
      public function set OnCancel(param1:Function) : void
      {
         this.FOnCancel = param1;
      }
      
      public function get ButtonOkCaption() : String
      {
         return this.FButtonOkCaption;
      }
      
      public function set ButtonOkCaption(param1:String) : void
      {
         this.FButtonOkCaption = param1;
      }
      
      public function get ButtonCancelCaption() : String
      {
         return this.FButtonCancelCaption;
      }
      
      public function set ButtonCancelCaption(param1:String) : void
      {
         this.FButtonCancelCaption = param1;
      }
      
      public function get Modal() : Boolean
      {
         return this.FModalLayer.visible;
      }
      
      public function set Modal(param1:Boolean) : void
      {
         this.FModalLayer.visible = param1;
      }
      
      public function Init() : void
      {
         this.ConstructComponents();
      }
      
      public function SetCoordinate(param1:int, param2:int) : void
      {
         this.FResource.x = param1;
         this.FResource.y = param2;
      }
      
      public function SetTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         this.FTextField.setTextFormat(param1,param2,param3);
      }
   }
}

