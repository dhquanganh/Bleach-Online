package Logics.HDActivityRecharge
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDDailyTotalCostData extends TActivityOSBase
   {
      
      protected var FDailyTotalCost:uint;
      
      protected var FAwardList:Vector.<TAwardData>;
      
      public function THDDailyTotalCostData()
      {
         super();
         this.FAwardList = new Vector.<TAwardData>();
      }
      
      public function get DailyTotalCost() : uint
      {
         return this.FDailyTotalCost;
      }
      
      public function set DailyTotalCost(param1:uint) : void
      {
         this.FDailyTotalCost = param1;
      }
      
      public function CountForAward() : uint
      {
         return this.FAwardList.length;
      }
      
      public function AddAward(param1:TAwardData) : void
      {
         this.FAwardList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TAwardData
      {
         return this.FAwardList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TAwardData = null;
         _loc1_ = int(this.FAwardList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FAwardList[_loc1_ - 1];
            _loc3_ = null;
            this.FAwardList.pop();
            _loc1_--;
         }
      }
   }
}

