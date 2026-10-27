package Logics.HDActivityGB
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityGBSevenDay extends TActivityOSBase
   {
      
      protected var FCurCount:uint;
      
      protected var FTotalCount:uint;
      
      public function TActivityGBSevenDay()
      {
         super();
      }
      
      public function get CurCount() : uint
      {
         return this.FCurCount;
      }
      
      public function set CurCount(param1:uint) : void
      {
         this.FCurCount = param1;
      }
      
      public function get TotalCount() : uint
      {
         return this.FTotalCount;
      }
      
      public function set TotalCount(param1:uint) : void
      {
         this.FTotalCount = param1;
      }
   }
}

