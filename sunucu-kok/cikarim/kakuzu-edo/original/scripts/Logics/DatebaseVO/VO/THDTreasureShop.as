package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTreasureShop extends THDActivityBase
   {
      
      protected var FGolds:Vector.<int>;
      
      protected var FIndexs:Vector.<int>;
      
      protected var FLimits:Vector.<int>;
      
      protected var FAwards:Vector.<Vector.<int>>;
      
      protected var FNames:Vector.<String>;
      
      protected var FDiscouts:Vector.<int>;
      
      protected var FPrices:Vector.<int>;
      
      public function THDTreasureShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FGolds = new Vector.<int>();
         this.FIndexs = new Vector.<int>();
         this.FLimits = new Vector.<int>();
         this.FAwards = new Vector.<Vector.<int>>();
         this.FNames = new Vector.<String>();
         this.FDiscouts = new Vector.<int>();
         this.FPrices = new Vector.<int>();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_) as Array;
         _loc5_ = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            this.FGolds.push(_loc6_.gold);
            this.FIndexs.push(_loc6_.index);
            this.FLimits.push(_loc6_.limit);
            this.FAwards.push(Vector.<int>(_loc6_.award));
            this.FNames.push(_loc6_.name);
            this.FDiscouts.push(_loc6_.discount);
            this.FPrices.push(_loc6_.price);
            _loc4_++;
         }
      }
      
      public function get Golds() : Vector.<int>
      {
         return this.FGolds;
      }
      
      public function get Indexs() : Vector.<int>
      {
         return this.FIndexs;
      }
      
      public function get Limits() : Vector.<int>
      {
         return this.FLimits;
      }
      
      public function get Awards() : Vector.<Vector.<int>>
      {
         return this.FAwards;
      }
      
      public function get Names() : Vector.<String>
      {
         return this.FNames;
      }
      
      public function get Discouts() : Vector.<int>
      {
         return this.FDiscouts;
      }
      
      public function get Prices() : Vector.<int>
      {
         return this.FPrices;
      }
   }
}

