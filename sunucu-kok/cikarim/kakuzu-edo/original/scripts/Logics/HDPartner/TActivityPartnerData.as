package Logics.HDPartner
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityPartnerData extends TActivityOSBase
   {
      
      public static const TASKNUM:int = 3;
      
      public static const TASKINDEX1:int = 0;
      
      public static const TASKINDEX2:int = 1;
      
      public static const TASKINDEX3:int = 2;
      
      protected var FTaskIndexs:Vector.<int>;
      
      protected var FTaskPrompts:Vector.<String>;
      
      protected var FTaskTotalSchedules:Vector.<int>;
      
      protected var FTaskConditions:Vector.<Vector.<int>>;
      
      protected var FTaskReciveRecored:Vector.<Boolean>;
      
      protected var FTaskSchedule:Vector.<int>;
      
      protected var FTaskInventories:Vector.<TInventories>;
      
      protected var FBoxIndexs:Vector.<int>;
      
      protected var FBoxCosts:Vector.<int>;
      
      protected var FBoxAwards:Vector.<int>;
      
      protected var FBoxInventories:Vector.<TInventories>;
      
      protected var FBuyRoseIndexs:Vector.<int>;
      
      protected var FBuyRoseCosts:Vector.<int>;
      
      protected var FBuyRoseNum:Vector.<int>;
      
      protected var FBuyRoseAward:Vector.<int>;
      
      protected var FRoseNumIndex:int;
      
      protected var FRoseOpenNum:int;
      
      protected var FBuyRoseArticls:Vector.<TInventories>;
      
      protected var FRoseCurrentNum:int;
      
      protected var FExchangeHeroIndexs:Vector.<int>;
      
      protected var FExchangeHeroNeedRoses:Vector.<int>;
      
      protected var FExchangeHeroHeroIDs:Vector.<int>;
      
      protected var FExchangeHeroFightReportAddr:Vector.<String>;
      
      protected var FExchangeHeroRecore:Vector.<Boolean>;
      
      protected var FTitleIndex:int;
      
      protected var FTitleID:int;
      
      protected var FTitleIfGet:Boolean;
      
      public function TActivityPartnerData()
      {
         super();
         this.FBoxInventories = new Vector.<TInventories>();
         this.FTaskReciveRecored = new Vector.<Boolean>();
         this.FTaskSchedule = new Vector.<int>(TASKNUM);
         this.FExchangeHeroRecore = new Vector.<Boolean>();
         this.FBuyRoseArticls = new Vector.<TInventories>();
         this.FTaskInventories = new Vector.<TInventories>();
      }
      
      public function get TaskIndexs() : Vector.<int>
      {
         return this.FTaskIndexs;
      }
      
      public function set TaskIndexs(param1:Vector.<int>) : void
      {
         this.FTaskIndexs = param1;
      }
      
      public function get TaskPrompts() : Vector.<String>
      {
         return this.FTaskPrompts;
      }
      
      public function set TaskPrompts(param1:Vector.<String>) : void
      {
         this.FTaskPrompts = param1;
      }
      
      public function get TaskTotalSchedules() : Vector.<int>
      {
         return this.FTaskTotalSchedules;
      }
      
      public function set TaskTotalSchedules(param1:Vector.<int>) : void
      {
         this.FTaskTotalSchedules = param1;
      }
      
      public function get TaskConditions() : Vector.<Vector.<int>>
      {
         return this.FTaskConditions;
      }
      
      public function set TaskConditions(param1:Vector.<Vector.<int>>) : void
      {
         this.FTaskConditions = param1;
      }
      
      public function get BoxIndexs() : Vector.<int>
      {
         return this.FBoxIndexs;
      }
      
      public function set BoxIndexs(param1:Vector.<int>) : void
      {
         this.FBoxIndexs = param1;
      }
      
      public function get BoxCosts() : Vector.<int>
      {
         return this.FBoxCosts;
      }
      
      public function set BoxCosts(param1:Vector.<int>) : void
      {
         this.FBoxCosts = param1;
      }
      
      public function get BoxAwards() : Vector.<int>
      {
         return this.FBoxAwards;
      }
      
      public function set BoxAwards(param1:Vector.<int>) : void
      {
         this.FBoxAwards = param1;
      }
      
      public function get BuyRoseIndexs() : Vector.<int>
      {
         return this.FBuyRoseIndexs;
      }
      
      public function set BuyRoseIndexs(param1:Vector.<int>) : void
      {
         this.FBuyRoseIndexs = param1;
      }
      
      public function get BuyRoseCosts() : Vector.<int>
      {
         return this.FBuyRoseCosts;
      }
      
      public function set BuyRoseCosts(param1:Vector.<int>) : void
      {
         this.FBuyRoseCosts = param1;
      }
      
      public function get BuyRoseNum() : Vector.<int>
      {
         return this.FBuyRoseNum;
      }
      
      public function set BuyRoseNum(param1:Vector.<int>) : void
      {
         this.FBuyRoseNum = param1;
      }
      
      public function get RoseNumIndex() : int
      {
         return this.FRoseNumIndex;
      }
      
      public function set RoseNumIndex(param1:int) : void
      {
         this.FRoseNumIndex = param1;
      }
      
      public function get ExchangeHeroIndexs() : Vector.<int>
      {
         return this.FExchangeHeroIndexs;
      }
      
      public function set ExchangeHeroIndexs(param1:Vector.<int>) : void
      {
         this.FExchangeHeroIndexs = param1;
      }
      
      public function get ExchangeHeroNeedRoses() : Vector.<int>
      {
         return this.FExchangeHeroNeedRoses;
      }
      
      public function set ExchangeHeroNeedRoses(param1:Vector.<int>) : void
      {
         this.FExchangeHeroNeedRoses = param1;
      }
      
      public function get ExchangeHeroHeroIDs() : Vector.<int>
      {
         return this.FExchangeHeroHeroIDs;
      }
      
      public function set ExchangeHeroHeroIDs(param1:Vector.<int>) : void
      {
         this.FExchangeHeroHeroIDs = param1;
      }
      
      public function get TitleIndex() : int
      {
         return this.FTitleIndex;
      }
      
      public function set TitleIndex(param1:int) : void
      {
         this.FTitleIndex = param1;
      }
      
      public function get TitleID() : int
      {
         return this.FTitleID;
      }
      
      public function set TitleID(param1:int) : void
      {
         this.FTitleID = param1;
      }
      
      public function get BoxInventories() : Vector.<TInventories>
      {
         return this.FBoxInventories;
      }
      
      public function get TaskReciveRecored() : Vector.<Boolean>
      {
         return this.FTaskReciveRecored;
      }
      
      public function get TaskSchedule() : Vector.<int>
      {
         return this.FTaskSchedule;
      }
      
      public function get RoseOpenNum() : int
      {
         return this.FRoseOpenNum;
      }
      
      public function set RoseOpenNum(param1:int) : void
      {
         this.FRoseOpenNum = param1;
      }
      
      public function get ExchangeHeroRecore() : Vector.<Boolean>
      {
         return this.FExchangeHeroRecore;
      }
      
      public function get RoseCurrentNum() : int
      {
         return this.FRoseCurrentNum;
      }
      
      public function set RoseCurrentNum(param1:int) : void
      {
         this.FRoseCurrentNum = param1;
      }
      
      public function get ExchangeHeroFightReportAddr() : Vector.<String>
      {
         return this.FExchangeHeroFightReportAddr;
      }
      
      public function set ExchangeHeroFightReportAddr(param1:Vector.<String>) : void
      {
         this.FExchangeHeroFightReportAddr = param1;
      }
      
      public function get TitleIfGet() : Boolean
      {
         return this.FTitleIfGet;
      }
      
      public function set TitleIfGet(param1:Boolean) : void
      {
         this.FTitleIfGet = param1;
      }
      
      public function set BuyRoseArticls(param1:Vector.<TInventories>) : void
      {
         this.FBuyRoseArticls = param1;
      }
      
      public function get BuyRoseAward() : Vector.<int>
      {
         return this.FBuyRoseAward;
      }
      
      public function set BuyRoseAward(param1:Vector.<int>) : void
      {
         this.FBuyRoseAward = param1;
      }
      
      public function get BuyRoseArticls() : Vector.<TInventories>
      {
         return this.FBuyRoseArticls;
      }
      
      public function get TaskInventories() : Vector.<TInventories>
      {
         return this.FTaskInventories;
      }
   }
}

