package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.MovieClip;
   
   public class TSceneSpriteMoudleInMapGuidePoint extends TSceneSpriteMoudleInMapGuide
   {
      
      public function TSceneSpriteMoudleInMapGuidePoint()
      {
         super();
      }
      
      override protected function CreateGuideComponent() : void
      {
         FGuideComponent = TUtilityReflection.CreateDisplayObjectInstance("GuidePoint") as MovieClip;
         addChild(FGuideComponent);
      }
      
      override protected function RunComplete() : void
      {
         super.RunComplete();
      }
      
      override public function StartShow() : void
      {
         super.StartShow();
      }
   }
}

