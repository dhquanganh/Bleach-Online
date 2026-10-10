package Logics.CityDefend
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TCityDefendRank
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FRankName:String;
      
      protected var FRankHarm:Number;
      
      public function TCityDefendRank()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get RankName() : String
      {
         return this.FRankName;
      }
      
      public function set RankName(param1:String) : void
      {
         this.FRankName = param1;
      }
      
      public function get RankHarm() : Number
      {
         return this.FRankHarm;
      }
      
      public function set RankHarm(param1:Number) : void
      {
         this.FRankHarm = param1;
      }
   }
}

