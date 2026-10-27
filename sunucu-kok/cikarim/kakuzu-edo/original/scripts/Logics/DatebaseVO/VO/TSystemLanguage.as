package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSystemLanguage extends TDatebaseVO
   {
      
      protected var FDesc:String;
      
      public function TSystemLanguage()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
   }
}

