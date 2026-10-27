package Logics.Streamization.Battle
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Battle.model.TResultInfo;
   import Logics.Battle.model.TTargetInfo;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerTargetInfo extends TUnstreamizer
   {
      
      protected var FUnstreamizerResultInfo:TUnstreamizerResultInfo;
      
      public function TUnstreamizerTargetInfo()
      {
         super();
         this.FUnstreamizerResultInfo = new TUnstreamizerResultInfo();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TTargetInfo = null;
         var _loc5_:TResultInfo = null;
         _loc4_ = param2 as TTargetInfo;
         _loc4_.CMD = param1.readByte();
         _loc4_.TargetCamp = param1.readByte();
         _loc4_.TargetPos = param1.readByte();
         _loc4_.ReportTargetStatus = param1.readUnsignedInt();
         _loc4_.TargetStatus = _loc4_.ReportTargetStatus;
         this.FUnstreamizerResultInfo.Unstreamize(param1,_loc4_.ResultInfo,_loc4_.CMD);
      }
   }
}

