package Logics.HDActivityGB
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityGBOnline extends TActivityOSBase
   {
      
      protected var FStep:uint;
      
      public function TActivityGBOnline()
      {
         super();
      }
      
      public function get Step() : uint
      {
         return this.FStep;
      }
      
      public function set Step(param1:uint) : void
      {
         this.FStep = param1;
      }
   }
}

