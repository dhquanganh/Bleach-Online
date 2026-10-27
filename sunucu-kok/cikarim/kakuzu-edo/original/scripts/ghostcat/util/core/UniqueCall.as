package ghostcat.util.core
{
   public class UniqueCall
   {
      
      public var dirty:Boolean = false;
      
      public var frame:Boolean = false;
      
      public var handler:Function;
      
      protected var para:Array;
      
      public function UniqueCall(param1:Function, param2:Boolean = false)
      {
         super();
         this.handler = param1;
         this.frame = param2;
      }
      
      public function invalidate(... rest) : void
      {
         if(this.dirty)
         {
            return;
         }
         this.dirty = true;
         this.para = rest;
         if(this.frame)
         {
            CallLaterQueue.instance.callLaterByTick(this.vaildNow);
         }
         else
         {
            CallLaterQueue.instance.callLaterByTime(this.vaildNow);
         }
      }
      
      public function vaildNow() : void
      {
         if(this.handler == null)
         {
            return;
         }
         if(this.para)
         {
            this.handler.apply(null,this.para);
         }
         else
         {
            this.handler();
         }
         this.dirty = false;
         this.para = null;
      }
      
      public function halt() : void
      {
         this.dirty = false;
         if(this.frame)
         {
            CallLaterQueue.instance.removeCallLaterByTick(this.vaildNow);
         }
         else
         {
            CallLaterQueue.instance.removeCallLaterByTime(this.vaildNow);
         }
      }
      
      public function destory() : void
      {
         this.halt();
         this.handler = null;
         this.para = null;
      }
   }
}

