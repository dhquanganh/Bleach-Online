package Logics.Streamization.InteractionLog
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.InteractionLog.TInteractionLog;
   import Logics.InteractionLog.TInteractionLogs;
   import Logics.InteractionLog.TPoolInteractionLog;
   import Logics.Spaces.LogicsSpace;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerInteractionLogs extends TUnstreamizer
   {
      
      protected static var FPoolInteractionLog:TPoolInteractionLog;
      
      protected var FUnstreamizerInteractionLog:TUnstreamizerInteractionLog;
      
      public function TUnstreamizerInteractionLogs()
      {
         super();
         this.FUnstreamizerInteractionLog = new TUnstreamizerInteractionLog();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolInteractionLog) : void
      {
         FPoolInteractionLog = param1;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:* = 0;
         var _loc5_:uint = 0;
         var _loc6_:TInteractionLog = null;
         var _loc7_:TInteractionLogs = null;
         var _loc8_:uint = 0;
         _loc7_ = param2 as TInteractionLogs;
         _loc8_ = param3 as uint;
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = FPoolInteractionLog.Acquire();
            this.FUnstreamizerInteractionLog.Unstreamize(param1,_loc6_,null);
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
         _loc7_.Sort();
         if(_loc8_ != 0)
         {
            _loc5_ = uint(_loc7_.Count);
            _loc4_ = int(_loc5_ - 1);
            while(_loc4_ >= 0)
            {
               if(_loc4_ < _loc8_)
               {
                  break;
               }
               _loc7_.DeleteInteractionLogByIndex(_loc4_);
               _loc4_--;
            }
         }
      }
   }
}

