package Logics.Campaign
{
   public class TStars
   {
      
      protected var FStars:Vector.<TStar>;
      
      public function TStars()
      {
         super();
         this.FStars = new Vector.<TStar>();
      }
      
      public function get Count() : int
      {
         return this.FStars.length;
      }
      
      public function GetStarByIndex(param1:int) : TStar
      {
         return this.FStars[param1];
      }
      
      public function GetStarById(param1:int) : TStar
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TStar = null;
         _loc2_ = int(this.FStars.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FStars[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetStarCountById(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TStar = null;
         _loc2_ = int(this.FStars.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FStars[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_.StarCount;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TStar = null;
         _loc1_ = int(this.FStars.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FStars[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FStars.length = 0;
      }
      
      public function Add(param1:TStar) : void
      {
         param1.StubReferences.Reference(this);
         this.FStars.push(param1);
      }
   }
}

