package Logics.CityDefend
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolCityDefend extends TPoolAutomatic
   {
      
      protected var FIndexCityDefendHero:int;
      
      protected var FIndexCityDefendReport:int;
      
      protected var FIndexCityDefendRank:int;
      
      public function TPoolCityDefend()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexCityDefendHero = RegisterClass(TCityDefendHero);
         this.FIndexCityDefendReport = RegisterClass(TCityDefendReport);
         this.FIndexCityDefendRank = RegisterClass(TCityDefendRank);
      }
      
      public function AcquireCityDefendHero(param1:uint = 0, param2:uint = 0) : TCityDefendHero
      {
         var _loc3_:TCityDefendHero = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexCityDefendHero) as TCityDefendHero;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TCityDefendHero(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireCityDefendReport() : TCityDefendReport
      {
         var _loc1_:TCityDefendReport = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexCityDefendReport) as TCityDefendReport;
         if(_loc1_ == null)
         {
            _loc1_ = new TCityDefendReport();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
      
      public function AcquireCityDefendRank() : TCityDefendRank
      {
         var _loc1_:TCityDefendRank = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexCityDefendRank) as TCityDefendRank;
         if(_loc1_ == null)
         {
            _loc1_ = new TCityDefendRank();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

