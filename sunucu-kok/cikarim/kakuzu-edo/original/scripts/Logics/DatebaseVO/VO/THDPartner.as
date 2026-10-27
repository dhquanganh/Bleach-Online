package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDPartner extends THDActivityBase
   {
      
      protected var FTaskIndexs:Vector.<int>;
      
      protected var FTaskPrompts:Vector.<String>;
      
      protected var FTaskTotalSchedules:Vector.<int>;
      
      protected var FTaskConditions:Vector.<Vector.<int>>;
      
      protected var FTaskAwards:Vector.<int>;
      
      protected var FBoxIndexs:Vector.<int>;
      
      protected var FBoxCosts:Vector.<int>;
      
      protected var FBoxAwards:Vector.<int>;
      
      protected var FBuyRoseIndexs:Vector.<int>;
      
      protected var FBuyRoseCosts:Vector.<int>;
      
      protected var FBuyRoseNum:Vector.<int>;
      
      protected var FRoseNumIndex:int;
      
      protected var FBuyRoseAward:Vector.<int>;
      
      protected var FRoseID:int;
      
      protected var FBuyRoseAwardRoseNum:Vector.<int>;
      
      protected var FExchangeHeroIndexs:Vector.<int>;
      
      protected var FExchangeHeroNeedRoses:Vector.<int>;
      
      protected var FExChangeHeroHeroIDs:Vector.<int>;
      
      protected var FExchangeHeroFightReportAddr:Vector.<String>;
      
      protected var FTitleIndex:int;
      
      protected var FTitleID:int;
      
      public function THDPartner()
      {
         super();
         this.FTaskIndexs = new Vector.<int>();
         this.FTaskPrompts = new Vector.<String>();
         this.FTaskTotalSchedules = new Vector.<int>();
         this.FTaskConditions = new Vector.<Vector.<int>>();
         this.FTaskAwards = new Vector.<int>();
         this.FBoxIndexs = new Vector.<int>();
         this.FBoxCosts = new Vector.<int>();
         this.FBoxAwards = new Vector.<int>();
         this.FBuyRoseIndexs = new Vector.<int>();
         this.FBuyRoseCosts = new Vector.<int>();
         this.FBuyRoseNum = new Vector.<int>();
         this.FBuyRoseAward = new Vector.<int>();
         this.FBuyRoseAwardRoseNum = new Vector.<int>();
         this.FExchangeHeroIndexs = new Vector.<int>();
         this.FExchangeHeroNeedRoses = new Vector.<int>();
         this.FExChangeHeroHeroIDs = new Vector.<int>();
         this.FExchangeHeroFightReportAddr = new Vector.<String>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FTaskIndexs.push(_loc3_.index);
         this.FTaskPrompts.push(_loc3_.prompt);
         this.FTaskTotalSchedules.push(_loc3_.totalSchedule);
         _loc4_ = new Vector.<int>();
         _loc6_ = int(_loc3_.condition.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_.push(_loc3_.condition[_loc5_].id);
            _loc5_++;
         }
         this.FTaskConditions.push(_loc4_);
         this.FTaskAwards.push(_loc3_.rose);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FTaskIndexs.push(_loc3_.index);
         this.FTaskPrompts.push(_loc3_.prompt);
         this.FTaskTotalSchedules.push(_loc3_.totalSchedule);
         _loc4_ = new Vector.<int>();
         _loc4_.push(_loc3_.level);
         _loc4_.push(_loc3_.num);
         this.FTaskConditions.push(_loc4_);
         this.FTaskAwards.push(_loc3_.rose);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FTaskIndexs.push(_loc3_.index);
         this.FTaskPrompts.push(_loc3_.prompt);
         this.FTaskTotalSchedules.push(_loc3_.totalSchedule);
         _loc4_ = new Vector.<int>();
         _loc4_.push(_loc3_.level);
         _loc4_.push(_loc3_.num);
         this.FTaskConditions.push(_loc4_);
         this.FTaskAwards.push(_loc3_.rose);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc2_) as Array;
         _loc6_ = int(_loc7_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FBoxIndexs.push(_loc7_[_loc5_].index);
            this.FBoxCosts.push(_loc7_[_loc5_].cost);
            this.FBoxAwards.push(_loc7_[_loc5_].award);
            _loc5_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc2_) as Array;
         _loc6_ = int(_loc7_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FBuyRoseIndexs.push(_loc7_[_loc5_].index);
            this.FBuyRoseCosts.push(_loc7_[_loc5_].cost);
            this.FBuyRoseNum.push(_loc7_[_loc5_].count);
            this.FBuyRoseAward.push(_loc7_[_loc5_].award);
            this.FBuyRoseAwardRoseNum.push(_loc7_[_loc5_].rose[0].amount);
            _loc5_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc2_) as Array;
         _loc6_ = int(_loc7_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FExchangeHeroIndexs.push(_loc7_[_loc5_].index);
            this.FExchangeHeroNeedRoses.push(_loc7_[_loc5_].needRose);
            this.FExChangeHeroHeroIDs.push(_loc7_[_loc5_].heroID);
            this.FExchangeHeroFightReportAddr[_loc5_] = _loc7_[_loc5_].reportId;
            _loc5_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FTitleIndex = _loc3_.index;
         this.FTitleID = _loc3_.titleID;
         this.FRoseNumIndex = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FRoseID = _loc3_.code;
      }
      
      public function get TaskIndexs() : Vector.<int>
      {
         return this.FTaskIndexs;
      }
      
      public function get TaskPrompts() : Vector.<String>
      {
         return this.FTaskPrompts;
      }
      
      public function get TaskTotalSchedules() : Vector.<int>
      {
         return this.FTaskTotalSchedules;
      }
      
      public function get TaskConditions() : Vector.<Vector.<int>>
      {
         return this.FTaskConditions;
      }
      
      public function get BoxIndexs() : Vector.<int>
      {
         return this.FBoxIndexs;
      }
      
      public function get BoxCosts() : Vector.<int>
      {
         return this.FBoxCosts;
      }
      
      public function get BoxAwards() : Vector.<int>
      {
         return this.FBoxAwards;
      }
      
      public function get BuyRoseIndexs() : Vector.<int>
      {
         return this.FBuyRoseIndexs;
      }
      
      public function get BuyRoseCosts() : Vector.<int>
      {
         return this.FBuyRoseCosts;
      }
      
      public function get BuyRoseNum() : Vector.<int>
      {
         return this.FBuyRoseNum;
      }
      
      public function get RoseNumIndex() : int
      {
         return this.FRoseNumIndex;
      }
      
      public function get ExchangeHeroIndexs() : Vector.<int>
      {
         return this.FExchangeHeroIndexs;
      }
      
      public function get ExchangeHeroNeedRoses() : Vector.<int>
      {
         return this.FExchangeHeroNeedRoses;
      }
      
      public function get ExChangeHeroHeroIDs() : Vector.<int>
      {
         return this.FExChangeHeroHeroIDs;
      }
      
      public function get TitleIndex() : int
      {
         return this.FTitleIndex;
      }
      
      public function get TitleID() : int
      {
         return this.FTitleID;
      }
      
      public function get ExchangeHeroFightReportAddr() : Vector.<String>
      {
         return this.FExchangeHeroFightReportAddr;
      }
      
      public function get BuyRoseAward() : Vector.<int>
      {
         return this.FBuyRoseAward;
      }
      
      public function get TaskAwards() : Vector.<int>
      {
         return this.FTaskAwards;
      }
      
      public function get RoseID() : int
      {
         return this.FRoseID;
      }
      
      public function get BuyRoseAwardRoseNum() : Vector.<int>
      {
         return this.FBuyRoseAwardRoseNum;
      }
   }
}

