package ghostcat.operation
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DelayOper extends Oper
   {
      
      public var timeout:int = 0;
      
      private var timer:Timer;
      
      public function DelayOper(param1:int = 0)
      {
         super();
         this.timeout = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this.timeout < 0)
         {
            return;
         }
         this.timer = new Timer(this.timeout,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,result);
         this.timer.start();
      }
      
      override protected function end(param1:* = null) : void
      {
         super.end(param1);
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,result);
            this.timer.stop();
         }
      }
   }
}

