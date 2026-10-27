package Logics.VainTravel
{
   public class TVainTravelFightReport
   {
      
      protected var FFightReportTime:int;
      
      protected var FFightReportType:int;
      
      protected var FFightResult:int;
      
      protected var FPlayerNameSources:String;
      
      protected var FPlayerNameDestination:String;
      
      protected var FFightAddr:String;
      
      public function TVainTravelFightReport()
      {
         super();
      }
      
      public function get FightResult() : int
      {
         return this.FFightResult;
      }
      
      public function set FightResult(param1:int) : void
      {
         this.FFightResult = param1;
      }
      
      public function get PlayerNameSources() : String
      {
         return this.FPlayerNameSources;
      }
      
      public function set PlayerNameSources(param1:String) : void
      {
         this.FPlayerNameSources = param1;
      }
      
      public function get PlayerNameDestination() : String
      {
         return this.FPlayerNameDestination;
      }
      
      public function set PlayerNameDestination(param1:String) : void
      {
         this.FPlayerNameDestination = param1;
      }
      
      public function get FightAddr() : String
      {
         return this.FFightAddr;
      }
      
      public function set FightAddr(param1:String) : void
      {
         this.FFightAddr = param1;
      }
      
      public function get FightReportTime() : int
      {
         return this.FFightReportTime;
      }
      
      public function set FightReportTime(param1:int) : void
      {
         this.FFightReportTime = param1;
      }
      
      public function get FightReportType() : int
      {
         return this.FFightReportType;
      }
      
      public function set FightReportType(param1:int) : void
      {
         this.FFightReportType = param1;
      }
   }
}

