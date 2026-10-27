package Logics.Smithy
{
   import Foundation.Pools.TPoolAutomatic;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Talisman.TSingleEquip;
   
   public class TPoolUISingleEquipment extends TPoolAutomatic
   {
      
      protected var FIndexUISingleEquipment:int;
      
      public function TPoolUISingleEquipment()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexUISingleEquipment = RegisterClass(TSingleEquip,this.ReleaseUI);
      }
      
      protected function ReleaseUI(param1:TSingleEquip) : void
      {
         param1.Release();
      }
      
      public function AcquireUISingleEquipment(param1:TUIComponent) : TSingleEquip
      {
         var _loc2_:TSingleEquip = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexUISingleEquipment) as TSingleEquip;
         if(_loc2_ == null)
         {
            _loc2_ = new TSingleEquip(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

