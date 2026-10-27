package Logics.InteractionLog
{
   public class TInteractionLogs
   {
      
      protected var FInteractionLogs:Vector.<TInteractionLog>;
      
      public function TInteractionLogs()
      {
         super();
         this.FInteractionLogs = new Vector.<TInteractionLog>();
      }
      
      protected function SortByTime(param1:TInteractionLog, param2:TInteractionLog) : int
      {
         if(param1.Time > param2.Time)
         {
            return -1;
         }
         if(param1.Time < param2.Time)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FInteractionLogs.length;
      }
      
      public function GetInteractionLogByIndex(param1:int) : TInteractionLog
      {
         return this.FInteractionLogs[param1];
      }
      
      public function GetInteractionLogByIdentifier(param1:uint, param2:uint) : TInteractionLog
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FInteractionLogs[_loc3_].Identifier0 == param1 && this.FInteractionLogs[_loc3_].Identifier1 == param2)
            {
               return this.FInteractionLogs[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInteractionLog = null;
         _loc1_ = int(this.FInteractionLogs.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FInteractionLogs[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FInteractionLogs.length = 0;
      }
      
      public function Add(param1:TInteractionLog) : void
      {
         param1.StubReferences.Reference(this);
         this.FInteractionLogs.push(param1);
      }
      
      public function DeleteInteractionLogByIndex(param1:uint) : void
      {
         var _loc2_:TInteractionLog = null;
         _loc2_ = this.FInteractionLogs[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FInteractionLogs.splice(param1,1);
      }
      
      public function Sort() : void
      {
         this.FInteractionLogs.sort(this.SortByTime);
      }
   }
}

