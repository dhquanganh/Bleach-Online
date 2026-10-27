package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.Sprite;
   
   public class TDecorationPointHP extends TDecoration
   {
      
      protected var FHPBar:Sprite;
      
      protected var FMainUI:Sprite;
      
      public function TDecorationPointHP()
      {
         super();
         this.LoadResource();
      }
      
      protected function LoadResource() : void
      {
         if(this.FMainUI == null)
         {
            this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("PointHP_Bar") as Sprite;
            if(this.FMainUI != null)
            {
               this.FHPBar = this.FMainUI["mc_hp"];
               addChild(this.FMainUI);
               this.x -= this.FMainUI.width / 2;
            }
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_BOTTOM;
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

