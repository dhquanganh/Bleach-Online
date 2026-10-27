package Foundation.Resources.Repositories
{
   import Foundation.Resources.Streamization.XML.TResourceLoaderXml;
   import Foundation.Resources.XML.TXml;
   
   public class TResourceRepositoryXml extends TResourceRepository
   {
      
      public function TResourceRepositoryXml(param1:String, param2:uint)
      {
         super(param1,param2);
      }
      
      override protected function ConstructLoaders() : void
      {
         FLoaderPrimary = new TResourceLoaderXml(FResourcePath,".bin",FPoolResourceRequest,TYPE_Primary,FPriority);
         FLoaderPrimary.OnResourceUnstreamized = LoadersOnResourceUnstreamized;
         FLoaderPrimary.OnLoadFailedResource = ProcessorLoadFailedResources;
         FLoaderSecondary = new TResourceLoaderXml(FResourcePath,".bin",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnResourceUnstreamized = LoadersOnResourceUnstreamized;
         FLoaderSecondary.OnLoadFailedResource = ProcessorLoadFailedResources;
      }
      
      public function GetXMLByIdentifier(param1:uint) : TXml
      {
         return FResources.GetEntityByIdentifier(param1) as TXml;
      }
   }
}

