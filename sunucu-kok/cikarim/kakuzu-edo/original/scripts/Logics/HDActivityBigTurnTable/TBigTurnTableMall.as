package Logics.HDActivityBigTurnTable
{
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TBigTurnTableMall
   {
      
      protected var FIndex:Vector.<uint>;
      
      protected var FCostChip:Vector.<uint>;
      
      protected var FTimeLimit:Vector.<int>;
      
      protected var FAward:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FBuyedTime:Vector.<int>;
      
      protected var FMallArray:Array;
      
      public function TBigTurnTableMall(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         super();
         this.FIndex = new Vector.<uint>();
         this.FCostChip = new Vector.<uint>();
         this.FTimeLimit = new Vector.<int>();
         this.FAward = new Vector.<uint>();
         this.FBuyedTime = new Vector.<int>();
         this.FInventories = new TInventories();
         _loc4_ = param1 as Array;
         this.FMallArray = _loc4_;
      }
      
      public function CreateLotteryAward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:TInventories = null;
         _loc4_ = new TInventories();
         _loc2_ = int(this.FMallArray.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMallArray[_loc1_];
            this.FIndex.push(_loc3_.index);
            this.FCostChip.push(_loc3_.costChip[0].value);
            this.FTimeLimit.push(_loc3_.limit);
            SToolReward.GetAwardsByAwardID(_loc3_.award[0],_loc4_);
            this.FInventories.Add(_loc4_.GetInventoryByIndex(0));
            _loc4_.Clear();
            _loc1_++;
         }
      }
      
      public function get Index() : Vector.<uint>
      {
         return this.FIndex;
      }
      
      public function get CostChip() : Vector.<uint>
      {
         return this.FCostChip;
      }
      
      public function get Award() : Vector.<uint>
      {
         return this.FAward;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function get BuyedTime() : Vector.<int>
      {
         return this.FBuyedTime;
      }
      
      public function get TimeLimit() : Vector.<int>
      {
         return this.FTimeLimit;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FIndex.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.FIndex[_loc4_] == param1)
            {
               this.FBuyedTime[_loc4_] = param2;
            }
            _loc4_++;
         }
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FIndex.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.FIndex[_loc4_] == param1)
            {
               this.FBuyedTime[_loc4_] = param2;
            }
            _loc4_++;
         }
      }
   }
}

