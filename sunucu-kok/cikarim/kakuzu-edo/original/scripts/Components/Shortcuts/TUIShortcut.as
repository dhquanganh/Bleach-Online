package Components.Shortcuts
{
   import Foundation.Common.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TUIShortcut extends TUIComponent
   {
      
      protected static const COORDINATE_Btn_X:int = 0;
      
      protected static const COORDINATE_Btn_Y:int = 1;
      
      protected var FSubstrate:Sprite;
      
      protected var FBmp_Left:Bitmap;
      
      protected var FBmpData_Middle:BitmapData;
      
      protected var FBmps_Middle:Vector.<Bitmap>;
      
      protected var FBmp_Right:Bitmap;
      
      protected var FEffects:TAnimationSequence;
      
      protected var FLayerEffects:Vector.<Bitmap>;
      
      protected var FButtons:Vector.<SimpleButton>;
      
      protected var FHints:Vector.<THint>;
      
      protected var FCoordinateBtn:Vector.<int>;
      
      protected var FBounds:TBounds;
      
      protected var FCapacity:uint;
      
      protected var FIsEffects:Vector.<Boolean>;
      
      protected var FInitialization:Boolean;
      
      protected var FNeedEffectOnMap:Boolean;
      
      protected var FIsWrap:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnDown:Function;
      
      protected var FOnUp:Function;
      
      public function TUIShortcut(param1:TUIComponent)
      {
         super(param1);
         this.FSubstrate = new Sprite();
         this.addChild(this.FSubstrate);
         this.FBmps_Middle = new Vector.<Bitmap>();
         this.FButtons = new Vector.<SimpleButton>();
         this.FHints = new Vector.<THint>();
         this.FLayerEffects = new Vector.<Bitmap>();
         this.FBounds = new TBounds();
         this.FIsEffects = new Vector.<Boolean>();
         this.mouseEnabled = false;
         this.FInitialization = false;
      }
      
      protected function Resources_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:Bitmap = null;
         var _loc5_:SimpleButton = null;
         var _loc6_:TAnimationFrame = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.FEffects != null)
         {
            _loc6_ = this.FEffects.GetAnimationFrameByIndex(0);
            _loc8_ = _loc6_.Surface.width;
            _loc9_ = _loc6_.Surface.height;
         }
         this.FSubstrate.addChild(this.FBmp_Left);
         _loc7_ = this.FBmp_Left.width;
         _loc2_ = int(this.FCapacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new Bitmap(this.FBmpData_Middle);
            this.FSubstrate.addChild(_loc4_);
            _loc4_.x = _loc7_;
            this.FBmps_Middle[_loc1_] = _loc4_;
            _loc7_ = _loc4_.x + _loc4_.width;
            _loc3_ = new Bitmap();
            this.FSubstrate.addChild(_loc3_);
            this.FLayerEffects[_loc1_] = _loc3_;
            this.FIsEffects[_loc1_] = false;
            _loc5_ = this.FButtons[_loc1_];
            if(_loc5_ != null)
            {
               _loc5_.x = _loc4_.x + (_loc4_.width - _loc5_.width) / 2 + this.FCoordinateBtn[COORDINATE_Btn_X];
               _loc5_.y = _loc4_.y + (_loc4_.height - _loc5_.height) / 2 + this.FCoordinateBtn[COORDINATE_Btn_Y];
               _loc5_.tabIndex = _loc1_;
               this.FSubstrate.addChild(_loc5_);
               this.addEventListenerPlayer(_loc5_);
            }
            _loc1_++;
         }
         this.FSubstrate.addChild(this.FBmp_Right);
         this.FBmp_Right.x = _loc7_;
      }
      
      protected function UpdateLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:SimpleButton = null;
         var _loc5_:Bitmap = null;
         var _loc6_:TAnimationFrame = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.FEffects != null)
         {
            _loc6_ = this.FEffects.GetAnimationFrameByIndex(0);
            _loc8_ = _loc6_.Surface.width;
            _loc9_ = _loc6_.Surface.height;
         }
         _loc7_ = false;
         _loc10_ = this.FBmp_Left.width;
         this.FBounds.Width = this.FBmp_Left.width;
         _loc2_ = int(this.FCapacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBmps_Middle[_loc1_];
            _loc4_ = this.FButtons[_loc1_];
            _loc5_ = this.FLayerEffects[_loc1_];
            if(_loc3_.visible)
            {
               _loc3_.x = _loc10_;
               _loc4_.x = _loc3_.x + this.FCoordinateBtn[COORDINATE_Btn_X];
               _loc4_.y = _loc3_.y + this.FCoordinateBtn[COORDINATE_Btn_Y];
               _loc5_.x = _loc3_.x + (_loc3_.width - _loc8_) / 2;
               _loc5_.y = _loc3_.y + (_loc3_.height - _loc9_) / 2 + 5;
               _loc10_ += _loc3_.width;
               _loc7_ = true;
            }
            else
            {
               _loc3_.x = 0;
               _loc4_.x = 0;
               _loc5_.x = 0;
               _loc5_.y = 0;
               _loc5_.visible = false;
            }
            _loc1_++;
         }
         this.FBmp_Right.x = _loc10_;
         this.FBmp_Left.visible = _loc7_;
         this.FBmp_Right.visible = _loc7_;
         if(_loc7_)
         {
            this.FBounds.Width = _loc10_;
         }
         else
         {
            this.FBounds.Width = 0;
         }
      }
      
      protected function LogicsPerform_UpdataEffects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Bitmap = null;
         var _loc5_:TAnimationFrame = null;
         _loc2_ = int(this.FCapacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FIsEffects[_loc1_];
            if(_loc3_)
            {
               _loc4_ = this.FLayerEffects[_loc1_];
               _loc5_ = this.FEffects.GetAnimationFrameByTick(STimingCore.TickCount);
               if(_loc4_.bitmapData == null)
               {
                  _loc4_.bitmapData = _loc5_.Surface;
               }
               else if(_loc4_.bitmapData != _loc5_.Surface)
               {
                  _loc4_.bitmapData = _loc5_.Surface;
               }
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorSwapComponent(param1:int, param2:SimpleButton, param3:SimpleButton) : void
      {
         param3.x = param2.x;
         param3.y = param2.y;
         param3.tabIndex = param2.tabIndex;
         this.RemoveEventListenerPlayer(param2);
         this.FSubstrate.removeChild(param2);
         this.FSubstrate.addChild(param3);
         this.addEventListenerPlayer(param3);
         this.FButtons[param1] = param3;
      }
      
      protected function addEventListenerPlayer(param1:SimpleButton) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.BtnOnClick,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnMove,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.BtnOnOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOUT,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.BtnOnDown,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.BtnOnUp,false,0,true);
      }
      
      protected function RemoveEventListenerPlayer(param1:SimpleButton) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.BtnOnClick);
         param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnMove);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.BtnOnOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOUT);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.BtnOnDown);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.BtnOnUp);
      }
      
      protected function BtnOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc3_);
         if(this.FOnClick != null)
         {
            this.FOnClick(this,_loc2_);
         }
      }
      
      protected function BtnOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         _loc4_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc4_);
         if(this.FOnMove != null)
         {
            this.FOnMove(this,_loc2_);
         }
      }
      
      protected function BtnOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc3_);
         if(this.FOnOver != null)
         {
            this.FOnOver(_loc3_,_loc2_);
         }
      }
      
      protected function BtnOnOUT(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc3_);
         if(this.FOnOut != null)
         {
            this.FOnOut(_loc3_,_loc2_);
         }
      }
      
      protected function BtnOnDown(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc3_);
         if(this.FOnDown != null)
         {
            this.FOnDown(_loc3_,_loc2_);
         }
      }
      
      protected function BtnOnUp(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FButtons.indexOf(_loc3_);
         if(this.FOnUp != null)
         {
            this.FOnUp(_loc3_,_loc2_);
         }
      }
      
      public function get Substrate() : Sprite
      {
         return this.FSubstrate;
      }
      
      public function get Capacity() : uint
      {
         return this.FCapacity;
      }
      
      public function set Capacity(param1:uint) : void
      {
         this.FCapacity = param1;
      }
      
      public function get Bmp_Left() : Bitmap
      {
         return this.FBmp_Left;
      }
      
      public function set Bmp_Left(param1:Bitmap) : void
      {
         this.FBmp_Left = param1;
      }
      
      public function get BmpData_Middle() : BitmapData
      {
         return this.FBmpData_Middle;
      }
      
      public function set BmpData_Middle(param1:BitmapData) : void
      {
         this.FBmpData_Middle = param1;
      }
      
      public function get Bmp_Right() : Bitmap
      {
         return this.FBmp_Right;
      }
      
      public function set Bmp_Right(param1:Bitmap) : void
      {
         this.FBmp_Right = param1;
      }
      
      public function get IsInitialization() : Boolean
      {
         return this.FInitialization;
      }
      
      public function set IsInitialization(param1:Boolean) : void
      {
         this.FInitialization = param1;
      }
      
      public function get Bounds() : TBounds
      {
         return this.FBounds;
      }
      
      public function get CoordinateBtn() : Vector.<int>
      {
         return this.FCoordinateBtn;
      }
      
      public function set CoordinateBtn(param1:Vector.<int>) : void
      {
         this.FCoordinateBtn = param1;
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
      
      public function get OnDown() : Function
      {
         return this.FOnDown;
      }
      
      public function set OnDown(param1:Function) : void
      {
         this.FOnDown = param1;
      }
      
      public function get OnUp() : Function
      {
         return this.FOnUp;
      }
      
      public function set OnUp(param1:Function) : void
      {
         this.FOnUp = param1;
      }
      
      public function get IsWrap() : Boolean
      {
         return this.FIsWrap;
      }
      
      public function set IsWrap(param1:Boolean) : void
      {
         this.FIsWrap = param1;
      }
      
      public function get Effects() : TAnimationSequence
      {
         return this.FEffects;
      }
      
      public function set Effects(param1:TAnimationSequence) : void
      {
         this.FEffects = param1;
      }
      
      public function GetBmp_Middle(param1:int) : Bitmap
      {
         return this.FBmps_Middle[param1];
      }
      
      public function GetIsEffectByIndex(param1:int) : Boolean
      {
         return this.FIsEffects[param1];
      }
      
      public function SetIsEffectByIndex(param1:Boolean, param2:int) : void
      {
         if(this.FIsEffects[param2] != param1)
         {
            this.FIsEffects[param2] = param1;
            this.FLayerEffects[param2].visible = param1;
         }
      }
      
      public function GetButtonByIndex(param1:int) : SimpleButton
      {
         return this.FButtons[param1];
      }
      
      public function SetButtonByIndex(param1:SimpleButton, param2:int) : void
      {
         this.FButtons[param2] = param1;
      }
      
      public function GetHintByIndex(param1:int) : THint
      {
         return this.FHints[param1];
      }
      
      public function SetHintByIndex(param1:THint, param2:int) : void
      {
         this.FHints[param2] = param1;
      }
      
      public function GetLayerEffectByIndex(param1:int) : Bitmap
      {
         return this.FLayerEffects[param1];
      }
      
      public function SetLayerEffectByIndex(param1:Bitmap, param2:int) : void
      {
         this.FLayerEffects[param2] = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         if(!this.FInitialization)
         {
            this.Resources_UILocations();
            this.FInitialization = true;
         }
      }
      
      public function UpdateComponentsLocation() : void
      {
         this.UpdateLocation();
      }
      
      public function UpdataEffects() : void
      {
         this.LogicsPerform_UpdataEffects();
      }
      
      public function SwapComponent(param1:int, param2:SimpleButton, param3:SimpleButton) : void
      {
         this.ProcessorSwapComponent(param1,param2,param3);
      }
   }
}

