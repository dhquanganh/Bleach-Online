package Logics.Streamization.HDActivity
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   import Logics.HDActivityMode.TActivityCrossServerRank;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   public class TUnstreamizerActivity extends TUnstreamizer
   {
      
      protected var FActivityInitData:TActivityInitRetData;
      
      public function TUnstreamizerActivity()
      {
         super();
         this.FActivityInitData = new TActivityInitRetData();
      }
      
      protected function UnstreamizationPerform_ActivityData(param1:ByteArray, param2:Object) : TActivityInitRetData
      {
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = param1.readUnsignedShort();
         _loc3_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         this.FActivityInitData.ClearAllBox();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            switch(_loc3_[_loc4_])
            {
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_BoxState:
                  this.UnstreamizationPerform_BoxState(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_Parameter:
                  this.UnstreamizationPerform_Parameter(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo1:
                  this.UnstreamizationPerform_RankInfo1(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo2:
                  this.UnstreamizationPerform_RankInfo2(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo3:
                  this.UnstreamizationPerform_RankInfo3(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo4:
                  this.UnstreamizationPerform_RankInfo4(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo5:
                  this.UnstreamizationPerform_RankInfo5(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo6:
                  this.UnstreamizationPerform_RankInfo6(param1,param2,this.FActivityInitData);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Unstreamizer_RankInfo7:
                  this.UnstreamizationPerform_RankInfo7(param1,param2,this.FActivityInitData);
            }
            _loc4_++;
         }
         return this.FActivityInitData;
      }
      
      private function UnstreamizationPerform_RankInfo1(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new THDOSRank();
            _loc6_.HighID = param1.readUnsignedInt();
            _loc6_.LowID = param1.readUnsignedInt();
            _loc6_.Rank = param1.readUnsignedInt();
            _loc6_.Level = param1.readUnsignedInt();
            _loc6_.Name = TUtilityString.FetchUTF(param1);
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_RankInfo2(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new THDOSRank();
            _loc6_.HighID = param1.readUnsignedInt();
            _loc6_.LowID = param1.readUnsignedInt();
            _loc6_.Level = param1.readUnsignedInt();
            _loc6_.Name = TUtilityString.FetchUTF(param1);
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_RankInfo3(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new THDOSRank();
            _loc6_.HighID = param1.readUnsignedInt();
            _loc6_.LowID = param1.readUnsignedInt();
            _loc6_.Family = param1.readUnsignedInt();
            _loc6_.Level = param1.readUnsignedInt();
            _loc6_.Name = TUtilityString.FetchUTF(param1);
            _loc6_.Damage = param1.readUnsignedInt();
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_RankInfo4(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc6_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_[_loc4_] = this.UnstreamizationPerform_StrInnerVec(param1);
            _loc4_++;
         }
         param3.AddAddtional(_loc6_);
      }
      
      private function UnstreamizationPerform_RankInfo5(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new THDOSRank();
            _loc6_.Family = param1.readUnsignedInt();
            _loc6_.Level = param1.readUnsignedInt();
            _loc6_.Name = TUtilityString.FetchUTF(param1);
            _loc6_.Parameter = param1.readUnsignedInt();
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_RankInfo6(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TActivityCrossServerRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TActivityCrossServerRank();
            _loc6_.HighID = param1.readUnsignedInt();
            _loc6_.LowID = param1.readUnsignedInt();
            _loc6_.Rank = param1.readUnsignedInt();
            _loc6_.Name = TUtilityString.FetchUTF(param1);
            _loc6_.AgentID = param1.readUnsignedInt();
            _loc6_.ServerID = param1.readUnsignedInt();
            _loc6_.Point = param1.readUnsignedInt();
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_RankInfo7(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TActivityServerRank = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         _loc5_ = param1.readUnsignedShort();
         _loc7_ = new Vector.<Object>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc11_ = param1.readUnsignedInt();
            _loc12_ = int(param1.readUnsignedInt());
            _loc9_ = TUtilityString.FetchUTF(param1);
            _loc8_ = Json.decode(_loc9_);
            _loc6_ = new TActivityServerRank(_loc10_,_loc11_,_loc4_,_loc8_);
            _loc7_[_loc4_] = _loc6_;
            _loc4_++;
         }
         param3.AddAddtional(_loc7_);
      }
      
      private function UnstreamizationPerform_StrInnerVec(param1:ByteArray) : Vector.<String>
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<String> = null;
         var _loc5_:String = null;
         _loc3_ = param1.readUnsignedShort();
         _loc4_ = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = TUtilityString.FetchUTF(param1);
            _loc4_[_loc2_] = _loc5_;
            _loc2_++;
         }
         return _loc4_;
      }
      
      private function UnstreamizationPerform_Parameter(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = int(param1.readUnsignedInt());
            param3.AddParameter(_loc6_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_BoxState(param1:ByteArray, param2:Object, param3:TActivityInitRetData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new THDBoxStateData();
            _loc6_.BoxIndex = param1.readInt();
            _loc6_.TypeAcquire = param1.readUnsignedInt();
            _loc6_.State = param1.readInt();
            this.UnstreamizationPerform_Condition(param1,param2,_loc6_);
            this.FActivityInitData.AddAllBox(_loc6_);
            _loc4_++;
         }
         this.FActivityInitData.BoxClassification();
      }
      
      protected function UnstreamizationPerform_Condition(param1:ByteArray, param2:Object, param3:THDBoxStateData) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = param1.readUnsignedShort();
         param3.Conditions.length = _loc5_;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            param3.Conditions[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
      }
      
      public function UnstreamizationPerform_Activity(param1:ByteArray, param2:Object) : TActivityInitRetData
      {
         this.FActivityInitData = this.UnstreamizationPerform_ActivityData(param1,param2);
         return this.FActivityInitData;
      }
   }
}

