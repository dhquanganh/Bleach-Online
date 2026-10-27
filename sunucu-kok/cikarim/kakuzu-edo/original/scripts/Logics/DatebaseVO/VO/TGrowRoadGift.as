package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TGrowRoadGift extends TDatebaseVO
   {
      
      protected var FAccept:int;
      
      protected var FReward:Vector.<int>;
      
      protected var FImageIcon:Vector.<int>;
      
      protected var FVipLimit:Vector.<int>;
      
      protected var FRewardDiscount:Vector.<int>;
      
      protected var FRewardOriginal:Vector.<int>;
      
      protected var FRewardPrice:Vector.<int>;
      
      public function TGrowRoadGift()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         this.FAccept = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FReward = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FImageIcon = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FVipLimit = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FRewardDiscount = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FRewardOriginal = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FRewardPrice = Vector.<int>(_loc3_);
      }
      
      public function get Accept() : int
      {
         return this.FAccept;
      }
      
      public function get Reward() : Vector.<int>
      {
         return this.FReward;
      }
      
      public function get ImageIcon() : Vector.<int>
      {
         return this.FImageIcon;
      }
      
      public function get VipLimit() : Vector.<int>
      {
         return this.FVipLimit;
      }
      
      public function get RewardDiscount() : Vector.<int>
      {
         return this.FRewardDiscount;
      }
      
      public function get RewardOriginal() : Vector.<int>
      {
         return this.FRewardOriginal;
      }
      
      public function get RewardPrice() : Vector.<int>
      {
         return this.FRewardPrice;
      }
   }
}

