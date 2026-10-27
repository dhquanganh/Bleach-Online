package Foundation.LoaderQueue
{
   import flash.events.Event;
   
   public class TLoaderQueueEvent extends Event
   {
      
      public static const TASK_ADDED:String = "TaskAdded";
      
      public static const TASK_REMOVED:String = "TaskRemoved";
      
      public static const TASK_COMPLETED:String = "TaskCompleted";
      
      public static const TASK_ERROR:String = "TaskError";
      
      public static const TASK_PROGRESS:String = "TaskProgress";
      
      public static const TASK_START:String = "TaskStart";
      
      public static const TASK_TIMEOUT:String = "TaskTimeOut";
      
      public static const TASK_LoadBlocked:String = "TaskLoadBlocked";
      
      public static const TASK_LoadFailed:String = "TaskLoadFailed";
      
      public static const TASK_STOP:String = "TaskStop";
      
      public static const TASK_DISPOSE:String = "TaskDispose";
      
      public static const TASK_QUEUE_COMPLETED:String = "TaskQueueCompleted";
      
      protected var FCustomData:*;
      
      protected var FBytesLoaded:Number;
      
      protected var FBytesTotal:Number;
      
      protected var FErrorMsg:String;
      
      public function TLoaderQueueEvent(param1:String, param2:* = null)
      {
         super(param1);
         this.FCustomData = param2;
      }
      
      public function get CustomData() : *
      {
         return this.FCustomData;
      }
      
      public function set CustomData(param1:*) : void
      {
         this.FCustomData = param1;
      }
      
      public function get BytesLoaded() : Number
      {
         return this.FBytesLoaded;
      }
      
      public function set BytesLoaded(param1:Number) : void
      {
         this.FBytesLoaded = param1;
      }
      
      public function get BytesTotal() : Number
      {
         return this.FBytesTotal;
      }
      
      public function set BytesTotal(param1:Number) : void
      {
         this.FBytesTotal = param1;
      }
      
      public function get ErrorMsg() : String
      {
         return this.FErrorMsg;
      }
      
      public function set ErrorMsg(param1:String) : void
      {
         this.FErrorMsg = param1;
      }
      
      override public function clone() : Event
      {
         var _loc1_:TLoaderQueueEvent = null;
         _loc1_ = new TLoaderQueueEvent(type);
         _loc1_.CustomData = this.FCustomData;
         _loc1_.BytesLoaded = this.FBytesLoaded;
         _loc1_.BytesTotal = this.FBytesTotal;
         _loc1_.ErrorMsg = this.FErrorMsg;
         return _loc1_;
      }
   }
}

