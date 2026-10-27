package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityMath;
   import Foundation.Utilities.TUtilityTexture;
   import Resources.Constants.CONST_MAP;
   
   public class TSceneSpriteMoudleInMapCanRun extends TSceneSpriteMoudleInMap
   {
      
      protected static const SPEED:Number = 0.45;
      
      protected static const FOLLOWRADIUS:int = 100 * 100;
      
      protected static const STARTFOLLOWRADIUS:int = 140 * 140;
      
      protected static const SPEEDCIRCLE:int = 4;
      
      protected static const ANIMADISTANCE:int = 50;
      
      protected var FRunOver:Boolean;
      
      protected var FMovementLinear:TMovementLinear;
      
      protected var FTickStore:int;
      
      protected var FAngleStore:int;
      
      protected var FFollower:TSceneSpriteMoudleInMapCanRun;
      
      protected var FFollowType:int;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FRunPath:Vector.<int>;
      
      public function TSceneSpriteMoudleInMapCanRun()
      {
         super();
         this.FMovementLinear = new TMovementLinear();
         this.FRunOver = true;
         this.FAngleStore = 0;
         this.FRunPath = new Vector.<int>();
         this.FCoordinate = new TCoordinate();
      }
      
      protected function UpdateRun() : void
      {
         if(this.FRunOver)
         {
            return;
         }
         this.FMovementLinear.Move(STimingCore.TickCount - this.FTickStore);
         FMapCoordinate.X = this.FMovementLinear.X;
         FMapCoordinate.Y = this.FMovementLinear.Y;
         if(this.FMovementLinear.MoveOver)
         {
            this.MoveToNext();
         }
      }
      
      protected function MoveToNext() : void
      {
         var _loc1_:Number = NaN;
         if(this.FRunPath.length == 0)
         {
            this.FRunOver = true;
            this.StopRun();
            this.ArriveTarget();
            return;
         }
         this.FCoordinate.X = this.FRunPath[0];
         this.FCoordinate.Y = this.FRunPath[1];
         _loc1_ = TUtilityMath.FastDistance(this.FCoordinate.X - FMapCoordinate.X,this.FCoordinate.Y - FMapCoordinate.Y);
         this.FMovementLinear.SetupSegmentByDuration(this.FCoordinate.X,this.FCoordinate.Y,FMapCoordinate.X,FMapCoordinate.Y,_loc1_ / SPEED);
         this.FRunPath.splice(0,2);
         FRoleDirection = FSpriteMoudleContorl.GetDirectionByStartEndDirection(FMapCoordinate,this.FCoordinate);
         this.ChangeToRun();
         this.FTickStore = STimingCore.TickCount;
      }
      
      protected function UpdateFollowCircle() : void
      {
         if(this.FFollower == null)
         {
            return;
         }
         this.FAngleStore += SPEEDCIRCLE;
         this.FAngleStore %= 360;
         FMapCoordinate.X = this.FFollower.MapCoordinate.X + ANIMADISTANCE * TUtilityMath.CosLookTable[this.FAngleStore];
         FMapCoordinate.Y = this.FFollower.MapCoordinate.Y + ANIMADISTANCE * TUtilityMath.SinLookTable[this.FAngleStore];
      }
      
      protected function UpdateFollowNormal() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         if(this.FFollower == null)
         {
            return;
         }
         _loc1_ = this.CheckIfLargeThan(FOLLOWRADIUS);
         if(!_loc1_)
         {
            if(!this.FRunOver)
            {
               this.FRunOver = true;
               this.ChangeToStandBy();
            }
            return;
         }
         _loc1_ = this.CheckIfLargeThan(STARTFOLLOWRADIUS);
         if(!_loc1_)
         {
            return;
         }
         _loc2_ = Math.sqrt((this.FFollower.MapCoordinate.X - FMapCoordinate.X) * (this.FFollower.MapCoordinate.X - FMapCoordinate.X) + (this.FFollower.MapCoordinate.Y - FMapCoordinate.Y) * (this.FFollower.MapCoordinate.Y - FMapCoordinate.Y));
         this.FMovementLinear.SetupSegmentByDuration(this.FFollower.MapCoordinate.X,this.FFollower.MapCoordinate.Y,FMapCoordinate.X,FMapCoordinate.Y,_loc2_ / SPEED);
         FRoleDirection = FSpriteMoudleContorl.GetDirectionByStartEndDirection(FMapCoordinate,this.FFollower.MapCoordinate);
         this.ChangeToRun();
         this.FTickStore = STimingCore.TickCount;
         this.FRunOver = false;
      }
      
      protected function CheckIfLargeThan(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = MapCoordinate.X - this.FFollower.MapCoordinate.X;
         _loc4_ = MapCoordinate.Y - this.FFollower.MapCoordinate.Y;
         _loc2_ = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         return _loc2_ > param1;
      }
      
      protected function ArriveTarget() : void
      {
      }
      
      public function get RunPath() : Vector.<int>
      {
         return this.FRunPath;
      }
      
      public function set RunPath(param1:Vector.<int>) : void
      {
         this.FRunPath = param1;
      }
      
      public function get RunOver() : Boolean
      {
         return this.FRunOver;
      }
      
      public function set RunOver(param1:Boolean) : void
      {
         this.FRunOver = param1;
      }
      
      public function SetFollower(param1:TSceneSpriteMoudleInMapCanRun, param2:int) : void
      {
         this.FFollower = param1;
         this.FFollowType = param2;
      }
      
      public function get Follower() : TSceneSpriteMoudleInMapCanRun
      {
         return this.FFollower;
      }
      
      override public function UpdateData() : void
      {
         super.UpdateData();
         this.UpdateRun();
         switch(this.FFollowType)
         {
            case CONST_MAP.FOLLOW_TYPE_CIRCLE:
               this.UpdateFollowCircle();
               break;
            case CONST_MAP.FOLLOW_TYPE_NORMAL:
               this.UpdateFollowNormal();
         }
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
      }
      
      public function StartRun() : void
      {
         this.RunOver = false;
         this.MoveToNext();
      }
      
      public function StopRun() : void
      {
         this.RunOver = true;
         this.ChangeToStandBy();
         this.FRunPath.length = 0;
      }
      
      override public function Release() : void
      {
         super.Release();
         this.FFollower = null;
         this.FRunPath.length = 0;
         this.FTickStore = 0;
         this.FAngleStore = 0;
      }
      
      public function ChangeToRun() : void
      {
         TUtilityTexture.QueryEightDirectionRun(FRoleDirection,FRoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
      }
      
      public function ChangeToStandBy() : void
      {
         TUtilityTexture.QueryEightDirectionStandBy(FRoleDirection,FRoleTempleteID,FQuery);
         ChangeRoleMoudle(FQuery.TextureID,FQuery.Scalx);
      }
   }
}

