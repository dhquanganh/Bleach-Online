package Components.Lists.Data
{
   import Foundation.UI.TUIComponent;
   import flash.events.TextEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TListItemTextField extends TListItem
   {
      
      protected var FTFInfor:TextField;
      
      protected var FTextWidth:int;
      
      public function TListItemTextField(param1:TUIComponent, param2:int)
      {
         super(param1);
         this.FTextWidth = param2;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FTFInfor = new TextField();
         this.FTFInfor.antiAliasType = AntiAliasType.ADVANCED;
         this.FTFInfor.autoSize = TextFieldAutoSize.LEFT;
         this.FTFInfor.mouseEnabled = true;
         this.FTFInfor.selectable = false;
         this.FTFInfor.multiline = true;
         this.FTFInfor.wordWrap = true;
         this.FTFInfor.width = this.FTextWidth;
         this.FTFInfor.addEventListener(TextEvent.LINK,this.TextOnTextEvent);
         addChild(this.FTFInfor);
      }
      
      protected function TextOnTextEvent(param1:TextEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = parseInt(param1.text);
         if(FOnClick != null)
         {
            FOnClick(_loc2_);
         }
      }
      
      public function get Text() : String
      {
         return this.FTFInfor.htmlText;
      }
      
      public function set Text(param1:String) : void
      {
         this.FTFInfor.htmlText = "";
         this.FTFInfor.htmlText = param1;
      }
      
      override public function Dispose() : void
      {
         this.FTFInfor.removeEventListener(TextEvent.LINK,this.TextOnTextEvent);
      }
   }
}

