package Logics.Streamization.VoidSoulWorld
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Logics.VoidSoulWorld.VO.TFormHeroVO;
   import Logics.VoidSoulWorld.VO.TFrontPlayerVO;
   import Logics.VoidSoulWorld.VO.TFrontVO;
   import Logics.VoidSoulWorld.VO.TPlayerHurtVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_VOIDSOULWORLD;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerVoidSoulWorld
   {
      
      protected var FData:TVoidSoulWorldData;
      
      public function TUnstreamizerVoidSoulWorld(param1:TVoidSoulWorldData)
      {
         super();
         this.FData = param1;
      }
      
      protected function UnstreamizerRank(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:UInt64 = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TPlayerHurtVO = null;
         this.FData.HurtRank.length = 0;
         _loc5_ = uint(param1.readShort());
         _loc5_ = Math.min(_loc5_,CONST_VOIDSOULWORLD.COUNT_HurlRank);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new TPlayerHurtVO();
            param1.readInt();
            param1.readInt();
            _loc7_.ServerID = param1.readInt();
            _loc7_.Quality = param1.readInt();
            _loc2_ = uint(param1.readInt());
            _loc3_ = uint(param1.readInt());
            _loc4_ = new UInt64(_loc3_,_loc2_);
            _loc7_.Hurt = _loc4_.ToNumber();
            _loc7_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc7_.ServerName = TUtilityString.FetchUTF(param1);
            param1.readInt();
            param1.readInt();
            this.FData.HurtRank.push(_loc7_);
            _loc6_++;
         }
      }
      
      protected function UnstreamizerHP(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:UInt64 = null;
         _loc2_ = uint(param1.readInt());
         _loc3_ = uint(param1.readInt());
         _loc4_ = new UInt64(_loc3_,_loc2_);
         this.FData.BossHP = _loc4_.ToNumber();
      }
      
      protected function UnstreamizerForm(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TFormHeroVO = null;
         _loc2_ = uint(param1.readShort());
         this.FData.Form.Heros.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = new TFormHeroVO();
            _loc6_.HeroID = param1.readInt();
            _loc6_.Pos = param1.readInt();
            this.FData.Form.Heros.push(_loc6_);
            _loc3_++;
         }
      }
      
      protected function UnstreamizerMyHurt(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:UInt64 = null;
         _loc2_ = param1.readInt();
         _loc3_ = param1.readInt();
         _loc4_ = new UInt64(_loc3_,_loc2_);
         this.FData.MyHurt = _loc4_.ToNumber();
      }
      
      public function InitRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:TFrontVO = null;
         this.FData.SubmitTime = param1.readInt();
         this.FData.DeadTime = param1.readInt();
         this.UnstreamizerHP(param1);
         this.FData.JoinAwardState = param1.readByte();
         this.FData.JoinAwardIndex = param1.readByte();
         this.UnstreamizerMyHurt(param1);
         this.FData.ReportId.length = 0;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = TUtilityString.FetchUTF(param1);
            if(_loc3_ < CONST_VOIDSOULWORLD.COUNT_ReportId)
            {
               this.FData.ReportId.push(_loc4_);
            }
            _loc3_++;
         }
         this.UnstreamizerRank(param1);
         _loc3_ = 0;
         while(_loc3_ < CONST_VOIDSOULWORLD.COUNT_Front)
         {
            _loc5_ = this.FData.Front[_loc3_];
            _loc5_.Players.length = 0;
            _loc3_++;
         }
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FightEnterRet(param1);
            _loc3_++;
         }
         this.UnstreamizerForm(param1);
      }
      
      public function FightEnterRet(param1:ByteArray) : uint
      {
         var _loc2_:TFrontPlayerVO = null;
         var _loc3_:TFrontVO = null;
         _loc2_ = new TFrontPlayerVO();
         _loc2_.HighID = param1.readInt();
         _loc2_.LowID = param1.readInt();
         _loc2_.Team = param1.readByte();
         _loc2_.WarTime = param1.readInt();
         _loc2_.TempleteID = param1.readInt();
         _loc2_.Quality = param1.readInt();
         _loc2_.Name = TUtilityString.FetchUTF(param1);
         _loc3_ = this.FData.Front[_loc2_.Team];
         _loc3_.Players.push(_loc2_);
         return _loc2_.Team;
      }
      
      public function ReviveRet(param1:ByteArray) : void
      {
         this.FData.DeadTime = 0;
      }
      
      public function DeadRet(param1:ByteArray) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TFrontPlayerVO = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TFrontVO = null;
         var _loc9_:UInt64 = null;
         _loc3_ = uint(param1.readInt());
         _loc4_ = uint(param1.readInt());
         if(this.FData.IsMyself(_loc3_,_loc4_))
         {
            this.FData.DeadTime = STimingCore.ServerTick;
         }
         _loc2_ = new Object();
         _loc6_ = 0;
         while(_loc6_ < CONST_VOIDSOULWORLD.COUNT_Front)
         {
            _loc8_ = this.FData.Front[_loc6_];
            _loc5_ = _loc8_.GetPlayerByOnlyID(_loc4_,_loc3_);
            if(_loc5_ != null)
            {
               _loc2_.Index1 = _loc6_;
               _loc2_.Index2 = _loc8_.Players.indexOf(_loc5_);
               _loc8_.Players.splice(_loc2_.Index2,1);
               break;
            }
            _loc6_++;
         }
         _loc3_ = uint(param1.readInt());
         _loc4_ = uint(param1.readInt());
         _loc9_ = new UInt64(_loc4_,_loc3_);
         _loc2_.BossHurt = _loc9_.ToNumber();
         return _loc2_;
      }
      
      public function RankRet(param1:ByteArray) : void
      {
         this.UnstreamizerHP(param1);
         this.UnstreamizerRank(param1);
      }
      
      public function ReportRet(param1:ByteArray) : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(this.FData.ReportId.length == CONST_VOIDSOULWORLD.COUNT_ReportId)
         {
            this.FData.ReportId.pop();
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FData.ReportId.unshift(_loc2_);
         this.UnstreamizerMyHurt(param1);
         _loc3_ = new Object();
         _loc3_.Silver = param1.readUnsignedInt();
         return _loc3_;
      }
      
      public function InfoSubmitRet(param1:ByteArray) : void
      {
         this.FData.SubmitTime = param1.readInt();
         this.UnstreamizerForm(param1);
      }
      
      public function DailyRewardRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData.RewardIndex = param1.readByte();
         this.FData.Form.SpecialHeroID.length = 0;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readInt());
            this.FData.Form.SpecialHeroID.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function JoinAwardRet(param1:ByteArray) : void
      {
         this.FData.JoinAwardState = 1;
      }
      
      public function InitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VoidSoulWorld_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function FightEnterReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VoidSoulWorld_FightEnterReq);
         _loc2_.Data.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function ReviveReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VoidSoulWorld_ReviveReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function InfoSubmitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VoidSoulWorld_InfoSubmitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function DailyRewardReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyActivity_DailyRewardReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function JoinAwardReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VoidSoulWorld_JoinAwardReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function GameStart() : void
      {
         this.FData.HurtRank.length = 0;
         this.FData.ReportId.length = 0;
         this.FData.FullHP();
      }
      
      public function GameOver() : void
      {
         var _loc1_:TFrontVO = null;
         for each(_loc1_ in this.FData.Front)
         {
            _loc1_.Players.length = 0;
         }
         this.FData.DeadTime = 0;
      }
   }
}

