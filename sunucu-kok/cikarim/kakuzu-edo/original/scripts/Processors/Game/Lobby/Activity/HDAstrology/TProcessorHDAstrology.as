package Processors.Game.Lobby.Activity.HDAstrology
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDAstrology.TActivityAstrologyData;
   import Logics.HDSwiftChange.*;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDAstrology.TUnstreamizerAstrology;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDAstrology extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 784;
      
      protected const WINDOW_HEIGHT:int = 592;
      
      protected var FWindowAstrology:TprocessorHDWindowAstrology;
      
      protected var FActivityAstrologyData:TActivityAstrologyData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerAstrology:TUnstreamizerAstrology;
      
      public function TProcessorHDAstrology(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_AstrologyHouse;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_AstrologyHouse);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FActivityAstrologyData = new TActivityAstrologyData();
         this.FWindowAstrology = new TprocessorHDWindowAstrology(this);
         this.FWindowAstrology.OnClose = this.CloseWindowHandler;
         this.FWindowAstrology.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FWindowAstrology.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         this.FWindowAstrology.ActivityAstrologyData = this.FActivityAstrologyData;
         ComponentBoundsCenter(this.FWindowAstrology,_loc1_);
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
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerAstrology = new TUnstreamizerAstrology();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_AstrologyHouse);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerAstrology.CoreConfigValue(null,this.FActivityAstrologyData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerAstrology.UnstreamizationPerform_InitData(null,this.FActivityAstrologyData,FActivityInitRetData);
         if(FActivityInitRetData.AllBox.length > 0)
         {
            this.FInited = true;
         }
         if(!this.Visible)
         {
            return;
         }
         this.FWindowAstrology.Show(FCurAtoms,FHDActivityConfig,this.FActivityAstrologyData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FUnstreamizerAstrology.FillBoxState(param1,this.FActivityAstrologyData,FHDActivityConfig);
         this.FWindowAstrology.Show(FCurAtoms,FHDActivityConfig,this.FActivityAstrologyData);
         _loc5_ = int(this.FActivityAstrologyData.ExtractDataVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(this.FActivityAstrologyData.ExtractDataVec[_loc4_].StarPicPosition == param1.Index)
            {
               this.FWindowAstrology.PlayEffect(_loc4_);
               break;
            }
            _loc4_++;
         }
      }
      
      protected function CloseWindowHandler(param1:Object) : void
      {
         ProcessorClose();
         this.FInited = true;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowAstrology.Load();
            return;
         }
         if(this.FInited)
         {
            this.FWindowAstrology.Visible = true;
            this.FWindowAstrology.Show(FCurAtoms,FHDActivityConfig,this.FActivityAstrologyData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_AstrologyHouse);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_AstrologyHouse);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

