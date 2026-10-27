package ghostcat.util
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import ghostcat.events.TickEvent;
   
   public class Tick extends EventDispatcher
   {
      
      private static var _instance:Tick;
      
      public static var frameRate:Number = NaN;
      
      public static var MAX_INTERVAL:int = 3000;
      
      public static var MIN_INTERVAL:int = 0;
      
      public var speed:Number = 1;
      
      public var pause:Boolean = false;
      
      private var displayObject:Shape;
      
      private var prevTime:int;
      
      public function Tick()
      {
         super();
         this.displayObject = new Shape();
         this.displayObject.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      public static function get instance() : Tick
      {
         if(!_instance)
         {
            _instance = new Tick();
         }
         return _instance;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function clear() : void
      {
         this.prevTime = 0;
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TickEvent = null;
         var _loc2_:int = getTimer();
         if(!this.pause)
         {
            if(this.prevTime == 0)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc3_ = Math.max(MIN_INTERVAL,Math.min(_loc2_ - this.prevTime,MAX_INTERVAL));
               _loc4_ = new TickEvent(TickEvent.TICK);
               _loc4_.interval = _loc3_ * this.speed;
               dispatchEvent(_loc4_);
            }
         }
         this.prevTime = _loc2_;
      }
   }
}

