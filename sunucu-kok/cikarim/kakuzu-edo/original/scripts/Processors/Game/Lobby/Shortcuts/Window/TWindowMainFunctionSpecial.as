package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Unlocks.*;
   import Processors.Game.Common.Effects.Display.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.filters.*;
   
   public class TWindowMainFunctionSpecial extends TWindowBase
   {
      
      protected static const COORDINATE_Shortcut_X:int = 570;
      
      protected static const COORDINATE_Shortcut_Y:int = 11;
      
      protected static const COORDINATE_MainFunctionBtn:Vector.<int> = Vector.<int>([10,-35]);
      
      protected var FEffectsBaseGlow:Vector.<TEffectBaseGlow>;
      
      protected var FGlowFilter:GlowFilter;
      
      protected var FWidth:int;
      
      protected var FOnMainFunctionSpecial:Function;
      
      public function TWindowMainFunctionSpecial(param1:TUIComponent)
      {
         super(param1);
         this.FEffectsBaseGlow = new Vector.<TEffectBaseGlow>();
         this.FGlowFilter = new GlowFilter(8453888,0.6,3,3,8,10,false,false);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_MainFunction_Special;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_FUNCTIONS_Special;
         FBtnCoordinates = COORDINATE_MainFunctionBtn;
         this.FWidth = 0;
         this.mouseEnabled = false;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         FClassNameBmpLeft = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_Bmp_Left;
         FClassNameBmpMiddle = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_Bmp_Middle;
         FClassNameBmpRight = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_Bmp_Right;
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_Btns;
         super.Resources_UIDispatch();
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_HomeCaption) as Sprite;
         FUIShortcut.addChild(_loc1_);
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.x = 25;
         _loc1_.y = 10;
      }
      
      override protected function Resources_UILocations() : void
      {
         FUIShortcut.OnMove = this.BtnOnMove;
         FUIShortcut.OnOut = this.BtnOnOut;
         FUIShortcut.OnDown = this.BtnOnDown;
         FUIShortcut.OnUp = this.BtnOnUp;
         FUIShortcut.X = COORDINATE_Shortcut_X;
         FUIShortcut.Y = COORDINATE_Shortcut_Y;
         super.Resources_UILocations();
      }
      
      override protected function UpdateShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:SimpleButton = null;
         var _loc5_:TEffectBaseGlow = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FUIShortcut.GetBmp_Middle(_loc1_);
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc1_);
            _loc3_.visible = _loc4_.visible;
            _loc1_++;
         }
         FUIShortcut.UpdateComponentsLocation();
         FUIShortcut.X = 729 - 110 - FUIShortcut.Bounds.Width;
         FUIShortcut.Y = 60;
      }
      
      protected function UpdateEffectsGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffectBaseGlow = null;
         _loc2_ = int(this.FEffectsBaseGlow.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEffectsBaseGlow[_loc1_];
            _loc3_.Run();
            _loc1_++;
         }
      }
      
      protected function UpdateBounds() : void
      {
         if(!FInitialization)
         {
            return;
         }
         if(FUIShortcut.Bounds.Width > 0)
         {
            this.FWidth = FUIShortcut.Bounds.Width;
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      override protected function ProcessorShortcutShowEffect(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = FUIShortcut.GetIsEffectByIndex(param1);
         if(_loc3_ != param2)
         {
            FUIShortcut.SetIsEffectByIndex(param2,param1);
         }
         if(param2)
         {
            this.OpenButtonEffect(param1);
         }
         else
         {
            this.TerminationButtonEffect(param1);
         }
      }
      
      protected function OpenButtonEffect(param1:int) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:TEffectBaseGlow = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = FUIShortcut.GetButtonByIndex(param1);
         if(_loc2_.filters != null && _loc2_.filters.length == 0)
         {
            _loc3_ = new TEffectBaseGlow();
            _loc3_.SetParameters(_loc2_,15911245,1);
            _loc3_.Run();
            this.FEffectsBaseGlow.push(_loc3_);
         }
      }
      
      protected function TerminationButtonEffect(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         var _loc5_:TEffectBaseGlow = null;
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc4_ = FUIShortcut.GetButtonByIndex(param1);
         _loc3_ = int(this.FEffectsBaseGlow.length);
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            _loc5_ = this.FEffectsBaseGlow[_loc2_];
            if(_loc5_ == null)
            {
               break;
            }
            if(_loc4_ == _loc5_.Source)
            {
               _loc5_.Stop();
               this.FEffectsBaseGlow.splice(_loc2_,1);
               _loc5_.Dispose();
               _loc5_ = null;
               break;
            }
            _loc2_--;
         }
      }
      
      override protected function ShortcutsOnClick(param1:Object, param2:int, param3:int = 0, param4:Vector.<uint> = null) : void
      {
         var _loc5_:SimpleButton = null;
         var _loc6_:Vector.<uint> = null;
         _loc5_ = FUIShortcut.GetButtonByIndex(param2);
         if(!_loc5_.enabled)
         {
            return;
         }
         _loc6_ = FShortcutsTypes;
         super.ShortcutsOnClick(param1,param2,FShortcutsPosition,_loc6_);
      }
      
      protected function BtnOnMove(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = FUIShortcut.GetButtonByIndex(param2);
         if(_loc3_.filters.length == 0)
         {
            _loc3_.filters = [this.FGlowFilter];
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = FUIShortcut.GetButtonByIndex(param2);
         if(_loc3_.enabled)
         {
            _loc3_.filters = [];
         }
      }
      
      protected function BtnOnDown(param1:Object, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:SimpleButton = null;
         _loc4_ = param1 as SimpleButton;
         if(!_loc4_.enabled)
         {
            return;
         }
         if(_loc4_.filters.length > 0)
         {
            _loc4_.filters = [];
         }
         _loc3_ = FUIShortcut.GetIsEffectByIndex(param2);
         if(_loc3_)
         {
            this.ProcessorShortcutShowEffect(param2,false);
         }
      }
      
      protected function BtnOnUp(param1:Object, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         _loc3_ = param1 as SimpleButton;
         if(!_loc3_.enabled)
         {
            return;
         }
         if(_loc3_.filters.length == 0)
         {
            _loc3_.filters = [this.FGlowFilter];
         }
      }
      
      override public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      override public function Update() : void
      {
         this.UpdateEffectsGlow();
      }
      
      override public function UpdateShortcutsState(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         _loc3_ = int(FShortcutsTypes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc2_);
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc2_);
            if(FOnQueryShortcutUnlock != null)
            {
               FQueryShortcut.Value = false;
               FOnQueryShortcutUnlock(this,FShortcutsPosition,_loc2_,FQueryShortcut);
            }
            _loc4_.enabled = FQueryShortcut.Value;
            if(_loc4_.enabled)
            {
               _loc4_.filters = [];
            }
            else
            {
               _loc4_.filters = [TUtilityFilter.gBlackFilters];
            }
            _loc2_++;
         }
         this.UpdateShortcuts();
      }
      
      override public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc2_ = FUIShortcut.GetButtonByIndex(param1.Index);
         _loc2_.alpha = 0;
         _loc2_.visible = true;
         _loc2_.enabled = true;
         _loc2_.filters = [];
         this.UpdateShortcuts();
         if(FOnUnlockResponse != null)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc2_);
            _loc4_ = new TBounds();
            _loc4_.Assign(_loc3_);
            _loc4_.Width = _loc2_.width;
            _loc4_.Height = _loc2_.height;
            FOnUnlockResponse(this,_loc4_,_loc2_);
         }
         this.ProcessorShortcutShowEffect(param1.Index,true);
      }
      
      override public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         if(!FInitialization)
         {
            return;
         }
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc3_ = FUIShortcut.GetButtonByIndex(param2);
         if(FOnQueryShortcutUnlock != null)
         {
            FQueryShortcut.Value = false;
            FOnQueryShortcutUnlock(this,FShortcutsPosition,param2,FQueryShortcut);
         }
         _loc3_.enabled = FQueryShortcut.Value;
         if(_loc3_.enabled)
         {
            _loc3_.filters = [];
         }
         else
         {
            _loc3_.filters = [TUtilityFilter.gBlackFilters];
         }
         this.UpdateShortcuts();
      }
      
      override public function HideAllShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         if(!FInitialization)
         {
            return;
         }
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(FUIShortcut.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FUIShortcut.GetButtonByIndex(_loc1_);
            _loc3_.enabled = false;
            _loc3_.filters = [TUtilityFilter.gBlackFilters];
            _loc1_++;
         }
         this.UpdateShortcuts();
      }
   }
}

