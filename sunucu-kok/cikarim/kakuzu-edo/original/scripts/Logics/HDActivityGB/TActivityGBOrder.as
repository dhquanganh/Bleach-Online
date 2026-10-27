package Logics.HDActivityGB
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityGBOrder extends TActivityOSBase
   {
      
      protected var FTime:uint;
      
      public function TActivityGBOrder()
      {
         super();
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
   }
}

