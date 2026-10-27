package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TWindowActiveList extends TWindowActiveListBase
   {
      
      public function TWindowActiveList(param1:TUIComponent, param2:TUIComponent)
      {
         super(param1,param2);
         FActivityModes = SLogicsCore.ActivityModes;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_ACTIVELISTS;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_ActiveList_Btns;
         super.Resources_UIDispatch();
      }
   }
}

