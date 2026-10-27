package Logics.HDNewYearSheep
{
   import Logics.DatebaseVO.VO.THDSheepRedPacketConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornGiftVo;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornMarketExchangeVo;
   import Logics.HDNewYearSheep.SendRedPacketVO.TPersonAwardVo;
   import Logics.Inventories.TInventories;
   
   public class TActivitySheepRedPacketData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDSheepRedPacketConfig;
      
      private var FShowInventories:Vector.<TInventories>;
      
      private var FMyFavornValue:int;
      
      private var FFreeSendRedPacketValue:int;
      
      private var FFreeResetValue:int;
      
      private var FAllServiceFavornValue:int;
      
      private var FPersonAwardVec:Vector.<TPersonAwardVo>;
      
      private var FFavornGiftVec:Vector.<TFavornGiftVo>;
      
      private var FFavornMarketVec:Vector.<TFavornMarketExchangeVo>;
      
      private var FGetAwardPos:int;
      
      public function TActivitySheepRedPacketData()
      {
         super();
         this.FShowInventories = new Vector.<TInventories>();
         this.FPersonAwardVec = new Vector.<TPersonAwardVo>();
         this.FFavornGiftVec = new Vector.<TFavornGiftVo>();
         this.FFavornMarketVec = new Vector.<TFavornMarketExchangeVo>();
      }
      
      public function set ActivityConfig(param1:THDSheepRedPacketConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ActivityConfig() : THDSheepRedPacketConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ShowInventories(param1:Vector.<TInventories>) : void
      {
         this.FShowInventories = param1;
      }
      
      public function get ShowInventories() : Vector.<TInventories>
      {
         return this.FShowInventories;
      }
      
      public function set MyFavornValue(param1:int) : void
      {
         this.FMyFavornValue = param1;
      }
      
      public function get MyFavornValue() : int
      {
         return this.FMyFavornValue;
      }
      
      public function set FreeSendRedPacketValue(param1:int) : void
      {
         this.FFreeSendRedPacketValue = param1;
      }
      
      public function get FreeSendRedPacketValue() : int
      {
         return this.FFreeSendRedPacketValue;
      }
      
      public function set FreeResetValue(param1:int) : void
      {
         this.FFreeResetValue = param1;
      }
      
      public function get FreeResetValue() : int
      {
         return this.FFreeResetValue;
      }
      
      public function set AllServiceFavornValue(param1:int) : void
      {
         this.FAllServiceFavornValue = param1;
      }
      
      public function get AllServiceFavornValue() : int
      {
         return this.FAllServiceFavornValue;
      }
      
      public function set PersonAwardVec(param1:Vector.<TPersonAwardVo>) : void
      {
         this.FPersonAwardVec = param1;
      }
      
      public function get PersonAwardVec() : Vector.<TPersonAwardVo>
      {
         return this.FPersonAwardVec;
      }
      
      public function set FavornGiftVec(param1:Vector.<TFavornGiftVo>) : void
      {
         this.FFavornGiftVec = param1;
      }
      
      public function get FavornGiftVec() : Vector.<TFavornGiftVo>
      {
         return this.FFavornGiftVec;
      }
      
      public function set FavornMarketVec(param1:Vector.<TFavornMarketExchangeVo>) : void
      {
         this.FFavornMarketVec = param1;
      }
      
      public function get FavornMarketVec() : Vector.<TFavornMarketExchangeVo>
      {
         return this.FFavornMarketVec;
      }
      
      public function get GetAwardPos() : int
      {
         return this.FGetAwardPos;
      }
      
      public function set GetAwardPos(param1:int) : void
      {
         this.FGetAwardPos = param1;
      }
   }
}

