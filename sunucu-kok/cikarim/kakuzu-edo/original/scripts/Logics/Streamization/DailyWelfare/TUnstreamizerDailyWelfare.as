package Logics.Streamization.DailyWelfare
{
   import Foundation.Streamization.*;
   import Logics.Dailywelfare.*;
   import Logics.DatebaseVO.VO.*;
   import flash.utils.*;
   
   public class TUnstreamizerDailyWelfare extends TUnstreamizer
   {
      
      public function TUnstreamizerDailyWelfare()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateWelfareInfo(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TDailyWelfare = null;
         var _loc5_:TDailyWelfareReward = null;
         var _loc6_:ByteArray = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         _loc4_ = param2 as TDailyWelfare;
         _loc5_ = param3 as TDailyWelfareReward;
         _loc6_ = param1 as ByteArray;
         _loc4_.WorldBossLv = _loc6_.readUnsignedInt();
         _loc9_ = uint(_loc6_.readByte());
         _loc10_ = uint(_loc6_.readByte());
         _loc8_ = _loc4_.GetBackItems.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.GetBackItems[_loc7_].Status = ((_loc10_ & 1 << _loc7_) > 0 ? 1 : 0) - ((_loc9_ & 1 << _loc7_) > 0 ? 1 : 0);
            _loc7_++;
         }
         _loc8_ = _loc4_.WelfareItems.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.WelfareItems[_loc7_].Status = (_loc9_ & 1 << _loc7_ + _loc4_.GetBackItems.length) > 0 ? 1 : 0;
            _loc7_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateAllItem(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TDailyWelfare = null;
         var _loc5_:TDailyWelfareReward = null;
         var _loc6_:ByteArray = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc4_ = param2 as TDailyWelfare;
         _loc5_ = param3 as TDailyWelfareReward;
         _loc6_ = param1 as ByteArray;
         _loc9_ = uint(_loc6_.readByte());
         _loc10_ = uint(_loc6_.readByte());
         _loc8_ = _loc4_.GetBackItems.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.GetBackItems[_loc7_].Status = ((_loc10_ & 1 << _loc7_) > 0 ? 1 : 0) - ((_loc9_ & 1 << _loc7_) > 0 ? 1 : 0);
            _loc7_++;
         }
         _loc8_ = _loc4_.WelfareItems.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.WelfareItems[_loc7_].Status = (_loc9_ & 1 << _loc7_ + _loc4_.GetBackItems.length) > 0 ? 1 : 0;
            _loc7_++;
         }
      }
      
      public function UnstreamizeUpdateDailyWelfareInfo(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateWelfareInfo(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateAllItem(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateAllItem(param1,param2,param3);
      }
   }
}

