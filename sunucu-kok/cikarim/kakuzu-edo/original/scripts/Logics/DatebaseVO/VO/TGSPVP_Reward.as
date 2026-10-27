package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGSPVP_Reward extends TDatebaseVO
   {
      
      protected var FFrom:int;
      
      protected var FTo:int;
      
      protected var FRewards:TRewards;
      
      public function TGSPVP_Reward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FFrom = param1.readInt();
         this.FTo = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FRewards = new TRewards(_loc2_);
      }
      
      public function get Rewards() : TRewards
      {
         return this.FRewards;
      }
      
      public function get From() : int
      {
         return this.FFrom;
      }
      
      public function get To() : int
      {
         return this.FTo;
      }
   }
}

