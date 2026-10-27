package Components.Lists.Data
{
   import Foundation.UI.*;
   import Resources.Constants.CONST_COMMON;
   import flash.display.*;
   import flash.events.*;
   
   public class TListItemText extends TListItem
   {
      
      protected static const RENDERINGSTATE_Normal:int = 1;
      
      protected static const RENDERINGSTATE_Hovering:int = 2;
      
      protected static const RENDERINGSTATE_Pressed:int = 3;
      
      protected static const RENDERINGSTATE_Disabled:int = 4;
      
      protected var FResource:MovieClip;
      
      public function TListItemText(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.addChild(this.FResource);
         this.FResource.mouseChildren = false;
         this.FResource.addEventListener(MouseEvent.MOUSE_DOWN,this.ItemOnDown,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_UP,this.ItemOnUp,false,0,true);
         this.FResource.addEventListener(MouseEvent.ROLL_OVER,this.ItemOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.ROLL_OUT,this.ItemOnOut,false,0,true);
         this.FResource.addEventListener(MouseEvent.CLICK,this.ItemOnClick,false,0,true);
      }
      
      protected function ItemOnClick(param1:MouseEvent) : void
      {
         if(FOnClick != null)
         {
            FOnClick(this);
         }
      }
      
      protected function ItemOnDown(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Pressed);
      }
      
      protected function ItemOnUp(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Normal);
      }
      
      protected function ItemOnOver(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Hovering);
      }
      
      protected function ItemOnOut(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Normal);
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
         return this.FResource[CONST_COMMON.RESOURCE_Link_TF_Text].text;
      }
      
      public function set Text(param1:String) : void
      {
         this.FResource[CONST_COMMON.RESOURCE_Link_TF_Text].text = param1;
      }
      
      override public function Dispose() : void
      {
         this.FResource.removeEventListener(MouseEvent.MOUSE_DOWN,this.ItemOnDown);
         this.FResource.removeEventListener(MouseEvent.MOUSE_UP,this.ItemOnUp);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OVER,this.ItemOnOver);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.ItemOnOut);
         this.FResource.removeEventListener(MouseEvent.CLICK,this.ItemOnClick);
         this.removeChild(this.FResource);
         this.FResource = null;
      }
   }
}

