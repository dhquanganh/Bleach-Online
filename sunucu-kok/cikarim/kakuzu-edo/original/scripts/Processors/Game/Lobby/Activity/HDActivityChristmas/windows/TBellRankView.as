package Processors.Game.Lobby.Activity.HDActivityChristmas.windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDChristmas.TActivityChristmasWishData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_CHRISTMAS;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TBellRankView extends TProcessorLobbyWindow
   {
      
      public static const Award_Count:int = 4;
      
      public static const AWard_Line_Count:int = 3;
      
      protected var FMainUI:Sprite;
      
      protected var FCurrentRankTF:TextField;
      
      protected var FTotalBellValueTF:TextField;
      
      protected var FMaskSp:Sprite;
      
      protected var FClose:TUIButton;
      
      protected var FIsInit:Boolean;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      protected var FUIScrollBarBellRank:TScrollBar;
      
      protected var FPlayerRankItemList:Vector.<Sprite>;
      
      protected var FAwardItemList:Vector.<Sprite>;
      
      protected var FSlotVect:Vector.<TUISlot>;
      
      protected var FData:TActivityChristmasWishData;
      
      public function TBellRankView(param1:TUIComponent)
      {
         super(param1);
         this.Visible = false;
         this.FPlayerRankItemList = new Vector.<Sprite>();
         this.FAwardItemList = new Vector.<Sprite>();
         this.FSlotVect = new Vector.<TUISlot>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_BellRankMain") as Sprite;
         addChild(this.FMainUI);
         this.FTotalBellValueTF = this.FMainUI["TF_BellValue"];
         this.FCurrentRankTF = this.FMainUI["MC_RankList"]["TF_CurRank"];
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FMainUI["btn_close"];
         this.FClose.OnClick = this.CloseOnClick;
         this.FMainUI.x = (FUICore.StageWidth - this.FMainUI.width >> 1) - FParent.Parent.X + CONST_CHRISTMAS.TabWidth;
         this.FMainUI.y = (FUICore.StageHeight - this.FMainUI.height >> 1) - FParent.Parent.Y;
         this.FMaskSp = new Sprite();
         this.FMaskSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FMaskSp.x = -FParent.Parent.X;
         this.FMaskSp.y = -FParent.Parent.Y;
         this.addChildAt(this.FMaskSp,0);
         this.FUIScrollBarAward = new TScrollBar(this.FMainUI["MC_Award"][CONST_ACTIVITY.RESOURCE_Link_MC_List],176,false,-7,74);
         this.FUIScrollBarAward.Visible = false;
         this.FUIScrollBarBellRank = new TScrollBar(this.FMainUI["MC_RankList"][CONST_ACTIVITY.RESOURCE_Link_MC_List],135,false,-3,23);
         this.FUIScrollBarBellRank.Visible = false;
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
         _loc3_ = this.FData.ActivityConfig.RankNum;
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
         _loc2_ = int(this.FData.PlayerBellRankList.length);
         this.FUIScrollBarBellRank.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPlayerRankItemList[_loc1_];
            _loc3_["TF_Ranking"].text = this.FData.PlayerBellRankList[_loc1_].PlayerRank.toString();
            _loc3_["TF_Level"].text = this.FData.PlayerBellRankList[_loc1_].PlayerBellValue.toString();
            _loc3_["TF_Name"].text = this.FData.PlayerBellRankList[_loc1_].PlayerName;
            _loc3_.visible = true;
            this.FUIScrollBarBellRank.AddItem(_loc3_);
            _loc1_++;
         }
         this.FUIScrollBarBellRank.ScrollToUp();
         this.FUIScrollBarBellRank.Visible = true;
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
         this.FTotalBellValueTF.text = this.FData.TotalBellValue.toString();
         if(this.FData.PlayeCurrentRank == CONST_CHRISTMAS.NO_RANK)
         {
            _loc1_ = ">" + this.FData.ActivityConfig.RankNum;
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
      
      public function set Data(param1:TActivityChristmasWishData) : void
      {
         this.FData = param1;
      }
      
      public function Show() : void
      {
         if(!this.FIsInit)
         {
            this.ResourcesPerform_UIDispatch();
            this.FIsInit = true;
         }
         this.Visible = true;
         this.UpdateUI();
      }
      
      public function RefreshView() : void
      {
         this.UpdateBellRankBar();
         this.FTotalBellValueTF.text = this.FData.TotalBellValue.toString();
      }
      
      public function Hide() : void
      {
         this.Visible = false;
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

