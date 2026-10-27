package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TFundShop;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGrowFundShop extends THDActivityBase
   {
      
      protected var FFundShops:Vector.<TFundShop>;
      
      public function THDGrowFundShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TFundShop = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc8_ = Json.decode(_loc7_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FFundShops = new Vector.<TFundShop>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TFundShop(_loc6_[_loc2_]);
            _loc5_.SetShopName(_loc8_[_loc2_]);
            this.FFundShops[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      public function get FundShops() : Vector.<TFundShop>
      {
         return this.FFundShops;
      }
   }
}

