package Logics.Mentorship.Elements
{
   public class TArrestPlayer
   {
      
      protected var FType:uint;
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      protected var FGuildName:String;
      
      protected var FIdentity:uint;
      
      protected var FDiscipleCount:uint;
      
      protected var FInteractionCDTime:uint;
      
      protected var FMasterName:String;
      
      public function TArrestPlayer()
      {
         super();
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get Identifier0() : uint
      {
         return this.FIdentifier0;
      }
      
      public function set Identifier0(param1:uint) : void
      {
         this.FIdentifier0 = param1;
      }
      
      public function get Identifier1() : uint
      {
         return this.FIdentifier1;
      }
      
      public function set Identifier1(param1:uint) : void
      {
         this.FIdentifier1 = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get GuildName() : String
      {
         return this.FGuildName;
      }
      
      public function set GuildName(param1:String) : void
      {
         this.FGuildName = param1;
      }
      
      public function get Identity() : uint
      {
         return this.FIdentity;
      }
      
      public function set Identity(param1:uint) : void
      {
         this.FIdentity = param1;
      }
      
      public function get DiscipleCount() : uint
      {
         return this.FDiscipleCount;
      }
      
      public function set DiscipleCount(param1:uint) : void
      {
         this.FDiscipleCount = param1;
      }
      
      public function get InteractionCDTime() : uint
      {
         return this.FInteractionCDTime;
      }
      
      public function set InteractionCDTime(param1:uint) : void
      {
         this.FInteractionCDTime = param1;
      }
      
      public function get MasterName() : String
      {
         return this.FMasterName;
      }
      
      public function set MasterName(param1:String) : void
      {
         this.FMasterName = param1;
      }
   }
}

