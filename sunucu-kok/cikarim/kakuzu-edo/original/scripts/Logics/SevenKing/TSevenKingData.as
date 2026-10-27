package Logics.SevenKing
{
   import Resources.Constants.CONST_COMMON;
   
   public class TSevenKingData
   {
      
      public static const CONST_Soul:uint = CONST_COMMON.CAPACITY_KingSouls;
      
      public static const CONST_Report:uint = 4;
      
      protected var FCurBattleTimes:uint;
      
      protected var FCurProgressFlag:uint;
      
      protected var FRespectInfo:Vector.<uint>;
      
      protected var FReportUserName:Vector.<String>;
      
      protected var FReportID:Vector.<String>;
      
      public function TSevenKingData()
      {
         super();
         this.FRespectInfo = new Vector.<uint>(CONST_Soul);
         this.FReportUserName = new Vector.<String>(CONST_Report);
         this.FReportID = new Vector.<String>(CONST_Report);
      }
      
      public function get CurBattleTimes() : uint
      {
         return this.FCurBattleTimes;
      }
      
      public function set CurBattleTimes(param1:uint) : void
      {
         this.FCurBattleTimes = param1;
      }
      
      public function get CurProgressFlag() : uint
      {
         return this.FCurProgressFlag;
      }
      
      public function set CurProgressFlag(param1:uint) : void
      {
         this.FCurProgressFlag = param1;
      }
      
      public function get RespectInfo() : Vector.<uint>
      {
         return this.FRespectInfo;
      }
      
      public function set RespectInfo(param1:Vector.<uint>) : void
      {
         this.FRespectInfo = param1;
      }
      
      public function get ReportUserName() : Vector.<String>
      {
         return this.FReportUserName;
      }
      
      public function set ReportUserName(param1:Vector.<String>) : void
      {
         this.FReportUserName = param1;
      }
      
      public function get ReportID() : Vector.<String>
      {
         return this.FReportID;
      }
      
      public function set ReportID(param1:Vector.<String>) : void
      {
         this.FReportID = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         this.FCurBattleTimes = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_Soul)
         {
            this.FRespectInfo[_loc1_] = 0;
            _loc1_++;
         }
      }
   }
}

