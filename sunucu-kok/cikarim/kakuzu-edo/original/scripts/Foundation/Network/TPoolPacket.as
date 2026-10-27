package Foundation.Network
{
   import Foundation.Network.Spaces.NetworkSpace;
   import Foundation.Pools.TPoolAutomatic;
   import flash.utils.ByteArray;
   
   use namespace NetworkSpace;
   
   public class TPoolPacket extends TPoolAutomatic
   {
      
      protected var FIndexPacket:int;
      
      public function TPoolPacket()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexPacket = RegisterClass(TPacket);
      }
      
      public function Acquire(param1:uint, param2:ByteArray = null) : TPacket
      {
         var _loc3_:TPacket = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexPacket) as TPacket;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TPacket(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
   }
}

