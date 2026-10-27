package Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThanksTreasureData;
   import Logics.HDThanksgivingDay.TThanksTreasureVO;
   import Processors.Game.Common.Effects.TWheelEffect;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Components.TTreasure;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorThanksTreasureView extends TProcessorHDSingleWindowBase
   {
      
      protected const TreasureCount:uint = 10;
      
      protected var FData:TThanksTreasureData;
      
      protected var FLookBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FOneDigBtn:TUIButton;
      
      protected var FAllDigBtn:TUIButton;
      
      protected var FMallBtn:TUIButton;
      
      protected var FReportBtn:TUIButton;
      
      protected var FBuyHeroBtn:TUIButton;
      
      protected var FShowUI:TShowAwardUI;
      
      protected var FTreasures:Vector.<TTreasure>;
      
      protected var FWheelEffect:TWheelEffect;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FConfigFirstArrive:Boolean = true;
      
      public function TProcessorThanksTreasureView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:TTreasure = null;
         if(this.FTreasures != null)
         {
            for each(_loc1_ in this.FTreasures)
            {
               _loc1_.IsBomb = false;
            }
         }
         if(this.FWheelEffect != null)
         {
            this.FWheelEffect.ForcedStop(-1);
         }
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
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as TThanksTreasureData;
         if(this.FConfigFirstArrive)
         {
            this.SetupScoreShop();
            this.FConfigFirstArrive = false;
         }
         FScene["TF_Gold"].text = String(this.FData.Config.Rate);
         FScene["TF_Score"].text = String(this.FData.Score);
         FScene["TF_DigCount"].text = String(this.FData.RemainDig);
         this.UpdateTreasures();
         this.UpdateShowUI();
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ScoreItemStates);
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.ScoreMall)
         {
            _loc2_.push(_loc1_.costScore);
            _loc3_.push(_loc1_.limit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.ScoreShop,_loc2_,_loc3_);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TTreasure = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FWheelEffect != null)
         {
            this.FWheelEffect.Loop();
         }
         for each(_loc1_ in this.FTreasures)
         {
            _loc1_.Loop();
         }
      }
      
      protected function UpdateTreasures() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TThanksTreasureVO = null;
         var _loc3_:TTreasure = null;
         var _loc4_:Boolean = false;
         if(this.FData.StopIndex != -1)
         {
            this.FWheelEffect.Stop(this.FData.StopIndex);
         }
         if(this.FData.CurRefresh)
         {
            this.CloseAllTreasures();
            FScene["MC_Gift"]["MC_RefreshEffect"].gotoAndPlay(2);
         }
         _loc1_ = 0;
         while(_loc1_ < this.TreasureCount)
         {
            _loc2_ = this.FData.Map[_loc1_];
            _loc3_ = this.FTreasures[_loc1_];
            _loc4_ = _loc2_.State == TThanksTreasureVO.STATE_RECEIVE;
            _loc3_.Receive = _loc4_;
            if(_loc2_.Article == null)
            {
               _loc3_.IsBomb = true;
            }
            else
            {
               _loc3_.IsBomb = false;
               _loc3_.Context = _loc2_.Article;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateShowUI() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = FScene["MC_ShowUI"];
         this.FShowUI.SetData(this.FData.Config.HeroGift.showType,this.FData.Config.HeroGift.award,this.FData.Config.HeroGift.showID,TOverlayerGiftBox.TYPE_ALL);
         if(this.FData.HeroGiftState == Activity_AlreadyReceive)
         {
            _loc1_.MC_Get.visible = true;
            this.FBuyHeroBtn.Enabled = false;
         }
         else
         {
            _loc1_.MC_Get.visible = false;
            this.FBuyHeroBtn.Enabled = true;
         }
         _loc1_.TF_NeedGold.text = String(this.FData.Config.HeroGift.gold);
         this.FReportBtn.Visible = this.FData.Config.HeroGift.fightReportAddr != "";
      }
      
      protected function Change(param1:int, param2:int) : void
      {
         var _loc3_:TTreasure = null;
         for each(_loc3_ in this.FTreasures)
         {
            _loc3_.IsBright = false;
         }
         if(param2 != -1)
         {
            this.FTreasures[param2].IsBright = true;
         }
      }
      
      protected function LuckyDraw() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.TreasureIndex);
      }
      
      protected function StopToTarget(param1:int) : void
      {
         var _loc2_:TTreasure = null;
         var _loc3_:TThanksTreasureVO = null;
         if(param1 != -1)
         {
            _loc2_ = this.FTreasures[param1];
            _loc3_ = this.FData.Map[param1];
            _loc2_.IsOpen = true;
            _loc2_.PlayEffect();
            if(_loc2_.IsBomb)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.showBomb);
            }
         }
      }
      
      protected function CloseAllTreasures() : void
      {
         var _loc1_:TTreasure = null;
         for each(_loc1_ in this.FTreasures)
         {
            _loc1_.IsOpen = false;
            _loc1_.IsBright = false;
         }
      }
      
      protected function OpenAllTreasures() : void
      {
         var _loc1_:TTreasure = null;
         for each(_loc1_ in this.FTreasures)
         {
            _loc1_.IsOpen = true;
         }
      }
      
      protected function OnLookBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.OpenAllTreasures();
      }
      
      protected function OnRefreshBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FWheelEffect.IsStart)
         {
            GoldBuy(this.FData.Config.RefreshGold,this.RefreshOK);
         }
      }
      
      protected function OnOneDigBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FWheelEffect.IsStart)
         {
            if(this.FData.GameOver)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.showBomb);
               return;
            }
            if(this.FData.RemainDig > 0)
            {
               this.OneDigOK(null);
            }
            else
            {
               GoldBuy(this.FData.Config.TreasureGold,this.OneDigOK);
            }
         }
      }
      
      protected function OnAllDigBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FWheelEffect.IsStart)
         {
            if(this.FData.GameOver)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.showBomb);
               return;
            }
            if(this.FData.AllNotDig())
            {
               GoldBuy(this.FData.Config.OnekeyTreasureGold,this.AllDigOK);
            }
            else
            {
               SToolReward.ShowMessage(this.FData.Config.Language.allDig);
            }
         }
      }
      
      protected function OnMallBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ScoreItemStates);
      }
      
      protected function OnReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.HeroGift.fightReportAddr);
      }
      
      protected function OnBuyHeroBtnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.HeroGift.gold,this.BuyHeroOK);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreMall[param1];
         _loc2_ = uint(_loc3_.costScore);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.scoreLess);
         }
      }
      
      protected function RefreshOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RefreshIndex);
      }
      
      protected function OneDigOK(param1:Object) : void
      {
         this.FWheelEffect.Play();
      }
      
      protected function AllDigOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OneKeyIndex);
      }
      
      protected function BuyHeroOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.HeroGift.index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TTreasure = null;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FLookBtn = new TUIButton();
         this.FLookBtn.Substrate = FScene["Btn_Look"];
         this.FLookBtn.OnClick = this.OnLookBtnClick;
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = FScene["Btn_Refresh"];
         this.FRefreshBtn.OnClick = this.OnRefreshBtnClick;
         this.FOneDigBtn = new TUIButton();
         this.FOneDigBtn.Substrate = FScene["Btn_OneDig"];
         this.FOneDigBtn.OnClick = this.OnOneDigBtnClick;
         this.FAllDigBtn = new TUIButton();
         this.FAllDigBtn.Substrate = FScene["Btn_AllDig"];
         this.FAllDigBtn.OnClick = this.OnAllDigBtnClick;
         this.FMallBtn = new TUIButton();
         this.FMallBtn.Substrate = FScene["Btn_Mall"];
         this.FMallBtn.OnClick = this.OnMallBtnClick;
         this.FReportBtn = new TUIButton();
         this.FReportBtn.Substrate = FScene["MC_ShowUI"]["Btn_Report"];
         this.FReportBtn.OnClick = this.OnReportBtnClick;
         this.FBuyHeroBtn = new TUIButton();
         this.FBuyHeroBtn.Substrate = FScene["MC_ShowUI"]["Btn_Buy"];
         this.FBuyHeroBtn.OnClick = this.OnBuyHeroBtnClick;
         this.FShowUI = new TShowAwardUI(this);
         this.FShowUI.UIDispatch(FScene["MC_ShowUI"]);
         this.FTreasures = new Vector.<TTreasure>(this.TreasureCount);
         _loc2_ = 0;
         while(_loc2_ < this.TreasureCount)
         {
            _loc3_ = new TTreasure(this);
            _loc3_.InitUI(FScene["MC_Gift"]["MC_Gift_" + _loc2_]);
            this.FTreasures[_loc2_] = _loc3_;
            _loc3_.IsOpen = false;
            _loc2_++;
         }
         this.FWheelEffect = new TWheelEffect();
         this.FWheelEffect.Init(this.TreasureCount,46,1,2,3);
         this.FWheelEffect.ChangeCall = this.Change;
         this.FWheelEffect.RandomTurnsFinishCall = this.LuckyDraw;
         this.FWheelEffect.StopToTargetCall = this.StopToTarget;
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_ThanksTreasureShop") as MovieClip;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(_loc4_);
         FScene["MC_Gift"]["MC_RefreshEffect"].mouseEnabled = false;
      }
   }
}

