package Logics.HDActivityOS
{
   public class TActivityOSKillHero extends TActivityOSBase
   {
      
      protected var FLimitCount:Vector.<uint>;
      
      public function TActivityOSKillHero()
      {
         super();
      }
      
      public function get LimitCount() : Vector.<uint>
      {
         return this.FLimitCount;
      }
      
      public function set LimitCount(param1:Vector.<uint>) : void
      {
         this.FLimitCount = param1;
      }
   }
}

