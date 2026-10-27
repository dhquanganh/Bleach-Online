package Processors.Game.Lobby.ReveredBook
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.UI.TUIComponent;
   import Logics.ReveredBook.Decoder.TUnstreamizerReveredBook;
   import Logics.ReveredBook.TReveredBookStrategy;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TComponentStrategy extends TProcessorLobbyWindow
   {
      
      protected static const TFWidth:int = 340;
      
      protected var FMainUI:Sprite;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FTextField:TextField;
      
      protected var FReveredBookStrategy:TReveredBookStrategy;
      
      protected var FUnstreamizerReveredBook:TUnstreamizerReveredBook;
      
      public function TComponentStrategy(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         this.FReveredBookStrategy = new TReveredBookStrategy();
         this.FUnstreamizerReveredBook.UnstreamizationStrategy(null,this.FReveredBookStrategy,null);
         this.CreateScroolBar();
      }
      
      protected function CreateScroolBar() : void
      {
         this.FScroolBar = new TScrollBar(this.FMainUI["ScroolBar"],410,false,1);
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextField.mouseEnabled = true;
         this.FTextField.selectable = false;
         this.FTextField.multiline = true;
         this.FTextField.wordWrap = true;
         this.FTextField.width = TFWidth;
      }
      
      protected function UILocation() : void
      {
      }
      
      protected function RederingStrategyInfor(param1:String) : void
      {
         this.FScroolBar.Clear();
         this.FTextField.htmlText = param1;
         this.FScroolBar.AddItem(this.FTextField);
         this.FScroolBar.ScrollToUp();
      }
      
      public function get TabInfor() : Vector.<String>
      {
         return this.FReveredBookStrategy.TabNames;
      }
      
      public function LoadResource(param1:Sprite) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.UIDispatch();
         this.UILocation();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.RederingStrategyInfor(this.FReveredBookStrategy.Contents[0]);
         }
      }
      
      public function set UnstreamizerReveredBook(param1:TUnstreamizerReveredBook) : void
      {
         this.FUnstreamizerReveredBook = param1;
      }
      
      public function TabClickNotify(param1:int) : void
      {
         this.RederingStrategyInfor(this.FReveredBookStrategy.Contents[param1]);
      }
      
      public function Reset() : void
      {
      }
   }
}

