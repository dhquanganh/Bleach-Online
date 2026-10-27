package Logics.Streamization.FreshGuide
{
   import Foundation.Registries.TRegistryInstance;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TFreshGuide;
   import Logics.FreshGuide.TFreshStep;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerFreshGuide extends TUnstreamizer
   {
      
      public function TUnstreamizerFreshGuide()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBins = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TFreshGuide = null;
         var _loc8_:TRegistryInstance = null;
         var _loc9_:TFreshStep = null;
         var _loc10_:TRegistryInstance = null;
         _loc10_ = param2 as TRegistryInstance;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_FreshGuide);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.Count)
         {
            _loc7_ = _loc4_.GetDatebaseByIndex(_loc5_) as TFreshGuide;
            _loc9_ = new TFreshStep(_loc7_.TriggerEventID);
            _loc9_.MC_ID = _loc7_.MC_ID;
            _loc9_.TriggerEventID = _loc7_.TriggerEventID;
            _loc9_.SpecialHandle = _loc7_.SpecialHandle;
            _loc9_.GuideMessage = _loc7_.GuideMessage;
            _loc9_.GuideDetial = _loc7_.GuideDetail;
            _loc9_.CompleteCondition = _loc7_.CompleteCondition;
            _loc9_.GenerateLocalID = _loc7_.GenerateLocalID;
            _loc9_.GenerateServerID = _loc7_.GenerateServerID;
            _loc9_.ArrowX = _loc7_.ArrowX;
            _loc9_.ArrowY = _loc7_.ArrowY;
            _loc9_.JmpTriggerID = _loc7_.JmpTriggerID;
            _loc9_.JmpGenerateCode = _loc7_.JmpGenerateCode;
            if(_loc7_.TaskStartFlag)
            {
               _loc8_ = new TRegistryInstance();
               _loc10_.Register(_loc7_.TriggerEventID,_loc8_);
            }
            _loc8_.Register(_loc7_.TriggerEventID,_loc9_);
            _loc5_++;
         }
      }
   }
}

