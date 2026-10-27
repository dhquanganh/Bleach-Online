package Logics.Organization
{
   public class TOrganizationMembers
   {
      
      protected var FOrganizationMembers:Vector.<TBaseOrganizationMember>;
      
      public function TOrganizationMembers()
      {
         super();
         this.FOrganizationMembers = new Vector.<TBaseOrganizationMember>();
      }
      
      public function get Count() : int
      {
         return this.FOrganizationMembers.length;
      }
      
      public function GetOrgMemberByIndex(param1:int) : TBaseOrganizationMember
      {
         return this.FOrganizationMembers[param1];
      }
      
      public function GetOrgMemberByIdentifier(param1:uint, param2:uint) : TBaseOrganizationMember
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FOrganizationMembers[_loc3_].Identifier0 == param1 && this.FOrganizationMembers[_loc3_].Identifier1 == param2)
            {
               return this.FOrganizationMembers[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBaseOrganizationMember = null;
         _loc1_ = int(this.FOrganizationMembers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FOrganizationMembers[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FOrganizationMembers.length = 0;
      }
      
      public function Add(param1:TBaseOrganizationMember) : void
      {
         param1.StubReferences.Reference(this);
         this.FOrganizationMembers.push(param1);
      }
      
      public function Delete(param1:TBaseOrganizationMember) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FOrganizationMembers.length)
         {
            if(param1.Identifier0 == this.FOrganizationMembers[_loc2_].Identifier0 && param1.Identifier1 == this.FOrganizationMembers[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FOrganizationMembers.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
   }
}

