package Logics.DatebaseVO.VO.Json
{
   public class TConditionStyleD
   {
      
      protected var FKey:uint;
      
      protected var FIndex:uint;
      
      protected var FAwardLimit:uint;
      
      protected var FType:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FNeed:uint;
      
      public function TConditionStyleD(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super();
         if(param1.index != null)
         {
            this.FIndex = param1.index;
         }
         if(param1.type != null)
         {
            this.FType = param1.type;
         }
         if(param1.key != null)
         {
            this.FKey = param1.key;
         }
         if(param1.awardlimit != null)
         {
            this.FAwardLimit = param1.awardlimit;
         }
         if(param1.award != null)
         {
            _loc3_ = int(param1.award.length);
            this.FAwards = new Vector.<uint>(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FAwards[_loc2_] = param1.award[_loc2_];
               _loc2_++;
            }
         }
         if(param1.need != null)
         {
            this.FNeed = param1.need;
         }
      }
      
      public function get Key() : uint
      {
         return this.FKey;
      }
      
      public function get AwardLimit() : uint
      {
         return this.FAwardLimit;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function get Need() : uint
      {
         return this.FNeed;
      }
      
      public function set Need(param1:uint) : void
      {
         this.FNeed = param1;
      }
   }
}

