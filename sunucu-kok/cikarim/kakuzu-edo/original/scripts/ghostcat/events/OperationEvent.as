package ghostcat.events
{
   import flash.events.Event;
   import ghostcat.operation.Oper;
   
   public class OperationEvent extends Event
   {
      
      public static const OPERATION_START:String = "operation_start";
      
      public static const OPERATION_COMPLETE:String = "operation_complete";
      
      public static const OPERATION_ERROR:String = "operation_error";
      
      public static const CHILD_OPERATION_START:String = "child_operation_start";
      
      public static const CHILD_OPERATION_COMPLETE:String = "child_operation_complete";
      
      public static const CHILD_OPERATION_ERROR:String = "child_operation_error";
      
      public var oper:Oper;
      
      public var childOper:Oper;
      
      public var result:*;
      
      public function OperationEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:OperationEvent = new OperationEvent(type,bubbles,cancelable);
         _loc1_.oper = this.oper;
         _loc1_.childOper = this.childOper;
         _loc1_.result = this.result;
         return _loc1_;
      }
   }
}

