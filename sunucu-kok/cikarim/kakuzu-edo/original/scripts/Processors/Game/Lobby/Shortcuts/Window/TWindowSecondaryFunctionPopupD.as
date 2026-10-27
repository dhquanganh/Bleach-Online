package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TWindowSecondaryFunctionPopupD extends TWindowPopupBase
   {
      
      public function TWindowSecondaryFunctionPopupD(param1:TUIComponent)
      {
         super(param1);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunctionD;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctionDs;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionD_Btns;
         super.Resources_UIDispatch();
      }
   }
}

