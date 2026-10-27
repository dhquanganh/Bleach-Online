package Logics.Pet.Gift
{
   import Resources.Constants.*;
   
   public class TGifts
   {
      
      protected var FGifts:Vector.<TGift>;
      
      public function TGifts()
      {
         super();
         this.FGifts = new Vector.<TGift>();
      }
      
      protected function SortByIdentifier() : void
      {
         this.FGifts.sort(this.SortIdentifier);
      }
      
      protected function SortIdentifier(param1:TGift, param2:TGift) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = param1.Identifier;
         _loc4_ = param2.Identifier;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FGifts.length;
      }
      
      public function GetGiftByIndex(param1:int) : TGift
      {
         return this.FGifts[param1];
      }
      
      public function GetGiftByIdentifier(param1:uint) : TGift
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGift = null;
         _loc2_ = int(this.FGifts.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FGifts[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetIndexByGift(param1:TGift) : uint
      {
         return this.FGifts.indexOf(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TGift = null;
         _loc1_ = int(this.FGifts.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FGifts[_loc2_];
            _loc3_.Clear();
            _loc2_++;
         }
         this.FGifts.length = 0;
      }
      
      public function Add(param1:TGift) : void
      {
         this.FGifts.push(param1);
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:TGift = null;
         _loc2_ = this.FGifts[param1];
         _loc2_.Clear();
         this.FGifts.splice(param1,1);
      }
      
      public function Sort() : void
      {
         this.SortByIdentifier();
      }
   }
}

