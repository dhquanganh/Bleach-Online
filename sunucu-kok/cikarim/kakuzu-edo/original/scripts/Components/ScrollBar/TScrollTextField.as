package Components.ScrollBar
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class TScrollTextField extends Sprite
   {
      
      protected var FTextField:TextField;
      
      protected var FOnResetHtmlText:Function;
      
      protected var FOnAppendHtmlText:Function;
      
      protected var FOnTextClick:Function;
      
      protected var FText:String = "";
      
      public function TScrollTextField(param1:TextField)
      {
         super();
         this.FTextField = param1;
         this.FTextField.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel);
         this.FTextField.addEventListener(TextEvent.LINK,this.TextClick);
         addChild(this.FTextField);
      }
      
      protected function OnMouseWheel(param1:Event) : void
      {
         if(this.FOnAppendHtmlText != null)
         {
            this.FOnAppendHtmlText();
         }
      }
      
      protected function TextClick(param1:TextEvent) : void
      {
         if(this.FOnTextClick != null)
         {
            this.FOnTextClick(param1.text);
         }
      }
      
      public function set OnResetHtmlText(param1:Function) : void
      {
         this.FOnResetHtmlText = param1;
      }
      
      public function set OnAppendHtmlText(param1:Function) : void
      {
         this.FOnAppendHtmlText = param1;
      }
      
      public function get ScrollV() : int
      {
         return this.FTextField.scrollV;
      }
      
      public function get MaxScrollV() : int
      {
         return this.FTextField.maxScrollV;
      }
      
      public function get OnTextClick() : Function
      {
         return this.FOnTextClick;
      }
      
      public function set OnTextClick(param1:Function) : void
      {
         this.FOnTextClick = param1;
      }
      
      public function SetScrool(param1:Number) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 * (this.FTextField.maxScrollV - 1);
         _loc2_++;
         this.FTextField.scrollV = _loc2_;
      }
      
      public function AppendText(param1:String) : void
      {
         this.FText += param1;
         this.FTextField.htmlText = this.FText;
         if(this.FOnAppendHtmlText != null)
         {
            this.FOnAppendHtmlText();
         }
      }
      
      public function SetHtmlText(param1:String) : void
      {
         this.FTextField.htmlText = param1;
         this.FText = param1;
         if(this.FOnResetHtmlText != null)
         {
            this.FOnResetHtmlText();
         }
      }
      
      public function GetHtmlText() : String
      {
         return this.FTextField.htmlText;
      }
      
      public function Clear() : void
      {
         this.SetHtmlText("");
         this.FText = "";
      }
   }
}

