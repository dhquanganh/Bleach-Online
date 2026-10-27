package Processors.Game.Lobby.Activity.HDKingLegend
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKingLegend.TActivityKingGuardData;
   import Logics.HDKingLegend.TActivityKingLegendData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDKingLegend.windows.TProcessorKingGuardView;
   import Processors.Game.Lobby.Activity.HDKingLegend.windows.TProcessorKingLegendView;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITYHALLOWEEN;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_KingLegend;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowKingLegend extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 2;
      
      protected var FKingLegendPanel:Sprite;
      
      protected var FKingGuardPanel:Sprite;
      
      protected var FKingLegendView:TProcessorKingLegendView;
      
      protected var FKingGuardView:TProcessorKingGuardView;
      
      protected var FUITab:TUITab;
      
      protected var FActivityOverMc:Sprite;
      
      protected var FSelectIndex:int;
      
      protected var FOnSelectHDType:Function;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TProcessorHDWindowKingLegend(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_KingLegendMain";
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FUITab = new TUITab(this);
         _loc3_ = this.FTabNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Tabs + _loc2_];
            if(_loc4_.MC_Status != null)
            {
               MovieClip(_loc4_.MC_Status).gotoAndStop(1);
               MovieClip(_loc4_.MC_Status).visible = false;
            }
            this.FUITab.SetTabByIndex(_loc4_,_loc2_);
            this.FUITab.SetTabCaptionByIndex("",_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.UIDispatch();
         FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FActivityOverMc = this.FScene["MC_ActivityOver"];
         this.FActivityOverMc.visible = false;
      }
      
      protected function ResetActivityPrompt(param1:Sprite) : void
      {
         FTF_OpenTime = param1[CONST_ACTIVITY.RESOURCE_Link_TF_OpenTime];
         FTF_CoolingTime = param1[CONST_ACTIVITY.RESOURCE_Link_TF_CoolingTime];
         FTF_Desc = param1[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      protected function UIDispatch() : void
      {
         this.FKingLegendPanel = FScene["MC_ActivityKing"];
         this.FKingGuardPanel = FScene["MC_ActivityGuard"];
         this.FKingLegendView = new TProcessorKingLegendView(this,this.FKingLegendPanel);
         this.FKingLegendView.GiftMoveFun = this.ActivityGiftOnMove;
         this.FKingLegendView.GiftOutFun = this.ActivityGiftOnOut;
         this.FKingLegendView.SendData = this.SendRequestData;
         this.FKingGuardView = new TProcessorKingGuardView(this,this.FKingGuardPanel);
         this.FKingGuardView.SendData = this.SendRequestData;
         this.FKingGuardView.OnCreateKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FKingLegendView.LogicsPerform();
         }
      }
      
      protected function SendRequestData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function ActivityGiftOnMove(param1:Object) : void
      {
         ProcessorOnGiftBoxMove(this,param1,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ActivityGiftOnOut() : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function SetCurrentShowView(param1:int) : void
      {
         switch(param1)
         {
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_0:
               this.FKingLegendPanel.visible = true;
               this.FKingGuardPanel.visible = false;
               break;
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_1:
               this.FKingLegendPanel.visible = false;
               this.FKingGuardPanel.visible = true;
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         if(this.FOnSelectHDType != null)
         {
            this.FOnSelectHDType(_loc2_);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FKingLegendView.ClearRecordDdata();
         ProcessorWindowClose();
      }
      
      public function get OnSelectHDType() : Function
      {
         return this.FOnSelectHDType;
      }
      
      public function set OnSelectHDType(param1:Function) : void
      {
         this.FOnSelectHDType = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_KingLegend)
         {
            this.FKingLegendView.Data = param3 as TActivityKingLegendData;
            this.FKingLegendView.ShowView();
            this.ResetActivityPrompt(this.FKingLegendPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_0);
         }
         else if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_KingGuard)
         {
            this.FKingGuardView.ActivityKingGuardData = param3 as TActivityKingGuardData;
            this.FKingGuardView.ShowView(param1,param2);
            this.ResetActivityPrompt(this.FKingGuardPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_1);
         }
         this.UpdateUIConfig();
      }
      
      public function SetHDTabState(param1:Vector.<Boolean>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == 0)
            {
               this.FActivityOverMc.visible = !param1[_loc2_];
            }
            if(!param1[_loc2_])
            {
               this.FUITab.SetTabEnabledByIndex(_loc2_,param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function SetupTabCurrentShowIndex(param1:int) : void
      {
         this.FSelectIndex = param1;
         this.FUITab.SwithTagManual(param1);
      }
      
      public function UpdataData(param1:int, param2:int) : void
      {
         if(param1 == CONST_KingLegend.RefreshKingLegend)
         {
            this.FKingLegendView.StopAnima(param2);
         }
      }
   }
}

