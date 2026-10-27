package Logics.Arena
{
   public class TArenaData
   {
      
      protected var FFightHeroList:TArenaHeros;
      
      protected var FHeroPanelList:TArenaHeros;
      
      protected var FReportList:TArenaReports;
      
      protected var FBoxType:int;
      
      protected var FBoxRanking:int;
      
      protected var FBoxLevel:int;
      
      protected var FFightTimes:int;
      
      protected var FAddTimes:int;
      
      protected var FColdDown:uint;
      
      protected var FHighRanking:int;
      
      protected var FCurRanking:int;
      
      protected var FStreakWin:int;
      
      protected var FColdDownBox:int;
      
      public function TArenaData()
      {
         super();
         this.FFightHeroList = new TArenaHeros();
         this.FHeroPanelList = new TArenaHeros();
         this.FReportList = new TArenaReports();
      }
      
      public function get FightHeroList() : TArenaHeros
      {
         return this.FFightHeroList;
      }
      
      public function set FightHeroList(param1:TArenaHeros) : void
      {
         this.FFightHeroList = param1;
      }
      
      public function get HeroPanelList() : TArenaHeros
      {
         return this.FHeroPanelList;
      }
      
      public function set HeroPanelList(param1:TArenaHeros) : void
      {
         this.FHeroPanelList = param1;
      }
      
      public function get ReportList() : TArenaReports
      {
         return this.FReportList;
      }
      
      public function set ReportList(param1:TArenaReports) : void
      {
         this.FReportList = param1;
      }
      
      public function get BoxType() : int
      {
         return this.FBoxType;
      }
      
      public function set BoxType(param1:int) : void
      {
         this.FBoxType = param1;
      }
      
      public function get BoxRanking() : int
      {
         return this.FBoxRanking;
      }
      
      public function set BoxRanking(param1:int) : void
      {
         this.FBoxRanking = param1;
      }
      
      public function get BoxLevel() : int
      {
         return this.FBoxLevel;
      }
      
      public function set BoxLevel(param1:int) : void
      {
         this.FBoxLevel = param1;
      }
      
      public function get FightTimes() : int
      {
         return this.FFightTimes;
      }
      
      public function set FightTimes(param1:int) : void
      {
         this.FFightTimes = param1;
      }
      
      public function get AddTimes() : int
      {
         return this.FAddTimes;
      }
      
      public function set AddTimes(param1:int) : void
      {
         this.FAddTimes = param1;
      }
      
      public function get ColdDown() : uint
      {
         return this.FColdDown;
      }
      
      public function set ColdDown(param1:uint) : void
      {
         this.FColdDown = param1;
      }
      
      public function get HighRanking() : int
      {
         return this.FHighRanking;
      }
      
      public function set HighRanking(param1:int) : void
      {
         this.FHighRanking = param1;
      }
      
      public function get CurRanking() : int
      {
         return this.FCurRanking;
      }
      
      public function set CurRanking(param1:int) : void
      {
         this.FCurRanking = param1;
      }
      
      public function get StreakWin() : int
      {
         return this.FStreakWin;
      }
      
      public function set StreakWin(param1:int) : void
      {
         this.FStreakWin = param1;
      }
      
      public function get ColdDownBox() : int
      {
         return this.FColdDownBox;
      }
      
      public function set ColdDownBox(param1:int) : void
      {
         this.FColdDownBox = param1;
      }
   }
}

