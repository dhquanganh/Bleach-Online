package Logics.HDCoolSummer
{
   import Logics.DatebaseVO.VO.THDCoolSummer;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TCoolSummerData extends TActivityOSBase
   {
      
      protected var FConfig:THDCoolSummer;
      
      protected var FFreeCount:uint;
      
      protected var FAllItems:TInventories;
      
      protected var FRandomItemIndexs:Vector.<uint>;
      
      protected var FRandomItemStates:Vector.<int>;
      
      protected var FUpdateSelectItems:Boolean;
      
      protected var FLockItems:Vector.<uint>;
      
      protected var FLockItemsPos:Vector.<uint>;
      
      protected var FScore:uint;
      
      protected var FScoreShop:TInventories;
      
      protected var FScoreItemStates:Vector.<int>;
      
      protected var FAwardIDToPos:Array;
      
      protected var FPosToAward:Array;
      
      protected var FMainAwardState:int;
      
      public function TCoolSummerData()
      {
         super();
         this.FLockItems = new Vector.<uint>();
         this.FLockItemsPos = new Vector.<uint>();
         this.FAllItems = new TInventories();
         this.FScoreShop = new TInventories();
         this.FAwardIDToPos = [];
         this.FPosToAward = [];
      }
      
      protected function ParsingConfig() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         this.FRandomItemIndexs = new Vector.<uint>(this.FConfig.ShellIndex.length);
         this.FRandomItemStates = new Vector.<int>(this.FConfig.ShellIndex.length);
         this.FScoreItemStates = new Vector.<int>(this.FConfig.ScoreShop.length);
         _loc2_ = 0;
         for each(_loc1_ in this.FConfig.Repository)
         {
            SToolReward.GetAwardsByAwardID(_loc1_.awardId,this.FAllItems);
            this.FAwardIDToPos[_loc1_.awardId] = _loc2_;
            this.FPosToAward[_loc2_] = _loc1_.awardId;
            _loc2_++;
         }
         for each(_loc1_ in this.FConfig.ScoreShop)
         {
            SToolReward.GetAwardsByAwardID(_loc1_.awardId,this.FScoreShop);
         }
      }
      
      public function get Config() : THDCoolSummer
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDCoolSummer) : void
      {
         if(this.FConfig != null)
         {
            return;
         }
         this.FConfig = param1;
         this.ParsingConfig();
      }
      
      public function get FreeCount() : uint
      {
         return this.FFreeCount;
      }
      
      public function set FreeCount(param1:uint) : void
      {
         this.FFreeCount = param1;
      }
      
      public function get AllItems() : TInventories
      {
         return this.FAllItems;
      }
      
      public function get RandomItemIndexs() : Vector.<uint>
      {
         return this.FRandomItemIndexs;
      }
      
      public function get RandomItemStates() : Vector.<int>
      {
         return this.FRandomItemStates;
      }
      
      public function get UpdateSelectItems() : Boolean
      {
         return this.FUpdateSelectItems;
      }
      
      public function set UpdateSelectItems(param1:Boolean) : void
      {
         this.FUpdateSelectItems = param1;
      }
      
      public function get LockItems() : Vector.<uint>
      {
         return this.FLockItems;
      }
      
      public function get LockItemsPos() : Vector.<uint>
      {
         return this.FLockItemsPos;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get ScoreShop() : TInventories
      {
         return this.FScoreShop;
      }
      
      public function get ScoreItemStates() : Vector.<int>
      {
         return this.FScoreItemStates;
      }
      
      public function get AwardIDToPos() : Array
      {
         return this.FAwardIDToPos;
      }
      
      public function get MainAwardState() : int
      {
         return this.FMainAwardState;
      }
      
      public function set MainAwardState(param1:int) : void
      {
         this.FMainAwardState = param1;
      }
      
      public function get PosToAward() : Array
      {
         return this.FPosToAward;
      }
   }
}

