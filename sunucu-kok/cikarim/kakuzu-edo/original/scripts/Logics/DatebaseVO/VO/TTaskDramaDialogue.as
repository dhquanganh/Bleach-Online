package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTaskDramaDialogue extends TDatebaseVO
   {
      
      protected var FConversations:String;
      
      public function TTaskDramaDialogue()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FConversations = TUtilityString.FetchUTF(param1);
      }
      
      public function get Conversations() : String
      {
         return this.FConversations;
      }
   }
}

