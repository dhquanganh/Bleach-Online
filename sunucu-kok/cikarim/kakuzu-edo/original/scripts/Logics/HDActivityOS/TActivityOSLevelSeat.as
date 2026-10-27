package Logics.HDActivityOS
{
   public class TActivityOSLevelSeat extends TActivityOSBase
   {
      
      protected var FPrizeNums:Vector.<uint>;
      
      public function TActivityOSLevelSeat()
      {
         super();
      }
      
      public function get PrizeNums() : Vector.<uint>
      {
         return this.FPrizeNums;
      }
      
      public function set PrizeNums(param1:Vector.<uint>) : void
      {
         this.FPrizeNums = param1;
      }
   }
}

