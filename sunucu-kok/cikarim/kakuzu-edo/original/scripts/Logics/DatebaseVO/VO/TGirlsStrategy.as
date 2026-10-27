package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGirlsStrategy extends TDatebaseVO
   {
      
      protected var FTabName:String;
      
      protected var FContent:String;
      
      public function TGirlsStrategy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FTabName = TUtilityString.FetchUTF(param1);
         this.FContent = TUtilityString.FetchUTF(param1);
      }
      
      public function get TabName() : String
      {
         return this.FTabName;
      }
      
      public function get Content() : String
      {
         return this.FContent;
      }
   }
}

