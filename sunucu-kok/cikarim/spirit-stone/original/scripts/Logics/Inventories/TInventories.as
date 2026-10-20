package Logics.Inventories
{
   public class TInventories
   {
      
      protected var FInventories:Vector.<TInventory>;
      
      public function TInventories()
      {
         super();
         this.FInventories = new Vector.<TInventory>();
      }
      
      public function get Count() : int
      {
         return this.FInventories.length;
      }
      
      public function GetInventoryByIndex(param1:int) : TInventory
      {
         return this.FInventories[param1];
      }
      
      protected function SortFieldUpgradingLevel(param1:TInventory, param2:TInventory) : int
      {
         var _loc3_:TAppliance = null;
         var _loc4_:TAppliance = null;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         if(param1 is TAppliance && param2 is TAppliance)
         {
            _loc3_ = param1 as TAppliance;
            _loc4_ = param2 as TAppliance;
            if(_loc3_.SortIndex > _loc4_.SortIndex)
            {
               return 1;
            }
            if(_loc3_.SortIndex < _loc4_.SortIndex)
            {
               return -1;
            }
            if(_loc3_.Identifier > _loc4_.Identifier)
            {
               return 1;
            }
            if(_loc3_.Identifier < _loc4_.Identifier)
            {
               return -1;
            }
         }
         if(param1 is TEquipment && param2 is TEquipment)
         {
            _loc5_ = param1 as TEquipment;
            _loc6_ = param2 as TEquipment;
            if(_loc5_.SortIndex > _loc6_.SortIndex)
            {
               return 1;
            }
            if(_loc5_.SortIndex < _loc6_.SortIndex)
            {
               return -1;
            }
            if(_loc5_.UpgradingLevel > _loc6_.UpgradingLevel)
            {
               return -1;
            }
            if(_loc5_.UpgradingLevel < _loc6_.UpgradingLevel)
            {
               return 1;
            }
            if(_loc5_.Identifier > _loc6_.Identifier)
            {
               return 1;
            }
            if(_loc5_.Identifier < _loc6_.Identifier)
            {
               return -1;
            }
         }
         return 0;
      }
      
      protected function SortFieldTime(param1:TInventory, param2:TInventory) : int
      {
         if(param1.TimingTime > param2.TimingTime)
         {
            return 1;
         }
         if(param1.TimingTime < param2.TimingTime)
         {
            return -1;
         }
         if(param1.SortIndex > param2.SortIndex)
         {
            return 1;
         }
         if(param1.SortIndex < param2.SortIndex)
         {
            return -1;
         }
         return 0;
      }
      
      public function Add(param1:TInventory) : void
      {
         param1.StubReferences.Reference(this);
         this.FInventories.push(param1);
      }
      
      public function GetInventoryByTempletID(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = int(this.FInventories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FInventories[_loc3_];
            if(_loc4_.IDTemplate == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetInventoryAllNumByTempletID(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         _loc5_ = 0;
         _loc2_ = int(this.FInventories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FInventories[_loc3_];
            if(_loc4_.IDTemplate == param1)
            {
               _loc5_ += _loc4_.Quantity;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function GetInventoryByIdentifier(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = int(this.FInventories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FInventories[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetInventoryByLongIdentifier(param1:uint, param2:uint) : TInventory
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc3_ = int(this.FInventories.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FInventories[_loc4_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function DeleteInventoryByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = int(this.FInventories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FInventories[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               _loc4_.StubReferences.Dereference(this);
               this.FInventories.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function DeleteInventoryByLongIdentifier(param1:uint, param2:uint) : TInventory
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc3_ = int(this.FInventories.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FInventories[_loc4_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               _loc5_.StubReferences.Dereference(this);
               this.FInventories.splice(_loc4_,1);
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function DeleteInventoryByIndex(param1:uint) : void
      {
         var _loc2_:TInventory = null;
         _loc2_ = this.FInventories[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FInventories.splice(param1,1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc1_ = int(this.FInventories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FInventories[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FInventories.length = 0;
      }
      
      public function Sort() : void
      {
         this.FInventories.sort(this.SortFieldUpgradingLevel);
      }
      
      public function SortTime() : void
      {
         this.FInventories.sort(this.SortFieldTime);
      }
      
      public function SortByFunction(param1:Function) : void
      {
         this.FInventories.sort(param1);
      }
      
      public function GetCountByTempleteID(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc4_ = 0;
         _loc2_ = int(this.FInventories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.FInventories[_loc3_];
            if(_loc5_.IDTemplate == param1)
            {
               _loc4_ += _loc5_.Quantity;
            }
            _loc3_++;
         }
         return _loc4_;
      }
   }
}

