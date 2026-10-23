package Logics.KingChallenge
{
   public class TBettingInfo
   {
      
      protected var FFighterNum:int;
      
      protected var FChooseLowId:uint;
      
      protected var FChooseHighId:uint;
      
      protected var FWinnerLowId:uint;
      
      protected var FWinnerHighId:uint;
      
      protected var FRewardStatus:int;
      
      protected var FAttUserInfo:TPlayerInfo;
      
      protected var FDefUserInfo:TPlayerInfo;
      
      protected var FAttUserName:String;
      
      protected var FDefUserName:String;
      
      protected var FChooseName:String;
      
      public function TBettingInfo()
      {
         super();
      }
      
      public function get FighterNum() : int
      {
         return this.FFighterNum;
      }
      
      public function set FighterNum(param1:int) : void
      {
         this.FFighterNum = param1;
      }
      
      public function get ChooseLowId() : uint
      {
         return this.FChooseLowId;
      }
      
      public function set ChooseLowId(param1:uint) : void
      {
         this.FChooseLowId = param1;
      }
      
      public function get ChooseHighId() : uint
      {
         return this.FChooseHighId;
      }
      
      public function set ChooseHighId(param1:uint) : void
      {
         this.FChooseHighId = param1;
      }
      
      public function get WinnerLowId() : uint
      {
         return this.FWinnerLowId;
      }
      
      public function set WinnerLowId(param1:uint) : void
      {
         this.FWinnerLowId = param1;
      }
      
      public function get WinnerHighId() : uint
      {
         return this.FWinnerHighId;
      }
      
      public function set WinnerHighId(param1:uint) : void
      {
         this.FWinnerHighId = param1;
      }
      
      public function get RewardStatus() : int
      {
         return this.FRewardStatus;
      }
      
      public function set RewardStatus(param1:int) : void
      {
         this.FRewardStatus = param1;
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
      
      public function get ChooseName() : String
      {
         return this.FChooseName;
      }
      
      public function set ChooseName(param1:String) : void
      {
         this.FChooseName = param1;
      }
   }
}

