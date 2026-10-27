package Logics.Purchases
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolPurchase extends TPoolAutomatic
   {
      
      protected var FindexPurchaseRequest:int;
      
      public function TPoolPurchase()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FindexPurchaseRequest = RegisterClass(TPurchaseRequest,this.ReleasingPerform_PurchaseRequest);
      }
      
      protected function ReleasingPerform_PurchaseRequest(param1:Object) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = param1 as TPurchaseRequest;
         _loc2_.Reset();
      }
      
      public function AcquirePurchaseRequest() : TPurchaseRequest
      {
         var _loc1_:TPurchaseRequest = null;
         _loc1_ = InstanceAcquireByIndex(this.FindexPurchaseRequest) as TPurchaseRequest;
         if(_loc1_ == null)
         {
            _loc1_ = new TPurchaseRequest();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

