package Processors.Game.Lobby.Activity.HDTreasureAwake
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDActivityTreasureAwake.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessowWindowMainView extends TProcessorHDSingleWindowBase
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBtnUpQuality:TUIButton;
      
      protected var FBtnBuyPaper:TUIButton;
      
      protected var FLayerMask:Sprite;
      
      protected var FWindowTreasureUpLevel:TProcessorWindowTreasureUpLevel;
      
      protected var FProcessorWindowBuyPaper:TProcessorWindowBuyPaper;
      
      protected var FTreasureAwakeData:TActivityTreasureAwakeData;
      
      public function TProcessowWindowMainView(param1:TUIComponent)
      {
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivityTreasureAwake;
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = FScene;
         this.FBtnUpQuality = new TUIButton();
         this.FBtnUpQuality.Substrate = this.FMainUI["Btn_UpQuality"];
         this.FBtnUpQuality.OnClick = this.BtnUpQualityOnClick;
         this.FBtnBuyPaper = new TUIButton();
         this.FBtnBuyPaper.Substrate = this.FMainUI["Btn_BuyPaper"];
         this.FBtnBuyPaper.OnClick = this.BtnBuyPaperOnClick;
         this.FLayerMask = new Sprite();
         FParent.addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FWindowTreasureUpLevel = new TProcessorWindowTreasureUpLevel(FParent);
         this.FWindowTreasureUpLevel.UIDispatch();
         this.FWindowTreasureUpLevel.UILocation();
         this.FWindowTreasureUpLevel.OnClose = this.CancleMask;
         this.FWindowTreasureUpLevel.OnBuyPaper = this.JmpBuyPaperView;
         this.FWindowTreasureUpLevel.x = (CONST_COMMON.STAGE_Width - this.FWindowTreasureUpLevel.width) / 2;
         this.FWindowTreasureUpLevel.y = (CONST_COMMON.STAGE_Height - this.FWindowTreasureUpLevel.height) / 2;
         this.FProcessorWindowBuyPaper = new TProcessorWindowBuyPaper(FParent);
         this.FProcessorWindowBuyPaper.UIDispatch();
         this.FProcessorWindowBuyPaper.UILocation();
         this.FProcessorWindowBuyPaper.OnBtnBuy = this.BuyPaperRequst;
         this.FProcessorWindowBuyPaper.OnClose = this.CancleMask;
         this.FProcessorWindowBuyPaper.x = (CONST_COMMON.STAGE_Width - this.FProcessorWindowBuyPaper.width) / 2;
         this.FProcessorWindowBuyPaper.y = (CONST_COMMON.STAGE_Height - this.FProcessorWindowBuyPaper.height) / 2;
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityDesc();
      }
      
      protected function CancleMask(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      protected function BtnUpQualityOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWindowTreasureUpLevel.Show();
         this.FLayerMask.visible = true;
      }
      
      protected function BtnBuyPaperOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FProcessorWindowBuyPaper.Show(this.FTreasureAwakeData);
         this.FLayerMask.visible = true;
      }
      
      protected function BuyPaperRequst(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      protected function JmpBuyPaperView(param1:Object) : void
      {
         this.FProcessorWindowBuyPaper.Show(this.FTreasureAwakeData);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.FTreasureAwakeData = param3 as TActivityTreasureAwakeData;
         this.UpdateUI();
         Visible = true;
      }
      
      public function UpLevelNotify() : void
      {
         this.FWindowTreasureUpLevel.UpLevelNotify();
      }
      
      public function BuyPaperNotify() : void
      {
         this.FProcessorWindowBuyPaper.Show(this.FTreasureAwakeData);
      }
   }
}

