package Logics.HDChristmas2015.VO
{
   import Logics.DatebaseVO.VO.THDChristmasSock;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityChristmasSock extends TActivityOSBase
   {
      
      protected var FTaskStatus:Vector.<int>;
      
      protected var FTaskGifts:Vector.<TInventories>;
      
      protected var FSockNum:uint;
      
      protected var FRound:uint;
      
      protected var FSockStatus:Vector.<int>;
      
      protected var FSocksGift:Vector.<TInventories>;
      
      protected var FJackPointStatus:int;
      
      protected var FRankVec:Vector.<TActivityServerRank>;
      
      protected var FConfig:THDChristmasSock;
      
      public function TActivityChristmasSock()
      {
         super();
         this.FTaskGifts = new Vector.<TInventories>();
         this.FSocksGift = new Vector.<TInventories>();
         this.FTaskStatus = new Vector.<int>();
         this.FSockStatus = new Vector.<int>();
         this.FRankVec = new Vector.<TActivityServerRank>();
      }
      
      public function get Config() : THDChristmasSock
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChristmasSock) : void
      {
         this.FConfig = param1;
      }
      
      public function get TaskStatus() : Vector.<int>
      {
         return this.FTaskStatus;
      }
      
      public function set TaskStatus(param1:Vector.<int>) : void
      {
         this.FTaskStatus = param1;
      }
      
      public function get SockNum() : uint
      {
         return this.FSockNum;
      }
      
      public function set SockNum(param1:uint) : void
      {
         this.FSockNum = param1;
      }
      
      public function get SockStatus() : Vector.<int>
      {
         return this.FSockStatus;
      }
      
      public function set SockStatus(param1:Vector.<int>) : void
      {
         this.FSockStatus = param1;
      }
      
      public function get JackPointStatus() : int
      {
         return this.FJackPointStatus;
      }
      
      public function set JackPointStatus(param1:int) : void
      {
         this.FJackPointStatus = param1;
      }
      
      public function get Round() : uint
      {
         return this.FRound;
      }
      
      public function set Round(param1:uint) : void
      {
         this.FRound = param1;
      }
      
      public function get TaskGifts() : Vector.<TInventories>
      {
         return this.FTaskGifts;
      }
      
      public function set TaskGifts(param1:Vector.<TInventories>) : void
      {
         this.FTaskGifts = param1;
      }
      
      public function get SocksGift() : Vector.<TInventories>
      {
         return this.FSocksGift;
      }
      
      public function set SocksGift(param1:Vector.<TInventories>) : void
      {
         this.FSocksGift = param1;
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

