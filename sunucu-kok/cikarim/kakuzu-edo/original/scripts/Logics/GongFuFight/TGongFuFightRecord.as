package Logics.GongFuFight
{
   public class TGongFuFightRecord
   {
      
      protected var FName:String;
      
      protected var FTime:uint;
      
      protected var FReportID:String;
      
      protected var FIsWin:Boolean;
      
      protected var FIsFight:Boolean;
      
      public function TGongFuFightRecord()
      {
         super();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get ReportID() : String
      {
         return this.FReportID;
      }
      
      public function set ReportID(param1:String) : void
      {
         this.FReportID = param1;
      }
      
      public function get IsWin() : Boolean
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:Boolean) : void
      {
         this.FIsWin = param1;
      }
      
      public function get IsFight() : Boolean
      {
         return this.FIsFight;
      }
      
      public function set IsFight(param1:Boolean) : void
      {
         this.FIsFight = param1;
      }
   }
}

