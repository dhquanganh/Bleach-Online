package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   
   public class TScriptActionChangeRoleState extends TScriptAction
   {
      
      protected var SoldierAnimatSequnce_BattleStand:int = 0;
      
      protected var SoldierAnimatSequnce_NormalAttrack:int = 1;
      
      protected var SoldierAnimatSequnce_SkillAttrack:int = 2;
      
      protected var FSoldierAnimationSequnceIndex:int;
      
      public function TScriptActionChangeRoleState()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         switch(this.FSoldierAnimationSequnceIndex)
         {
            case this.SoldierAnimatSequnce_BattleStand:
               FSoldierMeView.BattleStand(FSoldierMe.Direction);
               break;
            case this.SoldierAnimatSequnce_NormalAttrack:
               FSoldierMeView.NormalAttrack(FSoldierMe.Direction);
               break;
            case this.SoldierAnimatSequnce_SkillAttrack:
               FSoldierMeView.SkillAttrack(FSoldierMe.Direction);
         }
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FSoldierAnimationSequnceIndex = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FSoldierAnimationSequnceIndex = 0;
      }
   }
}

