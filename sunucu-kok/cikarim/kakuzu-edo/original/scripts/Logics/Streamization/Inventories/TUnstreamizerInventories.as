package Logics.Streamization.Inventories
{
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventoryReference;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerInventories extends TUnstreamizerInventoryUnknown
   {
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FReference:TInventoryReference;
      
      protected var FCollectionRetaining:Boolean;
      
      public function TUnstreamizerInventories()
      {
         super();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.FReference = new TInventoryReference();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Inventories(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Inventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = param2 as TInventories;
         _loc5_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FUnstreamizerReference.Unstreamize(param1,this.FReference,param3);
            _loc4_.Add(this.FReference.Inventory);
            _loc6_++;
         }
         this.FReference.Inventory = null;
      }
      
      protected function InventoryClassByCategory(param1:uint) : uint
      {
         var _loc2_:int = 0;
         _loc2_ = CATEGORY_Equipments.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return CLASS_Equipment;
         }
         return CLASS_Appliance;
      }
      
      public function get CollectionRetaining() : Boolean
      {
         return this.FCollectionRetaining;
      }
      
      public function set CollectionRetaining(param1:Boolean) : void
      {
         this.FCollectionRetaining = param1;
      }
   }
}

