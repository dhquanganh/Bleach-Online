package Logics.Streamization.BleachAgent
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.BleachAgent.VO.TBleachAgentConfigValueVO;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerBleachAgent
   {
      
      public const AwardType_Daily:uint = 0;
      
      public const AwardType_Week:uint = 1;
      
      public const AwardType_First:uint = 2;
      
      public const AwardType_Renewal:uint = 3;
      
      public const BuyType_Recharge:uint = 0;
      
      public const BuyType_Renewal:uint = 1;
      
      protected var FData:TBleachAgentData;
      
      public function TUnstreamizerBleachAgent(param1:TBleachAgentData)
      {
         super();
         this.FData = param1;
      }
      
      public function UnstreamizerConfig() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TBleachAgentConfigValueVO = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:uint = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = this.FData.ConfigValueVO;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_Price) as TConfigValue;
         _loc4_ = _loc2_.Value as Vector.<uint>;
         _loc3_.Original = _loc4_[0];
         _loc3_.Discount = _loc4_[1];
         _loc3_.Renewal = _loc4_[2];
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_Day) as TConfigValue;
         _loc3_.TotalTime = int(_loc2_.Value) * 24 * 60 * 60;
         _loc3_.EnjoyDay = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_FirstReward) as TConfigValue;
         _loc5_ = uint(int(_loc2_.Value));
         SToolReward.GetAwardsByAwardID(_loc5_,_loc3_.FirstReward);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_DailyReward) as TConfigValue;
         _loc5_ = uint(int(_loc2_.Value));
         SToolReward.GetAwardsByAwardID(_loc5_,_loc3_.DailyReward);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_WeekReward) as TConfigValue;
         _loc5_ = uint(int(_loc2_.Value));
         SToolReward.GetAwardsByAwardID(_loc5_,_loc3_.WeeklyReward);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_RenewalReward) as TConfigValue;
         _loc5_ = uint(int(_loc2_.Value));
         SToolReward.GetAwardsByAwardID(_loc5_,_loc3_.RenewReward);
      }
      
      protected function Core(param1:uint, param2:int) : void
      {
         switch(param1)
         {
            case this.AwardType_Daily:
               this.FData.DailyRewardState = param2;
               break;
            case this.AwardType_Week:
               this.FData.WeeklyRewardState = param2;
               break;
            case this.AwardType_First:
               this.FData.FirstRewardState = param2;
               break;
            case this.AwardType_Renewal:
               this.FData.RenewRewardState = param2;
         }
      }
      
      public function InitRet(param1:ByteArray) : void
      {
         this.Core(this.AwardType_Daily,param1.readInt());
         this.Core(this.AwardType_Week,param1.readInt());
         this.Core(this.AwardType_First,param1.readInt());
         this.Core(this.AwardType_Renewal,param1.readInt());
      }
      
      public function UpdateRet(param1:ByteArray) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readInt();
         this.Core(_loc2_,_loc3_);
         return _loc3_ == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      }
      
      public function BuyRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedInt();
         this.FData.TimeStamp = _loc3_;
         this.FData.Open = true;
         if(_loc2_ == this.BuyType_Recharge)
         {
            this.FData.UpdateCountForTotal();
         }
         this.FData.CurIsBuyState = false;
      }
      
      public function ExpireRet(param1:ByteArray) : void
      {
         this.FData.Open = false;
      }
      
      public function CharInfoNtf(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         this.FData.CurIsBuyState = !Boolean(param1.readInt());
         _loc2_ = param1.readInt();
         _loc3_ = param1.readInt();
         this.FData.Open = Boolean(_loc2_);
         if(_loc2_ == 1)
         {
            this.FData.TimeStamp = _loc3_;
         }
         else
         {
            this.FData.TimeStamp = 0;
         }
         _loc4_ = uint(this.FData.WelfareType_SignCout);
         while(_loc4_ <= this.FData.WelfareType_DayHellButterflyCount)
         {
            _loc5_ = param1.readInt();
            if(_loc2_)
            {
               this.FData.SetWelfareCountByType(_loc4_,_loc5_);
            }
            _loc4_++;
         }
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachAgent_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function UpdateReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachAgent_UpdateReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function BuyReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachAgent_BuyReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
   }
}

