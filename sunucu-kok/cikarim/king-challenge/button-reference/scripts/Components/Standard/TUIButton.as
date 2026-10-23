package Components.Standard
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIButton
   {
      
      protected static const RESOURCE_Link_TF_Caption:String = "TF_Caption";
      
      protected static const RENDERINGSTATE_Normal:uint = 1;
      
      protected static const RENDERINGSTATE_Hovering:uint = 2;
      
      protected static const RENDERINGSTATE_Pressed:uint = 3;
      
      protected static const RENDERINGSTATE_Disabled:uint = 4;
      
      protected var FSubstrate:MovieClip;
      
      protected var FMousePressed:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FHint:THint;
      
      protected var FOnClick:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FIsFilter:Boolean;
      
      protected var FEnabled:Boolean;
      
      protected var FTag:int;
      
      public function TUIButton()
      {
         super();
         this.FHint = new THint();
         this.FIsFilter = false;
         this.FEnabled = true;
         this.FIsInitialization = false;
      }
      
      protected function Initialization() : void
      {
         this.FSubstrate.mouseChildren = false;
         this.FSubstrate.tabEnabled = false;
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonOnOver,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonOnOut,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonOnMove,false,0,true);
         this.AddButtonEventListener();
         this.FIsInitialization = true;
      }
      
      protected function AddButtonEventListener() : void
      {
         this.FSubstrate.buttonMode = true;
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_DOWN,this.ButtonOnDown,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_UP,this.ButtonOnUp,false,0,true);
      }
      
      protected function RemoveButtonEventListener() : void
      {
         this.FSubstrate.buttonMode = false;
         this.FSubstrate.removeEventListener(MouseEvent.MOUSE_DOWN,this.ButtonOnDown);
         this.FSubstrate.removeEventListener(MouseEvent.MOUSE_UP,this.ButtonOnUp);
      }
      
      protected function ButtonOnDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         _loc2_.gotoAndStop(RENDERINGSTATE_Pressed);
         this.FMousePressed = true;
      }
      
      protected function ButtonOnUp(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.FMousePressed)
         {
            if(this.FOnClick != null)
            {
               this.FOnClick(this,param1);
            }
            if(this.FEnabled)
            {
               if(_loc2_.currentFrame == RENDERINGSTATE_Disabled)
               {
                  return;
               }
               if(_loc2_.currentFrame != RENDERINGSTATE_Hovering)
               {
                  _loc2_.gotoAndStop(RENDERINGSTATE_Hovering);
               }
               else if(_loc2_.currentFrame != RENDERINGSTATE_Normal)
               {
                  _loc2_.gotoAndStop(RENDERINGSTATE_Normal);
               }
            }
         }
         this.FMousePressed = false;
      }
      
      protected function ButtonOnClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      protected function ButtonOnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.FOnOver != null)
         {
            this.FOnOver(this,param1);
         }
         if(_loc2_.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         if(_loc2_.currentFrame != RENDERINGSTATE_Hovering)
         {
            _loc2_.gotoAndStop(RENDERINGSTATE_Hovering);
         }
      }
      
      protected function ButtonOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.FOnOut != null)
         {
            this.FOnOut(this,param1);
         }
         if(_loc2_.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         if(_loc2_.currentFrame != RENDERINGSTATE_Normal)
         {
            _loc2_.gotoAndStop(RENDERINGSTATE_Normal);
         }
         this.FMousePressed = false;
      }
      
      protected function ButtonOnMove(param1:MouseEvent) : void
      {
         if(this.FOnMove != null)
         {
            this.FOnMove(this,param1);
         }
      }
      
      public function get Substrate() : MovieClip
      {
         return this.FSubstrate;
      }
      
      public function set Substrate(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FSubstrate)
         {
            this.FSubstrate = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      public function set Caption(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         var _loc5_:int = 0;
         _loc5_ = this.FSubstrate.currentFrame;
         _loc3_ = this.FSubstrate.totalFrames;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSubstrate.gotoAndStop(_loc2_ + 1);
            _loc4_ = this.FSubstrate[RESOURCE_Link_TF_Caption];
            if(_loc4_ != null)
            {
               _loc4_.text = param1;
            }
            _loc2_++;
         }
         this.FSubstrate.gotoAndStop(_loc5_);
         _loc4_ = this.FSubstrate[RESOURCE_Link_TF_Caption];
         if(_loc4_ != null)
         {
            _loc4_.text = param1;
         }
      }
      
      public function get Enabled() : Boolean
      {
         return this.FEnabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         if(param1)
         {
            this.AddButtonEventListener();
            this.FSubstrate.gotoAndStop(RENDERINGSTATE_Normal);
            if(this.FIsFilter)
            {
               this.FSubstrate.filters = [];
            }
         }
         else
         {
            this.RemoveButtonEventListener();
            this.FSubstrate.gotoAndStop(RENDERINGSTATE_Disabled);
            if(this.FIsFilter)
            {
               this.FSubstrate.filters = [TUtilityFilter.gBlackFilters];
            }
         }
         this.FEnabled = param1;
      }
      
      public function get X() : int
      {
         return this.FSubstrate.x;
      }
      
      public function set X(param1:int) : void
      {
         this.FSubstrate.x = param1;
      }
      
      public function get Y() : int
      {
         return this.FSubstrate.y;
      }
      
      public function set Y(param1:int) : void
      {
         this.FSubstrate.y = param1;
      }
      
      public function get Width() : int
      {
         return this.FSubstrate.width;
      }
      
      public function get Height() : int
      {
         return this.FSubstrate.height;
      }
      
      public function get Visible() : Boolean
      {
         if(!this.FIsInitialization)
         {
            return false;
         }
         return this.FSubstrate.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FSubstrate.visible = param1;
      }
      
      public function get Hint() : THint
      {
         return this.FHint;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnMove() : Function
      {
         return this.FOnMove;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get IsFilter() : Boolean
      {
         return this.FIsFilter;
      }
      
      public function set IsFilter(param1:Boolean) : void
      {
         this.FIsFilter = param1;
      }
      
      public function get Tag() : int
      {
         return this.FTag;
      }
      
      public function set Tag(param1:int) : void
      {
         this.FTag = param1;
      }
      
      public function Dispose() : void
      {
         this.FSubstrate.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonOnOver);
         this.FSubstrate.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonOnOut);
         this.FSubstrate.removeEventListener(MouseEvent.MOUSE_MOVE,this.ButtonOnMove);
         this.RemoveButtonEventListener();
         this.FSubstrate.removeEventListener(MouseEvent.CLICK,this.ButtonOnClick);
         this.FHint = null;
         this.FOnClick = null;
         this.FOnMove = null;
         this.FOnOver = null;
         this.FOnOut = null;
         this.FSubstrate = null;
      }
      
      public function StopPropagation() : void
      {
         this.FSubstrate.addEventListener(MouseEvent.CLICK,this.ButtonOnClick,false,0,true);
      }
   }
}

