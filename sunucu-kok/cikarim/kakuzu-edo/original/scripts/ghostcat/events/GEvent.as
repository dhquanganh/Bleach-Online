package ghostcat.events
{
   import flash.events.Event;
   
   public class GEvent extends Event
   {
      
      public static const UPDATE_COMPLETE:String = "update_complete";
      
      public static const CREATE_COMPLETE:String = "create_complete";
      
      public static const REFRESH_COMPLETE:String = "refresh_complete";
      
      public static const SHOW:String = "show";
      
      public static const HIDE:String = "hide";
      
      public static const DATA_CHANGE:String = "data_change";
      
      public static const REMOVE:String = "remove";
      
      public function GEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new GEvent(type,bubbles,cancelable);
      }
   }
}

