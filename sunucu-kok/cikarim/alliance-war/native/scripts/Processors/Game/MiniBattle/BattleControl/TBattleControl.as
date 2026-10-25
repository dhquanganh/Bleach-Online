package Processors.Game.MiniBattle.BattleControl
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapBattleRole;
   import Processors.Game.MiniBattle.Mode.TBattleSoldierInfor;
   import Processors.Game.MiniBattle.Mode.TOneAttrack;
   import Processors.Game.MiniBattle.Mode.TOneBattle;
   import Processors.TProcessor;
   import Resources.Constants.CONST_MINIBATTLE;
   
   public class TBattleControl extends TProcessor
   {
      
      protected var FSoldierMe:TBattleSoldierInfor;
      
      protected var FSoldierControlMe:TSoldierControl;
      
      protected var FSoldierMeView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FSoldierEnemy:TBattleSoldierInfor;
      
      protected var FSoldierControlEnemy:TSoldierControl;
      
      protected var FSoldierEnemyView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FBattlePlaySchedule:int;
      
      protected var FBattleData:TOneBattle;
      
      protected var FOnBattleOver:Function;
      
      protected var FLinePosition:int;
      
      public function TBattleControl(param1:TUIComponent)
      {
         super(param1);
         this.FSoldierMeView = new TSceneSpriteMoudleInMapBattleRole();
         addChild(this.FSoldierMeView);
         this.FSoldierEnemyView = new TSceneSpriteMoudleInMapBattleRole();
         addChild(this.FSoldierEnemyView);
         this.FSoldierControlEnemy = new TSoldierControl(this);
         this.FSoldierControlEnemy.OnAttrackOver = this.CallBack_AttractOver;
         this.FSoldierControlMe = new TSoldierControl(this);
         this.FSoldierControlMe.OnAttrackOver = this.CallBack_AttractOver;
      }
      
      protected function StartAttrackByIndex(param1:int) : void
      {
         var _loc2_:TOneAttrack = null;
         _loc2_ = this.FBattleData.GetOneAttrackByIndex(param1);
         switch(_loc2_.AtrrackRoleCamp)
         {
            case CONST_MINIBATTLE.CampType_Friend:
               this.FSoldierControlMe.StartAttrack(_loc2_);
               break;
            case CONST_MINIBATTLE.CampType_Enemy:
               this.FSoldierControlEnemy.StartAttrack(_loc2_);
         }
      }
      
      protected function CallBack_AttractOver(param1:Object) : void
      {
         ++this.FBattlePlaySchedule;
         if(this.FBattlePlaySchedule >= this.FBattleData.Count)
         {
            if(this.FBattleData.BattleResult == CONST_MINIBATTLE.BattleResult_Win)
            {
               this.FSoldierMeView.ShowWin();
            }
            else
            {
               this.FSoldierEnemyView.ShowWin();
            }
            if(this.FOnBattleOver != null)
            {
               this.FOnBattleOver(this);
            }
         }
         else
         {
            this.StartAttrackByIndex(this.FBattlePlaySchedule);
         }
      }
      
      public function set BattleData(param1:TOneBattle) : void
      {
         this.FBattleData = param1;
         this.FBattleData.SoldierFriend.Position = this.FLinePosition;
         this.FBattleData.SoldierEnemy.Position = this.FLinePosition;
         this.FSoldierControlMe.SetBattleSoldier(this.FBattleData.SoldierFriend,this.FBattleData.SoldierEnemy,this.FSoldierMeView,this.FSoldierEnemyView);
         this.FSoldierControlEnemy.SetBattleSoldier(this.FBattleData.SoldierEnemy,this.FBattleData.SoldierFriend,this.FSoldierEnemyView,this.FSoldierMeView);
      }
      
      public function set OnBattleOver(param1:Function) : void
      {
         this.FOnBattleOver = param1;
      }
      
      public function set LinePosition(param1:int) : void
      {
         this.FLinePosition = param1;
      }
      
      public function get BattleData() : TOneBattle
      {
         return this.FBattleData;
      }
      
      public function StartBattle() : void
      {
         this.FBattlePlaySchedule = 0;
         this.StartAttrackByIndex(this.FBattlePlaySchedule);
         visible = true;
      }
      
      public function EndBattle() : void
      {
         this.FBattlePlaySchedule = 0;
         this.FBattleData = null;
         this.FSoldierControlMe.EndAttrack();
         this.FSoldierControlEnemy.EndAttrack();
         Visible = false;
      }
      
      public function Reset() : void
      {
         this.FSoldierEnemyView.visible = false;
         this.FSoldierMeView.visible = false;
         this.FSoldierEnemyView.Release();
         this.FSoldierMeView.Release();
         this.FSoldierControlMe.Reset();
         this.FSoldierControlEnemy.Reset();
         this.FBattlePlaySchedule = 0;
      }
   }
}

