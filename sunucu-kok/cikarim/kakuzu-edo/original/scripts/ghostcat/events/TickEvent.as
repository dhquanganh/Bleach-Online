package ghostcat.events
{
   import flash.events.Event;
   
   public class TickEvent extends Event
   {
      
      public static const TICK:String = "tick";
      
      public var interval:int;
      
      public function TickEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:TickEvent = new TickEvent(type,bubbles,cancelable);
         _loc1_.interval = this.interval;
         return _loc1_;
      }
   }
}

