package Logics.HDActivityOS
{
   public class TActivityOSCompoundStone extends TActivityOSBase
   {
      
      protected var FOwnedCounts:Vector.<uint>;
      
      public function TActivityOSCompoundStone()
      {
         super();
      }
      
      public function get OwnedCounts() : Vector.<uint>
      {
         return this.FOwnedCounts;
      }
      
      public function set OwnedCounts(param1:Vector.<uint>) : void
      {
         this.FOwnedCounts = param1;
      }
   }
}

