package Foundation.LoaderQueue.Adapter
{
   import Foundation.LoaderQueue.*;
   import Logging.*;
   import flash.events.*;
   import flash.net.*;
   
   public class AbstractLoaderAdapter extends EventDispatcher
   {
      
      protected var FLoaderContext:*;
      
      protected var FUrlRequest:URLRequest;
      
      protected var FIdentifier:uint;
      
      protected var FCustomData:*;
      
      protected var FMaxTries:int;
      
      protected var FNumTries:int;
      
      protected var FMaxTimeOutTries:int;
      
      protected var FNumTimeOutTries:int;
      
      protected var FMaxBlockTries:int;
      
      protected var FNumBlockTries:int;
      
      protected var FPriority:uint;
      
      protected var FState:String;
      
      protected var FAdapterAgent:IEventDispatcher;
      
      protected var FUrl:String;
      
      protected var FPreventCache:Boolean;
      
      protected var FLastBytesLoaded:Number;
      
      protected var FStartTime:int;
      
      protected var FEndTime:int;
      
      public function AbstractLoaderAdapter(param1:uint, param2:URLRequest, param3:* = null)
      {
         super();
         this.FPriority = param1;
         this.FUrlRequest = param2;
         this.FLoaderContext = param3;
         this.FUrl = param2.url;
         this.FMaxTries = 3;
         this.FNumTries = 0;
         this.FMaxTimeOutTries = 5;
         this.FNumTimeOutTries = 0;
         this.FMaxBlockTries = 5;
         this.FNumBlockTries = 0;
         this.FState = TLoaderAdapterState.WAITING;
         this.FPreventCache = false;
         this.FLastBytesLoaded = 0;
      }
      
      protected function GetPreventCacheURL(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1.indexOf("LoaderQueueNoCache=") >= 0)
         {
            if(param1.indexOf("?") != -1)
            {
               param1 = param1.split("?")[0];
            }
            else if(param1.indexOf("&") != -1)
            {
               param1 = param1.split("&")[0];
            }
         }
         _loc2_ = param1;
         _loc3_ = "LoaderQueueNoCache=" + new Date().getTime();
         if(_loc2_.indexOf("LoaderQueueNoCache=") == -1)
         {
            if(_loc2_.indexOf("?") != -1)
            {
               _loc2_ += "&" + _loc3_;
            }
            else
            {
               _loc2_ += "?" + _loc3_;
            }
         }
         return _loc2_;
      }
      
      protected function PreStartHandle() : void
      {
         this.State = TLoaderAdapterState.STARTED;
         if(this.FPreventCache)
         {
            this.FUrlRequest.url = this.GetPreventCacheURL(this.FUrlRequest.url);
         }
         with(this.FAdapterAgent)
         {
            addEventListener(Event.COMPLETE,Container_CompleteHandler);
            addEventListener(IOErrorEvent.DISK_ERROR,Container_ErrorHandler);
            addEventListener(IOErrorEvent.IO_ERROR,Container_ErrorHandler);
            addEventListener(IOErrorEvent.NETWORK_ERROR,Container_ErrorHandler);
         }
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_START,this.FCustomData));
      }
      
      protected function PreStopHandle() : void
      {
         this.State = TLoaderAdapterState.WAITING;
         this.RemoveAllListener();
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_STOP,this.FCustomData));
      }
      
      protected function RemoveAllListener() : void
      {
         if(this.FAdapterAgent)
         {
            this.FAdapterAgent.removeEventListener(Event.COMPLETE,this.Container_CompleteHandler);
            this.FAdapterAgent.removeEventListener(IOErrorEvent.DISK_ERROR,this.Container_ErrorHandler);
            this.FAdapterAgent.removeEventListener(IOErrorEvent.IO_ERROR,this.Container_ErrorHandler);
            this.FAdapterAgent.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.Container_ErrorHandler);
         }
      }
      
      protected function CreateErrorEvent(param1:Error) : ErrorEvent
      {
         return new ErrorEvent(TLoaderQueueEvent.TASK_ERROR,false,false,param1.message);
      }
      
      protected function Container_CompleteHandler(param1:Event) : void
      {
         this.FState = TLoaderAdapterState.COMPLETED;
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_COMPLETED,this.FCustomData));
      }
      
      protected function Container_ErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:TLoaderQueueEvent = null;
         SLogger.TraceLoadRequest(TLogger.LEVEL_LoadFailed,this,false);
         ++this.FNumTries;
         param1.stopPropagation();
         if(this.FNumTries <= this.FMaxTries)
         {
            this.RemoveAllListener();
            this.FState = TLoaderAdapterState.WAITING;
            ++SLogger.State.Retry;
            SLogger.TraceLoadRequest(TLogger.LEVEL_LoadFailureRetry,this,false);
            this.Start();
         }
         else
         {
            ++SLogger.State.Fail;
            SLogger.TraceLoadRequest(TLogger.LEVEL_LoadAbort,this,false);
            this.FState = TLoaderAdapterState.ERROR;
            _loc2_ = new TLoaderQueueEvent(TLoaderQueueEvent.TASK_ERROR,this.FCustomData);
            _loc2_.ErrorMsg = param1.text;
            dispatchEvent(_loc2_);
         }
      }
      
      protected function Container_ProgressHandler(param1:ProgressEvent) : void
      {
         var _loc2_:TLoaderQueueEvent = null;
         _loc2_ = new TLoaderQueueEvent(TLoaderQueueEvent.TASK_PROGRESS,this.FCustomData);
         _loc2_.BytesLoaded = param1.bytesLoaded;
         _loc2_.BytesTotal = param1.bytesTotal;
         dispatchEvent(_loc2_);
      }
      
      public function get Identifier() : uint
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:uint) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get CustomData() : *
      {
         return this.FCustomData;
      }
      
      public function set CustomData(param1:*) : void
      {
         this.FCustomData = param1;
      }
      
      public function get MaxTries() : int
      {
         return this.FMaxTries;
      }
      
      public function set MaxTries(param1:int) : void
      {
         this.FMaxTries = param1;
      }
      
      public function get NumTries() : int
      {
         return this.FNumTries;
      }
      
      public function get MaxTimeOutTries() : int
      {
         return this.FMaxTimeOutTries;
      }
      
      public function set MaxTimeOutTries(param1:int) : void
      {
         this.FMaxTimeOutTries = param1;
      }
      
      public function get NumTimeOutTries() : int
      {
         return this.FNumTimeOutTries;
      }
      
      public function set NumTimeOutTries(param1:int) : void
      {
         this.FNumTimeOutTries = param1;
      }
      
      public function get MaxBlockTries() : int
      {
         return this.FMaxBlockTries;
      }
      
      public function set MaxBlockTries(param1:int) : void
      {
         this.FMaxBlockTries = param1;
      }
      
      public function get NumBlockTries() : int
      {
         return this.FNumBlockTries;
      }
      
      public function set NumBlockTries(param1:int) : void
      {
         this.FNumBlockTries = param1;
      }
      
      public function get IsStarted() : Boolean
      {
         return this.FState == TLoaderAdapterState.STARTED;
      }
      
      public function get IsCompleted() : Boolean
      {
         return this.FState == TLoaderAdapterState.COMPLETED;
      }
      
      public function get Priority() : uint
      {
         return this.FPriority;
      }
      
      public function get State() : String
      {
         return this.FState;
      }
      
      public function set State(param1:String) : void
      {
         this.FState = param1;
      }
      
      protected function set AdapterAgent(param1:IEventDispatcher) : void
      {
         this.FAdapterAgent = param1;
      }
      
      protected function get AdapterAgent() : IEventDispatcher
      {
         return this.FAdapterAgent;
      }
      
      public function get Url() : String
      {
         return this.FUrl;
      }
      
      public function get PreventCache() : Boolean
      {
         return this.FPreventCache;
      }
      
      public function set PreventCache(param1:Boolean) : void
      {
         this.FPreventCache = param1;
      }
      
      public function get LastBytesLoaded() : Number
      {
         return this.FLastBytesLoaded;
      }
      
      public function set LastBytesLoaded(param1:Number) : void
      {
         this.FLastBytesLoaded = param1;
      }
      
      public function get StartTime() : int
      {
         return this.FStartTime;
      }
      
      public function set StartTime(param1:int) : void
      {
         this.FStartTime = param1;
      }
      
      public function get EndTime() : int
      {
         return this.FEndTime;
      }
      
      public function set EndTime(param1:int) : void
      {
         this.FEndTime = param1;
      }
      
      public function Start() : void
      {
         throw new Error("AbstractLoaderAdapter.Start() method is abstract " + "and must be implemented by subclasses.");
      }
      
      public function Dispose() : void
      {
         dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_DISPOSE,this.FCustomData));
         this.RemoveAllListener();
         this.FLoaderContext = null;
         this.FUrlRequest = null;
         this.FAdapterAgent = null;
      }
   }
}

