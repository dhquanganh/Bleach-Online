package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapBattleRole;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TScriptActionCheckHP extends TScriptAction
   {
      
      protected static const TargetType_Me:int = 0;
      
      protected static const TargetType_Enemy:int = 1;
      
      protected static const HpGreen:uint = 65280;
      
      protected static const HpRed:uint = 16711680;
      
      protected static const HpSize:int = 30;
      
      protected static const MaxMoveSpeed:int = 20;
      
      protected var FTargetID:int;
      
      protected var FHPPercentage:int;
      
      public function TScriptActionCheckHP()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSceneSpriteMoudleInMapBattleRole = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         switch(this.FTargetID)
         {
            case TargetType_Me:
               _loc1_ = this.FHPPercentage / 100 * FOneAttrack.MyBloodChangeValue;
               if(FOneAttrack.MyBloodChangeValue > 0)
               {
                  _loc6_ = FSoldierMe.CurrentHP + (FSoldierMe.LastHp - FSoldierMe.CurrentHP) * (FOneAttrack.CurrentTurn / FOneAttrack.TotalTurn);
                  FSoldierMeView.ChangeBloodRate(_loc6_ / FSoldierMe.TotalHP);
               }
               _loc3_ = FSoldierMeView;
               _loc7_ = 0;
               _loc8_ = -Math.random() * MaxMoveSpeed;
               break;
            case TargetType_Enemy:
               _loc1_ = this.FHPPercentage / 100 * FOneAttrack.EnemyBloodChangeValue;
               if(FOneAttrack.EnemyBloodChangeValue > 0)
               {
                  _loc6_ = FSoldierEnemy.CurrentHP + (FSoldierEnemy.LastHp - FSoldierEnemy.CurrentHP) * (FOneAttrack.CurrentTurn / FOneAttrack.TotalTurn);
                  FSoldierEnemyView.ChangeBloodRate(_loc6_ / FSoldierEnemy.TotalHP);
               }
               else
               {
                  _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_75);
                  PlayWorld(FSoldierEnemyView.x,FSoldierEnemyView.y - FSoldierEnemyView.height,_loc10_,-4,-4,30,HpRed);
               }
               _loc3_ = FSoldierEnemyView;
               _loc7_ = Math.random() * MaxMoveSpeed;
               _loc8_ = -Math.random() * MaxMoveSpeed;
               if(FSoldierEnemy.Direction == CONST_MAP.DIRECTION_RIGHT)
               {
                  _loc7_ *= -1;
                  _loc9_ = -30;
               }
         }
         if(_loc1_ != 0)
         {
            _loc2_ = _loc1_ > 0 ? HpRed : HpGreen;
            PlayHpEffect(_loc3_.x + _loc9_,_loc3_.y - _loc3_.height,_loc1_,_loc7_,_loc8_,HpSize,_loc2_);
         }
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FTargetID = param1.Next();
         this.FHPPercentage = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTargetID = 0;
         this.FHPPercentage = 0;
      }
   }
}

