package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TWindowSecondaryFunctionPopupA extends TWindowPopupBase
   {
      
      public function TWindowSecondaryFunctionPopupA(param1:TUIComponent)
      {
         super(param1);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunctionA;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctionAs;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionA_Btns;
         super.Resources_UIDispatch();
      }
   }
}

