package Logics.Items
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolItem extends TPoolAutomatic
   {
      
      protected var FIndexItem:int;
      
      public function TPoolItem()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexItem = RegisterClass(TItem);
      }
      
      public function AcquireItem() : TItem
      {
         var _loc1_:TItem = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexItem) as TItem;
         if(_loc1_ == null)
         {
            _loc1_ = new TItem();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

