package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TSevenHeroStarAddValue;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSevenHeroStar extends TDatebaseVO
   {
      
      protected var FPosition:uint;
      
      protected var FSevenHeroId:uint;
      
      protected var FHeroName:String;
      
      protected var FDesc:String;
      
      protected var FFinalStarName:String;
      
      protected var FAddValue:String;
      
      protected var FAddValues:Vector.<TSevenHeroStarAddValue>;
      
      public function TSevenHeroStar()
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
         this.FPosition = param1.readUnsignedInt();
         this.FSevenHeroId = param1.readUnsignedInt();
         this.FHeroName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FFinalStarName = TUtilityString.FetchUTF(param1);
         this.FAddValue = TUtilityString.FetchUTF(param1);
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
      
      public function get Position() : uint
      {
         return this.FPosition;
      }
      
      public function get SevenHeroId() : uint
      {
         return this.FSevenHeroId;
      }
      
      public function get HeroName() : String
      {
         return this.FHeroName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get FinalStarName() : String
      {
         return this.FFinalStarName;
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

