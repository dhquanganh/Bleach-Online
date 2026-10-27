package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.UI.TUIComponent;
   
   public class TUIRoleCanMovePlayerRoleMainRole extends TUIRoleCanMovePlayerRole
   {
      
      protected var FMovingToTargetNpc:Boolean;
      
      public function TUIRoleCanMovePlayerRoleMainRole(param1:TUIComponent)
      {
         super(param1);
         this.mouseEnabled = false;
      }
      
      public function UpdateMilitaryRank() : void
      {
         super.InitMilitaryRank();
      }
      
      public function UpdateMainRoleNameColor() : void
      {
         super.InitRoleName();
      }
      
      override public function Init() : void
      {
         OpenRebirthEffect(FRoleData.RebirthNum);
         InitRoleName();
         InitMilitaryRank();
         UpdateTextFieldPosition();
      }
      
      override public function Release() : void
      {
         super.Release();
      }
   }
}

