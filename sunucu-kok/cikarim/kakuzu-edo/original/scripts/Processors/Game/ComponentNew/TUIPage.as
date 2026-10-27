package Processors.Game.ComponentNew
{
   import Components.Standard.TUIButton;
   import Foundation.Utilities.TUtilityString;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIPage
   {
      
      public static const STRING_Capacity:String = "%0/%1";
      
      protected var FResource:Sprite;
      
      protected var FButtonPrevious:TUIButton;
      
      protected var FButtonNext:TUIButton;
      
      protected var FLabelPage:TextField;
      
      protected var FTotalQuantity:uint;
      
      protected var FPageSize:uint;
      
      protected var FPageIndex:int;
      
      protected var FTotalPage:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FIsNoUseVisible:Boolean;
      
      protected var FOnChangePage:Function;
      
      public function TUIPage()
      {
         super();
         this.FInitialization = false;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FButtonPrevious = new TUIButton();
         this.FButtonPrevious.Substrate = this.FResource["MC_Left"];
         this.FButtonPrevious.OnClick = this.ButtonPreviousPageOnClick;
         this.FButtonNext = new TUIButton();
         this.FButtonNext.Substrate = this.FResource["MC_Right"];
         this.FButtonNext.OnClick = this.ButtonNextPageOnClick;
         this.FLabelPage = this.FResource["TF_Page"];
         this.Reset();
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
         this.FTotalPage = Math.ceil(this.FTotalQuantity / this.FPageSize);
         this.FTotalPage = this.FTotalPage == 0 ? 1 : this.FTotalPage;
      }
      
      protected function CheckIsUse(param1:Boolean) : void
      {
         var _loc2_:TUIButton = null;
         if(param1)
         {
            _loc2_ = this.FButtonPrevious;
         }
         else
         {
            _loc2_ = this.FButtonNext;
         }
         if(this.FIsNoUseVisible)
         {
            _loc2_.Visible = false;
         }
         else
         {
            _loc2_.Visible = true;
         }
      }
      
      private function UpdateState() : void
      {
         this.UpdateTotalPage();
         this.FButtonPrevious.Enabled = true;
         this.FButtonPrevious.Visible = true;
         this.FButtonNext.Enabled = true;
         this.FButtonNext.Visible = true;
         if(this.FPageIndex == 0)
         {
            if(this.FButtonPrevious.Enabled)
            {
               this.FButtonPrevious.Enabled = false;
            }
            this.CheckIsUse(true);
         }
         if(this.FPageIndex == this.FTotalPage - 1)
         {
            if(this.FButtonNext.Enabled)
            {
               this.FButtonNext.Enabled = false;
            }
            this.CheckIsUse(false);
         }
         this.UpdateLabelPage();
      }
      
      protected function ButtonPreviousPageOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FPageIndex > 0)
         {
            --this.PageIndex;
            if(this.FOnChangePage != null)
            {
               this.FOnChangePage(this,this.FPageIndex);
            }
         }
      }
      
      protected function ButtonNextPageOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FPageIndex + 1 < this.FTotalPage)
         {
            ++this.PageIndex;
            if(this.FOnChangePage != null)
            {
               this.FOnChangePage(this,this.FPageIndex);
            }
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.ResourcesPerform_UIDispatch();
         }
      }
      
      public function get Visible() : Boolean
      {
         if(!this.FInitialization)
         {
            return false;
         }
         return this.FResource.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         if(this.FResource.visible != param1)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function get TotalQuantity() : uint
      {
         return this.FTotalQuantity;
      }
      
      public function set TotalQuantity(param1:uint) : void
      {
         this.FTotalQuantity = param1;
         this.UpdateState();
      }
      
      public function get PageSize() : uint
      {
         return this.FPageSize;
      }
      
      public function set PageSize(param1:uint) : void
      {
         this.FPageSize = param1;
         this.UpdateTotalPage();
      }
      
      public function get LabelPage() : TextField
      {
         return this.FLabelPage;
      }
      
      public function set LabelPage(param1:TextField) : void
      {
         this.FLabelPage = param1;
      }
      
      public function set IsNoUseVisible(param1:Boolean) : void
      {
         this.FIsNoUseVisible = param1;
         this.UpdateState();
      }
      
      public function get OnChangePage() : Function
      {
         return this.FOnChangePage;
      }
      
      public function set OnChangePage(param1:Function) : void
      {
         this.FOnChangePage = param1;
      }
      
      public function get PageIndex() : int
      {
         return this.FPageIndex;
      }
      
      public function set PageIndex(param1:int) : void
      {
         this.FPageIndex = Math.min(param1,this.FTotalPage);
         this.UpdateState();
      }
      
      public function get TotalPage() : uint
      {
         this.UpdateTotalPage();
         return this.FTotalPage;
      }
      
      public function Dispose() : void
      {
         this.FResource = null;
         this.FButtonPrevious.Dispose();
         this.FButtonPrevious = null;
         this.FButtonNext.Dispose();
         this.FButtonNext = null;
         this.FLabelPage = null;
         this.FOnChangePage = null;
      }
      
      public function Reset() : void
      {
         this.FButtonPrevious.Enabled = false;
         this.FButtonNext.Enabled = false;
         if(this.FLabelPage != null)
         {
            this.FLabelPage.text = "";
         }
         this.PageIndex = 0;
      }
   }
}

