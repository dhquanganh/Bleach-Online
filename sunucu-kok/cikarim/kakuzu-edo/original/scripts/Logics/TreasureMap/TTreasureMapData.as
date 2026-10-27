package Logics.TreasureMap
{
   public class TTreasureMapData
   {
      
      protected var FFightHeroList:TTreasureMapHeros;
      
      protected var FReportList:TTreasureMapReports;
      
      protected var FCurEnterTimes:int;
      
      protected var FCurRefreshTimes:int;
      
      protected var FCurQuality:uint;
      
      protected var FTreasureStatus:Boolean;
      
      protected var FRobberyTimes:int;
      
      protected var FVipBuyCount:uint;
      
      protected var FBlueStar:uint;
      
      protected var FRedStar:uint;
      
      protected var FTreasureTimes:uint;
      
      public function TTreasureMapData()
      {
         super();
         this.FFightHeroList = new TTreasureMapHeros();
         this.FReportList = new TTreasureMapReports();
      }
      
      public function get FightHeroList() : TTreasureMapHeros
      {
         return this.FFightHeroList;
      }
      
      public function set FightHeroList(param1:TTreasureMapHeros) : void
      {
         this.FFightHeroList = param1;
      }
      
      public function get ReportList() : TTreasureMapReports
      {
         return this.FReportList;
      }
      
      public function set ReportList(param1:TTreasureMapReports) : void
      {
         this.FReportList = param1;
      }
      
      public function get CurEnterTimes() : int
      {
         return this.FCurEnterTimes;
      }
      
      public function set CurEnterTimes(param1:int) : void
      {
         this.FCurEnterTimes = param1;
      }
      
      public function get CurRefreshTimes() : int
      {
         return this.FCurRefreshTimes;
      }
      
      public function set CurRefreshTimes(param1:int) : void
      {
         this.FCurRefreshTimes = param1;
      }
      
      public function get CurQuality() : int
      {
         return this.FCurQuality;
      }
      
      public function set CurQuality(param1:int) : void
      {
         this.FCurQuality = param1;
      }
      
      public function get TreasureStatus() : Boolean
      {
         return this.FTreasureStatus;
      }
      
      public function set TreasureStatus(param1:Boolean) : void
      {
         this.FTreasureStatus = param1;
      }
      
      public function get RobberyTimes() : uint
      {
         return this.FRobberyTimes;
      }
      
      public function set RobberyTimes(param1:uint) : void
      {
         this.FRobberyTimes = param1;
      }
      
      public function get VipBuyCount() : uint
      {
         return this.FVipBuyCount;
      }
      
      public function set VipBuyCount(param1:uint) : void
      {
         this.FVipBuyCount = param1;
      }
      
      public function get BlueStar() : uint
      {
         return this.FBlueStar;
      }
      
      public function set BlueStar(param1:uint) : void
      {
         this.FBlueStar = param1;
      }
      
      public function get RedStar() : uint
      {
         return this.FRedStar;
      }
      
      public function set RedStar(param1:uint) : void
      {
         this.FRedStar = param1;
      }
      
      public function get TreasureTimes() : uint
      {
         return this.FTreasureTimes;
      }
      
      public function set TreasureTimes(param1:uint) : void
      {
         this.FTreasureTimes = param1;
      }
   }
}

