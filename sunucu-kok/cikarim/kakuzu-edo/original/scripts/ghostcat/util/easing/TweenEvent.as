package ghostcat.util.easing
{
   import flash.events.Event;
   
   public class TweenEvent extends Event
   {
      
      public static const TWEEN_START:String = "tween_start";
      
      public static const TWEEN_END:String = "tween_end";
      
      public static const TWEEN_UPDATE:String = "tween_update";
      
      public function TweenEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TweenEvent(type,bubbles,cancelable);
      }
   }
}

