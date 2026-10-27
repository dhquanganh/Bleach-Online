package Processors.Game.Lobby.Activity.HDLuckyJoy
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDLuckyJoy.TActivityLuckyJoyData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Activity.HDLuckyJoy.Decoder.TUnstreamizerActivityLuckyJoy;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorHDLuckyJoy extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH:int = 727;
      
      protected static const WINDOW_HEIGHT:int = 548;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorHDWindowLuckyJoy:TProcessorHDWindowLuckyJoy;
      
      protected var FActivityLuckyJoyData:TActivityLuckyJoyData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerActivityLuckyJoy:TUnstreamizerActivityLuckyJoy;
      
      public function TProcessorHDLuckyJoy(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_LuckyJoy;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityLuckyJoy);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         this.FActivityLuckyJoyData = new TActivityLuckyJoyData();
         this.FProcessorHDWindowLuckyJoy = new TProcessorHDWindowLuckyJoy(this);
         this.FProcessorHDWindowLuckyJoy.OnClose = this.ShutDownWindow;
         this.FProcessorHDWindowLuckyJoy.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorHDWindowLuckyJoy.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         this.FProcessorHDWindowLuckyJoy.ActivityLuckyJoyData = this.FActivityLuckyJoyData;
         ComponentBoundsCenter(this.FProcessorHDWindowLuckyJoy,this.FBounds);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerActivityLuckyJoy = new TUnstreamizerActivityLuckyJoy();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_LuckyJoy);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerActivityLuckyJoy.CoreConfigValue(null,this.FActivityLuckyJoyData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerActivityLuckyJoy.UnstreamizationPerform_InitData(null,this.FActivityLuckyJoyData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowLuckyJoy.Show(FCurAtoms,FHDActivityConfig,this.FActivityLuckyJoyData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(param1.Index == this.FActivityLuckyJoyData.ScoreIndex)
         {
            _loc3_ = param1.Status - this.FActivityLuckyJoyData.CurrentScore;
            if(_loc3_ > 0)
            {
               _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_77),param1.Status - this.FActivityLuckyJoyData.CurrentScore);
               SToolReward.ShowMessage(_loc2_);
            }
         }
         this.FUnstreamizerActivityLuckyJoy.FillBoxState(param1.Index,param1.Status,this.FActivityLuckyJoyData);
         this.FProcessorHDWindowLuckyJoy.Show(FCurAtoms,FHDActivityConfig,this.FActivityLuckyJoyData);
         if(param1.Index == this.FActivityLuckyJoyData.RollResultIndex)
         {
            this.FProcessorHDWindowLuckyJoy.AwardArrive();
         }
      }
      
      protected function ShutDownWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         FGiftOverLayer.Hide();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         if(param3 != null)
         {
            _loc5_ = param3 as int;
         }
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FProcessorHDWindowLuckyJoy.OnLoadLog = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorHDWindowLuckyJoy.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorHDWindowLuckyJoy.Show(FCurAtoms,FHDActivityConfig,this.FActivityLuckyJoyData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_LuckyJoy);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_LuckyJoy);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

