package Logics.Streamization.Mentorship
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Mentorship.Elements.TArrestPlayer;
   import Logics.Mentorship.TArrest;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerArrest extends TUnstreamizer
   {
      
      public function TUnstreamizerArrest()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TArrest = null;
         var _loc7_:TArrestPlayer = null;
         _loc6_ = param2 as TArrest;
         _loc5_ = _loc6_.ArrestList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.ArrestList.pop();
            _loc4_++;
         }
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TArrestPlayer();
            _loc7_.Type = param1.readUnsignedByte();
            _loc7_.Identifier0 = param1.readUnsignedInt();
            _loc7_.Identifier1 = param1.readUnsignedInt();
            _loc7_.Name = TUtilityString.FetchUTF(param1);
            _loc7_.Level = param1.readUnsignedShort();
            _loc7_.GuildName = TUtilityString.FetchUTF(param1);
            _loc7_.Identity = param1.readUnsignedByte();
            _loc7_.DiscipleCount = param1.readUnsignedShort();
            _loc7_.InteractionCDTime = param1.readUnsignedInt();
            _loc7_.MasterName = TUtilityString.FetchUTF(param1);
            _loc6_.ArrestList.push(_loc7_);
            _loc4_++;
         }
      }
   }
}

