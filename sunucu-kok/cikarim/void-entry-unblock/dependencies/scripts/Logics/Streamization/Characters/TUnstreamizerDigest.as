package Logics.Streamization.Characters
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TDigest;
   import Logics.Spaces.LogicsSpace;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerDigest extends TUnstreamizer
   {
      
      public function TUnstreamizerDigest()
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
         var _loc7_:TDigest = null;
         _loc7_ = param2 as TDigest;
         _loc7_.Type = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         _loc7_.Coerce(_loc5_,_loc6_);
         _loc7_.Name = TUtilityString.FetchUTF(param1);
         _loc7_.Level = param1.readUnsignedShort();
      }
   }
}

