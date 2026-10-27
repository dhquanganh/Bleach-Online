package ghostcat.operation
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import ghostcat.events.OperationEvent;
   import ghostcat.util.core.AbstractUtil;
   
   public class Oper extends EventDispatcher implements IOper
   {
      
      public static const NONE:int = 0;
      
      public static const WAIT:int = 1;
      
      public static const RUN:int = 2;
      
      public static const END:int = 3;
      
      private static var instances:Dictionary = new Dictionary();
      
      public var id:String;
      
      public var queue:IQueue;
      
      public var step:int = 0;
      
      public var lastResult:*;
      
      public var immediately:Boolean = false;
      
      public var continueWhenFail:Boolean = true;
      
      public var holdInstance:Boolean = false;
      
      public function Oper()
      {
         super();
         AbstractUtil.preventConstructor(this,Oper);
      }
      
      public function execute() : void
      {
         var _loc1_:OperationEvent = new OperationEvent(OperationEvent.OPERATION_START);
         _loc1_.oper = this;
         dispatchEvent(_loc1_);
         this.step = RUN;
         if(this.holdInstance)
         {
            instances[this] = true;
         }
         if(this.immediately)
         {
            _loc1_ = new OperationEvent(OperationEvent.OPERATION_COMPLETE);
            _loc1_.oper = this;
            dispatchEvent(_loc1_);
         }
      }
      
      public function result(param1:* = null) : void
      {
         this.lastResult = param1;
         this.resultFunction(param1);
         this.end(param1);
         var _loc2_:OperationEvent = new OperationEvent(OperationEvent.OPERATION_COMPLETE);
         _loc2_.oper = this;
         _loc2_.result = param1;
         dispatchEvent(_loc2_);
         this.queue = null;
         this.step = END;
      }
      
      public function fault(param1:* = null) : void
      {
         this.lastResult = param1;
         this.failFunction(param1);
         this.end(param1);
         var _loc2_:OperationEvent = new OperationEvent(OperationEvent.OPERATION_ERROR);
         _loc2_.oper = this;
         _loc2_.result = param1;
         dispatchEvent(_loc2_);
         this.queue = null;
         this.step = END;
      }
      
      public function commit(param1:Queue = null) : void
      {
         if(!param1)
         {
            param1 = Queue.defaultQueue;
         }
         param1.commitChild(this);
      }
      
      protected function resultFunction(param1:* = null) : void
      {
      }
      
      protected function failFunction(param1:* = null) : void
      {
      }
      
      protected function end(param1:* = null) : void
      {
         if(this.holdInstance)
         {
            delete instances[this];
         }
      }
      
      public function halt() : void
      {
         this.end();
         if(this.queue)
         {
            this.queue.haltChild(this);
         }
      }
   }
}

