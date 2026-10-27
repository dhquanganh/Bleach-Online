package Processors.Game.Lobby.Activity.HDJigSaw
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDJigSaw;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDJigSaw.TActivityJSAward;
   import Logics.HDJigSaw.TActivityJSScore;
   import Logics.HDJigSaw.TActivityJigSaw;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityJigSaw.TUnstreamizerActivityJigSaw;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDJigSaw extends TProcessorHDSingleWindowsBase
   {
      
      protected static const JIGSAW_WIDTH:uint = 713;
      
      protected static const JIGSAW_HEIGHT:uint = 480;
      
      protected static const SCORESHOP_WIDTH:uint = 401;
      
      protected static const SCORESHOP_HEIGHT:uint = 364;
      
      protected var FProcessorWindowJigSaw:TProcessorHDWindowJigSaw;
      
      protected var FProcessorWindowScoreShop:TProcessorHDWindowScoreShop;
      
      protected var FBounds:TBounds;
      
      protected var FData_JigSaw:TActivityJigSaw;
      
      protected var FHD_JigSaw:THDJigSaw;
      
      protected var FUnstreamizerActivityJigSaw:TUnstreamizerActivityJigSaw;
      
      public function TProcessorHDJigSaw(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_JigSaw;
         this.FData_JigSaw = new TActivityJigSaw();
         this.FUnstreamizerActivityJigSaw = new TUnstreamizerActivityJigSaw();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityJigSaw);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowJigSaw = new TProcessorHDWindowJigSaw(this);
         this.FProcessorWindowJigSaw.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowJigSaw.OnEffectText = EffectGenerateText;
         this.FProcessorWindowJigSaw.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowJigSaw.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowJigSaw.OnScoreShop = this.OnScoreShop;
         this.FProcessorWindowJigSaw.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowJigSaw.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowJigSaw.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = JIGSAW_WIDTH;
         this.FBounds.Height = JIGSAW_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowJigSaw,this.FBounds);
         this.FProcessorWindowScoreShop = new TProcessorHDWindowScoreShop(this);
         this.FProcessorWindowScoreShop.OnBtnCloseClick = this.ScoreShopOnBtnCloseClick;
         this.FProcessorWindowScoreShop.OnEffectText = EffectGenerateText;
         this.FProcessorWindowScoreShop.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowScoreShop.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowScoreShop.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = SCORESHOP_WIDTH;
         this.FBounds.Height = SCORESHOP_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowScoreShop,this.FBounds);
      }
      
      private function ScoreShopOnBtnCloseClick(param1:Object) : void
      {
         this.FProcessorWindowScoreShop.Hide();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_JigSaw = FHDActivityConfig as THDJigSaw;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityJigSaw.UnstreamizeUpdateJigSaw(FActivityInitRetData,this.FData_JigSaw,this.FHD_JigSaw);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowJigSaw.Show(FCurAtoms,this.FHD_JigSaw,this.FData_JigSaw);
      }
      
      private function OnScoreShop(param1:Object, param2:Object) : void
      {
         this.FProcessorWindowScoreShop.Show(FCurAtoms,this.FHD_JigSaw,this.FData_JigSaw);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityJSAward = null;
         var _loc5_:TActivityJSScore = null;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = uint(param1.Index);
         _loc3_ = param1.Status;
         if(this.FData_JigSaw.Awards == null || this.FData_JigSaw.Awards.length < 0)
         {
            return;
         }
         _loc4_ = this.FData_JigSaw.GetAwardByUniqueIndex(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.Status = _loc3_;
         }
         _loc5_ = this.FData_JigSaw.Score;
         if(_loc5_ != null && _loc2_ == this.FData_JigSaw.Score.Index)
         {
            _loc5_.Score = _loc3_;
         }
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowJigSaw.Visible)
         {
            this.FProcessorWindowJigSaw.Show(FCurAtoms,this.FHD_JigSaw,this.FData_JigSaw);
         }
         if(this.FProcessorWindowScoreShop.Visible)
         {
            this.FProcessorWindowScoreShop.Show(FCurAtoms,this.FHD_JigSaw,this.FData_JigSaw);
         }
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
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
            this.FProcessorWindowJigSaw.Load();
            this.FProcessorWindowScoreShop.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Jigsaw);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_JigSaw == null)
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
         this.FProcessorWindowJigSaw.Hide();
         this.FProcessorWindowScoreShop.Hide();
      }
   }
}

