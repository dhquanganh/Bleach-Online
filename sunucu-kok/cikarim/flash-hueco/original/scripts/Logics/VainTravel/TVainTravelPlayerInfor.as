package Logics.VainTravel
{
   import Logics.TypeCodeAmount.TTypeCodeAmounts;
   
   public class TVainTravelPlayerInfor
   {
      
      protected var FIndex:int;
      
      protected var FPlayerIDHigh:uint;
      
      protected var FPlayerIDLow:uint;
      
      protected var FPlatformName:String;
      
      protected var FServerID:int;
      
      protected var FPlayerName:String;
      
      protected var FPlayerLevel:int;
      
      protected var FPlayerSkillID:int;
      
      protected var FPlayerPower:int;
      
      protected var FKnifeID:int;
      
      protected var FKnifeSchedule:int;
      
      protected var FHeroTemplateID:Vector.<int>;
      
      protected var FHeroLevel:Vector.<int>;
      
      protected var FHeroBloodRate:Vector.<int>;
      
      protected var FHeroChangeSchdule:Vector.<int>;
      
      protected var FHeroFightPos:Vector.<int>;
      
      protected var FAwards:TTypeCodeAmounts;
      
      protected var FCurrentState:int;
      
      public function TVainTravelPlayerInfor()
      {
         super();
         this.FHeroTemplateID = new Vector.<int>();
         this.FHeroLevel = new Vector.<int>();
         this.FHeroBloodRate = new Vector.<int>();
         this.FHeroChangeSchdule = new Vector.<int>();
         this.FHeroFightPos = new Vector.<int>();
         this.FAwards = new TTypeCodeAmounts();
      }
      
      protected function get HeroCount() : int
      {
         return this.FHeroLevel.length;
      }
      
      public function get PlatformName() : String
      {
         return this.FPlatformName;
      }
      
      public function set PlatformName(param1:String) : void
      {
         this.FPlatformName = param1;
      }
      
      public function get ServerID() : int
      {
         return this.FServerID;
      }
      
      public function set ServerID(param1:int) : void
      {
         this.FServerID = param1;
      }
      
      public function get PlayerName() : String
      {
         return this.FPlayerName;
      }
      
      public function set PlayerName(param1:String) : void
      {
         this.FPlayerName = param1;
      }
      
      public function get PlayerSkillID() : int
      {
         return this.FPlayerSkillID;
      }
      
      public function set PlayerSkillID(param1:int) : void
      {
         this.FPlayerSkillID = param1;
      }
      
      public function get PlayerPower() : int
      {
         return this.FPlayerPower;
      }
      
      public function set PlayerPower(param1:int) : void
      {
         this.FPlayerPower = param1;
      }
      
      public function get KnifeID() : int
      {
         return this.FKnifeID;
      }
      
      public function set KnifeID(param1:int) : void
      {
         this.FKnifeID = param1;
      }
      
      public function get KnifeSchedule() : int
      {
         return this.FKnifeSchedule;
      }
      
      public function set KnifeSchedule(param1:int) : void
      {
         this.FKnifeSchedule = param1;
      }
      
      public function get HeroTemplateID() : Vector.<int>
      {
         return this.FHeroTemplateID;
      }
      
      public function get HeroLevel() : Vector.<int>
      {
         return this.FHeroLevel;
      }
      
      public function get CurrentState() : int
      {
         return this.FCurrentState;
      }
      
      public function set CurrentState(param1:int) : void
      {
         this.FCurrentState = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get PlayerIDHigh() : uint
      {
         return this.FPlayerIDHigh;
      }
      
      public function set PlayerIDHigh(param1:uint) : void
      {
         this.FPlayerIDHigh = param1;
      }
      
      public function get PlayerIDLow() : uint
      {
         return this.FPlayerIDLow;
      }
      
      public function set PlayerIDLow(param1:uint) : void
      {
         this.FPlayerIDLow = param1;
      }
      
      public function get PlayerLevel() : int
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:int) : void
      {
         this.FPlayerLevel = param1;
      }
      
      public function get HeroChangeSchdule() : Vector.<int>
      {
         return this.FHeroChangeSchdule;
      }
      
      public function get HeroFightPos() : Vector.<int>
      {
         return this.FHeroFightPos;
      }
      
      public function get Awards() : TTypeCodeAmounts
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:TTypeCodeAmounts) : void
      {
         this.FAwards = param1;
      }
      
      public function get HeroBloodRate() : Vector.<int>
      {
         return this.FHeroBloodRate;
      }
      
      public function HeroBloodRateByIndex(param1:int) : Number
      {
         return this.FHeroBloodRate[param1] / 100;
      }
   }
}

