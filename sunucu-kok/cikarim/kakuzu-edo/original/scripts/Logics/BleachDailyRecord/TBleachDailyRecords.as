package Logics.BleachDailyRecord
{
   import Logics.DatebaseVO.VO.TGrowRoadDayTask;
   
   public class TBleachDailyRecords
   {
      
      protected var FBleachDailyRecords:Vector.<TBleachDailyRecord>;
      
      public function TBleachDailyRecords()
      {
         super();
         this.FBleachDailyRecords = new Vector.<TBleachDailyRecord>();
      }
      
      public function get BleachDailyRecords() : Vector.<TBleachDailyRecord>
      {
         return this.FBleachDailyRecords;
      }
      
      public function get Count() : int
      {
         return this.FBleachDailyRecords.length;
      }
      
      public function GetBleachDailyRecordByID(param1:uint) : TBleachDailyRecord
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGrowRoadDayTask = null;
         _loc3_ = int(this.FBleachDailyRecords.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBleachDailyRecords[_loc2_].GrowRoadDayTask;
            if(_loc4_.Identifier == param1)
            {
               return this.FBleachDailyRecords[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TGrowRoadDayTask = null;
         _loc2_ = int(this.FBleachDailyRecords.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBleachDailyRecords[_loc1_].Reset();
            _loc1_++;
         }
      }
   }
}

