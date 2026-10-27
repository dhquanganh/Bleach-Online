package Processors.Game.Lobby.MainScene
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.MainScene.Role.IRole;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_MainScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class TLayerLittleScript extends TProcessorLobbyWindow
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      protected static const FMin_MouseY:int = 390;
      
      protected static const FContinueMoveMinDistance:int = 20 * 20;
      
      protected var FDartBitmap:Bitmap;
      
      protected var FDartAnimationSequence:TAnimationSequence;
      
      protected var FDartShowing:Boolean;
      
      protected var FTargetMapX:Number;
      
      protected var FTargetMapY:Number;
      
      protected var FDartMapX:int;
      
      protected var FDartMapY:int;
      
      protected var FTickReference:int;
      
      protected var FContinueChangeRolePosition:Boolean;
      
      protected var FStartMouseDownTick:int;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FBounds:TBounds;
      
      protected var FLongClickMove:Boolean;
      
      protected var FMainRole:IRole;
      
      protected var FChangeRolePositionByMouse:Function;
      
      public function TLayerLittleScript(param1:TUIComponent)
      {
         super(param1);
         this.FDartBitmap = new Bitmap();
         this.addChild(this.FDartBitmap);
         this.FCoordinate = new TCoordinate();
         this.FBounds = new TBounds();
         this.FLongClickMove = true;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.TEXTUREID_RECOUSE_MouseEff);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TTexture = null;
         _loc1_ = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.TEXTUREID_RECOUSE_MouseEff);
         if(_loc1_ != null)
         {
            this.FDartAnimationSequence = _loc1_.GetAnimationSequenceByIndex(0);
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      public function UpdateDarkAnimation() : void
      {
         if(this.FDartAnimationSequence != null)
         {
            if(this.FDartShowing)
            {
               this.FDartBitmap.bitmapData = this.FDartAnimationSequence.GetAnimationFrameByTick(this.FTickReference).Surface;
               this.FTickReference += SIZE_FrameRatePerSecond;
               if(this.FTickReference > this.FDartAnimationSequence.Duration)
               {
                  this.FDartShowing = false;
                  this.FTickReference = 0;
               }
               this.FCoordinate.X = this.FDartMapX - SLogicsCore.ScreenMapX;
               this.FCoordinate.Y = this.FDartMapY;
               this.FDartAnimationSequence.Evaluate(this.FCoordinate,this.FBounds);
               this.FDartBitmap.x = this.FBounds.X;
               this.FDartBitmap.y = this.FBounds.Y;
            }
            else
            {
               this.FDartBitmap.bitmapData = null;
            }
         }
      }
      
      protected function CountTargetPosition() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(mouseY < FMin_MouseY)
         {
            _loc1_ = SLogicsCore.ScreenMapX + mouseX - this.FMainRole.MapX;
            _loc2_ = mouseY - this.FMainRole.MapY;
            _loc4_ = _loc2_ / _loc1_;
            this.FTargetMapX = this.FMainRole.MapX + (FMin_MouseY - this.FMainRole.MapY) / _loc4_;
            this.FTargetMapY = FMin_MouseY;
         }
         else
         {
            this.FTargetMapX = SLogicsCore.ScreenMapX + mouseX;
            this.FTargetMapY = mouseY;
         }
      }
      
      protected function UpdataContinueChangePosition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FContinueChangeRolePosition && this.FMainRole != null)
         {
            this.FBounds.X = 0;
            this.FBounds.Y = 0;
            this.FBounds.Width = CONST_COMMON.STAGE_Width;
            this.FBounds.Height = CONST_COMMON.STAGE_Height;
            if(!TUtilityCartisian.BoundsContainsCoordinate(this.FBounds,FUICore.MouseCoordinate))
            {
               this.FContinueChangeRolePosition = false;
            }
            else if(STimingCore.TickCount - this.FStartMouseDownTick > 200)
            {
               _loc1_ = SLogicsCore.ScreenMapX + mouseX - this.FMainRole.MapX;
               _loc2_ = mouseY - this.FMainRole.MapY;
               if(_loc1_ * _loc1_ + _loc2_ * _loc2_ > FContinueMoveMinDistance)
               {
                  this.CountTargetPosition();
                  this.FMainRole.SetupTargetPosition(this.FTargetMapX,this.FTargetMapY,CONST_MainScene.RoleMoveSpeed);
                  this.ChangeMainRolePosition();
               }
            }
         }
      }
      
      override protected function LogicsPerform() : void
      {
         this.UpdateDarkAnimation();
         this.UpdataContinueChangePosition();
      }
      
      protected function ChangeMainRolePosition() : void
      {
         if(this.FChangeRolePositionByMouse != null)
         {
            this.FChangeRolePositionByMouse();
         }
      }
      
      protected function OnMouseClick(param1:MouseEvent = null) : void
      {
         if(this.FMainRole != null)
         {
            this.CountTargetPosition();
            this.FDartShowing = true;
            this.FTickReference = 0;
            this.FDartMapX = this.FTargetMapX;
            this.FDartMapY = this.FTargetMapY;
            this.FMainRole.SetupTargetPosition(this.FTargetMapX,this.FTargetMapY,CONST_MainScene.RoleMoveSpeed);
            this.ChangeMainRolePosition();
         }
      }
      
      protected function OnMouseDown(param1:MouseEvent) : void
      {
         if(!this.FLongClickMove)
         {
            return;
         }
         this.FContinueChangeRolePosition = true;
         this.FDartShowing = false;
         this.FStartMouseDownTick = STimingCore.TickCount;
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         this.FContinueChangeRolePosition = false;
      }
      
      protected function OnMouseUp(param1:MouseEvent) : void
      {
         if(this.FContinueChangeRolePosition)
         {
            this.FContinueChangeRolePosition = false;
         }
      }
      
      public function set MainRole(param1:IRole) : void
      {
         this.FMainRole = param1;
      }
      
      public function set MouseEventObject(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,0,true);
      }
      
      public function set ChangeRolePositionByMouse(param1:Function) : void
      {
         this.FChangeRolePositionByMouse = param1;
      }
      
      public function get TargetMapX() : Number
      {
         return this.FTargetMapX;
      }
      
      public function get TargetMapY() : Number
      {
         return this.FTargetMapY;
      }
      
      public function get LongClickMove() : Boolean
      {
         return this.FLongClickMove;
      }
      
      public function set LongClickMove(param1:Boolean) : void
      {
         this.FLongClickMove = param1;
      }
   }
}

