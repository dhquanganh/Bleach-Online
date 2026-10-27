package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   
   public class TScriptActionCheckDie extends TScriptAction
   {
      
      protected static const TargetType_Me:int = 0;
      
      protected static const TargetType_Enemy:int = 1;
      
      protected var FTargetID:int;
      
      public function TScriptActionCheckDie()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         switch(this.FTargetID)
         {
            case TargetType_Me:
               if(FSoldierMe.LastHp <= 0 && !FOneAttrack.HaveNext)
               {
                  FSoldierMeView.RoleDie(FSoldierMe.Direction);
               }
               break;
            case TargetType_Enemy:
               if(FSoldierEnemy.LastHp <= 0 && !FOneAttrack.HaveNext)
               {
                  FSoldierEnemyView.RoleDie(FSoldierEnemy.Direction);
               }
         }
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FTargetID = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTargetID = 0;
      }
   }
}

