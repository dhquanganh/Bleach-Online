package Processors.Game.MiniBattle.ScriptAction
{
   import Foundation.Common.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Resources.Constants.*;
   
   public class TScriptActionJmpToTarget extends TScriptAction
   {
      
      protected static const TargetType_Me:int = 0;
      
      protected static const TargetType_Enemy:int = 1;
      
      protected var FTargetID:uint;
      
      protected var FCampCorrdinate:TCoordinate;
      
      protected var FXOffset:int;
      
      protected var FDurationTime:int;
      
      public function TScriptActionJmpToTarget()
      {
         super();
         this.FCampCorrdinate = new TCoordinate();
      }
      
      protected function GetCorrinateByPosition(param1:int, param2:int, param3:TCoordinate) : void
      {
         switch(param2)
         {
            case CONST_MAP.DIRECTION_RIGHT:
               param3.X = CONST_MINIBATTLE.LeftSoldierScreenX[param1];
               param3.Y = CONST_MINIBATTLE.LeftSoldierScreenY[param1];
               break;
            case CONST_MAP.DIRECTION_LEFT:
               param3.X = CONST_MINIBATTLE.RightSoldierScreenX[param1];
               param3.Y = CONST_MINIBATTLE.RightSoldierScreenY[param1];
         }
      }
      
      override public function Trigger() : void
      {
         switch(this.FTargetID)
         {
            case TargetType_Me:
               this.GetCorrinateByPosition(FSoldierMe.Position,FSoldierMe.Direction,this.FCampCorrdinate);
               this.FCampCorrdinate.X = FSoldierMe.Direction == CONST_MAP.DIRECTION_LEFT ? int(this.FCampCorrdinate.X - this.FXOffset) : int(this.FCampCorrdinate.X + this.FXOffset);
               FSoldierMeView.Move(FSoldierMeView.x,FSoldierMeView.y,this.FCampCorrdinate.X,this.FCampCorrdinate.Y,this.FDurationTime);
               break;
            case TargetType_Enemy:
               this.GetCorrinateByPosition(FSoldierEnemy.Position,FSoldierEnemy.Direction,this.FCampCorrdinate);
               this.FCampCorrdinate.X = FSoldierEnemy.Direction == CONST_MAP.DIRECTION_LEFT ? int(this.FCampCorrdinate.X - this.FXOffset) : int(this.FCampCorrdinate.X + this.FXOffset);
               FSoldierMeView.Move(FSoldierMeView.x,FSoldierMeView.y,this.FCampCorrdinate.X,this.FCampCorrdinate.Y,this.FDurationTime);
         }
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FTargetID = param1.Next();
         this.FXOffset = param1.Next();
         this.FDurationTime = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTargetID = 0;
         this.FCampCorrdinate.X = 0;
         this.FCampCorrdinate.Y = 0;
         this.FXOffset = 0;
         this.FDurationTime = 0;
      }
   }
}

