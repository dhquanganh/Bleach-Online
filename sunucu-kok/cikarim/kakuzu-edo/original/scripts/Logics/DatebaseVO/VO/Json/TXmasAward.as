package Logics.DatebaseVO.VO.Json
{
   public class TXmasAward
   {
      
      protected var FConditionList:Vector.<uint>;
      
      protected var FAwardId:Vector.<uint>;
      
      public function TXmasAward(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         _loc2_ = param1.sugarNum as Array;
         _loc4_ = _loc2_.length;
         this.FConditionList = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FConditionList[_loc3_] = _loc5_;
            _loc3_++;
         }
         _loc2_ = param1.awardId as Array;
         _loc4_ = _loc2_.length;
         this.FAwardId = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FAwardId[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      public function get ConditionList() : Vector.<uint>
      {
         return this.FConditionList;
      }
      
      public function get AwardId() : Vector.<uint>
      {
         return this.FAwardId;
      }
   }
}

