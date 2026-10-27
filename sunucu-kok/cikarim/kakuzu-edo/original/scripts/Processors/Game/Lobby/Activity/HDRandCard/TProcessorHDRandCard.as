package Processors.Game.Lobby.Activity.HDRandCard
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDRandCard.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDRandCard extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOWSIZE_WIDHT_RandCard:uint = 807;
      
      protected static const WINDOWSIZE_HEIGHT_RandCard:uint = 514;
      
      protected var FProcessorWindowRandCard:TProcessorHDWindowRandCard;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FDataRandCard:TActivityRandCard;
      
      protected var FHDRandCard:THDRandCard;
      
      protected var FIsInitData:Boolean;
      
      protected var FIsFirstEnter:Boolean;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDRandCard(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_RandCard;
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
         this.FDataRandCard = new TActivityRandCard();
         this.FIsInitData = false;
         this.FIsFirstEnter = true;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRandCard);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowRandCard = new TProcessorHDWindowRandCard(this);
         this.FProcessorWindowRandCard.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowRandCard.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowRandCard.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowRandCard.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOWSIZE_WIDHT_RandCard;
         this.FBounds.Height = WINDOWSIZE_HEIGHT_RandCard;
         ComponentBoundsCenter(this.FProcessorWindowRandCard,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDRandCard = FHDActivityConfig as THDRandCard;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_RandCard);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDRandCard == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateRandCard(FActivityInitRetData,this.FDataRandCard,this.FHDRandCard);
         this.FIsInitData = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowRandCard.Show(FCurAtoms,this.FHDRandCard,this.FDataRandCard);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(!this.FIsInitData)
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_RandCard);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(FMemoryID != FCurAtoms.Identifier)
            {
               if(this.FHDRandCard == null)
               {
                  GetActivityConfigByActivityAtoms(FCurAtoms);
               }
               FMemoryID = FCurAtoms.Identifier;
            }
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
            return;
         }
         this.FDataRandCard.SetData(param1.Index,param1.Status);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowRandCard.Show(FCurAtoms,this.FHDRandCard,this.FDataRandCard);
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityRCStageData = null;
         super.ValuesChange(param1,param2);
         if(this.FIsInitData)
         {
            _loc4_ = int(param2.length);
            if(_loc4_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercTotal)
            {
               _loc5_ = this.FDataRandCard.GoldStage;
               _loc5_.Stage = param2[1];
               this.FDataRandCard.SetGoldAward(param2[2]);
               _loc5_ = this.FDataRandCard.SuperStage;
               _loc5_.Stage = param2[4];
            }
            else if(_loc4_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercGold)
            {
               _loc5_ = this.FDataRandCard.GoldStage;
               _loc5_.Stage = param2[1];
               this.FDataRandCard.SetGoldAward(param2[2]);
            }
            else if(_loc4_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercSuper)
            {
               _loc5_ = this.FDataRandCard.SuperStage;
               _loc5_.Stage = param2[1];
            }
         }
         if(this.Visible)
         {
            this.FProcessorWindowRandCard.WindowUpDateUI(param2);
         }
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         this.FProcessorWindowRandCard.OnLoadLog = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowRandCard.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_RandCard);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDRandCard == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowRandCard.Hide();
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         if(!this.Visible)
         {
            return;
         }
         if(param1.length > 0)
         {
            this.FProcessorWindowRandCard.OperateRet(param1);
         }
      }
   }
}

