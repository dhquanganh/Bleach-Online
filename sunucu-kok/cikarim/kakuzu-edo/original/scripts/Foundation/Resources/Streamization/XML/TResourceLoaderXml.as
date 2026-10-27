package Foundation.Resources.Streamization.XML
{
   import Foundation.Resources.Common.TPoolResourceRequest;
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Common.TResourceRequest;
   import Foundation.Resources.Streamization.TResourceLoader;
   import Foundation.Resources.XML.TXml;
   
   public class TResourceLoaderXml extends TResourceLoader
   {
      
      public function TResourceLoaderXml(param1:String, param2:String, param3:TPoolResourceRequest, param4:uint, param5:uint)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function ConstructUnstreamizer() : void
      {
         FUnstreamizer = new TResourceUnstreamizerXml();
         FUnstreamizer.OnResourceUnstreamized = UnstreamizerOnResourceUnstreamized;
      }
      
      override protected function ResourceInstantialize(param1:TResourceRequest) : TResource
      {
         return new TXml(param1.Identifier);
      }
   }
}

