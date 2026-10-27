package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.Sprite;
   
   public class TDecorationBlood extends TDecoration
   {
      
      protected var FHPBar:Sprite;
      
      protected var FMainUI:Sprite;
      
      public function TDecorationBlood()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         if(this.FMainUI == null)
         {
            this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MiniHP_Bar") as Sprite;
            this.FHPBar = this.FMainUI["mc_hp"];
            addChild(this.FMainUI);
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function get YOffset() : int
      {
         return 0;
      }
      
      public function ChangeBlood(param1:Number) : void
      {
         this.LoadResource();
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         this.FHPBar.scaleX = param1;
      }
   }
}

