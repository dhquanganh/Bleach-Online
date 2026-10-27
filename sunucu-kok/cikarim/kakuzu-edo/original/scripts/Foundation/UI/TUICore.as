package Foundation.UI
{
   import Foundation.Common.*;
   import Resources.Constants.CONST_COMMON;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class TUICore extends Sprite
   {
      
      protected var FUIStage:Stage;
      
      protected var FMouseCoordinate:TCoordinate;
      
      protected var FMouseCapturingComponent:TUIComponent;
      
      protected var FMouseHoveringComponent:TUIComponent;
      
      protected var FModalComponents:Vector.<TUIComponent>;
      
      protected var FOverlayRoutines:Vector.<Function>;
      
      protected var FStageWidth:uint;
      
      protected var FStageHeight:uint;
      
      protected var FDragSource:TUIComponent;
      
      protected var FDragObject:Object;
      
      protected var FDragAccept:Boolean;
      
      protected var FShiftKey:Boolean;
      
      protected var FCtrlKey:Boolean;
      
      public function TUICore(param1:Stage)
      {
         super();
         this.FUIStage = param1;
         this.FUIStage.addChild(this);
         this.FStageWidth = CONST_COMMON.STAGE_Width;
         this.FStageHeight = CONST_COMMON.STAGE_Height;
         this.FMouseCoordinate = new TCoordinate();
         this.FMouseCapturingComponent = null;
         this.FModalComponents = new Vector.<TUIComponent>();
         this.FOverlayRoutines = new Vector.<Function>();
         this.FUIStage.addEventListener(KeyboardEvent.KEY_DOWN,this.StageOnKeyboardDown);
         this.FUIStage.addEventListener(KeyboardEvent.KEY_UP,this.StageOnKeyboardUp);
      }
      
      protected function StageOnKeyboardDown(param1:KeyboardEvent) : void
      {
         if(param1.shiftKey)
         {
            this.FShiftKey = true;
         }
         else
         {
            this.FShiftKey = false;
         }
         if(param1.ctrlKey)
         {
            this.FCtrlKey = true;
         }
         else
         {
            this.FCtrlKey = false;
         }
      }
      
      protected function StageOnKeyboardUp(param1:KeyboardEvent) : void
      {
         if(param1.shiftKey)
         {
            this.FShiftKey = true;
         }
         else
         {
            this.FShiftKey = false;
         }
         if(param1.ctrlKey)
         {
            this.FCtrlKey = true;
         }
         else
         {
            this.FCtrlKey = false;
         }
      }
      
      public function get ShiftKey() : Boolean
      {
         return this.FShiftKey;
      }
      
      public function set ShiftKey(param1:Boolean) : void
      {
         this.FShiftKey = param1;
      }
      
      public function get CtrlKey() : Boolean
      {
         return this.FCtrlKey;
      }
      
      public function set CtrlKey(param1:Boolean) : void
      {
         this.FCtrlKey = param1;
      }
      
      public function get UIStage() : Stage
      {
         return this.FUIStage;
      }
      
      public function get StageWidth() : uint
      {
         return this.FStageWidth;
      }
      
      public function get StageHeight() : uint
      {
         return this.FStageHeight;
      }
      
      public function get MouseCoordinate() : TCoordinate
      {
         return this.FMouseCoordinate;
      }
      
      public function get MouseCapturingComponent() : TUIComponent
      {
         return this.FMouseCapturingComponent;
      }
      
      public function get MouseHoveringComponent() : TUIComponent
      {
         return this.FMouseHoveringComponent;
      }
      
      public function get ModalComponent() : TUIComponent
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.FModalComponents.length);
         if(_loc1_ == 0)
         {
            return null;
         }
         return this.FModalComponents[_loc1_ - 1];
      }
      
      public function get OverlayCount() : int
      {
         return this.FOverlayRoutines.length;
      }
      
      public function get DragSource() : TUIComponent
      {
         return this.FDragSource;
      }
      
      public function set DragSource(param1:TUIComponent) : void
      {
         this.FDragSource = param1;
      }
      
      public function get DragObject() : Object
      {
         return this.FDragObject;
      }
      
      public function set DragObject(param1:Object) : void
      {
         this.FDragObject = param1;
      }
      
      public function get DragAccept() : Boolean
      {
         return this.FDragAccept;
      }
      
      public function set DragAccept(param1:Boolean) : void
      {
         this.FDragAccept = param1;
      }
      
      public function Update() : void
      {
         this.FMouseCoordinate.X = this.FUIStage.mouseX;
         this.FMouseCoordinate.Y = this.FUIStage.mouseY;
      }
      
      public function UpdateStageSize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = uint(this.FUIStage.stageWidth);
         _loc2_ = uint(this.FUIStage.stageHeight);
         if(_loc1_ > CONST_COMMON.STAGE_Max_Width)
         {
            _loc1_ = CONST_COMMON.STAGE_Max_Width;
         }
         if(_loc1_ < CONST_COMMON.STAGE_Min_Width)
         {
            _loc1_ = CONST_COMMON.STAGE_Min_Width;
         }
         if(_loc2_ > CONST_COMMON.STAGE_Max_Height)
         {
            _loc2_ = CONST_COMMON.STAGE_Max_Height;
         }
         if(_loc2_ < CONST_COMMON.STAGE_Min_Height)
         {
            _loc2_ = CONST_COMMON.STAGE_Min_Height;
         }
         this.FStageWidth = _loc1_;
         this.FStageHeight = _loc2_;
      }
      
      public function MouseCaptureSet(param1:TUIComponent) : void
      {
         this.FMouseCapturingComponent = param1;
         Mouse.hide();
      }
      
      public function MouseCaptureRelease(param1:TUIComponent) : void
      {
         if(this.FMouseCapturingComponent == param1)
         {
            this.FMouseCapturingComponent = null;
            Mouse.show();
         }
      }
      
      public function MouseHoverSet(param1:TUIComponent) : void
      {
         if(this.FMouseHoveringComponent == null)
         {
            this.FMouseHoveringComponent = param1;
         }
      }
      
      public function MouseHoverRelease() : void
      {
         this.FMouseHoveringComponent = null;
      }
      
      public function MouseHovering(param1:TUIComponent) : Boolean
      {
         return this.FMouseHoveringComponent == param1;
      }
      
      public function MouseStartDrag(param1:TUIComponent, param2:Boolean = false) : void
      {
         param1.startDrag(param2);
         param1.Visible = true;
      }
      
      public function MouseStopDrag(param1:TUIComponent) : void
      {
         param1.stopDrag();
         param1.Visible = false;
      }
      
      public function MouseSetCursor(param1:String) : void
      {
         if(Mouse.cursor != param1)
         {
            Mouse.cursor = param1;
         }
      }
      
      public function ModalSet(param1:TUIComponent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(this.FModalComponents.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.FModalComponents[_loc3_] == param1)
            {
               return;
            }
            _loc3_++;
         }
         this.FModalComponents.push(param1);
      }
      
      public function ModalRelease(param1:TUIComponent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         _loc2_ = int(this.FModalComponents.length);
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.FModalComponents[_loc3_] == param1)
            {
               this.FModalComponents.splice(_loc3_,1);
               return;
            }
            _loc3_--;
         }
      }
   }
}

