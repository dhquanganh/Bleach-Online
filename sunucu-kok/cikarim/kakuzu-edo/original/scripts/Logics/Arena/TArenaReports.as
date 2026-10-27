package Logics.Arena
{
   public class TArenaReports
   {
      
      protected var FArenaReports:Vector.<TArenaReport>;
      
      public function TArenaReports()
      {
         super();
         this.FArenaReports = new Vector.<TArenaReport>();
      }
      
      public function get Count() : int
      {
         return this.FArenaReports.length;
      }
      
      public function GetReportByIndex(param1:int) : TArenaReport
      {
         return this.FArenaReports[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TArenaReport = null;
         _loc1_ = int(this.FArenaReports.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FArenaReports[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FArenaReports.length = 0;
      }
      
      public function Add(param1:TArenaReport) : void
      {
         param1.StubReferences.Reference(this);
         this.FArenaReports.push(param1);
      }
   }
}

