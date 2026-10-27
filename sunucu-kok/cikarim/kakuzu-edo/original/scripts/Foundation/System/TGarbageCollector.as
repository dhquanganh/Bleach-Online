package Foundation.System
{
   import Foundation.Timing.STimingCore;
   import flash.net.LocalConnection;
   
   public class TGarbageCollector
   {
      
      protected var FInterval:int;
      
      protected var FCurrentTick:int;
      
      protected var FNextTick:int;
      
      public function TGarbageCollector()
      {
         super();
         this.FInterval = 30002;
         this.FCurrentTick = STimingCore.TickCount;
         this.FNextTick = this.FCurrentTick + this.FInterval;
      }
      
      protected function PerformGC() : void
      {
         try
         {
            new LocalConnection().connect("GC");
            new LocalConnection().connect("GC");
         }
         catch(E:Error)
         {
         }
      }
      
      public function get Interval() : int
      {
         return this.FInterval;
      }
      
      public function set Interval(param1:int) : void
      {
         if(param1 < 0)
         {
            this.FInterval = 0;
         }
         else
         {
            this.FInterval = param1;
         }
      }
      
      public function Process() : void
      {
         this.FCurrentTick = STimingCore.TickCount;
         if(this.FCurrentTick >= this.FNextTick)
         {
            this.PerformGC();
            this.FNextTick += this.FInterval;
            if(this.FNextTick <= this.FCurrentTick)
            {
               this.FNextTick = this.FCurrentTick + this.FInterval;
            }
         }
      }
   }
}

