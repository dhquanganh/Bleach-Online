package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChildrenDayCollect extends THDActivityBase
   {
      
      protected var FItems:Vector.<Object>;
      
      public function THDChildrenDayCollect()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
   }
}

