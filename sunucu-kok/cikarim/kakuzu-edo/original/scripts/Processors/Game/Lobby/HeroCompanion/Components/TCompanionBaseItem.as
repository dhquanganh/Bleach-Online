package Processors.Game.Lobby.HeroCompanion.Components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TCompanionBaseItem
   {
      
      protected var FMainUI:Sprite;
      
      protected var FItemOnOver:Function;
      
      protected var FItemOnOut:Function;
      
      protected var FItemOnDown:Function;
      
      protected var FItemOnMove:Function;
      
      public function TCompanionBaseItem(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FMainUI.mouseChildren = false;
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OVER,this.OnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMove);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.OnOut);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_DOWN,this.OnDown);
      }
      
      protected function OnDown(param1:MouseEvent) : void
      {
         if(this.FItemOnDown != null)
         {
            this.FItemOnDown(this,param1);
         }
      }
      
      protected function OnOut(param1:MouseEvent) : void
      {
         if(this.FItemOnOut != null)
         {
            this.FItemOnOut(this,param1);
         }
      }
      
      protected function OnOver(param1:MouseEvent) : void
      {
         if(this.FItemOnOver != null)
         {
            this.FItemOnOver(this,param1);
         }
      }
      
      protected function OnMove(param1:MouseEvent) : void
      {
         if(this.FItemOnMove != null)
         {
            this.FItemOnMove(this,param1);
         }
      }
      
      public function get ItemOnOver() : Function
      {
         return this.FItemOnOver;
      }
      
      public function set ItemOnOver(param1:Function) : void
      {
         this.FItemOnOver = param1;
      }
      
      public function get ItemOnOut() : Function
      {
         return this.FItemOnOut;
      }
      
      public function set ItemOnOut(param1:Function) : void
      {
         this.FItemOnOut = param1;
      }
      
      public function get ItemOnDown() : Function
      {
         return this.FItemOnDown;
      }
      
      public function set ItemOnDown(param1:Function) : void
      {
         this.FItemOnDown = param1;
      }
      
      public function get ItemOnMove() : Function
      {
         return this.FItemOnMove;
      }
      
      public function set ItemOnMove(param1:Function) : void
      {
         this.FItemOnMove = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.FMainUI.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
      }
      
      public function get Substrate() : Sprite
      {
         return this.FMainUI;
      }
   }
}

