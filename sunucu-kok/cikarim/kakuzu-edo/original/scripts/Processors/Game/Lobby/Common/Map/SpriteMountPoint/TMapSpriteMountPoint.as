package Processors.Game.Lobby.Common.Map.SpriteMountPoint
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSprite;
   import Resources.Constants.CONST_CURSOR;
   import Resources.Constants.CONST_MAP;
   import flash.events.MouseEvent;
   
   public class TMapSpriteMountPoint extends TSpriteMountPoint
   {
      
      public function TMapSpriteMountPoint(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function get Cursor() : uint
      {
         return CONST_CURSOR.CURSORID_NPC;
      }
      
      override public function get CursorDisplayObject() : TUIComponent
      {
         return this;
      }
      
      override protected function OnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         if(_loc2_.SpriteClassID == CONST_MAP.SPRITE_SYSTEMID_NPC)
         {
            FUICore.MouseCaptureSet(this);
         }
         super.OnMouseOver(param1);
      }
      
      override protected function OnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:TSceneSprite = null;
         _loc2_ = param1.target as TSceneSprite;
         if(_loc2_.SpriteClassID == CONST_MAP.SPRITE_SYSTEMID_NPC)
         {
            FUICore.MouseCaptureRelease(this);
         }
         super.OnMouseOut(param1);
      }
   }
}

