package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_MainScene;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TUIRole extends TUI implements IRole
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected static const FFilters:Array = [TUtilityFilter.highLightFilters];
      
      protected var FCoordinate:TCoordinate;
      
      protected var FBounds:TBounds;
      
      protected var FTextFiledNameFormat:TextFormat;
      
      protected var FTextFiledName:TextField;
      
      protected var FMapX:Number;
      
      protected var FMapY:Number;
      
      protected var FDirection:int;
      
      protected var FPivotXStore:int;
      
      protected var FOnMouseOver:Function;
      
      protected var FOnMouseOut:Function;
      
      public function TUIRole(param1:TUIComponent)
      {
         super(param1);
         this.FCoordinate = new TCoordinate();
         this.FBounds = new TBounds();
         this.FTextFiledNameFormat = new TextFormat();
         this.FTextFiledName = new TextField();
         this.FTextFiledName.autoSize = TextFieldAutoSize.CENTER;
         this.FTextFiledName.width = 177;
         this.FTextFiledName.filters = NameFilters;
         this.FTextFiledName.selectable = false;
         addChild(this.FTextFiledName);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.HandleOnMouseOver);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.HandleOnMouseMove);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.HandleOnMouseOut);
         this.addEventListener(MouseEvent.CLICK,this.HandleOnMouseClick);
         this.FMapX = 0;
         this.FMapY = 0;
      }
      
      protected function UpdateRolePosition() : void
      {
         if(FCurrentSequence != null)
         {
            this.FCoordinate.X = this.FMapX;
            this.FCoordinate.Y = this.FMapY;
            FCurrentSequence.Evaluate(this.FCoordinate,this.FBounds);
            x = this.FBounds.X - SLogicsCore.ScreenMapX;
            y = this.FBounds.Y;
            if(this.FDirection == CONST_MainScene.DIRECTION_Left)
            {
               x += FCurrentFrame.Pivot.X << 1;
            }
         }
      }
      
      protected function UpdateDisplayObjectPosition(param1:DisplayObject) : void
      {
         if(FCurrentFrame != null)
         {
            if(FCurrentFrame.Pivot.X == this.FPivotXStore)
            {
               return;
            }
            if(this.FDirection == CONST_MainScene.DIRECTION_RIGHT)
            {
               param1.x = FCurrentFrame.Pivot.X - param1.width / 2;
            }
            else
            {
               param1.x = -FCurrentFrame.Pivot.X - param1.width / 2;
            }
         }
      }
      
      protected function HandleOnMouseOver(param1:MouseEvent) : void
      {
      }
      
      protected function HandleOnMouseMove(param1:MouseEvent) : void
      {
      }
      
      protected function HandleOnMouseOut(param1:MouseEvent) : void
      {
      }
      
      protected function HandleOnMouseClick(param1:MouseEvent) : void
      {
      }
      
      public function get ScreenX() : Number
      {
         return this.FMapX - SLogicsCore.ScreenMapX;
      }
      
      public function get ScreenY() : Number
      {
         return this.FMapY;
      }
      
      public function get MapX() : Number
      {
         return this.FMapX;
      }
      
      public function set MapX(param1:Number) : void
      {
         this.FMapX = param1;
      }
      
      public function get MapY() : Number
      {
         return this.FMapY;
      }
      
      public function set MapY(param1:Number) : void
      {
         this.FMapY = param1;
      }
      
      public function get Direction() : int
      {
         return this.FDirection;
      }
      
      public function UpdateData() : void
      {
      }
      
      public function UpdateView() : void
      {
         super.Update();
         this.UpdateRolePosition();
      }
      
      public function ChangeDirection(param1:int) : void
      {
         this.FDirection = param1;
         ChangeScaleX(this.FDirection);
         this.UpdateRolePosition();
      }
      
      public function SetupTargetPosition(param1:Number, param2:Number, param3:Number) : void
      {
      }
      
      override public function Release() : void
      {
         super.Release();
      }
   }
}

