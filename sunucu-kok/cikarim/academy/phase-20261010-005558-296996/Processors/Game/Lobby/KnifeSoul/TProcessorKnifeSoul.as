package Processors.Game.Lobby.KnifeSoul
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TKnifeSoul;
   import Logics.KnifeSoul.TKnifeSoulData;
   import Logics.SLogicsCore;
   import Logics.SpiritSchool.TSpiritSchoolData;
   import Logics.Streamization.SpiritSchool.TUnstreamizerSpiritSchool;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_KNIFESOUL;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorKnifeSoul extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDHT:int = 576;
      
      protected static const WINDOW_HEIGHT:int = 440;
      
      protected var FKnifeSoul:TKnifeSoulData;
      
      protected var FSpiritSchoolData:TSpiritSchoolData;
      
      protected var FUnstreamizerSpiritSchool:TUnstreamizerSpiritSchool;
      
      protected var FWindowKnifeSoul:TProcessorWindowKnifeSoul;
      
      protected var FBounds:TBounds;
      
      protected var FOnKnifeChange:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorKnifeSoul(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowKnifeSoul = new TProcessorWindowKnifeSoul(this);
         this.FWindowKnifeSoul.OnHitMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowKnifeSoul.OnHitOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowKnifeSoul.OnEffectText = ProcessorsOnEffectText;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDHT;
         this.FBounds.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowKnifeSoul,this.FBounds);
         this.FBounds = null;
         this.FKnifeSoul = SLogicsCore.Character.KnifeSoul;
         this.FSpiritSchoolData = new TSpiritSchoolData();
         this.FWindowKnifeSoul.Data_School = this.FSpiritSchoolData;
         this.FUnstreamizerSpiritSchool = new TUnstreamizerSpiritSchool();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_KNIFESOUL.RESOURCESID_KNIFESOUL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FWindowKnifeSoul.UIDispatch();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FWindowKnifeSoul.UILocation();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KnifeSoulTrainResponse,this.PerformPacket_SC_TrainKnifeSoul);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KnifeSoulInfoResponse,this.PerformPacket_SC_KnifeSoulInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SpiritSchoolInfoRet,this.PerformPacket_SC_SpiritSchoolInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SpiritSchoolTrainRet,this.PerformPacket_SC_SpiritSchoolTrainRet);
      }
      
      protected function PerformPacket_SC_TrainKnifeSoul(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(this.FKnifeSoul.ID);
         this.FKnifeSoul.ID = _loc3_.readUnsignedInt();
         this.FKnifeSoul.CurrentExp = _loc3_.readUnsignedInt();
         this.FKnifeSoul.SmallCritNum = _loc3_.readUnsignedByte();
         this.FKnifeSoul.BigCritNum = _loc3_.readUnsignedByte();
         this.FKnifeSoul.GainExp = _loc3_.readUnsignedInt();
         _loc5_ = "";
         if(this.FKnifeSoul.SmallCritNum != 0)
         {
            _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_7),this.FKnifeSoul.SmallCritNum);
         }
         if(this.FKnifeSoul.BigCritNum != 0)
         {
            _loc5_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_8),this.FKnifeSoul.BigCritNum);
         }
         _loc5_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_9),this.FKnifeSoul.GainExp);
         if(this.FKnifeSoul.BigCritNum != 0 && this.FKnifeSoul.GainExp == 0)
         {
            _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_8),this.FKnifeSoul.BigCritNum);
         }
         EffectGenerateText(_loc5_);
         if(_loc4_ != this.FKnifeSoul.ID)
         {
            if(this.FUpdateHeroPower != null)
            {
               this.FUpdateHeroPower(this);
            }
         }
         this.FWindowKnifeSoul.Update();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_TrainKnifeSoul);
      }
      
      protected function PerformPacket_SC_KnifeSoulInfo(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TKnifeSoul = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FKnifeSoul.ID = _loc3_.readUnsignedInt();
         this.FKnifeSoul.CurrentExp = _loc3_.readUnsignedInt();
         this.FKnifeSoul.AddedAgile = _loc3_.readUnsignedInt();
         this.FKnifeSoul.AddedPower = _loc3_.readUnsignedInt();
         this.FKnifeSoul.AddedIntelligence = _loc3_.readUnsignedInt();
         this.FKnifeSoul.AddedLife = _loc3_.readUnsignedInt();
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeSoul,this.FKnifeSoul.ID) as TKnifeSoul;
         this.FKnifeSoul.Level = _loc4_.Level;
         this.KnifeInforChanged();
         this.AssginKnifeSoulInfor(this.FKnifeSoul);
         if(this.visible)
         {
            this.FWindowKnifeSoul.Update();
            this.FWindowKnifeSoul.visible = true;
         }
      }
      
      protected function PerformPacket_SC_SpiritSchoolInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param1.Data;
         this.FUnstreamizerSpiritSchool.UnstreamizeUpdateSpiritSchoolInfo(_loc3_,this.FSpiritSchoolData);
         if(this.FWindowKnifeSoul.Visible)
         {
            this.FWindowKnifeSoul.UpdateSchool();
         }
      }
      
      protected function PerformPacket_SC_SpiritSchoolTrainRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.FWindowKnifeSoul.AcademyPending = false;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerSpiritSchool.UnstreamizeUpdateAllItem(_loc3_,this.FSpiritSchoolData);
         _loc7_ = _loc3_.readInt();
         _loc8_ = _loc3_.readInt();
         _loc9_ = _loc3_.readInt();
         if(this.FWindowKnifeSoul.Visible)
         {
            this.FWindowKnifeSoul.UpdateSchool();
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_9),_loc7_));
            if(_loc8_ > 0)
            {
               EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_7),_loc8_));
            }
            if(_loc9_ > 0)
            {
               EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_8),_loc9_));
            }
            if(this.FUpdateHeroPower != null)
            {
               this.FUpdateHeroPower(this);
            }
         }
      }
      
      protected function RequestKnifeBaseInfor_Perform() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeInfoRequest);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function RequestSpiritSchoolInfor_Perform() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SpiritSchoolInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function RequestTrainKnifeSoul_Perform(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeTrainRequest);
         _loc3_.Data.writeUnsignedInt(param1);
         _loc3_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function RequestShowKnifeSoul_Perform(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeSoulShowViewRequest);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function KnifeInforChanged() : void
      {
         if(this.FOnKnifeChange != null)
         {
            this.FOnKnifeChange(this);
         }
      }
      
      protected function AssginKnifeSoulInfor(param1:TKnifeSoulData) : void
      {
         var _loc2_:TKnifeSoul = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeSoul,param1.ID) as TKnifeSoul;
         param1.Power = _loc2_.Power;
         param1.Agile = _loc2_.Agile;
         param1.Intelligence = _loc2_.Intelligence;
         param1.Life = _loc2_.Life;
         param1.NextID = _loc2_.NextID;
         param1.Level = _loc2_.Level;
         param1.NeedExp = _loc2_.NeedExp;
      }
      
      public function set OnKnifeChange(param1:Function) : void
      {
         this.FOnKnifeChange = param1;
      }
      
      override public function set OnClose(param1:Function) : void
      {
         super.OnClose = param1;
         this.FWindowKnifeSoul.OnClose = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowKnifeSoul.Load();
            return;
         }
         this.RequestKnifeBaseInfor_Perform();
         this.RequestSpiritSchoolInfor_Perform();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenKnifeSoul);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FWindowKnifeSoul.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseKnifeSoul);
      }
      
      public function RequestKnifeBaseInfor() : void
      {
         this.RequestKnifeBaseInfor_Perform();
      }
   }
}

