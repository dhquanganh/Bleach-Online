package ghostcat.operation
{
   import ghostcat.events.OperationEvent;
   
   public class RepeatOper extends Oper
   {
      
      public var children:Array;
      
      public var loop:int;
      
      public var curLoop:int;
      
      public var index:int = 0;
      
      public function RepeatOper(param1:Array = null, param2:int = -1, param3:Boolean = false)
      {
         super();
         this.children = param1;
         this.loop = param2;
         this.holdInstance = param3;
      }
      
      override public function execute() : void
      {
         var _loc2_:Oper = null;
         super.execute();
         this.curLoop = this.loop;
         var _loc1_:int = 0;
         while(_loc1_ < this.children.length)
         {
            _loc2_ = this.children[_loc1_] as Oper;
            _loc2_.addEventListener(OperationEvent.OPERATION_COMPLETE,this.nextOperation);
            _loc2_.addEventListener(OperationEvent.OPERATION_ERROR,fault);
            _loc1_++;
         }
         this.index = 0;
         if(Boolean(this.children) && this.children.length > 0)
         {
            this.children[0].execute();
         }
      }
      
      override protected function end(param1:* = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Oper = null;
         super.end(param1);
         if(this.children)
         {
            _loc2_ = 0;
            while(_loc2_ < this.children.length)
            {
               _loc3_ = this.children[_loc2_] as Oper;
               _loc3_.removeEventListener(OperationEvent.OPERATION_COMPLETE,this.nextOperation);
               _loc3_.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
               _loc2_++;
            }
         }
      }
      
      private function nextOperation(param1:OperationEvent) : void
      {
         ++this.index;
         if(this.index > this.children.length - 1)
         {
            --this.curLoop;
            this.index = 0;
            if(this.curLoop == 0)
            {
               result();
               return;
            }
         }
         var _loc2_:Oper = this.children[this.index];
         _loc2_.execute();
      }
   }
}

