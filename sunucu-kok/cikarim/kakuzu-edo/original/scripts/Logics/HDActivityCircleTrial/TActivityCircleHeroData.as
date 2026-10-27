package Logics.HDActivityCircleTrial
{
   import Logics.DatebaseVO.VO.THDCircleHero;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityCircleHeroData extends TActivityOSBase
   {
      
      protected var FCurRechargeValue:int;
      
      protected var FNeedRechargeValue:int;
      
      protected var FRechargeGiftState:int;
      
      protected var FRechargeInventories:TInventories;
      
      protected var FTaskVo:TCircleTaskVo;
      
      protected var FExtractInventories:Vector.<TInventories>;
      
      protected var FExtractAwardVec:Vector.<TExtractFreeAwardVo>;
      
      protected var FDebrisGiftVec:Vector.<TExtractFreeAwardVo>;
      
      protected var FCircleHeroConfig:THDCircleHero;
      
      protected var FHeroState:int;
      
      protected var FFreeTimes:int;
      
      protected var FCurrentDebris:int;
      
      protected var FExtractTotalTimes:int;
      
      protected var FRounds:int;
      
      public function TActivityCircleHeroData()
      {
         super();
         this.FExtractInventories = new Vector.<TInventories>();
         this.FExtractAwardVec = new Vector.<TExtractFreeAwardVo>();
         this.FDebrisGiftVec = new Vector.<TExtractFreeAwardVo>();
      }
      
      public function get ExtractInventories() : Vector.<TInventories>
      {
         return this.FExtractInventories;
      }
      
      public function set ExtractInventories(param1:Vector.<TInventories>) : void
      {
         this.FExtractInventories = param1;
      }
      
      public function get ExtractAwardVec() : Vector.<TExtractFreeAwardVo>
      {
         return this.FExtractAwardVec;
      }
      
      public function set ExtractAwardVec(param1:Vector.<TExtractFreeAwardVo>) : void
      {
         this.FExtractAwardVec = param1;
      }
      
      public function get DebrisGiftVec() : Vector.<TExtractFreeAwardVo>
      {
         return this.FDebrisGiftVec;
      }
      
      public function set DebrisGiftVec(param1:Vector.<TExtractFreeAwardVo>) : void
      {
         this.FDebrisGiftVec = param1;
      }
      
      public function get TaskVo() : TCircleTaskVo
      {
         return this.FTaskVo;
      }
      
      public function set TaskVo(param1:TCircleTaskVo) : void
      {
         this.FTaskVo = param1;
      }
      
      public function get CircleHeroConfig() : THDCircleHero
      {
         return this.FCircleHeroConfig;
      }
      
      public function set CircleHeroConfig(param1:THDCircleHero) : void
      {
         this.FCircleHeroConfig = param1;
      }
      
      public function get CurRechargeValue() : int
      {
         return this.FCurRechargeValue;
      }
      
      public function set CurRechargeValue(param1:int) : void
      {
         this.FCurRechargeValue = param1;
      }
      
      public function get NeedRechargeValue() : int
      {
         return this.FNeedRechargeValue;
      }
      
      public function set NeedRechargeValue(param1:int) : void
      {
         this.FNeedRechargeValue = param1;
      }
      
      public function set RechargeGiftState(param1:int) : void
      {
         this.FRechargeGiftState = param1;
      }
      
      public function get RechargeGiftState() : int
      {
         return this.FRechargeGiftState;
      }
      
      public function get RechargeInventories() : TInventories
      {
         return this.FRechargeInventories;
      }
      
      public function set RechargeInventories(param1:TInventories) : void
      {
         this.FRechargeInventories = param1;
      }
      
      public function get HeroState() : int
      {
         return this.FHeroState;
      }
      
      public function set HeroState(param1:int) : void
      {
         this.FHeroState = param1;
      }
      
      public function get FreeTimes() : int
      {
         return this.FFreeTimes;
      }
      
      public function set FreeTimes(param1:int) : void
      {
         this.FFreeTimes = param1;
      }
      
      public function get CurrentDebris() : int
      {
         return this.FCurrentDebris;
      }
      
      public function set CurrentDebris(param1:int) : void
      {
         this.FCurrentDebris = param1;
      }
      
      public function get ExtractTotalTimes() : int
      {
         return this.FExtractTotalTimes;
      }
      
      public function set ExtractTotalTimes(param1:int) : void
      {
         this.FExtractTotalTimes = param1;
      }
      
      public function get Rounds() : int
      {
         return this.FRounds;
      }
      
      public function set Rounds(param1:int) : void
      {
         this.FRounds = param1;
      }
   }
}

