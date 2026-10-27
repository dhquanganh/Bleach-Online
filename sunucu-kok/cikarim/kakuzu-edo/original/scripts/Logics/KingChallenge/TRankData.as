package Logics.KingChallenge
{
   public class TRankData
   {
      
      protected var FLowId:uint;
      
      protected var FHighId:uint;
      
      protected var FAgentId:uint;
      
      protected var FServerId:uint;
      
      protected var FUserName:String;
      
      protected var FServerName:String;
      
      protected var FRank:uint;
      
      protected var FPower:uint;
      
      public function TRankData()
      {
         super();
      }
      
      public function get LowId() : uint
      {
         return this.FLowId;
      }
      
      public function set LowId(param1:uint) : void
      {
         this.FLowId = param1;
      }
      
      public function get HighId() : uint
      {
         return this.FHighId;
      }
      
      public function set HighId(param1:uint) : void
      {
         this.FHighId = param1;
      }
      
      public function get AgentId() : uint
      {
         return this.FAgentId;
      }
      
      public function set AgentId(param1:uint) : void
      {
         this.FAgentId = param1;
      }
      
      public function get ServerId() : uint
      {
         return this.FServerId;
      }
      
      public function set ServerId(param1:uint) : void
      {
         this.FServerId = param1;
      }
      
      public function get UserName() : String
      {
         return this.FUserName;
      }
      
      public function set UserName(param1:String) : void
      {
         this.FUserName = param1;
      }
      
      public function get ServerName() : String
      {
         return this.FServerName;
      }
      
      public function set ServerName(param1:String) : void
      {
         this.FServerName = param1;
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get Power() : uint
      {
         return this.FPower;
      }
      
      public function set Power(param1:uint) : void
      {
         this.FPower = param1;
      }
   }
}

