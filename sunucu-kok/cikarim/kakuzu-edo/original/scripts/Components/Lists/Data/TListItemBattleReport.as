package Components.Lists.Data
{
   import Components.Standard.TUIButton;
   import Foundation.UI.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class TListItemBattleReport extends TListItem
   {
      
      protected var FResource:MovieClip;
      
      protected var FButton:TUIButton;
      
      protected var FText:TextField;
      
      public function TListItemBattleReport(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.addChild(this.FResource);
         this.FText = this.FResource["tf_info"];
         this.FButton = new TUIButton();
         this.FButton.Substrate = this.FResource["btn_look"];
         this.FButton.OnClick = this.ItemOnClick;
      }
      
      protected function ItemOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnClick != null)
         {
            FOnClick(this);
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get Text() : String
      {
         return this.FText.text;
      }
      
      public function set Text(param1:String) : void
      {
         this.FText.text = param1;
      }
      
      override public function Dispose() : void
      {
         this.FText = null;
         this.FButton.OnClick = null;
         this.FButton = null;
         this.removeChild(this.FResource);
         this.FResource = null;
      }
   }
}

