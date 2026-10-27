package Foundation.Resources.Streamization
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.LoaderQueue.*;
   import Foundation.Registries.*;
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Spaces.*;
   import Foundation.Timing.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Resources.Constants.CONST_COMMON;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   
   use namespace ResourcesSpace;
   
   public class TResourceLoader extends EventDispatcher
   {
      
      protected static var FLoaderQueue:TLoaderQueue;
      
      protected static var FLoaderProgress:TLoaderProgress;
      
      protected static var FCurrentPercentage:uint;
      
      protected static var FCurrentKbps:uint;
      
      protected static var MAX_SYNC:uint = CONST_COMMON.MAX_SYNC;
      
      protected static const LOADINGSTATE_Failure:int = -1;
      
      protected static const LOADINGSTATE_Idle:uint = 0;
      
      protected static const LOADINGSTATE_Request:uint = 1;
      
      protected static const LOADINGSTATE_Wait:uint = 2;
      
      protected static const LOADINGSTATE_UnstreamizationRequest:uint = 3;
      
      protected static const LOADINGSTATE_UnstreamizationWait:uint = 4;
      
      protected static const LOADINGSTATE_Finalize:uint = 5;
      
      public static const TYPE_Primary:uint = 0;
      
      public static const TYPE_Secondary:uint = 1;
      
      ConstructLoader();
      
      protected var FRequests:TEntityList;
      
      protected var FRequestsLoading:TEntityList;
      
      protected var FLoaderAdaptes:Vector.<ILoaderAdapter>;
      
      protected var FLoaderAdapter:ILoaderAdapter;
      
      protected var FLoaderContext:LoaderContext;
      
      protected var FUnstreamizer:TResourceUnstreamizer;
      
      protected var FLoadingRoutines:TRegistryRoutine;
      
      protected var FLoadingState:int;
      
      protected var FLoadedRequest:TResourceRequest;
      
      protected var FLoadedStream:ByteArray;
      
      protected var FLoadedResource:TResource;
      
      protected var FResourcePath:String;
      
      protected var FResourceSuffix:String;
      
      protected var FPoolResourceRequest:TPoolResourceRequest;
      
      protected var FBytesTotal:uint;
      
      protected var FLoadType:uint;
      
      protected var FResourceConfig:Dictionary;
      
      protected var FOnResourceUnstreamized:Function;
      
      protected var FOnLoadFailedResource:Function;
      
      protected var FPriority:uint;
      
      public function TResourceLoader(param1:String, param2:String, param3:TPoolResourceRequest, param4:uint, param5:uint = 100)
      {
         super();
         this.FLoaderAdaptes = new Vector.<ILoaderAdapter>();
         this.FResourcePath = param1;
         this.FResourceSuffix = param2;
         this.FPoolResourceRequest = param3;
         this.FResourceConfig = SParametersCore.ResourceConfig;
         this.FPriority = param5;
         this.FLoadType = param4;
         this.FRequests = new TEntityList();
         this.FRequestsLoading = new TEntityList();
         this.ConstructUnstreamizer();
         this.FLoadingRoutines = new TRegistryRoutine();
         this.LoadingRegisterRoutines();
      }
      
      protected static function ConstructLoader() : void
      {
         FLoaderQueue = new TLoaderQueue(MAX_SYNC,10,true);
         FLoaderQueue.addEventListener(TLoaderQueueEvent.TASK_ERROR,LoaderOnTaskError);
         FLoaderProgress = new TLoaderProgress();
         FLoaderProgress.addEventListener(Event.CHANGE,LoaderOnProgressChange);
         FLoaderProgress.addEventListener(Event.COMPLETE,LoaderOnProgressComplete);
      }
      
      protected static function LoaderOnProgressChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:ILoaderAdapter = null;
         _loc6_ = FLoaderProgress.BytesLoaded;
         _loc5_ = FLoaderProgress.BytesTotal;
         _loc4_ = Math.floor(_loc6_ * 100 / _loc5_);
         FCurrentPercentage = _loc4_;
      }
      
      protected static function LoaderOnProgressComplete(param1:Event) : void
      {
      }
      
      protected static function LoaderOnTaskError(param1:TLoaderQueueEvent) : void
      {
      }
      
      protected function AddEventListener(param1:ILoaderAdapter) : void
      {
         param1.addEventListener(TLoaderQueueEvent.TASK_COMPLETED,this.LoaderAdapterOnComplete);
         param1.addEventListener(TLoaderQueueEvent.TASK_ERROR,this.LoaderAdapterOnError);
      }
      
      protected function RemoveEventListener(param1:ILoaderAdapter) : void
      {
         param1.removeEventListener(TLoaderQueueEvent.TASK_COMPLETED,this.LoaderAdapterOnComplete);
         param1.removeEventListener(TLoaderQueueEvent.TASK_ERROR,this.LoaderAdapterOnError);
      }
      
      protected function ConstructLoaderAdapter(param1:URLRequest) : ILoaderAdapter
      {
         return null;
      }
      
      protected function ConstructUnstreamizer() : void
      {
      }
      
      protected function ResourceURL(param1:TResourceRequest) : String
      {
         return this.FResourcePath + TUtilityHexadecimal.Format(param1.Identifier,8) + this.FResourceSuffix;
      }
      
      protected function ResourceInstantialize(param1:TResourceRequest) : TResource
      {
         return null;
      }
      
      protected function ResourceNotifyUnstreamized(param1:TResource) : void
      {
         if(this.FOnResourceUnstreamized != null)
         {
            this.FOnResourceUnstreamized(this,param1);
         }
      }
      
      protected function LoadingRegisterRoutines() : void
      {
         this.FLoadingRoutines.Register(LOADINGSTATE_Failure,this.LoadingPerform_Failure);
         this.FLoadingRoutines.Register(LOADINGSTATE_Idle,this.LoadingPerform_Idle);
         this.FLoadingRoutines.Register(LOADINGSTATE_Request,this.LoadingPerform_Request);
         this.FLoadingRoutines.Register(LOADINGSTATE_Wait,this.LoadingPerform_Wait);
         this.FLoadingRoutines.Register(LOADINGSTATE_UnstreamizationRequest,this.LoadingPerform_UnstreamizationRequest);
         this.FLoadingRoutines.Register(LOADINGSTATE_UnstreamizationWait,this.LoadingPerform_UnstreamizationWait);
         this.FLoadingRoutines.Register(LOADINGSTATE_Finalize,this.LoadingPerform_Finalize);
      }
      
      protected function LoadingPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         do
         {
            _loc1_ = this.FLoadingState;
            _loc2_ = this.FLoadingRoutines.GetRoutineByIndentifier(this.FLoadingState);
            if(_loc2_ != null)
            {
               _loc2_();
            }
         }
         while(_loc1_ != this.FLoadingState);
      }
      
      protected function LoadingPerform_Failure() : void
      {
      }
      
      protected function LoadingPerform_Idle() : void
      {
         if(this.FRequests.Count != 0)
         {
            this.FLoadingState = LOADINGSTATE_Request;
         }
      }
      
      protected function LoadingPerform_Request() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:URLRequest = null;
         var _loc5_:String = null;
         var _loc6_:TResourceRequest = null;
         var _loc7_:ILoaderAdapter = null;
         var _loc8_:int = 0;
         _loc2_ = this.FRequests.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FRequests.GetEntityByIndex(_loc1_) as TResourceRequest;
            _loc8_ = this.FRequestsLoading.IndexOf(_loc6_);
            if(_loc8_ < 0)
            {
               _loc3_ = this.ResourceURL(_loc6_);
               if(this.FResourceConfig)
               {
                  _loc5_ = this.FResourceConfig[_loc3_];
               }
               if(_loc5_ == null)
               {
                  if(SParametersCore.ClientVersion == 0)
                  {
                     _loc5_ = "";
                  }
                  else
                  {
                     _loc5_ = SParametersCore.ClientVersion.toString();
                  }
               }
               if(_loc5_.length > 0)
               {
                  _loc3_ = _loc5_ + "/" + _loc3_;
               }
               _loc3_ = SParametersCore.CdnRoot + _loc3_;
               _loc4_ = new URLRequest();
               _loc4_.url = _loc3_;
               _loc7_ = this.ConstructLoaderAdapter(_loc4_);
               _loc7_.Identifier = _loc6_.Identifier;
               _loc7_.StartTime = STimingCore.TickCount;
               if(this.FLoadType == TYPE_Primary)
               {
                  FLoaderProgress.AddItem(_loc7_);
                  if(!FLoaderProgress.IsStarted)
                  {
                     FLoaderProgress.Start();
                  }
               }
               this.AddEventListener(_loc7_);
               FLoaderQueue.AddItem(_loc7_);
               this.FRequestsLoading.Add(_loc6_);
               return;
            }
            _loc1_++;
         }
         this.FLoadingState = LOADINGSTATE_Wait;
      }
      
      protected function LoadingPerform_Wait() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ILoaderAdapter = null;
         this.FLoaderAdapter = null;
         _loc2_ = int(this.FLoaderAdaptes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FLoaderAdaptes[_loc1_];
            if(_loc3_.IsCompleted)
            {
               this.FLoaderAdapter = _loc3_;
               this.FLoadedRequest = this.FRequests.GetEntityByIdentifier(_loc3_.Identifier) as TResourceRequest;
               break;
            }
            _loc1_++;
         }
      }
      
      protected function LoadingPerform_UnstreamizationRequest() : void
      {
         this.FLoadedResource = this.ResourceInstantialize(this.FLoadedRequest);
         this.FUnstreamizer.Unstreamize(this.FLoadedStream,this.FLoadedResource,null);
         this.FLoadingState = LOADINGSTATE_UnstreamizationWait;
      }
      
      protected function LoadingPerform_UnstreamizationWait() : void
      {
         this.FUnstreamizer.Process();
         if(this.FUnstreamizer.Unstreamizing)
         {
            return;
         }
         this.FLoadingState = LOADINGSTATE_Finalize;
      }
      
      protected function LoadingPerform_Finalize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TResourceRequest = null;
         var _loc3_:ILoaderAdapter = null;
         _loc3_ = this.FLoaderAdapter;
         _loc1_ = this.FLoaderAdaptes.indexOf(_loc3_);
         if(_loc1_ >= 0)
         {
            this.FLoaderAdaptes.splice(_loc1_,1);
         }
         _loc2_ = this.FRequests.GetEntityByIdentifier(_loc3_.Identifier) as TResourceRequest;
         _loc1_ = this.FRequests.IndexOf(_loc2_);
         this.FRequests.Delete(_loc1_);
         _loc2_ = this.FRequestsLoading.GetEntityByIdentifier(_loc3_.Identifier) as TResourceRequest;
         _loc1_ = this.FRequestsLoading.IndexOf(_loc2_);
         this.FRequestsLoading.Delete(_loc1_);
         if(this.FLoadType == TYPE_Primary)
         {
            FLoaderProgress.RemoveItem(_loc3_);
         }
         FLoaderQueue.RemoveItem(_loc3_);
         _loc3_.Dispose();
         this.FLoadedRequest = null;
         this.FLoadedStream = null;
         this.FLoadedResource = null;
         this.FLoaderAdapter = null;
         this.FLoaderContext = null;
         this.FLoadingState = LOADINGSTATE_Idle;
      }
      
      protected function LoaderAdapterOnComplete(param1:TLoaderQueueEvent) : void
      {
         var _loc2_:ILoaderAdapter = null;
         _loc2_ = param1.target as ILoaderAdapter;
         this.RemoveEventListener(_loc2_);
         this.FLoaderAdaptes.push(_loc2_);
      }
      
      protected function LoaderAdapterOnError(param1:TLoaderQueueEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TResourceRequest = null;
         var _loc5_:ILoaderAdapter = null;
         _loc5_ = param1.target as ILoaderAdapter;
         this.RemoveEventListener(_loc5_);
         _loc3_ = _loc5_.Identifier;
         _loc4_ = this.FRequests.GetEntityByIdentifier(_loc3_) as TResourceRequest;
         _loc2_ = this.FRequests.IndexOf(_loc4_);
         this.FRequests.Delete(_loc2_);
         _loc4_ = this.FRequestsLoading.GetEntityByIdentifier(_loc3_) as TResourceRequest;
         _loc2_ = this.FRequestsLoading.IndexOf(_loc4_);
         this.FRequestsLoading.Delete(_loc2_);
         if(this.FLoadType == TYPE_Primary)
         {
            FLoaderProgress.RemoveItem(_loc5_);
         }
         if(this.FLoadingState != LOADINGSTATE_UnstreamizationWait)
         {
            if(this.FRequests.Count != 0)
            {
               this.FLoadingState = LOADINGSTATE_Request;
            }
            else if(this.FRequestsLoading.Count != 0)
            {
               this.FLoadingState = LOADINGSTATE_Wait;
            }
            else
            {
               this.FLoadingState = LOADINGSTATE_Idle;
            }
         }
         if(this.FOnLoadFailedResource != null)
         {
            this.FOnLoadFailedResource(this,_loc3_);
         }
         _loc5_.Dispose();
         _loc5_ = null;
      }
      
      protected function UnstreamizerOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         this.ResourceNotifyUnstreamized(param2);
      }
      
      public function get Count() : int
      {
         return this.FRequests.Count;
      }
      
      public function get OnResourceUnstreamized() : Function
      {
         return this.FOnResourceUnstreamized;
      }
      
      public function set OnResourceUnstreamized(param1:Function) : void
      {
         this.FOnResourceUnstreamized = param1;
      }
      
      public function get OnLoadFailedResource() : Function
      {
         return this.FOnLoadFailedResource;
      }
      
      public function set OnLoadFailedResource(param1:Function) : void
      {
         this.FOnLoadFailedResource = param1;
      }
      
      public function get CurrentPercentage() : uint
      {
         return FCurrentPercentage;
      }
      
      public function get CurrentKbps() : uint
      {
         return FCurrentKbps;
      }
      
      public function get Priority() : uint
      {
         return this.FPriority;
      }
      
      public function Process() : void
      {
         this.LoadingPerform();
      }
      
      public function Load(param1:uint) : void
      {
         var _loc2_:TResourceRequest = null;
         _loc2_ = this.FPoolResourceRequest.Acquire(param1);
         this.FRequests.Add(_loc2_);
      }
      
      public function ResourceRequestedByIdentifier(param1:uint) : Boolean
      {
         return this.FRequests.GetEntityByIdentifier(param1) != null;
      }
   }
}

