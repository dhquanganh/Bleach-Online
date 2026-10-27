package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TRecommendStone extends TDatebaseVO
   {
      
      protected var FStonesType:Vector.<int>;
      
      protected var FStones:String;
      
      public function TRecommendStone()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FStones = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FStones);
         _loc3_ = _loc2_.stones as Array;
         _loc4_ = int(_loc3_.length);
         this.FStonesType = new Vector.<int>(_loc4_);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this.FStonesType[_loc5_] = _loc3_[_loc5_];
            _loc5_++;
         }
      }
      
      public function get StonesType() : Vector.<int>
      {
         return this.FStonesType;
      }
      
      public function get Stones() : String
      {
         return this.FStones;
      }
   }
}

