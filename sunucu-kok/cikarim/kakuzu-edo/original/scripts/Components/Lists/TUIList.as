package Components.Lists
{
   import Components.Lists.Data.TListItem;
   import Components.Standard.TUIScrollBarVertical;
   import Foundation.Common.TBounds;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import flash.display.Sprite;
   
   public class TUIList extends TUIComponent
   {
      
      protected static const STRING_LINK_SP_MountPoint:String = "SP_MountPoint";
      
      protected var FSP_MountPoint:Sprite;
      
      protected var FItems:Vector.<TListItem>;
      
      protected var FScrollBar:TUIScrollBarVertical;
      
      protected var FBoundsItem:TBounds;
      
      protected var FViewPortOffset:int;
      
      protected var FResource:Sprite;
      
      protected var FItemHeight:int;
      
      protected var FOnAdd:Function;
      
      protected var FOnClick:Function;
      
      protected var FOnClear:Function;
      
      protected var FOnDelete:Function;
      
      public function TUIList(param1:TUIComponent)
      {
         super(param1);
         FBoundsClient.Width = 250;
         FBoundsClient.Height = 100;
         this.ConstructItems();
         this.FScrollBar = new TUIScrollBarVertical(this);
         this.FScrollBar.Visible = false;
         this.FScrollBar.Min = 0;
         this.FScrollBar.ThumbSizeMin = 20;
         this.FScrollBar.MouseWheelScale = 3;
         this.FScrollBar.OnChange = this.ScrollBarOnChange;
         this.FBoundsItem = new TBounds();
         this.FItemHeight = 20;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.addChild(this.FResource);
         BoundsClientSet(0,0,this.FResource.width,this.FResource.height);
         this.FSP_MountPoint = this.FResource[STRING_LINK_SP_MountPoint];
         this.addChild(this.FScrollBar);
         this.FScrollBar.Init();
         this.FScrollBar.X = this.FResource.width - this.FScrollBar.Width - 3;
         this.FScrollBar.Y = (this.FResource.height - this.FScrollBar.Height) / 2;
      }
      
      protected function ConstructItems() : void
      {
         this.FItems = new Vector.<TListItem>();
      }
      
      protected function UpdateScrollBar() : void
      {
         var _loc1_:int = 0;
         _loc1_ = FBoundsClient.Height;
         this.FScrollBar.PageSize = _loc1_;
         this.FScrollBar.Max = this.Count * this.FItemHeight + 2;
      }
      
      protected function UpdateRowsHeight() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = FBoundsClient.Height;
         _loc2_ = this.Count * this.FItemHeight;
         if(_loc2_ > _loc3_)
         {
            _loc1_ = true;
         }
         else
         {
            this.FViewPortOffset = 0;
            _loc1_ = false;
         }
         this.FScrollBar.Visible = _loc1_;
         return _loc1_;
      }
      
      protected function UpdateSlotsPosition() : void
      {
         this.FViewPortOffset = this.FScrollBar.Value;
      }
      
      protected function RowChange(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TListItem = null;
         var _loc4_:TListItem = null;
         _loc3_ = param1 as TListItem;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc4_ = this.FItems[_loc2_];
            if(_loc3_ == _loc4_)
            {
               if(this.FOnClick != null)
               {
                  this.FOnClick(param1,_loc2_);
               }
            }
            _loc2_++;
         }
      }
      
      protected function UpdateUIList() : void
      {
         if(this.UpdateRowsHeight())
         {
            this.UpdateScrollBar();
         }
         this.RenderingPerform_Data();
      }
      
      protected function RenderingPerform_Data() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TListItem = null;
         _loc1_ = FBoundsClient.X;
         _loc2_ = 0 - this.FViewPortOffset;
         _loc4_ = FBoundsClient.Width;
         if(this.FScrollBar.Visible)
         {
            _loc4_ -= this.FScrollBar.Width;
         }
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            _loc5_ = this.FItems[_loc3_];
            TUtilityCartisian.BoundsSet(this.FBoundsItem,_loc1_,_loc2_,_loc4_,this.FItemHeight);
            _loc5_.Y = _loc2_;
            _loc2_ += this.FItemHeight;
            _loc3_++;
         }
      }
      
      protected function ScrollBarOnChange(param1:Object) : void
      {
         this.UpdateSlotsPosition();
         this.UpdateUIList();
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get ScrollBarResource() : Sprite
      {
         return this.FScrollBar.Resource;
      }
      
      public function set ScrollBarResource(param1:Sprite) : void
      {
         this.FScrollBar.Resource = param1;
      }
      
      public function get ScrollBar() : TUIScrollBarVertical
      {
         return this.FScrollBar;
      }
      
      public function get Count() : int
      {
         return this.FItems.length;
      }
      
      public function GetItemByIndex(param1:int) : TListItem
      {
         return this.FItems[param1];
      }
      
      public function get ItemHeight() : int
      {
         return this.FItemHeight;
      }
      
      public function set ItemHeight(param1:int) : void
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         this.FItemHeight = param1;
      }
      
      public function get ActualHeight() : int
      {
         return this.FItemHeight * this.FItems.length;
      }
      
      public function get OnAdd() : Function
      {
         return this.FOnAdd;
      }
      
      public function set OnAdd(param1:Function) : void
      {
         this.FOnAdd = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnClear() : Function
      {
         return this.FOnClear;
      }
      
      public function set OnClear(param1:Function) : void
      {
         this.FOnClear = param1;
      }
      
      public function get OnDelete() : Function
      {
         return this.FOnDelete;
      }
      
      public function set OnDelete(param1:Function) : void
      {
         this.FOnDelete = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function RenderingPerform() : void
      {
         this.FScrollBar.RenderingPerform();
      }
      
      public function EvaluateBoundScreen() : void
      {
         this.FScrollBar.EvaluateBoundScreen();
      }
      
      override public function Dispose() : void
      {
         this.removeChild(this.FResource);
         this.Clear();
         this.FScrollBar.Dispose();
         this.FScrollBar = null;
         this.FSP_MountPoint = null;
         this.FResource = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TListItem = null;
         _loc1_ = 0;
         while(_loc1_ < this.Count)
         {
            _loc2_ = this.FItems[_loc1_];
            this.FSP_MountPoint.removeChild(_loc2_);
            _loc2_.OnClick = null;
            _loc2_.Dispose();
            _loc2_ = null;
            _loc1_++;
         }
         this.FItems.length = 0;
         if(this.FOnClear != null)
         {
            this.FOnClear(this);
         }
      }
      
      public function Add(param1:TListItem) : void
      {
         if(param1 != null)
         {
            this.FItems.push(param1);
            param1.OnClick = this.RowChange;
            param1.Perform_UIDispatch();
            this.FSP_MountPoint.addChild(param1);
            param1.X = param1.MarginLeft;
            this.FItemHeight = param1.Height;
            this.UpdateUIList();
            if(this.FOnAdd != null)
            {
               this.FOnAdd(this,param1);
            }
         }
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:TListItem = null;
         _loc2_ = this.FItems[param1];
         _loc2_.OnClick = null;
         _loc2_.Dispose();
         this.FItems.splice(param1,1);
         _loc2_ = null;
         this.UpdateUIList();
         if(this.FOnDelete != null)
         {
            this.FOnDelete(this,param1);
         }
      }
   }
}

