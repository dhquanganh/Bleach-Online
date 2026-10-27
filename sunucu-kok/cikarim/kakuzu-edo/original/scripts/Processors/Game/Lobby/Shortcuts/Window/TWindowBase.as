package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.Shortcuts.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Unlocks.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TWindowBase extends TUIComponent
   {
      
      protected static const RESOURCE_ClassName_Common_Bmp_Common:String = CONST_SHORTCUTS.RESOURCE_ClassName_Common_Bmp_Common;
      
      protected static const COORDINATE_BTN:Vector.<int> = Vector.<int>([1,1]);
      
      protected var FUIShortcut:TUIShortcut;
      
      protected var FBtnCoordinates:Vector.<int>;
      
      protected var FQueryShortcut:TQueryBoolean;
      
      protected var FQueryShortcutCombine:TQueryBoolean;
      
      protected var FIsEffects:Vector.<Boolean>;
      
      protected var FBounds:TBounds;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FClassNameBmpLeft:String;
      
      protected var FClassNameBmpMiddle:String;
      
      protected var FClassNameBmpRight:String;
      
      protected var FResourceClassNameBtns:Vector.<String>;
      
      protected var FInitialization:Boolean;
      
      protected var FShortcutsPosition:uint;
      
      protected var FShortcutsTypes:Vector.<uint>;
      
      protected var FShortcutOnClick:Function;
      
      protected var FOnUnlockResponse:Function;
      
      protected var FOnQueryShortcutUnlock:Function;
      
      protected var FOnQueryShortcutCombine:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TWindowBase(param1:TUIComponent)
      {
         super(param1);
         this.FUIShortcut = new TUIShortcut(this);
         this.FQueryShortcut = new TQueryBoolean();
         this.FQueryShortcutCombine = new TQueryBoolean();
         this.FBounds = new TBounds();
         this.FBtnCoordinates = COORDINATE_BTN;
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:SimpleButton = null;
         var _loc5_:TAnimationSequence = null;
         this.FUIShortcut.Bmp_Left = TUtilityReflection.CreateBitmapByDisplayObject(this.FClassNameBmpLeft);
         this.FUIShortcut.BmpData_Middle = TUtilityReflection.CreateBitmapDataByDisplayObject(this.FClassNameBmpMiddle);
         this.FUIShortcut.Bmp_Right = TUtilityReflection.CreateBitmapByDisplayObject(this.FClassNameBmpRight);
         _loc5_ = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Textures_ShortcutEffect,0);
         this.FUIShortcut.Effects = _loc5_;
         _loc2_ = int(this.FShortcutsTypes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FResourceClassNameBtns[_loc1_];
            _loc4_ = TUtilityReflection.CreateSimpleButtonByDisplayObject(_loc3_) as SimpleButton;
            if(_loc4_ == null)
            {
               _loc4_ = TUtilityReflection.CreateSimpleButtonByDisplayObject(RESOURCE_ClassName_Common_Bmp_Common) as SimpleButton;
            }
            this.FUIShortcut.SetButtonByIndex(_loc4_,_loc1_);
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,this.FShortcutsPosition * 10000 + _loc1_,_loc4_);
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,this.FShortcutsPosition * 10000 + _loc1_,FParent);
            _loc1_++;
         }
         this.FIsEffects = new Vector.<Boolean>(this.FShortcutsTypes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FIsEffects[_loc1_] = false;
            _loc1_++;
         }
         this.FClassNameBmpLeft = null;
         this.FClassNameBmpMiddle = null;
         this.FClassNameBmpRight = null;
         this.FResourceClassNameBtns = null;
      }
      
      protected function Resources_UILocations() : void
      {
         this.FUIShortcut.OnClick = this.ShortcutsOnClick;
         this.FUIShortcut.Capacity = this.FShortcutsTypes.length;
         this.FUIShortcut.CoordinateBtn = this.FBtnCoordinates;
         this.FUIShortcut.Perform_UIDispatch();
      }
      
      protected function UpdateShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:SimpleButton = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(!this.FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(this.FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUIShortcut.GetBmp_Middle(_loc1_);
            _loc4_ = this.FUIShortcut.GetButtonByIndex(_loc1_);
            _loc6_ = _loc4_.visible;
            _loc5_ = this.FIsEffects[_loc1_];
            _loc3_.visible = _loc6_;
            if(!_loc6_)
            {
               this.FUIShortcut.SetIsEffectByIndex(_loc6_,_loc1_);
            }
            else
            {
               this.FUIShortcut.SetIsEffectByIndex(_loc5_,_loc1_);
            }
            _loc1_++;
         }
         this.FUIShortcut.UpdateComponentsLocation();
      }
      
      protected function UpdateEffects() : void
      {
         if(this.FUIShortcut.IsInitialization)
         {
            this.FUIShortcut.UpdataEffects();
         }
      }
      
      protected function ProcessorShortcutShowEffect(param1:uint, param2:Boolean) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         _loc5_ = this.FShortcutsTypes.indexOf(param1);
         _loc3_ = this.FUIShortcut.GetButtonByIndex(_loc5_);
         this.FIsEffects[_loc5_] = param2;
         if(!_loc3_.visible)
         {
            return;
         }
         _loc4_ = this.FUIShortcut.GetIsEffectByIndex(_loc5_);
         if(_loc4_ != param2)
         {
            this.FUIShortcut.SetIsEffectByIndex(param2,_loc5_);
         }
      }
      
      protected function ProcessorChangeShortcutIcon(param1:uint) : void
      {
      }
      
      protected function ComponentsAlign() : void
      {
      }
      
      protected function PopupAdaptive(param1:TWindowPopupBase, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc4_:TCoordinate = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc5_ = FUICore.StageWidth;
         _loc6_ = FUICore.StageHeight;
         if(param1.Visible)
         {
            if(param1.ShortcutWidth > 0)
            {
               _loc3_ = this.FUIShortcut.GetButtonByIndex(param2);
               _loc4_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
               _loc4_.X += this.FUIShortcut.BmpData_Middle.width / 2;
               _loc4_.Y += this.Height - 5;
               param1.X = _loc4_.X - param1.ShortcutWidth / 2;
               param1.FollowPoint = null;
               param1.Y = _loc4_.Y;
               if(param1.X < 0)
               {
                  param1.X = 0;
                  param1.FollowPoint = _loc4_;
               }
               else if(param1.X + param1.ShortcutWidth > _loc5_)
               {
                  param1.X = _loc5_ - param1.ShortcutWidth;
                  param1.FollowPoint = _loc4_;
               }
            }
            else if(param1.Visible)
            {
               param1.Hide();
            }
         }
      }
      
      protected function ShortcutsOnClick(param1:Object, param2:int, param3:int = 0, param4:Vector.<uint> = null) : void
      {
         var _loc5_:Vector.<uint> = null;
         if(this.FShortcutOnClick != null)
         {
            SLogicsCore.SinalPostFreshGuide(this.FShortcutsPosition * 10000 + param2);
            if(param4 == null)
            {
               _loc5_ = this.FShortcutsTypes;
            }
            else
            {
               _loc5_ = param4;
            }
            this.FShortcutOnClick(this,_loc5_[param2],param3,param4);
         }
      }
      
      public function get ShortcutWidth() : int
      {
         return this.FUIShortcut.Bounds.Width;
      }
      
      public function get ShortcutsPosition() : uint
      {
         return this.FShortcutsPosition;
      }
      
      public function get ShortcutsTypes() : Vector.<uint>
      {
         return this.FShortcutsTypes;
      }
      
      public function get ShortcutOnClick() : Function
      {
         return this.FShortcutOnClick;
      }
      
      public function set ShortcutOnClick(param1:Function) : void
      {
         this.FShortcutOnClick = param1;
      }
      
      public function get OnUnlockResponse() : Function
      {
         return this.FOnUnlockResponse;
      }
      
      public function set OnUnlockResponse(param1:Function) : void
      {
         this.FOnUnlockResponse = param1;
      }
      
      public function get OnQueryShortcutUnlock() : Function
      {
         return this.FOnQueryShortcutUnlock;
      }
      
      public function set OnQueryShortcutUnlock(param1:Function) : void
      {
         this.FOnQueryShortcutUnlock = param1;
      }
      
      public function get OnQueryShortcutCombine() : Function
      {
         return this.FOnQueryShortcutCombine;
      }
      
      public function set OnQueryShortcutCombine(param1:Function) : void
      {
         this.FOnQueryShortcutCombine = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
         this.FInitialization = true;
      }
      
      public function Update() : void
      {
         this.UpdateEffects();
      }
      
      public function UpdateShortcutsState(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         _loc3_ = int(this.FUIShortcut.Capacity);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FUIShortcut.GetButtonByIndex(_loc2_);
            if(this.FOnQueryShortcutUnlock != null)
            {
               this.FQueryShortcut.Value = false;
               this.FOnQueryShortcutUnlock(this,this.FShortcutsPosition,_loc2_,this.FQueryShortcut);
            }
            _loc4_.visible = this.FQueryShortcut.Value;
            if(this.FOnQueryShortcutCombine != null && _loc4_.visible)
            {
               this.FQueryShortcutCombine.Value = false;
               this.FOnQueryShortcutCombine(this,this.FShortcutsPosition,_loc2_,this.FQueryShortcutCombine);
               _loc4_.visible = this.FQueryShortcutCombine.Value;
            }
            _loc2_++;
         }
         this.UpdateShortcuts();
      }
      
      public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc2_ = this.FUIShortcut.GetButtonByIndex(param1.Index);
         _loc2_.alpha = 0;
         _loc2_.visible = true;
         this.UpdateShortcuts();
         if(this.FOnUnlockResponse != null)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc2_);
            _loc4_ = new TBounds();
            _loc4_.Assign(_loc3_);
            _loc4_.Width = _loc2_.width;
            _loc4_.Height = _loc2_.height;
            this.FOnUnlockResponse(this,_loc4_,_loc2_);
         }
      }
      
      public function ShowEffectNotification(param1:uint, param2:uint, param3:Boolean) : void
      {
         this.ProcessorShortcutShowEffect(param2,param3);
      }
      
      public function GetEffectState() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         _loc2_ = int(this.FShortcutsTypes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUIShortcut.GetButtonByIndex(_loc1_);
            if(this.FIsEffects[_loc1_] && _loc3_.visible)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function QueryShortcutCoordinate(param1:Object, param2:uint, param3:TQueryCoordinate) : void
      {
         var _loc4_:SimpleButton = null;
         var _loc5_:TCoordinate = null;
         _loc4_ = this.FUIShortcut.GetButtonByIndex(param2);
         _loc5_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc4_);
         _loc5_.X += _loc4_.width / 2 - 12;
         _loc5_.Y += _loc4_.height / 2 - 6;
         param3.Value.Assign(_loc5_);
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         if(!this.FInitialization)
         {
            return;
         }
         if(!this.FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc3_ = this.FUIShortcut.GetButtonByIndex(param2);
         if(this.FOnQueryShortcutUnlock != null)
         {
            this.FQueryShortcut.Value = false;
            this.FOnQueryShortcutUnlock(this,this.FShortcutsPosition,param2,this.FQueryShortcut);
         }
         _loc3_.visible = this.FQueryShortcut.Value;
         if(this.FOnQueryShortcutCombine != null && _loc3_.visible)
         {
            this.FQueryShortcutCombine.Value = false;
            this.FOnQueryShortcutCombine(this,this.FShortcutsPosition,param2,this.FQueryShortcutCombine);
            _loc3_.visible = this.FQueryShortcutCombine.Value;
         }
         this.UpdateShortcuts();
      }
      
      public function HideAllShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         if(!this.FInitialization)
         {
            return;
         }
         if(!this.FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(this.FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUIShortcut.GetButtonByIndex(_loc1_);
            _loc3_.visible = false;
            _loc1_++;
         }
         this.UpdateShortcuts();
      }
   }
}

