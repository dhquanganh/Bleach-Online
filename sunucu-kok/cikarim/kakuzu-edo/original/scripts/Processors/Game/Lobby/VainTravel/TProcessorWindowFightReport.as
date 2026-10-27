package Processors.Game.Lobby.VainTravel
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelFightReport;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_VAINTRAVEL;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowFightReport extends TProcessorLobbyWindow
   {
      
      protected static const TabNum:int = 2;
      
      protected static const TabIndex_TodayFight:int = 0;
      
      protected static const TabIndex_NiceFight:int = 1;
      
      protected var FMainUI:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FBtnClose:TUIButton;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FCurrentTabIndex:int;
      
      protected var FBtnLookFight:Vector.<TUIButton>;
      
      protected var FVainTravelData:TVainTravelData;
      
      public function TProcessorWindowFightReport(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("VainTravelFightReportUI") as Sprite;
         addChild(this.FMainUI);
         this.FUITab = new TUITab(this);
         _loc2_ = TabNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMainUI["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FScroolBar = new TScrollBar(this.FMainUI["mc_list"],177,false);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["BtnClose"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnLookFight = new Vector.<TUIButton>();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FCurrentTabIndex = TabIndex_TodayFight;
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderFightReport() : void
      {
         this.ClearBtns(this.FBtnLookFight);
         this.FScroolBar.Clear();
         switch(this.FCurrentTabIndex)
         {
            case TabIndex_TodayFight:
               this.RenderTodayFightReport();
               break;
            case TabIndex_NiceFight:
               this.RenderNiceFightReport();
         }
      }
      
      protected function RenderTodayFightReport() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVainTravelFightReport = null;
         var _loc4_:String = null;
         var _loc5_:Sprite = null;
         _loc2_ = int(this.FVainTravelData.VainTravelTodayFightReports.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FVainTravelData.VainTravelTodayFightReports[_loc1_];
            _loc4_ = this.CreateFightReportInfor(_loc3_);
            _loc5_ = this.CreateScroolItem(_loc4_);
            this.FScroolBar.AddItem(_loc5_);
            _loc1_++;
         }
      }
      
      protected function RenderNiceFightReport() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVainTravelFightReport = null;
         var _loc4_:String = null;
         var _loc5_:Sprite = null;
         _loc2_ = int(this.FVainTravelData.VainTravelNiceFightReports.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FVainTravelData.VainTravelNiceFightReports[_loc1_];
            _loc4_ = this.CreateFightReportInfor(_loc3_);
            _loc5_ = this.CreateScroolItem(_loc4_);
            this.FScroolBar.AddItem(_loc5_);
            _loc1_++;
         }
      }
      
      protected function CreateFightReportInfor(param1:TVainTravelFightReport) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         switch(param1.FightResult)
         {
            case CONST_VAINTRAVEL.BattleResult_Lose:
               return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_10),param1.PlayerNameSources,param1.PlayerNameDestination);
            case CONST_VAINTRAVEL.BattleResult_Win:
               return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_09),param1.PlayerNameSources,param1.PlayerNameDestination);
            default:
               return null;
         }
      }
      
      protected function CreateScroolItem(param1:String) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("VainTravelFightReportItem") as Sprite;
         _loc2_["Infor"].text = param1;
         _loc3_ = new TUIButton();
         _loc3_.Substrate = _loc2_["btn_look"];
         _loc3_.OnClick = this.BtnLookFightOnClick;
         this.FBtnLookFight.push(_loc3_);
         return _loc2_;
      }
      
      protected function ClearBtns(param1:Vector.<TUIButton>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc4_.Dispose();
            _loc2_++;
         }
         param1.length = 0;
      }
      
      protected function BtnLookFightOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FBtnLookFight.indexOf(param1 as TUIButton);
         switch(this.FCurrentTabIndex)
         {
            case TabIndex_TodayFight:
               _loc4_ = this.FVainTravelData.VainTravelTodayFightReports[_loc3_].FightAddr;
               break;
            case TabIndex_NiceFight:
               _loc4_ = this.FVainTravelData.VainTravelNiceFightReports[_loc3_].FightAddr;
         }
         SExternalCore.NavigateToBattleReportUrl(_loc4_);
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.RenderFightReport();
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function Show(param1:TVainTravelData) : void
      {
         this.FVainTravelData = param1;
         this.RenderFightReport();
         Visible = true;
      }
      
      public function Reset() : void
      {
         this.FCurrentTabIndex = TabIndex_TodayFight;
         this.FUITab.SwithTagManual(this.FCurrentTabIndex);
      }
   }
}

