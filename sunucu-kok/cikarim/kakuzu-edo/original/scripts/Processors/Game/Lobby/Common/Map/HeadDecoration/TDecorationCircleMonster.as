package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.MovieClip;
   
   public class TDecorationCircleMonster extends TDecoration
   {
      
      protected static const CIRCLE_COLOR_RED:int = 1;
      
      protected static const CIRCLE_COLOR_BLACK:int = 2;
      
      protected var FMonster:TSceneSpriteMoudleInMapMonster;
      
      protected var FMC_Circle:MovieClip;
      
      protected var FCurrentFrame:MovieClip;
      
      public function TDecorationCircleMonster()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      protected function LoadResource() : void
      {
         if(this.FMC_Circle == null)
         {
            this.FMC_Circle = TUtilityReflection.CreateDisplayObjectInstance("MonsterCircle") as MovieClip;
            addChild(this.FMC_Circle);
         }
      }
      
      override public function Release() : void
      {
         if(this.FCurrentFrame != null)
         {
            this.FCurrentFrame.stop();
            this.FCurrentFrame = null;
         }
         this.FMC_Circle.visible = false;
      }
      
      protected function Update_Perform() : void
      {
         this.LoadResource();
         this.Release();
         if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_Latest) != 0)
         {
            this.FMC_Circle.gotoAndStop(CIRCLE_COLOR_RED);
            this.FCurrentFrame = this.FMC_Circle["Circle"];
         }
         else if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_MainQuest) != 0)
         {
            this.FMC_Circle.gotoAndStop(CIRCLE_COLOR_BLACK);
            this.FCurrentFrame = this.FMC_Circle["Circle"];
         }
         else if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_BranchQuest) != 0)
         {
            this.FMC_Circle.gotoAndStop(CIRCLE_COLOR_BLACK);
            this.FCurrentFrame = this.FMC_Circle["Circle"];
         }
         if(this.FCurrentFrame != null)
         {
            this.FCurrentFrame.play();
            (this.FCurrentFrame.getChildAt(1) as MovieClip).play();
            this.FMC_Circle.visible = true;
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_BOTTOM;
      }
      
      override public function Update(param1:Object) : void
      {
         this.FMonster = param1 as TSceneSpriteMoudleInMapMonster;
         this.Update_Perform();
      }
   }
}

