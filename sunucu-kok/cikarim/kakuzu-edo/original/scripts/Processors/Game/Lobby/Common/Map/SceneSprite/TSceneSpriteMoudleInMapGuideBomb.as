package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.MovieClip;
   
   public class TSceneSpriteMoudleInMapGuideBomb extends TSceneSpriteMoudleInMapGuide
   {
      
      protected var FShadow:MovieClip;
      
      public function TSceneSpriteMoudleInMapGuideBomb()
      {
         super();
      }
      
      override protected function CreateGuideComponent() : void
      {
         FGuideComponent = TUtilityReflection.CreateDisplayObjectInstance("GuideBomb") as MovieClip;
         this.FShadow = TUtilityReflection.CreateDisplayObjectInstance("GuideShadow") as MovieClip;
         addChild(this.FShadow);
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
      
      override public function ShowEnd() : void
      {
         super.ShowEnd();
         this.FShadow.visible = false;
         FGuideComponent.visible = false;
      }
      
      override public function Release() : void
      {
         super.Release();
         this.FShadow.visible = true;
         FGuideComponent.visible = true;
      }
   }
}

