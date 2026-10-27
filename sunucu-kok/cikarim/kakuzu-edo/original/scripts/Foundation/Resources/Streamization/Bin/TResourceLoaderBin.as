package Foundation.Resources.Streamization.Bin
{
   import Foundation.LoaderQueue.Adapter.TURLLoaderAdapter;
   import Foundation.LoaderQueue.ILoaderAdapter;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Common.TPoolResourceRequest;
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Common.TResourceRequest;
   import Foundation.Resources.Streamization.TResourceLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class TResourceLoaderBin extends TResourceLoader
   {
      
      public function TResourceLoaderBin(param1:String, param2:String, param3:TPoolResourceRequest, param4:uint, param5:uint)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function ConstructLoaderAdapter(param1:URLRequest) : ILoaderAdapter
      {
         return new TURLLoaderAdapter(FPriority,param1);
      }
      
      override protected function ConstructUnstreamizer() : void
      {
         FUnstreamizer = new TResourceUnstreamizerBin();
         FUnstreamizer.OnResourceUnstreamized = UnstreamizerOnResourceUnstreamized;
      }
      
      override protected function ResourceInstantialize(param1:TResourceRequest) : TResource
      {
         return new TBins(param1.Identifier);
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
   }
}

