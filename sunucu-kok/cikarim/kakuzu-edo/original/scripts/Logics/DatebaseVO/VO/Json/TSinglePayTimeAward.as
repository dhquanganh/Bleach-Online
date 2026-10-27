package Logics.DatebaseVO.VO.Json
{
   public class TSinglePayTimeAward
   {
      
      protected var FKey:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FType:uint;
      
      protected var FLimit:uint;
      
      public function TSinglePayTimeAward(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FKey = param1.key;
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
         this.FLimit = param1.limit;
         this.FType = param1.type;
      }
      
      public function get Key() : uint
      {
         return this.FKey;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
   }
}

