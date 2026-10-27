package Logging.Digests
{
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
      
      public function GetDigestByIdentifier(param1:uint) : TDigest
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TDigest = null;
         _loc2_ = int(this.FDigests.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FDigests[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Shift() : TDigest
      {
         var _loc1_:int = 0;
         var _loc2_:TDigest = null;
         _loc1_ = int(this.FDigests.length);
         if(_loc1_ > 0)
         {
            _loc2_ = this.FDigests[0];
            _loc2_.StubReferences.Dereference(this);
            this.FDigests.splice(0,1);
            return _loc2_;
         }
         return null;
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
   }
}

