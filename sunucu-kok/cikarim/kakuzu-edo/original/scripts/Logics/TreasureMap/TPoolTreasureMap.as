package Logics.TreasureMap
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolTreasureMap extends TPoolAutomatic
   {
      
      protected var FIndexTreasureMapHero:int;
      
      protected var FIndexTreasureMapReport:int;
      
      public function TPoolTreasureMap()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexTreasureMapHero = RegisterClass(TTreasureMapHero);
         this.FIndexTreasureMapReport = RegisterClass(TTreasureMapReport);
      }
      
      public function AcquireMapHero(param1:uint, param2:uint) : TTreasureMapHero
      {
         var _loc3_:TTreasureMapHero = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexTreasureMapHero) as TTreasureMapHero;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TTreasureMapHero(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireMapReport() : TTreasureMapReport
      {
         var _loc1_:TTreasureMapReport = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexTreasureMapReport) as TTreasureMapReport;
         if(_loc1_ == null)
         {
            _loc1_ = new TTreasureMapReport();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

