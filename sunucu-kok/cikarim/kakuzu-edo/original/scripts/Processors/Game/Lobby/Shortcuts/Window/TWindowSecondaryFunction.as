package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.TQueryBoolean;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.SLogicsCore;
   import Logics.Unlocks.TUnlock;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TWindowSecondaryFunction extends TWindowBase
   {
      
      public static const POSITION_SecondaryFunctionA:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionA;
      
      public static const POSITION_SecondaryFunctionB:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionB;
      
      public static const POSITION_SecondaryFunctionC:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionC;
      
      public static const POSITION_SecondaryFunctionD:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionD;
      
      public static const TYPE_SecondaryFunction_Daily:uint = CONST_SHORTCUTS.TYPE_SecondaryFunction_Daily;
      
      public static const TYPE_SecondaryFunction_Battle:uint = CONST_SHORTCUTS.TYPE_SecondaryFunction_Battle;
      
      public static const TYPE_SecondaryFunction_Novice:uint = CONST_SHORTCUTS.TYPE_SecondaryFunction_Novice;
      
      public static const TYPE_SecondaryFunction_BrLikeus:uint = CONST_SHORTCUTS.TYPE_SecondaryFunction_BrLikeus;
      
      protected var FWindowSecondaryFunctionPopupA:TWindowSecondaryFunctionPopupA;
      
      protected var FWindowSecondaryFunctionPopupB:TWindowSecondaryFunctionPopupB;
      
      protected var FWindowSecondaryFunctionPopupC:TWindowSecondaryFunctionPopupC;
      
      protected var FWindowSecondaryFunctionPopupD:TWindowSecondaryFunctionPopupD;
      
      protected var FSetDailySignIconFunction:Function;
      
      public function TWindowSecondaryFunction(param1:TUIComponent, param2:TUIComponent)
      {
         super(param1);
         this.FWindowSecondaryFunctionPopupA = new TWindowSecondaryFunctionPopupA(param2);
         this.FWindowSecondaryFunctionPopupA.ShortcutOnClick = this.ShortcutsOnClick;
         this.FWindowSecondaryFunctionPopupA.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowSecondaryFunctionPopupA.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowSecondaryFunctionPopupA.alpha = 0;
         this.FWindowSecondaryFunctionPopupA.Visible = false;
         this.FWindowSecondaryFunctionPopupB = new TWindowSecondaryFunctionPopupB(param2);
         this.FWindowSecondaryFunctionPopupB.ShortcutOnClick = this.ShortcutsOnClick;
         this.FWindowSecondaryFunctionPopupB.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowSecondaryFunctionPopupB.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowSecondaryFunctionPopupB.alpha = 0;
         this.FWindowSecondaryFunctionPopupB.Visible = false;
         this.FWindowSecondaryFunctionPopupC = new TWindowSecondaryFunctionPopupC(param2);
         this.FWindowSecondaryFunctionPopupC.ShortcutOnClick = this.ShortcutsOnClick;
         this.FWindowSecondaryFunctionPopupC.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowSecondaryFunctionPopupC.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowSecondaryFunctionPopupC.alpha = 0;
         this.FWindowSecondaryFunctionPopupC.Visible = false;
         this.FWindowSecondaryFunctionPopupD = new TWindowSecondaryFunctionPopupD(param2);
         this.FWindowSecondaryFunctionPopupD.ShortcutOnClick = this.ShortcutsOnClick;
         this.FWindowSecondaryFunctionPopupD.OnQueryShortcutUnlock = this.ShortcutOnQueryUnlock;
         this.FWindowSecondaryFunctionPopupD.OnUnlockResponse = this.ProcessorOnUnlockResponse;
         this.FWindowSecondaryFunctionPopupD.alpha = 0;
         this.FWindowSecondaryFunctionPopupD.Visible = false;
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunction;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctions;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FClassNameBmpLeft = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Left;
         FClassNameBmpMiddle = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Middle;
         FClassNameBmpRight = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Right;
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Btns;
         super.Resources_UIDispatch();
      }
      
      override protected function Resources_UILocations() : void
      {
         this.FWindowSecondaryFunctionPopupA.addEventListener(MouseEvent.ROLL_OVER,this.WindowPopupOnOver);
         this.FWindowSecondaryFunctionPopupA.addEventListener(MouseEvent.ROLL_OUT,this.WindowPopupOnOut);
         this.FWindowSecondaryFunctionPopupB.addEventListener(MouseEvent.ROLL_OVER,this.WindowPopupOnOver);
         this.FWindowSecondaryFunctionPopupB.addEventListener(MouseEvent.ROLL_OUT,this.WindowPopupOnOut);
         this.FWindowSecondaryFunctionPopupC.addEventListener(MouseEvent.ROLL_OVER,this.WindowPopupOnOver);
         this.FWindowSecondaryFunctionPopupC.addEventListener(MouseEvent.ROLL_OUT,this.WindowPopupOnOut);
         this.FWindowSecondaryFunctionPopupD.addEventListener(MouseEvent.ROLL_OVER,this.WindowPopupOnOver);
         this.FWindowSecondaryFunctionPopupD.addEventListener(MouseEvent.ROLL_OUT,this.WindowPopupOnOut);
         this.addEventListener(MouseEvent.ROLL_OUT,this.WindowCurSecondaryFunctionOnOut);
         FUIShortcut.OnOver = this.ShortcutsOnOver;
         this.FWindowSecondaryFunctionPopupA.CallbackHide = this.CallbackHide;
         this.FWindowSecondaryFunctionPopupB.CallbackHide = this.CallbackHide;
         this.FWindowSecondaryFunctionPopupC.CallbackHide = this.CallbackHide;
         this.FWindowSecondaryFunctionPopupD.CallbackHide = this.CallbackHide;
         this.OnQueryShortcutCombine = this.ProcessorOnQueryShortcutCombine;
         super.Resources_UILocations();
      }
      
      override protected function ComponentsAlign() : void
      {
         if(!this.Visible)
         {
            return;
         }
         PopupAdaptive(this.FWindowSecondaryFunctionPopupA,TYPE_SecondaryFunction_Daily);
         PopupAdaptive(this.FWindowSecondaryFunctionPopupB,TYPE_SecondaryFunction_Battle);
         PopupAdaptive(this.FWindowSecondaryFunctionPopupC,TYPE_SecondaryFunction_Novice);
         PopupAdaptive(this.FWindowSecondaryFunctionPopupD,TYPE_SecondaryFunction_BrLikeus);
      }
      
      override protected function ProcessorChangeShortcutIcon(param1:uint) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:SimpleButton = null;
         var _loc4_:int = 0;
         _loc4_ = FShortcutsTypes.indexOf(param1);
         if(param1 == CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus)
         {
            _loc2_ = FUIShortcut.GetButtonByIndex(_loc4_);
            _loc3_ = TUtilityReflection.CreateSimpleButtonByDisplayObject(CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_LikeUs_B) as SimpleButton;
            FUIShortcut.SwapComponent(param1,_loc2_,_loc3_);
         }
      }
      
      protected function ShortcutsOnOver(param1:Object, param2:int) : void
      {
         switch(param2)
         {
            case TYPE_SecondaryFunction_Daily:
               this.FWindowSecondaryFunctionPopupA.Show();
               this.FWindowSecondaryFunctionPopupB.Hide();
               this.FWindowSecondaryFunctionPopupC.Hide();
               this.FWindowSecondaryFunctionPopupD.Hide();
               break;
            case TYPE_SecondaryFunction_Battle:
               this.FWindowSecondaryFunctionPopupB.Show();
               this.FWindowSecondaryFunctionPopupA.Hide();
               this.FWindowSecondaryFunctionPopupC.Hide();
               this.FWindowSecondaryFunctionPopupD.Hide();
               break;
            case TYPE_SecondaryFunction_Novice:
               this.FWindowSecondaryFunctionPopupC.Show();
               this.FWindowSecondaryFunctionPopupA.Hide();
               this.FWindowSecondaryFunctionPopupB.Hide();
               this.FWindowSecondaryFunctionPopupD.Hide();
               break;
            case TYPE_SecondaryFunction_BrLikeus:
               this.FWindowSecondaryFunctionPopupD.Show();
               this.FWindowSecondaryFunctionPopupA.Hide();
               this.FWindowSecondaryFunctionPopupB.Hide();
               this.FWindowSecondaryFunctionPopupC.Hide();
               break;
            default:
               this.FWindowSecondaryFunctionPopupA.Hide();
               this.FWindowSecondaryFunctionPopupB.Hide();
               this.FWindowSecondaryFunctionPopupC.Hide();
               this.FWindowSecondaryFunctionPopupD.Hide();
         }
         if(param2 == TYPE_SecondaryFunction_Daily || param2 == TYPE_SecondaryFunction_Battle || param2 == TYPE_SecondaryFunction_Novice || param2 == TYPE_SecondaryFunction_BrLikeus)
         {
            SLogicsCore.SinalPostFreshGuide(FShortcutsPosition * 1000000 + param2);
         }
      }
      
      protected function WindowPopupOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TWindowPopupBase = null;
         _loc2_ = param1.currentTarget as TWindowPopupBase;
         _loc2_.Show();
      }
      
      protected function WindowPopupOnOut(param1:MouseEvent) : void
      {
         var _loc2_:TWindowPopupBase = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as TWindowPopupBase;
         _loc2_.Hide();
      }
      
      protected function WindowCurSecondaryFunctionOnOut(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         if(this.FWindowSecondaryFunctionPopupA.Visible)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FWindowSecondaryFunctionPopupA);
            FBounds.Assign(_loc3_);
            FBounds.Width = this.FWindowSecondaryFunctionPopupA.ShortcutWidth;
            FBounds.Height = this.FWindowSecondaryFunctionPopupA.Height + 20;
            FBounds.Y -= 20;
            _loc2_ = TUtilityCartisian.BoundsContainsCoordinate(FBounds,FUICore.MouseCoordinate);
            if(!_loc2_)
            {
               this.FWindowSecondaryFunctionPopupA.Hide();
            }
         }
         if(this.FWindowSecondaryFunctionPopupB.Visible)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FWindowSecondaryFunctionPopupB);
            FBounds.Assign(_loc3_);
            FBounds.Width = this.FWindowSecondaryFunctionPopupB.ShortcutWidth;
            FBounds.Height = this.FWindowSecondaryFunctionPopupB.Height + 20;
            FBounds.Y -= 20;
            _loc2_ = TUtilityCartisian.BoundsContainsCoordinate(FBounds,FUICore.MouseCoordinate);
            if(!_loc2_)
            {
               this.FWindowSecondaryFunctionPopupB.Hide();
            }
         }
         if(this.FWindowSecondaryFunctionPopupC.Visible)
         {
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FWindowSecondaryFunctionPopupC);
            FBounds.Assign(_loc3_);
            FBounds.Width = this.FWindowSecondaryFunctionPopupC.ShortcutWidth;
            FBounds.Height = this.FWindowSecondaryFunctionPopupC.Height + 20;
            FBounds.Y -= 20;
            _loc2_ = TUtilityCartisian.BoundsContainsCoordinate(FBounds,FUICore.MouseCoordinate);
            if(!_loc2_)
            {
               this.FWindowSecondaryFunctionPopupC.Hide();
            }
         }
      }
      
      protected function CallbackHide(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1 is TWindowSecondaryFunctionPopupA)
         {
            _loc2_ = int(TYPE_SecondaryFunction_Daily);
         }
         else if(param1 is TWindowSecondaryFunctionPopupB)
         {
            _loc2_ = int(TYPE_SecondaryFunction_Battle);
         }
         else if(param1 is TWindowSecondaryFunctionPopupC)
         {
            _loc2_ = int(TYPE_SecondaryFunction_Novice);
         }
         else if(param1 is TWindowSecondaryFunctionPopupD)
         {
            _loc2_ = int(TYPE_SecondaryFunction_BrLikeus);
         }
         SLogicsCore.SinalPostFreshGuide(-(FShortcutsPosition * 1000000 + _loc2_));
      }
      
      protected function ProcessorOnQueryShortcutCombine(param1:Object, param2:int, param3:int, param4:TQueryBoolean) : void
      {
         var _loc5_:TWindowPopupBase = null;
         switch(param3)
         {
            case TYPE_SecondaryFunction_Daily:
               _loc5_ = this.FWindowSecondaryFunctionPopupA;
               break;
            case TYPE_SecondaryFunction_Battle:
               _loc5_ = this.FWindowSecondaryFunctionPopupB;
               break;
            case TYPE_SecondaryFunction_Novice:
               _loc5_ = this.FWindowSecondaryFunctionPopupC;
               break;
            case TYPE_SecondaryFunction_BrLikeus:
               _loc5_ = this.FWindowSecondaryFunctionPopupD;
         }
         if(_loc5_ != null)
         {
            param4.Value = _loc5_.GetShortcutsState();
         }
         else
         {
            param4.Value = true;
         }
      }
      
      override protected function ShortcutsOnClick(param1:Object, param2:int, param3:int = 0, param4:Vector.<uint> = null) : void
      {
         var _loc5_:TWindowPopupBase = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         _loc6_ = int(FShortcutsPosition);
         if(param1 is TWindowPopupBase)
         {
            _loc5_ = param1 as TWindowPopupBase;
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            _loc5_.Hide();
            _loc6_ = int(_loc5_.ShortcutsPosition);
            _loc7_ = _loc5_.ShortcutsTypes;
         }
         super.ShortcutsOnClick(param1,param2,_loc6_,_loc7_);
      }
      
      protected function ShortcutOnQueryUnlock(param1:Object, param2:uint, param3:uint, param4:TQueryBoolean) : void
      {
         if(FOnQueryShortcutUnlock != null)
         {
            FOnQueryShortcutUnlock(param1,param2,param3,param4);
         }
      }
      
      protected function ProcessorOnUnlockResponse(param1:Object, param2:TBounds, param3:Object) : void
      {
         if(FOnUnlockResponse != null)
         {
            FOnUnlockResponse(param1,param2,param3);
         }
      }
      
      override public function Perform_UIDispatch() : void
      {
         super.Perform_UIDispatch();
         this.FWindowSecondaryFunctionPopupA.Perform_UIDispatch();
         this.FWindowSecondaryFunctionPopupB.Perform_UIDispatch();
         this.FWindowSecondaryFunctionPopupC.Perform_UIDispatch();
         this.FWindowSecondaryFunctionPopupD.Perform_UIDispatch();
      }
      
      override public function Update() : void
      {
         this.ComponentsAlign();
         this.FWindowSecondaryFunctionPopupA.Update();
         this.FWindowSecondaryFunctionPopupB.Update();
         this.FWindowSecondaryFunctionPopupC.Update();
         this.FWindowSecondaryFunctionPopupD.Update();
         super.Update();
      }
      
      override public function UpdateShortcutsState(param1:Object) : void
      {
         this.FWindowSecondaryFunctionPopupA.UpdateShortcutsState(param1);
         this.FWindowSecondaryFunctionPopupB.UpdateShortcutsState(param1);
         this.FWindowSecondaryFunctionPopupC.UpdateShortcutsState(param1);
         this.FWindowSecondaryFunctionPopupD.UpdateShortcutsState(param1);
         super.UpdateShortcutsState(param1);
      }
      
      override public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:SimpleButton = null;
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         var _loc7_:TWindowPopupBase = null;
         if(param1.Position == ShortcutsPosition && (param1.Index != TYPE_SecondaryFunction_Daily && param1.Index != TYPE_SecondaryFunction_Battle && param1.Index != TYPE_SecondaryFunction_Novice && param1.Index != TYPE_SecondaryFunction_BrLikeus))
         {
            super.UnlockingNotification(param1);
            return;
         }
         switch(param1.Position)
         {
            case this.FWindowSecondaryFunctionPopupA.ShortcutsPosition:
               _loc2_ = int(TYPE_SecondaryFunction_Daily);
               _loc7_ = this.FWindowSecondaryFunctionPopupA;
               break;
            case this.FWindowSecondaryFunctionPopupB.ShortcutsPosition:
               _loc2_ = int(TYPE_SecondaryFunction_Battle);
               _loc7_ = this.FWindowSecondaryFunctionPopupB;
               break;
            case this.FWindowSecondaryFunctionPopupC.ShortcutsPosition:
               _loc2_ = int(TYPE_SecondaryFunction_Novice);
               _loc7_ = this.FWindowSecondaryFunctionPopupC;
               break;
            case this.FWindowSecondaryFunctionPopupD.ShortcutsPosition:
               _loc2_ = int(TYPE_SecondaryFunction_BrLikeus);
               _loc7_ = this.FWindowSecondaryFunctionPopupD;
         }
         _loc7_.UnlockingNotification(param1);
         if(FOnUnlockResponse != null)
         {
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc2_);
            _loc6_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc4_);
            _loc5_ = new TBounds();
            _loc5_.Assign(_loc6_);
            _loc5_.Width = _loc4_.width;
            _loc5_.Height = _loc4_.height;
            FOnUnlockResponse(this,_loc5_,_loc4_);
         }
         _loc3_ = _loc7_.GetEffectState();
         if(this.FSetDailySignIconFunction != null)
         {
            if(CONST_SHORTCUTS.POSITION_SecondaryFunctionA == param1.Position && CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign == param1.Index)
            {
               this.FSetDailySignIconFunction(_loc3_);
            }
         }
         if(_loc3_)
         {
            this.ShowEffectNotification(FShortcutsPosition,_loc2_,_loc3_);
         }
         this.UpdateShortcutsState(null);
      }
      
      override public function ShowEffectNotification(param1:uint, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         _loc4_ = -1;
         switch(param1)
         {
            case FShortcutsPosition:
               ProcessorShortcutShowEffect(param2,param3);
               break;
            case POSITION_SecondaryFunctionA:
               this.FWindowSecondaryFunctionPopupA.ShowEffectNotification(param1,param2,param3);
               _loc4_ = int(TYPE_SecondaryFunction_Daily);
               _loc5_ = this.FWindowSecondaryFunctionPopupA.GetEffectState();
               break;
            case POSITION_SecondaryFunctionB:
               this.FWindowSecondaryFunctionPopupB.ShowEffectNotification(param1,param2,param3);
               _loc4_ = int(TYPE_SecondaryFunction_Battle);
               _loc5_ = this.FWindowSecondaryFunctionPopupB.GetEffectState();
               break;
            case POSITION_SecondaryFunctionC:
               this.FWindowSecondaryFunctionPopupC.ShowEffectNotification(param1,param2,param3);
               _loc4_ = int(TYPE_SecondaryFunction_Novice);
               _loc5_ = this.FWindowSecondaryFunctionPopupC.GetEffectState();
               break;
            case POSITION_SecondaryFunctionD:
               this.FWindowSecondaryFunctionPopupD.ShowEffectNotification(param1,param2,param3);
               _loc4_ = int(TYPE_SecondaryFunction_BrLikeus);
               _loc5_ = this.FWindowSecondaryFunctionPopupD.GetEffectState();
         }
         if(_loc4_ >= 0)
         {
            ProcessorShortcutShowEffect(_loc4_,_loc5_);
            if(CONST_SHORTCUTS.POSITION_SecondaryFunctionA == param1 && CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign == param2)
            {
               if(this.FSetDailySignIconFunction != null)
               {
                  this.FSetDailySignIconFunction(_loc5_);
               }
            }
         }
      }
      
      public function ChangeShortcutIcon(param1:uint, param2:uint) : void
      {
         switch(param1)
         {
            case FShortcutsPosition:
               this.ProcessorChangeShortcutIcon(param2);
               break;
            case POSITION_SecondaryFunctionA:
            case POSITION_SecondaryFunctionB:
            case POSITION_SecondaryFunctionC:
            case POSITION_SecondaryFunctionD:
         }
      }
      
      override public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case CONST_SHORTCUTS.POSITION_SecondaryFunctionA:
               this.FWindowSecondaryFunctionPopupA.SetupShortcutsShow(param1,param2);
               break;
            case CONST_SHORTCUTS.POSITION_SecondaryFunctionB:
               this.FWindowSecondaryFunctionPopupB.SetupShortcutsShow(param1,param2);
               break;
            case CONST_SHORTCUTS.POSITION_SecondaryFunctionC:
               this.FWindowSecondaryFunctionPopupC.SetupShortcutsShow(param1,param2);
               break;
            case CONST_SHORTCUTS.POSITION_SecondaryFunctionD:
               this.FWindowSecondaryFunctionPopupD.SetupShortcutsShow(param1,param2);
               break;
            case CONST_SHORTCUTS.POSITION_SecondaryFunction:
               super.SetupShortcutsShow(param1,param2);
         }
      }
      
      override public function HideAllShortcuts() : void
      {
         this.FWindowSecondaryFunctionPopupA.HideAllShortcuts();
         this.FWindowSecondaryFunctionPopupB.HideAllShortcuts();
         this.FWindowSecondaryFunctionPopupC.HideAllShortcuts();
         this.FWindowSecondaryFunctionPopupD.HideAllShortcuts();
         super.HideAllShortcuts();
      }
      
      public function set SetDailySignIconFunction(param1:Function) : void
      {
         this.FSetDailySignIconFunction = param1;
      }
      
      public function get SetDailySignIconFunction() : Function
      {
         return this.FSetDailySignIconFunction;
      }
   }
}

