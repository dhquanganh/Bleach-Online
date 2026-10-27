package Logics.HDAnniversary
{
   import Logics.DatebaseVO.VO.THDAnniversaryThree;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TAnniversaryThree extends TActivityOSBase
   {
      
      protected var FJoinStatus:int;
      
      protected var FGetStatus:int;
      
      protected var FPrivateLog:String;
      
      protected var FServerLog:String;
      
      protected var FAlready:uint;
      
      protected var FBag:TInventories;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FScore:int;
      
      protected var FRankVec:Vector.<TActivityServerRank>;
      
      protected var FConfig:THDAnniversaryThree;
      
      public function TAnniversaryThree()
      {
         super();
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
         this.RankVec = new Vector.<TActivityServerRank>();
      }
      
      public function get JoinStatus() : int
      {
         return this.FJoinStatus;
      }
      
      public function set JoinStatus(param1:int) : void
      {
         this.FJoinStatus = param1;
      }
      
      public function get GetStatus() : int
      {
         return this.FGetStatus;
      }
      
      public function set GetStatus(param1:int) : void
      {
         this.FGetStatus = param1;
      }
      
      public function get PrivateLog() : String
      {
         return this.FPrivateLog;
      }
      
      public function set PrivateLog(param1:String) : void
      {
         this.FPrivateLog = param1;
      }
      
      public function get ServerLog() : String
      {
         return this.FServerLog;
      }
      
      public function set ServerLog(param1:String) : void
      {
         this.FServerLog = param1;
      }
      
      public function get Already() : uint
      {
         return this.FAlready;
      }
      
      public function set Already(param1:uint) : void
      {
         this.FAlready = param1;
      }
      
      public function get Bag() : TInventories
      {
         return this.FBag;
      }
      
      public function set Bag(param1:TInventories) : void
      {
         this.FBag = param1;
      }
      
      public function get Config() : THDAnniversaryThree
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDAnniversaryThree) : void
      {
         this.FConfig = param1;
      }
      
      public function get MailStatus() : Vector.<int>
      {
         return this.FMailStatus;
      }
      
      public function set MailStatus(param1:Vector.<int>) : void
      {
         this.FMailStatus = param1;
      }
      
      public function get MailInvs() : TInventories
      {
         return this.FMailInvs;
      }
      
      public function set MailInvs(param1:TInventories) : void
      {
         this.FMailInvs = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
      
      public function get RankVec() : Vector.<TActivityServerRank>
      {
         return this.FRankVec;
      }
      
      public function set RankVec(param1:Vector.<TActivityServerRank>) : void
      {
         this.FRankVec = param1;
      }
   }
}

