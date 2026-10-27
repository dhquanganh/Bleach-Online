package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TDoubleFishRank;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenPumpkin extends THDActivityBase
   {
      
      protected const MatchPumpkin_Count:uint = 6;
      
      protected var FTaskDescribe:Vector.<Vector.<String>>;
      
      protected var FTaskComTotals:Vector.<Vector.<uint>>;
      
      protected var FTaskIDs:Vector.<Vector.<uint>>;
      
      protected var FTaskIndexCTS:Vector.<Vector.<uint>>;
      
      protected var FTaskComGetMatchCount:Vector.<Vector.<uint>>;
      
      protected var FAllServerRewardID:Vector.<uint>;
      
      protected var FLuckRewardID:Vector.<uint>;
      
      protected var FRankInfo:Array;
      
      protected var FAllServerRewardDescribe:String;
      
      protected var FNeedLightCount:uint;
      
      protected var FNeedMatchToLight:uint;
      
      protected var FPumpkinID:Vector.<uint>;
      
      protected var FMatchGetLight:uint;
      
      protected var FNeedCoinToLight:uint;
      
      protected var FCoinGetLight:uint;
      
      protected var FMatchLightIndex:uint;
      
      protected var FCoinGetLightIndex:uint;
      
      protected var FPumpkinLightIndex:uint;
      
      protected var FAllPumpkinLightIndex:uint;
      
      protected var FServerAwardIndex:uint;
      
      protected var FMatchIndex:uint;
      
      protected var FRankDes:String;
      
      protected var FNeedMatchTip:String;
      
      protected var FNeedCoinTip:String;
      
      protected var FRankList:Vector.<TDoubleFishRank>;
      
      protected var FRankDesc:String;
      
      public function THDHalloweenPumpkin()
      {
         super();
         this.FTaskDescribe = new Vector.<Vector.<String>>();
         this.FTaskIDs = new Vector.<Vector.<uint>>();
         this.FTaskComTotals = new Vector.<Vector.<uint>>();
         this.FTaskIndexCTS = new Vector.<Vector.<uint>>();
         this.FTaskComGetMatchCount = new Vector.<Vector.<uint>>();
         this.FAllServerRewardID = new Vector.<uint>();
         this.FLuckRewardID = new Vector.<uint>();
         this.FPumpkinID = new Vector.<uint>();
         this.FRankInfo = new Array();
         this.FRankList = new Vector.<TDoubleFishRank>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:TDoubleFishRank = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         this.FRankDes = TUtilityString.FetchUTF(param1);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc9_ = TUtilityString.FetchUTF(param1);
         _loc10_ = TUtilityString.FetchUTF(param1);
         this.FPumpkinLightIndex = param1.readInt();
         _loc12_ = TUtilityString.FetchUTF(param1);
         _loc13_ = TUtilityString.FetchUTF(param1);
         this.FMatchIndex = param1.readInt();
         _loc15_ = TUtilityString.FetchUTF(param1);
         this.FAllPumpkinLightIndex = param1.readInt();
         this.FAllServerRewardDescribe = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc8_);
         _loc3_ = _loc4_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.TaskCore(_loc4_[_loc2_],Json.decode(_loc7_),Json.decode(_loc15_));
            _loc2_++;
         }
         this.FRankInfo = Json.decode(_loc6_);
         this.LightUpCore(Json.decode(_loc9_));
         this.GoldLightCore(Json.decode(_loc10_));
         this.ServerAwardCore(Json.decode(_loc12_));
         this.LuckAwardCore(Json.decode(_loc13_));
         _loc3_ = this.FRankInfo.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TDoubleFishRank(this.FRankInfo[_loc2_]);
            this.FRankList[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function TaskCore(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Vector.<uint> = null;
         var _loc12_:Vector.<String> = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:Vector.<uint> = null;
         var _loc15_:Vector.<uint> = null;
         _loc11_ = new Vector.<uint>();
         _loc12_ = new Vector.<String>();
         _loc13_ = new Vector.<uint>();
         _loc14_ = new Vector.<uint>();
         _loc15_ = new Vector.<uint>();
         _loc6_ = param1.length;
         _loc7_ = param2.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = uint(param1[_loc4_]);
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc9_ = param2[_loc5_];
               if(_loc9_.index == _loc8_)
               {
                  break;
               }
               _loc5_++;
            }
            _loc11_.push(_loc9_.index);
            _loc7_ = param3.length;
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc10_ = param3[_loc5_];
               if(_loc9_.type == _loc10_.type)
               {
                  break;
               }
               _loc5_++;
            }
            _loc12_.push(_loc10_.info);
            _loc15_.push(_loc10_.moduleId);
            _loc13_.push(_loc9_.value);
            _loc14_.push(_loc9_.getMatch);
            _loc4_++;
         }
         this.FTaskIndexCTS.push(_loc11_);
         this.FTaskDescribe.push(_loc12_);
         this.FTaskComGetMatchCount.push(_loc14_);
         this.FTaskComTotals.push(_loc13_);
         this.FTaskIDs.push(_loc15_);
      }
      
      protected function LightUpCore(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FMatchLightIndex = param1.index;
         this.FNeedMatchToLight = param1.needMatch;
         this.FMatchGetLight = param1.getLight;
         this.FNeedMatchTip = param1.tip;
         _loc2_ = param1.award;
         _loc5_ = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = _loc2_[_loc4_];
            this.FPumpkinID.push(_loc3_.awardId);
            _loc4_++;
         }
      }
      
      protected function GoldLightCore(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FCoinGetLightIndex = param1.index;
         this.FNeedCoinToLight = param1.gold;
         this.FCoinGetLight = param1.getLight;
         this.FNeedCoinTip = param1.tip;
         _loc2_ = param1.award;
         _loc5_ = _loc2_.length;
         _loc4_ = this.MatchPumpkin_Count;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = _loc2_[_loc4_];
            this.FPumpkinID.push(_loc3_.awardId);
            _loc4_++;
         }
      }
      
      protected function ServerAwardCore(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FServerAwardIndex = param1.index;
         this.FNeedLightCount = param1.condition;
         _loc2_ = param1.award;
         _loc4_ = _loc2_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FAllServerRewardID.push(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function LuckAwardCore(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FLuckRewardID.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get TaskDescribe() : Vector.<Vector.<String>>
      {
         return this.FTaskDescribe;
      }
      
      public function get AllServerRewardID() : Vector.<uint>
      {
         return this.FAllServerRewardID;
      }
      
      public function get LuckRewardID() : Vector.<uint>
      {
         return this.FLuckRewardID;
      }
      
      public function get NeedLightCount() : uint
      {
         return this.FNeedLightCount;
      }
      
      public function get AllServerRewardDescribe() : String
      {
         return this.FAllServerRewardDescribe;
      }
      
      public function get TaskIDs() : Vector.<Vector.<uint>>
      {
         return this.FTaskIDs;
      }
      
      public function get NeedMatchToLight() : uint
      {
         return this.FNeedMatchToLight;
      }
      
      public function get TaskComTotals() : Vector.<Vector.<uint>>
      {
         return this.FTaskComTotals;
      }
      
      public function get MatchLightIndex() : uint
      {
         return this.FMatchLightIndex;
      }
      
      public function get TaskComGetMatchCount() : Vector.<Vector.<uint>>
      {
         return this.FTaskComGetMatchCount;
      }
      
      public function get TaskIndexCTS() : Vector.<Vector.<uint>>
      {
         return this.FTaskIndexCTS;
      }
      
      public function get MatchGetLight() : uint
      {
         return this.FMatchGetLight;
      }
      
      public function get NeedCoinToLight() : uint
      {
         return this.FNeedCoinToLight;
      }
      
      public function get CoinGetLight() : uint
      {
         return this.FCoinGetLight;
      }
      
      public function get CoinGetLightIndex() : uint
      {
         return this.FCoinGetLightIndex;
      }
      
      public function get PumpkinLightIndex() : uint
      {
         return this.FPumpkinLightIndex;
      }
      
      public function get ServerAwardIndex() : uint
      {
         return this.FServerAwardIndex;
      }
      
      public function get MatchIndex() : uint
      {
         return this.FMatchIndex;
      }
      
      public function get PumpkinID() : Vector.<uint>
      {
         return this.FPumpkinID;
      }
      
      public function get AllPumpkinLightIndex() : uint
      {
         return this.FAllPumpkinLightIndex;
      }
      
      public function get RankList() : Vector.<TDoubleFishRank>
      {
         return this.FRankList;
      }
      
      public function get RankDesc() : String
      {
         return this.FRankDesc;
      }
      
      public function get RankDes() : String
      {
         return this.FRankDes;
      }
      
      public function get NeedMatchTip() : String
      {
         return this.FNeedMatchTip;
      }
      
      public function get NeedCoinTip() : String
      {
         return this.FNeedCoinTip;
      }
   }
}

