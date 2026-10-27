package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRelatedCondition extends TDatebaseVO
   {
      
      protected var FCondition:String;
      
      protected var FCondtionHtml:String;
      
      public function TRelatedCondition()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCondition = TUtilityString.FetchUTF(param1);
         this.FCondtionHtml = TUtilityString.FetchUTF(param1);
      }
      
      public function get Described() : String
      {
         return this.FCondition;
      }
      
      public function get CondtionHtml() : String
      {
         return this.FCondtionHtml;
      }
   }
}

