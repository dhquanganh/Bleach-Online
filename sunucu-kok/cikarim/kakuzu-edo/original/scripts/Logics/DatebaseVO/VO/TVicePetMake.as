package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TVicePetMake extends TDatebaseVO
   {
      
      protected var FConsume:Vector.<int>;
      
      protected var FNeedSilver:uint;
      
      protected var FPathWay:String;
      
      public function TVicePetMake()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FConsume = Vector.<int>(_loc3_);
         this.FNeedSilver = param1.readUnsignedInt();
         this.FPathWay = TUtilityString.FetchUTF(param1);
      }
      
      public function get Consume() : Vector.<int>
      {
         return this.FConsume;
      }
      
      public function get NeedSilver() : uint
      {
         return this.FNeedSilver;
      }
      
      public function get PathWay() : String
      {
         return this.FPathWay;
      }
   }
}

