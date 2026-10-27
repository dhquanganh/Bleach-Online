package Logics.Characters
{
   import Foundation.Utilities.TUtilityString;
   
   public class TFriendDigests
   {
      
      protected var FFriendDigests:Vector.<TFriendDigest>;
      
      public function TFriendDigests()
      {
         super();
         this.FFriendDigests = new Vector.<TFriendDigest>();
      }
      
      public function get Count() : int
      {
         return this.FFriendDigests.length;
      }
      
      public function GetDigestByIndex(param1:int) : TFriendDigest
      {
         return this.FFriendDigests[param1];
      }
      
      public function GetDigestByIdentifier(param1:uint, param2:uint) : TFriendDigest
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FFriendDigests[_loc3_].Identifier0 == param1 && this.FFriendDigests[_loc3_].Identifier1 == param2)
            {
               return this.FFriendDigests[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetDigestByName(param1:String) : TFriendDigest
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = TUtilityString.StringsAreEquals(param1,this.FFriendDigests[_loc2_].Name);
            if(_loc3_)
            {
               return this.FFriendDigests[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function FriendDigestSortLevel(param1:TFriendDigest, param2:TFriendDigest) : int
      {
         if(param1.Level < param2.Level)
         {
            return 1;
         }
         return -1;
      }
      
      protected function FriendDigestSortHomeLevel(param1:TFriendDigest, param2:TFriendDigest) : int
      {
         if(param1.HomeLevel < param2.HomeLevel)
         {
            return 1;
         }
         return -1;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFriendDigest = null;
         _loc1_ = int(this.FFriendDigests.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FFriendDigests[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FFriendDigests.length = 0;
      }
      
      public function ClearListByType(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:TFriendDigest = null;
         _loc2_ = int(this.FFriendDigests.length);
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this.FFriendDigests[_loc3_];
            if(_loc4_.Type == param1)
            {
               this.DeleteByDigest(_loc4_);
            }
            _loc3_--;
         }
      }
      
      public function Add(param1:TFriendDigest) : void
      {
         param1.StubReferences.Reference(this);
         this.FFriendDigests.push(param1);
      }
      
      public function DeleteByDigest(param1:TFriendDigest) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FFriendDigests.length)
         {
            if(param1.Identifier0 == this.FFriendDigests[_loc2_].Identifier0 && param1.Identifier1 == this.FFriendDigests[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FFriendDigests.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function SortLevel() : void
      {
         this.FFriendDigests.sort(this.FriendDigestSortLevel);
      }
      
      public function SortHomeLevel() : void
      {
         this.FFriendDigests.sort(this.FriendDigestSortHomeLevel);
      }
   }
}

