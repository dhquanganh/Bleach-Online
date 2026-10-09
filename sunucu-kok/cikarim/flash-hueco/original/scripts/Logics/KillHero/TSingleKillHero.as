package Logics.KillHero
{
   public class TSingleKillHero
   {
      
      private var FKillHeroId:int;
      
      private var FBestId:String;
      
      private var FBestName:String;
      
      private var FFirstId:String;
      
      private var FFirstName:String;
      
      private var FIsPassed:Boolean;
      
      private var FHeroIds:Vector.<int>;
      
      protected var FEnterCount:uint;
      
      protected var FResetCount:uint;
      
      public function TSingleKillHero(param1:int)
      {
         super();
         this.FHeroIds = new Vector.<int>();
         this.FKillHeroId = param1;
         this.FBestId = "";
         this.FBestName = "";
         this.FFirstId = "";
         this.FFirstName = "";
      }
      
      public function get KillHeroId() : int
      {
         return this.FKillHeroId;
      }
      
      public function get BestId() : String
      {
         return this.FBestId;
      }
      
      public function set BestId(param1:String) : void
      {
         this.FBestId = param1;
      }
      
      public function get BestName() : String
      {
         return this.FBestName;
      }
      
      public function set BestName(param1:String) : void
      {
         this.FBestName = param1;
      }
      
      public function get FirstId() : String
      {
         return this.FFirstId;
      }
      
      public function set FirstId(param1:String) : void
      {
         this.FFirstId = param1;
      }
      
      public function get FirstName() : String
      {
         return this.FFirstName;
      }
      
      public function set FirstName(param1:String) : void
      {
         this.FFirstName = param1;
      }
      
      public function get EnterCount() : uint
      {
         return this.FEnterCount;
      }
      
      public function set EnterCount(param1:uint) : void
      {
         this.FEnterCount = param1;
      }
      
      public function get ResetCount() : uint
      {
         return this.FResetCount;
      }
      
      public function set ResetCount(param1:uint) : void
      {
         this.FResetCount = param1;
      }
      
      public function get IsPassed() : Boolean
      {
         return this.FIsPassed;
      }
      
      public function set IsPassed(param1:Boolean) : void
      {
         this.FIsPassed = param1;
      }
      
      public function get IsTodayPass() : Boolean
      {
         return this.FEnterCount > this.FResetCount;
      }
      
      public function get HeroIds() : Vector.<int>
      {
         return this.FHeroIds;
      }
      
      public function set HeroIds(param1:Vector.<int>) : void
      {
         this.FHeroIds = param1;
      }
   }
}

