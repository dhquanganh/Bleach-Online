package Logging.Requests
{
   public class TRequests
   {
      
      protected var FRequests:Vector.<TRequest>;
      
      public function TRequests()
      {
         super();
         this.FRequests = new Vector.<TRequest>();
      }
      
      public function get Count() : int
      {
         return this.FRequests.length;
      }
      
      public function GetRequestByIndex(param1:int) : TRequest
      {
         return this.FRequests[param1];
      }
      
      public function GetRequestByIdentifier(param1:uint) : TRequest
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRequest = null;
         _loc2_ = int(this.FRequests.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FRequests[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function DeleteRequestByIdentifier(param1:uint) : TRequest
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRequest = null;
         _loc2_ = int(this.FRequests.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FRequests[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               _loc4_.StubReferences.Dereference(this);
               this.FRequests.splice(_loc3_,1);
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRequest = null;
         _loc1_ = int(this.FRequests.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRequests[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FRequests.length = 0;
      }
      
      public function Add(param1:TRequest) : void
      {
         param1.StubReferences.Reference(this);
         this.FRequests.push(param1);
      }
   }
}

