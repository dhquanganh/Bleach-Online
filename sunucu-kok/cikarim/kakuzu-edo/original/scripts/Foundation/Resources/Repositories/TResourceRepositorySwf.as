package Foundation.Resources.Repositories
{
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.SWF.TSwf;
   import Foundation.Resources.Streamization.SWF.TResourceLoaderSwf;
   
   public class TResourceRepositorySwf extends TResourceRepository
   {
      
      public function TResourceRepositorySwf(param1:String, param2:uint)
      {
         super(param1,param2);
      }
      
      override protected function ConstructLoaders() : void
      {
         FLoaderPrimary = new TResourceLoaderSwf(FResourcePath,".swf",FPoolResourceRequest,TYPE_Primary,FPriority);
         FLoaderPrimary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         FLoaderPrimary.OnLoadFailedResource = ProcessorLoadFailedResources;
         FLoaderSecondary = new TResourceLoaderSwf(FResourcePath,".swf",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         FLoaderSecondary.OnLoadFailedResource = ProcessorLoadFailedResources;
      }
      
      override protected function LoadersOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         FResources.Add(param2);
      }
      
      public function GetSWFByIdentifier(param1:uint) : TSwf
      {
         return null;
      }
   }
}

