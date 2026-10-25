package Resources.Constants
{
   import Processors.Game.MiniBattle.ScriptAction.*;
   
   public class CONST_MINIBATTLE
   {
      
      public static const RESOURCESID_MiniBattle:uint = 2164260865;
      
      public static const RESOURCESID_BattleLoading:uint = 2;
      
      public static const MiniBattleType_PVE:int = CONST_BATTLE.BattleType_TeamBattlePVE;
      
      public static const MiniBattleType_PVP:int = CONST_BATTLE.BattleType_TeamBattlePVP;
      
      public static const LeftSoldierScreenX:Vector.<int> = Vector.<int>([300,200,300]);
      
      public static const LeftSoldierScreenY:Vector.<int> = Vector.<int>([400,500,600]);
      
      public static const RightSoldierScreenX:Vector.<int> = Vector.<int>([800,900,800]);
      
      public static const RightSoldierScreenY:Vector.<int> = Vector.<int>([400,500,600]);
      
      public static const SoldierType_Hero:int = 0;
      
      public static const SoldierType_Monster:int = 1;
      
      public static const CampType_Friend:int = 0;
      
      public static const CampType_Enemy:int = 1;
      
      public static const BattleResult_Win:int = 0;
      
      public static const BattleResult_Lose:int = 1;
      
      public static const SoldierPosition_Inside:int = 0;
      
      public static const SoldierPosition_Middle:int = 1;
      
      public static const SoldierPosition_OutSide:int = 2;
      
      public static const SoldierPositionArr:Vector.<int> = Vector.<int>([SoldierPosition_Inside,SoldierPosition_Middle,SoldierPosition_OutSide]);
      
      public static const ScripActionClass:Vector.<Class> = Vector.<Class>([TScriptActionPlaySound,TScriptActionJmpToCorrdinate,TScriptActionJmpToTarget,TScriptActionPlayAnimation,TScriptActionCheckHP,TScriptActionCheckDie,TScriptActionChangeRoleState]);
      
      public static const SoldierAnimatSequnce_BattleStand:int = 0;
      
      public static const SoldierAnimatSequnce_NormalAttrack:int = 1;
      
      public static const SoldierAnimatSequnce_SkillAttrack:int = 2;
      
      public function CONST_MINIBATTLE()
      {
         super();
      }
   }
}

