package Logics.BleachDailyRecord
{
   import Logics.DatebaseVO.VO.TGrowRoadDayTask;
   
   public class TBleachDailyRecord
   {
      
      protected var FGrowRoadDayTask:TGrowRoadDayTask;
      
      protected var FIfOpen:Boolean;
      
      protected var FUnlockDescription:String;
      
      protected var FRecordValue:int;
      
      public function TBleachDailyRecord()
      {
         super();
         this.Reset();
      }
      
      public function get GrowRoadDayTask() : TGrowRoadDayTask
      {
         return this.FGrowRoadDayTask;
      }
      
      public function set GrowRoadDayTask(param1:TGrowRoadDayTask) : void
      {
         this.FGrowRoadDayTask = param1;
      }
      
      public function get IfOpen() : Boolean
      {
         return this.FIfOpen;
      }
      
      public function set IfOpen(param1:Boolean) : void
      {
         this.FIfOpen = param1;
      }
      
      public function get UnlockDescription() : String
      {
         return this.FUnlockDescription;
      }
      
      public function set UnlockDescription(param1:String) : void
      {
         this.FUnlockDescription = param1;
      }
      
      public function get RecordValue() : int
      {
         return this.FRecordValue;
      }
      
      public function set RecordValue(param1:int) : void
      {
         this.FRecordValue = param1;
      }
      
      public function Reset() : void
      {
         this.FIfOpen = false;
         this.FRecordValue = 0;
      }
   }
}

