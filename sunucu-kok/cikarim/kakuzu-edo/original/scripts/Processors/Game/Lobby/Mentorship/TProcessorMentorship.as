package Processors.Game.Lobby.Mentorship
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.InteractionLog.*;
   import Logics.Mentorship.*;
   import Logics.Mentorship.Elements.*;
   import Logics.Streamization.InteractionLog.*;
   import Logics.Streamization.Mentorship.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HelpTips.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorMentorship extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowMentorship_Width:uint = 684;
      
      protected static const SIZE_WindowMentorship_Height:uint = 474;
      
      protected static const SIZE_WindowArrest_Width:uint = 490;
      
      protected static const SIZE_WindowArrest_Height:uint = 438;
      
      protected static const SIZE_WindowInteraction_Width:uint = 410;
      
      protected static const SIZE_WindowInteraction_Height:uint = 268;
      
      protected static const SIZE_WindowRescue_Width:uint = 490;
      
      protected static const SIZE_WindowRescue_Height:uint = 438;
      
      protected static const ERROR_LevelOverstep:int = 1;
      
      protected const CAPACITY_InteractionLogs:uint = 15;
      
      protected var FProcessorWindowMentorship:TProcessorWindowMentorship;
      
      protected var FProcessorWindowArrest:TProcessorWindowArrest;
      
      protected var FProcessorWindowInteraction:TProcessorWindowInteraction;
      
      protected var FProcessorWindowRescue:TProcessorWindowRescue;
      
      protected var FMentorshipBounds:TBounds;
      
      protected var FArrestBounds:TBounds;
      
      protected var FInteractionBounds:TBounds;
      
      protected var FRescueBounds:TBounds;
      
      protected var FMentorship:TMentorship;
      
      protected var FArrest:TArrest;
      
      protected var FRescue:TRescue;
      
      protected var FSOS:TSOS;
      
      protected var FDisciple:TDisciple;
      
      protected var FInteractionLogs:TInteractionLogs;
      
      protected var FUnstreamizerMentorship:TUnstreamizerMentorship;
      
      protected var FUnstreamizerArrest:TUnstreamizerArrest;
      
      protected var FUnstreamizerRescue:TUnstreamizerRescue;
      
      protected var FUnstreamizerSOS:TUnstreamizerSOS;
      
      protected var FUnstreamizerInteractionLogs:TUnstreamizerInteractionLogs;
      
      protected var FUnstreamizerDisciple:TUnstreamizerDisciple;
      
      protected var FIsInteractionLogReq:Boolean;
      
      protected var FOnShowOtherPlayerInfor:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      public function TProcessorMentorship(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowMentorship = new TProcessorWindowMentorship(this);
         this.FProcessorWindowMentorship.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowMentorship.OnArrest = this.ProcessorWindowOnArrest;
         this.FProcessorWindowMentorship.OnRescueMembers = this.ProcessorWindowOnRescueMembers;
         this.FProcessorWindowMentorship.OnInteraction = this.ProcessorWindowOnInteraction;
         this.FProcessorWindowMentorship.OnWatchOhterPlayerInfo = this.ProcessorOnShowOtherPlayerInfor;
         this.FProcessorWindowMentorship.OnDrawExp = this.ProcessorOnCMDReq;
         this.FProcessorWindowMentorship.OnResist = this.ProcessorOnCMDReq;
         this.FProcessorWindowMentorship.OnRedeem = this.ProcessorOnCMDReq;
         this.FProcessorWindowMentorship.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMentorship.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowArrest = new TProcessorWindowArrest(this);
         this.FProcessorWindowArrest.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowArrest.OnArrestPlayer = this.ProcessorOnCMDReq;
         this.FProcessorWindowInteraction = new TProcessorWindowInteraction(this);
         this.FProcessorWindowInteraction.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowInteraction.OnInteraction = this.ProcessorOnCMDReq;
         this.FProcessorWindowRescue = new TProcessorWindowRescue(this);
         this.FProcessorWindowRescue.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowRescue.OnRescuePlayer = this.ProcessorOnCMDReq;
         this.FMentorshipBounds = new TBounds();
         this.FMentorshipBounds.X = this.FProcessorWindowMentorship.x;
         this.FMentorshipBounds.Y = this.FProcessorWindowMentorship.y;
         this.FMentorshipBounds.Width = SIZE_WindowMentorship_Width;
         this.FMentorshipBounds.Height = SIZE_WindowMentorship_Height;
         ComponentBoundsCenter(this.FProcessorWindowMentorship,this.FMentorshipBounds);
         this.FMentorshipBounds = null;
         this.FArrestBounds = new TBounds();
         this.FArrestBounds.X = this.FProcessorWindowArrest.x;
         this.FArrestBounds.Y = this.FProcessorWindowArrest.y;
         this.FArrestBounds.Width = SIZE_WindowArrest_Width;
         this.FArrestBounds.Height = SIZE_WindowArrest_Height;
         ComponentBoundsCenter(this.FProcessorWindowArrest,this.FArrestBounds);
         this.FArrestBounds = null;
         this.FInteractionBounds = new TBounds();
         this.FInteractionBounds.X = this.FProcessorWindowInteraction.x;
         this.FInteractionBounds.Y = this.FProcessorWindowInteraction.y;
         this.FInteractionBounds.Width = SIZE_WindowInteraction_Width;
         this.FInteractionBounds.Height = SIZE_WindowInteraction_Height;
         ComponentBoundsCenter(this.FProcessorWindowInteraction,this.FInteractionBounds);
         this.FInteractionBounds = null;
         this.FRescueBounds = new TBounds();
         this.FRescueBounds.X = this.FProcessorWindowRescue.x;
         this.FRescueBounds.Y = this.FProcessorWindowRescue.y;
         this.FRescueBounds.Width = SIZE_WindowRescue_Width;
         this.FRescueBounds.Height = SIZE_WindowRescue_Height;
         ComponentBoundsCenter(this.FProcessorWindowRescue,this.FRescueBounds);
         this.FRescueBounds = null;
         this.FUnstreamizerMentorship = new TUnstreamizerMentorship();
         this.FUnstreamizerArrest = new TUnstreamizerArrest();
         this.FUnstreamizerRescue = new TUnstreamizerRescue();
         this.FUnstreamizerSOS = new TUnstreamizerSOS();
         this.FUnstreamizerInteractionLogs = new TUnstreamizerInteractionLogs();
         this.FUnstreamizerDisciple = new TUnstreamizerDisciple();
         this.FMentorship = SLogicsCore.Mentorship;
         this.FArrest = new TArrest();
         this.FRescue = new TRescue();
         this.FSOS = new TSOS();
         this.FInteractionLogs = new TInteractionLogs();
         this.FDisciple = new TDisciple();
         this.FIsInteractionLogReq = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MENTORSHIP.RESOURCESID_Swf_Mentorship);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_LoadBaseDataRet,this.PacketPerform_SC_LoadBaseDataRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_CatchListRet,this.PacketPerform_SC_CatchListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_RescueMembersListRet,this.PacketPerform_SC_RescueMembersListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_SOSListRet,this.PacketPerform_SC_SOSListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_InteractionLogRet,this.PacketPerform_SC_InteractionLogRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_ArrestDiscipleRet,this.PacketPerform_SC_ArrestDiscipleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_IntercationRet,this.PacketPerform_SC_IntercationRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_RescueRet,this.PacketPerform_SC_RescueRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_GetExpRet,this.PacketPerform_SC_GetExpRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_ReleaseRet,this.PacketPerform_SC_ReleaseRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_RedeemRet,this.PacketPerform_SC_RedeemRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_CommandRet,this.PacketPerform_SC_CommandRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_ResistRet,this.PacketPerform_SC_ResistRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mentorship_SOSRet,this.PacketPerform_SC_SOSRet);
      }
      
      protected function PacketPerform_SC_LoadBaseDataRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerMentorship.Unstreamize(_loc2_,this.FMentorship,null);
         if(this.Visible)
         {
            this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
         }
      }
      
      protected function PacketPerform_SC_CatchListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerArrest.Unstreamize(_loc2_,this.FArrest,null);
         this.FProcessorWindowArrest.UpdateUI(this.FArrest);
      }
      
      protected function PacketPerform_SC_RescueMembersListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerRescue.Unstreamize(_loc2_,this.FRescue,null);
         this.FProcessorWindowRescue.UpdateUI(this.FRescue);
      }
      
      protected function PacketPerform_SC_SOSListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerSOS.Unstreamize(_loc2_,this.FSOS,null);
         this.FProcessorWindowRescue.UpdateUI(this.FSOS);
      }
      
      protected function PacketPerform_SC_InteractionLogRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerInteractionLogs.Unstreamize(_loc2_,this.FInteractionLogs,this.CAPACITY_InteractionLogs);
         if(this.Visible)
         {
            this.FProcessorWindowMentorship.UpdateLog(this.FInteractionLogs);
         }
      }
      
      protected function PacketPerform_SC_ArrestDiscipleRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = int(_loc2_.readUnsignedByte());
         if(_loc5_ == ERROR_LevelOverstep)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_27));
            }
            this.PacketPerform_CS_CatchListReq();
            return;
         }
         this.ProcessorBattleStatus();
         _loc4_ = Boolean(_loc2_.readUnsignedByte());
         this.FMentorship.TodayArrestCount = _loc2_.readUnsignedInt();
         if(_loc4_)
         {
            this.FUnstreamizerDisciple.Unstreamize(_loc2_,this.FDisciple,null);
            this.FMentorship.DiscipleList.push(this.FDisciple);
         }
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_IntercationRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TDisciple = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TSlaveGainExp = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = _loc2_.readUnsignedInt();
         _loc7_ = _loc2_.readUnsignedInt();
         _loc10_ = _loc2_.readUnsignedInt();
         switch(this.FMentorship.Identity)
         {
            case CONST_MENTORSHIP.IDENTITY_Master:
               _loc4_ = this.FMentorship.GetDiscipleByID(_loc5_,_loc6_);
               if(_loc4_ != null)
               {
                  _loc4_.InteractionCDTime = _loc7_;
                  _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveGainExp,_loc4_.DiscipleLevel) as TSlaveGainExp;
                  _loc9_ = _loc2_.readUnsignedInt();
                  EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_25),_loc4_.DiscipleName,_loc9_));
               }
               break;
            case CONST_MENTORSHIP.IDENTITY_Disciple:
               this.FMentorship.InteractionCDTime = _loc7_;
               _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveGainExp,SLogicsCore.Character.GetMainLevel()) as TSlaveGainExp;
               _loc9_ = _loc2_.readUnsignedInt();
               EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_25),this.FMentorship.MasterName,_loc9_));
         }
         this.FMentorship.TodayInteractionCount = _loc10_;
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_RescueRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TDisciple = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.ProcessorBattleStatus();
         _loc4_ = this.FMentorship.GetDiscipleByID(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         if(_loc4_ != null)
         {
            _loc4_.InteractionCDTime = _loc2_.readUnsignedInt();
         }
         this.FMentorship.TodayRescueCount = _loc2_.readUnsignedInt();
      }
      
      protected function PacketPerform_SC_GetExpRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDisciple = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = this.FMentorship.GetDiscipleByID(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         if(_loc5_ != null)
         {
            _loc5_.StartWorkTime = _loc2_.readUnsignedInt();
            _loc5_.DrawTime = _loc2_.readUnsignedInt();
         }
         _loc6_ = this.FMentorship.TodayGetExp;
         this.FMentorship.TodayGetExp = _loc2_.readUnsignedInt();
         _loc7_ = this.FMentorship.TodayGetExp - _loc6_;
         _loc8_ = _loc2_.readUnsignedInt();
         if(_loc5_ != null)
         {
            _loc5_.AddUpExp = _loc2_.readUnsignedInt();
         }
         switch(_loc4_)
         {
            case CONST_MENTORSHIP.COMMAND_Draw:
               break;
            case CONST_MENTORSHIP.COMMAND_Squeeze:
            case CONST_MENTORSHIP.COMMAND_DrawAll:
            case CONST_MENTORSHIP.COMMAND_Release:
               EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_24),_loc5_.DiscipleName,_loc7_));
         }
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_ReleaseRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TDisciple = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = _loc2_.readUnsignedInt();
         this.FMentorship.Identity = _loc2_.readUnsignedInt();
         _loc7_ = this.FMentorship.TodayGetExp;
         this.FMentorship.TodayGetExp = _loc2_.readUnsignedInt();
         _loc8_ = this.FMentorship.TodayGetExp - _loc7_;
         _loc4_ = this.FMentorship.GetDiscipleByID(_loc5_,_loc6_);
         if(_loc8_ <= 0)
         {
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_35),_loc4_.DiscipleName));
         }
         else
         {
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_23),_loc4_.DiscipleName,_loc8_));
         }
         this.FMentorship.DeleteDiscipleByID(_loc5_,_loc6_);
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_RedeemRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FMentorship.DeleteDiscipleByID(_loc2_.readUnsignedInt(),_loc2_.readUnsignedInt());
         this.FMentorship.Identity = CONST_MENTORSHIP.IDENTITY_Freedom;
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_CommandRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
      }
      
      protected function PacketPerform_SC_ResistRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.ProcessorBattleStatus();
         _loc5_ = Boolean(_loc2_.readUnsignedByte());
         this.FMentorship.TodayResistCount = _loc2_.readUnsignedInt();
         if(_loc5_)
         {
            this.FMentorship.Identity = CONST_MENTORSHIP.IDENTITY_Freedom;
         }
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function PacketPerform_SC_SOSRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TSOSPlayer = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.ProcessorBattleStatus();
         _loc5_ = Boolean(_loc2_.readUnsignedByte());
         _loc6_ = _loc2_.readUnsignedInt();
         _loc7_ = _loc2_.readUnsignedInt();
         _loc4_ = this.FSOS.GetSOSPlayerByID(_loc6_,_loc7_);
         this.FMentorship.TodaySOSCount = _loc2_.readUnsignedInt();
         if(_loc5_)
         {
            this.FMentorship.Identity = CONST_MENTORSHIP.IDENTITY_Freedom;
         }
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      protected function ProcessorOnCMDReq(param1:Object, param2:uint, param3:uint, param4:uint, param5:uint) : void
      {
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_CommandReq);
         _loc7_ = _loc6_.Data;
         _loc7_.writeByte(param2);
         _loc7_.writeByte(param3);
         _loc7_.writeUnsignedInt(param4);
         _loc7_.writeUnsignedInt(param5);
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function PacketPerform_CS_CatchListReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_CatchListReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PacketPerform_CS_RescueMembersListReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_RescueMembersListReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PACKETID_CS_SOSListReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_SOSListReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorBattleStatus() : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_Slave,CONST_MUSIC.ID_SCENE_Slave);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_CS_LoadBaseDataReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_LoadBaseDataReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PacketPerform_CS_InteractionLogReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_InteractionLogReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         if(param1 is TProcessorWindowMentorship)
         {
            ProcessorClose();
         }
         else
         {
            this.FProcessorWindowMentorship.Visible = true;
            param1.Visible = false;
            this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
         }
      }
      
      protected function ProcessorWindowOnArrest(param1:Object) : void
      {
         this.PacketPerform_CS_CatchListReq();
         param1.Visible = false;
         this.FProcessorWindowArrest.Visible = true;
      }
      
      protected function ProcessorWindowOnRescueMembers(param1:Object, param2:uint) : void
      {
         if(param2 == CONST_MENTORSHIP.TYPE_Rescue)
         {
            this.PacketPerform_CS_RescueMembersListReq();
            param1.Visible = false;
            this.FProcessorWindowRescue.Visible = true;
         }
         else if(param2 == CONST_MENTORSHIP.TYPE_SOS)
         {
            if(SLogicsCore.Organization.OrgId <= 0)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_36));
            }
            else
            {
               this.PACKETID_CS_SOSListReq();
               param1.Visible = false;
               this.FProcessorWindowRescue.Visible = true;
            }
         }
      }
      
      protected function ProcessorWindowOnInteraction(param1:Object, param2:Object) : void
      {
         param1.Visible = false;
         this.FProcessorWindowInteraction.Visible = true;
         this.FProcessorWindowInteraction.UpdateUI(param2);
      }
      
      protected function ProcessorOnShowOtherPlayerInfor(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnShowOtherPlayerInfor != null)
         {
            this.FOnShowOtherPlayerInfor(this,param2,param3);
         }
      }
      
      public function get OnShowOtherPlayerInfor() : Function
      {
         return this.FOnShowOtherPlayerInfor;
      }
      
      public function set OnShowOtherPlayerInfor(param1:Function) : void
      {
         this.FOnShowOtherPlayerInfor = param1;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMentorship.Load();
            this.FProcessorWindowArrest.Load();
            this.FProcessorWindowRescue.Load();
            this.FProcessorWindowInteraction.Load();
            return;
         }
         this.PacketPerform_CS_LoadBaseDataReq();
         if(!this.FIsInteractionLogReq)
         {
            this.PacketPerform_CS_InteractionLogReq();
            this.FIsInteractionLogReq = true;
         }
         this.FProcessorWindowMentorship.Visible = true;
         this.FProcessorWindowArrest.Visible = false;
         this.FProcessorWindowInteraction.Visible = false;
         this.FProcessorWindowRescue.Visible = false;
         this.FProcessorWindowMentorship.UpdateLog(this.FInteractionLogs);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_Slave,CONST_MUSIC.ID_SCENE_Slave,false);
      }
      
      public function UpdateUI() : void
      {
         this.FProcessorWindowMentorship.UpdateUI(this.FMentorship);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowInteraction.Reset();
         this.FProcessorWindowMentorship.Reset();
      }
   }
}

