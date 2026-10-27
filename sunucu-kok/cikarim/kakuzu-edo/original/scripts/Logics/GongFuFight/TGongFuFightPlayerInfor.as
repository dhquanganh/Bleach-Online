package Logics.GongFuFight
{
   public class TGongFuFightPlayerInfor
   {
      
      protected var FPlayerIndex:int;
      
      protected var FPlayerName:String;
      
      protected var FPlayerServerName:String;
      
      protected var FPlayerMainHeroID:uint;
      
      protected var FPlayerFriendID:Vector.<uint>;
      
      protected var FPlayerLevel:uint;
      
      protected var FPlayerQuality:uint;
      
      protected var FPlayerFightPowerValue:uint;
      
      protected var FPlayerPet:uint;
      
      protected var FPlayerScore:uint;
      
      protected var FType:uint;
      
      protected var FKnifeID:uint;
      
      protected var FState:int;
      
      public function TGongFuFightPlayerInfor()
      {
         super();
         this.FPlayerFriendID = new Vector.<uint>();
      }
      
      public function get PlayerIndex() : int
      {
         return this.FPlayerIndex;
      }
      
      public function set PlayerIndex(param1:int) : void
      {
         this.FPlayerIndex = param1;
      }
      
      public function get PlayerName() : String
      {
         return this.FPlayerName;
      }
      
      public function set PlayerName(param1:String) : void
      {
         this.FPlayerName = param1;
      }
      
      public function get PlayerServerName() : String
      {
         return this.FPlayerServerName;
      }
      
      public function set PlayerServerName(param1:String) : void
      {
         this.FPlayerServerName = param1;
      }
      
      public function get PlayerMainHeroID() : uint
      {
         return this.FPlayerMainHeroID;
      }
      
      public function set PlayerMainHeroID(param1:uint) : void
      {
         this.FPlayerMainHeroID = param1;
      }
      
      public function get PlayerFriendID() : Vector.<uint>
      {
         return this.FPlayerFriendID;
      }
      
      public function set PlayerFriendID(param1:Vector.<uint>) : void
      {
         this.FPlayerFriendID = param1;
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:uint) : void
      {
         this.FPlayerLevel = param1;
      }
      
      public function get PlayerQuality() : uint
      {
         return this.FPlayerQuality;
      }
      
      public function set PlayerQuality(param1:uint) : void
      {
         this.FPlayerQuality = param1;
      }
      
      public function get PlayerFightPowerValue() : uint
      {
         return this.FPlayerFightPowerValue;
      }
      
      public function set PlayerFightPowerValue(param1:uint) : void
      {
         this.FPlayerFightPowerValue = param1;
      }
      
      public function get PlayerPet() : uint
      {
         return this.FPlayerPet;
      }
      
      public function set PlayerPet(param1:uint) : void
      {
         this.FPlayerPet = param1;
      }
      
      public function get PlayerScore() : uint
      {
         return this.FPlayerScore;
      }
      
      public function set PlayerScore(param1:uint) : void
      {
         this.FPlayerScore = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get KnifeID() : uint
      {
         return this.FKnifeID;
      }
      
      public function set KnifeID(param1:uint) : void
      {
         this.FKnifeID = param1;
      }
   }
}

