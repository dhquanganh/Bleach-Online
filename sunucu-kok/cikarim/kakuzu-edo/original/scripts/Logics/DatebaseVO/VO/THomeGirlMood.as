package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THomeGirlMood extends TDatebaseVO
   {
      
      protected var FMood:int;
      
      protected var FNormalCommunicateReward:TFixedAward;
      
      protected var FGoldCommunicateReward:TFixedAward;
      
      public function THomeGirlMood()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         this.FMood = param1.readInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc4_);
         this.FNormalCommunicateReward = new TFixedAward(_loc2_[0]);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc4_);
         this.FGoldCommunicateReward = new TFixedAward(_loc2_[0]);
      }
      
      public function get Mood() : int
      {
         return this.FMood;
      }
      
      public function get NormalCommunicateReward() : TFixedAward
      {
         return this.FNormalCommunicateReward;
      }
      
      public function get GoldCommunicateReward() : TFixedAward
      {
         return this.FGoldCommunicateReward;
      }
   }
}

