package Logics.Arena
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TArenaReport
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FPlayerNick:String;
      
      protected var FIsFight:Boolean;
      
      protected var FIsWin:Boolean;
      
      protected var FChgRanking:int;
      
      protected var FWhen:uint;
      
      protected var FReportId:String;
      
      public function TArenaReport()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get PlayerNick() : String
      {
         return this.FPlayerNick;
      }
      
      public function set PlayerNick(param1:String) : void
      {
         this.FPlayerNick = param1;
      }
      
      public function get IsFight() : Boolean
      {
         return this.FIsFight;
      }
      
      public function set IsFight(param1:Boolean) : void
      {
         this.FIsFight = param1;
      }
      
      public function get IsWin() : Boolean
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:Boolean) : void
      {
         this.FIsWin = param1;
      }
      
      public function get ChgRanking() : int
      {
         return this.FChgRanking;
      }
      
      public function set ChgRanking(param1:int) : void
      {
         this.FChgRanking = param1;
      }
      
      public function get When() : uint
      {
         return this.FWhen;
      }
      
      public function set When(param1:uint) : void
      {
         this.FWhen = param1;
      }
      
      public function get ReportId() : String
      {
         return this.FReportId;
      }
      
      public function set ReportId(param1:String) : void
      {
         this.FReportId = param1;
      }
   }
}

