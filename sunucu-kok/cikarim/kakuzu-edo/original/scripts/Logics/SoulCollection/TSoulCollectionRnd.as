package Logics.SoulCollection
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSoulCollectionRnd extends TDatebaseVO
   {
      
      protected var FType:uint;
      
      protected var FReward:Object;
      
      public function TSoulCollectionRnd()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FType = param1.readUnsignedInt();
         this.FReward = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get Reward() : Object
      {
         return this.FReward;
      }
   }
}

