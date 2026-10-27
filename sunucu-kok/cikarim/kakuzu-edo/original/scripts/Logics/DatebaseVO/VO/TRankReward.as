package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRankReward extends TDatebaseVO
   {
      
      protected var FTips:String;
      
      public function TRankReward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FTips = TUtilityString.FetchUTF(param1);
      }
      
      public function get Tips() : String
      {
         return this.FTips;
      }
   }
}

