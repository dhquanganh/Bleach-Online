package Logics.HDNewYearSheep
{
   import Logics.DatebaseVO.VO.THDSheepGoodSell;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class THDSheepGoodSellData extends TActivityOSBase
   {
      
      protected var FSheepGoodSellVO:THDSheepGoodSell;
      
      protected var FFreeAwards:Vector.<TInventories>;
      
      protected var FActAwards:Vector.<Vector.<TInventories>>;
      
      protected var FActAwardBuyFlag:Vector.<int>;
      
      protected var FLoadingAwards:Vector.<TInventories>;
      
      protected var FLoadingAwardReciveFlag:Boolean;
      
      protected var FFinalAwards:TInventories;
      
      protected var FFinalAwardReciveFlag:Boolean;
      
      protected var FActivityNum:int;
      
      protected var FInited:Boolean;
      
      public function THDSheepGoodSellData()
      {
         super();
         this.FFreeAwards = new Vector.<TInventories>();
         this.FActAwards = new Vector.<Vector.<TInventories>>();
         this.FLoadingAwards = new Vector.<TInventories>();
         this.FFinalAwards = new TInventories();
         this.FActAwardBuyFlag = new Vector.<int>();
      }
      
      public function get ActAwardBuyFlag() : Vector.<int>
      {
         return this.FActAwardBuyFlag;
      }
      
      public function set ActAwardBuyFlag(param1:Vector.<int>) : void
      {
         this.FActAwardBuyFlag = param1;
      }
      
      public function get LoadingAwardReciveFlag() : Boolean
      {
         return this.FLoadingAwardReciveFlag;
      }
      
      public function set LoadingAwardReciveFlag(param1:Boolean) : void
      {
         this.FLoadingAwardReciveFlag = param1;
      }
      
      public function get FinalAwardReciveFlag() : Boolean
      {
         return this.FFinalAwardReciveFlag;
      }
      
      public function set FinalAwardReciveFlag(param1:Boolean) : void
      {
         this.FFinalAwardReciveFlag = param1;
      }
      
      public function get ActivityNum() : int
      {
         return this.FActivityNum - 1;
      }
      
      public function set ActivityNum(param1:int) : void
      {
         this.FActivityNum = param1;
      }
      
      public function get SheepGoodSellVO() : THDSheepGoodSell
      {
         return this.FSheepGoodSellVO;
      }
      
      public function set SheepGoodSellVO(param1:THDSheepGoodSell) : void
      {
         this.FSheepGoodSellVO = param1;
      }
      
      public function get FinalAwards() : TInventories
      {
         return this.FFinalAwards;
      }
      
      public function get ActAwards() : Vector.<Vector.<TInventories>>
      {
         return this.FActAwards;
      }
      
      public function get FreeAwards() : Vector.<TInventories>
      {
         return this.FFreeAwards;
      }
      
      public function get LoadingAwards() : Vector.<TInventories>
      {
         return this.FLoadingAwards;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
   }
}

