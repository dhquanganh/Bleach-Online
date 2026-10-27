package Logics.HDActivityOS
{
   public class THDDailyActivityInfo
   {
      
      protected var FUserID0:uint;
      
      protected var FUserID1:uint;
      
      protected var FTime:uint;
      
      protected var FFamily:uint;
      
      protected var FLevel:uint;
      
      protected var FName:String;
      
      protected var FHurt:uint;
      
      protected var FOrgRank0:Vector.<String>;
      
      protected var FOrgRank1:Vector.<String>;
      
      protected var FOrgRank2:Vector.<String>;
      
      protected var FOrgLevel:uint;
      
      protected var FOrgName:String;
      
      protected var FScore:uint;
      
      protected var FIsWin:uint;
      
      public function THDDailyActivityInfo()
      {
         super();
         this.FOrgRank0 = new Vector.<String>();
         this.FOrgRank1 = new Vector.<String>();
         this.FOrgRank2 = new Vector.<String>();
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get Family() : uint
      {
         return this.FFamily;
      }
      
      public function set Family(param1:uint) : void
      {
         this.FFamily = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Hurt() : uint
      {
         return this.FHurt;
      }
      
      public function set Hurt(param1:uint) : void
      {
         this.FHurt = param1;
      }
      
      public function get OrgRank0() : Vector.<String>
      {
         return this.FOrgRank0;
      }
      
      public function set OrgRank0(param1:Vector.<String>) : void
      {
         this.FOrgRank0 = param1;
      }
      
      public function get OrgRank1() : Vector.<String>
      {
         return this.FOrgRank1;
      }
      
      public function set OrgRank1(param1:Vector.<String>) : void
      {
         this.FOrgRank1 = param1;
      }
      
      public function get OrgRank2() : Vector.<String>
      {
         return this.FOrgRank2;
      }
      
      public function set OrgRank2(param1:Vector.<String>) : void
      {
         this.FOrgRank2 = param1;
      }
      
      public function get OrgLevel() : uint
      {
         return this.FOrgLevel;
      }
      
      public function set OrgLevel(param1:uint) : void
      {
         this.FOrgLevel = param1;
      }
      
      public function get OrgName() : String
      {
         return this.FOrgName;
      }
      
      public function set OrgName(param1:String) : void
      {
         this.FOrgName = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get IsWin() : uint
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:uint) : void
      {
         this.FIsWin = param1;
      }
      
      public function get UserID1() : uint
      {
         return this.FUserID1;
      }
      
      public function set UserID1(param1:uint) : void
      {
         this.FUserID1 = param1;
      }
      
      public function get UserID0() : uint
      {
         return this.FUserID0;
      }
      
      public function set UserID0(param1:uint) : void
      {
         this.FUserID0 = param1;
      }
   }
}

