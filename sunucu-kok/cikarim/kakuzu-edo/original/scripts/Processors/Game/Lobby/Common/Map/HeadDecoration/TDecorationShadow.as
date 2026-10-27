package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.MovieClip;
   
   public class TDecorationShadow extends TDecoration
   {
      
      protected var FUI:MovieClip;
      
      public function TDecorationShadow()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         if(this.FUI == null)
         {
            this.FUI = TUtilityReflection.CreateDisplayObjectInstance("BootShadow") as MovieClip;
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
         return POSITION_BOTTOM;
      }
      
      override public function Update(param1:Object) : void
      {
         this.Update_Perform();
      }
   }
}

