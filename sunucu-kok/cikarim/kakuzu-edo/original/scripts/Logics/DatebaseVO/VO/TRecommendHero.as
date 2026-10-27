package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TRecommendHero extends TDatebaseVO
   {
      
      protected var FAbility:String;
      
      protected var FIfRecommend:int;
      
      protected var FGetRode:String;
      
      protected var FFriends:Vector.<int>;
      
      protected var FSortID:int;
      
      public function TRecommendHero()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         this.FAbility = TUtilityString.FetchUTF(param1);
         this.FIfRecommend = param1.readInt();
         this.FGetRode = TUtilityString.FetchUTF(param1);
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc3_);
         this.FFriends = Vector.<int>(_loc4_);
         this.FSortID = param1.readInt();
      }
      
      public function get Ability() : String
      {
         return this.FAbility;
      }
      
      public function get IfRecommend() : int
      {
         return this.FIfRecommend;
      }
      
      public function get GetRode() : String
      {
         return this.FGetRode;
      }
      
      public function get Friends() : Vector.<int>
      {
         return this.FFriends;
      }
      
      public function get SortID() : int
      {
         return this.FSortID;
      }
   }
}

