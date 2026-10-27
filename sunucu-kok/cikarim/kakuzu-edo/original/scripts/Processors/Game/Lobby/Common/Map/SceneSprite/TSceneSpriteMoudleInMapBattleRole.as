package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationBlood;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationNameSolider;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationWinFlag;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   
   public class TSceneSpriteMoudleInMapBattleRole extends TSceneSpriteMoudleInMap
   {
      
      protected static const State_Normal:int = 0;
      
      protected static const State_Ding:int = 1;
      
      protected static const State_Doding:int = 2;
      
      protected static const State_Moving:int = 3;
      
      protected var AlphaSubSpeed:Number = 0.03;
      
      protected var XMoveSpeed:Number = 2;
      
      protected var DodgeDuration:int = 1000;
      
      protected var DodgeMoveOffset:int = 80;
      
      protected var DieMoveOffset:int = 80;
      
      protected var FDieDuration:int = 1000;
      
      protected var FActionState:int;
      
      protected var FDecorationBlood:TDecorationBlood;
      
      protected var FDecorationName:TDecorationNameSolider;
      
      protected var FDecorationWinFlag:TDecorationWinFlag;
      
      protected var FMovementLinear:TMovementLinear;
      
      protected var FTickStore:int;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FOnOverDied:Function;
      
      public function TSceneSpriteMoudleInMapBattleRole()
      {
         super();
         this.FDecorationBlood = new TDecorationBlood();
         this.FDecorationName = new TDecorationNameSolider();
         this.FDecorationWinFlag = new TDecorationWinFlag();
         AddHeadDecoration(this.FDecorationBlood);
         AddHeadDecoration(this.FDecorationName);
         AddHeadDecoration(this.FDecorationWinFlag);
         this.addChild(this.FDecorationBlood);
         this.addChild(this.FDecorationName);
         this.addChild(this.FDecorationWinFlag);
         this.FMovementLinear = new TMovementLinear();
         FQuery = new TMoudleInfor();
         this.FCoordinate = new TCoordinate();
         this.FActionState = State_Normal;
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
         switch(this.FActionState)
         {
            case State_Ding:
               this.UpdateDing();
               break;
            case State_Moving:
               this.UpdateMoving();
               break;
            case State_Doding:
               this.UpdateDoding();
         }
      }
      
      protected function UpdateDoding() : void
      {
         if(this.FTickStore >= this.DodgeDuration)
         {
            x = this.FCoordinate.X;
            this.FActionState = State_Normal;
         }
         this.FTickStore += CONST_COMMON.ElapseTime;
      }
      
      protected function UpdateMoving() : void
      {
         if(this.FMovementLinear.MoveOver)
         {
            this.FActionState = State_Normal;
         }
         this.FMovementLinear.Move(this.FTickStore);
         x = this.FMovementLinear.X;
         y = this.FMovementLinear.Y;
         this.FTickStore += CONST_COMMON.ElapseTime;
      }
      
      protected function UpdateDing() : void
      {
         if(this.FMovementLinear.MoveOver)
         {
            this.alpha = 0;
            this.FActionState = State_Normal;
            if(this.FOnOverDied != null)
            {
               this.FOnOverDied(this);
            }
            return;
         }
         this.FMovementLinear.Move(this.FTickStore);
         alpha = (this.FDieDuration - this.FTickStore) / this.FDieDuration;
         x = this.FMovementLinear.X;
         y = this.FMovementLinear.Y;
         this.FTickStore += CONST_COMMON.ElapseTime;
      }
      
      override protected function HaveRoleMoudle() : Boolean
      {
         return false;
      }
      
      public function get IsNormal() : Boolean
      {
         return this.FActionState == State_Normal;
      }
      
      override public function Release() : void
      {
         super.Release();
         this.HideWin();
         this.FTickStore = 0;
         this.FCoordinate.X = 0;
         this.FCoordinate.Y = 0;
         this.FActionState = State_Normal;
      }
      
      public function RoleDie(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == CONST_MAP.DIRECTION_LEFT)
         {
            _loc2_ = x + this.DieMoveOffset;
         }
         else
         {
            _loc2_ = x - this.DieMoveOffset;
         }
         _loc3_ = y;
         this.FMovementLinear.SetupSegmentByDuration(_loc2_,_loc3_,x,y,this.FDieDuration);
         this.FTickStore = 0;
         this.FActionState = State_Ding;
      }
      
      public function BattleStand(param1:int) : void
      {
         TUtilityTexture.QueryTwoDirectionBattleStandBy(param1,RoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
         FRoleDirection = param1;
      }
      
      public function NormalAttrack(param1:int) : void
      {
         TUtilityTexture.QueryTwoDirectionNormalAttrack(param1,RoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
         FRoleDirection = param1;
      }
      
      public function SkillAttrack(param1:int) : void
      {
         TUtilityTexture.QueryTwoDirectionSkillAttrack(param1,RoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
         FRoleDirection = param1;
      }
      
      public function BeAttrack(param1:int) : void
      {
         TUtilityTexture.QueryTwoDirectionBlow(param1,RoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
         FRoleDirection = param1;
      }
      
      public function ChangeBloodRate(param1:Number) : void
      {
         this.FDecorationBlood.ChangeBlood(param1);
      }
      
      public function ChangeName(param1:String, param2:int) : void
      {
         this.FDecorationName.UpdateName(param1,param2);
      }
      
      public function Move(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.FMovementLinear.SetupSegmentByDuration(param3,param4,param1,param2,param5);
         this.FActionState = State_Moving;
         this.FTickStore = 0;
      }
      
      public function Dodge(param1:int) : void
      {
         this.FCoordinate.X = x;
         this.FCoordinate.Y = y;
         switch(param1)
         {
            case CONST_MAP.DIRECTION_RIGHT:
               x -= this.DodgeMoveOffset;
               break;
            case CONST_MAP.DIRECTION_LEFT:
               x += this.DodgeMoveOffset;
         }
         this.FTickStore = 0;
         this.FActionState = State_Doding;
      }
      
      public function ShowWin() : void
      {
         this.FDecorationWinFlag.Show();
         this.FDecorationWinFlag.visible = true;
      }
      
      public function HideWin() : void
      {
         this.FDecorationWinFlag.Hide();
         this.FDecorationWinFlag.visible = false;
      }
   }
}

