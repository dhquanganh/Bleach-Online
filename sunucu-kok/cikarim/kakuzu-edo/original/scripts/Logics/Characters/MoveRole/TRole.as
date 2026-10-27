package Logics.Characters.MoveRole
{
   import Foundation.Common.TEntity64;
   
   public class TRole extends TEntity64
   {
      
      protected var FRoleID:uint;
      
      protected var FRoleTemplateID:uint;
      
      protected var FRoleName:String;
      
      protected var FTownID:uint;
      
      public function TRole(param1:uint, param2:uint)
      {
         super(param1,param2);
      }
      
      public function get RoleID() : uint
      {
         return this.FRoleID;
      }
      
      public function set RoleID(param1:uint) : void
      {
         this.FRoleID = param1;
      }
      
      public function get RoleTemplateID() : uint
      {
         return this.FRoleTemplateID;
      }
      
      public function set RoleTemplateID(param1:uint) : void
      {
         this.FRoleTemplateID = param1;
      }
      
      public function get RoleName() : String
      {
         return this.FRoleName;
      }
      
      public function set RoleName(param1:String) : void
      {
         this.FRoleName = param1;
      }
      
      public function get TownID() : uint
      {
         return this.FTownID;
      }
      
      public function set TownID(param1:uint) : void
      {
         this.FTownID = param1;
      }
   }
}

