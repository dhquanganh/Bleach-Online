package Processors.Accessories
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Processors.TProcessor;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOADING;
   
   public class TProcessorResourcesVital extends TProcessor
   {
      
      public function TProcessorResourcesVital(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_LOADING.RESOURCESID_SwfVital_MainLoading);
         SResourcesCore.TexturesVital.LoadPrimary(CONST_LOADING.RESOURCESID_TexturesVital_GirlBikini);
         SResourcesCore.ResourceBin.LoadPrimary(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         super.ResourcesPerform_UIRequest();
      }
   }
}

