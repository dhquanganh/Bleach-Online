package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MainScene;
   import Resources.Constants.CONST_ROLE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.events.MouseEvent;
   
   public class TUIRoleCanMovePet extends TUIRoleCanMove
   {
      
      protected var DistanceStartRun:int = 22500;
      
      protected var MinDistance:int = 10000;
      
      protected var State_Following:int = 0;
      
      protected var State_Leaveing:int = 1;
      
      protected var State_Leaved:int = 2;
      
      protected var FCurrentPetState:int;
      
      protected var FFollowRole:TUIRoleCanMovePlayerRole;
      
      public function TUIRoleCanMovePet(param1:TUIComponent)
      {
         super(param1);
         this.removeEventListener(MouseEvent.MOUSE_OVER,HandleOnMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,HandleOnMouseOut);
         this.removeEventListener(MouseEvent.CLICK,HandleOnMouseClick);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,HandleOnMouseMove);
         FTextFiledName.textColor = 16777215;
         this.mouseEnabled = false;
      }
      
      public function UpdatePetPosition() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         _loc1_ = this.CheckIfCollision(this.MinDistance);
         if(_loc1_)
         {
            StopMove();
            return;
         }
         _loc2_ = !this.CheckIfCollision(this.DistanceStartRun);
         if(_loc2_)
         {
            SetupTargetPosition(this.FFollowRole.MapX,this.FFollowRole.MapY + 2,CONST_MainScene.RoleMoveSpeed);
         }
      }
      
      protected function CheckIfCollision(param1:int) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = this.FFollowRole.MapX - MapX;
         _loc3_ = this.FFollowRole.MapY - MapY;
         if(_loc2_ * _loc2_ + _loc3_ * _loc3_ > param1)
         {
            return false;
         }
         return true;
      }
      
      protected function UpdateDirection() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FFollowRole.MapX > this.MapX ? CONST_MainScene.DIRECTION_RIGHT : CONST_MainScene.DIRECTION_Left;
         ChangeDirection(_loc1_);
      }
      
      protected function InitPetName() : void
      {
         var _loc1_:TKnife = null;
         var _loc2_:TKnifeExpand = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,FTemplateID) as TKnife;
         if(_loc1_ == null)
         {
            return;
         }
         FTextFiledName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_1),this.FFollowRole.RoleData.RoleName,_loc1_.Name);
         FTextFiledName.y = -FTextFiledName.height;
         UpdateDisplayObjectPosition(FTextFiledName);
      }
      
      override protected function DoArriveTargetPosition() : void
      {
         super.DoArriveTargetPosition();
      }
      
      public function set FollowRole(param1:TUIRoleCanMovePlayerRole) : void
      {
         this.FFollowRole = param1;
      }
      
      public function get FollowRole() : TUIRoleCanMovePlayerRole
      {
         return this.FFollowRole;
      }
      
      override public function UpdateData() : void
      {
         this.UpdatePetPosition();
         super.UpdateData();
      }
      
      override public function UpdateView() : void
      {
         this.UpdateDirection();
         super.UpdateView();
         UpdateDisplayObjectPosition(FTextFiledName);
      }
      
      override public function Release() : void
      {
         super.Release();
         parent.removeChild(this);
         StubReferences.Dereference(this.FFollowRole);
         this.FollowRole = null;
         this.FCurrentPetState = this.State_Leaved;
      }
      
      public function Init() : void
      {
         if(FTemplateID != 0)
         {
            this.InitPetName();
            ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
            FOnArriveTarget = StopToNormalIdle;
         }
      }
   }
}

