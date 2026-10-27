package Components.Drops
{
   import Components.Lists.Data.TListItem;
   import Components.Lists.Data.TListItemText;
   import Components.Lists.TUIList;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityString;
   import flash.events.MouseEvent;
   import ghostcat.util.easing.TweenUtil;
   
   public class TUIDropList extends TUIDrop
   {
      
      protected var FItemIndex:int;
      
      protected var FUIList:TUIList;
      
      protected var FOnClick:Function;
      
      public function TUIDropList(param1:TUIComponent)
      {
         super(param1);
         this.FUIList = new TUIList(this);
         this.FUIList.Visible = false;
         this.FUIList.OnAdd = this.UIListOnAdd;
         this.FUIList.OnClick = this.UIListOnClick;
         this.FUIList.OnClear = this.UIListOnClear;
         this.FUIList.OnDelete = this.UIListOnDelete;
         this.FItemIndex = -1;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FUIList.Y = FResource.height + 10;
         this.FUIList.Perform_UIDispatch();
      }
      
      override protected function DroppingDroppable() : Boolean
      {
         var _loc1_:Boolean = false;
         return this.FUIList.Count > 0 && !this.FUIList.Visible;
      }
      
      override protected function DroppingEvaluate() : void
      {
         this.FUIList.Visible = true;
         TweenUtil.removeTween(this.FUIList);
         TweenUtil.to(this.FUIList,200,{"alpha":1});
      }
      
      override protected function DroppingActivate() : void
      {
         this.addEventListenerWindowPopup();
      }
      
      override protected function DroppingDeactivate() : void
      {
         this.RemoveEventListenerWindowPopup();
      }
      
      protected function addEventListenerWindowPopup() : void
      {
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.WindowPopupHiderOnUp,false,0,true);
      }
      
      protected function RemoveEventListenerWindowPopup() : void
      {
         FUICore.UIStage.removeEventListener(MouseEvent.MOUSE_UP,this.WindowPopupHiderOnUp);
      }
      
      protected function ProcessorPopupWindowHider(param1:TUIComponent, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = false;
         if(param1.Visible)
         {
            _loc3_ = this.HitWindowTest(param1);
            if(_loc3_ && !param2)
            {
               return;
            }
            TweenUtil.removeTween(param1);
            TweenUtil.to(param1,200,{
               "alpha":0,
               "onComplete":this.UIListEffectEndOnCompleted
            });
            this.DroppingDeactivate();
         }
      }
      
      protected function HitWindowTest(param1:TUIComponent) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(param1);
         _loc4_ = new TBounds();
         _loc4_.Assign(_loc3_);
         _loc4_.Width = param1.Width;
         _loc4_.Height = param1.Height;
         return TUtilityCartisian.BoundsContainsCoordinate(_loc4_,FUICore.MouseCoordinate);
      }
      
      override protected function RenderingPerform_Context() : void
      {
         var _loc1_:TListItemText = null;
         if(this.FItemIndex < 0)
         {
            return;
         }
         _loc1_ = this.FUIList.GetItemByIndex(this.FItemIndex) as TListItemText;
         FTF_Text.text = _loc1_.Text;
      }
      
      protected function UIListEffectEndOnCompleted() : void
      {
         this.FUIList.Visible = false;
      }
      
      protected function UIListOnAdd(param1:Object, param2:TListItem) : void
      {
         if(this.FUIList.Count > 0)
         {
            if(TUtilityString.Empty(FTF_Text.text))
            {
               FTF_Text.text = (param2 as TListItemText).Text;
            }
         }
      }
      
      protected function UIListOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:TListItemText = null;
         if(param2 < 0)
         {
            return;
         }
         if(param2 != this.FItemIndex)
         {
            _loc3_ = this.FUIList.GetItemByIndex(param2) as TListItemText;
            FTF_Text.text = (_loc3_ as TListItemText).Text;
            this.FItemIndex = param2;
            if(this.FOnClick != null)
            {
               this.FOnClick(this,param2);
            }
            this.ProcessorPopupWindowHider(this.FUIList,true);
         }
      }
      
      protected function UIListOnClear(param1:Object) : void
      {
         this.FItemIndex = -1;
         if(FTF_Text != null)
         {
            FTF_Text.text = "";
         }
      }
      
      protected function UIListOnDelete(param1:Object, param2:int) : void
      {
         if(this.FItemIndex < 0)
         {
            return;
         }
         if(param2 > this.FItemIndex)
         {
            return;
         }
         if(param2 < this.FItemIndex)
         {
            --this.FItemIndex;
            return;
         }
         if(param2 == this.FItemIndex)
         {
            this.FItemIndex = -1;
            return;
         }
      }
      
      protected function WindowPopupHiderOnUp(param1:MouseEvent) : void
      {
         this.ProcessorPopupWindowHider(this.FUIList);
      }
      
      public function get UIList() : TUIList
      {
         return this.FUIList;
      }
      
      public function get ItemIndex() : int
      {
         return this.FItemIndex;
      }
      
      public function set ItemIndex(param1:int) : void
      {
         var _loc2_:TListItemText = null;
         if(param1 >= this.FUIList.Count)
         {
            this.FItemIndex = -1;
         }
         else if(param1 != this.FItemIndex)
         {
            _loc2_ = this.FUIList.GetItemByIndex(param1) as TListItemText;
            FTF_Text.text = (_loc2_ as TListItemText).Text;
            this.FItemIndex = param1;
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      override public function Perform_UIDispatch() : void
      {
         super.Perform_UIDispatch();
         this.ResourcesPerform_UIDispatch();
      }
      
      override public function Dispose() : void
      {
         super.Dispose();
         this.FUIList.Dispose();
         this.FUIList = null;
         this.FOnClick = null;
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

