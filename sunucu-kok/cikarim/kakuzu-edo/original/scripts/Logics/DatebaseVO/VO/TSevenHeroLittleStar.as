package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TSevenHeroStarAddValue;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSevenHeroLittleStar extends TDatebaseVO
   {
      
      protected var FBigStar:uint;
      
      protected var FSort:uint;
      
      protected var FPreLittleStar:int;
      
      protected var FIsLast:uint;
      
      protected var FCostSoulId:uint;
      
      protected var FCostSoul:uint;
      
      protected var FAddValue:String;
      
      protected var FLittleStarName:String;
      
      protected var FAddValues:Vector.<TSevenHeroStarAddValue>;
      
      public function TSevenHeroLittleStar()
      {
         super();
         this.FAddValues = new Vector.<TSevenHeroStarAddValue>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:TSevenHeroStarAddValue = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         this.FBigStar = param1.readUnsignedInt();
         this.FSort = param1.readUnsignedInt();
         this.FPreLittleStar = param1.readInt();
         this.FIsLast = param1.readUnsignedInt();
         this.FCostSoulId = param1.readUnsignedInt();
         this.FCostSoul = param1.readUnsignedInt();
         this.FAddValue = TUtilityString.FetchUTF(param1);
         this.FLittleStarName = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FAddValue) as Array;
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = new TSevenHeroStarAddValue(_loc3_[_loc4_] as Object);
            this.FAddValues[_loc4_] = _loc2_;
            _loc4_++;
         }
      }
      
      public function get BigStar() : uint
      {
         return this.FBigStar;
      }
      
      public function get Sort() : uint
      {
         return this.FSort;
      }
      
      public function get PreLittleStar() : int
      {
         return this.FPreLittleStar;
      }
      
      public function get IsLast() : uint
      {
         return this.FIsLast;
      }
      
      public function get CostSoulId() : uint
      {
         return this.FCostSoulId;
      }
      
      public function get CostSoul() : uint
      {
         return this.FCostSoul;
      }
      
      public function get LittleStarName() : String
      {
         return this.FLittleStarName;
      }
      
      public function get AddValues() : Vector.<TSevenHeroStarAddValue>
      {
         return this.FAddValues;
      }
      
      public function get AddValue() : String
      {
         return this.FAddValue;
      }
   }
}

