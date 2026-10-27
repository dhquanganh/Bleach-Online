package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSheepRedPacketConfig extends THDActivityBase
   {
      
      private var FMyselfFavoutIndex:int;
      
      private var FAllPropsVec:Vector.<int>;
      
      private var FAllServerIndexVec:Vector.<int>;
      
      private var FAllServerConditionVec:Vector.<int>;
      
      private var FAllServerAwardVec:Vector.<int>;
      
      private var FMarketIndexVec:Vector.<int>;
      
      private var FMarketCostVec:Vector.<int>;
      
      private var FMarketAwardVec:Vector.<int>;
      
      private var FMarketLimitVec:Vector.<int>;
      
      private var FSendFreeIndex:int;
      
      private var FResetFreeIndex:int;
      
      private var FResetFreeValue:int;
      
      private var FSendFreeValue:int;
      
      private var FSendRedPacketIndex:int;
      
      private var FSendPacketCostGold:int;
      
      private var FResetBtnIndex:int;
      
      private var FResetCostGold:int;
      
      private var FShowAwardVec:Vector.<int>;
      
      private var FRandomPropsIndex:int;
      
      private var FFavourValue:int;
      
      private var FSendPacketPrompt:String;
      
      private var FResetPrompt:String;
      
      private var FFavourPrompt:String;
      
      private var FAllServiceIndex:int;
      
      private var FSendRedPacketFinishPrompt:String;
      
      private var FFreeResetPrompt:String;
      
      public function THDSheepRedPacketConfig()
      {
         super();
         this.FAllPropsVec = new Vector.<int>();
         this.FAllServerIndexVec = new Vector.<int>();
         this.FAllServerConditionVec = new Vector.<int>();
         this.FAllServerAwardVec = new Vector.<int>();
         this.FMarketIndexVec = new Vector.<int>();
         this.FMarketCostVec = new Vector.<int>();
         this.FMarketAwardVec = new Vector.<int>();
         this.FMarketLimitVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FMyselfFavoutIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAllPropsVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAllServerIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FAllServerConditionVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FAllServerAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMarketIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FMarketCostVec[_loc2_] = _loc4_[_loc2_].costFavour;
            this.FMarketAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FMarketLimitVec[_loc2_] = _loc4_[_loc2_].limit;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FSendFreeIndex = _loc6_.giveAwardIndex;
         this.FResetFreeIndex = _loc6_.resetFreeTimeIndex;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FResetFreeValue = _loc6_.resetValue;
         this.FSendFreeValue = _loc6_.giveAwardValue;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FSendRedPacketIndex = _loc6_.index;
         this.FSendPacketCostGold = _loc6_.costGold;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FResetBtnIndex = _loc6_.index;
         this.FResetCostGold = _loc6_.costGold;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FShowAwardVec = Vector.<int>(_loc4_);
         this.FRandomPropsIndex = param1.readUnsignedInt();
         this.FFavourValue = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FSendPacketPrompt = _loc6_.sendPacketPrompt;
         this.FResetPrompt = _loc6_.resetPrompt;
         this.FFreeResetPrompt = _loc6_.freeReset;
         this.FFavourPrompt = _loc6_.favourPrompt;
         this.FSendRedPacketFinishPrompt = _loc6_.sendFinishPrompt;
         this.FAllServiceIndex = param1.readUnsignedInt();
      }
      
      public function get MyselfFavoutIndex() : int
      {
         return this.FMyselfFavoutIndex;
      }
      
      public function get AllPropsVec() : Vector.<int>
      {
         return this.FAllPropsVec;
      }
      
      public function get AllServerIndexVec() : Vector.<int>
      {
         return this.FAllServerIndexVec;
      }
      
      public function get AllServerConditionVec() : Vector.<int>
      {
         return this.FAllServerConditionVec;
      }
      
      public function get AllServerAwardVec() : Vector.<int>
      {
         return this.FAllServerAwardVec;
      }
      
      public function get MarketIndexVec() : Vector.<int>
      {
         return this.FMarketIndexVec;
      }
      
      public function get MarketCostVec() : Vector.<int>
      {
         return this.FMarketCostVec;
      }
      
      public function get MarketAwardVec() : Vector.<int>
      {
         return this.FMarketAwardVec;
      }
      
      public function get MarketLimitVec() : Vector.<int>
      {
         return this.FMarketLimitVec;
      }
      
      public function get SendFreeIndex() : int
      {
         return this.FSendFreeIndex;
      }
      
      public function get ResetFreeIndex() : int
      {
         return this.FResetFreeIndex;
      }
      
      public function get ResetFreeValue() : int
      {
         return this.FResetFreeValue;
      }
      
      public function get SendFreeValue() : int
      {
         return this.FSendFreeValue;
      }
      
      public function get SendRedPacketIndex() : int
      {
         return this.FSendRedPacketIndex;
      }
      
      public function get SendPacketCostGold() : int
      {
         return this.FSendPacketCostGold;
      }
      
      public function get ResetBtnIndex() : int
      {
         return this.FResetBtnIndex;
      }
      
      public function get ResetCostGold() : int
      {
         return this.FResetCostGold;
      }
      
      public function get ShowAwardVec() : Vector.<int>
      {
         return this.FShowAwardVec;
      }
      
      public function get RandomPropsIndex() : int
      {
         return this.FRandomPropsIndex;
      }
      
      public function get FavourValue() : int
      {
         return this.FFavourValue;
      }
      
      public function get SendPacketPrompt() : String
      {
         return this.FSendPacketPrompt;
      }
      
      public function get ResetPrompt() : String
      {
         return this.FResetPrompt;
      }
      
      public function get FreeResetPrompt() : String
      {
         return this.FFreeResetPrompt;
      }
      
      public function get FavourPrompt() : String
      {
         return this.FFavourPrompt;
      }
      
      public function get SendRedPacketFinishPrompt() : String
      {
         return this.FSendRedPacketFinishPrompt;
      }
      
      public function get AllServiceIndex() : int
      {
         return this.FAllServiceIndex;
      }
   }
}

