package Logics.TreasureMap
{
   public class TTreasureMapReports
   {
      
      protected var FTreasureMapReports:Vector.<TTreasureMapReport>;
      
      public function TTreasureMapReports()
      {
         super();
         this.FTreasureMapReports = new Vector.<TTreasureMapReport>();
      }
      
      public function get Count() : int
      {
         return this.FTreasureMapReports.length;
      }
      
      public function GetReportByIndex(param1:int) : TTreasureMapReport
      {
         return this.FTreasureMapReports[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTreasureMapReport = null;
         _loc1_ = int(this.FTreasureMapReports.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FTreasureMapReports[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FTreasureMapReports.length = 0;
      }
      
      public function Add(param1:TTreasureMapReport) : void
      {
         param1.StubReferences.Reference(this);
         this.FTreasureMapReports.push(param1);
      }
   }
}

