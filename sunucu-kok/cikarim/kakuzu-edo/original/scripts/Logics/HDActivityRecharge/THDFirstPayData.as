package Logics.HDActivityRecharge
{
   public class THDFirstPayData
   {
      
      protected var FAwardList:Vector.<TAwardData>;
      
      protected var FTotalPay:uint;
      
      public function THDFirstPayData()
      {
         super();
         this.FAwardList = new Vector.<TAwardData>();
      }
      
      public function get AwardList() : Vector.<TAwardData>
      {
         return this.FAwardList;
      }
      
      public function set AwardList(param1:Vector.<TAwardData>) : void
      {
         this.FAwardList = param1;
      }
      
      public function get TotalPay() : uint
      {
         return this.FTotalPay;
      }
      
      public function set TotalPay(param1:uint) : void
      {
         this.FTotalPay = param1;
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

