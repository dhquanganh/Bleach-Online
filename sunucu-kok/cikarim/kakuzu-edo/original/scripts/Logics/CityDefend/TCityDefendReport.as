package Logics.CityDefend
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TCityDefendReport
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FUserName:String;
      
      protected var FIsInitiative:Boolean;
      
      protected var FIsWin:Boolean;
      
      protected var FReportId:String;
      
      protected var FLastHp:Number;
      
      public function TCityDefendReport()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get UserName() : String
      {
         return this.FUserName;
      }
      
      public function set UserName(param1:String) : void
      {
         this.FUserName = param1;
      }
      
      public function get IsInitiative() : Boolean
      {
         return this.FIsInitiative;
      }
      
      public function set IsInitiative(param1:Boolean) : void
      {
         this.FIsInitiative = param1;
      }
      
      public function get IsWin() : Boolean
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:Boolean) : void
      {
         this.FIsWin = param1;
      }
      
      public function get ReportId() : String
      {
         return this.FReportId;
      }
      
      public function set ReportId(param1:String) : void
      {
         this.FReportId = param1;
      }
      
      public function get LastHp() : Number
      {
         return this.FLastHp;
      }
      
      public function set LastHp(param1:Number) : void
      {
         this.FLastHp = param1;
      }
   }
}

