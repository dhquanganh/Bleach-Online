package Logics.HDThanksgivingDay
{
   import Logics.DatebaseVO.VO.THDThanksTreasure;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import flash.utils.Dictionary;
   
   public class TThanksTreasureData extends TActivityOSBase
   {
      
      protected const TreasureCount:uint = 10;
      
      protected var FScore:uint;
      
      protected var FStopIndex:int;
      
      protected var FMap:Dictionary;
      
      protected var FScoreItemStates:Vector.<int>;
      
      protected var FHeroGiftState:int;
      
      protected var FConfig:THDThanksTreasure;
      
      protected var FGameOver:Boolean;
      
      protected var FCurRefresh:Boolean;
      
      protected var FRemainDig:uint;
      
      protected var FScoreShop:TInventories;
      
      public function TThanksTreasureData()
      {
         super();
         this.FMap = new Dictionary();
         this.FScoreItemStates = new Vector.<int>();
         this.FScoreShop = new TInventories();
         this.FGameOver = false;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get StopIndex() : int
      {
         return this.FStopIndex;
      }
      
      public function set StopIndex(param1:int) : void
      {
         this.FStopIndex = param1;
      }
      
      public function get Map() : Dictionary
      {
         return this.FMap;
      }
      
      public function get Config() : THDThanksTreasure
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDThanksTreasure) : void
      {
         this.FConfig = param1;
      }
      
      public function get GameOver() : Boolean
      {
         return this.FGameOver;
      }
      
      public function set GameOver(param1:Boolean) : void
      {
         this.FGameOver = param1;
      }
      
      public function get CurRefresh() : Boolean
      {
         return this.FCurRefresh;
      }
      
      public function set CurRefresh(param1:Boolean) : void
      {
         this.FCurRefresh = param1;
      }
      
      public function get HeroGiftState() : int
      {
         return this.FHeroGiftState;
      }
      
      public function set HeroGiftState(param1:int) : void
      {
         this.FHeroGiftState = param1;
      }
      
      public function get RemainDig() : uint
      {
         return this.FRemainDig;
      }
      
      public function set RemainDig(param1:uint) : void
      {
         this.FRemainDig = param1;
      }
      
      public function get ScoreShop() : TInventories
      {
         return this.FScoreShop;
      }
      
      public function get ScoreItemStates() : Vector.<int>
      {
         return this.FScoreItemStates;
      }
      
      public function AllNotDig() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:TThanksTreasureVO = null;
         _loc1_ = 0;
         while(_loc1_ < this.TreasureCount)
         {
            _loc2_ = this.FMap[_loc1_];
            if(_loc2_.State == TThanksTreasureVO.STATE_RECEIVE)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function InitMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TThanksTreasureVO = null;
         _loc1_ = 0;
         while(_loc1_ < this.TreasureCount)
         {
            _loc2_ = new TThanksTreasureVO();
            this.FMap[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
   }
}

