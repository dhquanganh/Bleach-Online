package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_MainScene;
   import Resources.Constants.CONST_ROLE;
   
   public class TUIRoleCanMove extends TUIRole
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FTargetMapX:Number;
      
      protected var FTargetMapY:Number;
      
      protected var FSpeedX:Number;
      
      protected var FSpeedY:Number;
      
      protected var FCostTime:int;
      
      protected var FOnArriveTarget:Function;
      
      protected var FCanRun:Boolean;
      
      public function TUIRoleCanMove(param1:TUIComponent)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      protected function UpdateRoleMove() : void
      {
         if(this.FCanRun)
         {
            FMapX += this.FSpeedX;
            FMapY += this.FSpeedY;
            --this.FCostTime;
            if(this.FCostTime < 0)
            {
               FMapX = this.FTargetMapX;
               FMapY = this.FTargetMapY;
               this.DoArriveTargetPosition();
            }
         }
      }
      
      protected function DoArriveTargetPosition() : void
      {
         this.FCanRun = false;
         if(this.FOnArriveTarget != null)
         {
            this.FOnArriveTarget();
         }
      }
      
      public function get TargetMapX() : Number
      {
         return this.FTargetMapX;
      }
      
      public function get TargetMapY() : Number
      {
         return this.FTargetMapY;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function set OnArriveTarget(param1:Function) : void
      {
         this.FOnArriveTarget = param1;
      }
      
      override public function SetupTargetPosition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this.FTargetMapX = param1;
         this.FTargetMapY = param2;
         _loc4_ = param1 - FMapX;
         _loc5_ = param2 - FMapY;
         _loc6_ = Math.atan2(_loc5_,_loc4_);
         this.FSpeedX = Math.cos(_loc6_) * param3;
         this.FSpeedY = Math.sin(_loc6_) * param3;
         if(Math.abs(_loc4_) > Math.abs(_loc5_))
         {
            this.FCostTime = _loc4_ / this.FSpeedX;
         }
         else
         {
            this.FCostTime = _loc5_ / this.FSpeedY;
         }
         if(_loc4_ < 0)
         {
            ChangeDirection(CONST_MainScene.DIRECTION_Left);
         }
         else if(_loc4_ > 0)
         {
            ChangeDirection(CONST_MainScene.DIRECTION_RIGHT);
         }
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun);
         this.FCanRun = true;
      }
      
      override public function UpdateData() : void
      {
         super.UpdateData();
         this.UpdateRoleMove();
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
      }
      
      public function StopMove() : void
      {
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         this.FTargetMapX = 0;
         this.FTargetMapY = 0;
         this.FCanRun = false;
      }
      
      public function StopToNormalIdle() : void
      {
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         this.FCanRun = false;
      }
      
      public function StopToBattleIdle() : void
      {
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby);
         this.FCanRun = false;
      }
   }
}

