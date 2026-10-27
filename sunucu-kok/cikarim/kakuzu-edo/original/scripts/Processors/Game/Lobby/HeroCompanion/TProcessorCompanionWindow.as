package Processors.Game.Lobby.HeroCompanion
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.HeroCompanion.CardEmploy.TProcessorCompanionEmploy;
   import Processors.Game.Lobby.HeroCompanion.CardMap.TProcessorCompanionMap;
   import Processors.Game.Lobby.HeroCompanion.CardReforging.TProcessorCompanionReforging;
   import Processors.Game.Lobby.HeroCompanion.CardSeat.TProcessorCompanionSeat;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardTip;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorCompanionWindow extends TProcessorLobbyWindows
   {
      
      protected static const Tab_Num:int = 4;
      
      protected var FBtnClose:TUIButton;
      
      protected var FProcessorViews:Vector.<TCompanionBaseView>;
      
      protected var FProcessorEmployView:TProcessorCompanionEmploy;
      
      protected var FProcessorSeatView:TProcessorCompanionSeat;
      
      protected var FProcessorMapView:TProcessorCompanionMap;
      
      protected var FProcessorReforgingView:TProcessorCompanionReforging;
      
      protected var FCardTip:TCompanionCardTip;
      
      protected var FHint:THint;
      
      protected var FMainUI:Sprite;
      
      protected var FTab:TUITab;
      
      protected var FData:THeroCompanionData;
      
      protected var FTabIndex:int;
      
      public function TProcessorCompanionWindow(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorEmployView = new TProcessorCompanionEmploy(this);
         this.FProcessorEmployView.TipOnOver = this.TipOnOver;
         this.FProcessorEmployView.TipOnOut = this.TipOnOut;
         this.FProcessorSeatView = new TProcessorCompanionSeat(this);
         this.FProcessorSeatView.TipOnOver = this.TipOnOver;
         this.FProcessorSeatView.TipOnOut = this.TipOnOut;
         this.FProcessorMapView = new TProcessorCompanionMap(this);
         this.FProcessorMapView.TipOnOver = this.TipOnOver;
         this.FProcessorMapView.TipOnOut = this.TipOnOut;
         this.FProcessorReforgingView = new TProcessorCompanionReforging(this);
         this.FProcessorReforgingView.TipOnOver = this.TipOnOver;
         this.FProcessorReforgingView.TipOnOut = this.TipOnOut;
         this.FProcessorViews = Vector.<TCompanionBaseView>([this.FProcessorEmployView,this.FProcessorSeatView,this.FProcessorMapView,this.FProcessorReforgingView]);
         this.FCardTip = new TCompanionCardTip(param1);
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_HeroCompanion) as Sprite;
         addChild(this.FMainUI);
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         this.FProcessorEmployView.UIDispatch(this.FMainUI["MC_Employ"]);
         this.FProcessorSeatView.UIDispatch(this.FMainUI["MC_Seat"]);
         this.FProcessorMapView.UIDispatch(this.FMainUI["MC_Map"]);
         this.FProcessorReforgingView.UIDispatch(this.FMainUI["MC_Reforging"]);
         this.FTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < Tab_Num)
         {
            this.FTab.SetTabByIndex(this.FMainUI["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTab.OnSwitch = this.TabOnSwitch;
         this.FTab.Init();
         this.FTab.SwithTagManual(0);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.WindowOnClose;
      }
      
      private function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      private function TabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FTabIndex = param1;
         _loc3_ = Tab_Num;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FProcessorViews[_loc2_].Visible = false;
            _loc2_++;
         }
         this.FProcessorViews[param1].Visible = true;
         if(this.FProcessorViews[param1].NeedRefresh)
         {
            this.FProcessorViews[param1].SetData(this.FData);
         }
      }
      
      protected function TipOnOver(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 is TCompanionCard)
         {
            this.FCardTip.SetData(param1 as TCompanionCard);
            this.FCardTip.X = FUICore.mouseX;
            this.FCardTip.Y = FUICore.mouseY;
            this.FCardTip.Visible = true;
         }
      }
      
      protected function TipOnOut() : void
      {
         this.FCardTip.Visible = false;
         SUtilityOverLayer.UIComponentsHintOnOut(FParent,this.FHint);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.FCardTip.Update();
      }
      
      public function UpdateView(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FData = param1;
         _loc3_ = Tab_Num;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FProcessorViews[_loc2_].NeedRefresh = true;
            _loc2_++;
         }
         if(this.FProcessorViews[this.FTabIndex].Visible)
         {
            this.FProcessorViews[this.FTabIndex].SetData(this.FData);
         }
         this.FCardTip.InitData(param1);
      }
      
      public function ShowEmployAnimation() : void
      {
         this.FProcessorEmployView.ShowResult();
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FCardTip.Load();
      }
   }
}

