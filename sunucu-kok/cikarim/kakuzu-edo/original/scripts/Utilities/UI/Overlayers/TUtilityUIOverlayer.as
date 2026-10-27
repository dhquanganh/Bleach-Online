package Utilities.UI.Overlayers
{
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Rendering.Overlayers.TOverlayer;
   
   public class TUtilityUIOverlayer
   {
      
      public function TUtilityUIOverlayer()
      {
         super();
      }
      
      protected static function ResourcesDispatchSubstrate(param1:TOverlayer) : void
      {
         param1.AnimationSubstrate = SUtilityResource.BtmDataTipsBG;
         param1.DividingLine = SUtilityResource.BtmDataDividingLine;
         param1.ResourcesUpdate();
      }
      
      public static function ResourcesDispatch(param1:TOverlayer) : void
      {
         ResourcesDispatchSubstrate(param1);
      }
   }
}

