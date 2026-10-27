package Logics.HDActivityRecharge
{
   public class TDailyCostAwardData extends TAwardData
   {
      
      protected var FCount:uint;
      
      public function TDailyCostAwardData()
      {
         super();
      }
      
      public function get Count() : uint
      {
         return this.FCount;
      }
      
      public function set Count(param1:uint) : void
      {
         this.FCount = param1;
      }
   }
}

