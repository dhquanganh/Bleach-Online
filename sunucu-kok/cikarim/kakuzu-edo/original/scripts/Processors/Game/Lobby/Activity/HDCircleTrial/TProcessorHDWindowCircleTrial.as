package Processors.Game.Lobby.Activity.HDCircleTrial
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityCircleTrial.TActivityCircleHeroData;
   import Logics.HDActivityCircleTrial.TActivityCircleTrialData;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDCircleTrial.windows.TProcessorWindowHDCircleTrialView;
   import Processors.Game.Lobby.Activity.HDCircleTrial.windows.TProcessorWindowHDTrialExchange;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITYCIRCLETRIAL;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowCircleTrial extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 2;
      
      protected var FCircleTrialPanel:Sprite;
      
      protected var FCircleTrialView:TProcessorWindowHDCircleTrialView;
      
      protected var FTrialExchangeView:TProcessorWindowHDTrialExchange;
      
      protected var FTrialExchangePanel:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FOnLoadLog:Function;
      
      protected var FOnSelectHDType:Function;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TProcessorHDWindowCircleTrial(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_ActivityCircleTrial";
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
         this.FCircleTrialPanel = FScene["MC_CircleTrial1"];
         this.FTrialExchangePanel = FScene["MC_CircleTrial2"];
         this.FCircleTrialView = new TProcessorWindowHDCircleTrialView(this,this.FCircleTrialPanel);
         this.FCircleTrialView.GiftMoveFun = this.CircleTrialGiftOnMove;
         this.FCircleTrialView.GiftOutFun = this.CircleTrialGiftOnOut;
         this.FCircleTrialView.SendData = this.SendServiceData;
         this.FTrialExchangeView = new TProcessorWindowHDTrialExchange(this,this.FTrialExchangePanel);
         this.FTrialExchangeView.GiftMoveFun = this.CircleTrialGiftOnMove;
         this.FTrialExchangeView.GiftOutFun = this.CircleTrialGiftOnOut;
         this.FTrialExchangeView.SendData = this.SendServiceData;
         this.FTrialExchangeView.OnLoadLog = this.FOnLoadLog;
         this.FTrialExchangeView.OnCreateKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FCircleTrialView.LogicsPerform();
            this.FTrialExchangeView.LogicsPerform();
         }
      }
      
      protected function CircleTrialGiftOnMove(param1:Object) : void
      {
         ProcessorOnGiftBoxMove(this,param1,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function CircleTrialGiftOnOut() : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function SetCurrentShowView(param1:int) : void
      {
         switch(param1)
         {
            case CONST_ACTIVITYCIRCLETRIAL.MODEL_TAB_1:
               this.FCircleTrialPanel.visible = true;
               this.FTrialExchangePanel.visible = false;
               break;
            case CONST_ACTIVITYCIRCLETRIAL.MODEL_TAB_2:
               this.FCircleTrialPanel.visible = false;
               this.FTrialExchangePanel.visible = true;
         }
      }
      
      protected function SendServiceData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
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
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_CircleTrial)
         {
            this.FCircleTrialView.ActivityCircleTrialData = param3 as TActivityCircleTrialData;
            this.FCircleTrialView.ShowView();
            this.ResetActivityPrompt(this.FCircleTrialPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYCIRCLETRIAL.MODEL_TAB_1);
         }
         else if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_CirCleHero)
         {
            this.FTrialExchangeView.ActivityCircleHeroData = param3 as TActivityCircleHeroData;
            this.FTrialExchangeView.ShowView();
            this.ResetActivityPrompt(this.FTrialExchangePanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYCIRCLETRIAL.MODEL_TAB_2);
         }
         this.UpdateUIConfig();
      }
      
      public function OnOperatRet(param1:Vector.<TFixedAward>) : void
      {
         this.FCircleTrialView.OnOperatRet(param1);
      }
      
      public function SetHDTabState(param1:Vector.<Boolean>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc2_++;
         }
      }
      
      public function SetupTabCurrentShowIndex(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
      }
      
      public function UpdateArrive(param1:int, param2:int, param3:int) : void
      {
         if(param1 == 1)
         {
            if(this.FTrialExchangeView != null)
            {
               this.FTrialExchangeView.UpdateArrive(param2,param3);
            }
         }
         else if(param1 == 0)
         {
            if(this.FCircleTrialView != null)
            {
               this.FCircleTrialView.UpdateArrive(param2,param3);
            }
         }
      }
      
      public function ShowActivityImage() : void
      {
         if(this.FCircleTrialView != null)
         {
            this.FCircleTrialView.ShowActivityImage(true);
         }
      }
   }
}

