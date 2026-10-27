package Logics.HDActivityFund
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDFundLvData extends TActivityOSBase
   {
      
      protected var FAwardList:Vector.<TFundLvAwardData>;
      
      public function THDFundLvData()
      {
         super();
         this.FAwardList = new Vector.<TFundLvAwardData>();
      }
      
      public function CountForAward() : uint
      {
         return this.FAwardList.length;
      }
      
      public function AddAward(param1:TFundLvAwardData) : void
      {
         this.FAwardList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TFundLvAwardData
      {
         return this.FAwardList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TFundLvAwardData = null;
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

