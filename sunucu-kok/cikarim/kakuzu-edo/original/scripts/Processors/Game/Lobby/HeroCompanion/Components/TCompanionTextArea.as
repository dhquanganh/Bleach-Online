package Processors.Game.Lobby.HeroCompanion.Components
{
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Foundation.UI.TUIComponent;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TCompanionTextArea extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFDesc:TextField;
      
      protected var FScroll:TScrollBarSimple;
      
      protected var FScrollText:TScrollTextField;
      
      protected var FActivityHeight:int;
      
      protected var FHtmlText:String;
      
      public function TCompanionTextArea(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function get HtmlText() : String
      {
         return this.FHtmlText;
      }
      
      public function set HtmlText(param1:String) : void
      {
         this.FHtmlText = param1;
         this.FTFDesc.htmlText = this.FHtmlText;
      }
      
      public function get Substrate() : Sprite
      {
         return this.FMainUI;
      }
      
      public function set Substrate(param1:Sprite) : void
      {
         this.FMainUI = param1;
      }
      
      public function get ActivityHeight() : int
      {
         return this.FActivityHeight;
      }
      
      public function set ActivityHeight(param1:int) : void
      {
         this.FActivityHeight = param1;
      }
      
      public function Init() : void
      {
         this.FTFDesc = this.FMainUI["TF_Desc"];
         this.FScrollText = new TScrollTextField(this.FTFDesc);
         this.FMainUI.addChild(this.FScrollText);
         this.FScroll = new TScrollBarSimple(this,this.FMainUI["mc_bar"],this.FMainUI["btn_up"],this.FMainUI["btn_down"],this.FActivityHeight - this.FMainUI["mc_bar"].height,this.FScrollText);
         this.FMainUI.addChild(this.FScroll);
      }
      
      public function Update() : void
      {
         this.FScroll.LogicsProcess();
      }
   }
}

