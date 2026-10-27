package Processors.Game.Lobby.Common.Map.SpriteMountPoint
{
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSprite;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TSpriteMountPoint extends TUIComponent
   {
      
      protected var FChilds:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FBitmapData:BitmapData;
      
      protected var FBitmap:Bitmap;
      
      protected var FRectangleTool:Rectangle;
      
      protected var FPointTool:Point;
      
      public function TSpriteMountPoint(param1:TUIComponent)
      {
         super(param1);
         this.FChilds = new Vector.<TSceneSpriteMoudleInMap>();
         mouseEnabled = false;
         this.AddMouseEvent();
      }
      
      protected function AddMouseEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.OnMouseClick,true);
         addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
      }
      
      protected function OnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         _loc2_.OnMouseClick();
         param1.stopImmediatePropagation();
      }
      
      protected function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         _loc2_.OnMouseMove();
      }
      
      protected function OnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         _loc2_.OnMouseOver();
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         _loc2_.OnMouseOut();
      }
      
      public function AddSpriteBatch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            this.AddSprite(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function AddSprite(param1:TSceneSpriteMoudleInMap) : void
      {
         var _loc2_:int = 0;
         _loc2_ = numChildren;
         addChild(param1);
         param1.visible = false;
         if(_loc2_ < numChildren)
         {
            this.FChilds.push(param1);
         }
      }
      
      public function Relocation(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(STimingCore.TickCount);
         _loc4_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = param1[_loc2_];
            if(!_loc3_.visible)
            {
               _loc3_.visible = true;
            }
            if(_loc2_ != _loc3_.Layer)
            {
               setChildIndex(_loc3_,_loc2_);
               _loc3_.Layer = _loc2_;
            }
            _loc3_.UpdateTick = _loc5_;
            _loc2_++;
         }
         _loc4_ = int(this.FChilds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.FChilds[_loc2_];
            if(_loc3_.UpdateTick != _loc5_ && _loc3_.visible)
            {
               _loc3_.visible = false;
            }
            _loc3_.Layer = -1;
            _loc2_++;
         }
      }
      
      protected function DrawChild(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudleInMap = null;
         this.FRectangleTool.width = this.FBitmapData.width;
         this.FRectangleTool.height = this.FBitmapData.height;
         this.FBitmapData.fillRect(this.FRectangleTool,16777215);
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            if(_loc4_.RoleBitMap.bitmapData != null)
            {
               this.FRectangleTool.width = _loc4_.RoleBitMap.width;
               this.FRectangleTool.height = _loc4_.RoleBitMap.height;
               this.FPointTool.x = _loc4_.x;
               this.FPointTool.y = _loc4_.y;
               this.FBitmapData.lock();
               this.FBitmapData.copyPixels(_loc4_.RoleBitMap.bitmapData,this.FRectangleTool,this.FPointTool,null,null,true);
               this.FBitmapData.unlock();
            }
            _loc2_++;
         }
      }
   }
}

