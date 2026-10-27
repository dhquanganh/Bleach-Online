package Logics.KnifeSoul
{
   public class TKnifeSoulData
   {
      
      protected var FID:uint;
      
      protected var FNextID:uint;
      
      protected var FLevel:int;
      
      protected var FLevelLimit:int;
      
      protected var FNeedExp:int;
      
      protected var FPower:int;
      
      protected var FAgile:int;
      
      protected var FIntelligence:int;
      
      protected var FLife:int;
      
      protected var FAddedPower:int;
      
      protected var FAddedAgile:int;
      
      protected var FAddedIntelligence:int;
      
      protected var FAddedLife:int;
      
      protected var FCurrentExp:uint;
      
      protected var FSmallCritNum:uint;
      
      protected var FBigCritNum:uint;
      
      protected var FGainExp:uint;
      
      protected var FChangedID:uint;
      
      protected var FIfFight:Boolean;
      
      protected var FCurrentModuleID:uint;
      
      protected var FCurrentName:String;
      
      public function TKnifeSoulData()
      {
         super();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get NextID() : uint
      {
         return this.FNextID;
      }
      
      public function set NextID(param1:uint) : void
      {
         this.FNextID = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get LevelLimit() : int
      {
         return this.FLevelLimit;
      }
      
      public function set LevelLimit(param1:int) : void
      {
         this.FLevelLimit = param1;
      }
      
      public function get NeedExp() : int
      {
         return this.FNeedExp;
      }
      
      public function set NeedExp(param1:int) : void
      {
         this.FNeedExp = param1;
      }
      
      public function get Power() : int
      {
         return this.FPower;
      }
      
      public function set Power(param1:int) : void
      {
         this.FPower = param1;
      }
      
      public function get Agile() : int
      {
         return this.FAgile;
      }
      
      public function set Agile(param1:int) : void
      {
         this.FAgile = param1;
      }
      
      public function get Intelligence() : int
      {
         return this.FIntelligence;
      }
      
      public function set Intelligence(param1:int) : void
      {
         this.FIntelligence = param1;
      }
      
      public function get Life() : int
      {
         return this.FLife;
      }
      
      public function set Life(param1:int) : void
      {
         this.FLife = param1;
      }
      
      public function get CurrentExp() : uint
      {
         return this.FCurrentExp;
      }
      
      public function set CurrentExp(param1:uint) : void
      {
         this.FCurrentExp = param1;
      }
      
      public function get SmallCritNum() : uint
      {
         return this.FSmallCritNum;
      }
      
      public function set SmallCritNum(param1:uint) : void
      {
         this.FSmallCritNum = param1;
      }
      
      public function get BigCritNum() : uint
      {
         return this.FBigCritNum;
      }
      
      public function set BigCritNum(param1:uint) : void
      {
         this.FBigCritNum = param1;
      }
      
      public function get GainExp() : uint
      {
         return this.FGainExp;
      }
      
      public function set GainExp(param1:uint) : void
      {
         this.FGainExp = param1;
      }
      
      public function get ChangedID() : uint
      {
         return this.FChangedID;
      }
      
      public function set ChangedID(param1:uint) : void
      {
         this.FChangedID = param1;
      }
      
      public function get CurrentModuleID() : uint
      {
         return this.FCurrentModuleID;
      }
      
      public function set CurrentModuleID(param1:uint) : void
      {
         this.FCurrentModuleID = param1;
      }
      
      public function get IfFight() : Boolean
      {
         return this.FChangedID != 0;
      }
      
      public function get AddedPower() : int
      {
         return this.FAddedPower;
      }
      
      public function set AddedPower(param1:int) : void
      {
         this.FAddedPower = param1;
      }
      
      public function get AddedAgile() : int
      {
         return this.FAddedAgile;
      }
      
      public function set AddedAgile(param1:int) : void
      {
         this.FAddedAgile = param1;
      }
      
      public function get AddedIntelligence() : int
      {
         return this.FAddedIntelligence;
      }
      
      public function set AddedIntelligence(param1:int) : void
      {
         this.FAddedIntelligence = param1;
      }
      
      public function get AddedLife() : int
      {
         return this.FAddedLife;
      }
      
      public function set AddedLife(param1:int) : void
      {
         this.FAddedLife = param1;
      }
      
      public function get CurrentName() : String
      {
         return this.FCurrentName;
      }
      
      public function set CurrentName(param1:String) : void
      {
         this.FCurrentName = param1;
      }
   }
}

