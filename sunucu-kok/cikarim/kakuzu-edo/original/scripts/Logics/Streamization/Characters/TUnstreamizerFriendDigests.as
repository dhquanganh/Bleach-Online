package Logics.Streamization.Characters
{
   import Logics.Characters.TFriendDigest;
   import Logics.Characters.TFriendDigests;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerFriendDigests extends TUnstreamizerCharacterUnknown
   {
      
      protected var FUnstreamizerDigest:TUnstreamizerFriendDigest;
      
      public function TUnstreamizerFriendDigests()
      {
         super();
         this.FUnstreamizerDigest = new TUnstreamizerFriendDigest();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Digests(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Digests(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TFriendDigests = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TFriendDigest = null;
         _loc4_ = param2 as TFriendDigests;
         _loc4_.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = FPoolCharacter.AcquireFriendDigest();
            this.FUnstreamizerDigest.Unstreamize(param1,_loc7_,param3);
            _loc4_.Add(_loc7_);
            _loc6_++;
         }
      }
   }
}

