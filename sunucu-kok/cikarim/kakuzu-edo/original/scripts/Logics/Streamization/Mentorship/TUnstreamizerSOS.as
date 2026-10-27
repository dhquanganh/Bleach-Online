package Logics.Streamization.Mentorship
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Mentorship.Elements.TSOSPlayer;
   import Logics.Mentorship.TSOS;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerSOS extends TUnstreamizer
   {
      
      public function TUnstreamizerSOS()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TSOS = null;
         var _loc7_:TSOSPlayer = null;
         _loc6_ = param2 as TSOS;
         _loc5_ = _loc6_.SOSList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SOSList.pop();
            _loc4_++;
         }
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TSOSPlayer();
            _loc7_.Identifier0 = param1.readUnsignedInt();
            _loc7_.Identifier1 = param1.readUnsignedInt();
            _loc7_.Name = TUtilityString.FetchUTF(param1);
            _loc7_.Level = param1.readUnsignedInt();
            _loc7_.GuildName = TUtilityString.FetchUTF(param1);
            _loc7_.Identity = param1.readUnsignedByte();
            _loc7_.DiscipleCount = param1.readUnsignedShort();
            _loc7_.HasSOS = param1.readUnsignedByte();
            _loc7_.From = param1.readByte();
            _loc6_.SOSList.push(_loc7_);
            _loc4_++;
         }
      }
   }
}

