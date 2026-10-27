package Components.Drops
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIDrop extends TUIComponent
   {
      
      protected var FButtonDrop:TUIButton;
      
      protected var FTF_Text:TextField;
      
      protected var FResource:Sprite;
      
      public function TUIDrop(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.addChild(this.FResource);
         BoundsClientSet(0,0,this.FResource.width,this.FResource.height);
         this.FTF_Text = this.FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
         this.FTF_Text.text = "";
         this.FButtonDrop = new TUIButton();
         this.FButtonDrop.Substrate = this.FResource[CONST_COMMON.RESOURCE_Link_Btn_Drop];
         this.FButtonDrop.OnClick = this.ButtonDropOnClick;
      }
      
      protected function RenderingPerform_Context() : void
      {
      }
      
      protected function DroppingDroppable() : Boolean
      {
         return true;
      }
      
      protected function DroppingEvaluate() : void
      {
      }
      
      protected function DroppingActivate() : void
      {
      }
      
      protected function DroppingDeactivate() : void
      {
      }
      
      protected function ButtonDropOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.DroppingDroppable())
         {
            this.DroppingEvaluate();
            this.DroppingActivate();
            param2.stopPropagation();
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      override public function Dispose() : void
      {
         this.FButtonDrop.Dispose();
         this.FButtonDrop = null;
         this.FTF_Text = null;
         if(this.FResource.parent != null)
         {
            this.FResource.parent.removeChild(this.FResource);
         }
         this.FResource = null;
      }
   }
}

