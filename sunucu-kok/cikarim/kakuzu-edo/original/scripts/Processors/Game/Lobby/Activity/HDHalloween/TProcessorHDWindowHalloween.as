package Processors.Game.Lobby.Activity.HDHalloween
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityHalloween.TActivityHalloweenExchangeData;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityHalloween.TActivityHalloweenTreeData;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TProcessorHDWindowWelfare;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TprocessorWindowHDHalloweenExchange;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TprocessorWindowHDHalloweenPumpkin;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TprocessorWindowHDHalloweenTree;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITYHALLOWEEN;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowHalloween extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 4;
      
      protected var FHalloweenPay:Sprite;
      
      protected var FHalloweenTree:Sprite;
      
      protected var FHalloweenPumpkin:Sprite;
      
      protected var FHalloweenShop:Sprite;
      
      protected var FMainAnima:MovieClip;
      
      protected var FHalloweenTreeView:TprocessorWindowHDHalloweenTree;
      
      protected var FHalloweenPayView:TProcessorHDWindowWelfare;
      
      protected var FHalloweenPumpkinView:TprocessorWindowHDHalloweenPumpkin;
      
      protected var FHalloweenExchangeView:TprocessorWindowHDHalloweenExchange;
      
      protected var FOnLoadLog:Function;
      
      protected var FUITab:TUITab;
      
      protected var FTabMasks:Vector.<Sprite>;
      
      protected var FOnSelectHDType:Function;
      
      public function TProcessorHDWindowHalloween(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_HalloweenMain";
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FUITab = new TUITab(this);
         this.FTabMasks = new Vector.<Sprite>();
         _loc3_ = this.FTabNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTabMasks.push(FScene["Mask" + _loc2_]);
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
         this.FHalloweenPay = FScene["MC_HalloweenActivity1"];
         this.FHalloweenTree = FScene["MC_HalloweenActivity2"];
         this.FHalloweenTree.visible = false;
         this.FHalloweenPumpkin = FScene["MC_HalloweenActivity3"];
         this.FHalloweenPumpkin.visible = false;
         this.FHalloweenShop = FScene["MC_HalloweenActivity4"];
         this.FHalloweenShop.visible = false;
         this.FHalloweenPayView = new TProcessorHDWindowWelfare(this,this.FHalloweenPay);
         this.FHalloweenPayView.ActivityOperateReq = this.ActivityOperateReq;
         this.FHalloweenTreeView = new TprocessorWindowHDHalloweenTree(this,this.FHalloweenTree);
         this.FHalloweenTreeView.WateringFun = this.HalloweenTreeWatering;
         this.FHalloweenTreeView.GetAwardFun = this.HalloweenTreeGetAward;
         this.FHalloweenTreeView.GiftMoveFun = this.HalloweenGiftOnMove;
         this.FHalloweenTreeView.GiftOutFun = this.HalloweenGiftOnOut;
         this.FHalloweenPumpkinView = new TprocessorWindowHDHalloweenPumpkin(this,this.FHalloweenPumpkin);
         this.FHalloweenPumpkinView.ActivityOperateReq = this.ActivityOperateReq;
         this.FHalloweenPumpkinView.OnGiftBoxMove = FOnGiftBoxMove;
         this.FHalloweenPumpkinView.OnGiftBoxOut = FOnGiftBoxOut;
         this.FHalloweenPumpkinView.OnLoadLog = this.FOnLoadLog;
         this.FHalloweenPumpkinView.OnMainClose = this.BtnCloseOnClick;
         this.FHalloweenExchangeView = new TprocessorWindowHDHalloweenExchange(this,this.FHalloweenShop);
         this.FHalloweenExchangeView.RequestFun = this.HalloweenExchangeRequest;
         this.FHalloweenExchangeView.ExchangeMoveFun = this.HalloweenGiftOnMove;
         this.FHalloweenExchangeView.ExchangeOutFun = this.HalloweenGiftOnOut;
         this.FMainAnima = FScene["MC_Anima"];
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FHalloweenTreeView.LogicsPerform();
            this.FHalloweenPayView.LogicsPerform();
            this.FHalloweenPumpkinView.Loop();
            this.FHalloweenExchangeView.LogicsPerform();
            this.FMainAnima.play();
         }
      }
      
      protected function HalloweenTreeWatering(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function HalloweenTreeGetAward(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function ActivityOperateReq(param1:uint, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(param1,param2);
      }
      
      protected function HalloweenGiftOnMove(param1:Object) : void
      {
         ProcessorOnGiftBoxMove(this,param1,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function HalloweenGiftOnOut() : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function HalloweenExchangeRequest(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function SetCurrentShowView(param1:int) : void
      {
         switch(param1)
         {
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_0:
               this.FHalloweenPay.visible = true;
               this.FHalloweenTree.visible = false;
               this.FHalloweenPumpkinView.ViewVisible = false;
               this.FHalloweenShop.visible = false;
               break;
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_1:
               this.FHalloweenPay.visible = false;
               this.FHalloweenTree.visible = true;
               this.FHalloweenPumpkinView.ViewVisible = false;
               this.FHalloweenShop.visible = false;
               break;
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_2:
               this.FHalloweenPay.visible = false;
               this.FHalloweenTree.visible = false;
               this.FHalloweenPumpkinView.ViewVisible = true;
               this.FHalloweenShop.visible = false;
               break;
            case CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_3:
               this.FHalloweenPay.visible = false;
               this.FHalloweenTree.visible = false;
               this.FHalloweenPumpkinView.ViewVisible = false;
               this.FHalloweenShop.visible = true;
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
         ProcessorWindowClose();
         this.FMainAnima.stop();
         this.FHalloweenPumpkinView.MainViewClose();
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
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_HalloweenPay)
         {
            this.FHalloweenPayView.Show(param1,param2,param3);
            this.FHalloweenPayView.OnGiftBoxMove = FOnGiftBoxMove;
            this.FHalloweenPayView.OnGiftBoxOut = FOnGiftBoxOut;
            this.ResetActivityPrompt(this.FHalloweenPay["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_0);
         }
         else if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_HalloweenTree)
         {
            this.FHalloweenTreeView.ActivityHalloweenTreeData = param3 as TActivityHalloweenTreeData;
            this.FHalloweenTreeView.ShowView();
            this.ResetActivityPrompt(this.FHalloweenTree["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_1);
         }
         else if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_HalloweenPumpkin)
         {
            this.FHalloweenPumpkinView.Data = param3 as TActivityHalloweenPumpkinData;
            this.FHalloweenPumpkinView.Atoms = param1;
            this.FHalloweenPumpkinView.GetInventoriesVectByAwardID = ProcessorGetInventoriesVectByAwardID;
            this.FHalloweenPumpkinView.UpdateUI();
            this.ResetActivityPrompt(this.FHalloweenPumpkin["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_2);
         }
         else
         {
            this.FHalloweenExchangeView.ActivityHalloweenExchangeData = param3 as TActivityHalloweenExchangeData;
            this.FHalloweenExchangeView.ShowView();
            this.ResetActivityPrompt(this.FHalloweenShop["MC_Prompt"]);
            this.SetCurrentShowView(CONST_ACTIVITYHALLOWEEN.HALLOWEEN_TAB_3);
         }
         this.UpdateUIConfig();
      }
      
      public function OnOperatRet(param1:Vector.<TFixedAward>) : void
      {
         this.FHalloweenPayView.OperateRet(param1);
      }
      
      public function SetHDTabState(param1:Vector.<Boolean>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUITab.SetTabEnabledByIndex(_loc2_,param1[_loc2_]);
            this.FTabMasks[_loc2_].visible = !param1[_loc2_];
            _loc2_++;
         }
      }
      
      public function SetupTabCurrentShowIndex(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
      }
   }
}

