package Processors.Game.Lobby.Activity.HDDreamComeTrue
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDDreamComeTrue.windows.TProcessorExchangeView;
   import Processors.Game.Lobby.Activity.HDDreamComeTrue.windows.TProcessorTurntableView;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TprocessorHDWindowDreams extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 2;
      
      private var FExchangePanel:Sprite;
      
      private var FTurntablePanle:Sprite;
      
      private var FExchangeView:TProcessorExchangeView;
      
      private var FTurntableView:TProcessorTurntableView;
      
      private var FUITab:TUITab;
      
      protected var FActivityDreamsData:TActivityDreamsData;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TprocessorHDWindowDreams(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_DreamsComeTrue";
         FActivityID = CONST_ACTIVITY_MODE.Activity_DreamsComeTrue;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatch();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         this.FUITab = new TUITab(this);
         _loc2_ = this.FTabNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FScene["MC_Tab" + _loc1_];
            if(_loc3_.MC_Status != null)
            {
               MovieClip(_loc3_.MC_Status).gotoAndStop(1);
               MovieClip(_loc3_.MC_Status).visible = false;
            }
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            this.FUITab.SetTabCaptionByIndex("",_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FExchangePanel = FScene["MC_ExchangeView"];
         this.FExchangeView = new TProcessorExchangeView(this,this.FExchangePanel);
         this.FExchangeView.OnCreateKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData;
         this.FExchangeView.ActivityDreamsData = this.FActivityDreamsData;
         this.FExchangeView.OnMoveGiftTips = this.OnMoveGift;
         this.FExchangeView.OnOutGiftTips = this.OnOutGift;
         this.FExchangeView.SendData = this.SendServiceData;
         this.FTurntablePanle = FScene["MC_TurntableView"];
         this.FTurntableView = new TProcessorTurntableView(this,this.FTurntablePanle);
         this.FTurntableView.SendData = this.SendServiceData;
         this.FTurntableView.Data = this.FActivityDreamsData;
         this.OnSelectPanel(CONST_DREAMS.DREAMS_TAB_0,true);
      }
      
      protected function SendServiceData(param1:int, param2:int = 0, param3:Vector.<int> = null) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1,param2,param3);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.FExchangeView.LogicsPerform_EnterFrame();
            this.FTurntableView.LogicsPerform_EnterFrame();
         }
      }
      
      private function OnSelectPanel(param1:int, param2:Boolean) : void
      {
         if(param1 == CONST_DREAMS.DREAMS_TAB_0)
         {
            this.FTurntablePanle.visible = !param2;
            this.FExchangePanel.visible = param2;
         }
         else
         {
            this.FTurntablePanle.visible = param2;
            this.FExchangePanel.visible = !param2;
         }
      }
      
      protected function OnMoveGift(param1:Object) : void
      {
         ProcessorOnGiftBoxMove(this,param1,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnOutGift(param1:Object) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.OnSelectPanel(_loc2_,true);
      }
      
      public function set ActivityDreamsData(param1:TActivityDreamsData) : void
      {
         this.FActivityDreamsData = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.FActivityDreamsData = param3 as TActivityDreamsData;
         this.FExchangeView.ActivityDreamsData = this.FActivityDreamsData;
         this.FExchangeView.ShowView();
         this.FTurntableView.Data = this.FActivityDreamsData;
         this.FTurntableView.ShowView();
      }
      
      public function UpdateView() : void
      {
         this.FExchangeView.ActivityDreamsData = this.FActivityDreamsData;
         this.FExchangeView.RefreshView();
         this.FTurntableView.Data = this.FActivityDreamsData;
         this.FTurntableView.ShowView();
      }
      
      public function GetTurntableAwardPos(param1:int) : void
      {
         this.FTurntableView.GetTurntableAward(param1);
      }
   }
}

