package Utilities.UI.Marquees
{
   import Components.HyperStrings.TUIHyperStringMarquee;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   
   public class TUtilityUIMarquee
   {
      
      public function TUtilityUIMarquee()
      {
         super();
      }
      
      protected static function ResourcesDispatchSubstrate(param1:TUIHyperStringMarquee) : void
      {
         param1.AnimationSubstrate = SUtilityResource.BtmDataTipsBG;
         param1.Btn_Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_Btn_Close) as MovieClip;
         param1.ResourcesUpdate();
      }
      
      public static function ResourcesDispatch(param1:TUIHyperStringMarquee) : void
      {
         ResourcesDispatchSubstrate(param1);
      }
   }
}

