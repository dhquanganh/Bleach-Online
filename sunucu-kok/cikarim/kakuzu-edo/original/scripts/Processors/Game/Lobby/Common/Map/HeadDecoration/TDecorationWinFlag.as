package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.MovieClip;
   
   public class TDecorationWinFlag extends TDecoration
   {
      
      protected var FUI:MovieClip;
      
      public function TDecorationWinFlag()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         if(this.FUI == null)
         {
            this.FUI = TUtilityReflection.CreateDisplayObjectInstance("MiniBattleWinFlag") as MovieClip;
            this.FUI.x = -this.FUI.width / 2;
            addChild(this.FUI);
         }
      }
      
      override public function Release() : void
      {
      }
      
      protected function Update_Perform() : void
      {
         this.LoadResource();
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function get YOffset() : int
      {
         return 20;
      }
      
      override public function Update(param1:Object) : void
      {
         this.Update_Perform();
      }
      
      public function Show() : void
      {
         this.LoadResource();
         this.FUI.gotoAndPlay(1);
      }
      
      public function Hide() : void
      {
         this.LoadResource();
         this.FUI.stop();
      }
   }
}

