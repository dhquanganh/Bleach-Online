package Foundation.LoaderQueue
{
   import Logging.SLogger;
   import Logging.TLogger;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TLoaderQueue extends EventDispatcher implements ILoaderQueue
   {
      
      protected var FDelay:int;
      
      protected var FCacheMap:Object;
      
      protected var FLoaderDict:Dictionary;
      
      protected var FLoaderPriorityLib:Array;
      
      protected var FThreadLib:Array;
      
      protected var FTimeOutToSort:Timer;
      
      protected var FTimeBlock:Timer;
      
      protected var FJumpQueueIfCached:Boolean;
      
      protected var FThreadLimit:uint;
      
      protected var FReversePriority:Boolean;
      
      public function TLoaderQueue(param1:uint = 2, param2:int = 500, param3:Boolean = true)
      {
         super();
         this.FThreadLimit = param1;
         this.FDelay = param2;
         this.FJumpQueueIfCached = param3;
         this.FCacheMap = {};
         this.FLoaderPriorityLib = [];
         this.FThreadLib = [];
         this.FLoaderDict = new Dictionary();
         this.FTimeOutToSort = new Timer(param2,1);
         this.FTimeOutToSort.addEventListener(TimerEvent.TIMER_COMPLETE,this.TimeOutToSort_TimerCompleteHandler);
         this.FTimeBlock = new Timer(10000,1);
         this.FTimeBlock.addEventListener(TimerEvent.TIMER_COMPLETE,this.TimeBlockHandler);
         this.FReversePriority = false;
      }
      
      protected function CheckQueueHandle() : Boolean
      {
         var _loc1_:uint = 0;
         for each(_loc1_ in this.FLoaderPriorityLib)
         {
            if(this.FLoaderDict[_loc1_].length > 0)
            {
               return true;
            }
         }
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_QUEUE_COMPLETED));
         return false;
      }
      
      protected function CheckThreadHandle(param1:ILoaderAdapter) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this.FThreadLib.length < this.FThreadLimit)
         {
            this.FThreadLib.push(param1);
            this.StartItem(param1);
         }
         else
         {
            this.ThreadFullHandle(param1);
         }
      }
      
      protected function DisposeItem(param1:ILoaderAdapter) : void
      {
         var _loc2_:uint = 0;
         if(param1.IsStarted)
         {
            param1.removeEventListener(TLoaderQueueEvent.TASK_COMPLETED,this.LoaderAdapter_CompletedHandler);
            param1.removeEventListener(TLoaderQueueEvent.TASK_ERROR,this.LoaderAdapter_ErrorHandler);
            try
            {
               param1.Stop();
            }
            catch(e:Error)
            {
            }
         }
         param1.removeEventListener(TLoaderQueueEvent.TASK_DISPOSE,this.LoaderAdapter_DisposeHandler);
         _loc2_ = uint(this.FThreadLib.indexOf(param1));
         if(_loc2_ != -1)
         {
            this.FThreadLib.splice(_loc2_,1);
         }
         if(this.FLoaderDict[param1.Priority] == null)
         {
            return;
         }
         _loc2_ = uint(this.FLoaderDict[param1.Priority].indexOf(param1));
         this.FLoaderDict[param1.Priority].splice(_loc2_,1);
      }
      
      protected function GetNextIdleItem() : ILoaderAdapter
      {
         var _loc1_:uint = 0;
         var _loc2_:ILoaderAdapter = null;
         loop0:
         for each(_loc1_ in this.FLoaderPriorityLib)
         {
            var _loc5_:int = 0;
            var _loc6_:* = this.FLoaderDict[_loc1_];
            do
            {
               for each(_loc2_ in _loc6_)
               {
               }
               continue loop0;
            }
            while(_loc2_.IsStarted);
            return _loc2_;
         }
         return null;
      }
      
      protected function StartItem(param1:ILoaderAdapter) : void
      {
         SLogger.TraceLoadRequest(TLogger.LEVEL_LoadStart,param1,false);
         param1.addEventListener(TLoaderQueueEvent.TASK_COMPLETED,this.LoaderAdapter_CompletedHandler,false,16777215,false);
         param1.addEventListener(TLoaderQueueEvent.TASK_ERROR,this.LoaderAdapter_ErrorHandler,false,16777215,false);
         param1.Start();
         SLogger.State.Loading = this.FThreadLib.length;
      }
      
      protected function StopItem(param1:ILoaderAdapter) : void
      {
         param1.removeEventListener(TLoaderQueueEvent.TASK_COMPLETED,this.LoaderAdapter_CompletedHandler);
         param1.removeEventListener(TLoaderQueueEvent.TASK_ERROR,this.LoaderAdapter_ErrorHandler);
         try
         {
            param1.Stop();
         }
         catch(error:Error)
         {
         }
      }
      
      protected function ThreadFullHandle(param1:ILoaderAdapter) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc3_ = int(this.FThreadLib.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.CheckReversePriority(ILoaderAdapter(this.FThreadLib[_loc2_]).Priority,param1.Priority);
            if(_loc4_)
            {
               this.StopItem(this.FThreadLib[_loc2_]);
               this.FThreadLib[_loc2_] = param1;
               this.StartItem(param1);
            }
            _loc2_++;
         }
      }
      
      protected function SortStartedItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:ILoaderAdapter = null;
         var _loc4_:int = 0;
         var _loc5_:ILoaderAdapter = null;
         var _loc6_:ILoaderAdapter = null;
         var _loc7_:Boolean = false;
         _loc3_ = this.GetNextIdleItem();
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = int(_loc3_.Priority);
         _loc2_ = int(this.FThreadLib.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FThreadLib[_loc1_];
            _loc7_ = this.CheckReversePriority(_loc6_.Priority,_loc4_);
            if(_loc7_)
            {
               _loc5_ = this.GetNextIdleItem();
               _loc7_ = this.CheckReversePriority(_loc6_.Priority,_loc5_.Priority);
               if(_loc7_)
               {
                  this.StopItem(_loc6_);
                  this.FThreadLib[_loc1_] = _loc5_;
                  this.StartItem(_loc5_);
                  _loc4_ = int(_loc5_.Priority);
               }
               else
               {
                  _loc4_ = int(_loc6_.Priority);
               }
            }
            else
            {
               _loc4_ = int(_loc6_.Priority);
            }
            _loc1_++;
         }
      }
      
      protected function FillThreadPool() : void
      {
         var _loc1_:ILoaderAdapter = null;
         while(this.CurrentStartedNum < this.FThreadLimit)
         {
            _loc1_ = this.GetNextIdleItem();
            if(_loc1_ == null)
            {
               break;
            }
            this.FThreadLib.push(_loc1_);
            this.StartItem(_loc1_);
            _loc1_ = null;
         }
      }
      
      protected function CheckReversePriority(param1:uint, param2:uint) : Boolean
      {
         if(!this.FReversePriority)
         {
            return param1 > param2;
         }
         return param2 > param1;
      }
      
      protected function LoaderAdapter_CompletedHandler(param1:TLoaderQueueEvent) : void
      {
         var _loc2_:ILoaderAdapter = null;
         _loc2_ = param1.currentTarget as ILoaderAdapter;
         ++SLogger.State.Success;
         SLogger.TraceLoadRequest(TLogger.LEVEL_LoadEnd,_loc2_,false);
         if(this.FJumpQueueIfCached && !_loc2_.PreventCache)
         {
            this.FCacheMap[_loc2_.Url] = true;
         }
         this.DisposeItem(_loc2_);
         if(this.CheckQueueHandle())
         {
            this.CheckThreadHandle(this.GetNextIdleItem());
         }
         if(this.FThreadLib.length > 0)
         {
            if(!this.FTimeBlock.running)
            {
               this.FTimeBlock.reset();
               this.FTimeBlock.start();
            }
         }
         SLogger.State.Loading = this.FThreadLib.length;
      }
      
      protected function LoaderAdapter_ErrorHandler(param1:TLoaderQueueEvent) : void
      {
         var _loc2_:ILoaderAdapter = null;
         _loc2_ = param1.currentTarget as ILoaderAdapter;
         dispatchEvent(param1);
         this.DisposeItem(_loc2_);
         if(this.CheckQueueHandle())
         {
            this.CheckThreadHandle(this.GetNextIdleItem());
         }
         SLogger.State.Loading = this.FThreadLib.length;
      }
      
      protected function LoaderAdapter_DisposeHandler(param1:TLoaderQueueEvent) : void
      {
         this.RemoveItem(param1.target as ILoaderAdapter);
      }
      
      protected function TimeOutToSort_TimerCompleteHandler(param1:TimerEvent) : void
      {
         this.FTimeOutToSort.reset();
         if(!this.FReversePriority)
         {
            this.FLoaderPriorityLib.sort(Array.NUMERIC);
         }
         else
         {
            this.FLoaderPriorityLib.sort(Array.NUMERIC);
            this.FLoaderPriorityLib.reverse();
         }
         if(this.FThreadLib.length > 0)
         {
            this.SortStartedItem();
         }
         this.FillThreadPool();
         if(!this.FTimeBlock.running)
         {
            this.FTimeBlock.reset();
            this.FTimeBlock.start();
         }
      }
      
      protected function TimeBlockHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ILoaderAdapter = null;
         var _loc6_:TLoaderQueueEvent = null;
         _loc4_ = 0;
         this.FTimeBlock.reset();
         _loc3_ = int(this.FThreadLib.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FThreadLib[_loc2_];
            if(_loc5_ != null)
            {
               if(_loc5_.BytesLoaded == _loc5_.LastBytesLoaded)
               {
                  if(_loc5_.BytesLoaded == 0)
                  {
                     ++_loc5_.NumTimeOutTries;
                     if(_loc5_.NumTimeOutTries <= _loc5_.MaxTimeOutTries)
                     {
                        ++SLogger.State.TimeOut;
                        ++SLogger.State.Retry;
                        SLogger.TraceLoadRequest(TLogger.LEVEL_LoadTimeOutRetry,_loc5_,false);
                        this.RemoveItem(_loc5_);
                        this.AddItem(_loc5_);
                        _loc4_++;
                     }
                     else
                     {
                        ++SLogger.State.Fail;
                        SLogger.TraceLoadRequest(TLogger.LEVEL_LoadAbort,_loc5_,false);
                        _loc5_.State = TLoaderAdapterState.ERROR;
                        _loc6_ = new TLoaderQueueEvent(TLoaderQueueEvent.TASK_ERROR);
                        _loc5_.dispatchEvent(_loc6_);
                     }
                  }
                  else
                  {
                     ++_loc5_.NumBlockTries;
                     if(_loc5_.NumBlockTries <= _loc5_.MaxBlockTries)
                     {
                        ++SLogger.State.Block;
                        ++SLogger.State.Retry;
                        SLogger.TraceLoadRequest(TLogger.LEVEL_LoadBlockRetry,_loc5_,false);
                        this.RemoveItem(_loc5_);
                        this.AddItem(_loc5_);
                        _loc4_++;
                     }
                     else
                     {
                        ++SLogger.State.Fail;
                        SLogger.TraceLoadRequest(TLogger.LEVEL_LoadAbort,_loc5_,false);
                        _loc5_.State = TLoaderAdapterState.ERROR;
                        _loc6_ = new TLoaderQueueEvent(TLoaderQueueEvent.TASK_ERROR);
                        _loc5_.dispatchEvent(_loc6_);
                     }
                  }
               }
               else
               {
                  _loc5_.LastBytesLoaded = _loc5_.BytesLoaded;
               }
            }
            _loc2_++;
         }
         if(_loc4_ > 0 || _loc3_ > 0)
         {
            this.FTimeBlock.start();
         }
      }
      
      public function get CurrentStartedNum() : uint
      {
         return this.FThreadLib.length;
      }
      
      public function get JumpQueueIfCached() : Boolean
      {
         return this.FJumpQueueIfCached;
      }
      
      public function set JumpQueueIfCached(param1:Boolean) : void
      {
         this.FJumpQueueIfCached = param1;
      }
      
      public function get ThreadLimit() : uint
      {
         return this.FThreadLimit;
      }
      
      public function set ThreadLimit(param1:uint) : void
      {
         this.FThreadLimit = param1;
      }
      
      public function get ReversePriority() : Boolean
      {
         return this.FReversePriority;
      }
      
      public function set ReversePriority(param1:Boolean) : void
      {
         this.FReversePriority = param1;
      }
      
      public function AddItem(param1:ILoaderAdapter) : void
      {
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_ADDED,param1));
         if(this.FJumpQueueIfCached)
         {
            if(this.FCacheMap[param1.Url])
            {
               SLogger.TraceLoadRequest(TLogger.LEVEL_LoadStart,param1,true);
               param1.Start();
               return;
            }
         }
         if(this.FLoaderDict[param1.Priority] == null)
         {
            this.FLoaderDict[param1.Priority] = [];
            this.FLoaderPriorityLib.push(param1.Priority);
         }
         this.FLoaderDict[param1.Priority].push(param1);
         param1.addEventListener(TLoaderQueueEvent.TASK_DISPOSE,this.LoaderAdapter_DisposeHandler);
         if(!this.FTimeOutToSort.running)
         {
            this.FTimeOutToSort.start();
         }
      }
      
      public function Dispose() : void
      {
         this.RemoveAllItem();
         this.FLoaderDict = null;
         this.FLoaderPriorityLib = null;
         this.FThreadLib = null;
         this.FTimeOutToSort.stop();
         this.FTimeOutToSort.removeEventListener(TimerEvent.TIMER_COMPLETE,this.TimeOutToSort_TimerCompleteHandler);
         this.FTimeOutToSort = null;
         this.FTimeBlock.stop();
         this.FTimeBlock.removeEventListener(TimerEvent.TIMER,this.TimeBlockHandler);
         this.FTimeBlock = null;
      }
      
      public function RemoveAllItem() : void
      {
         var _loc1_:uint = 0;
         for each(_loc1_ in this.FLoaderPriorityLib)
         {
            this.RemoveItemByPriority(_loc1_);
         }
      }
      
      public function RemoveItem(param1:ILoaderAdapter) : void
      {
         this.DisposeItem(param1);
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_REMOVED,param1));
      }
      
      public function RemoveItemByPriority(param1:uint) : void
      {
         var _loc2_:ILoaderAdapter = null;
         for each(_loc2_ in this.FLoaderDict[param1])
         {
            this.RemoveItem(_loc2_);
         }
      }
      
      public function SaveItemByPriority(param1:uint) : void
      {
         var _loc2_:ILoaderAdapter = null;
         for each(_loc2_ in this.FLoaderDict[param1])
         {
            if(_loc2_.Priority != param1)
            {
               this.RemoveItem(_loc2_);
            }
         }
      }
   }
}

