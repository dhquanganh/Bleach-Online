package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBeauty extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FRewardType:Vector.<int>;
      
      protected var FRewardCode:Vector.<int>;
      
      protected var FClothesID:Vector.<int>;
      
      protected var FDay:int;
      
      protected var FSuccessText:Vector.<String>;
      
      protected var FFailText:String;
      
      public function TBeauty()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FName = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FRewardType = new Vector.<int>();
         this.FRewardCode = new Vector.<int>();
         _loc5_ = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FRewardType.push(_loc3_[_loc4_].type);
            this.FRewardCode.push([_loc4_].code);
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FClothesID = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FSuccessText = Vector.<String>(_loc3_);
         this.FFailText = TUtilityString.FetchUTF(param1);
         this.FDay = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get ClothesID() : Vector.<int>
      {
         return this.FClothesID;
      }
      
      public function get Day() : int
      {
         return this.FDay;
      }
      
      public function get RewardType() : Vector.<int>
      {
         return this.FRewardType;
      }
      
      public function get RewardCode() : Vector.<int>
      {
         return this.FRewardCode;
      }
      
      public function get SuccessText() : Vector.<String>
      {
         return this.FSuccessText;
      }
      
      public function get FailText() : String
      {
         return this.FFailText;
      }
   }
}

