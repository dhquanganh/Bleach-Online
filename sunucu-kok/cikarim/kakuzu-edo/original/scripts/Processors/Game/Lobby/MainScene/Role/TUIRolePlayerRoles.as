package Processors.Game.Lobby.MainScene.Role
{
   public class TUIRolePlayerRoles
   {
      
      protected var FRoles:Vector.<TUIRoleCanMovePlayerRole>;
      
      public function TUIRolePlayerRoles()
      {
         super();
         this.FRoles = new Vector.<TUIRoleCanMovePlayerRole>();
      }
      
      public function get Count() : int
      {
         return this.FRoles.length;
      }
      
      public function GetRoleByIndex(param1:int) : TUIRoleCanMovePlayerRole
      {
         return this.FRoles[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIRoleCanMovePlayerRole = null;
         _loc1_ = int(this.FRoles.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRoles[_loc2_];
            if(_loc3_ != null)
            {
               _loc3_.StubReferences.Dereference(this);
            }
            _loc2_++;
         }
         this.FRoles.length = 0;
      }
      
      public function Add(param1:TUIRoleCanMovePlayerRole) : void
      {
         param1.StubReferences.Reference(this);
         this.FRoles.push(param1);
      }
      
      public function GetRoleByIdentifier(param1:uint, param2:uint) : TUIRoleCanMovePlayerRole
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         _loc4_ = int(this.FRoles.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRoles[_loc3_];
            if(_loc5_.RoleData.Identifier0 == param1 && _loc5_.RoleData.Identifier1 == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function DeleteRoleByIndex(param1:int) : void
      {
         var _loc2_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = this.FRoles[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FRoles.splice(param1,1);
      }
      
      public function DeleteRoleByIdentifier(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         _loc4_ = int(this.FRoles.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRoles[_loc3_];
            if(_loc5_.RoleData.Identifier0 == param1 && _loc5_.RoleData.Identifier1 == param2)
            {
               this.FRoles.splice(_loc3_,1);
               _loc5_.StubReferences.Dereference(this);
               return;
            }
            _loc3_++;
         }
      }
   }
}

