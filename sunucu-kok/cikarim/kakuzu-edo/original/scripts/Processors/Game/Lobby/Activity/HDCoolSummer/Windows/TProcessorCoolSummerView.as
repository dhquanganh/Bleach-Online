package Processors.Game.Lobby.Activity.HDCoolSummer.Windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.SelectBox.TSelectBox;
   import Components.SelectBox.TSelectBoxMulti;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDCoolSummer.TCoolSummerData;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class TProcessorCoolSummerView extends TProcessorHDSingleWindowBase
   {
      
      private var FFeastHero:uint = 0;
      
      private var FFeastPending:int = 0;
      
      protected const ChooseMax:uint = 3;
      
      protected const State_Geted:int = -1;
      
      protected const State_Open:int = 1;
      
      protected const State_Close:int = 0;
      
      protected const MinScrollDistance:Number = 202;
      
      protected const ItemStamp:Number = 3.55;
      
      protected const SingleItemStamp:Number = 46;
      
      protected var FAllOpenBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FChooseOKBtn:TUIButton;
      
      protected var FScoreShopBtn:TUIButton;
      
      protected var FReportBtn:TUIButton;
      
      protected var FExchangeBtn:TUIButton;
      
      protected var FData:TCoolSummerData;
      
      protected var FRandomSlots:Vector.<TUISlot>;
      
      protected var FChooseSlots:Vector.<TUISlot>;
      
      protected var FAllSlots:Vector.<TUISlot>;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FSelectBox:TSelectBoxMulti;
      
      protected var FCurrentClickItemPostIndex:uint;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FConfigFirstArrive:Boolean = true;
      
      public function TProcessorCoolSummerView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
         this.FFeastHero = 0;
         this.FFeastPending = 0;
         var _loc1_:MovieClip = null;
         if(FScene != null)
         {
            _loc1_ = FScene["MC_RandomItemsPanel"];
            this.ClearSelectBox();
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.UpdateFeastTime();
      }
      
      private function UpdateFeastTime() : void
      {
         if(this.FData == null)
         {
            return;
         }
         var end:uint = uint(this.FData.Config.MainAward.eventEnd);
         if(end > 0)
         {
            ProcessorFormatActivityTimeFromNowOn(end);
            ProcessorFormatActivityCountDown(end);
         }
         else
         {
            FIsInitCoolingTime = false;
            if(FTF_OpenTime != null)
            {
               FTF_OpenTime.text = "Ongoing / Daily reset at midnight";
            }
            if(FTF_CoolingTime != null)
            {
               FTF_CoolingTime.text = "--";
            }
         }
      }
      
      private function BeginFeastRequest() : Boolean
      {
         if(getTimer() < this.FFeastPending)
         {
            return false;
         }
         this.FFeastPending = getTimer() + 3000;
         return true;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         this.FFeastPending = 0;
         this.FData = param1 as TCoolSummerData;
         this.UpdateFeastTime();
         if(this.FConfigFirstArrive)
         {
            this.CreateScrollBar();
            this.SetupScoreShop();
            this.CreateUI();
            this.FConfigFirstArrive = false;
         }
         _loc2_ = FScene["MC_RandomItemsPanel"];
         _loc2_.TF_OpenOnceCost.text = String(this.FData.Config.OpenOnce.gold);
         _loc4_ = this.FData.RandomItemIndexs.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.FRandomSlots[_loc5_];
            _loc6_.Context = this.FData.AllItems.GetInventoryByIndex(this.FData.RandomItemIndexs[_loc5_]);
            _loc3_ = _loc2_["MC_RandomItem_" + _loc5_];
            _loc7_ = this.FData.RandomItemStates[_loc5_];
            if(_loc7_ == this.State_Geted)
            {
               _loc3_.MC_Geted.visible = true;
               _loc6_.Visible = true;
               _loc3_.MC_Bg.gotoAndStop(2);
               _loc3_.MC_Bg.mouseChildren = _loc3_.MC_Bg.mouseEnabled = false;
            }
            else if(_loc7_ == this.State_Open)
            {
               _loc3_.MC_Geted.visible = false;
               _loc6_.Visible = true;
               _loc3_.MC_Bg.gotoAndStop(2);
               _loc3_.MC_Bg.mouseChildren = _loc3_.MC_Bg.mouseEnabled = false;
            }
            else
            {
               _loc3_.MC_Geted.visible = false;
               _loc6_.Visible = false;
               _loc3_.MC_Bg.gotoAndStop(1);
               _loc3_.MC_Bg.mouseChildren = _loc3_.MC_Bg.mouseEnabled = true;
            }
            _loc5_++;
         }
         _loc2_.TF_AllOpenCost.text = this.GetAllOpenCost().toString();
         _loc2_.TF_FreeCount.text = this.FData.FreeCount.toString();
         _loc2_.TF_RefreshCost.text = String(this.FData.Config.Refresh.gold);
         _loc2_ = FScene["MC_ChoosePanel"];
         _loc2_.TF_Score.text = this.FData.Score.toString();
         if(this.FData.LockItems.length > 0)
         {
            _loc4_ = this.FData.LockItems.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc9_ = this.FData.LockItems[_loc5_];
               this.FSelectBox.SetSelectByIndex(_loc9_);
               _loc5_++;
            }
            _loc4_ = uint(this.FData.AllItems.Count);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.EnableSelectBox((this.FScrollBar.Items[_loc5_] as MovieClip).MC_Select,false);
               _loc5_++;
            }
            this.FChooseOKBtn.Enabled = false;
         }
         else if(this.FData.UpdateSelectItems)
         {
            this.ClearSelectBox();
            _loc2_.TF_ChooseCost.text = "0";
            this.FChooseOKBtn.Enabled = true;
            this.FData.UpdateSelectItems = false;
         }
         this.UpdateChoose();
         _loc2_ = FScene["MC_MainAwardPanel"];
         if(this.FFeastHero != uint(this.FData.Config.MainAward.showID))
         {
            this.FFeastHero = uint(this.FData.Config.MainAward.showID);
            this.FShowAwardUI.SetData(this.FData.Config.MainAward.showType,this.FData.Config.MainAward.awardID,this.FData.Config.MainAward.showID,TOverlayerGiftBox.TYPE_ALL);
         }
         this.FReportBtn.Visible = this.FData.Config.MainAward.fightReportAddr != "";
         if(this.FData.MainAwardState == this.State_Geted)
         {
            this.FExchangeBtn.Enabled = false;
            _loc2_.MC_Receive.visible = true;
         }
         else
         {
            _loc2_.MC_Receive.visible = false;
            if(this.FData.Score >= this.FData.Config.MainAward.score)
            {
               this.FExchangeBtn.Enabled = true;
            }
            else
            {
               this.FExchangeBtn.Enabled = false;
            }
         }
         _loc2_.TF_MainScore.text = String(this.FData.Config.MainAward.score);
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ScoreItemStates);
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.ScoreShop)
         {
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.ScoreShop,_loc2_,_loc3_);
      }
      
      protected function CreateUI() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:TUISlot = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc1_ = FScene["MC_RandomItemsPanel"];
         _loc5_ = this.FData.RandomItemIndexs.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = _loc1_["MC_RandomItem_" + _loc4_];
            _loc2_.Pos = _loc4_;
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_.MC_Slot;
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FRandomSlots[_loc4_] = _loc3_;
            _loc2_.MC_Effect.mouseChildren = _loc2_.MC_Effect.mouseEnabled = false;
            _loc2_.MC_Geted.mouseChildren = _loc2_.MC_Geted.mouseEnabled = false;
            _loc2_.MC_Bg.buttonMode = true;
            _loc4_++;
         }
      }
      
      protected function UpdateChoose() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TUISlot = null;
         _loc1_ = FScene["MC_ChoosePanel"];
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.ChooseMax)
         {
            _loc7_ = this.FChooseSlots[_loc3_];
            _loc7_.Context = null;
            _loc3_++;
         }
         _loc4_ = this.FSelectBox.TasksState.length;
         _loc6_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(this.FSelectBox.TasksState[_loc3_]);
            if(_loc5_ == TSelectBox.State_Select)
            {
               _loc2_ += this.FData.Config.Repository[_loc3_].gold;
               this.FChooseSlots[_loc6_].Context = this.FData.AllItems.GetInventoryByIndex(_loc3_);
               _loc6_++;
            }
            _loc3_++;
         }
         _loc1_.TF_ChooseCost.text = _loc2_.toString();
         if(this.FData.LockItems.length == 0)
         {
            this.FChooseOKBtn.Enabled = _loc6_ > 0;
         }
      }
      
      protected function EnableSelectBox(param1:MovieClip, param2:Boolean) : void
      {
         if(param2)
         {
            param1.filters = [];
         }
         else
         {
            param1.filters = [TUtilityFilter.gBlackFilters];
         }
         param1.mouseChildren = param1.mouseEnabled = param2;
      }
      
      protected function EnableSelectBoxAll(param1:Boolean, param2:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         _loc4_ = uint(this.FScrollBar.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FScrollBar.Items[_loc3_] as MovieClip;
            _loc6_ = _loc5_.MC_Select;
            if(param2.indexOf(_loc3_) == -1)
            {
               this.EnableSelectBox(_loc6_,param1);
            }
            _loc3_++;
         }
      }
      
      protected function GetAllOpenCost() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc1_ = uint(this.FData.Config.OpenOnce.gold);
         _loc2_ = 0;
         for each(_loc3_ in this.FData.RandomItemStates)
         {
            if(_loc3_ == this.State_Close)
            {
               _loc2_++;
            }
         }
         _loc2_ = Math.max(0,_loc2_ -= this.FData.FreeCount);
         return _loc1_ * _loc2_ * (this.FData.Config.OpenAll.discount / 100);
      }
      
      protected function CreateItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TInventory = null;
         _loc2_ = uint(this.FData.AllItems.Count);
         this.FSelectBox = new TSelectBoxMulti();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_CoolSummerBar") as MovieClip;
            _loc5_ = this.FData.AllItems.GetInventoryByIndex(_loc1_);
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slos"];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            _loc4_.Context = _loc5_;
            this.FAllSlots[_loc1_] = _loc4_;
            _loc3_.TF_Name.text = _loc5_.Name;
            _loc3_.TF_Gold.text = String(this.FData.Config.Repository[_loc1_].gold);
            this.FSelectBox.SetTaskByIndex(_loc1_,_loc3_.MC_Select);
            this.FScrollBar.AddItem(_loc3_);
            _loc1_++;
         }
         this.FSelectBox.Init();
         this.FSelectBox.CallBackOnSelect = this.CallBackOnSelect;
         this.FSelectBox.CallBackOnUnselect = this.CallBackOnUnselect;
         this.FSelectBox.UnselectAll();
      }
      
      protected function CreateScrollBar() : void
      {
         this.FScrollBar = new TScrollBar(FScene["MC_ChoosePanel"]["MC_RollScene"],this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
         this.CreateItem();
         this.FScrollBar.ScrollToUp();
         this.FScrollBar.Visible = true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         this.UpdateSlots(this.FRandomSlots);
         this.UpdateSlots(this.FChooseSlots);
         this.UpdateSlots(this.FAllSlots);
      }
      
      protected function UpdateSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:TUISlot = null;
         for each(_loc2_ in param1)
         {
            _loc2_.Update();
         }
      }
      
      protected function ClearSelectBox() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         _loc1_ = uint(this.FData.AllItems.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FScrollBar.Items[_loc2_] as MovieClip;
            _loc4_ = _loc3_.MC_Select;
            this.EnableSelectBox(_loc4_,true);
            this.FSelectBox.SetUnselectByIndex(_loc2_);
            _loc2_++;
         }
      }
      
      protected function OnAllOpenBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = this.GetAllOpenCost();
         if(_loc3_ != 0)
         {
            GoldBuy(_loc3_,this.OnAllOpenBtnClickOK);
         }
         else
         {
            this.OnAllOpenBtnClickOK(null);
         }
      }
      
      protected function OnRefreshBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(this.FData.Config.Refresh.gold);
         if(_loc3_ != 0)
         {
            GoldBuy(_loc3_,this.OnRefreshBtnClickOK);
         }
         else
         {
            this.OnRefreshBtnClickOK(null);
         }
      }
      
      protected function OnChooseOKBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         _loc3_ = FScene["MC_ChoosePanel"];
         _loc4_ = uint(_loc3_.TF_ChooseCost.text);
         if(_loc4_ > 0)
         {
            GoldBuy(_loc4_,this.OnChooseOKBtnClickOK);
         }
         else
         {
            this.OnChooseOKBtnClickOK(null);
         }
      }
      
      protected function OnScoreShopBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ScoreItemStates);
      }
      
      protected function OnReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.MainAward.fightReportAddr);
      }
      
      protected function OnExchangeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.BeginFeastRequest())
         {
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.MainAward.index,0,Vector.<int>([int(this.FData.Config.MainAward.revision)]));
      }
      
      protected function CallBackOnSelect(param1:int, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         this.FSelectBox.SetSelectByIndex(param2);
         _loc4_ = [];
         _loc3_ = 0;
         _loc5_ = 0;
         for each(param1 in this.FSelectBox.TasksState)
         {
            if(param1 == TSelectBox.State_Select)
            {
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            _loc5_++;
         }
         if(_loc3_ >= this.ChooseMax)
         {
            this.EnableSelectBoxAll(false,_loc4_);
         }
         this.UpdateChoose();
      }
      
      protected function CallBackOnUnselect(param1:int, param2:int) : void
      {
         this.FSelectBox.SetUnselectByIndex(param2);
         this.EnableSelectBoxAll(true,[]);
         this.UpdateChoose();
      }
      
      protected function OnRandomItemsPanelClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.FData.FreeCount > 0 ? 0 : uint(this.FData.Config.OpenOnce.gold);
         if(param1.target.name == "MC_Bg")
         {
            _loc3_ = param1.target.parent as MovieClip;
            this.FCurrentClickItemPostIndex = this.FData.Config.ShellIndex[_loc3_.Pos];
            if(_loc2_ == 0)
            {
               this.OnRandomItemClickOk(null);
            }
            else
            {
               GoldBuy(_loc2_,this.OnRandomItemClickOk);
            }
         }
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreShop[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.scoreLess);
         }
      }
      
      protected function OnAllOpenBtnClickOK(param1:Object) : void
      {
         if(!this.BeginFeastRequest())
         {
            return;
         }
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         _loc4_ = FScene["MC_RandomItemsPanel"];
         _loc3_ = this.FData.RandomItemIndexs.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FData.RandomItemStates[_loc2_];
            if(_loc5_ == this.State_Close)
            {
               _loc4_["MC_RandomItem_" + _loc2_]["MC_Effect"].gotoAndPlay(2);
            }
            _loc2_++;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OpenAll.index);
      }
      
      protected function OnRefreshBtnClickOK(param1:Object) : void
      {
         if(!this.BeginFeastRequest())
         {
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Refresh.index);
      }
      
      protected function OnChooseOKBtnClickOK(param1:Object) : void
      {
         if(!this.BeginFeastRequest())
         {
            return;
         }
         var _loc2_:Vector.<int> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         _loc2_ = new Vector.<int>();
         _loc4_ = this.FSelectBox.TasksState.length;
         _loc5_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FSelectBox.TasksState[_loc3_];
            if(_loc6_ == TSelectBox.State_Select)
            {
               _loc7_ = uint(this.FData.PosToAward[_loc3_]);
               _loc2_.push(_loc7_);
               _loc2_.push(_loc5_);
               _loc5_++;
            }
            _loc3_++;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Choose,0,_loc2_);
      }
      
      protected function OnRandomItemClickOk(param1:Object) : void
      {
         if(!this.BeginFeastRequest())
         {
            return;
         }
         var _loc2_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurrentClickItemPostIndex);
         _loc2_ = this.FData.Config.ShellIndex.indexOf(this.FCurrentClickItemPostIndex);
         FScene["MC_RandomItemsPanel"]["MC_RandomItem_" + _loc2_]["MC_Effect"].gotoAndPlay(2);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         super.InitWindow(param1);
         this.FRandomSlots = new Vector.<TUISlot>();
         this.FChooseSlots = new Vector.<TUISlot>();
         this.FAllSlots = new Vector.<TUISlot>();
         this.FShowAwardUI = new TShowAwardUI(this);
         _loc2_ = FScene["MC_RandomItemsPanel"];
         this.FAllOpenBtn = new TUIButton();
         this.FAllOpenBtn.Substrate = _loc2_.Btn_AllOpen;
         this.FAllOpenBtn.OnClick = this.OnAllOpenBtnClick;
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = _loc2_.Btn_Refresh;
         this.FRefreshBtn.OnClick = this.OnRefreshBtnClick;
         _loc2_.addEventListener(MouseEvent.CLICK,this.OnRandomItemsPanelClick);
         _loc2_ = FScene["MC_ChoosePanel"];
         this.FChooseOKBtn = new TUIButton();
         this.FChooseOKBtn.Substrate = _loc2_.Btn_ChooseOK;
         this.FChooseOKBtn.OnClick = this.OnChooseOKBtnClick;
         this.FScoreShopBtn = new TUIButton();
         this.FScoreShopBtn.Substrate = _loc2_.Btn_ScoreShop;
         this.FScoreShopBtn.OnClick = this.OnScoreShopBtnClick;
         _loc5_ = 0;
         while(_loc5_ < this.ChooseMax)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc2_["MC_ChooseSlot_" + _loc5_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FChooseSlots[_loc5_] = _loc4_;
            _loc5_++;
         }
         _loc2_ = FScene["MC_MainAwardPanel"];
         this.FReportBtn = new TUIButton();
         this.FReportBtn.Substrate = _loc2_.Btn_Report;
         this.FReportBtn.OnClick = this.OnReportBtnClick;
         this.FExchangeBtn = new TUIButton();
         this.FExchangeBtn.Substrate = _loc2_.Btn_Exchange;
         this.FExchangeBtn.OnClick = this.OnExchangeBtnClick;
         this.FShowAwardUI.UIDispatch(_loc2_.MC_ShowAwardUI);
         _loc2_.MC_Receive.mouseChildren = _loc2_.MC_Receive.mouseEnabled = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance("MC_CoolSummerExchange") as MovieClip;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(_loc7_);
      }
   }
}

