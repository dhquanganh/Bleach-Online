package Processors.Game.Common
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.TProcessorGame;
   
   public class TProcessorMountPoint extends TProcessorGame
   {
      
      public function TProcessorMountPoint(param1:TUIComponent)
      {
         super(param1);
         FResourcesState = RESOURCESSTATE_Ready;
      }
   }
}

