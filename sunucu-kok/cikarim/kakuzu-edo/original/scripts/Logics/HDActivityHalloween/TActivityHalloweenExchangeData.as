package Logics.HDActivityHalloween
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityHalloweenExchangeData extends TActivityOSBase
   {
      
      protected var FDataList:Vector.<THalloweenExchangeGiftVo>;
      
      protected var FShowInventories:Vector.<TInventories>;
      
      protected var FCurDay:int;
      
      protected var FDaysIndex:int;
      
      protected var FFreeTimesIndex:int;
      
      protected var FResidueDegree:int;
      
      protected var FExchangeIndex:int;
      
      protected var FTotalExchangeValue:int;
      
      protected var FOpenAllIndex:int;
      
      protected var FResetIndex:int;
      
      protected var FHeroType:int;
      
      protected var FHeroId:int;
      
      protected var FFightReportAddr:String;
      
      protected var FExtractList:Vector.<THalloweenExtractGiftVo>;
      
      protected var FIsHaveHero:Boolean;
      
      protected var FExtractArrPos:int;
      
      protected var FResetGold:int;
      
      protected var FSingleSpendGold:int;
      
      protected var FDiscount:int;
      
      protected var FTipsExtractStr:String;
      
      protected var FTipsButtonStr:String;
      
      public function TActivityHalloweenExchangeData()
      {
         super();
         this.FDataList = new Vector.<THalloweenExchangeGiftVo>();
         this.FShowInventories = new Vector.<TInventories>();
         this.FExtractList = new Vector.<THalloweenExtractGiftVo>();
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
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
      
      public function get ResidueDegree() : int
      {
         return this.FResidueDegree;
      }
      
      public function set ResidueDegree(param1:int) : void
      {
         this.FResidueDegree = param1;
      }
      
      public function get ExchangeIndex() : int
      {
         return this.FExchangeIndex;
      }
      
      public function set ExchangeIndex(param1:int) : void
      {
         this.FExchangeIndex = param1;
      }
      
      public function get TotalExchangeValue() : int
      {
         return this.FTotalExchangeValue;
      }
      
      public function set TotalExchangeValue(param1:int) : void
      {
         this.FTotalExchangeValue = param1;
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
      
      public function get DataList() : Vector.<THalloweenExchangeGiftVo>
      {
         return this.FDataList;
      }
      
      public function set DataList(param1:Vector.<THalloweenExchangeGiftVo>) : void
      {
         this.FDataList = param1;
      }
      
      public function get ShowInventories() : Vector.<TInventories>
      {
         return this.FShowInventories;
      }
      
      public function set ShowInventories(param1:Vector.<TInventories>) : void
      {
         this.FShowInventories = param1;
      }
      
      public function get ExtractList() : Vector.<THalloweenExtractGiftVo>
      {
         return this.FExtractList;
      }
      
      public function set ExtractList(param1:Vector.<THalloweenExtractGiftVo>) : void
      {
         this.FExtractList = param1;
      }
      
      public function get IsHaveHero() : Boolean
      {
         return this.FIsHaveHero;
      }
      
      public function set IsHaveHero(param1:Boolean) : void
      {
         this.FIsHaveHero = param1;
      }
      
      public function get ExtractArrPos() : int
      {
         return this.FExtractArrPos;
      }
      
      public function set ExtractArrPos(param1:int) : void
      {
         this.FExtractArrPos = param1;
      }
      
      public function get ResetGold() : int
      {
         return this.FResetGold;
      }
      
      public function set ResetGold(param1:int) : void
      {
         this.FResetGold = param1;
      }
      
      public function get SingleSpendGold() : int
      {
         return this.FSingleSpendGold;
      }
      
      public function set SingleSpendGold(param1:int) : void
      {
         this.FSingleSpendGold = param1;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function set Discount(param1:int) : void
      {
         this.FDiscount = param1;
      }
      
      public function get TipsExtractStr() : String
      {
         return this.FTipsExtractStr;
      }
      
      public function set TipsExtractStr(param1:String) : void
      {
         this.FTipsExtractStr = param1;
      }
      
      public function get TipsButtonStr() : String
      {
         return this.FTipsButtonStr;
      }
      
      public function set TipsButtonStr(param1:String) : void
      {
         this.FTipsButtonStr = param1;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
      
      public function set FightReportAddr(param1:String) : void
      {
         this.FFightReportAddr = param1;
      }
   }
}

