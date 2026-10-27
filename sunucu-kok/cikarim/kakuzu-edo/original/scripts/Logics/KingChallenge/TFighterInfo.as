package Logics.KingChallenge
{
   public class TFighterInfo
   {
      
      protected var FFightNum:int;
      
      protected var FAttUserLowId:uint;
      
      protected var FAttUserHighId:uint;
      
      protected var FDefUserLowId:uint;
      
      protected var FDefUserHighId:uint;
      
      protected var FRet:int;
      
      protected var FAttUserInfo:TPlayerInfo;
      
      protected var FDefUserInfo:TPlayerInfo;
      
      protected var FAttUserName:String;
      
      protected var FDefUserName:String;
      
      protected var FReport:String;
      
      protected var FGambleTimeEnd:uint;
      
      public function TFighterInfo()
      {
         super();
      }
      
      public function get FightNum() : int
      {
         return this.FFightNum;
      }
      
      public function set FightNum(param1:int) : void
      {
         this.FFightNum = param1;
      }
      
      public function get AttUserLowId() : uint
      {
         return this.FAttUserLowId;
      }
      
      public function set AttUserLowId(param1:uint) : void
      {
         this.FAttUserLowId = param1;
      }
      
      public function get AttUserHighId() : uint
      {
         return this.FAttUserHighId;
      }
      
      public function set AttUserHighId(param1:uint) : void
      {
         this.FAttUserHighId = param1;
      }
      
      public function get DefUserLowId() : uint
      {
         return this.FDefUserLowId;
      }
      
      public function set DefUserLowId(param1:uint) : void
      {
         this.FDefUserLowId = param1;
      }
      
      public function get DefUserHighId() : uint
      {
         return this.FDefUserHighId;
      }
      
      public function set DefUserHighId(param1:uint) : void
      {
         this.FDefUserHighId = param1;
      }
      
      public function get Ret() : int
      {
         return this.FRet;
      }
      
      public function set Ret(param1:int) : void
      {
         this.FRet = param1;
      }
      
      public function get AttUserInfo() : TPlayerInfo
      {
         return this.FAttUserInfo;
      }
      
      public function set AttUserInfo(param1:TPlayerInfo) : void
      {
         this.FAttUserInfo = param1;
      }
      
      public function get DefUserInfo() : TPlayerInfo
      {
         return this.FDefUserInfo;
      }
      
      public function set DefUserInfo(param1:TPlayerInfo) : void
      {
         this.FDefUserInfo = param1;
      }
      
      public function get GambleTimeEnd() : uint
      {
         return this.FGambleTimeEnd;
      }
      
      public function set GambleTimeEnd(param1:uint) : void
      {
         this.FGambleTimeEnd = param1;
      }
      
      public function get Report() : String
      {
         return this.FReport;
      }
      
      public function set Report(param1:String) : void
      {
         this.FReport = param1;
      }
      
      public function get AttUserName() : String
      {
         return this.FAttUserName;
      }
      
      public function set AttUserName(param1:String) : void
      {
         this.FAttUserName = param1;
      }
      
      public function get DefUserName() : String
      {
         return this.FDefUserName;
      }
      
      public function set DefUserName(param1:String) : void
      {
         this.FDefUserName = param1;
      }
   }
}

