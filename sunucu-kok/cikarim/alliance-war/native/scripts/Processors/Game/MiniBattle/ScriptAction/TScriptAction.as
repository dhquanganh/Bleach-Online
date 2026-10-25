package Processors.Game.MiniBattle.ScriptAction
{
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapBattleRole;
   import Processors.Game.MiniBattle.Mode.TBattleSoldierInfor;
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   import Processors.Game.MiniBattle.Mode.TOneAttrack;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_SIGNAL;
   
   public class TScriptAction
   {
      
      protected var FSoldierMe:TBattleSoldierInfor;
      
      protected var FSoldierMeView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FSoldierEnemy:TBattleSoldierInfor;
      
      protected var FSoldierEnemyView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FOneAttrack:TOneAttrack;
      
      protected var FOnPlayAnimation:Function;
      
      protected var FOnPlayGoneWorld:Function;
      
      protected var FTriggerFrameTime:int;
      
      public function TScriptAction()
      {
         super();
      }
      
      protected function PlayAnimation(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         if(this.FOnPlayAnimation != null)
         {
            this.FOnPlayAnimation(param1,param2,param3,param4,param5,param6);
         }
      }
      
      protected function PlaySound(param1:int) : void
      {
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,param1,true);
      }
      
      protected function PlayHpEffect(param1:int, param2:int, param3:int, param4:Number, param5:Number, param6:int, param7:uint) : void
      {
         if(this.FOnPlayGoneWorld != null)
         {
            this.FOnPlayGoneWorld(param1,param2,param3.toString(),param4,param5,param6,param7);
         }
      }
      
      protected function PlayWorld(param1:int, param2:int, param3:String, param4:Number, param5:Number, param6:int, param7:uint) : void
      {
         if(this.FOnPlayGoneWorld != null)
         {
            this.FOnPlayGoneWorld(param1,param2,param3,param4,param5,param6,param7);
         }
      }
      
      public function set OneAttrack(param1:TOneAttrack) : void
      {
         this.FOneAttrack = param1;
      }
      
      public function get TriggerFrameTime() : int
      {
         return this.FTriggerFrameTime;
      }
      
      public function set TriggerFrameTime(param1:int) : void
      {
         this.FTriggerFrameTime = param1;
      }
      
      public function set OnPlayAnimation(param1:Function) : void
      {
         this.FOnPlayAnimation = param1;
      }
      
      public function set OnPlayGoneWorld(param1:Function) : void
      {
         this.FOnPlayGoneWorld = param1;
      }
      
      public function SetSoldierInfor(param1:TBattleSoldierInfor, param2:TSceneSpriteMoudleInMapBattleRole, param3:TBattleSoldierInfor, param4:TSceneSpriteMoudleInMapBattleRole, param5:TOneAttrack) : void
      {
         this.FSoldierMe = param1;
         this.FSoldierMeView = param2;
         this.FSoldierEnemy = param3;
         this.FSoldierEnemyView = param4;
         this.FOneAttrack = param5;
      }
      
      public function Trigger() : void
      {
      }
      
      public function Init(param1:TFileScriptAction) : void
      {
         this.FTriggerFrameTime = param1.Next();
      }
      
      public function Reset() : void
      {
         this.FSoldierMe = null;
         this.FSoldierMeView = null;
         this.FSoldierEnemy = null;
         this.FSoldierEnemyView = null;
         this.FOneAttrack = null;
         this.FTriggerFrameTime = 0;
      }
   }
}

