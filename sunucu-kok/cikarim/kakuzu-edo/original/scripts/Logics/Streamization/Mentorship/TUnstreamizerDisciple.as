package Logics.Streamization.Mentorship
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Mentorship.Elements.TDisciple;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerDisciple extends TUnstreamizer
   {
      
      public function TUnstreamizerDisciple()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TDisciple = null;
         _loc4_ = param2 as TDisciple;
         _loc4_.DiscipleID0 = param1.readUnsignedInt();
         _loc4_.DiscipleID1 = param1.readUnsignedInt();
         _loc4_.DiscipleName = TUtilityString.FetchUTF(param1);
         _loc4_.DiscipleLevel = param1.readUnsignedInt();
         _loc4_.DiscipleHeroID = param1.readUnsignedInt();
         _loc4_.DiscipleGuildName = TUtilityString.FetchUTF(param1);
         _loc4_.InteractionCDTime = param1.readUnsignedInt();
         _loc4_.StartWorkTime = param1.readUnsignedInt();
         _loc4_.DrawTime = param1.readUnsignedInt();
         _loc4_.AddUpExp = param1.readUnsignedInt();
      }
   }
}

