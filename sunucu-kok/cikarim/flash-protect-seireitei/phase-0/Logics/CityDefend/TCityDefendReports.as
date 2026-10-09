package Logics.CityDefend
{
   public class TCityDefendReports
   {
      
      protected var FCityDefendReports:Vector.<TCityDefendReport>;
      
      public function TCityDefendReports()
      {
         super();
         this.FCityDefendReports = new Vector.<TCityDefendReport>();
      }
      
      public function get Count() : int
      {
         return this.FCityDefendReports.length;
      }
      
      public function GetReportByIndex(param1:int) : TCityDefendReport
      {
         return this.FCityDefendReports[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCityDefendReport = null;
         _loc1_ = int(this.FCityDefendReports.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FCityDefendReports[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FCityDefendReports.length = 0;
      }
      
      public function Add(param1:TCityDefendReport) : void
      {
         param1.StubReferences.Reference(this);
         this.FCityDefendReports.push(param1);
         while(this.FCityDefendReports.length > 20)
         {
            var oldest:TCityDefendReport = this.FCityDefendReports.shift();
            oldest.StubReferences.Dereference(this);
         }
      }
   }
}

