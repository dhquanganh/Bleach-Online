package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTGD_1 extends THDActivityBase
   {
      
      protected var FDayFreeGifts:Vector.<Object>;
      
      protected var FBag:Object;
      
      public function THDTGD_1()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDayFreeGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get DayFreeGifts() : Vector.<Object>
      {
         return this.FDayFreeGifts;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
   }
}

