package Processors.Game.Lobby.Counter
{
   import Foundation.Container.*;
   import Foundation.Network.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Signals.*;
   import Processors.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorCounter extends TProcessorGame
   {
      
      public static const SIGNALDESTINATIONS_COUNTER_REQ:Vector.<uint> = CONST_SIGNAL.SIGNALDESTINATIONS_COUNTER;
      
      public static const SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret;
      
      public static const SIGNALDESTINATION_COUNTER_VIP_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_VIP_Ret;
      
      public static const SIGNALDESTINATION_COUNTER_MilitaryOrdersLimit_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_MilitaryOrdersLimit_Ret;
      
      public static const SIGNALDESTINATION_COUNTER_HELLBUTTERFLY_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_HELLBUTTERFLY_Ret;
      
      public static const SIGNALDESTINATION_COUNTER_HeroSlotNum_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_HeroSlotNum_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_PurpleNinja_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_PurpleNinja_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_GoldNinja_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_GoldNinja_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_SuperNinja_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_SuperNinja_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_Equipment_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_Equipment_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_Talisman_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_Talisman_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_Jade_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_Jade_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_RechargeDetail_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_RechargeDetail_Ret;
      
      public static const SIGNALDESTINATION_ACTIVE_AddConsume_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_ACTIVE_AddConsume_Ret;
      
      public static const SIGNALDESTINATION_COUNTER_OrgDailyDonate_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_OrgDailyDonate_Ret;
      
      public static const KEY_CopyNum:uint = CONST_COUNTER.KEY_CopyNum;
      
      public static const KEY_BuyCopyNum:uint = CONST_COUNTER.KEY_BuyCopyNum;
      
      public static const KEY_CanCopyCount:uint = CONST_COUNTER.KEY_CanCopyCount;
      
      public static const KEY_CopyEndTime:uint = CONST_COUNTER.KEY_CopyEndTime;
      
      public static const KEY_EFL_CopyHereID:uint = CONST_COUNTER.KEY_EFL_CopyHereID;
      
      public static const KEY_CopyHeroCardID:uint = CONST_COUNTER.KEY_CopyHeroCardID;
      
      public static const KEY_VIP_ReceiveState:uint = CONST_COUNTER.KEY_VIP_ReceiveState;
      
      public static const KEY_COUNTER_MilitaryOrdersLimit:uint = CONST_COUNTER.KEY_COUNTER_MilitaryOrdersLimit;
      
      public static const KEY_HELLBUTTERFLY_COMMUNICATION:uint = CONST_COUNTER.KEY_HELLBUTTERFLY_COMMUNICATION;
      
      public static const KEY_HELLBUTTERFLY_EAT:uint = CONST_COUNTER.KEY_HELLBUTTERFLY_EAT;
      
      public static const KEY_HELLBUTTERFLY_CD:uint = CONST_COUNTER.KEY_HELLBUTTERFLY_CD;
      
      public static const KEY_PurpleNinja_lv30:uint = CONST_COUNTER.KEY_PurpleNinja_lv30;
      
      public static const KEY_PurpleNinja_lv50:uint = CONST_COUNTER.KEY_PurpleNinja_lv50;
      
      public static const KEY_GoldNinja:uint = CONST_COUNTER.KEY_GoldNinja;
      
      public static const KEY_AdvanceGoldNinja:uint = CONST_COUNTER.KEY_AdvanceGoldNinja;
      
      public static const KEY_AdvancePurpleNinja:uint = CONST_COUNTER.KEY_AdvancePurpleNinja;
      
      public static const KEY_Equipment_Lv30:uint = CONST_COUNTER.KEY_Equipment_Lv30;
      
      public static const KEY_Equipment_Lv50:uint = CONST_COUNTER.KEY_Equipment_Lv50;
      
      public static const KEY_Talisman_Power:uint = CONST_COUNTER.KEY_Talisman_Power;
      
      public static const KEY_Talisman_Intellect:uint = CONST_COUNTER.KEY_Talisman_Intellect;
      
      public static const KEY_Talisman_Life:uint = CONST_COUNTER.KEY_Talisman_Life;
      
      public static const KEY_Talisman_Agility:uint = CONST_COUNTER.KEY_Talisman_Agility;
      
      public static const KEY_Jade_Lv3:uint = CONST_COUNTER.KEY_Jade_Lv3;
      
      public static const KEY_Jade_Lv4:uint = CONST_COUNTER.KEY_Jade_Lv4;
      
      public static const KEY_Jade_Lv5:uint = CONST_COUNTER.KEY_Jade_Lv5;
      
      public static const KEY_Jade_Lv6:uint = CONST_COUNTER.KEY_Jade_Lv6;
      
      public static const KEY_Recharge:uint = CONST_COUNTER.KEY_Recharge;
      
      public static const KEY_AddConsume:uint = CONST_COUNTER.KEY_AddConsume;
      
      public static const KEY_FirstRecharge:uint = CONST_COUNTER.KEY_FirstRecharge;
      
      public static const KEY_OrgDailyDonate:uint = CONST_COUNTER.KEY_OrgDailyDonate;
      
      public static const KEY_AddHeroSlotNum:uint = CONST_COUNTER.KEY_AddHeroSlotNum;
      
      protected var FCounterHashMap:THashMap;
      
      protected var FLimitHashMap:THashMap;
      
      public function TProcessorCounter(param1:TUIComponent)
      {
         super(param1);
         this.ConstructCounterHashMap();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Counter_CounterRet,this.PacketPerform_SC_CounterRet);
      }
      
      protected function PacketPerform_SC_CounterRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc4_ = param1.Data;
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_.readUnsignedInt();
            _loc7_ = _loc4_.readUnsignedInt();
            this.FLimitHashMap.Put(_loc6_,_loc7_);
            _loc5_ = uint(this.FCounterHashMap.GetValue(_loc6_));
            SLogicsCore.SignalPost(_loc5_,_loc6_,_loc7_);
            _loc2_++;
         }
      }
      
      protected function ConstructCounterHashMap() : void
      {
         this.FCounterHashMap = new THashMap();
         this.FLimitHashMap = SLogicsCore.CounterLimit;
         this.FCounterHashMap.Put(KEY_CopyNum,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_BuyCopyNum,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_CanCopyCount,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_CopyEndTime,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_EFL_CopyHereID,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_CopyHeroCardID,SIGNALDESTINATION_COUNTER_CopyClassRoom_Ret);
         this.FCounterHashMap.Put(KEY_VIP_ReceiveState,SIGNALDESTINATION_COUNTER_VIP_Ret);
         this.FCounterHashMap.Put(KEY_COUNTER_MilitaryOrdersLimit,SIGNALDESTINATION_COUNTER_MilitaryOrdersLimit_Ret);
         this.FCounterHashMap.Put(KEY_HELLBUTTERFLY_COMMUNICATION,SIGNALDESTINATION_COUNTER_HELLBUTTERFLY_Ret);
         this.FCounterHashMap.Put(KEY_HELLBUTTERFLY_EAT,SIGNALDESTINATION_COUNTER_HELLBUTTERFLY_Ret);
         this.FCounterHashMap.Put(KEY_HELLBUTTERFLY_CD,SIGNALDESTINATION_COUNTER_HELLBUTTERFLY_Ret);
         this.FCounterHashMap.Put(KEY_AddHeroSlotNum,SIGNALDESTINATION_COUNTER_HeroSlotNum_Ret);
         this.FCounterHashMap.Put(KEY_PurpleNinja_lv30,SIGNALDESTINATION_ACTIVE_PurpleNinja_Ret);
         this.FCounterHashMap.Put(KEY_PurpleNinja_lv50,SIGNALDESTINATION_ACTIVE_PurpleNinja_Ret);
         this.FCounterHashMap.Put(KEY_GoldNinja,SIGNALDESTINATION_ACTIVE_GoldNinja_Ret);
         this.FCounterHashMap.Put(KEY_AdvanceGoldNinja,SIGNALDESTINATION_ACTIVE_SuperNinja_Ret);
         this.FCounterHashMap.Put(KEY_AdvancePurpleNinja,SIGNALDESTINATION_ACTIVE_SuperNinja_Ret);
         this.FCounterHashMap.Put(KEY_Equipment_Lv30,SIGNALDESTINATION_ACTIVE_Equipment_Ret);
         this.FCounterHashMap.Put(KEY_Equipment_Lv50,SIGNALDESTINATION_ACTIVE_Equipment_Ret);
         this.FCounterHashMap.Put(KEY_Talisman_Power,SIGNALDESTINATION_ACTIVE_Talisman_Ret);
         this.FCounterHashMap.Put(KEY_Talisman_Intellect,SIGNALDESTINATION_ACTIVE_Talisman_Ret);
         this.FCounterHashMap.Put(KEY_Talisman_Life,SIGNALDESTINATION_ACTIVE_Talisman_Ret);
         this.FCounterHashMap.Put(KEY_Talisman_Agility,SIGNALDESTINATION_ACTIVE_Talisman_Ret);
         this.FCounterHashMap.Put(KEY_Jade_Lv3,SIGNALDESTINATION_ACTIVE_Jade_Ret);
         this.FCounterHashMap.Put(KEY_Jade_Lv4,SIGNALDESTINATION_ACTIVE_Jade_Ret);
         this.FCounterHashMap.Put(KEY_Jade_Lv5,SIGNALDESTINATION_ACTIVE_Jade_Ret);
         this.FCounterHashMap.Put(KEY_Jade_Lv6,SIGNALDESTINATION_ACTIVE_Jade_Ret);
         this.FCounterHashMap.Put(KEY_Recharge,SIGNALDESTINATION_ACTIVE_RechargeDetail_Ret);
         this.FCounterHashMap.Put(KEY_AddConsume,SIGNALDESTINATION_ACTIVE_AddConsume_Ret);
         this.FCounterHashMap.Put(KEY_FirstRecharge,SIGNALDESTINATION_ACTIVE_RechargeDetail_Ret);
         this.FCounterHashMap.Put(KEY_OrgDailyDonate,SIGNALDESTINATION_COUNTER_OrgDailyDonate_Ret);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_CounterReqSignals();
      }
      
      protected function LogicsPerform_CounterReqSignals() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSignal = null;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<uint> = null;
         _loc2_ = int(SIGNALDESTINATIONS_COUNTER_REQ.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = SIGNALDESTINATIONS_COUNTER_REQ[_loc1_];
            _loc3_ = SLogicsCore.SignalRetrieve(_loc4_);
            if(_loc3_ != null)
            {
               _loc5_ = _loc3_.UserData as Vector.<uint>;
               this.Perform_CS_LimitListReq(_loc5_);
            }
            _loc1_++;
         }
      }
      
      protected function Perform_CS_LimitListReq(param1:Vector.<uint>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:uint = 0;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Counter_CounterReq);
         _loc5_ = _loc4_.Data;
         _loc3_ = int(param1.length);
         _loc5_.writeShort(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1.shift();
            _loc5_.writeUnsignedInt(_loc6_);
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         param1.length = 0;
      }
   }
}

