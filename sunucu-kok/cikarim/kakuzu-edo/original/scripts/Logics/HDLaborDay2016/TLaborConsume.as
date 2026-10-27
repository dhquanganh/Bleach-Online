package Logics.HDLaborDay2016
{
   import Logics.DatebaseVO.VO.THDLaborConsume;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TLaborConsume extends TActivityOSBase
   {
      
      protected var FConfig:THDLaborConsume;
      
      protected var FScore:uint;
      
      protected var FRefreshCount:uint;
      
      protected var FShowState:int;
      
      protected var FGiftInfo:Vector.<int>;
      
      protected var FStoreState:Vector.<int>;
      
      public function TLaborConsume()
      {
         super();
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get RefreshCount() : uint
      {
         return this.FRefreshCount;
      }
      
      public function set RefreshCount(param1:uint) : void
      {
         this.FRefreshCount = param1;
      }
      
      public function get ShowState() : int
      {
         return this.FShowState;
      }
      
      public function set ShowState(param1:int) : void
      {
         this.FShowState = param1;
      }
      
      public function get GiftInfo() : Vector.<int>
      {
         return this.FGiftInfo;
      }
      
      public function set GiftInfo(param1:Vector.<int>) : void
      {
         this.FGiftInfo = param1;
      }
      
      public function get StoreState() : Vector.<int>
      {
         return this.FStoreState;
      }
      
      public function set StoreState(param1:Vector.<int>) : void
      {
         this.FStoreState = param1;
      }
      
      public function get Config() : THDLaborConsume
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDLaborConsume) : void
      {
         if(this.FConfig == null)
         {
            this.FConfig = param1;
            this.FGiftInfo = new Vector.<int>(this.FConfig.BannerIndex.length);
            this.FStoreState = new Vector.<int>(this.FConfig.Mall.length);
         }
      }
   }
}

