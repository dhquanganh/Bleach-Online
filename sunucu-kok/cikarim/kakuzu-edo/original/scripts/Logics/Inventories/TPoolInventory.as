package Logics.Inventories
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolInventory extends TPoolAutomatic
   {
      
      protected var FIndexEquipment:int;
      
      protected var FIndexAppliance:int;
      
      protected var FIndexCrashJade:int;
      
      protected var FIndexEquipmentAppendAttribute:int;
      
      protected var FIndexSuitEffect:int;
      
      protected var FIndexInventorySample:int;
      
      protected var FIndexInventoryWake:int;
      
      public function TPoolInventory()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexEquipment = RegisterClass(TEquipment,this.ReleasingPerform_Equipment);
         this.FIndexAppliance = RegisterClass(TAppliance,this.ReleasingPerform_Appliance);
         this.FIndexCrashJade = RegisterClass(TCrashJade,this.ReleasingPerform_CrashJade);
         this.FIndexEquipmentAppendAttribute = RegisterClass(TEquipmentAppendAttribute);
         this.FIndexSuitEffect = RegisterClass(TSuitEffect);
         this.FIndexInventorySample = RegisterClass(TInventorySample,this.ReleasingPerform_InventorySample);
         this.FIndexInventoryWake = RegisterClass(TInventoryWake,this.ReleasingPerform_InventoryWake);
      }
      
      protected function ReleasingPerform_Equipment(param1:Object) : void
      {
         var _loc2_:TEquipment = null;
         _loc2_ = param1 as TEquipment;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_Appliance(param1:Object) : void
      {
         var _loc2_:TAppliance = null;
         _loc2_ = param1 as TAppliance;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_CrashJade(param1:Object) : void
      {
         var _loc2_:TCrashJade = null;
         _loc2_ = param1 as TCrashJade;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_InventorySample(param1:Object) : void
      {
         var _loc2_:TInventorySample = null;
         _loc2_ = param1 as TInventorySample;
         _loc2_.Clear();
      }
      
      protected function ReleasingPerform_InventoryWake(param1:Object) : void
      {
         var _loc2_:TInventoryWake = null;
         _loc2_ = param1 as TInventoryWake;
         _loc2_.Reset();
      }
      
      public function AcquireEquipment(param1:uint = 0) : TEquipment
      {
         var _loc2_:TEquipment = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEquipment) as TEquipment;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TEquipment(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireEquipmentAppendAttribute() : TEquipmentAppendAttribute
      {
         var _loc1_:TEquipmentAppendAttribute = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexEquipmentAppendAttribute) as TEquipmentAppendAttribute;
         if(_loc1_ == null)
         {
            _loc1_ = new TEquipmentAppendAttribute();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
      
      public function AcquireAppliance(param1:uint = 0) : TAppliance
      {
         var _loc2_:TAppliance = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexAppliance) as TAppliance;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TAppliance(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireWakeUp(param1:uint = 0) : TInventoryWake
      {
         var _loc2_:TInventoryWake = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexInventoryWake) as TInventoryWake;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TInventoryWake(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireCrashJade(param1:uint = 0) : TCrashJade
      {
         var _loc2_:TCrashJade = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexCrashJade) as TCrashJade;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TCrashJade(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireSuitEffect() : TSuitEffect
      {
         var _loc1_:TSuitEffect = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexSuitEffect) as TSuitEffect;
         if(_loc1_ == null)
         {
            _loc1_ = new TSuitEffect();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
      
      public function AcquireInventorySample() : TInventorySample
      {
         var _loc1_:TInventorySample = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexInventorySample) as TInventorySample;
         if(_loc1_ == null)
         {
            _loc1_ = new TInventorySample();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

