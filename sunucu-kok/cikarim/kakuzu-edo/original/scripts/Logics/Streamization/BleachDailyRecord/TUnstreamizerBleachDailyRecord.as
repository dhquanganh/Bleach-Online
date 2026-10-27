package Logics.Streamization.BleachDailyRecord
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachDailyRecord.TBleachDailyRecord;
   import Logics.BleachDailyRecord.TBleachDailyRecords;
   import Logics.DatebaseVO.VO.TFunctionSwitch;
   import Logics.DatebaseVO.VO.TGrowRoadDayTask;
   import Logics.DatebaseVO.VO.TTask;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerBleachDailyRecord extends TUnstreamizer
   {
      
      public function TUnstreamizerBleachDailyRecord()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBleachDailyRecords = null;
         var _loc5_:TBleachDailyRecord = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TBleachDailyRecords;
         _loc9_ = int(param1.readUnsignedShort());
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = int(param1.readUnsignedInt());
            _loc5_ = _loc4_.GetBleachDailyRecordByID(_loc6_);
            _loc5_.IfOpen = true;
            _loc5_.RecordValue = _loc7_;
            _loc8_++;
         }
      }
      
      protected function CreateUnlockDescription(param1:TBleachDailyRecord) : String
      {
         var _loc2_:TFunctionSwitch = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TTask = null;
         if(param1.GrowRoadDayTask.UnlockCondition == 0)
         {
            return "";
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_FunctionSwitch,param1.GrowRoadDayTask.UnlockCondition) as TFunctionSwitch;
         _loc4_ = _loc2_.ConditionType;
         _loc5_ = _loc2_.ConditiontValue;
         switch(_loc4_)
         {
            case 1:
               _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Task,_loc5_) as TTask;
               return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_06),_loc6_.Name);
            case 2:
               return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_07),_loc5_);
            default:
               return null;
         }
      }
      
      public function UnstreamizationByDataBase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBleachDailyRecords = null;
         var _loc7_:TBleachDailyRecord = null;
         var _loc8_:TBins = null;
         _loc6_ = param2 as TBleachDailyRecords;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GrowRoadDayTask);
         _loc5_ = _loc8_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TBleachDailyRecord();
            _loc7_.GrowRoadDayTask = _loc8_.GetDatebaseByIndex(_loc4_) as TGrowRoadDayTask;
            _loc7_.UnlockDescription = this.CreateUnlockDescription(_loc7_);
            if(_loc7_.GrowRoadDayTask.UnlockCondition != 0)
            {
               _loc6_.BleachDailyRecords.push(_loc7_);
            }
            _loc4_++;
         }
      }
   }
}

