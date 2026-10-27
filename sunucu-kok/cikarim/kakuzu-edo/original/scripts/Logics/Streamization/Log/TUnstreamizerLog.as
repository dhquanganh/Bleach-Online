package Logics.Streamization.Log
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Log.TLog;
   import Logics.Log.TLogs;
   import Logics.SLogicsCore;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerLog extends TUnstreamizer
   {
      
      public function TUnstreamizerLog()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TLog = null;
         var _loc8_:Vector.<TLog> = null;
         var _loc9_:TLogs = null;
         _loc6_ = param3 as int;
         _loc9_ = param2 as TLogs;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = SLogicsCore.PoolLog.Acquire();
            _loc7_.UserIDHigh = param1.readUnsignedInt();
            _loc7_.UserIDLow = param1.readUnsignedInt();
            _loc7_.Name = TUtilityString.FetchUTF(param1);
            _loc7_.RecoredTime = param1.readUnsignedInt();
            _loc7_.Data = TUtilityString.FetchUTF(param1);
            _loc9_.AddByType(_loc6_,_loc7_);
            _loc4_++;
         }
      }
   }
}

