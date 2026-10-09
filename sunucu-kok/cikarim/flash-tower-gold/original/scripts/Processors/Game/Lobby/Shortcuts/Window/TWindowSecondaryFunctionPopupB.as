package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TWindowSecondaryFunctionPopupB extends TWindowPopupBase
   {
      
      public function TWindowSecondaryFunctionPopupB(param1:TUIComponent)
      {
         super(param1);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunctionB;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctionBs;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionB_Btns;
         super.Resources_UIDispatch();
      }
   }
}

