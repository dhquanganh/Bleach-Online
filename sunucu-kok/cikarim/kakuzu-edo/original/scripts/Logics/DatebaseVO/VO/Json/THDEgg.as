package Logics.DatebaseVO.VO.Json
{
   public class THDEgg
   {
      
      protected var FLimit:uint;
      
      protected var FGold:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FRate:uint;
      
      public function THDEgg(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FLimit = param1.limit;
         this.FGold = param1.cost;
         _loc2_ = param1.award as Array;
         _loc4_ = _loc2_.length;
         this.FAwards = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FAwards[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FRate = param1.rate;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:uint) : void
      {
         this.FLimit = param1;
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function set Gold(param1:uint) : void
      {
         this.FGold = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function set Rate(param1:uint) : void
      {
         this.FRate = param1;
      }
   }
}

