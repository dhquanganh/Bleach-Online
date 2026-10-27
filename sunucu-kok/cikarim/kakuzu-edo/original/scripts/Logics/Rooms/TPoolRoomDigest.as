package Logics.Rooms
{
   import Foundation.Pools.TPoolAutomatic;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   
   use namespace LobbySpace;
   
   public class TPoolRoomDigest extends TPoolAutomatic
   {
      
      protected var FIndexRoomDigest:int;
      
      public function TPoolRoomDigest()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexRoomDigest = RegisterClass(TRoomDigest);
      }
      
      protected function ReleasingPerform_Room(param1:Object) : void
      {
         var _loc2_:TRoomDigest = null;
         _loc2_ = param1 as TRoomDigest;
         _loc2_.Reset();
      }
      
      public function Acquire(param1:uint = 0) : TRoomDigest
      {
         var _loc2_:TRoomDigest = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexRoomDigest) as TRoomDigest;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TRoomDigest(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

