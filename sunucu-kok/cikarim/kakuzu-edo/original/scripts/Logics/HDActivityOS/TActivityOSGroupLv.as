package Logics.HDActivityOS
{
   public class TActivityOSGroupLv extends TActivityOSBase
   {
      
      protected var FInfo:THDDailyActivityInfo;
      
      public function TActivityOSGroupLv()
      {
         super();
         this.FInfo = new THDDailyActivityInfo();
      }
      
      public function get Info() : THDDailyActivityInfo
      {
         return this.FInfo;
      }
      
      public function set Info(param1:THDDailyActivityInfo) : void
      {
         this.FInfo = param1;
      }
   }
}

