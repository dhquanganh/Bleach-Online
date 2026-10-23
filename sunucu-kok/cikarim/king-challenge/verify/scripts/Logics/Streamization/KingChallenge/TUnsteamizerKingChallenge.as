package Logics.Streamization.KingChallenge
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Logics.KingChallenge.TBettingInfo;
   import Logics.KingChallenge.TFighterInfo;
   import Logics.KingChallenge.TKingChallenge;
   import Logics.KingChallenge.TPlayerInfo;
   import Logics.KingChallenge.TRankData;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnsteamizerKingChallenge
   {
      
      protected var FData:TKingChallenge;
      
      public function TUnsteamizerKingChallenge(param1:TKingChallenge)
      {
         super();
         this.FData = param1;
      }
      
      public function InitRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPlayerInfo = null;
         this.FData.PlayersInfo.length = 0;
         this.FData.FightsInfo.length = 0;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TPlayerInfo();
            _loc4_.LowId = param1.readUnsignedInt();
            _loc4_.HighId = param1.readUnsignedInt();
            _loc4_.ModelId = param1.readUnsignedInt();
            _loc4_.Power = param1.readUnsignedInt();
            _loc4_.Position = param1.readInt();
            _loc4_.AgentId = param1.readInt();
            _loc4_.ServerId = param1.readInt();
            _loc4_.UserName = param1.readUTF();
            _loc4_.ServerName = param1.readUTF();
            this.FData.PlayersInfo.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function InitReq(param1:uint = 1) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_InitReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function RankRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TRankData = null;
         this.FData.RankData.length = 0;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TRankData();
            _loc4_.LowId = param1.readUnsignedInt();
            _loc4_.HighId = param1.readUnsignedInt();
            _loc4_.AgentId = param1.readInt();
            _loc4_.ServerId = param1.readInt();
            _loc4_.ServerName = param1.readUTF();
            _loc4_.UserName = param1.readUTF();
            _loc4_.Rank = param1.readUnsignedInt();
            _loc4_.Power = param1.readUnsignedInt();
            this.FData.RankData.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function RankReq(param1:uint = 1) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_RankReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function BaseRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBettingInfo = null;
         this.FData.BettingsInfo.length = 0;
         this.FData.SeasonStatus = param1.readUnsignedInt();
         this.FData.FighterStartTime = param1.readUnsignedInt();
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TBettingInfo();
            _loc4_.FighterNum = param1.readUnsignedInt();
            _loc4_.ChooseLowId = param1.readUnsignedInt();
            _loc4_.ChooseHighId = param1.readUnsignedInt();
            _loc4_.WinnerLowId = param1.readUnsignedInt();
            _loc4_.WinnerHighId = param1.readUnsignedInt();
            _loc4_.RewardStatus = param1.readByte();
            if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null)
            {
               _loc4_.AttUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).AttUserInfo;
            }
            if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null)
            {
               _loc4_.DefUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).DefUserInfo;
            }
            _loc4_.AttUserName = param1.readUTF();
            _loc4_.DefUserName = param1.readUTF();
            _loc4_.ChooseName = param1.readUTF();
            if(this.FData.HadBettingInfoById(_loc4_.FighterNum) == false)
            {
               this.FData.BettingsInfo.push(_loc4_);
            }
            _loc3_++;
         }
         this.FData.UserBaseInfo.Group = param1.readUnsignedByte() * 1000;
         this.FData.UserBaseInfo.Permission = param1.readBoolean();
         this.FData.UserBaseInfo.Rank = param1.readByte();
         this.FData.UserBaseInfo.AwardStatus = param1.readByte();
      }
      
      public function BaseReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_InitFightReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function FightRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TFighterInfo = null;
         var _loc5_:TFighterInfo = null;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TFighterInfo();
            _loc4_.FightNum = param1.readInt();
            _loc4_.AttUserLowId = param1.readUnsignedInt();
            _loc4_.AttUserHighId = param1.readUnsignedInt();
            _loc4_.DefUserLowId = param1.readUnsignedInt();
            _loc4_.DefUserHighId = param1.readUnsignedInt();
            _loc4_.AttUserInfo = this.FData.FindPlayerInfoById(_loc4_.AttUserLowId,_loc4_.AttUserHighId);
            _loc4_.DefUserInfo = this.FData.FindPlayerInfoById(_loc4_.DefUserLowId,_loc4_.DefUserHighId);
            _loc4_.Ret = param1.readByte();
            _loc4_.Report = param1.readUTF();
            _loc4_.GambleTimeEnd = this.FData.FighterStartTime;
            if(this.FData.HadFightInfoById(_loc4_.FightNum) == false)
            {
               this.FData.FightsInfo.push(_loc4_);
            }
            else
            {
               this.FData.SetFightInfoById(_loc4_.FightNum,_loc4_);
            }
            _loc3_++;
         }
         if(param1.bytesAvailable >= 4)
         {
            var roundStart:uint = param1.readUnsignedInt();
            for each(var fight:TFighterInfo in this.FData.FightsInfo)
            {
               fight.GambleTimeEnd = roundStart + (fight.FightNum % 1000 < 4 ? 0 : (fight.FightNum % 1000 < 6 ? 300 : 600));
            }
         }
         this.BaseReq();
      }
      
      public function FightReq(param1:uint = 1) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         _loc2_ = 1;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_FightReq);
            _loc4_.Data.writeInt(param1 >= 1000 ? param1 / 1000 : param1);
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
            _loc3_++;
         }
      }
      
      public function BettingRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBettingInfo = null;
         this.FData.BettingsInfo.length = 0;
         _loc2_ = uint(param1.readShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TBettingInfo();
            _loc4_.FighterNum = param1.readUnsignedInt();
            _loc4_.ChooseLowId = param1.readUnsignedInt();
            _loc4_.ChooseHighId = param1.readUnsignedInt();
            _loc4_.WinnerLowId = param1.readUnsignedInt();
            _loc4_.WinnerHighId = param1.readUnsignedInt();
            _loc4_.RewardStatus = param1.readByte();
            if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null)
            {
               _loc4_.AttUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).AttUserInfo;
            }
            if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null)
            {
               _loc4_.DefUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).DefUserInfo;
            }
            _loc4_.AttUserName = param1.readUTF();
            _loc4_.DefUserName = param1.readUTF();
            _loc4_.ChooseName = param1.readUTF();
            this.FData.BettingsInfo.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

