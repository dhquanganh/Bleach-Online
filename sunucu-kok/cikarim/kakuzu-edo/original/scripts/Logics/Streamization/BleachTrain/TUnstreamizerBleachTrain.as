package Logics.Streamization.BleachTrain
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Battle.model.*;
   import Logics.BleachDailyRecord.*;
   import Logics.BleachTrain.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerBleachTrain extends TUnstreamizer
   {
      
      public const FormatTabCaption:String = "%0级";
      
      public function TUnstreamizerBleachTrain()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBleachTrainDatas = null;
         var _loc5_:TBleachTrainData = null;
         var _loc6_:TBleachTrainVipBag = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc4_ = param2 as TBleachTrainDatas;
         _loc8_ = int(param1.readUnsignedShort());
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = param1.readUnsignedInt();
            _loc10_ = param1.readUnsignedInt();
            _loc5_ = _loc4_.GetBleachTrainByID(_loc9_);
            _loc5_.IfGotReward = _loc10_ == 1;
            _loc5_.CurrentScheduel = param1.readUnsignedInt();
            _loc5_.IfOpen = true;
            if(_loc5_.IfGotReward)
            {
               _loc5_.IfCanGotReward = false;
            }
            else
            {
               _loc5_.IfCanGotReward = _loc5_.GrowRoadTask.AllNumber <= _loc5_.CurrentScheduel;
            }
            _loc7_++;
         }
         _loc8_ = int(param1.readUnsignedShort());
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc11_ = param1.readUnsignedInt();
            _loc12_ = param1.readUnsignedInt();
            _loc6_ = _loc4_.GetVipBag(_loc11_,_loc12_);
            _loc6_.IfSelled = true;
            _loc7_++;
         }
      }
      
      protected function LevelCompare(param1:int, param2:int) : int
      {
         if(param1 < param2)
         {
            return -1;
         }
         if(param1 > param2)
         {
            return 1;
         }
         return 0;
      }
      
      protected function DispatchTrainInfor(param1:Vector.<TBleachTrainData>, param2:TBleachTrainDatas) : void
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TBleachTrainData = null;
         var _loc9_:String = null;
         _loc3_ = new Vector.<int>();
         _loc7_ = int(param1.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1[_loc6_];
            _loc4_ = _loc8_.GrowRoadTask.Type;
            _loc5_ = _loc3_.indexOf(_loc4_);
            if(_loc5_ == -1)
            {
               _loc3_.push(_loc4_);
            }
            _loc6_++;
         }
         _loc3_.sort(this.LevelCompare);
         param2.LevelNeed = _loc3_;
         _loc7_ = int(_loc3_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = TUtilityString.Format(this.FormatTabCaption,_loc3_[_loc6_]);
            param2.TabNames.push(_loc9_);
            param2.BleachTrainDatas.push(new Vector.<TBleachTrainData>());
            _loc6_++;
         }
         _loc7_ = int(param1.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1[_loc6_];
            _loc4_ = _loc8_.GrowRoadTask.Type;
            _loc5_ = _loc3_.indexOf(_loc4_);
            param2.BleachTrainDatas[_loc5_].push(_loc8_);
            _loc6_++;
         }
      }
      
      protected function CreateVipBagInfor(param1:Vector.<TBleachTrainVipBag>, param2:TGrowRoadGift) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBleachTrainVipBag = null;
         _loc4_ = int(param2.Reward.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TBleachTrainVipBag();
            _loc5_.Icon = param2.ImageIcon[_loc3_];
            _loc5_.VipNeed = param2.VipLimit[_loc3_];
            _loc5_.RewardDiscount = param2.RewardDiscount[_loc3_];
            _loc5_.RewardOriginal = param2.RewardOriginal[_loc3_];
            _loc5_.RewardPrice = param2.RewardPrice[_loc3_];
            _loc5_.AwardID = param2.Reward[_loc3_];
            SToolReward.GetAwardsByAwardID(param2.Reward[_loc3_],_loc5_.Rewards);
            param1.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function UnstreamizationByDataBase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBleachTrainDatas = null;
         var _loc7_:Vector.<TBleachTrainData> = null;
         var _loc8_:TBleachTrainData = null;
         var _loc9_:TBins = null;
         var _loc10_:TBleachTrainVipBag = null;
         var _loc11_:TGrowRoadGift = null;
         _loc6_ = param2 as TBleachTrainDatas;
         _loc7_ = param3 as Vector.<TBleachTrainData>;
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GrowRoadTask);
         _loc5_ = _loc9_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new TBleachTrainData();
            _loc8_.GrowRoadTask = _loc9_.GetDatebaseByIndex(_loc4_) as TGrowRoadTask;
            SToolReward.CreateRewardInventoryByRewardInfor(_loc8_.GrowRoadTask.NormalReward,_loc8_.Rewards);
            SToolReward.CreateRewardInventoryByRewardInfor(_loc8_.GrowRoadTask.VipReward,_loc8_.Rewards);
            _loc7_.push(_loc8_);
            _loc4_++;
         }
         this.DispatchTrainInfor(_loc7_,_loc6_);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GrowRoadGift);
         _loc5_ = _loc9_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc9_.GetDatebaseByIndex(_loc4_) as TGrowRoadGift;
            _loc6_.VipBags.push(new Vector.<TBleachTrainVipBag>());
            _loc6_.BagGroupID.push(_loc11_.Identifier);
            this.CreateVipBagInfor(_loc6_.VipBags[_loc4_],_loc11_);
            _loc4_++;
         }
      }
   }
}

