package Processors.Game.Lobby.Activity.HDDreamComeTrue.windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDDreamsComeTrue;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DREAMS;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorScoreRankView extends TUIComponent
   {
      
      public static const Award_Count:int = 4;
      
      public static const AWard_Line_Count:int = 6;
      
      protected var FMainUI:Sprite;
      
      protected var FCurrentRankTF:TextField;
      
      protected var FTotalScoreTF:TextField;
      
      protected var FMaskSp:Sprite;
      
      protected var FClose:TUIButton;
      
      protected var FIsInit:Boolean;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      protected var FUIScrollBarScoreRank:TScrollBar;
      
      protected var FPlayerRankItemList:Vector.<Sprite>;
      
      protected var FAwardItemList:Vector.<Sprite>;
      
      protected var FSlotVect:Vector.<TUISlot>;
      
      protected var FBins:TBins;
      
      protected var FConfig:THDDreamsComeTrue;
      
      protected var FData:TActivityDreamsData;
      
      public function TProcessorScoreRankView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         param2.visible = false;
         this.FPlayerRankItemList = new Vector.<Sprite>();
         this.FAwardItemList = new Vector.<Sprite>();
         this.FSlotVect = new Vector.<TUISlot>();
         this.InitWindow();
      }
      
      private function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         this.FTotalScoreTF = this.FMainUI["MC_RankList"]["TF_CurScore"];
         this.FCurrentRankTF = this.FMainUI["MC_RankList"]["TF_CurRank"];
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FMainUI["btn_close"];
         this.FClose.OnClick = this.CloseOnClick;
         this.FUIScrollBarAward = new TScrollBar(this.FMainUI["MC_Award"][CONST_ACTIVITY.RESOURCE_Link_MC_List],176,false,-7,74);
         this.FUIScrollBarAward.Visible = false;
         this.FUIScrollBarScoreRank = new TScrollBar(this.FMainUI["MC_RankList"][CONST_ACTIVITY.RESOURCE_Link_MC_List],135,false,-3,23);
         this.FUIScrollBarScoreRank.Visible = false;
         this.CreateMCRankElement();
      }
      
      private function CreateMCRankElement() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DreamsComeTrue);
         this.FConfig = this.FBins.GetDatebaseByIndex(0) as THDDreamsComeTrue;
         _loc3_ = this.FConfig.RankNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MC_RankListElement") as Sprite;
            this.FPlayerRankItemList[_loc2_] = _loc1_;
            this.FPlayerRankItemList[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = AWard_Line_Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MC_LevelRankAward") as Sprite;
            _loc6_ = Award_Count;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc4_ = new TUISlot(this);
               _loc4_.Resource = _loc1_[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc5_];
               _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
               _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
               TJadeCommon.InitSlot(_loc4_);
               _loc4_.Init();
               this.FSlotVect[_loc2_ * _loc6_ + _loc5_] = _loc4_;
               _loc5_++;
            }
            this.FAwardItemList[_loc2_] = _loc1_;
            this.FAwardItemList[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      protected function UpdateBellRankBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = int(this.FData.PlayerScoreRankList.length);
         this.FUIScrollBarScoreRank.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPlayerRankItemList[_loc1_];
            _loc3_["TF_Ranking"].text = this.FData.PlayerScoreRankList[_loc1_].PlayerRank.toString();
            _loc3_["TF_Level"].text = this.FData.PlayerScoreRankList[_loc1_].PlayerBellValue.toString();
            _loc3_["TF_Name"].text = this.FData.PlayerScoreRankList[_loc1_].PlayerName;
            _loc3_.visible = true;
            this.FUIScrollBarScoreRank.AddItem(_loc3_);
            _loc1_++;
         }
         this.FUIScrollBarScoreRank.ScrollToUp();
         this.FUIScrollBarScoreRank.Visible = true;
      }
      
      protected function UpdateAwardRankBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = int(this.FData.RankAwardList.length);
         this.FUIScrollBarAward.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAwardItemList[_loc1_];
            _loc3_["TF_Prompt_0"].text = this.FData.RankAwardList[_loc1_].RankInfo;
            _loc6_ = this.FData.RankAwardList[_loc1_].Inventories.Count;
            _loc6_ = _loc6_ > Award_Count ? Award_Count : _loc6_;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc4_ = this.FSlotVect[_loc1_ * _loc6_ + _loc5_];
               _loc4_.Context = null;
               _loc4_.Context = this.FData.RankAwardList[_loc1_].Inventories.GetInventoryByIndex(_loc5_);
               _loc5_++;
            }
            _loc3_.visible = true;
            this.FUIScrollBarAward.AddItem(_loc3_);
            _loc1_++;
         }
         this.FUIScrollBarAward.ScrollToUp();
         this.FUIScrollBarAward.Visible = true;
      }
      
      private function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Update();
            _loc1_++;
         }
      }
      
      private function UpdateUI() : void
      {
         var _loc1_:String = null;
         this.UpdateAwardRankBar();
         this.UpdateBellRankBar();
         this.FTotalScoreTF.text = this.FData.TotalScore.toString();
         if(this.FData.PlayeCurrentRank == CONST_DREAMS.NO_RANK)
         {
            _loc1_ = ">" + this.FConfig.RankNum;
         }
         else
         {
            _loc1_ = " " + this.FData.PlayeCurrentRank;
         }
         this.FCurrentRankTF.text = _loc1_;
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Hide();
      }
      
      public function set Data(param1:TActivityDreamsData) : void
      {
         this.FData = param1;
      }
      
      public function Show() : void
      {
         this.FMainUI.visible = true;
         this.UpdateUI();
      }
      
      public function RefreshView() : void
      {
         this.UpdateBellRankBar();
         this.FTotalScoreTF.text = this.FData.TotalScore.toString();
      }
      
      public function Hide() : void
      {
         this.FMainUI.visible = false;
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         if(this.visible)
         {
            this.UpdateExtractSlots();
         }
      }
   }
}

