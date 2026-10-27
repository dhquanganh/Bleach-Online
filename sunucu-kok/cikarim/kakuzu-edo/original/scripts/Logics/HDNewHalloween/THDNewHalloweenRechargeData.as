package Logics.HDNewHalloween
{
   import Logics.DatebaseVO.VO.THDNewHalloweenRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornMarketExchangeVo;
   import Logics.Streamization.HDActivityNewHalloween.RechargeVo.TRechargeGiftVo;
   
   public class THDNewHalloweenRechargeData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDNewHalloweenRecharge;
      
      private var FScore:int;
      
      private var FCurDayGold:int;
      
      private var FTotalGold:int;
      
      private var FEveryDayAwardVec:Vector.<TRechargeGiftVo>;
      
      private var FGoldAwardVec:Vector.<TRechargeGiftVo>;
      
      private var FScoreMallVoVec:Vector.<TFavornMarketExchangeVo>;
      
      public function THDNewHalloweenRechargeData()
      {
         super();
         this.FEveryDayAwardVec = new Vector.<TRechargeGiftVo>();
         this.FGoldAwardVec = new Vector.<TRechargeGiftVo>();
         this.FScoreMallVoVec = new Vector.<TFavornMarketExchangeVo>();
      }
      
      public function set ActivityConfig(param1:THDNewHalloweenRecharge) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ActivityConfig() : THDNewHalloweenRecharge
      {
         return this.FActivityConfig;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set TotalGold(param1:int) : void
      {
         this.FTotalGold = param1;
      }
      
      public function get TotalGold() : int
      {
         return this.FTotalGold;
      }
      
      public function set CurDayGold(param1:int) : void
      {
         this.FCurDayGold = param1;
      }
      
      public function get CurDayGold() : int
      {
         return this.FCurDayGold;
      }
      
      public function set EveryDayAwardVec(param1:Vector.<TRechargeGiftVo>) : void
      {
         this.FEveryDayAwardVec = param1;
      }
      
      public function get EveryDayAwardVec() : Vector.<TRechargeGiftVo>
      {
         return this.FEveryDayAwardVec;
      }
      
      public function set GoldAwardVec(param1:Vector.<TRechargeGiftVo>) : void
      {
         this.FGoldAwardVec = param1;
      }
      
      public function get GoldAwardVec() : Vector.<TRechargeGiftVo>
      {
         return this.FGoldAwardVec;
      }
      
      public function set ScoreMallVoVec(param1:Vector.<TFavornMarketExchangeVo>) : void
      {
         this.FScoreMallVoVec = param1;
      }
      
      public function get ScoreMallVoVec() : Vector.<TFavornMarketExchangeVo>
      {
         return this.FScoreMallVoVec;
      }
   }
}

