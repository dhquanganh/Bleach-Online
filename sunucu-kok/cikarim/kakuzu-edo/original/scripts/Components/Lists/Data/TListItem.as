package Components.Lists.Data
{
   import Foundation.UI.TUIComponent;
   
   public class TListItem extends TUIComponent
   {
      
      protected var FMarginLeft:int;
      
      protected var FUserData:Object;
      
      protected var FOnClick:Function;
      
      public function TListItem(param1:TUIComponent)
      {
         super(param1);
         this.FMarginLeft = 3;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      public function get MarginLeft() : int
      {
         return this.FMarginLeft;
      }
      
      public function set MarginLeft(param1:int) : void
      {
         this.FMarginLeft = param1;
      }
      
      public function get UserData() : Object
      {
         return this.FUserData;
      }
      
      public function set UserData(param1:Object) : void
      {
         this.FUserData = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
   }
}

