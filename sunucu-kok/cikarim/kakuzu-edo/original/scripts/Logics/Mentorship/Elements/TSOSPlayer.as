package Logics.Mentorship.Elements
{
   public class TSOSPlayer
   {
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      protected var FGuildName:String;
      
      protected var FIdentity:uint;
      
      protected var FDiscipleCount:uint;
      
      protected var FHasSOS:uint;
      
      protected var FFrom:uint;
      
      public function TSOSPlayer()
      {
         super();
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
      
      public function get HasSOS() : uint
      {
         return this.FHasSOS;
      }
      
      public function set HasSOS(param1:uint) : void
      {
         this.FHasSOS = param1;
      }
      
      public function get From() : uint
      {
         return this.FFrom;
      }
      
      public function set From(param1:uint) : void
      {
         this.FFrom = param1;
      }
   }
}

