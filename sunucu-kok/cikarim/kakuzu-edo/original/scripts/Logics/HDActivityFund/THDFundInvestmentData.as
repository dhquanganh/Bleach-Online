package Logics.HDActivityFund
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDFundInvestmentData extends TActivityOSBase
   {
      
      protected var FFundInvestmentList:Vector.<TFundInvestment>;
      
      public function THDFundInvestmentData()
      {
         super();
         this.FFundInvestmentList = new Vector.<TFundInvestment>();
      }
      
      public function CountForAward() : uint
      {
         return this.FFundInvestmentList.length;
      }
      
      public function AddAward(param1:TFundInvestment) : void
      {
         this.FFundInvestmentList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TFundInvestment
      {
         return this.FFundInvestmentList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TFundInvestment = null;
         _loc1_ = int(this.FFundInvestmentList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FFundInvestmentList[_loc1_ - 1];
            _loc3_ = null;
            this.FFundInvestmentList.pop();
            _loc1_--;
         }
      }
   }
}

