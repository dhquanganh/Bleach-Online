package Logics.Rooms
{
   public class TRoomDigests
   {
      
      protected var FDigests:Vector.<TRoomDigest>;
      
      public function TRoomDigests()
      {
         super();
         this.FDigests = new Vector.<TRoomDigest>();
      }
      
      protected function SortRoom(param1:TRoomDigest, param2:TRoomDigest) : int
      {
         if(param1.ModelID < param2.ModelID)
         {
            if(param1.IsFighting || param1.Passworded || param1.PlayerCount >= param1.PlayerCapacity)
            {
               return 1;
            }
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FDigests.length;
      }
      
      public function GetDigestByIndex(param1:int) : TRoomDigest
      {
         return this.FDigests[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRoomDigest = null;
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
      
      public function Add(param1:TRoomDigest) : void
      {
         param1.StubReferences.Reference(this);
         this.FDigests.push(param1);
      }
      
      public function GetDigestByIdentifier(param1:uint) : TRoomDigest
      {
         var _loc2_:int = 0;
         var _loc3_:TRoomDigest = null;
         var _loc4_:TRoomDigest = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FDigests[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TRoomDigest = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FDigests[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               _loc3_.StubReferences.Dereference(this);
               this.FDigests.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function SortRooms() : void
      {
         this.FDigests.sort(this.SortRoom);
      }
   }
}

