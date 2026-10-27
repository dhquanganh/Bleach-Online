package Logics.SoulCollection
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSoulCollectionShop extends TDatebaseVO
   {
      
      protected var FID:uint;
      
      protected var FExchangeReward:Object;
      
      protected var FFrequency:uint;
      
      public function TSoulCollectionShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FExchangeReward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FFrequency = param1.readUnsignedInt();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function get ExchangeReward() : Object
      {
         return this.FExchangeReward;
      }
      
      public function get Frequency() : uint
      {
         return this.FFrequency;
      }
   }
}

