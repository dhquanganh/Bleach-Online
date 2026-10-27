package Processors.Game.Lobby.Activity.HDTreasureAwake
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityTreasureAwake.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDTreasureAwake extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH:int = 502;
      
      protected static const WINDOW_HEIGHT:int = 388;
      
      protected var FProcessowWindowMainView:TProcessowWindowMainView;
      
      protected var FTreasureAwakeData:TActivityTreasureAwakeData;
      
      protected var FUnstreamizerTreasureAwake:TUnstreamizerTreasureAwake;
      
      protected var FBounds:TBounds;
      
      protected var FInited:Boolean;
      
      public function TProcessorHDTreasureAwake(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_TreasureAwake;
         this.FTreasureAwakeData = new TActivityTreasureAwakeData();
         this.FUnstreamizerTreasureAwake = new TUnstreamizerTreasureAwake();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityTreasureAwake);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureAwake_LevelUpRet,this.PakcetPerform_TreasureAwake_LevelUp);
      }
      
      protected function PakcetPerform_TreasureAwake_LevelUp(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FProcessowWindowMainView.UpLevelNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_28));
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         this.FProcessowWindowMainView = new TProcessowWindowMainView(this);
         this.FProcessowWindowMainView.OnClose = this.ProcessorsOnBtnCloseClick;
         ComponentBoundsCenter(this.FProcessowWindowMainView,this.FBounds);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_TreasureAwake);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FTreasureAwakeData.HDTreasueShopeApply = FHDActivityConfig as THDTreasureShop;
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FTreasureAwakeData.HDTreasueShopeApply = FHDActivityConfig as THDTreasureShop;
         this.FUnstreamizerTreasureAwake.UnstreamizationPerform_InitData(null,this.FTreasureAwakeData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessowWindowMainView.Show(FCurAtoms,FHDActivityConfig,this.FTreasureAwakeData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FTreasureAwakeData.ActivityDataUpdate(param1.Index,param1.Status);
         this.FProcessowWindowMainView.Show(FCurAtoms,FHDActivityConfig,this.FTreasureAwakeData);
         this.FProcessowWindowMainView.BuyPaperNotify();
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessowWindowMainView.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessowWindowMainView.Show(FCurAtoms,FHDActivityConfig,this.FTreasureAwakeData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_TreasureAwake);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(FMemoryID != FCurAtoms.Identifier)
            {
               if(FHDActivityConfig == null)
               {
                  GetActivityConfigByActivityAtoms(FCurAtoms);
               }
               FMemoryID = FCurAtoms.Identifier;
            }
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.CheckEffectState();
      }
      
      public function CheckEffectState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FTreasureAwakeData.BuyTimes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FTreasureAwakeData.BuyTimes[_loc1_] < this.FTreasureAwakeData.HDTreasueShopeApply.Limits[_loc1_])
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
               this.ProcessorEffectNotify();
               return;
            }
            _loc1_++;
         }
         FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         this.ProcessorEffectNotify();
      }
      
      public function ProcessorEffectNotify() : void
      {
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_TreasureAwake);
         }
      }
   }
}

