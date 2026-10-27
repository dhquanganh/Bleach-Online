package Components.ScrollBar
{
   import Foundation.Utilities.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   public class TScrollBar
   {
      
      public static const StartShow_Head:int = 1;
      
      public static const StartShow_End:int = 2;
      
      protected var FScene:MovieClip;
      
      protected var FScrolVisible:Boolean;
      
      protected var FMinScrollDistance:Number;
      
      protected var FItemStamp:Number;
      
      protected var FSingleItemStamp:Number;
      
      protected var FInitListPosY:Number;
      
      protected var FInitBarPosY:Number;
      
      protected var FCurBarPosY:Number;
      
      protected var FItems:Vector.<DisplayObject>;
      
      protected var FMaxHeight:int;
      
      protected var FAddItemAutoDown:Boolean;
      
      public function TScrollBar(param1:MovieClip, param2:Number, param3:Boolean = true, param4:Number = 0, param5:Number = 0)
      {
         super();
         this.FScene = param1;
         this.FMinScrollDistance = param2;
         this.FAddItemAutoDown = param3;
         this.FItemStamp = param4;
         this.FSingleItemStamp = param5;
         this.InitScroll();
      }
      
      protected function set ScrolVisible(param1:Boolean) : void
      {
         this.FScrolVisible = param1;
         this.FScene.btn_up.visible = param1;
         this.FScene.btn_down.visible = param1;
         this.FScene.mc_bar.visible = param1;
         this.FScene.mc_barback.visible = param1;
         if(this.FScene.mc_barline)
         {
            this.FScene.mc_barline.visible = param1;
         }
      }
      
      protected function get ScrolVisible() : Boolean
      {
         return this.FScrolVisible;
      }
      
      protected function InitScroll() : void
      {
         this.ScrolVisible = false;
         this.FItems = new Vector.<DisplayObject>();
         this.FMaxHeight = 0;
         this.FInitListPosY = this.FScene.mc_list.y;
         this.FInitBarPosY = this.FScene.mc_bar.y;
         TGameUtil.setMovieClipButton(this.FScene.btn_up,true);
         this.FScene.btn_up.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         TGameUtil.setMovieClipButton(this.FScene.btn_down,false);
         this.FScene.btn_down.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseDown);
         TGameUtil.setMovieClipButton(this.FScene.mc_bar,true);
         this.FScene.mc_bar.addEventListener(MouseEvent.MOUSE_DOWN,this.OnScrollDown);
         this.FScene.mc_barback.addEventListener(MouseEvent.MOUSE_UP,this.OnScorllLump);
         this.FScene.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel);
         if(this.FAddItemAutoDown)
         {
            this.FScene.mc_bar.y = this.FScene.mc_barback.y + this.FScene.mc_barback.height - this.FScene.mc_bar.height;
         }
      }
      
      protected function CheckBtn() : void
      {
         TGameUtil.setMovieClipButton(this.FScene.btn_up,this.FScene.mc_barback.y < this.FScene.mc_bar.y);
         TGameUtil.setMovieClipButton(this.FScene.btn_down,this.FScene.mc_barback.y + (this.FScene.mc_barback.height - this.FScene.mc_bar.height) >= this.FScene.mc_bar.y);
      }
      
      protected function OnScorllLump(param1:MouseEvent) : void
      {
         if(param1.localY < this.FScene.mc_bar.y)
         {
            this.FScene.mc_list.y += this.FMinScrollDistance;
            if(this.FScene.mc_list.y > this.FInitListPosY)
            {
               this.FScene.mc_list.y = this.FInitListPosY;
            }
         }
         else
         {
            this.FScene.mc_list.y -= this.FMinScrollDistance;
            if(this.FScene.mc_list.y < -(this.FScene.mc_list.height - this.FMinScrollDistance))
            {
               this.FScene.mc_list.y = -(this.FScene.mc_list.height - this.FMinScrollDistance);
            }
         }
         this.FScene.mc_bar.y = this.FInitBarPosY - this.FScene.mc_list.y / (this.FScene.mc_list.height - this.FMinScrollDistance) * (this.FScene.mc_barback.height - this.FScene.mc_bar.height);
         this.CheckBtn();
      }
      
      protected function OnMouseWheel(param1:MouseEvent) : void
      {
         if(this.FMaxHeight < this.FMinScrollDistance)
         {
            return;
         }
         if(param1.delta > 0)
         {
            this.OnMouseUp(null);
         }
         else
         {
            this.OnMouseDown(null);
         }
      }
      
      protected function OnScrollDown(param1:MouseEvent) : void
      {
         MovieClip(this.FScene.mc_bar).startDrag(false,new Rectangle(this.FScene.mc_barback.x,this.FScene.mc_barback.y - 1,0,this.FScene.mc_barback.height - this.FScene.mc_bar.height + 1));
         if(this.FScene.stage)
         {
            this.FScene.stage.addEventListener(MouseEvent.MOUSE_UP,this.OnScrollUp);
            this.FScene.stage.addEventListener(Event.ENTER_FRAME,this.OnScroll);
         }
      }
      
      protected function OnScroll(param1:Event) : void
      {
         this.FScene.mc_list.y = -(this.FScene.mc_list.height - this.FMinScrollDistance) * (this.FScene.mc_bar.y - this.FScene.mc_barback.y) / (this.FScene.mc_barback.height - this.FScene.mc_bar.height);
      }
      
      protected function OnScrollUp(param1:MouseEvent) : void
      {
         if(Boolean(this.FScene) && Boolean(this.FScene.mc_bar))
         {
            MovieClip(this.FScene.mc_bar).stopDrag();
         }
         if(this.FScene.stage)
         {
            this.FScene.stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnScrollUp);
            this.FScene.stage.removeEventListener(Event.ENTER_FRAME,this.OnScroll);
         }
         this.CheckBtn();
      }
      
      protected function OnMouseUp(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            if(!this.FScene.btn_up.buttonMode)
            {
               return;
            }
         }
         this.FScene.mc_list.y += this.FSingleItemStamp + this.FItemStamp;
         if(this.FScene.mc_list.y > this.FInitListPosY)
         {
            this.FScene.mc_list.y = this.FInitListPosY;
         }
         this.FScene.mc_bar.y = this.FInitBarPosY - this.FScene.mc_list.y / (this.FScene.mc_list.height - this.FSingleItemStamp) * (this.FScene.mc_barback.height - this.FScene.mc_bar.height);
         this.CheckBtn();
      }
      
      protected function OnMouseDown(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            if(!this.FScene.btn_down.buttonMode)
            {
               return;
            }
         }
         if(this.FScene.mc_list.height > this.FMinScrollDistance)
         {
            this.FScene.mc_list.y -= this.FSingleItemStamp + this.FItemStamp;
            if(this.FScene.mc_list.y < -(this.FScene.mc_list.height - this.FMinScrollDistance))
            {
               this.FScene.mc_list.y = -(this.FScene.mc_list.height - this.FMinScrollDistance);
            }
         }
         else
         {
            this.FScene.mc_list.y = 0;
         }
         this.FScene.mc_bar.y = this.FInitBarPosY - this.FScene.mc_list.y / (this.FScene.mc_list.height - this.FMinScrollDistance) * (this.FScene.mc_barback.height + 2 - this.FScene.mc_bar.height);
         this.CheckBtn();
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FScene.visible = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.FScene.visible;
      }
      
      public function get Count() : int
      {
         return this.FItems ? int(this.FItems.length) : 0;
      }
      
      public function get Items() : Vector.<DisplayObject>
      {
         return this.FItems;
      }
      
      public function get CurBarPosY() : Number
      {
         return this.FCurBarPosY;
      }
      
      public function set CurBarPosY(param1:Number) : void
      {
         this.FScene.mc_list.y = -param1;
         this.FScene.mc_bar.y = this.FInitBarPosY - this.FScene.mc_list.y / (this.FScene.mc_list.height - this.FMinScrollDistance) * (this.FScene.mc_barback.height + 2 - this.FScene.mc_bar.height);
      }
      
      public function AddItem(param1:DisplayObject) : void
      {
         param1.x = 0;
         param1.y = this.FMaxHeight;
         this.FScene.mc_list.addChild(param1);
         this.FItems.push(param1);
         this.FMaxHeight += param1.height + this.FItemStamp;
         if(this.FSingleItemStamp <= 0)
         {
            this.FSingleItemStamp = param1.height + this.FItemStamp;
         }
         if(this.FMaxHeight > this.FMinScrollDistance)
         {
            this.ScrolVisible = true;
         }
         if(this.FAddItemAutoDown)
         {
            this.OnMouseDown();
         }
         this.CheckBtn();
      }
      
      public function AddItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            this.AddItem(_loc3_);
            _loc2_++;
         }
      }
      
      public function DelItem(param1:int) : DisplayObject
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         if(param1 > this.FItems.length)
         {
            return null;
         }
         _loc3_ = this.FItems[param1];
         if(_loc3_ != null)
         {
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            this.FItems.splice(param1,1);
         }
         this.FMaxHeight = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FItems.length)
         {
            _loc4_ = this.FItems[_loc2_];
            _loc4_.y = this.FMaxHeight + this.FItemStamp;
            this.FMaxHeight += _loc4_.height + this.FItemStamp;
            _loc2_++;
         }
         if(this.FMaxHeight < this.FMinScrollDistance)
         {
            this.ScrolVisible = false;
         }
         return _loc3_;
      }
      
      public function Clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(this.FItems.length)
         {
            _loc1_ = this.FItems.pop();
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         this.ScrolVisible = false;
         this.FMaxHeight = 0;
         this.ScrollToUp();
      }
      
      public function ScrollToDown() : void
      {
         if(this.FScene == null)
         {
            return;
         }
         if(this.FScene.mc_list.height > this.FMinScrollDistance)
         {
            this.FScene.mc_list.y = -(this.FScene.mc_list.height - this.FMinScrollDistance);
         }
         else
         {
            this.FScene.mc_list.y = 0;
         }
         this.FScene.mc_bar.y = this.FInitBarPosY - this.FScene.mc_list.y / (this.FScene.mc_list.height - this.FMinScrollDistance) * (this.FScene.mc_barback.height + 2 - this.FScene.mc_bar.height);
         this.CheckBtn();
      }
      
      public function ScrollToUp() : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FScene.mc_list.y = this.FInitListPosY;
         this.FScene.mc_bar.y = this.FInitBarPosY;
         this.CheckBtn();
      }
      
      public function RemoveAllEvent() : void
      {
         this.FScene.btn_up.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         this.FScene.btn_down.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseDown);
         this.FScene.mc_bar.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnScrollDown);
         this.FScene.removeEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel);
         this.FScene.mc_barback.removeEventListener(MouseEvent.MOUSE_UP,this.OnScorllLump);
      }
      
      public function getCurHight() : Number
      {
         var _loc1_:Number = NaN;
         return this.FMaxHeight > this.FMinScrollDistance ? this.FMinScrollDistance : this.FMaxHeight;
      }
   }
}

