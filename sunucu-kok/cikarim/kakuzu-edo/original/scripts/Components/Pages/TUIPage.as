package Components.Pages
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Resources.Constants.CONST_COMMON;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIPage extends TUIComponent
   {
      
      public static const STRING_Capacity:String = CONST_COMMON.STRING_Capacity;
      
      protected var FButtonPrevious:TUIButton;
      
      protected var FButtonNext:TUIButton;
      
      protected var FLabelPage:TextField;
      
      protected var FTotalQuantity:uint;
      
      protected var FPageSize:uint;
      
      protected var FPageIndex:int;
      
      protected var FTotalPage:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FOnChangePage:Function;
      
      public function TUIPage(param1:TUIComponent)
      {
         super(param1);
         this.FButtonPrevious = new TUIButton();
         this.FButtonPrevious.OnClick = this.ButtonPreviousPageOnClick;
         this.FButtonNext = new TUIButton();
         this.FButtonNext.OnClick = this.ButtonNextPageOnClick;
         this.mouseEnabled = false;
         this.FInitialization = false;
      }
      
      protected function Initialization() : void
      {
         this.FButtonPrevious.Enabled = false;
         this.FButtonNext.Enabled = false;
         this.FInitialization = true;
      }
      
      protected function UpdateLabelPage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FPageIndex;
         _loc2_ = int(this.FTotalPage);
         if(this.FTotalPage <= 0)
         {
            _loc1_ = 1;
            _loc2_ = 1;
         }
         else
         {
            _loc1_++;
         }
         if(this.FLabelPage != null)
         {
            this.FLabelPage.text = TUtilityString.Format(STRING_Capacity,_loc1_,_loc2_);
         }
      }
      
      protected function UpdateTotalPage() : void
      {
         this.FTotalPage = Math.floor(this.FTotalQuantity / this.FPageSize * -1) * -1;
      }
      
      protected function ButtonPreviousPageOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FPageIndex > 0)
         {
            --this.FPageIndex;
            this.UpdateLabelPage();
         }
         if(this.FPageIndex == 0)
         {
            if(this.FButtonPrevious.Enabled)
            {
               this.FButtonPrevious.Enabled = false;
            }
         }
         this.PageIndex = this.FPageIndex;
         if(this.FOnChangePage != null)
         {
            this.FOnChangePage(this,this.FPageIndex);
         }
      }
      
      protected function ButtonNextPageOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FPageIndex + 1 < this.FTotalPage)
         {
            ++this.FPageIndex;
            this.UpdateLabelPage();
         }
         if(this.FPageIndex == this.FTotalPage - 1)
         {
            if(this.FButtonNext.Enabled)
            {
               this.FButtonNext.Enabled = false;
            }
         }
         this.PageIndex = this.FPageIndex;
         if(this.FOnChangePage != null)
         {
            this.FOnChangePage(this,this.FPageIndex);
         }
      }
      
      public function get ButtonPrevious() : TUIButton
      {
         return this.FButtonPrevious;
      }
      
      public function set ButtonPrevious(param1:TUIButton) : void
      {
         this.FButtonPrevious = param1;
      }
      
      public function get ButtonNext() : TUIButton
      {
         return this.FButtonNext;
      }
      
      public function set ButtonNext(param1:TUIButton) : void
      {
         this.FButtonNext = param1;
      }
      
      public function get TotalQuantity() : uint
      {
         return this.FTotalQuantity;
      }
      
      public function set TotalQuantity(param1:uint) : void
      {
         this.FTotalQuantity = param1;
      }
      
      public function get PageSize() : uint
      {
         return this.FPageSize;
      }
      
      public function set PageSize(param1:uint) : void
      {
         this.FPageSize = param1;
      }
      
      public function get LabelPage() : TextField
      {
         return this.FLabelPage;
      }
      
      public function set LabelPage(param1:TextField) : void
      {
         this.FLabelPage = param1;
      }
      
      public function get OnChangePage() : Function
      {
         return this.FOnChangePage;
      }
      
      public function set OnChangePage(param1:Function) : void
      {
         this.FOnChangePage = param1;
      }
      
      public function set PageIndex(param1:int) : void
      {
         this.FPageIndex = param1;
         this.FButtonNext.Enabled = true;
         this.FButtonPrevious.Enabled = true;
         if(param1 >= this.FTotalPage - 1)
         {
            if(this.FButtonNext.Enabled)
            {
               this.FButtonNext.Enabled = false;
            }
         }
         if(param1 <= 0)
         {
            if(this.FButtonPrevious.Enabled)
            {
               this.FButtonPrevious.Enabled = false;
            }
         }
         this.FPageIndex = param1;
         this.UpdateLabelPage();
      }
      
      public function get TotalPage() : uint
      {
         return this.FTotalPage;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      override public function Dispose() : void
      {
         this.FButtonPrevious.Dispose();
         this.FButtonPrevious = null;
         this.FButtonNext.Dispose();
         this.FButtonNext = null;
         this.FLabelPage = null;
         this.FOnChangePage = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Update() : void
      {
         this.UpdateTotalPage();
         this.UpdateLabelPage();
         this.PageIndex = this.FPageIndex;
      }
      
      public function Reset() : void
      {
         this.FPageIndex = 0;
         this.Update();
      }
      
      public function SetupPage(param1:int, param2:int) : void
      {
         this.TotalQuantity = param1;
         this.Update();
         this.PageIndex = param2;
      }
   }
}

