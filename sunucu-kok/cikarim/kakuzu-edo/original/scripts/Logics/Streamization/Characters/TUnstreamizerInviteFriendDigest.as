package Logics.Streamization.Characters
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TFriendDigest;
   import Logics.Spaces.LogicsSpace;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerInviteFriendDigest extends TUnstreamizer
   {
      
      public function TUnstreamizerInviteFriendDigest()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TFriendDigest = null;
         _loc7_ = param2 as TFriendDigest;
         _loc7_.Type = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         _loc7_.Coerce(_loc5_,_loc6_);
         _loc7_.Name = TUtilityString.FetchUTF(param1);
         _loc7_.Level = param1.readUnsignedShort();
         _loc7_.Country = param1.readUnsignedByte();
      }
   }
}

