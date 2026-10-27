package Logics.HDActivityHalloween
{
   import Foundation.Common.THint;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDHalloweenPumpkin;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Log.TLog;
   import Logics.SLogicsCore;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TActivityHalloweenPumpkinData extends TActivityOSBase
   {
      
      protected var FRanks:Vector.<TActivityServerRank>;
      
      protected var FDay:uint;
      
      protected var FConfig:THDHalloweenPumpkin;
      
      protected var FProgress:Array;
      
      protected var FLuckPlayerName:Vector.<String>;
      
      protected var FAllLightCount:uint;
      
      protected var FMyLightCount:uint;
      
      protected var FMatchCount:uint;
      
      protected var FAllServerRewardData:Array;
      
      protected var FLuckRewardData:Array;
      
      protected var FAllServerRewardGet:Boolean;
      
      protected var FLuckRewardGet:Boolean;
      
      protected var FPumpkinReward:int;
      
      protected var FRankValues:Vector.<uint>;
      
      protected var FNeedCoinTipData:THint;
      
      protected var FNeedMatchTipData:THint;
      
      protected var FIsUpdatePackage:Boolean;
      
      protected var FMyRank:int;
      
      protected var FCurOwned:uint;
      
      public function TActivityHalloweenPumpkinData()
      {
         super();
         this.FDay = 0;
         this.FProgress = new Array();
         this.FLuckPlayerName = new Vector.<String>();
         this.FAllServerRewardData = new Array();
         this.FLuckRewardData = new Array();
         this.FLuckPlayerName.push("");
         this.FLuckPlayerName.push("");
         this.FLuckPlayerName.push("");
         this.FRanks = new Vector.<TActivityServerRank>();
         this.FMyRank = -1;
      }
      
      public function get Config() : THDHalloweenPumpkin
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDHalloweenPumpkin) : void
      {
         this.FConfig = param1;
      }
      
      public function get Progress() : Array
      {
         return this.FProgress;
      }
      
      public function set Progress(param1:Array) : void
      {
         this.FProgress = param1;
      }
      
      public function get LuckPlayerName() : Vector.<String>
      {
         return this.FLuckPlayerName;
      }
      
      public function set LuckPlayerName(param1:Vector.<String>) : void
      {
         this.FLuckPlayerName = param1;
      }
      
      public function get MyLightCount() : uint
      {
         return this.FMyLightCount;
      }
      
      public function set MyLightCount(param1:uint) : void
      {
         this.FMyLightCount = param1;
      }
      
      public function get MatchCount() : uint
      {
         return this.FMatchCount;
      }
      
      public function set MatchCount(param1:uint) : void
      {
         this.FMatchCount = param1;
      }
      
      public function get MyRank() : int
      {
         return this.FMyRank;
      }
      
      public function set MyRank(param1:int) : void
      {
         this.FMyRank = param1;
      }
      
      public function get CurOwned() : uint
      {
         return this.FCurOwned;
      }
      
      public function set CurOwned(param1:uint) : void
      {
         this.FCurOwned = param1;
      }
      
      public function get AllServerRewardDescribe() : String
      {
         return this.FConfig.NeedLightCount.toString();
      }
      
      public function get AllServerRewardData() : TInventories
      {
         var _loc1_:TInventories = null;
         if(!this.FAllServerRewardData[this.FDay])
         {
            _loc1_ = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.AllServerRewardID[0],_loc1_);
            this.FAllServerRewardData[this.FDay] = _loc1_;
         }
         return this.FAllServerRewardData[this.FDay];
      }
      
      public function get LuckRewardData() : TInventories
      {
         var _loc1_:TInventories = null;
         if(!this.FLuckRewardData[this.FDay])
         {
            _loc1_ = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.LuckRewardID[this.FDay],_loc1_);
            this.FLuckRewardData[this.FDay] = _loc1_;
         }
         return this.FLuckRewardData[this.FDay];
      }
      
      public function get AllServerRewardGet() : Boolean
      {
         return this.FAllServerRewardGet;
      }
      
      public function set AllServerRewardGet(param1:Boolean) : void
      {
         this.FAllServerRewardGet = param1;
      }
      
      public function get LuckRewardGet() : Boolean
      {
         return this.FLuckRewardGet;
      }
      
      public function set LuckRewardGet(param1:Boolean) : void
      {
         this.FLuckRewardGet = param1;
      }
      
      public function get AllLightCount() : uint
      {
         return this.FAllLightCount;
      }
      
      public function set AllLightCount(param1:uint) : void
      {
         this.FAllLightCount = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get PumpkinReward() : int
      {
         return this.FPumpkinReward;
      }
      
      public function set PumpkinReward(param1:int) : void
      {
         this.FPumpkinReward = param1;
      }
      
      public function get NeedCoinTipData() : THint
      {
         if(this.FNeedCoinTipData == null)
         {
            this.FNeedCoinTipData = new THint();
            this.FNeedCoinTipData.Caption = TUtilityString.Format(this.FConfig.NeedCoinTip,this.FConfig.NeedCoinToLight);
         }
         return this.FNeedCoinTipData;
      }
      
      public function get NeedMatchTipData() : THint
      {
         if(this.FNeedMatchTipData == null)
         {
            this.FNeedMatchTipData = new THint();
            this.FNeedMatchTipData.Caption = TUtilityString.Format(this.FConfig.NeedMatchTip,this.FConfig.NeedMatchToLight);
         }
         return this.FNeedMatchTipData;
      }
      
      public function get AllowGetAllServerReward() : Boolean
      {
         return !this.AllServerRewardGet && this.AllLightCount >= this.FConfig.NeedLightCount;
      }
      
      public function get AllowMatchLight() : Boolean
      {
         return this.MatchCount >= this.FConfig.NeedMatchToLight;
      }
      
      public function get AllowCoinLight() : Boolean
      {
         return SLogicsCore.Character.CreditGold >= this.FConfig.NeedCoinToLight;
      }
      
      public function get TaskCount() : uint
      {
         return this.FConfig.TaskIDs[this.FDay].length;
      }
      
      public function get PumpkinData() : Vector.<uint>
      {
         return this.FConfig.PumpkinID;
      }
      
      public function get RankValues() : Vector.<uint>
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FRankValues == null)
         {
            _loc2_ = this.FConfig.RankList.length;
            this.FRankValues = new Vector.<uint>(_loc2_);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FRankValues[_loc1_] = this.FConfig.RankList[_loc1_].Awards[0];
               _loc1_++;
            }
         }
         return this.FRankValues;
      }
      
      public function get RankCount() : uint
      {
         return this.FRanks.length;
      }
      
      public function get IsUpdatePackage() : Boolean
      {
         return this.FIsUpdatePackage;
      }
      
      public function set IsUpdatePackage(param1:Boolean) : void
      {
         this.FIsUpdatePackage = param1;
      }
      
      public function TaskIsOK(param1:uint) : Boolean
      {
         return this.FProgress[param1] >= this.FConfig.TaskComTotals[this.FDay][param1];
      }
      
      public function SetLuckyPlayer(param1:Vector.<TLog>, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TLog = null;
         _loc4_ = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1[_loc3_];
            if(_loc5_.RecoredTime > param2)
            {
               this.FLuckPlayerName[_loc3_] = _loc5_.Name;
            }
            else
            {
               this.FLuckPlayerName[_loc3_] = "";
            }
            _loc3_++;
         }
      }
      
      public function GetTaskID(param1:uint) : uint
      {
         return this.FConfig.TaskIDs[this.FDay][param1];
      }
      
      public function GetPumpkinIndexByRewardID() : uint
      {
         return this.FConfig.PumpkinID.indexOf(this.FPumpkinReward);
      }
      
      public function GetTaskString(param1:uint, param2:uint) : String
      {
         var _loc3_:String = null;
         if(param2 == 0)
         {
            _loc3_ = this.FConfig.TaskDescribe[this.FDay][param1];
            _loc3_ = TUtilityString.Format(_loc3_,this.FConfig.TaskComTotals[this.FDay][param1]);
         }
         else
         {
            _loc3_ = this.FProgress[param1] + "/" + this.FConfig.TaskComTotals[this.FDay][param1];
         }
         return _loc3_;
      }
      
      public function GetRankByIndex(param1:int) : TActivityServerRank
      {
         if(this.FRanks != null && this.FRanks.length > 0)
         {
            return this.FRanks[param1];
         }
         return null;
      }
      
      public function AddRankItem(param1:TActivityServerRank) : void
      {
         this.FRanks.push(param1);
      }
      
      public function ClearRank() : void
      {
         this.FRanks.length = 0;
      }
   }
}

