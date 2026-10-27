package Processors.Game.Lobby.MainSceneTwo
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.MainScene.Role.IRole;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class TDark extends TProcessorLobbyWindow
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      protected static const FMin_MouseY:int = 390;
      
      protected static const FContinueMoveMinDistance:int = 20 * 20;
      
      protected var FDartBitmap:Bitmap;
      
      protected var FDartAnimationSequence:TAnimationSequence;
      
      protected var FDartShowing:Boolean;
      
      protected var FDartMapX:int;
      
      protected var FDartMapY:int;
      
      protected var FTickReference:int;
      
      protected var FRelationComponent:TUIComponent;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FBounds:TBounds;
      
      protected var FMainRole:IRole;
      
      protected var FCallBack:Function;
      
      protected var FMapParameter:TMapParameter;
      
      public function TDark(param1:TUIComponent, param2:TUIComponent, param3:TMapParameter)
      {
         super(param1);
         this.MouseEventObject = param2;
         this.FMapParameter = param3;
         this.FDartBitmap = new Bitmap();
         this.addChild(this.FDartBitmap);
         this.FCoordinate = new TCoordinate();
         this.FBounds = new TBounds();
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
         var _loc1_:BitmapData = null;
         if(this.FDartAnimationSequence != null)
         {
            if(this.FDartShowing)
            {
               _loc1_ = this.FDartAnimationSequence.GetAnimationFrameByTick(this.FTickReference).Surface;
               if(this.FDartBitmap.bitmapData != _loc1_)
               {
                  this.FDartBitmap.bitmapData = _loc1_;
               }
               this.FTickReference += SIZE_FrameRatePerSecond;
               if(this.FTickReference > this.FDartAnimationSequence.Duration)
               {
                  this.FDartShowing = false;
                  this.FTickReference = 0;
               }
               this.FCoordinate.X = this.FDartMapX - this.FMapParameter.ScreenBounds.X;
               this.FCoordinate.Y = this.FDartMapY - this.FMapParameter.ScreenBounds.Y;
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
      
      override protected function LogicsPerform() : void
      {
         this.UpdateDarkAnimation();
      }
      
      protected function OnMouseClick(param1:MouseEvent = null) : void
      {
         if(this.FMapParameter.MapData == null)
         {
            return;
         }
         this.FDartShowing = true;
         this.FTickReference = 0;
         if(this.FCallBack != null)
         {
            this.FCallBack(mouseX,mouseY);
         }
         this.FDartMapX = mouseX + this.FMapParameter.ScreenBounds.X;
         this.FDartMapY = mouseY + this.FMapParameter.ScreenBounds.Y;
         param1.stopImmediatePropagation();
      }
      
      protected function OnMouseDown(param1:MouseEvent) : void
      {
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
      }
      
      protected function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      public function set MainRole(param1:IRole) : void
      {
         this.FMainRole = param1;
      }
      
      public function set MouseEventObject(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.OnMouseClick);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,0,true);
      }
      
      public function set CallBack(param1:Function) : void
      {
         this.FCallBack = param1;
      }
   }
}

