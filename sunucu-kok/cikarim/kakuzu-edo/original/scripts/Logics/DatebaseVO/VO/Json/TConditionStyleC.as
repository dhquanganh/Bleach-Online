package Logics.DatebaseVO.VO.Json
{
   public class TConditionStyleC
   {
      
      protected var FTotalCount:uint;
      
      protected var FValue:Vector.<TConditionStyleB>;
      
      public function TConditionStyleC(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TConditionStyleB = null;
         super();
         if(param1.totalCount != null)
         {
            this.FTotalCount = param1.totalCount;
         }
         if(param1.value != null)
         {
            _loc3_ = int(param1.value.length);
            this.FValue = new Vector.<TConditionStyleB>(param1.value.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = new TConditionStyleB(param1.value[_loc2_]);
               this.FValue[_loc2_] = _loc4_;
               _loc2_++;
            }
         }
      }
      
      public function get TotalCount() : uint
      {
         return this.FTotalCount;
      }
      
      public function get Value() : Vector.<TConditionStyleB>
      {
         return this.FValue;
      }
   }
}

