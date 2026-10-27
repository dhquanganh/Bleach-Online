package Logics.Characters
{
   public class TRoleDigests
   {
      
      protected var FRoleDigests:Vector.<TRoleDigest>;
      
      public function TRoleDigests()
      {
         super();
         this.FRoleDigests = new Vector.<TRoleDigest>();
      }
      
      public function get Count() : int
      {
         return this.FRoleDigests.length;
      }
      
      public function GetDigestByIndex(param1:int) : TRoleDigest
      {
         return this.FRoleDigests[param1];
      }
      
      public function GetDigestByIdentifier(param1:uint, param2:uint) : TRoleDigest
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FRoleDigests[_loc3_].Identifier0 == param1 && this.FRoleDigests[_loc3_].Identifier0 == param2)
            {
               return this.FRoleDigests[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRoleDigest = null;
         _loc1_ = int(this.FRoleDigests.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRoleDigests[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FRoleDigests.length = 0;
      }
      
      public function Add(param1:TRoleDigest) : void
      {
         param1.StubReferences.Reference(this);
         this.FRoleDigests.push(param1);
      }
      
      public function Delete(param1:TRoleDigest) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FRoleDigests.length)
         {
            if(param1.Identifier0 == this.FRoleDigests[_loc2_].Identifier0 && param1.Identifier1 == this.FRoleDigests[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FRoleDigests.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
   }
}

