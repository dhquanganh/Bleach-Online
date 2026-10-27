package Processors.Game.Lobby.Common.Map.MapWindowContorl
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.UI.TUICore;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.DrawMap.TDrawMapTwo;
   import Resources.Constants.CONST_CURSOR;
   import flash.events.MouseEvent;
   
   public class TMapWindowControlMouse extends TMapWindowControl
   {
      
      protected static const WEAKEN_RAT:Number = 0.8;
      
      public static const MOUSECURSOR_AUTO:String = CONST_CURSOR.MOUSECURSOR_AUTO;
      
      public static const MOUSECURSOR_HAND:String = CONST_CURSOR.MOUSECURSOR_HAND;
      
      protected var FMouseRelationComponent:TUIComponent;
      
      protected var FUICore:TUICore;
      
      protected var FUpdating:Boolean;
      
      protected var FMouseCoordinate:TCoordinate;
      
      protected var FSpeedX:Number;
      
      protected var FSpeedY:Number;
      
      protected var FBounds:TBounds;
      
      public function TMapWindowControlMouse(param1:TUIComponent, param2:TUICore, param3:TMapParameter, param4:TDrawMapTwo)
      {
         super(param3,param4);
         this.FMouseRelationComponent = param1;
         this.FUICore = param2;
         this.Init();
      }
      
      protected function Init() : void
      {
         this.FMouseCoordinate = new TCoordinate();
         this.FBounds = new TBounds();
         this.FMouseRelationComponent.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         this.FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         this.FSpeedX = 0;
         this.FSpeedY = 0;
      }
      
      protected function InitScreen() : void
      {
         FMapDrawer.SetScreenShowArea(FMapParameter.ScreenBounds);
      }
      
      protected function MoveScreen() : void
      {
         this.FBounds.X = this.FMouseCoordinate.X - this.FUICore.mouseX + FMapParameter.ScreenBounds.X;
         this.FBounds.Y = this.FMouseCoordinate.Y - this.FUICore.mouseY + FMapParameter.ScreenBounds.Y;
         this.FBounds.Width = FMapParameter.ScreenBounds.Width;
         this.FBounds.Height = FMapParameter.ScreenBounds.Height;
         ReLocationCoordinate(this.FBounds);
         FMapParameter.ScreenBounds.Assign(this.FBounds);
         FMapDrawer.SetScreenShowArea(this.FBounds);
         this.FMouseCoordinate.X = this.FUICore.mouseX;
         this.FMouseCoordinate.Y = this.FUICore.mouseY;
      }
      
      protected function MoveBySpeed() : void
      {
         if(this.FSpeedX * this.FSpeedX < 0.01 && this.FSpeedY * this.FSpeedY < 0.01)
         {
            return;
         }
         this.FBounds.X = FMapParameter.ScreenBounds.X + this.FSpeedX;
         this.FBounds.Y = FMapParameter.ScreenBounds.Y + this.FSpeedY;
         this.FBounds.Width = FMapParameter.ScreenBounds.Width;
         this.FBounds.Height = FMapParameter.ScreenBounds.Height;
         ReLocationCoordinate(this.FBounds);
         FMapParameter.ScreenBounds.Assign(this.FBounds);
         FMapDrawer.SetScreenShowArea(this.FBounds);
         this.FSpeedX *= WEAKEN_RAT;
         this.FSpeedY *= WEAKEN_RAT;
      }
      
      protected function OnMouseDown(param1:MouseEvent) : void
      {
         this.FUpdating = true;
         this.FMouseCoordinate.X = this.FUICore.mouseX;
         this.FMouseCoordinate.Y = this.FUICore.mouseY;
         this.FUICore.MouseSetCursor(MOUSECURSOR_HAND);
      }
      
      protected function OnMouseUp(param1:MouseEvent) : void
      {
         if(this.FUpdating)
         {
            this.FSpeedX = (this.FMouseCoordinate.X - this.FUICore.mouseX) * 2;
            this.FSpeedY = (this.FMouseCoordinate.Y - this.FUICore.mouseY) * 2;
         }
         this.FUpdating = false;
         this.FUICore.MouseSetCursor(MOUSECURSOR_AUTO);
      }
      
      override public function Update() : void
      {
         super.Update();
         if(FModify)
         {
            this.InitScreen();
            FModify = false;
            return;
         }
         if(this.FUpdating)
         {
            this.MoveScreen();
         }
         if(FMapParameter.MapData != null)
         {
            this.MoveBySpeed();
         }
      }
      
      override public function Release() : void
      {
         this.FSpeedX = 0;
         this.FSpeedY = 0;
         FMapParameter.ScreenBounds.X = 0;
         FMapParameter.ScreenBounds.Y = 0;
      }
   }
}

