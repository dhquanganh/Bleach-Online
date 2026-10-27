package Logics.Log
{
   import Foundation.Registries.TRegistryInstance;
   
   public class TLogs
   {
      
      protected var FRegisterLog:TRegistryInstance;
      
      public function TLogs()
      {
         super();
         this.FRegisterLog = new TRegistryInstance();
      }
      
      protected function SortByTime(param1:TLog, param2:TLog) : int
      {
         if(param1.RecoredTime > param2.RecoredTime)
         {
            return -1;
         }
         if(param1.RecoredTime < param2.RecoredTime)
         {
            return 1;
         }
         return 0;
      }
      
      public function GetLogsByType(param1:int) : Vector.<TLog>
      {
         var _loc2_:Vector.<TLog> = null;
         _loc2_ = this.FRegisterLog.GetInstanceByIdentifier(param1) as Vector.<TLog>;
         if(_loc2_ == null)
         {
            _loc2_ = new Vector.<TLog>();
            this.FRegisterLog.Register(param1,_loc2_);
         }
         return _loc2_;
      }
      
      public function ClearByType(param1:int) : void
      {
         var _loc2_:Vector.<TLog> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = this.FRegisterLog.GetInstanceByIdentifier(param1) as Vector.<TLog>;
         if(_loc2_ == null)
         {
            return;
         }
         _loc4_ = int(_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_[_loc3_].StubReferences.Dereference(this);
            _loc3_++;
         }
         _loc2_.length = 0;
      }
      
      public function Sort(param1:Vector.<TLog>) : void
      {
         param1.sort(this.SortByTime);
      }
      
      public function AddByType(param1:int, param2:TLog) : void
      {
         var _loc3_:Vector.<TLog> = null;
         _loc3_ = this.GetLogsByType(param1);
         param2.StubReferences.Reference(this);
         _loc3_.push(param2);
      }
   }
}

