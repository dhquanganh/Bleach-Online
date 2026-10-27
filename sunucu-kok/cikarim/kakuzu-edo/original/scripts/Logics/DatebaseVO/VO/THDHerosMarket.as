package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHerosMarket extends THDActivityBase
   {
      
      protected var FHerosId:Vector.<uint>;
      
      protected var FHerosItemId:Vector.<uint>;
      
      protected var FHerosCost:Vector.<uint>;
      
      protected var FHerosHotId:Vector.<uint>;
      
      protected var FHerosHotIndex:Vector.<uint>;
      
      protected var FHerosReportId:Vector.<String>;
      
      protected var FHerosPosition:Vector.<uint>;
      
      protected var FHerosAchieveIndex:Vector.<uint>;
      
      protected var FHerosAchieveAward:Vector.<uint>;
      
      protected var FHerosAchieveCond:Vector.<uint>;
      
      protected var FHerosAchieveTips:Vector.<String>;
      
      protected var FHeroExpIndex:uint;
      
      protected var FHeroExpAward:uint;
      
      protected var FHeroExpCost:uint;
      
      protected var FHeroExpTip:String;
      
      protected var FKnifeId:Vector.<uint>;
      
      protected var FKnifeItemId:Vector.<uint>;
      
      protected var FExpandIds:Vector.<Vector.<uint>>;
      
      protected var FKnifeCost:Vector.<uint>;
      
      protected var FKnifeHotId:Vector.<uint>;
      
      protected var FKnifeHotIndex:Vector.<uint>;
      
      protected var FKnifeReportId:Vector.<String>;
      
      protected var FKnifePosition:Vector.<uint>;
      
      protected var FKnifeAchieveIndex:Vector.<uint>;
      
      protected var FKnifeAchieveAward:Vector.<uint>;
      
      protected var FKnifeAchieveCond:Vector.<uint>;
      
      protected var FKnifeAchieveTips:Vector.<String>;
      
      protected var FKnifeExpIndex:uint;
      
      protected var FKnifeExpAward:uint;
      
      protected var FKnifeExpCost:uint;
      
      protected var FKnifeExpTip:String;
      
      protected var FTabSwitch:uint;
      
      protected var FItemTip:String;
      
      public function THDHerosMarket()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<uint> = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FHerosId = new Vector.<uint>(_loc2_);
         this.FHerosItemId = new Vector.<uint>(_loc2_);
         this.FHerosCost = new Vector.<uint>(_loc2_);
         this.FHerosReportId = new Vector.<String>(_loc2_);
         this.FHerosPosition = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FHerosId[_loc3_] = _loc6_[_loc3_].id;
            this.FHerosItemId[_loc3_] = _loc6_[_loc3_].itemId;
            this.FHerosCost[_loc3_] = _loc6_[_loc3_].cost;
            this.FHerosReportId[_loc3_] = _loc6_[_loc3_].reportId;
            this.FHerosPosition[_loc3_] = _loc6_[_loc3_].position;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FHerosHotId = new Vector.<uint>(_loc2_);
         this.FHerosHotIndex = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FHerosHotId[_loc3_] = _loc6_[_loc3_].condition;
            this.FHerosHotIndex[_loc3_] = _loc6_[_loc3_].index;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FHerosAchieveIndex = new Vector.<uint>(_loc2_);
         this.FHerosAchieveAward = new Vector.<uint>(_loc2_);
         this.FHerosAchieveCond = new Vector.<uint>(_loc2_);
         this.FHerosAchieveTips = new Vector.<String>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FHerosAchieveIndex[_loc3_] = _loc6_[_loc3_].index;
            this.FHerosAchieveAward[_loc3_] = _loc6_[_loc3_].award;
            this.FHerosAchieveCond[_loc3_] = _loc6_[_loc3_].condition;
            this.FHerosAchieveTips[_loc3_] = _loc6_[_loc3_].tips;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FKnifeId = new Vector.<uint>(_loc2_);
         this.FKnifeItemId = new Vector.<uint>(_loc2_);
         this.FKnifeCost = new Vector.<uint>(_loc2_);
         this.FExpandIds = new Vector.<Vector.<uint>>(_loc2_);
         this.FKnifeReportId = new Vector.<String>(_loc2_);
         this.FKnifePosition = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FKnifeId[_loc3_] = _loc6_[_loc3_].id;
            this.FKnifeItemId[_loc3_] = _loc6_[_loc3_].itemId;
            this.FKnifeCost[_loc3_] = _loc6_[_loc3_].cost;
            _loc8_ = new Vector.<uint>(4);
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc8_[_loc4_] = _loc6_[_loc3_].expandId[_loc4_];
               _loc4_++;
            }
            this.FExpandIds[_loc3_] = _loc8_;
            this.FKnifeReportId[_loc3_] = _loc6_[_loc3_].reportId;
            this.FKnifePosition[_loc3_] = _loc6_[_loc3_].position;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FKnifeHotId = new Vector.<uint>(_loc2_);
         this.FKnifeHotIndex = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FKnifeHotId[_loc3_] = _loc6_[_loc3_].condition;
            this.FKnifeHotIndex[_loc3_] = _loc6_[_loc3_].index;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FKnifeAchieveIndex = new Vector.<uint>(_loc2_);
         this.FKnifeAchieveAward = new Vector.<uint>(_loc2_);
         this.FKnifeAchieveCond = new Vector.<uint>(_loc2_);
         this.FKnifeAchieveTips = new Vector.<String>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FKnifeAchieveIndex[_loc3_] = _loc6_[_loc3_].index;
            this.FKnifeAchieveAward[_loc3_] = _loc6_[_loc3_].award;
            this.FKnifeAchieveCond[_loc3_] = _loc6_[_loc3_].condition;
            this.FKnifeAchieveTips[_loc3_] = _loc6_[_loc3_].tips;
            _loc3_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         _loc2_ = uint(_loc7_.length);
         this.FHeroExpIndex = _loc7_.index;
         this.FHeroExpAward = _loc7_.award;
         this.FHeroExpCost = _loc7_.cost;
         this.FHeroExpTip = _loc7_.tips;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         _loc2_ = uint(_loc7_.length);
         this.FKnifeExpIndex = _loc7_.index;
         this.FKnifeExpAward = _loc7_.award;
         this.FKnifeExpCost = _loc7_.cost;
         this.FKnifeExpTip = _loc7_.tips;
         this.FTabSwitch = param1.readUnsignedInt();
         this.FItemTip = TUtilityString.FetchUTF(param1);
      }
      
      public function get HerosId() : Vector.<uint>
      {
         return this.FHerosId;
      }
      
      public function get HerosCost() : Vector.<uint>
      {
         return this.FHerosCost;
      }
      
      public function get HerosHotId() : Vector.<uint>
      {
         return this.FHerosHotId;
      }
      
      public function get HerosAchieveIndex() : Vector.<uint>
      {
         return this.FHerosAchieveIndex;
      }
      
      public function get HerosAchieveAward() : Vector.<uint>
      {
         return this.FHerosAchieveAward;
      }
      
      public function get HerosAchieveCond() : Vector.<uint>
      {
         return this.FHerosAchieveCond;
      }
      
      public function get HeroExpIndex() : uint
      {
         return this.FHeroExpIndex;
      }
      
      public function get HeroExpAward() : uint
      {
         return this.FHeroExpAward;
      }
      
      public function get HeroExpCost() : uint
      {
         return this.FHeroExpCost;
      }
      
      public function get HeroExpTip() : String
      {
         return this.FHeroExpTip;
      }
      
      public function get KnifeId() : Vector.<uint>
      {
         return this.FKnifeId;
      }
      
      public function get KnifeCost() : Vector.<uint>
      {
         return this.FKnifeCost;
      }
      
      public function get KnifeHotId() : Vector.<uint>
      {
         return this.FKnifeHotId;
      }
      
      public function get KnifeAchieveIndex() : Vector.<uint>
      {
         return this.FKnifeAchieveIndex;
      }
      
      public function get KnifeAchieveAward() : Vector.<uint>
      {
         return this.FKnifeAchieveAward;
      }
      
      public function get KnifeAchieveCond() : Vector.<uint>
      {
         return this.FKnifeAchieveCond;
      }
      
      public function get KnifeExpIndex() : uint
      {
         return this.FKnifeExpIndex;
      }
      
      public function get KnifeExpAward() : uint
      {
         return this.FKnifeExpAward;
      }
      
      public function get KnifeExpCost() : uint
      {
         return this.FKnifeExpCost;
      }
      
      public function get KnifeExpTip() : String
      {
         return this.FKnifeExpTip;
      }
      
      public function get TabSwitch() : uint
      {
         return this.FTabSwitch;
      }
      
      public function get HerosItemId() : Vector.<uint>
      {
         return this.FHerosItemId;
      }
      
      public function get KnifeItemId() : Vector.<uint>
      {
         return this.FKnifeItemId;
      }
      
      public function get ExpandIds() : Vector.<Vector.<uint>>
      {
         return this.FExpandIds;
      }
      
      public function get HerosHotIndex() : Vector.<uint>
      {
         return this.FHerosHotIndex;
      }
      
      public function get KnifeHotIndex() : Vector.<uint>
      {
         return this.FKnifeHotIndex;
      }
      
      public function get HerosReportId() : Vector.<String>
      {
         return this.FHerosReportId;
      }
      
      public function get HerosPosition() : Vector.<uint>
      {
         return this.FHerosPosition;
      }
      
      public function get KnifeReportId() : Vector.<String>
      {
         return this.FKnifeReportId;
      }
      
      public function get KnifePosition() : Vector.<uint>
      {
         return this.FKnifePosition;
      }
      
      public function get ItemTip() : String
      {
         return this.FItemTip;
      }
      
      public function get KnifeAchieveTips() : Vector.<String>
      {
         return this.FKnifeAchieveTips;
      }
      
      public function get HerosAchieveTips() : Vector.<String>
      {
         return this.FHerosAchieveTips;
      }
   }
}

