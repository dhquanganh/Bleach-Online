package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSevenHeroDailyAward extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FFreeCount:uint;
      
      protected var FRewards:String;
      
      protected var FCost:Vector.<int>;
      
      protected var FCrit:String;
      
      protected var FStarame:String;
      
      protected var FTips:String;
      
      protected var FRewardVect:Vector.<Object>;
      
      protected var FCostVect:Array;
      
      public function TSevenHeroDailyAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FFreeCount = param1.readUnsignedInt();
         this.FRewards = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         this.FCost = Vector.<int>(Json.decode(_loc4_));
         this.FCrit = TUtilityString.FetchUTF(param1);
         this.FStarame = TUtilityString.FetchUTF(param1);
         this.FTips = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FRewards);
         this.FRewardVect = Vector.<Object>(_loc2_);
         this.FCostVect = _loc4_.split(",") as Array;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get FreeCount() : uint
      {
         return this.FFreeCount;
      }
      
      public function get Rewards() : String
      {
         return this.FRewards;
      }
      
      public function get Cost() : Vector.<int>
      {
         return this.FCost;
      }
      
      public function get Crit() : String
      {
         return this.FCrit;
      }
      
      public function get Starame() : String
      {
         return this.FStarame;
      }
      
      public function get Tips() : String
      {
         return this.FTips;
      }
      
      public function get RewardVect() : Vector.<Object>
      {
         return this.FRewardVect;
      }
      
      public function get CostVect() : Array
      {
         return this.FCostVect;
      }
   }
}

