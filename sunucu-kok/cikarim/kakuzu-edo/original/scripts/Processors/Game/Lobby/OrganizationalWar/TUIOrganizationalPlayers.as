package Processors.Game.Lobby.OrganizationalWar
{
   public class TUIOrganizationalPlayers
   {
      
      protected var FRoles:Vector.<TUIOrganizationalWarPlayer>;
      
      public function TUIOrganizationalPlayers()
      {
         super();
         this.FRoles = new Vector.<TUIOrganizationalWarPlayer>();
      }
      
      protected function SortMethod(param1:TUIOrganizationalWarPlayer, param2:TUIOrganizationalWarPlayer) : int
      {
         if(param1.RoleData.TotalScore > param2.RoleData.TotalScore)
         {
            return -1;
         }
         if(param1.RoleData.TotalScore < param2.RoleData.TotalScore)
         {
            return 1;
         }
         return 0;
      }
      
      protected function ScoreSort_Perform() : void
      {
         this.FRoles.sort(this.SortMethod);
      }
      
      public function get Count() : int
      {
         return this.FRoles.length;
      }
      
      public function GetRoleByIndex(param1:int) : TUIOrganizationalWarPlayer
      {
         return this.FRoles[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIOrganizationalWarPlayer = null;
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
      
      public function Add(param1:TUIOrganizationalWarPlayer) : void
      {
         param1.StubReferences.Reference(this);
         this.FRoles.push(param1);
      }
      
      public function IndexOfIndentifier(param1:uint, param2:uint) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIOrganizationalWarPlayer = null;
         _loc4_ = int(this.FRoles.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRoles[_loc3_];
            if(_loc5_.RoleData != null)
            {
               if(_loc5_.RoleData.Identifier0 == param1 && _loc5_.RoleData.Identifier1 == param2)
               {
                  return _loc3_;
               }
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function GetRoleByIdentifier(param1:uint, param2:uint) : TUIOrganizationalWarPlayer
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIOrganizationalWarPlayer = null;
         _loc4_ = int(this.FRoles.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRoles[_loc3_];
            if(_loc5_.RoleData != null)
            {
               if(_loc5_.RoleData.Identifier0 == param1 && _loc5_.RoleData.Identifier1 == param2)
               {
                  return _loc5_;
               }
            }
            _loc3_++;
         }
         return null;
      }
      
      public function DeleteRoleByIdentifier(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIOrganizationalWarPlayer = null;
         _loc4_ = int(this.FRoles.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRoles[_loc3_];
            if(_loc5_.RoleData != null)
            {
               if(_loc5_.RoleData.Identifier0 == param1 && _loc5_.RoleData.Identifier1 == param2)
               {
                  this.FRoles.splice(_loc3_,1);
                  _loc5_.Release();
                  _loc5_.StubReferences.Reference(this);
                  return;
               }
            }
            _loc3_++;
         }
      }
      
      public function ScoreSort() : void
      {
         this.ScoreSort_Perform();
      }
   }
}

