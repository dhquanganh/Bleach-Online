package Logics.HDActivityRecharge
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDDailyPayData extends TActivityOSBase
   {
      
      protected var FAward:TAwardData;
      
      public function THDDailyPayData()
      {
         super();
         this.FAward = new TAwardData();
      }
      
      public function get Award() : TAwardData
      {
         return this.FAward;
      }
      
      public function set Award(param1:TAwardData) : void
      {
         this.FAward = param1;
      }
   }
}

