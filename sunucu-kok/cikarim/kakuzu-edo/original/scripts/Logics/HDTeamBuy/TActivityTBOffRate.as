package Logics.HDTeamBuy
{
   public class TActivityTBOffRate
   {
      
      protected var FCondition:uint;
      
      protected var FValue:uint;
      
      protected var FSort:uint;
      
      public function TActivityTBOffRate(param1:Object)
      {
         super();
         if(param1.condition != null)
         {
            this.FCondition = param1.condition;
         }
         if(param1.value != null)
         {
            this.FValue = param1.value;
         }
         if(param1.sort != null)
         {
            this.FSort = param1.sort;
         }
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function get Sort() : uint
      {
         return this.FSort;
      }
   }
}

