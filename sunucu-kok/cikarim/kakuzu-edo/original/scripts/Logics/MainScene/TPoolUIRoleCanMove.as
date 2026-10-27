package Logics.MainScene
{
   import Foundation.Pools.TPoolAutomatic;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.MoveRole.TRoleCanControl;
   import Logics.Spaces.LogicsSpace;
   import Processors.Game.Lobby.MainScene.Role.TUIRoleCanMovePet;
   import Processors.Game.Lobby.MainScene.Role.TUIRoleCanMovePlayerRole;
   
   use namespace LogicsSpace;
   
   public class TPoolUIRoleCanMove extends TPoolAutomatic
   {
      
      protected var FIndexUIRoleCanMovePlayerRole:int;
      
      protected var FIndexUIRoleCanMovePet:int;
      
      protected var FIndexRoleCanControl:int;
      
      public function TPoolUIRoleCanMove()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexUIRoleCanMovePlayerRole = RegisterClass(TUIRoleCanMovePlayerRole,this.ReleaseRole);
         this.FIndexUIRoleCanMovePet = RegisterClass(TUIRoleCanMovePet);
         this.FIndexRoleCanControl = RegisterClass(TRoleCanControl);
      }
      
      protected function ReleaseRole(param1:TUIRoleCanMovePlayerRole) : void
      {
         param1.Release();
      }
      
      public function AcquireUIRoleCanMovePlayerRole(param1:TUIComponent) : TUIRoleCanMovePlayerRole
      {
         var _loc2_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexUIRoleCanMovePlayerRole) as TUIRoleCanMovePlayerRole;
         if(_loc2_ == null)
         {
            _loc2_ = new TUIRoleCanMovePlayerRole(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireUIRoleCanMovePet(param1:TUIComponent) : TUIRoleCanMovePet
      {
         var _loc2_:TUIRoleCanMovePet = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexUIRoleCanMovePet) as TUIRoleCanMovePet;
         if(_loc2_ == null)
         {
            _loc2_ = new TUIRoleCanMovePet(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireRoleCanControl(param1:uint = 0, param2:uint = 0) : TRoleCanControl
      {
         var _loc3_:TRoleCanControl = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexRoleCanControl) as TRoleCanControl;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TRoleCanControl(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
   }
}

