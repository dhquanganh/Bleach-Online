package Foundation.Resources.Common
{
   import Foundation.Pools.TPoolAutomatic;
   import Foundation.Resources.Spaces.ResourcesSpace;
   
   use namespace ResourcesSpace;
   
   public class TPoolResourceRequest extends TPoolAutomatic
   {
      
      protected var FIndexResourceRequest:int;
      
      public function TPoolResourceRequest()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexResourceRequest = RegisterClass(TResourceRequest);
      }
      
      public function Release(param1:TResourceRequest) : void
      {
         InstanceRelease(param1);
      }
      
      public function Acquire(param1:uint) : TResourceRequest
      {
         var _loc2_:TResourceRequest = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexResourceRequest) as TResourceRequest;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TResourceRequest(param1);
         }
         return _loc2_;
      }
   }
}

