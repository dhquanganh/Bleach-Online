package Foundation.Resources.Streamization.Bin
{
   import Foundation.LoaderQueue.Adapter.TURLLoaderAdapter;
   import Foundation.LoaderQueue.ILoaderAdapter;
   import Foundation.Resources.Common.TPoolResourceRequest;
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Common.TResourceRequest;
   import Foundation.Resources.Streamization.TResourceLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class TResourceLoaderBinPackage extends TResourceLoader
   {
      
      public function TResourceLoaderBinPackage(param1:String, param2:String, param3:TPoolResourceRequest, param4:uint, param5:uint)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function ConstructLoaderAdapter(param1:URLRequest) : ILoaderAdapter
      {
         return new TURLLoaderAdapter(FPriority,param1);
      }
      
      override protected function ConstructUnstreamizer() : void
      {
         FUnstreamizer = new TResourceUnstreamizerBinPackage();
         FUnstreamizer.OnResourceUnstreamized = this.UnstreamizerOnResourceUnstreamized;
      }
      
      override protected function ResourceInstantialize(param1:TResourceRequest) : TResource
      {
         return null;
      }
      
      override protected function LoadingPerform_Wait() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:TURLLoaderAdapter = null;
         super.LoadingPerform_Wait();
         if(FLoaderAdapter == null)
         {
            return;
         }
         _loc2_ = FLoaderAdapter as TURLLoaderAdapter;
         _loc1_ = _loc2_.Data;
         if(_loc1_ != null)
         {
            _loc1_.endian = Endian.LITTLE_ENDIAN;
            FLoadedStream = _loc1_;
            FLoadedStream.position = 0;
            FLoadingState = LOADINGSTATE_UnstreamizationRequest;
         }
      }
      
      override protected function LoadingPerform_UnstreamizationRequest() : void
      {
         FUnstreamizer.Unstreamize(FLoadedStream,null,FLoadedRequest);
         FLoadingState = LOADINGSTATE_UnstreamizationWait;
      }
      
      override protected function UnstreamizerOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         ResourceNotifyUnstreamized(param2);
      }
   }
}

