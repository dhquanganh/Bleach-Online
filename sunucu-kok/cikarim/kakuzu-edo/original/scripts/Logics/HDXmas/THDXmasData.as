package Logics.HDXmas
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDXmasData extends TActivityOSBase
   {
      
      protected var FIndexCanGet:uint;
      
      protected var FCollectNumList:Vector.<uint>;
      
      protected var FDailFreeTimes:uint;
      
      protected var FInventoryList:Vector.<TXmasAwardData>;
      
      public function THDXmasData()
      {
         super();
         this.FCollectNumList = new Vector.<uint>();
         this.FInventoryList = new Vector.<TXmasAwardData>();
      }
      
      public function get IndexCanGet() : uint
      {
         return this.FIndexCanGet;
      }
      
      public function set IndexCanGet(param1:uint) : void
      {
         this.FIndexCanGet = param1;
      }
      
      public function get DailFreeTimes() : uint
      {
         return this.FDailFreeTimes;
      }
      
      public function set DailFreeTimes(param1:uint) : void
      {
         this.FDailFreeTimes = param1;
      }
      
      public function get CountCollect() : uint
      {
         return this.FCollectNumList.length;
      }
      
      public function get CountInventory() : uint
      {
         return this.FInventoryList.length;
      }
      
      public function get CollectNumList() : Vector.<uint>
      {
         return this.FCollectNumList;
      }
      
      public function set CollectNumList(param1:Vector.<uint>) : void
      {
         this.FCollectNumList = param1;
      }
      
      public function AddAward(param1:TXmasAwardData) : void
      {
         this.FInventoryList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : TXmasAwardData
      {
         return this.FInventoryList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TXmasAwardData = null;
         _loc1_ = int(this.FInventoryList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FInventoryList[_loc1_ - 1];
            _loc3_ = null;
            this.FInventoryList.pop();
            _loc1_--;
         }
      }
   }
}

