package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TFundLevelBag;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGrowFundLv extends THDActivityBase
   {
      
      protected var FBags:Vector.<TFundLevelBag>;
      
      public function THDGrowFundLv()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TFundLevelBag = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc7_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FBags = new Vector.<TFundLevelBag>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TFundLevelBag(_loc6_[_loc2_]);
            _loc5_.SetInventoriesId(_loc7_[_loc2_]);
            this.FBags[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      public function get Bags() : Vector.<TFundLevelBag>
      {
         return this.FBags;
      }
   }
}

