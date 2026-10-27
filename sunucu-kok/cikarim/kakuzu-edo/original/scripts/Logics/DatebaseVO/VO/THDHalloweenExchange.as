package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenExchange extends THDActivityBase
   {
      
      private var FShowList:Array;
      
      private var FExtractAwardList:Array;
      
      private var FExtractCost:int;
      
      private var FFreeTimes:int;
      
      private var FExchangeIndexList:Vector.<int>;
      
      private var FExchangeValueList:Vector.<int>;
      
      private var FExchangeAwardList:Vector.<int>;
      
      private var FHeroType:int;
      
      private var FHeroId:int;
      
      private var FFightReportAddr:String;
      
      private var FExchangeIndex:int;
      
      private var FDaysIndex:int;
      
      private var FFreeTimesIndex:int;
      
      private var FOpenAllIndex:int;
      
      private var FResetIndex:int;
      
      private var FRandomIndex:int;
      
      private var FResetGold:int;
      
      private var FDiscount:int;
      
      private var FTipsGridStr:String;
      
      private var FTipsBtnStr:String;
      
      public function THDHalloweenExchange()
      {
         super();
         this.FExchangeIndexList = new Vector.<int>();
         this.FExchangeValueList = new Vector.<int>();
         this.FExchangeAwardList = new Vector.<int>();
         this.FExtractAwardList = new Array();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FShowList = _loc4_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new Vector.<int>();
            _loc8_ = 0;
            while(_loc8_ < _loc4_[_loc2_].length)
            {
               _loc7_ = _loc4_[_loc2_][_loc8_];
               _loc9_[_loc8_] = _loc7_.awardId;
               _loc8_++;
            }
            this.FExtractAwardList.push(_loc9_);
            _loc2_++;
         }
         this.FExtractCost = param1.readUnsignedInt();
         this.FFreeTimes = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FExchangeIndexList[_loc2_] = _loc4_[_loc2_].index;
            this.FExchangeValueList[_loc2_] = _loc4_[_loc2_].exchangeValue;
            this.FExchangeAwardList[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FHeroType = _loc7_.awardType;
         this.FHeroId = _loc7_.id;
         this.FFightReportAddr = _loc7_.reportId;
         this.FExchangeIndex = param1.readUnsignedInt();
         this.FDaysIndex = param1.readUnsignedInt();
         this.FFreeTimesIndex = param1.readUnsignedInt();
         this.FOpenAllIndex = param1.readUnsignedInt();
         this.FResetIndex = param1.readUnsignedInt();
         this.FRandomIndex = param1.readUnsignedInt();
         this.FResetGold = param1.readUnsignedInt();
         this.FDiscount = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         this.FTipsGridStr = _loc5_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         this.FTipsBtnStr = _loc5_;
      }
      
      public function get ShowList() : Array
      {
         return this.FShowList;
      }
      
      public function set ShowList(param1:Array) : void
      {
         this.FShowList = param1;
      }
      
      public function get FreeTimes() : int
      {
         return this.FFreeTimes;
      }
      
      public function set FreeTimes(param1:int) : void
      {
         this.FFreeTimes = param1;
      }
      
      public function get ExchangeIndexList() : Vector.<int>
      {
         return this.FExchangeIndexList;
      }
      
      public function set ExchangeIndexList(param1:Vector.<int>) : void
      {
         this.FExchangeIndexList = param1;
      }
      
      public function get ExchangeValueList() : Vector.<int>
      {
         return this.FExchangeValueList;
      }
      
      public function set ExchangeValueList(param1:Vector.<int>) : void
      {
         this.FExchangeValueList = param1;
      }
      
      public function get ExchangeAwardList() : Vector.<int>
      {
         return this.FExchangeAwardList;
      }
      
      public function set ExchangeAwardList(param1:Vector.<int>) : void
      {
         this.FExchangeAwardList = param1;
      }
      
      public function get HeroType() : int
      {
         return this.FHeroType;
      }
      
      public function set HeroType(param1:int) : void
      {
         this.FHeroType = param1;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function get ExchangeIndex() : int
      {
         return this.FExchangeIndex;
      }
      
      public function set ExchangeIndex(param1:int) : void
      {
         this.FExchangeIndex = param1;
      }
      
      public function get DaysIndex() : int
      {
         return this.FDaysIndex;
      }
      
      public function set DaysIndex(param1:int) : void
      {
         this.FDaysIndex = param1;
      }
      
      public function get FreeTimesIndex() : int
      {
         return this.FFreeTimesIndex;
      }
      
      public function set FreeTimesIndex(param1:int) : void
      {
         this.FFreeTimesIndex = param1;
      }
      
      public function get OpenAllIndex() : int
      {
         return this.FOpenAllIndex;
      }
      
      public function set OpenAllIndex(param1:int) : void
      {
         this.FOpenAllIndex = param1;
      }
      
      public function get ResetIndex() : int
      {
         return this.FResetIndex;
      }
      
      public function set ResetIndex(param1:int) : void
      {
         this.FResetIndex = param1;
      }
      
      public function get ExtractCost() : int
      {
         return this.FExtractCost;
      }
      
      public function set ExtractCost(param1:int) : void
      {
         this.FExtractCost = param1;
      }
      
      public function get ResetGold() : int
      {
         return this.FResetGold;
      }
      
      public function set ResetGold(param1:int) : void
      {
         this.FResetGold = param1;
      }
      
      public function get ExtractAwardList() : Array
      {
         return this.FExtractAwardList;
      }
      
      public function set ExtractAwardList(param1:Array) : void
      {
         this.FExtractAwardList = param1;
      }
      
      public function get RandomIndex() : int
      {
         return this.FRandomIndex;
      }
      
      public function set RandomIndex(param1:int) : void
      {
         this.FRandomIndex = param1;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get TipsBtnStr() : String
      {
         return this.FTipsBtnStr;
      }
      
      public function get TipsGridStr() : String
      {
         return this.FTipsGridStr;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
   }
}

