package Logics.Streamization.ExpDuplicate
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TExpDuplicate;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.ExpDuplicate.VO.TExpDupConfigValueVO;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerExpDuplicate
   {
      
      protected var FData:TExpDuplicateData;
      
      protected var FRebirthData:TRebirthData;
      
      public function TUnstreamizerExpDuplicate(param1:TExpDuplicateData)
      {
         super();
         this.FData = param1;
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      protected function GetExp(param1:TDuplicateVO) : Number
      {
         var _loc2_:uint = 0;
         var _loc3_:UInt64 = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:THeroExp = null;
         _loc2_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,_loc2_) as THeroExp;
         _loc3_ = this.FRebirthData.CalNeedExpByUInt64(_loc7_.NeedExp,SLogicsCore.Character.GetMainHero().RebirthNum);
         _loc4_ = uint(SLogicsCore.Character.VipLevel);
         _loc5_ = this.FData.ConfigValueVO.NumVipBase + _loc4_ * this.FData.ConfigValueVO.NumVipArg;
         _loc6_ = Math.pow(_loc2_,1.25) + 0.625 * _loc3_.ToNumber() * (_loc5_ + param1.Config.DiffArg) / _loc2_ + 1500 * _loc2_;
         _loc6_ = uint(_loc6_ / 1000) * 1000;
         return Math.floor(_loc6_);
      }
      
      public function UnstreamizerConfig() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TExpDupConfigValueVO = null;
         var _loc4_:TDuplicateVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TExpDuplicate = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = this.FData.ConfigValueVO;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ExpDuplicate_NumVipBase) as TConfigValue;
         _loc3_.NumVipBase = Number(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ExpDuplicate_NumVipArg) as TConfigValue;
         _loc3_.NumVipArg = Number(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ExpDuplicate_RefreshPrice) as TConfigValue;
         _loc3_.RefreshPrice = Vector.<int>(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ExpDuplicate_Times) as TConfigValue;
         _loc3_.BattleCount = int(_loc2_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ExpDuplicate);
         _loc6_ = uint(_loc1_.Count);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc1_.GetDatebaseByIndex(_loc5_) as TExpDuplicate;
            _loc4_ = new TDuplicateVO();
            this.FData.EnemyArmy[_loc5_] = _loc4_;
            _loc4_.Config = _loc7_;
            _loc5_++;
         }
      }
      
      public function InitRet(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TDuplicateVO = null;
         _loc2_ = param1.readInt();
         this.FData.RemainBattle = this.FData.ConfigValueVO.BattleCount - _loc2_;
         _loc4_ = param1.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.readInt();
            _loc6_ = this.FData.EnemyArmy[_loc3_];
            _loc6_.EnemyArmyID = _loc5_;
            _loc6_.IsOpen = SLogicsCore.Character.GetMainLevel() >= _loc6_.Config.LvLimit;
            _loc6_.Exp = this.GetExp(_loc6_);
            _loc3_++;
         }
      }
      
      public function SkillRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDuplicateVO = null;
         var _loc6_:uint = 0;
         _loc2_ = uint(param1.readInt());
         _loc5_ = this.FData.GetVOByID(_loc2_);
         _loc5_.RefreshCount = param1.readInt();
         _loc5_.SkillBuff.length = 0;
         _loc4_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = uint(param1.readInt());
            _loc5_.SkillBuff[_loc3_] = _loc6_;
            _loc3_++;
         }
      }
      
      public function RefreshRet(param1:ByteArray) : void
      {
         this.SkillRet(param1);
      }
      
      public function BattleCountRet(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readInt();
         this.FData.RemainBattle = this.FData.ConfigValueVO.BattleCount - _loc2_;
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ExpDuplicate_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function SkillReq(param1:TDuplicateVO) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ExpDuplicate_SkillReq);
         _loc2_.Data.writeInt(param1.Config.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function RefreshReq(param1:TDuplicateVO) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ExpDuplicate_RefreshReq);
         _loc2_.Data.writeInt(param1.Config.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function BattleReq(param1:TDuplicateVO) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ExpDuplicate_FightReq);
         _loc2_.Data.writeInt(param1.Config.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
   }
}

