package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDYellowDiamonGiftBagFreshBag extends THDYellowDiamonGiftBag
   {
      
      protected var FGold:Vector.<int>;
      
      public function THDYellowDiamonGiftBagFreshBag()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FGold = Vector.<int>(Json.decode(_loc2_));
      }
      
      public function get Gold() : Vector.<int>
      {
         return this.FGold;
      }
   }
}

