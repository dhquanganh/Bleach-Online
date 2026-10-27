package Foundation.Resources.Repositories
{
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Maps.TMaps;
   import Foundation.Resources.Streamization.Map.TResourceLoaderMap;
   
   public class TResourceRepositoryMap extends TResourceRepository
   {
      
      public function TResourceRepositoryMap(param1:String, param2:uint)
      {
         super(param1,param2);
      }
      
      override protected function ConstructLoaders() : void
      {
         FLoaderPrimary = new TResourceLoaderMap(FResourcePath,".bin",FPoolResourceRequest,TYPE_Primary,FPriority);
         FLoaderPrimary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         FLoaderPrimary.OnLoadFailedResource = ProcessorLoadFailedResources;
         FLoaderSecondary = new TResourceLoaderMap(FResourcePath,".bin",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         FLoaderSecondary.OnLoadFailedResource = ProcessorLoadFailedResources;
      }
      
      override protected function LoadersOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         var _loc3_:TMaps = null;
         _loc3_ = param2 as TMaps;
         FResources.Add(_loc3_);
      }
      
      public function GetMapsByResourceID(param1:uint) : TMaps
      {
         return FResources.GetEntityByIdentifier(param1) as TMaps;
      }
   }
}

