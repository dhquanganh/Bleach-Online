package Processors.Game.Lobby.Chat.HyperString.Data
{
   import Foundation.Utilities.TUtilityString;
   import Logics.HyperStrings.Elements.THyperStringElementLinkItem;
   import Logics.HyperStrings.Elements.THyperStringElementTextual;
   import Rendering.HyperStrings.Data.THyperStringFormatSheet;
   import Resources.Constants.CONST_COMMON;
   
   public class THyperStringFormatSheetChat extends THyperStringFormatSheet
   {
      
      protected static const STRING_ThinSquare:String = CONST_COMMON.STRING_ThinSquare;
      
      protected static const STRING_ThickSquare:String = CONST_COMMON.STRING_ThickSquare;
      
      public function THyperStringFormatSheetChat()
      {
         super();
      }
      
      override protected function FormattingRegisterRoutines() : void
      {
         FormattingRegisterRoutine(THyperStringElementLinkItem,this.FormattingPerform_LinkItem);
      }
      
      protected function FormattingPerform_LinkItem(param1:THyperStringElementTextual) : String
      {
         return TUtilityString.Format(STRING_ThinSquare,param1.Text);
      }
   }
}

