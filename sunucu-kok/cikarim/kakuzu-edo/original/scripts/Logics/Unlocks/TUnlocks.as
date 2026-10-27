package Logics.Unlocks
{
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnlocks
   {
      
      protected var FUnlocks:Vector.<TUnlock>;
      
      public function TUnlocks()
      {
         super();
         this.FUnlocks = new Vector.<TUnlock>();
      }
      
      public function get Count() : int
      {
         return this.FUnlocks.length;
      }
      
      public function GetUnlockByIndex(param1:int) : TUnlock
      {
         return this.FUnlocks[param1];
      }
      
      public function GetUnlockByIdentifier(param1:int) : TUnlock
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            if(this.FUnlocks[_loc2_].Identifier == param1)
            {
               return this.FUnlocks[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      LogicsSpace function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUnlock = null;
         _loc1_ = int(this.FUnlocks.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FUnlocks[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FUnlocks.length = 0;
      }
      
      LogicsSpace function Add(param1:TUnlock) : void
      {
         param1.StubReferences.Reference(this);
         this.FUnlocks.push(param1);
      }
      
      LogicsSpace function Delete(param1:int) : void
      {
         var _loc2_:TUnlock = null;
         _loc2_ = this.FUnlocks[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FUnlocks.splice(param1,1);
      }
   }
}

