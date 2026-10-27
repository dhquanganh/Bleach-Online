package Logics.SoulCollection
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSoulCollectionBase extends TDatebaseVO
   {
      
      protected var FLotteryConsume:Object;
      
      public function TSoulCollectionBase()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FLotteryConsume = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get LotteryConsume() : Object
      {
         return this.FLotteryConsume;
      }
   }
}

