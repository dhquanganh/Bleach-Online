package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.Shortcuts.*;
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.geom.Point;
   import ghostcat.operation.*;
   import ghostcat.util.easing.*;
   
   public class TWindowPopupBase extends TWindowBase
   {
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FBmp_Pointer:Bitmap;
      
      protected var FFollowPoint:TCoordinate = null;
      
      protected var FCallbackHide:Function;
      
      public function TWindowPopupBase(param1:TUIComponent)
      {
         super(param1);
         FUIShortcut = new TUIShortcut9Grid(this);
         this.ConstructTweens();
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 10;
         this.FTweenOperIn.target = this;
         this.FTweenOperOut.duration = 150;
         this.FTweenOperOut.target = this;
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FClassNameBmpLeft = CONST_SHORTCUTS.RESOURCE_ClassName_Popup_Bmp_Left;
         FClassNameBmpMiddle = CONST_SHORTCUTS.RESOURCE_ClassName_Popup_Bmp_Middle;
         FClassNameBmpRight = CONST_SHORTCUTS.RESOURCE_ClassName_Popup_Bmp_Right;
         (FUIShortcut as TUIShortcut9Grid).UI9GridSource = SUtilityResource.BtmDataShortcutPopupBG;
         super.Resources_UIDispatch();
         this.FBmp_Pointer = TUtilityReflection.CreateBitmapByDisplayObject(CONST_SHORTCUTS.RESOURCE_ClassName_Popup_Bmp_Pointer);
         addChild(this.FBmp_Pointer);
      }
      
      override protected function ProcessorResize() : void
      {
      }
      
      override protected function Resources_UILocations() : void
      {
         super.Resources_UILocations();
      }
      
      override protected function ComponentsAlign() : void
      {
         var _loc1_:Point = null;
         if(!this.Visible)
         {
            return;
         }
         if(this.FFollowPoint == null)
         {
            this.FBmp_Pointer.x = (ShortcutWidth - this.FBmp_Pointer.width) / 2;
         }
         else
         {
            _loc1_ = globalToLocal(new Point(this.FFollowPoint.X,this.FFollowPoint.Y));
            this.FBmp_Pointer.x = _loc1_.x - this.FBmp_Pointer.width / 2;
         }
         this.FBmp_Pointer.y = FUIShortcut.Y - this.FBmp_Pointer.height + 2;
      }
      
      override protected function UpdateShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FUIShortcut.GetButtonByIndex(_loc1_);
            _loc5_ = _loc3_.visible;
            _loc4_ = FIsEffects[_loc1_];
            if(!_loc5_)
            {
               FUIShortcut.SetIsEffectByIndex(_loc5_,_loc1_);
            }
            else
            {
               FUIShortcut.SetIsEffectByIndex(_loc4_,_loc1_);
            }
            _loc1_++;
         }
         FUIShortcut.UpdateComponentsLocation();
      }
      
      protected function PerformTweenOperOnStart(param1:TweenEvent) : void
      {
         if(!this.Visible)
         {
            this.Visible = true;
         }
      }
      
      protected function PerformTweenOperOnComplete(param1:TweenEvent) : void
      {
         if(this.Visible)
         {
            this.Visible = false;
            this.mouseEnabled = true;
            this.mouseChildren = true;
         }
         if(this.FCallbackHide != null)
         {
            this.FCallbackHide(this);
         }
      }
      
      public function set CallbackHide(param1:Function) : void
      {
         this.FCallbackHide = param1;
      }
      
      public function set FollowPoint(param1:TCoordinate) : void
      {
         this.FFollowPoint = param1;
      }
      
      public function Show() : void
      {
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeIn,
            "onStartHandler":this.PerformTweenOperOnStart
         };
         this.FTweenOperOut.params = {
            "alpha":1,
            "ease":Cubic.easeOut,
            "onCompleteHandler":this.PerformTweenOperOnStart
         };
         this.FRepeatOper.execute();
      }
      
      public function Hide() : void
      {
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeOut,
            "onStartHandler":this.PerformTweenOperOnStart
         };
         this.FTweenOperOut.params = {
            "alpha":0,
            "ease":Cubic.easeIn,
            "onCompleteHandler":this.PerformTweenOperOnComplete
         };
         this.FRepeatOper.execute();
      }
      
      override public function Update() : void
      {
         this.ComponentsAlign();
         super.Update();
      }
      
      override public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:SimpleButton = null;
         _loc2_ = FUIShortcut.GetButtonByIndex(param1.Index);
         _loc2_.visible = true;
         this.UpdateShortcuts();
      }
      
      override public function QueryShortcutCoordinate(param1:Object, param2:uint, param3:TQueryCoordinate) : void
      {
         var _loc4_:SimpleButton = null;
         var _loc5_:TCoordinate = null;
         _loc4_ = FUIShortcut.GetButtonByIndex(param2);
         _loc5_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc4_);
         _loc5_.X += _loc4_.width / 2 - 12;
         _loc5_.Y += _loc4_.height / 2 - 6;
         param3.Value.Assign(_loc5_);
      }
      
      public function GetShortcutsState() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc2_ = int(FShortcutsTypes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FUIShortcut.GetButtonByIndex(_loc1_);
            if(_loc3_.visible)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
   }
}

