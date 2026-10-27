package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TOrgPointAward extends TDatebaseVO
   {
      
      protected var FArr:Array;
      
      public function TOrgPointAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FArr = Json.decode(_loc2_) as Array;
      }
      
      public function get Arr() : Array
      {
         return this.FArr;
      }
   }
}

