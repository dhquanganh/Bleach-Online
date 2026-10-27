package Processors.Game.Lobby.Activity.HDAstrology
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
   import Logics.HDAstrology.TActivityAstrologyData;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDAstrology.windows.TAstrologyPictureView;
   import Processors.Game.Lobby.Activity.HDAstrology.windows.TSoulCombineView;
   import Processors.Game.Lobby.Activity.HDAstrology.windows.TSoulExchangeView;
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
   
   public class TprocessorHDWindowAstrology extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 2;
      
      private var FAstrologyImagePanel:Sprite;
      
      private var FStarPictureView:TAstrologyPictureView;
      
      private var FSoulCombinePanle:Sprite;
      
      private var FSoulCombineView:TSoulCombineView;
      
      private var FShopExchangView:TSoulExchangeView;
      
      private var FUITab:TUITab;
      
      private var FSelectShopType:int;
      
      protected var FActivityAstrologyData:TActivityAstrologyData;
      
      public function TprocessorHDWindowAstrology(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_AstrologyHouse";
         FActivityID = CONST_ACTIVITY_MODE.Activity_AstrologyHouse;
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
            _loc3_ = FScene["Btn_Tab_" + _loc1_];
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
         this.FAstrologyImagePanel = FScene["MC_AstrologyImageView"];
         this.FStarPictureView = new TAstrologyPictureView(this,this.FAstrologyImagePanel);
         this.FStarPictureView.Data = this.FActivityAstrologyData;
         this.FStarPictureView.OnMoveGiftTips = this.OnMoveGift;
         this.FStarPictureView.OnOutGiftTips = this.OnOutGift;
         this.FStarPictureView.SendData = this.SendServiceData;
         this.FStarPictureView.OpenShopFun = this.OpenShop;
         this.FSoulCombinePanle = FScene["MC_SoulCombineView"];
         this.FSoulCombineView = new TSoulCombineView(this,this.FSoulCombinePanle);
         this.FSoulCombineView.SendData = this.SendServiceData;
         this.FSoulCombineView.Data = this.FActivityAstrologyData;
         this.FSoulCombineView.OpenShopFun = this.OpenShop;
         this.OnSelectPanel(CONST_DREAMS.DREAMS_TAB_0);
         this.FShopExchangView = new TSoulExchangeView(this);
         this.FShopExchangView.SendData = this.SendServiceData;
         this.FShopExchangView.Data = this.FActivityAstrologyData;
         FParent.addChild(this.FShopExchangView);
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
            this.FSoulCombineView.LogicsPerform_EnterFrame();
            this.FStarPictureView.LogicsPerform_EnterFrame();
            this.FShopExchangView.LogicsPerform_EnterFrame();
         }
      }
      
      private function OnSelectPanel(param1:int, param2:Boolean = true) : void
      {
         if(param1 == CONST_DREAMS.DREAMS_TAB_0)
         {
            this.FAstrologyImagePanel.visible = param2;
            this.FSoulCombinePanle.visible = !param2;
         }
         else
         {
            this.FAstrologyImagePanel.visible = !param2;
            this.FSoulCombinePanle.visible = param2;
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
      
      private function OpenShop(param1:int) : void
      {
         this.FSelectShopType = param1;
         this.FShopExchangView.Data = this.FActivityAstrologyData;
         this.FShopExchangView.Show(param1);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.OnSelectPanel(_loc2_);
      }
      
      public function set ActivityAstrologyData(param1:TActivityAstrologyData) : void
      {
         this.FActivityAstrologyData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.FActivityAstrologyData = param3 as TActivityAstrologyData;
         this.FStarPictureView.Data = this.FActivityAstrologyData;
         this.FStarPictureView.ShowView();
         this.FSoulCombineView.Data = this.FActivityAstrologyData;
         this.FSoulCombineView.ShowView();
         if(this.FShopExchangView.Visible)
         {
            this.FShopExchangView.Data = this.FActivityAstrologyData;
            this.FShopExchangView.Show(this.FSelectShopType);
         }
      }
      
      public function PlayEffect(param1:int) : void
      {
         this.FStarPictureView.PlayEffect(param1);
      }
   }
}

