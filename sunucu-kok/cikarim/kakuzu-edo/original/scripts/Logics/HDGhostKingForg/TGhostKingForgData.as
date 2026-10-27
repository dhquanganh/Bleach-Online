package Logics.HDGhostKingForg
{
   import Logics.DatebaseVO.VO.THDGhostKingForg;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TGhostKingForgData extends TActivityOSBase
   {
      
      protected var FConfig:THDGhostKingForg;
      
      protected var FTotalRecharge:uint;
      
      protected var FTotalGhostKingPower:uint;
      
      protected var FCanSelectCount:uint;
      
      protected var FForgGiftState:int;
      
      protected var FShowUIState:int;
      
      protected var FScoreItemStates:Vector.<int>;
      
      protected var FForgPower:uint;
      
      public function TGhostKingForgData()
      {
         super();
         this.FScoreItemStates = new Vector.<int>();
      }
      
      public function get TotalRecharge() : uint
      {
         return this.FTotalRecharge;
      }
      
      public function set TotalRecharge(param1:uint) : void
      {
         this.FTotalRecharge = param1;
      }
      
      public function get TotalGhostKingPower() : uint
      {
         return this.FTotalGhostKingPower;
      }
      
      public function set TotalGhostKingPower(param1:uint) : void
      {
         this.FTotalGhostKingPower = param1;
      }
      
      public function get CanSelectCount() : uint
      {
         return this.FCanSelectCount;
      }
      
      public function set CanSelectCount(param1:uint) : void
      {
         this.FCanSelectCount = param1;
      }
      
      public function get ForgGiftState() : int
      {
         return this.FForgGiftState;
      }
      
      public function set ForgGiftState(param1:int) : void
      {
         this.FForgGiftState = param1;
      }
      
      public function get ShowUIState() : int
      {
         return this.FShowUIState;
      }
      
      public function set ShowUIState(param1:int) : void
      {
         this.FShowUIState = param1;
      }
      
      public function get ScoreItemStates() : Vector.<int>
      {
         return this.FScoreItemStates;
      }
      
      public function set ScoreItemStates(param1:Vector.<int>) : void
      {
         this.FScoreItemStates = param1;
      }
      
      public function get ForgPower() : uint
      {
         return this.FForgPower;
      }
      
      public function set ForgPower(param1:uint) : void
      {
         this.FForgPower = param1;
      }
      
      public function get Config() : THDGhostKingForg
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDGhostKingForg) : void
      {
         this.FConfig = param1;
      }
   }
}

