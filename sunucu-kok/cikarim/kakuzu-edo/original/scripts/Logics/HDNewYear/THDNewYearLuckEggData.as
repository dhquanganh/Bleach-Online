package Logics.HDNewYear
{
   import Foundation.Timing.STimingCore;
   import Logics.DatebaseVO.VO.THDNewYearLuckEggConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear.VO.TNewYearLuckEggGiftVO;
   import Logics.HDNewYear.VO.TNewYearLuckEggVO;
   
   public class THDNewYearLuckEggData extends TActivityOSBase
   {
      
      public static const LOGINGIFTS_COUNT:uint = 5;
      
      public static const EGGROLLGIFTS_COUNT:uint = 8;
      
      public static const LUCKEGG_COUNT:uint = 3;
      
      protected var FLoginGifts:Vector.<TNewYearLuckEggGiftVO>;
      
      protected var FEggRollGifts:Vector.<TNewYearLuckEggGiftVO>;
      
      protected var FEggs:Vector.<TNewYearLuckEggVO>;
      
      protected var FHammerCount:uint;
      
      protected var FEggRollCount:uint;
      
      protected var FConfig:THDNewYearLuckEggConfig;
      
      protected var FLanguage:THDNewYearLuckEggLanguage;
      
      public function THDNewYearLuckEggData()
      {
         var _loc1_:uint = 0;
         var _loc2_:TNewYearLuckEggGiftVO = null;
         var _loc3_:TNewYearLuckEggVO = null;
         super();
         this.FLoginGifts = new Vector.<TNewYearLuckEggGiftVO>(LOGINGIFTS_COUNT);
         this.FEggRollGifts = new Vector.<TNewYearLuckEggGiftVO>(EGGROLLGIFTS_COUNT);
         this.FEggs = new Vector.<TNewYearLuckEggVO>(LUCKEGG_COUNT);
         this.FLanguage = new THDNewYearLuckEggLanguage();
         _loc1_ = 0;
         while(_loc1_ < LOGINGIFTS_COUNT)
         {
            _loc2_ = new TNewYearLuckEggGiftVO();
            this.FLoginGifts[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < EGGROLLGIFTS_COUNT)
         {
            _loc2_ = new TNewYearLuckEggGiftVO();
            this.FEggRollGifts[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < LUCKEGG_COUNT)
         {
            _loc3_ = new TNewYearLuckEggVO();
            this.FEggs[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      public function get LoginGifts() : Vector.<TNewYearLuckEggGiftVO>
      {
         return this.FLoginGifts;
      }
      
      public function get EggRollGifts() : Vector.<TNewYearLuckEggGiftVO>
      {
         return this.FEggRollGifts;
      }
      
      public function get HammerCount() : uint
      {
         return this.FHammerCount;
      }
      
      public function set HammerCount(param1:uint) : void
      {
         this.FHammerCount = param1;
      }
      
      public function get Eggs() : Vector.<TNewYearLuckEggVO>
      {
         return this.FEggs;
      }
      
      public function get EggRollCount() : uint
      {
         return this.FEggRollCount;
      }
      
      public function set EggRollCount(param1:uint) : void
      {
         this.FEggRollCount = param1;
      }
      
      public function get Config() : THDNewYearLuckEggConfig
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYearLuckEggConfig) : void
      {
         this.FConfig = param1;
         this.FLanguage.FillLanguage(this.FConfig);
      }
      
      public function get Language() : THDNewYearLuckEggLanguage
      {
         return this.FLanguage;
      }
      
      public function UpdateFreeEggTimeStamp(param1:Number, param2:Number) : void
      {
         var _loc3_:TNewYearLuckEggVO = null;
         _loc3_ = this.FEggs[0];
         if(_loc3_.CurCount < _loc3_.TotalCount)
         {
            _loc3_.RemainTime = Math.max(param1 - (STimingCore.ServerTick - param2),0);
         }
      }
      
      public function UpdateFreeEggRemainTime(param1:Number) : void
      {
         var _loc2_:TNewYearLuckEggVO = null;
         _loc2_ = this.FEggs[0];
         _loc2_.RemainTime -= param1;
         if(_loc2_.RemainTime < 0)
         {
            _loc2_.RemainTime = 0;
         }
      }
      
      public function GetEggDataIndexByVecIndex(param1:uint) : int
      {
         switch(param1)
         {
            case 0:
               return this.FConfig.CopperEgg.index;
            case 1:
               return this.FConfig.SilverEgg.index;
            case 2:
               return this.FConfig.GoldEgg.index;
            default:
               return -1;
         }
      }
      
      public function GetEggNeedGold(param1:uint) : int
      {
         var _loc2_:TNewYearLuckEggVO = null;
         _loc2_ = this.FEggs[param1];
         if(_loc2_.IsFree)
         {
            return 0;
         }
         return Math.max(_loc2_.NeedHammerCount - this.FHammerCount,0) * this.FConfig.HammerCostGold;
      }
   }
}

