package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TDialogueScript extends TDatebaseVO
   {
      
      protected var FTalk:String;
      
      public function TDialogueScript()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FTalk = TUtilityString.FetchUTF(param1);
      }
      
      public function get Talk() : String
      {
         return this.FTalk;
      }
      
      public function GetDecode() : *
      {
         return Json.decode(this.FTalk);
      }
   }
}

