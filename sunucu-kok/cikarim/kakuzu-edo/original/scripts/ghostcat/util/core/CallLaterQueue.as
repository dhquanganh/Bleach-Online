package ghostcat.util.core
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import ghostcat.events.TickEvent;
   import ghostcat.util.Tick;
   
   public class CallLaterQueue
   {
      
      public static var instance:CallLaterQueue = new CallLaterQueue();
      
      private var timer:Timer;
      
      private var timeQueue:Array;
      
      private var timeQueuePara:Array;
      
      private var ticker:Tick;
      
      private var tickQueue:Array;
      
      private var tickQueuePara:Array;
      
      public function CallLaterQueue()
      {
         super();
         this.timer = new Timer(0,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerHandler);
         this.timeQueue = [];
         this.timeQueuePara = [];
         this.ticker = Tick.instance;
         this.ticker.addEventListener(TickEvent.TICK,this.tickHandler);
         this.tickQueue = [];
         this.tickQueuePara = [];
      }
      
      public function callLaterByTime(param1:Function, param2:Array = null) : void
      {
         this.timeQueue[this.timeQueue.length] = param1;
         this.timeQueuePara[this.timeQueuePara.length] = param2;
         if(!this.timer.running)
         {
            this.timer.repeatCount = 1;
            this.timer.start();
         }
      }
      
      public function callLaterByTick(param1:Function, param2:Array = null) : void
      {
         this.tickQueue[this.tickQueue.length] = param1;
         this.tickQueuePara[this.tickQueuePara.length] = param2;
      }
      
      public function removeCallLaterByTime(param1:Function) : void
      {
         var _loc2_:int = this.timeQueue.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.timeQueue.splice(_loc2_,1);
            this.timeQueuePara.splice(_loc2_,1);
         }
      }
      
      public function removeCallLaterByTick(param1:Function) : void
      {
         var _loc2_:int = this.tickQueue.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.tickQueue.splice(_loc2_,1);
            this.tickQueuePara.splice(_loc2_,1);
         }
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc6_:Array = null;
         var _loc2_:Array = this.timeQueue.concat();
         var _loc3_:Array = this.timeQueuePara.concat();
         this.timeQueue.length = 0;
         this.timeQueuePara.length = 0;
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_)
            {
               (_loc2_[_loc5_] as Function).apply(null,_loc3_[_loc5_]);
            }
            else
            {
               (_loc2_[_loc5_] as Function)();
            }
            _loc5_++;
         }
      }
      
      private function tickHandler(param1:TickEvent) : void
      {
         var _loc6_:Array = null;
         var _loc2_:Array = this.tickQueue.concat();
         var _loc3_:Array = this.tickQueuePara.concat();
         this.tickQueue.length = 0;
         this.tickQueuePara.length = 0;
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_)
            {
               (_loc2_[_loc5_] as Function).apply(null,_loc3_[_loc5_]);
            }
            else
            {
               (_loc2_[_loc5_] as Function)();
            }
            _loc5_++;
         }
      }
   }
}

