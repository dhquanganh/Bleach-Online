package Logics.HDActivityFund
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDFundShopData extends TActivityOSBase
   {
      
      protected var FBuyIndex:int;
      
      protected var FAwardList:Vector.<TFundShopAward>;
      
      public function THDFundShopData()
      {
         super();
         this.FAwardList = new Vector.<TFundShopAward>();
      }
      
      public function get BuyIndex() : int
      {
         return this.FBuyIndex;
      }
      
      public function set BuyIndex(param1:int) : void
      {
         this.FBuyIndex = param1;
      }
      
      public function CountForAward() : uint
      {
         return this.FAwardList.length;
      }
      
      public function AddAward(param1:TFundShopAward) : void
      {
         this.FAwardList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TFundShopAward
      {
         return this.FAwardList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TFundShopAward = null;
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

