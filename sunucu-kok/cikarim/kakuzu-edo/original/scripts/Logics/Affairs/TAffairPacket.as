package Logics.Affairs
{
   import Foundation.Network.TPacket;
   
   public class TAffairPacket extends TAffair
   {
      
      protected var FPacket:TPacket;
      
      public function TAffairPacket(param1:uint)
      {
         super(param1);
      }
      
      public function get Packet() : TPacket
      {
         return this.FPacket;
      }
      
      public function set Packet(param1:TPacket) : void
      {
         if(param1 != this.FPacket)
         {
            if(this.FPacket != null)
            {
               this.FPacket.StubReferences.Dereference(this);
            }
            if(param1 != null)
            {
               param1.StubReferences.Reference(this);
            }
            this.FPacket = param1;
         }
      }
   }
}

