package Logics.Inventories
{
   import Foundation.Collections.*;
   
   public class TCollectionInventory extends TCollectionInstance
   {
      
      public function TCollectionInventory(param1:int)
      {
         super(param1);
      }
      
      override protected function InstanceReplace(param1:int, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:TInventory = null;
         _loc3_ = FInstances[param1];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_ as TInventory;
            _loc4_.StubReferences.Dereference(this);
         }
         if(param2 != null)
         {
            _loc4_ = param2 as TInventory;
            _loc4_.StubReferences.Reference(this);
         }
         FInstances[param1] = param2;
      }
      
      public function GetInventoryByIndex(param1:int) : TInventory
      {
         return FInstances[param1] as TInventory;
      }
      
      public function GetInventoryByIdentifier(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = 0;
         while(_loc2_ < Capacity)
         {
            _loc3_ = FInstances[_loc2_] as TInventory;
            if(_loc3_ != null)
            {
               if(_loc3_.Identifier == param1)
               {
                  return _loc3_;
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetInventoryByIDTemplate(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = 0;
         while(_loc2_ < Capacity)
         {
            _loc3_ = FInstances[_loc2_] as TInventory;
            if(_loc3_ != null)
            {
               if(_loc3_.IDTemplate == param1)
               {
                  return _loc3_;
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetInventorysByIDTemplate(param1:uint) : Vector.<TInventory>
      {
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:Vector.<TInventory> = null;
         _loc4_ = new Vector.<TInventory>();
         _loc2_ = 0;
         while(_loc2_ < Capacity)
         {
            _loc3_ = FInstances[_loc2_] as TInventory;
            if(_loc3_ != null)
            {
               if(_loc3_.IDTemplate == param1)
               {
                  _loc4_.push(_loc3_);
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetIndexByIDTemplate(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = 0;
         while(_loc2_ < Capacity)
         {
            _loc3_ = FInstances[_loc2_] as TInventory;
            if(_loc3_ != null)
            {
               if(_loc3_.IDTemplate == param1)
               {
                  return _loc2_;
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function SetInventoryByIndex(param1:int, param2:TInventory) : void
      {
         this.InstanceReplace(param1,param2);
      }
      
      public function GetIndexsByIDTemplate(param1:uint) : Vector.<int>
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = new Vector.<int>();
         _loc3_ = 0;
         while(_loc3_ < Capacity)
         {
            _loc4_ = FInstances[_loc3_] as TInventory;
            if(_loc4_ != null)
            {
               if(_loc4_.IDTemplate == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

