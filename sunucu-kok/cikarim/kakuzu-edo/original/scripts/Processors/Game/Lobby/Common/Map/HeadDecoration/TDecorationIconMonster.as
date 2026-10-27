package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Registries.TRegistryRoutine;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.MovieClip;
   
   public class TDecorationIconMonster extends TDecoration
   {
      
      protected static const KNIFE_COLOR_RED:int = 1;
      
      protected static const KNIFE_COLOR_BLACK:int = 2;
      
      protected var FMonster:TSceneSpriteMoudleInMapMonster;
      
      protected var FRegistryRoutine:TRegistryRoutine;
      
      protected var FHeadIcon:MovieClip;
      
      protected var FCurrentFrame:MovieClip;
      
      public function TDecorationIconMonster()
      {
         super();
         this.FRegistryRoutine = new TRegistryRoutine();
      }
      
      protected function LoadResource() : void
      {
         if(this.FHeadIcon == null)
         {
            this.FHeadIcon = TUtilityReflection.CreateDisplayObjectInstance("MonsterKnife") as MovieClip;
            addChild(this.FHeadIcon);
         }
      }
      
      protected function Update_Perform() : void
      {
         this.LoadResource();
         this.Release();
         if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_Latest) != 0)
         {
            this.FCurrentFrame = this.FHeadIcon["Knife"];
         }
         if(this.FCurrentFrame != null)
         {
            this.FCurrentFrame.play();
            (this.FCurrentFrame.getChildAt(1) as MovieClip).play();
            this.FHeadIcon.visible = true;
         }
      }
      
      override public function Release() : void
      {
         if(this.FCurrentFrame != null)
         {
            this.FCurrentFrame.stop();
            (this.FCurrentFrame.getChildAt(1) as MovieClip).stop();
         }
         this.FCurrentFrame = null;
         this.FHeadIcon.visible = false;
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         this.FMonster = param1 as TSceneSpriteMoudleInMapMonster;
         this.Update_Perform();
      }
   }
}

