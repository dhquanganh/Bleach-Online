package Logics.Characters.MoveRole
{
   import Resources.Constants.*;
   
   public class TRoleCanControls
   {
      
      protected var FRoles:Vector.<TRoleCanControl>;
      
      public function TRoleCanControls()
      {
         super();
         this.FRoles = new Vector.<TRoleCanControl>();
      }
      
      public function get Count() : int
      {
         return this.FRoles.length;
      }
      
      public function GetRoleByIndex(param1:int) : TRoleCanControl
      {
         return this.FRoles[param1];
      }
      
      public function GetRoleByIdentifier(param1:uint, param2:uint) : TRoleCanControl
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TRoleCanControl = null;
         _loc3_ = int(this.FRoles.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FRoles[_loc4_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRoleCanControl = null;
         _loc1_ = int(this.FRoles.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRoles[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FRoles.length = 0;
      }
      
      public function Add(param1:TRoleCanControl) : void
      {
         param1.StubReferences.Reference(this);
         this.FRoles.push(param1);
      }
      
      public function DeleteRoleByIdentifier(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TRoleCanControl = null;
         _loc3_ = 0;
         while(_loc3_ < this.FRoles.length)
         {
            _loc4_ = this.FRoles[_loc3_];
            if(_loc4_.Identifier0 == param1 && _loc4_.Identifier1 == param2)
            {
               _loc4_.StubReferences.Dereference(this);
               this.FRoles.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function Delete(param1:TRoleCanControl) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FRoles.length)
         {
            if(param1.Identifier0 == this.FRoles[_loc2_].Identifier0 && param1.Identifier1 == this.FRoles[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FRoles.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
   }
}

