package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.MovieClip;
   
   public class TDecorationQuestFlag extends TDecoration
   {
      
      protected var FREAMINDEX_MAINQUEST:int = 1;
      
      protected var FREAMINDEX_BREACHQUEST:int = 2;
      
      protected var FUI:MovieClip;
      
      protected var FCurrentUI:MovieClip;
      
      protected var FMonster:TSceneSpriteMoudleInMapMonster;
      
      public function TDecorationQuestFlag()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         var _loc1_:int = 0;
         if(this.FUI == null)
         {
            this.FUI = TUtilityReflection.CreateDisplayObjectInstance("QuestFlag") as MovieClip;
            addChild(this.FUI);
         }
      }
      
      override public function Release() : void
      {
         var _loc1_:int = 0;
         this.FUI.visible = false;
         if(this.FCurrentUI == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.FCurrentUI["Arrow" + (_loc1_ + 1)].stop();
            _loc1_++;
         }
         this.FCurrentUI = null;
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         this.LoadResource();
         this.Release();
         if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_MainQuest) != 0)
         {
            this.FUI.gotoAndStop(this.FREAMINDEX_MAINQUEST);
            this.FCurrentUI = this.FUI["MainQuest"];
            this.FUI.visible = true;
         }
         else if((this.FMonster.MonsterState & CONST_WORLDMAP.MonsterState_BranchQuest) != 0)
         {
            this.FUI.gotoAndStop(this.FREAMINDEX_BREACHQUEST);
            this.FCurrentUI = this.FUI["SubQuest"];
            this.FUI.visible = true;
         }
         if(this.FCurrentUI == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.FCurrentUI["Arrow" + (_loc1_ + 1)].play();
            _loc1_++;
         }
         this.FUI.visible = true;
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function get YOffset() : int
      {
         return 15;
      }
      
      override public function Update(param1:Object) : void
      {
         this.FMonster = param1 as TSceneSpriteMoudleInMapMonster;
         this.Update_Perform();
      }
   }
}

