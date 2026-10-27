package Processors.Game.Lobby.Common.Map.SpriteMountPoint
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_CURSOR;
   import flash.events.MouseEvent;
   
   public class TMonsterMountPoint extends TSpriteMountPoint
   {
      
      public function TMonsterMountPoint(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function get Cursor() : uint
      {
         return CONST_CURSOR.CURSORID_MONSTER;
      }
      
      override public function get CursorDisplayObject() : TUIComponent
      {
         return this;
      }
      
      override protected function OnMouseOver(param1:MouseEvent) : void
      {
         FUICore.MouseCaptureSet(this);
         super.OnMouseOver(param1);
      }
      
      override protected function OnMouseOut(param1:MouseEvent) : void
      {
         FUICore.MouseCaptureRelease(this);
         super.OnMouseOut(param1);
      }
   }
}

