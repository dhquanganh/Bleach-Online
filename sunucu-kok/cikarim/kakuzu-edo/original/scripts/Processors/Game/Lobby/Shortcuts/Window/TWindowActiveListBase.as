package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.HDActivityMode.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TWindowActiveListBase extends TWindowBase
   {
      
      protected static const POSITION_ActiveListSecondary:uint = CONST_SHORTCUTS.POSITION_ActiveListSecondary;
      
      protected static const COORDINATE_ActivityBtn:Vector.<int> = Vector.<int>([1,5]);
      
      protected var FActivityModes:TActivityModes;
      
      public function TWindowActiveListBase(param1:TUIComponent, param2:TUIComponent)
      {
         super(param1);
         this.FActivityModes = SLogicsCore.ActivityModes;
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_ActiveList;
         FBtnCoordinates = COORDINATE_ActivityBtn;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FClassNameBmpLeft = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Left;
         FClassNameBmpMiddle = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Middle;
         FClassNameBmpRight = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Bmp_Right;
         super.Resources_UIDispatch();
      }
      
      protected function ProcessorOpenStatusNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:SimpleButton = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
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
            _loc4_ = FUIShortcut.GetButtonByIndex(_loc1_);
            _loc4_.visible = false;
            _loc1_++;
         }
         _loc2_ = this.FActivityModes.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FActivityModes.GetActivityAtomsByIndex(_loc1_).MainType;
            _loc6_ = FShortcutsTypes.indexOf(_loc5_);
            if(_loc6_ != -1)
            {
               _loc4_ = FUIShortcut.GetButtonByIndex(_loc6_);
               _loc4_.visible = true;
            }
            _loc1_++;
         }
         UpdateShortcuts();
      }
      
      protected function UpdateShortcutEffect() : void
      {
         if(FUIShortcut.IsInitialization)
         {
            FUIShortcut.UpdataEffects();
         }
      }
      
      protected function ShowEffectNotification_ActiveListSecondary(param1:uint, param2:uint, param3:Boolean) : void
      {
      }
      
      override protected function ShortcutsOnClick(param1:Object, param2:int, param3:int = 0, param4:Vector.<uint> = null) : void
      {
         var _loc5_:TWindowPopupBase = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         _loc6_ = int(FShortcutsPosition);
         _loc7_ = FShortcutsTypes;
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
      
      override public function Update() : void
      {
         ComponentsAlign();
         this.UpdateShortcutEffect();
         super.Update();
      }
      
      public function OpenStatusNotification() : void
      {
         this.ProcessorOpenStatusNotification();
      }
      
      override public function ShowEffectNotification(param1:uint, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case FShortcutsPosition:
               if(FShortcutsTypes.indexOf(param2) != -1)
               {
                  ProcessorShortcutShowEffect(param2,param3);
               }
               break;
            case POSITION_ActiveListSecondary:
               this.ShowEffectNotification_ActiveListSecondary(param1,param2,param3);
         }
      }
   }
}

