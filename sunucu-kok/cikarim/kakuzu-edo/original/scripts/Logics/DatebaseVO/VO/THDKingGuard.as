package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDKingLegend.TActivityKLAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDKingGuard extends THDActivityBase
   {
      
      protected var FGuardRecharges:Vector.<Vector.<TActivityKLAward>>;
      
      protected var FGuardIds:Vector.<int>;
      
      protected var FChipIds:Vector.<int>;
      
      protected var FChipCosts:Vector.<int>;
      
      protected var FChipGets:Vector.<int>;
      
      protected var FKingIndexs:Vector.<int>;
      
      protected var FLastDayIndexs:Vector.<int>;
      
      protected var FGetCards:Vector.<int>;
      
      protected var FStringMsgs:Vector.<String>;
      
      protected var FDailyFreeCount:int;
      
      protected var FRechargeMoney:int;
      
      protected var FRechargeCount:int;
      
      protected var FLastResultIndex:int;
      
      protected var FDailyPayIndex:int;
      
      protected var FTotalFreeIndex:int;
      
      protected var FDailyFreeIndex:int;
      
      protected var FRechargeIndex:int;
      
      protected var FGameStatusIndex:int;
      
      protected var FGameIndex:int;
      
      protected var FGameCost:int;
      
      protected var FGameWinIndex:int;
      
      protected var FGameWinCost:int;
      
      protected var FBuyDay:int;
      
      public function THDKingGuard()
      {
         super();
         this.FGuardRecharges = new Vector.<Vector.<TActivityKLAward>>();
         this.FGuardIds = new Vector.<int>();
         this.FChipIds = new Vector.<int>();
         this.FChipCosts = new Vector.<int>();
         this.FChipGets = new Vector.<int>();
         this.FKingIndexs = new Vector.<int>();
         this.FGetCards = new Vector.<int>();
         this.FLastDayIndexs = new Vector.<int>();
         this.FStringMsgs = new Vector.<String>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:TActivityKLAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_);
         _loc4_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.FGuardRecharges[_loc2_] = new Vector.<TActivityKLAward>();
            this.FGuardIds.push(_loc6_[_loc2_].cardType);
            this.FKingIndexs.push(_loc6_[_loc2_].index);
            this.FGetCards.push(_loc6_[_loc2_].getCard);
            _loc7_ = _loc6_[_loc2_].award;
            _loc5_ = int(_loc7_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc10_ = new TActivityKLAward();
               _loc10_.CostCard = _loc7_[_loc3_].costCard;
               _loc10_.MaxGetCount = _loc7_[_loc3_].maxGetCount;
               _loc10_.AwardId = _loc7_[_loc3_].awardId;
               _loc10_.DisplayId = _loc7_[_loc3_].displayId;
               this.FGuardRecharges[_loc2_].push(_loc10_);
               _loc3_++;
            }
            _loc2_++;
         }
         this.FLastResultIndex = param1.readUnsignedInt();
         this.FDailyFreeCount = param1.readUnsignedInt();
         this.FTotalFreeIndex = param1.readUnsignedInt();
         this.FDailyFreeIndex = param1.readUnsignedInt();
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc8_);
         this.FRechargeIndex = _loc9_.index;
         this.FRechargeMoney = _loc9_.condition;
         this.FRechargeCount = _loc9_.freeTime;
         this.FGameStatusIndex = param1.readUnsignedInt();
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc8_);
         this.FGameIndex = _loc9_.index;
         this.FGameCost = _loc9_.cost;
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc8_);
         this.FGameWinIndex = _loc9_.index;
         this.FGameWinCost = _loc9_.cost;
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc8_);
         this.FBuyDay = _loc9_.day;
         _loc6_ = _loc9_.buy;
         _loc4_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.FLastDayIndexs.push(_loc6_[_loc2_].index);
            this.FChipIds.push(_loc6_[_loc2_].chipIndex);
            this.FChipCosts.push(_loc6_[_loc2_].cost);
            this.FChipGets.push(_loc6_[_loc2_].getChip);
            _loc2_++;
         }
         this.FDailyPayIndex = param1.readUnsignedInt();
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc8_);
         _loc4_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.FStringMsgs.push(_loc6_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get RechargeMoney() : int
      {
         return this.FRechargeMoney;
      }
      
      public function get RechargeCount() : int
      {
         return this.FRechargeCount;
      }
      
      public function get BuyDay() : int
      {
         return this.FBuyDay;
      }
      
      public function get TotalFreeIndex() : int
      {
         return this.FTotalFreeIndex;
      }
      
      public function set TotalFreeIndex(param1:int) : void
      {
         this.FTotalFreeIndex = param1;
      }
      
      public function get DailyFreeIndex() : int
      {
         return this.FDailyFreeIndex;
      }
      
      public function set DailyFreeIndex(param1:int) : void
      {
         this.FDailyFreeIndex = param1;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function set RechargeIndex(param1:int) : void
      {
         this.FRechargeIndex = param1;
      }
      
      public function get GameStatusIndex() : int
      {
         return this.FGameStatusIndex;
      }
      
      public function set GameStatusIndex(param1:int) : void
      {
         this.FGameStatusIndex = param1;
      }
      
      public function get GameIndex() : int
      {
         return this.FGameIndex;
      }
      
      public function set GameIndex(param1:int) : void
      {
         this.FGameIndex = param1;
      }
      
      public function get GameWinIndex() : int
      {
         return this.FGameWinIndex;
      }
      
      public function set GameWinIndex(param1:int) : void
      {
         this.FGameWinIndex = param1;
      }
      
      public function get KingIndexs() : Vector.<int>
      {
         return this.FKingIndexs;
      }
      
      public function set KingIndexs(param1:Vector.<int>) : void
      {
         this.FKingIndexs = param1;
      }
      
      public function get GameCost() : int
      {
         return this.FGameCost;
      }
      
      public function get GameWinCost() : int
      {
         return this.FGameWinCost;
      }
      
      public function get ChipCosts() : Vector.<int>
      {
         return this.FChipCosts;
      }
      
      public function set ChipCosts(param1:Vector.<int>) : void
      {
         this.FChipCosts = param1;
      }
      
      public function get ChipIds() : Vector.<int>
      {
         return this.FChipIds;
      }
      
      public function set ChipIds(param1:Vector.<int>) : void
      {
         this.FChipIds = param1;
      }
      
      public function get LastDayIndexs() : Vector.<int>
      {
         return this.FLastDayIndexs;
      }
      
      public function set LastDayIndexs(param1:Vector.<int>) : void
      {
         this.FLastDayIndexs = param1;
      }
      
      public function get LastResultIndex() : int
      {
         return this.FLastResultIndex;
      }
      
      public function set LastResultIndex(param1:int) : void
      {
         this.FLastResultIndex = param1;
      }
      
      public function GetCards(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = this.FKingIndexs.indexOf(param1);
         return this.FGetCards[_loc2_];
      }
      
      public function GetGuardType(param1:int) : int
      {
         return this.FGuardIds[param1];
      }
      
      public function GetAwardsByGuard(param1:int) : Vector.<TActivityKLAward>
      {
         var _loc2_:int = 0;
         _loc2_ = this.FKingIndexs.indexOf(param1);
         return this.FGuardRecharges[_loc2_];
      }
      
      public function GetString(param1:int) : String
      {
         return this.FStringMsgs[param1];
      }
   }
}

