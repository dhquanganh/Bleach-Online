package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TWindowSecondaryFunctionPopupC extends TWindowPopupBase
   {
      
      public function TWindowSecondaryFunctionPopupC(param1:TUIComponent)
      {
         super(param1);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunctionC;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctionCs;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionC_Btns;
         super.Resources_UIDispatch();
         FIsEffects[1] = true;
         FIsEffects[2] = true;
      }
   }
}

