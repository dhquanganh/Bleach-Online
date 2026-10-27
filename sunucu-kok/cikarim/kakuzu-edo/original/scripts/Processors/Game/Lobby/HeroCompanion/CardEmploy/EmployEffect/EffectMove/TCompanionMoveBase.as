package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.EffectMove
{
   import flash.display.DisplayObject;
   
   public class TCompanionMoveBase
   {
      
      protected var FStartTick:int;
      
      protected var FDisplay:DisplayObject;
      
      protected var FOnSpecialShowEnd:Function;
      
      public function TCompanionMoveBase()
      {
         super();
      }
      
      public function get Display() : DisplayObject
      {
         return this.FDisplay;
      }
      
      public function set Display(param1:DisplayObject) : void
      {
         this.FDisplay = param1;
      }
      
      public function set OnSpecialShowEnd(param1:Function) : void
      {
         this.FOnSpecialShowEnd = param1;
      }
      
      public function get MoveOver() : Boolean
      {
         return false;
      }
      
      public function StartToAction() : void
      {
      }
      
      public function Action() : void
      {
      }
      
      public function SetMove(... rest) : void
      {
         this.FDisplay.alpha = 0;
      }
   }
}

