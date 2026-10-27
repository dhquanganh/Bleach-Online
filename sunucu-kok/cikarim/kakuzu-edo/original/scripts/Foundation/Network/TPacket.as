package Foundation.Network
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Foundation.Network.Spaces.NetworkSpace;
   import flash.utils.ByteArray;
   
   use namespace NetworkSpace;
   
   public class TPacket extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FData:ByteArray;
      
      public function TPacket(param1:uint, param2:ByteArray = null)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         if(param2 == null)
         {
            this.FData = new ByteArray();
         }
         else
         {
            this.FData = param2;
         }
      }
      
      NetworkSpace function Coerce(param1:uint, param2:ByteArray) : void
      {
         FIdentifier = param1;
         if(param2 == null)
         {
            this.FData.length = 0;
         }
         else
         {
            this.FData = param2;
         }
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Data() : ByteArray
      {
         return this.FData;
      }
   }
}

