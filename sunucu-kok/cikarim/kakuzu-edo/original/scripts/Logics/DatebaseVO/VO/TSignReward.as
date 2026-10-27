package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSignReward extends TDatebaseVO
   {
      
      protected var FDay:int;
      
      protected var FDesc:String;
      
      protected var FSignForReward:TRewards;
      
      public function TSignReward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FDay = param1.readUnsignedInt();
         this.FDesc = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FSignForReward = new TRewards(_loc2_);
      }
      
      public function get Day() : int
      {
         return this.FDay;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get SignForReward() : TRewards
      {
         return this.FSignForReward;
      }
   }
}

