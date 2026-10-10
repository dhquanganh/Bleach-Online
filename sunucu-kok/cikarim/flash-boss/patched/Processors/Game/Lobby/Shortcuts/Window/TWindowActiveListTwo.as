package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.display.SimpleButton;
   
   public class TWindowActiveListTwo extends TWindowActiveListBase
   {
      
      public static const TYPE_ActiveList_ReceivePacks:uint = CONST_SHORTCUTS.TYPE_ActiveList_ReceivePacks;
      
      public static const TYPE_ActiveListSecondary_LevelGiftBag:uint = CONST_SHORTCUTS.TYPE_ActiveListSecondary_LevelGiftBag;
      
      protected var FWindowActiveListPopup:TWindowActiveListPopup;
      
      protected var FOnNotificationLevelGiftBagState:Function;
      
      public function TWindowActiveListTwo(param1:TUIComponent, param2:TUIComponent)
      {
         super(param1,param2);
         FActivityModes = SLogicsCore.ActivityModes;
         this.FWindowActiveListPopup = new TWindowActiveListPopup(param2);
         this.FWindowActiveListPopup.ShortcutOnClick = ShortcutsOnClick;
         this.FWindowActiveListPopup.Visible = false;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_ACTIVELISTSTWO;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_ActiveListTwo_Btns;
         super.Resources_UIDispatch();
      }
      
      override protected function Resources_UILocations() : void
      {
         this.FWindowActiveListPopup.addEventListener(MouseEvent.ROLL_OVER,this.WindowPopupOnOver);
         this.FWindowActiveListPopup.addEventListener(MouseEvent.ROLL_OUT,this.WindowPopupOnOut);
         this.addEventListener(MouseEvent.ROLL_OUT,this.WindowActiveListOnOut);
         FUIShortcut.OnOver = this.ShortcutsOnOver;
         super.Resources_UILocations();
      }
      
      override protected function ProcessorOpenStatusNotification() : void
      {
         super.ProcessorOpenStatusNotification();
         this.FWindowActiveListPopup.OpenStatusNotification();
      }
      
      override protected function ComponentsAlign() : void
      {
         if(!this.Visible)
         {
            return;
         }
         PopupAdaptive(this.FWindowActiveListPopup,FShortcutsTypes.indexOf(TYPE_ActiveList_ReceivePacks));
      }
      
      override protected function ShowEffectNotification_ActiveListSecondary(param1:uint, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         this.FWindowActiveListPopup.ShowEffectNotification(param1,param2,param3);
         _loc4_ = this.FWindowActiveListPopup.GetEffectState();
         ProcessorShortcutShowEffect(0,_loc4_);
         if(param2 == TYPE_ActiveListSecondary_LevelGiftBag)
         {
            if(this.FOnNotificationLevelGiftBagState != null)
            {
               this.FOnNotificationLevelGiftBagState(this,param3);
            }
         }
      }
      
      protected function ShortcutsOnOver(param1:Object, param2:int) : void
      {
         if(param2 == FShortcutsTypes.indexOf(TYPE_ActiveList_ReceivePacks))
         {
            this.FWindowActiveListPopup.Show();
            return;
         }
      }
      
      protected function WindowPopupOnOver(param1:MouseEvent) : void
      {
         this.FWindowActiveListPopup.Show();
      }
      
      protected function WindowPopupOnOut(param1:MouseEvent) : void
      {
         this.FWindowActiveListPopup.Hide();
      }
      
      protected function WindowActiveListOnOut(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FWindowActiveListPopup);
         FBounds.Assign(_loc3_);
         FBounds.Width = this.FWindowActiveListPopup.ShortcutWidth;
         FBounds.Height = this.FWindowActiveListPopup.Height + 20;
         FBounds.Y -= 20;
         _loc2_ = TUtilityCartisian.BoundsContainsCoordinate(FBounds,FUICore.MouseCoordinate);
         if(!_loc2_)
         {
            this.FWindowActiveListPopup.Hide();
         }
      }
      
      public function get OnNotificationLevelGiftBagState() : Function
      {
         return this.FOnNotificationLevelGiftBagState;
      }
      
      public function set OnNotificationLevelGiftBagState(param1:Function) : void
      {
         this.FOnNotificationLevelGiftBagState = param1;
      }
      
      override public function Perform_UIDispatch() : void
      {
         super.Perform_UIDispatch();
         this.FWindowActiveListPopup.Perform_UIDispatch();
      }
      
      override public function Update() : void
      {
         this.FWindowActiveListPopup.Update();
         super.Update();
      }

      public function IllusionAnchor() : Point
      {
         if(!this.Visible || !FUIShortcut.IsInitialization)return null;
         var gift:SimpleButton=FUIShortcut.GetButtonByIndex(FShortcutsTypes.indexOf(TYPE_ActiveList_ReceivePacks));
         if(gift==null||!gift.visible)return null;
         return gift.localToGlobal(new Point(-72,0));
      }
   }
}

