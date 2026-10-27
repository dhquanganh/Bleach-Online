package Processors.Game.Lobby.ActivityManager
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Registries.TRegistryInstance;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityModes;
   import Logics.SLogicsCore;
   import Logics.Streamization.HDActivityMode.TUnstreamizerActivityModes;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyModule;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorActivityManager extends TProcessorLobbyModule
   {
      
      protected static const CONFIGS_ID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ID_Vect;
      
      protected static const CONFIGS_ResourceID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ResourceID_Vect;
      
      protected static const CardinalNumber_ActivityID:uint = 10000;
      
      protected static const ACTIVITY_SECOND_LIST:Vector.<uint> = CONST_ACTIVITY_MODE.ACTIVITY_SECOND_LIST;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const POSITION_ActiveList:uint = CONST_SHORTCUTS.POSITION_ActiveList;
      
      protected static const POSITION_ActiveListSecondary:uint = CONST_SHORTCUTS.POSITION_ActiveListSecondary;
      
      protected static const TYPE_Operate_Collection:int = CONST_ACTIVITY_MODE.TYPE_Operate_Collection;
      
      protected static const TYPE_Operate_Award:int = CONST_ACTIVITY_MODE.TYPE_Operate_Award;
      
      protected static const TYPE_Operate_Buy:int = CONST_ACTIVITY_MODE.TYPE_Operate_Buy;
      
      protected var FIsInit:Boolean;
      
      protected var FHDActivityBin:TBins;
      
      protected var FHDIconBin:TBins;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FUnstreamizerActivityModes:TUnstreamizerActivityModes;
      
      protected var FFixedAwards:Vector.<TFixedAward>;
      
      protected var FUpdateActivityNotification:Function;
      
      protected var FShortcutEffectNotification:Function;
      
      protected var FCDKRetNotification:Function;
      
      protected var FAwardStatusChangeNotify:Function;
      
      protected var FOnActivitiesInitRet:Function;
      
      protected var FOnActivitiesValueChange:Function;
      
      protected var FOnOperateRet:Function;
      
      protected var FIsInitData:Boolean;
      
      protected var FAtomsVectWithCoolingTime:Vector.<TActivityAtoms>;
      
      protected var FListener:TRegistryInstance;
      
      public function TProcessorActivityManager(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FUnstreamizerActivityModes = new TUnstreamizerActivityModes();
         this.FIsInit = false;
         this.FFixedAwards = new Vector.<TFixedAward>();
         this.FIsInitData = false;
         this.FAtomsVectWithCoolingTime = new Vector.<TActivityAtoms>();
         this.FListener = new TRegistryInstance();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInitData)
         {
            this.CheckAtomsCoolingTime();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FHDActivityBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDActivity);
         this.FHDIconBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDIcon);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_LoadActivityInfoRet,this.PacketPerform_SC_LoadActiviesInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_UpdateRet,this.PacketPerform_SC_ActiviesUpdateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_OperateRet,this.PacketPerform_SC_OperateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_CDKRet,this.PerformPacket_SC_CDKRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_AwardStatusChangeNotify,this.PerformPacket_SC_AwardStatusChangeNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_InitRet,this.PerformPacket_SC_ActivitiesInitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Activity_ValueStatusChangeNotify,this.PerformPacket_SC_ValueStatusChangeNotifyRet);
      }
      
      protected function PacketPerform_SC_LoadActiviesInfoRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityAtoms = null;
         _loc2_ = param1.Data;
         if(this.FHDActivityBin == null)
         {
            this.FHDActivityBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDActivity);
         }
         this.FUnstreamizerActivityModes.Unstreamize(_loc2_,this.FActivityModes,this.FHDActivityBin);
         this.UpdateActivityListSecond();
         this.CheckFirstPayState();
         this.CheckRecharge();
         this.CheckSoulBox();
         this.CheckActivityBigTurnTable();
         if(this.FUpdateActivityNotification != null)
         {
            this.FUpdateActivityNotification(this);
         }
         this.UpdateActivitySecondEffect();
         this.SetAtomsCoolingTimeData();
         this.FIsInitData = true;
      }
      
      protected function SetAtomsCoolingTimeData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         _loc2_ = int(this.FAtomsVectWithCoolingTime.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAtomsVectWithCoolingTime[_loc1_] = null;
            _loc1_++;
         }
         this.FAtomsVectWithCoolingTime.length = 0;
         _loc2_ = this.FActivityModes.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityModes.GetActivityAtomsByIndex(_loc1_);
            if(_loc3_.EffectCoolingDown != -1)
            {
               this.FAtomsVectWithCoolingTime.push(_loc3_);
            }
            _loc1_++;
         }
      }
      
      protected function CheckAtomsCoolingTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         _loc2_ = int(this.FAtomsVectWithCoolingTime.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAtomsVectWithCoolingTime[_loc1_];
            if(_loc3_.EffectCoolingDown - STimingCore.ServerTick <= 0)
            {
               _loc3_.Status = Activity_CanReceive;
               this.FShortcutEffectNotification(POSITION_ActiveList,_loc3_.MainType,Boolean(_loc3_.Status));
            }
            else
            {
               _loc3_.Status = Activity_CanNotReceive;
               this.FShortcutEffectNotification(POSITION_ActiveList,_loc3_.MainType,Boolean(_loc3_.Status));
            }
            _loc1_++;
         }
      }
      
      protected function PacketPerform_SC_ActiviesUpdateRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         if(this.FHDActivityBin == null)
         {
            this.FHDActivityBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDActivity);
         }
         this.FUnstreamizerActivityModes.UnstreamizeUpdateActivity(_loc2_,this.FActivityModes,this.FHDActivityBin);
         this.UpdateActivityListSecond();
         this.CheckFirstPayState();
         this.CheckRecharge();
         this.CheckSoulBox();
         this.CheckActivityBigTurnTable();
         if(this.FUpdateActivityNotification != null)
         {
            this.FUpdateActivityNotification(this);
         }
         this.UpdateActivitySecondEffect();
         this.SetAtomsCoolingTimeData();
      }
      
      protected function PacketPerform_SC_OperateRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:TFixedAward = null;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:TActivityAtoms = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         _loc11_ = _loc4_.readUnsignedInt();
         _loc13_ = _loc4_.readUnsignedInt();
         _loc10_ = this.FActivityModes.GetActivityAtomsByIdentifier(_loc11_);
         this.FFixedAwards.length = 0;
         _loc3_ = _loc4_.readShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new Object();
            _loc7_.type = _loc4_.readShort();
            _loc7_.code = _loc4_.readUnsignedInt();
            _loc7_.amount = _loc4_.readUnsignedInt();
            _loc6_ = new TFixedAward(_loc7_);
            this.FFixedAwards.push(_loc6_);
            _loc2_++;
         }
         if(_loc13_ >= TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_30).length || TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_30)[_loc13_] == "")
         {
            _loc9_ = "";
         }
         else
         {
            _loc9_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_30)[_loc13_] + "\n";
         }
         if(this.FFixedAwards.length != 0)
         {
            _loc9_ = this.SetEffectText(this.FFixedAwards,_loc9_);
         }
         if(FOnEffectText != null)
         {
            FOnEffectText(this,_loc9_);
         }
         if(_loc10_ != null)
         {
            this.NotifyListenerOnOperateRet(_loc10_,this.FFixedAwards);
         }
      }
      
      protected function SetEffectText(param1:Vector.<TFixedAward>, param2:String) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TArticle = null;
         var _loc6_:uint = 0;
         _loc4_ = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = CONST_COMMON.RewardIDToTemplateID(param1[_loc3_].Type,param1[_loc3_].Code);
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc6_) as TArticle;
            param2 += _loc5_.Name + "*" + param1[_loc3_].Amount + "\n";
            _loc3_++;
         }
         return param2;
      }
      
      protected function PerformPacket_SC_CDKRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(this.FCDKRetNotification != null)
         {
            this.FCDKRetNotification(this);
         }
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(FOnEffectText != null)
         {
            FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_01));
         }
      }
      
      protected function PerformPacket_SC_ActivitiesInitRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TActivityAtoms = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         _loc4_ = this.FActivityModes.GetActivityAtomsByIdentifier(_loc3_);
         if(!_loc4_)
         {
            return;
         }
         this.NotifyListenerOnActivitiesInitRet(_loc4_,_loc2_);
      }
      
      protected function PerformPacket_SC_ValueStatusChangeNotifyRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TActivityAtoms = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         _loc4_ = this.FActivityModes.GetActivityAtomsByIdentifier(_loc3_);
         if(_loc4_ == null)
         {
            return;
         }
         _loc7_ = _loc2_.readUnsignedShort();
         _loc5_ = new Vector.<int>(_loc7_);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_[_loc6_] = _loc2_.readUnsignedInt();
            _loc6_++;
         }
         this.NotifyListenerOnActivitiesValueChange(_loc4_,_loc5_);
      }
      
      protected function PerformPacket_SC_AwardStatusChangeNotify(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ByteArray = null;
         var _loc9_:uint = 0;
         var _loc10_:TActivityAtoms = null;
         var _loc11_:TActAwardStatusInfo = null;
         _loc8_ = param1.Data;
         _loc3_ = _loc8_.readShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = new TActAwardStatusInfo();
            _loc11_.ID = _loc8_.readUnsignedInt();
            _loc11_.Index = _loc8_.readInt();
            _loc11_.Status = _loc8_.readInt();
            _loc5_ = _loc8_.readShort();
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc11_.Condition.push(_loc8_.readInt());
               _loc4_++;
            }
            _loc7_ = _loc8_.readShort();
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc11_.Strs.push(_loc8_.readUTF());
               _loc6_++;
            }
            _loc10_ = this.FActivityModes.GetActivityAtomsByIdentifier(_loc11_.ID);
            if(_loc10_ == null)
            {
               return;
            }
            if(_loc11_.ID == 14 && _loc10_ == null)
            {
               this.ProcessorOnActiveInfoReq();
               return;
            }
            this.NotifyListenerOnAwardStatusChangeNotify(_loc10_,_loc11_);
            _loc2_++;
         }
      }
      
      protected function ConstructCounterHashMap() : void
      {
      }
      
      protected function ActivityInitReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_InitReq);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function CheckActivityTeamBuy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         var _loc4_:Vector.<TActivityAtoms> = null;
         _loc4_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy);
         _loc2_ = int(_loc4_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc4_[_loc1_].ActivityID == CONST_ACTIVITY_MODE.Activity_TeamBuy)
            {
               this.ActivityInitReq(_loc4_[_loc1_].Identifier);
               break;
            }
            _loc1_++;
         }
      }
      
      protected function CheckActivityBigTurnTable() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         var _loc4_:Vector.<TActivityAtoms> = null;
         _loc4_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BigTurnTable);
         _loc2_ = int(_loc4_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc4_[_loc1_].ActivityID == CONST_ACTIVITY_MODE.Activity_BigTurnTable)
            {
               this.ActivityInitReq(_loc4_[_loc1_].Identifier);
               break;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateActivityListSecond() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         _loc2_ = int(ACTIVITY_SECOND_LIST.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityModes.GetActivityAtomsByActivityID(ACTIVITY_SECOND_LIST[_loc1_]);
            if(_loc3_ != null)
            {
               if(_loc3_.Status == Activity_AlreadyReceive)
               {
                  this.FActivityModes.DeleteByIdentifier(_loc3_.Identifier);
               }
               else if(ACTIVITY_SECOND_LIST[_loc1_] == CONST_ACTIVITY_MODE.Activity_OnlineGiftBag || ACTIVITY_SECOND_LIST[_loc1_] == CONST_ACTIVITY_MODE.Activity_OrderGiftBag)
               {
                  this.ActivityInitReq(_loc3_.Identifier);
               }
            }
            _loc1_++;
         }
      }
      
      protected function CheckFirstPayState() : void
      {
         var _loc1_:TActivityAtoms = null;
         _loc1_ = this.FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FirstPay);
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.Status == Activity_AlreadyReceive)
         {
            this.FActivityModes.DeleteByIdentifier(_loc1_.Identifier);
         }
         else
         {
            this.ActivityInitReq(_loc1_.Identifier);
         }
      }
      
      protected function CheckRecharge() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TActivityAtoms> = null;
         var _loc4_:TActivityAtoms = null;
         _loc3_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Recharge);
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            this.ActivityInitReq(_loc4_.Identifier);
            _loc1_++;
         }
         _loc3_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_MaskFright);
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            this.ActivityInitReq(_loc4_.Identifier);
            _loc1_++;
         }
      }
      
      protected function CheckSoulBox() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TActivityAtoms> = null;
         var _loc4_:TActivityAtoms = null;
         _loc3_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SoulBox);
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            this.ActivityInitReq(_loc4_.Identifier);
            _loc1_++;
         }
      }
      
      protected function UpdateActivitySecondEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         var _loc4_:Vector.<TActivityAtoms> = null;
         _loc4_ = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_ReceivePacks);
         _loc2_ = int(_loc4_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[_loc1_];
            this.ActivityListSecondEffectNotification(_loc3_);
            _loc1_++;
         }
      }
      
      protected function ActivityListSecondEffectNotification(param1:TActivityAtoms) : void
      {
         var _loc2_:Boolean = false;
         if(param1.Status == Activity_CanReceive)
         {
            _loc2_ = true;
         }
         else
         {
            _loc2_ = false;
         }
         this.FShortcutEffectNotification(POSITION_ActiveListSecondary,param1.SecondType,_loc2_);
      }
      
      protected function NotifyListenerOnOperateRet(param1:TActivityAtoms, param2:Vector.<TFixedAward>) : void
      {
         var _loc3_:Object = null;
         _loc3_ = this.FListener.GetInstanceByIdentifier(param1.MainType);
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.OperateRet(param2);
      }
      
      protected function NotifyListenerOnActivitiesValueChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:Object = null;
         _loc3_ = this.FListener.GetInstanceByIdentifier(param1.MainType);
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.ValuesChange(param1,param2);
      }
      
      protected function NotifyListenerOnActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         var _loc3_:Object = null;
         _loc3_ = this.FListener.GetInstanceByIdentifier(param1.MainType);
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.ActivitiesInitRet(param1,param2);
      }
      
      protected function NotifyListenerOnAwardStatusChangeNotify(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:Object = null;
         _loc3_ = this.FListener.GetInstanceByIdentifier(param1.MainType);
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.UpdateActivityChangeState(param1,param2);
      }
      
      public function get UpdateActivityNotification() : Function
      {
         return this.FUpdateActivityNotification;
      }
      
      public function set UpdateActivityNotification(param1:Function) : void
      {
         this.FUpdateActivityNotification = param1;
      }
      
      public function get ShortcutEffectNotification() : Function
      {
         return this.FShortcutEffectNotification;
      }
      
      public function set ShortcutEffectNotification(param1:Function) : void
      {
         this.FShortcutEffectNotification = param1;
      }
      
      public function get CDKRetNotification() : Function
      {
         return this.FCDKRetNotification;
      }
      
      public function set CDKRetNotification(param1:Function) : void
      {
         this.FCDKRetNotification = param1;
      }
      
      public function get AwardStatusChangeNotify() : Function
      {
         return this.FAwardStatusChangeNotify;
      }
      
      public function set AwardStatusChangeNotify(param1:Function) : void
      {
         this.FAwardStatusChangeNotify = param1;
      }
      
      public function get OnActivitiesInitRet() : Function
      {
         return this.FOnActivitiesInitRet;
      }
      
      public function set OnActivitiesInitRet(param1:Function) : void
      {
         this.FOnActivitiesInitRet = param1;
      }
      
      public function get OnActivitiesValueChange() : Function
      {
         return this.FOnActivitiesValueChange;
      }
      
      public function set OnActivitiesValueChange(param1:Function) : void
      {
         this.FOnActivitiesValueChange = param1;
      }
      
      public function get OnOperateRet() : Function
      {
         return this.FOnOperateRet;
      }
      
      public function set OnOperateRet(param1:Function) : void
      {
         this.FOnOperateRet = param1;
      }
      
      public function ProcessorOnActiveInfoReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_LoadActivityInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function GetConfigByActivityNumber(param1:uint) : TDatebaseVO
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TDatebaseVO = null;
         _loc3_ = param1 % CardinalNumber_ActivityID;
         _loc2_ = param1 - _loc3_;
         _loc4_ = CONFIGS_ID_Vect.indexOf(_loc2_);
         _loc2_ = CONFIGS_ResourceID_Vect[_loc4_];
         return SResourcesCore.ResourceBin.GetDatebase(_loc2_,param1);
      }
      
      public function GetActivityAtomsByMainType(param1:uint) : Vector.<TActivityAtoms>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TActivityAtoms> = null;
         var _loc5_:TActivityAtoms = null;
         _loc3_ = this.FActivityModes.Count;
         _loc4_ = new Vector.<TActivityAtoms>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FActivityModes.GetActivityAtomsByIndex(_loc2_);
            if(param1 == _loc5_.MainType)
            {
               _loc4_.push(_loc5_);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function ActivityListEffectNotification(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TActivityAtoms> = null;
         var _loc5_:TActivityAtoms = null;
         var _loc6_:Boolean = false;
         _loc6_ = false;
         _loc4_ = this.FActivityModes.GetActivityAtomsByMainType(param1);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_[_loc2_];
            if(_loc5_.Status >= Activity_CanReceive)
            {
               _loc6_ = true;
               break;
            }
            _loc2_++;
         }
         if(_loc6_)
         {
            this.FShortcutEffectNotification(POSITION_ActiveList,param1,true);
         }
         else
         {
            this.FShortcutEffectNotification(POSITION_ActiveList,param1,false);
         }
      }
      
      public function AddListener(param1:int, param2:Object) : void
      {
         this.FListener.Register(param1,param2);
      }
   }
}

