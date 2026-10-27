package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Processors.Game.Lobby.Common.Map.MouseEventHander.TMouseEventHander;
   import flash.display.Sprite;
   
   public class TSceneSprite extends Sprite
   {
      
      protected var FSpriteClassID:int;
      
      protected var FMouseEventHander:TMouseEventHander;
      
      public function TSceneSprite()
      {
         super();
         mouseChildren = false;
      }
      
      public function OnMouseClick() : void
      {
         if(this.FMouseEventHander == null)
         {
            return;
         }
         this.FMouseEventHander.HandleOnMouseClick(this);
      }
      
      public function OnMouseOver() : void
      {
         if(this.FMouseEventHander == null)
         {
            return;
         }
         this.FMouseEventHander.HandleOnMouseOver(this);
      }
      
      public function OnMouseOut() : void
      {
         if(this.FMouseEventHander == null)
         {
            return;
         }
         this.FMouseEventHander.HandleOnMouseOut(this);
      }
      
      public function OnMouseMove() : void
      {
         if(this.FMouseEventHander == null)
         {
            return;
         }
         this.FMouseEventHander.HandleOnMouseMove(this);
      }
      
      public function get SpriteClassID() : int
      {
         return this.FSpriteClassID;
      }
      
      public function set SpriteClassID(param1:int) : void
      {
         this.FSpriteClassID = param1;
      }
      
      public function set MouseEventHander(param1:TMouseEventHander) : void
      {
         this.FMouseEventHander = param1;
         mouseEnabled = param1 != null;
      }
      
      public function UpdateData() : void
      {
      }
      
      public function UpdateView() : void
      {
      }
      
      public function Release() : void
      {
         this.FSpriteClassID = 0;
         this.FMouseEventHander = null;
         filters = null;
      }
   }
}

