package Processors.Game.Lobby.QianKunARoll
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.InteractionLog.*;
   import Logics.Inventories.*;
   import Logics.Streamization.InteractionLog.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorQianKunARoll extends TProcessorLobbyWindows
   {
      
      protected static const MAX_TabCount:int = 1;
      
      protected static const MAX_RewardBoxCount:int = 3;
      
      protected static const Windows_Width:int = 808;
      
      protected static const Windows_Height:int = 516;
      
      protected var FMC:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FProcessorWindowQianKunARoll:TProcessorWindowQianKunARoll;
      
      protected var FScore:int;
      
      protected var FGambleTimes:int;
      
      protected var FBoxRewardVect:Vector.<int>;
      
      protected var FLogVect:Vector.<Object>;
      
      protected var FInitWindows:Boolean;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInteractionLog:TUnstreamizerInteractionLog;
      
      protected var FUnstreamizerInteractionLogs:TUnstreamizerInteractionLogs;
      
      protected var FInteractionLogs:TInteractionLogs;
      
      public function TProcessorQianKunARoll(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowQianKunARoll = new TProcessorWindowQianKunARoll(this);
         this.FProcessorWindowQianKunARoll.Visible = false;
         this.FProcessorWindowQianKunARoll.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowQianKunARoll.OnStartRoll = this.ProcessorOnStartRoll;
         this.FProcessorWindowQianKunARoll.OnGetBoxReward = this.ProcessorOnGetBox;
         this.FTabIndex = 0;
         this.FBoxRewardVect = new Vector.<int>();
         this.FLogVect = new Vector.<Object>();
         this.FInitWindows = false;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventories = new TInventories();
         this.FUnstreamizerInteractionLog = new TUnstreamizerInteractionLog();
         this.FUnstreamizerInteractionLogs = new TUnstreamizerInteractionLogs();
         this.FInteractionLogs = new TInteractionLogs();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_QIANKUNAROLL.RESOURCESID_Swf_QianKunARoll);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.Init();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_QianKunARoll_InitRet,this.PacketPerform_SC_InitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_QianKunARoll_StartRollRet,this.PacketPerform_SC_StartRollRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_QianKunARoll_GetBoxRet,this.PacketPerform_SC_GetBoxRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_QianKunARoll_LogRet,this.PacketPerform_SC_LogRet);
      }
      
      protected function Init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_QIANKUNAROLL.RESOURCE_ClassName_MC_QianKunARoll) as Sprite;
         addChild(this.FMC);
         this.FMC.x = (CONST_COMMON.STAGE_Width - this.FMC.width) / 2;
         this.FMC.y = (CONST_COMMON.STAGE_Height - this.FMC.height) / 2;
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FUITab = new TUITab(this);
         _loc2_ = MAX_TabCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_Btn_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.ProcessorTabOnSwitch;
         this.FUITab.Init();
         this.FProcessorWindowQianKunARoll.SetUI(this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_MainARoll]);
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,OnClose);
      }
      
      protected function PacketPerform_SC_InitRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FScore = _loc2_.readUnsignedInt();
         this.FGambleTimes = _loc2_.readByte();
         _loc5_ = _loc2_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FBoxRewardVect[_loc4_] = _loc2_.readUnsignedInt();
            _loc4_++;
         }
         this.FUnstreamizerInteractionLogs.Unstreamize(_loc2_,this.FInteractionLogs,12);
         this.FProcessorWindowQianKunARoll.GambleInit(this.FScore,this.FGambleTimes,this.FBoxRewardVect);
         this.FInitWindows = true;
         this.FProcessorWindowQianKunARoll.Visible = true;
         this.FProcessorWindowQianKunARoll.UpdataLog(this.FInteractionLogs);
      }
      
      protected function PacketPerform_SC_StartRollRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readByte();
         this.FProcessorWindowQianKunARoll.ShowDiceMc(_loc4_ == 0 ? false : true);
         this.FProcessorWindowQianKunARoll.AddScore();
         ++this.FGambleTimes;
         this.FProcessorWindowQianKunARoll.UpDataUI(this.FGambleTimes,this.FBoxRewardVect);
      }
      
      protected function PacketPerform_SC_GetBoxRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readByte();
         this.FBoxRewardVect[_loc4_ - 1] = 1;
         this.FProcessorWindowQianKunARoll.UpDataUI(this.FGambleTimes,this.FBoxRewardVect);
         _loc6_ = new Vector.<uint>();
         _loc7_ = new Vector.<int>();
         _loc5_ = _loc2_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = uint(_loc2_.readShort());
            _loc11_ = uint(_loc2_.readUnsignedInt());
            _loc7_.push(_loc2_.readUnsignedInt());
            _loc8_ = CONST_COMMON.RewardIDToTemplateID(_loc10_,_loc11_);
            if(_loc8_ > 0)
            {
               _loc6_.push(_loc8_);
            }
            else
            {
               _loc6_.push(_loc11_);
            }
            _loc4_++;
         }
         this.FInventories.Clear();
         if(_loc6_.length > 0)
         {
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc6_);
         }
         _loc9_ = "";
         if(FOnEffectText != null)
         {
            _loc5_ = this.FInventories.Count;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_ += this.FInventories.GetInventoryByIndex(_loc4_).Name.toString() + "*" + _loc7_[_loc4_] + "\n";
               _loc4_++;
            }
            FOnEffectText(this,_loc9_);
         }
      }
      
      protected function PacketPerform_SC_LogRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:TInteractionLog = null;
         _loc2_ = param1.Data;
         _loc3_ = SLogicsCore.PoolInteractionLog.Acquire();
         this.FUnstreamizerInteractionLog.Unstreamize(_loc2_,_loc3_,null);
         this.FInteractionLogs.Add(_loc3_);
         this.FInteractionLogs.Sort();
         if(this.FProcessorWindowQianKunARoll.Visible)
         {
            this.FProcessorWindowQianKunARoll.UpdataLog(this.FInteractionLogs);
         }
      }
      
      protected function ProcessorOnStartRoll(param1:Object, param2:int, param3:int) : void
      {
         this.PacketPerform_SC_StartRollReq(param2,param3);
      }
      
      protected function ProcessorOnGetBox(param1:Object, param2:int) : void
      {
         this.PacketPerform_SC_GetBoxReq(param2);
      }
      
      protected function PacketPerform_SC_InitReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_QianKunARoll_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PacketPerform_SC_StartRollReq(param1:int, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_QianKunARoll_StartRollReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeByte(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function PacketPerform_SC_GetBoxReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_QianKunARoll_GetBoxReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorTabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         if(this.FTabIndex == _loc2_)
         {
            return;
         }
         this.FTabIndex = _loc2_;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowQianKunARoll.Load();
            return;
         }
         if(!this.FInitWindows)
         {
            this.PacketPerform_SC_InitReq();
            return;
         }
         this.FProcessorWindowQianKunARoll.Mount();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function ResetData() : void
      {
         this.FProcessorWindowQianKunARoll.ResetData();
      }
   }
}

