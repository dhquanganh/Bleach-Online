package Logics.HDActivityMode
{
   public class TActivityCrossServerRank
   {
      
      protected var FHighID:uint;
      
      protected var FLowID:uint;
      
      protected var FName:String;
      
      protected var FServerID:uint;
      
      protected var FAgentID:uint;
      
      protected var FRank:uint;
      
      protected var FPoint:uint;
      
      protected var FPower:uint;
      
      protected var FLevel:uint;
      
      protected var FClassLevel:uint;
      
      public function TActivityCrossServerRank()
      {
         super();
      }
      
      public function get HighID() : uint
      {
         return this.FHighID;
      }
      
      public function set HighID(param1:uint) : void
      {
         this.FHighID = param1;
      }
      
      public function get LowID() : uint
      {
         return this.FLowID;
      }
      
      public function set LowID(param1:uint) : void
      {
         this.FLowID = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get ServerID() : uint
      {
         return this.FServerID;
      }
      
      public function set ServerID(param1:uint) : void
      {
         this.FServerID = param1;
      }
      
      public function get Point() : uint
      {
         return this.FPoint;
      }
      
      public function set Point(param1:uint) : void
      {
         this.FPoint = param1;
      }
      
      public function get Power() : uint
      {
         return this.FPower;
      }
      
      public function set Power(param1:uint) : void
      {
         this.FPower = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get ClassLevel() : uint
      {
         return this.FClassLevel;
      }
      
      public function set ClassLevel(param1:uint) : void
      {
         this.FClassLevel = param1;
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get AgentID() : uint
      {
         return this.FAgentID;
      }
      
      public function set AgentID(param1:uint) : void
      {
         this.FAgentID = param1;
      }
   }
}

