package Processors.Game.MiniBattle.Mode
{
   public class TBattleSoldierInfor
   {
      
      protected var FCurrentHP:int;
      
      protected var FTotalHP:int;
      
      protected var FLastHp:int;
      
      protected var FName:String;
      
      protected var FTemplateID:uint;
      
      protected var FMoudleID:uint;
      
      protected var FQuality:int;
      
      protected var FPosition:uint;
      
      protected var FDirection:int;
      
      protected var FSoldierType:int;
      
      protected var FCampID:uint;
      
      public function TBattleSoldierInfor()
      {
         super();
      }
      
      public function get CurrentHP() : int
      {
         return this.FCurrentHP;
      }
      
      public function set CurrentHP(param1:int) : void
      {
         this.FCurrentHP = param1;
      }
      
      public function get TotalHP() : int
      {
         return this.FTotalHP;
      }
      
      public function set TotalHP(param1:int) : void
      {
         this.FTotalHP = param1;
      }
      
      public function get TemplateID() : uint
      {
         return this.FTemplateID;
      }
      
      public function set TemplateID(param1:uint) : void
      {
         this.FTemplateID = param1;
      }
      
      public function get Position() : uint
      {
         return this.FPosition;
      }
      
      public function set Position(param1:uint) : void
      {
         this.FPosition = param1;
      }
      
      public function get Direction() : int
      {
         return this.FDirection;
      }
      
      public function set Direction(param1:int) : void
      {
         this.FDirection = param1;
      }
      
      public function get SoldierType() : int
      {
         return this.FSoldierType;
      }
      
      public function set SoldierType(param1:int) : void
      {
         this.FSoldierType = param1;
      }
      
      public function get CampID() : uint
      {
         return this.FCampID;
      }
      
      public function set CampID(param1:uint) : void
      {
         this.FCampID = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get LastHp() : int
      {
         return this.FLastHp;
      }
      
      public function set LastHp(param1:int) : void
      {
         this.FLastHp = param1;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:int) : void
      {
         this.FQuality = param1;
      }
      
      public function get MoudleID() : uint
      {
         return this.FMoudleID;
      }
      
      public function set MoudleID(param1:uint) : void
      {
         this.FMoudleID = param1;
      }
      
      public function Reset() : void
      {
      }
   }
}

