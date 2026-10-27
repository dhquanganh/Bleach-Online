package Logics.HDActivityGB
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityGBGold extends TActivityOSBase
   {
      
      protected var FTotalCount:uint;
      
      protected var FCurCount:uint;
      
      public function TActivityGBGold()
      {
         super();
      }
      
      public function get TotalCount() : uint
      {
         return this.FTotalCount;
      }
      
      public function set TotalCount(param1:uint) : void
      {
         this.FTotalCount = param1;
      }
      
      public function get CurCount() : uint
      {
         return this.FCurCount;
      }
      
      public function set CurCount(param1:uint) : void
      {
         this.FCurCount = param1;
      }
   }
}

