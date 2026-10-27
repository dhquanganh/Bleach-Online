package Logics.Characters
{
   import Foundation.Utilities.TUtilityString;
   
   public class TDigests
   {
      
      protected var FDigests:Vector.<TDigest>;
      
      public function TDigests()
      {
         super();
         this.FDigests = new Vector.<TDigest>();
      }
      
      public function get Count() : int
      {
         return this.FDigests.length;
      }
      
      public function GetDigestByIndex(param1:int) : TDigest
      {
         return this.FDigests[param1];
      }
      
      public function GetDigestByIdentifier(param1:uint, param2:uint) : TDigest
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FDigests[_loc3_].Identifier0 == param1 && this.FDigests[_loc3_].Identifier1 == param2)
            {
               return this.FDigests[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetDigestByName(param1:String) : TDigest
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = TUtilityString.StringsAreEquals(param1,this.FDigests[_loc2_].Name);
            if(_loc3_)
            {
               return this.FDigests[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function DigestSortLevel(param1:TDigest, param2:TDigest) : int
      {
         if(param1.Level < param2.Level)
         {
            return 1;
         }
         return -1;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TDigest = null;
         _loc1_ = int(this.FDigests.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FDigests[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FDigests.length = 0;
      }
      
      public function Add(param1:TDigest) : void
      {
         param1.StubReferences.Reference(this);
         this.FDigests.push(param1);
      }
      
      public function DeleteByDigest(param1:TDigest) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FDigests.length)
         {
            if(param1.Identifier0 == this.FDigests[_loc2_].Identifier0 && param1.Identifier1 == this.FDigests[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FDigests.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function SortLevel() : void
      {
         this.FDigests.sort(this.DigestSortLevel);
      }
   }
}

