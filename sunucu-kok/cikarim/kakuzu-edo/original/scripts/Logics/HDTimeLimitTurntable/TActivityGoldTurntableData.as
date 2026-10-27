package Logics.HDTimeLimitTurntable
{
   import Logics.DatebaseVO.VO.THDTimeLimitTurntableConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityGoldTurntableData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDTimeLimitTurntableConfig;
      
      protected var FLowExtractValue:int;
      
      protected var FHighExtractValue:int;
      
      protected var FRechargeGoldValue:int;
      
      public function TActivityGoldTurntableData()
      {
         super();
      }
      
      public function get ActivityConfig() : THDTimeLimitTurntableConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDTimeLimitTurntableConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get LowExtractValue() : int
      {
         return this.FLowExtractValue;
      }
      
      public function set LowExtractValue(param1:int) : void
      {
         this.FLowExtractValue = param1;
      }
      
      public function get HighExtractValue() : int
      {
         return this.FHighExtractValue;
      }
      
      public function set HighExtractValue(param1:int) : void
      {
         this.FHighExtractValue = param1;
      }
      
      public function get RechargeGoldValue() : int
      {
         return this.FRechargeGoldValue;
      }
      
      public function set RechargeGoldValue(param1:int) : void
      {
         this.FRechargeGoldValue = param1;
      }
   }
}

