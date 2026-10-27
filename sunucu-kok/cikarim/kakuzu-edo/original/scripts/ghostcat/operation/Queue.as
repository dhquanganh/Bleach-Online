package ghostcat.operation
{
   import ghostcat.debug.Debug;
   import ghostcat.events.OperationEvent;
   
   public class Queue extends Oper implements IQueue
   {
      
      private static var _defaultQueue:Queue;
      
      public var children:Array = [];
      
      public var autoStart:Boolean = true;
      
      public function Queue(param1:Array = null, param2:Boolean = false)
      {
         var _loc4_:Oper = null;
         super();
         this.holdInstance = param2;
         if(!param1)
         {
            param1 = [];
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_] as Oper;
            _loc4_.queue = this;
            _loc4_.step = Oper.WAIT;
            _loc3_++;
         }
         this.children = param1;
      }
      
      public static function get defaultQueue() : Queue
      {
         if(!_defaultQueue)
         {
            _defaultQueue = new Queue();
         }
         return _defaultQueue;
      }
      
      public function commitChild(param1:Oper) : void
      {
         param1.queue = this;
         param1.step = Oper.WAIT;
         this.children.push(param1);
         if(this.autoStart && this.children.length == 1)
         {
            this.doLoad();
         }
      }
      
      public function haltChild(param1:Oper) : void
      {
         param1.queue = null;
         param1.step = Oper.NONE;
         var _loc2_:int = this.children.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            this.nexthandler(null);
         }
         else
         {
            this.children.splice(_loc2_,1);
         }
      }
      
      private function doLoad() : void
      {
         var _loc1_:Oper = null;
         if(this.children.length > 0)
         {
            _loc1_ = this.children[0];
            _loc1_.addEventListener(OperationEvent.OPERATION_START,this.starthandler);
            _loc1_.addEventListener(OperationEvent.OPERATION_COMPLETE,this.nexthandler);
            _loc1_.addEventListener(OperationEvent.OPERATION_ERROR,this.nexthandler);
            _loc1_.execute();
         }
         else
         {
            result();
         }
      }
      
      private function starthandler(param1:OperationEvent) : void
      {
         var _loc2_:Oper = param1.currentTarget as Oper;
         _loc2_.removeEventListener(OperationEvent.OPERATION_START,this.starthandler);
         var _loc3_:OperationEvent = new OperationEvent(OperationEvent.CHILD_OPERATION_START);
         _loc3_.oper = this;
         _loc3_.childOper = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      private function nexthandler(param1:OperationEvent) : void
      {
         var _loc3_:OperationEvent = null;
         var _loc2_:Oper = this.children[0] as Oper;
         _loc2_.removeEventListener(OperationEvent.OPERATION_START,this.starthandler);
         _loc2_.removeEventListener(OperationEvent.OPERATION_COMPLETE,this.nexthandler);
         _loc2_.removeEventListener(OperationEvent.OPERATION_ERROR,this.nexthandler);
         this.children.shift();
         if(_loc2_.continueWhenFail || !param1 || param1.type == OperationEvent.OPERATION_COMPLETE)
         {
            this.doLoad();
         }
         else
         {
            fault(param1);
         }
         if(param1)
         {
            _loc3_ = new OperationEvent(param1.type == OperationEvent.OPERATION_COMPLETE ? OperationEvent.CHILD_OPERATION_COMPLETE : OperationEvent.CHILD_OPERATION_ERROR);
            _loc3_.oper = this;
            _loc3_.childOper = _loc2_;
            _loc3_.result = param1.result;
            dispatchEvent(_loc3_);
         }
      }
      
      override public function commit(param1:Queue = null) : void
      {
         if(!param1)
         {
            param1 = Queue.defaultQueue;
         }
         if(param1 == this)
         {
            Debug.error("不能将自己推入自己的队列中");
         }
         else
         {
            super.commit(param1);
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.doLoad();
      }
      
      override public function halt() : void
      {
         super.halt();
         if(this.children.length > 0)
         {
            this.children = this.children.slice(0,1);
            (this.children[0] as Oper).halt();
         }
      }
   }
}

