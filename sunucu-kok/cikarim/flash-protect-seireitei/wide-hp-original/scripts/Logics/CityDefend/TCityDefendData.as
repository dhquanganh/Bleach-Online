package Logics.CityDefend
{
   public class TCityDefendData
   {
      
      protected var FHeroList:TCityDefendHeros;
      
      protected var FDoorHeroList:TCityDefendHeros;
      
      protected var FReportList:TCityDefendReports;
      
      protected var FOrganizationRank:TCityDefendRanks;
      
      protected var FHeroRank:TCityDefendRanks;
      
      protected var FCityDefendType:uint;
      
      protected var FBeferStartColdDown:uint;
      
      protected var FReviveColdDown:uint;
      
      protected var FActivityColdDown:uint;
      
      protected var FDefendOrganizationName:String;
      
      protected var FCityDoorIndex:uint;
      
      protected var FWorldLevel:uint;
      
      protected var FCityDoorTotleHp:uint;
      
      protected var FCityDoorCurHp:Number;
      
      protected var FBoomLevel:uint;
      
      protected var FBuyCount:uint;
      
      protected var FDefendBuffLevel:uint;
      
      protected var FOrganizationBuffLevel:uint;
      
      public function TCityDefendData()
      {
         super();
         this.FHeroList = new TCityDefendHeros();
         this.FDoorHeroList = new TCityDefendHeros();
         this.FReportList = new TCityDefendReports();
         this.FOrganizationRank = new TCityDefendRanks();
         this.FHeroRank = new TCityDefendRanks();
      }
      
      public function get HeroList() : TCityDefendHeros
      {
         return this.FHeroList;
      }
      
      public function get DoorHeroList() : TCityDefendHeros
      {
         return this.FDoorHeroList;
      }
      
      public function get ReportList() : TCityDefendReports
      {
         return this.FReportList;
      }
      
      public function get OrganizationRank() : TCityDefendRanks
      {
         return this.FOrganizationRank;
      }
      
      public function get HeroRank() : TCityDefendRanks
      {
         return this.FHeroRank;
      }
      
      public function get CityDefendType() : uint
      {
         return this.FCityDefendType;
      }
      
      public function set CityDefendType(param1:uint) : void
      {
         this.FCityDefendType = param1;
      }
      
      public function get BeferStartColdDown() : uint
      {
         return this.FBeferStartColdDown;
      }
      
      public function set BeferStartColdDown(param1:uint) : void
      {
         this.FBeferStartColdDown = param1;
      }
      
      public function get ReviveColdDown() : uint
      {
         return this.FReviveColdDown;
      }
      
      public function set ReviveColdDown(param1:uint) : void
      {
         this.FReviveColdDown = param1;
      }
      
      public function get ActivityColdDown() : uint
      {
         return this.FActivityColdDown;
      }
      
      public function set ActivityColdDown(param1:uint) : void
      {
         this.FActivityColdDown = param1;
      }
      
      public function get DefendOrganizationName() : String
      {
         return this.FDefendOrganizationName;
      }
      
      public function set DefendOrganizationName(param1:String) : void
      {
         this.FDefendOrganizationName = param1;
      }
      
      public function get CityDoorIndex() : uint
      {
         return this.FCityDoorIndex;
      }
      
      public function set CityDoorIndex(param1:uint) : void
      {
         this.FCityDoorIndex = param1;
      }
      
      public function get WorldLevel() : uint
      {
         return this.FWorldLevel;
      }
      
      public function set WorldLevel(param1:uint) : void
      {
         this.FWorldLevel = param1;
      }
      
      public function get CityDoorTotleHp() : uint
      {
         return this.FCityDoorTotleHp;
      }
      
      public function set CityDoorTotleHp(param1:uint) : void
      {
         this.FCityDoorTotleHp = param1;
      }
      
      public function get CityDoorCurHp() : Number
      {
         return this.FCityDoorCurHp;
      }
      
      public function set CityDoorCurHp(param1:Number) : void
      {
         this.FCityDoorCurHp = param1;
      }
      
      public function get BoomLevel() : uint
      {
         return this.FBoomLevel;
      }
      
      public function set BoomLevel(param1:uint) : void
      {
         this.FBoomLevel = param1;
      }
      
      public function get BuyCount() : uint
      {
         return this.FBuyCount;
      }
      
      public function set BuyCount(param1:uint) : void
      {
         this.FBuyCount = param1;
      }
      
      public function get DefendBuffLevel() : uint
      {
         return this.FDefendBuffLevel;
      }
      
      public function set DefendBuffLevel(param1:uint) : void
      {
         this.FDefendBuffLevel = param1;
      }
      
      public function get OrganizationBuffLevel() : uint
      {
         return this.FOrganizationBuffLevel;
      }
      
      public function set OrganizationBuffLevel(param1:uint) : void
      {
         this.FOrganizationBuffLevel = param1;
      }
   }
}

