package Logics.HDActivityRecharge
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDDailyCostData extends TActivityOSBase
   {
      
      protected var FAwardList:Vector.<TDailyCostAwardData>;
      
      public function THDDailyCostData()
      {
         super();
         this.FAwardList = new Vector.<TDailyCostAwardData>();
      }
      
      public function CountForAward() : uint
      {
         return this.FAwardList.length;
      }
      
      public function AddAward(param1:TDailyCostAwardData) : void
      {
         this.FAwardList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TDailyCostAwardData
      {
         return this.FAwardList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TDailyCostAwardData = null;
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

