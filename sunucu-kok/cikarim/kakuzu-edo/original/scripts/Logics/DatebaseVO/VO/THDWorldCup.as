package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDWorldCup extends THDActivityBase
   {
      
      protected var FTeams:Vector.<String>;
      
      protected var FSelector2Cost:uint;
      
      protected var FSelector2Tips:String;
      
      protected var FFinalCost:uint;
      
      protected var FFinalHero:uint;
      
      protected var FOptsCost:Vector.<uint>;
      
      protected var FOptsAward:Vector.<uint>;
      
      protected var FReturnLevel:Vector.<String>;
      
      protected var FReturnKey:Vector.<uint>;
      
      protected var FReturnRate:Vector.<uint>;
      
      protected var FTips:String;
      
      public function THDWorldCup()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc2_ = _loc5_.length;
         this.FTeams = new Vector.<String>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FTeams[_loc3_] = _loc5_[_loc3_].country;
            _loc3_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         this.FSelector2Cost = _loc5_[1].cost;
         this.FSelector2Tips = _loc5_[1].tips;
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         this.FFinalCost = _loc6_.condition;
         this.FFinalHero = _loc6_.heroid;
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc2_ = _loc5_.length;
         this.FOptsCost = new Vector.<uint>(_loc2_);
         this.FOptsAward = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FOptsCost[_loc3_] = _loc5_[_loc3_].cost;
            this.FOptsAward[_loc3_] = _loc5_[_loc3_].tips;
            _loc3_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc2_ = _loc5_.length;
         this.FReturnLevel = new Vector.<String>(_loc2_);
         this.FReturnRate = new Vector.<uint>(_loc2_);
         this.FReturnKey = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FReturnKey[_loc3_] = _loc5_[_loc3_].key;
            this.FReturnLevel[_loc3_] = _loc5_[_loc3_].tips;
            this.FReturnRate[_loc3_] = _loc5_[_loc3_].rate;
            _loc3_++;
         }
         this.FTips = TUtilityString.FetchUTF(param1);
      }
      
      public function get Teams() : Vector.<String>
      {
         return this.FTeams;
      }
      
      public function get Selector2Cost() : uint
      {
         return this.FSelector2Cost;
      }
      
      public function get FinalCost() : uint
      {
         return this.FFinalCost;
      }
      
      public function get OptsCost() : Vector.<uint>
      {
         return this.FOptsCost;
      }
      
      public function get FinalHero() : uint
      {
         return this.FFinalHero;
      }
      
      public function get OptsAward() : Vector.<uint>
      {
         return this.FOptsAward;
      }
      
      public function get ReturnLevel() : Vector.<String>
      {
         return this.FReturnLevel;
      }
      
      public function get ReturnRate() : Vector.<uint>
      {
         return this.FReturnRate;
      }
      
      public function get Tips() : String
      {
         return this.FTips;
      }
      
      public function get ReturnKey() : Vector.<uint>
      {
         return this.FReturnKey;
      }
      
      public function get Selector2Tips() : String
      {
         return this.FSelector2Tips;
      }
   }
}

