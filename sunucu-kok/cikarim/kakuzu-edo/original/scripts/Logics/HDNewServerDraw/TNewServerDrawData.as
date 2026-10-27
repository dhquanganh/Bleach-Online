package Logics.HDNewServerDraw
{
   import Logics.DatebaseVO.VO.THDNewServerDraw;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewServerDrawData extends TActivityOSBase
   {
      
      protected var FLotteryTargetIndex:int;
      
      protected var FTodayReceiveState:int;
      
      protected var FGiftsState:Vector.<int>;
      
      protected var FInvs:Vector.<TInventories>;
      
      protected var FConfig:THDNewServerDraw;
      
      public function TNewServerDrawData()
      {
         super();
         this.FGiftsState = new Vector.<int>();
         this.FInvs = new Vector.<TInventories>();
      }
      
      public function get LotteryTargetIndex() : int
      {
         return this.FLotteryTargetIndex;
      }
      
      public function set LotteryTargetIndex(param1:int) : void
      {
         this.FLotteryTargetIndex = param1;
      }
      
      public function get TodayReceiveState() : int
      {
         return this.FTodayReceiveState;
      }
      
      public function set TodayReceiveState(param1:int) : void
      {
         this.FTodayReceiveState = param1;
      }
      
      public function get GiftsState() : Vector.<int>
      {
         return this.FGiftsState;
      }
      
      public function get Config() : THDNewServerDraw
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewServerDraw) : void
      {
         this.FConfig = param1;
      }
      
      public function get Invs() : Vector.<TInventories>
      {
         return this.FInvs;
      }
   }
}

