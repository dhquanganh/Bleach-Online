package Logics.DatebaseVO.VO.Json
{
   public class TAchievementCondition
   {
      
      protected var FType:int;
      
      protected var FValue1:int;
      
      protected var FValue2:int;
      
      protected var FNeedTimes:int;
      
      public function TAchievementCondition(param1:Object)
      {
         super();
         this.FType = param1.type;
         this.FValue1 = param1.value1;
         this.FValue2 = param1.value2;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Value1() : int
      {
         return this.FValue1;
      }
      
      public function get Value2() : int
      {
         return this.FValue2;
      }
      
      public function get NeedTimes() : int
      {
         return this.FNeedTimes;
      }
      
      public function set NeedTimes(param1:int) : void
      {
         this.FNeedTimes = param1;
      }
   }
}

