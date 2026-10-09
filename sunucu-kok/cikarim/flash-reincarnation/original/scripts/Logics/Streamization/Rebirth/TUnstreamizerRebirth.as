package Logics.Streamization.Rebirth
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventories;
   import Logics.Rebirth.TRebirthData;
   import Logics.Rebirth.VO.TRebirthConfigValueVO;
   import Logics.SLogicsCore;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRebirth
   {
      
      protected var FData:TRebirthData;
      
      public function TUnstreamizerRebirth(param1:TRebirthData)
      {
         super();
         this.FData = param1;
      }
      
      public function UnstreamizerConfig() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TRebirthConfigValueVO = null;
         var _loc4_:TRewards = null;
         var _loc5_:TInventories = null;
         var _loc6_:Object = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = this.FData.ConfigValueVO;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_NeedLevel) as TConfigValue;
         _loc3_.RebirthNeedLevel = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_ReduceLevel) as TConfigValue;
         _loc3_.ReduceExp = _loc2_.Value as Vector.<Object>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RebirthStoneID) as TConfigValue;
         _loc3_.RebirthStoneID = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_SoulStoneCost) as TConfigValue;
         _loc3_.SoulStoneCost = _loc2_.Value;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RefineSoulStoneCost) as TConfigValue;
         _loc3_.RefineSoulStoneCost = _loc2_.Value;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_SuperPropCost) as TConfigValue;
         _loc3_.SuperPropCost = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_ExpBook) as TConfigValue;
         _loc4_ = new TRewards(Vector.<Object>([_loc2_.Value]));
         _loc5_ = new TInventories();
         SToolReward.CreateRewardInventoryByRewardInfor(_loc4_,_loc5_);
         _loc3_.ExpBook = _loc5_.GetInventoryByIndex(0);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_DailyBuyExpBookCost) as TConfigValue;
         _loc3_.DailyBuyExpBookCost = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RebirthCostCount) as TConfigValue;
         _loc3_.RebirthCostCount = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RebirthEffectID) as TConfigValue;
         _loc3_.RebirthEffectID = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_PropPowerBaseID) as TConfigValue;
         _loc3_.PropPowerBaseID = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_AttEffectBaseID) as TConfigValue;
         _loc3_.AttEffectBaseID = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_AttEffectOpenZone) as TConfigValue;
         _loc3_.AttEffectOpenZone = new Vector.<Array>();
         for each(_loc6_ in _loc2_.Value)
         {
            _loc3_.AttEffectOpenZone.push(_loc6_ as Array);
         }
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_MaxRebirthNum) as TConfigValue;
         _loc3_.MaxRebirthNum = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_PropPowerZone) as TConfigValue;
         _loc3_.PropPowerZone = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_PropPowerZone) as TConfigValue;
         _loc3_.ExpBookID = int(_loc2_.Value);
      }
      
      public function RebirthRet(param1:ByteArray) : int
      {
         var _loc2_:THero = null;
         _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.readInt());
         _loc2_.PropPower = param1.readInt();
         _loc2_.AttackEffect = param1.readInt();
         _loc2_.HistoryMaxLevel = Math.max(_loc2_.HistoryMaxLevel,_loc2_.RebirthLevel);
         _loc2_.RebirthLevel = this.FData.GetAfterLevel(_loc2_);
         ++_loc2_.RebirthNum;
         _loc2_.Experience.High = 0;
         _loc2_.Experience.Low = 0;
         return _loc2_.Identifier;
      }
      
      public function ResetRet(param1:ByteArray) : Object
      {
         var _loc2_:THero = null;
         var _loc3_:Object = null;
         _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.readInt());
         _loc2_.PropPower = param1.readInt();
         _loc2_.AttackEffect = param1.readInt();
         _loc3_ = {};
         _loc3_.Attr = param1.readByte();
         _loc3_.Effect = param1.readByte();
         _loc3_.HeroID = _loc2_.Identifier;
         return _loc3_;
      }
      
      public function GetExpBookRet(param1:ByteArray) : int
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.readByte());
         if(_loc2_ == 0)
         {
            this.FData.GetBook = true;
         }
         return _loc2_;
      }
      
      public function InitRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.readByte());
         if(_loc2_ == 1)
         {
            this.FData.GetBook = true;
         }
         else
         {
            this.FData.GetBook = false;
         }
      }
      
      public function RebirthReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Rebirth_RebirthReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function ResetReq(param1:uint, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:TPacket = null;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Rebirth_ResetReq);
         _loc5_.Data.writeInt(param1);
         _loc5_.Data.writeByte(param2);
         _loc5_.Data.writeByte(param3);
         _loc5_.Data.writeByte(param4);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      public function GetExpBookReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Rebirth_GetExpBookReq);
         _loc2_.Data.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Rebirth_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

