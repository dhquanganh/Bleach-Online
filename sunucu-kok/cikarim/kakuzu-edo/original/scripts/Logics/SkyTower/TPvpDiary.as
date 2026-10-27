package Logics.SkyTower
{
   public class TPvpDiary
   {
      
      protected var FTime:uint;
      
      protected var FIsInitiativeFight:Boolean;
      
      protected var FIsWin:Boolean;
      
      protected var FNickname:String;
      
      protected var FBattleReportID:String;
      
      public function TPvpDiary()
      {
         super();
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get IsInitiativeFight() : Boolean
      {
         return this.FIsInitiativeFight;
      }
      
      public function set IsInitiativeFight(param1:Boolean) : void
      {
         this.FIsInitiativeFight = param1;
      }
      
      public function get IsWin() : Boolean
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:Boolean) : void
      {
         this.FIsWin = param1;
      }
      
      public function get Nickname() : String
      {
         return this.FNickname;
      }
      
      public function set Nickname(param1:String) : void
      {
         this.FNickname = param1;
      }
      
      public function get BattleReportID() : String
      {
         return this.FBattleReportID;
      }
      
      public function set BattleReportID(param1:String) : void
      {
         this.FBattleReportID = param1;
      }
   }
}

