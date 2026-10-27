package Processors.Game.Lobby.Activity.HDNewYear2016Two.windows
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDNewYear2016Chess;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Chess;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowNewYear2016Chess extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Super:TUIButton;
      
      protected var FMC_DiceOut:MovieClip;
      
      protected var FMC_DiceIn:MovieClip;
      
      protected var FMC_DiceBarInner:MovieClip;
      
      protected var FBtn_Dices:Vector.<TUIButton>;
      
      protected var FBtn_Normal:TUIButton;
      
      protected var FBtn_Reflash:TUIButton;
      
      protected var FIsReflash:Boolean;
      
      protected var FBtn_OneKey:TUIButton;
      
      protected var FBtn_ShowRewards:TUIButton;
      
      protected var FBtn_ShowShop:TUIButton;
      
      protected var FElapse:int;
      
      protected var FPlayer:MovieClip;
      
      protected var FLastPos:uint;
      
      protected var FTables:Vector.<Sprite>;
      
      protected var FMC_NormalMoive:MovieClip;
      
      protected var FMC_Chesstable:Sprite;
      
      protected var FTemp:Vector.<int>;
      
      protected var FScore:int;
      
      protected var FSP_ShowUI:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_GetPrize:TUIButton;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_ShowUICost:TextField;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FAwardShow:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FPage:TUIPage;
      
      protected var FClose:TUIButton;
      
      protected var FConfig:THDNewYear2016Chess;
      
      protected var FData:TNewYear2016Chess;
      
      public function TProcessorHDWindowNewYear2016Chess(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2016Chess;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Condition"].text = this.FConfig.OneKeyArrive.score + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TNewYear2016Chess;
         FScene["TF_Score"].text = this.FData.Score.toString();
         this.FPlayer.gotoAndStop(this.FData.CurPos + 1);
         this.PlayDice(this.FData.CurPos);
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
         this.UpdateJackPoint();
         this.FPage.TotalQuantity = this.FData.AwardShow.Count;
         this.FPage.Update();
         this.FBtn_Reflash.Enabled = this.FBtn_OneKey.Enabled = this.FData.CurPos == 0 ? true : false;
         _loc3_ = 12;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.AwardShow.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         _loc3_ = this.FConfig.AwardBins.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTables[this.FConfig.AwardBins[_loc2_].pos - 1]["SP_Mouse"].addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorTableOnMove);
            this.FTables[this.FConfig.AwardBins[_loc2_].pos - 1]["SP_Mouse"].addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorTableOnOut);
            this.FTables[this.FConfig.AwardBins[_loc2_].pos - 1].mouseChildren = true;
            this.FTables[this.FConfig.AwardBins[_loc2_].pos - 1].mouseEnabled = true;
            _loc2_++;
         }
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FLastPos = this.FData.CurPos;
            this.FScore = this.FData.Score;
            this.FIsinit = true;
         }
         this.FScore = this.FData.Score - this.FScore;
         if(this.FScore > 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + this.FScore);
         }
         this.FScore = this.FData.Score;
         if(this.FIsReflash)
         {
            _loc3_ = this.FConfig.AwardBins.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FTables[this.FConfig.AwardBins[_loc2_].pos - 1]["MC_mv"].play();
               _loc2_++;
            }
            this.FIsReflash = false;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible || this.FData == null)
         {
            return;
         }
         this.FElapse = this.FData.Time - STimingCore.ServerTick;
         FScene["Btn_Normal"]["TF_CoolDown"].text = TUtilityTiming.fomatTimeTwo(this.FElapse).toString();
         FScene["Btn_Normal"]["TF_CoolDown"].visible = this.FElapse > 0 ? true : false;
         _loc1_ = 12;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function ShowDiceBarOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FMC_DiceOut.currentFrame == this.FMC_DiceOut.totalFrames)
         {
            this.FMC_DiceOut.gotoAndStop(1);
            this.FMC_DiceIn.visible = true;
            this.FMC_DiceIn.gotoAndPlay(1);
         }
         else
         {
            this.FMC_DiceIn.visible = false;
            this.FMC_DiceOut.gotoAndPlay(1);
         }
      }
      
      protected function PlayDice(param1:uint) : void
      {
         if(param1 == 0)
         {
            this.FLastPos = 0;
            return;
         }
         if(param1 == this.FLastPos || !this.FIsinit)
         {
            return;
         }
         this.FMC_NormalMoive["MC_DiceNum"].gotoAndStop(param1 - this.FLastPos);
         this.FMC_NormalMoive.gotoAndPlay(1);
         this.FLastPos = this.FData.CurPos;
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FConfig.ScoreShop)
         {
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.ScoreShop,_loc2_,_loc3_);
      }
      
      protected function NormalOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FElapse > 0)
         {
            GoldBuy(this.FConfig.OrdinaryDice.gold,this.GoldNormalOnClick);
         }
         else
         {
            this.GoldNormalOnClick(null);
         }
      }
      
      protected function GoldNormalOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OrdinaryDice.index);
      }
      
      protected function SuperDiceOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FTemp = new Vector.<int>(1);
         this.FTemp[0] = param1.Tag + 1;
         GoldBuy(this.FConfig.SuperDice.gold,this.GoldSuperDiceOnClick);
      }
      
      protected function GoldSuperDiceOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.SuperDice.index,0,this.FTemp);
      }
      
      protected function ReflashOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.Refresh.gold,this.GoldReflashOnClick);
      }
      
      protected function GoldReflashOnClick(param1:Object) : void
      {
         this.FIsReflash = true;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Refresh.index);
      }
      
      protected function OneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.OneKeyArrive.gold,this.GoldOneKeyOnClick);
      }
      
      protected function GoldOneKeyOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OneKeyArrive.index);
      }
      
      protected function ShowAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FAwardShow.visible = true;
         this.UpdatePage();
      }
      
      protected function AwardShowOnClose(param1:Object, param2:MouseEvent) : void
      {
         this.FAwardShow.visible = false;
      }
      
      protected function ProcessorGetPrizeOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.BigAward.gold,this.GoldProcessorGetPrizeOnClick);
      }
      
      protected function GoldProcessorGetPrizeOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BigAward.index);
      }
      
      protected function ProcessorReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToBattleReportUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      protected function ShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
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
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
         }
      }
      
      protected function UpdateJackPoint() : void
      {
         this.FSP_ShowUI.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         this.FTF_ShowUICost.text = this.FData.Config.BigAward.gold + "";
         if(this.FData.JackStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FBtn_GetPrize.Visible = false;
         }
         else
         {
            this.FSP_AlreadyGet.visible = false;
            this.FBtn_GetPrize.Visible = true;
         }
      }
      
      protected function ProcessorTableOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = uint(param1.currentTarget.parent.name.split("_")[2]);
         _loc3_ = this.FConfig.AwardBins.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.FConfig.AwardBins[_loc4_].pos - 1 == _loc2_)
            {
               _loc5_ = _loc4_;
            }
            _loc4_++;
         }
         ProcessorOnGiftBoxMove(this,this.FData.Awards[_loc5_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorTableOnOut(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc2_ < this.FData.AwardShow.Count)
            {
               this.FSlots[_loc1_].Visible = true;
               this.FSlots[_loc1_] = this.FSlots[_loc1_];
               this.FSlots[_loc1_].Context = this.FData.AwardShow.GetInventoryByIndex(_loc2_);
            }
            else
            {
               this.FSlots[_loc1_].Visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         FPageIndex = param2;
         this.UpdatePage();
      }
      
      protected function LocalToGlobalIndex(param1:uint) : uint
      {
         return FPageIndex * 12 + param1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         super.InitWindow(param1);
         this.FBtn_Super = new TUIButton();
         this.FBtn_Super.Substrate = FScene["MC_DiceOut"]["Btn_Super"];
         this.FBtn_Super.OnClick = this.ShowDiceBarOnClick;
         this.FMC_DiceOut = FScene["MC_DiceOut"];
         this.FMC_DiceIn = FScene["MC_SuperBar"];
         this.FMC_DiceIn.visible = false;
         this.FMC_DiceBarInner = this.FMC_DiceOut["MC_DiceBarInner"];
         _loc2_ = 6;
         this.FBtn_Dices = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_DiceBarInner["Btn_Dice_" + _loc3_];
            _loc4_.OnClick = this.SuperDiceOnClick;
            _loc4_.Tag = _loc3_;
            this.FBtn_Dices[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FBtn_Normal = new TUIButton();
         this.FBtn_Normal.Substrate = FScene["Btn_Normal"];
         this.FBtn_Normal.OnClick = this.NormalOnClick;
         this.FBtn_Reflash = new TUIButton();
         this.FBtn_Reflash.Substrate = FScene["Btn_Reflash"];
         this.FBtn_Reflash.OnClick = this.ReflashOnClick;
         this.FBtn_OneKey = new TUIButton();
         this.FBtn_OneKey.Substrate = FScene["Btn_OneKey"];
         this.FBtn_OneKey.OnClick = this.OneKeyOnClick;
         this.FBtn_ShowRewards = new TUIButton();
         this.FBtn_ShowRewards.Substrate = FScene["Btn_ShowAward"];
         this.FBtn_ShowRewards.OnClick = this.ShowAwardOnClick;
         this.FBtn_ShowShop = new TUIButton();
         this.FBtn_ShowShop.Substrate = FScene["Btn_ShowShop"];
         this.FBtn_ShowShop.OnClick = this.ShowShopOnClick;
         this.FPlayer = new MovieClip();
         this.FPlayer = FScene["MC_Man"];
         this.FMC_Chesstable = FScene["MC_Chesstable"];
         _loc2_ = 100;
         this.FTables = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FTables[_loc3_] = this.FMC_Chesstable["MC_Chess_" + _loc3_];
            this.FTables[_loc3_]["TF_Prompt"].text = (_loc3_ + 1).toString();
            this.FTables[_loc3_].mouseChildren = false;
            this.FTables[_loc3_].mouseEnabled = false;
            _loc3_++;
         }
         this.FMC_NormalMoive = FScene["MC_NormalMovie"];
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_NewYear2016ChessShop") as MovieClip);
         this.FAwardShow = FScene["MC_AwardShow"];
         _loc2_ = 12;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = this.FAwardShow["slot" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FAwardShow.MC_ChangeSlotPage.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = this.FAwardShow.MC_ChangeSlotPage.MC_PageLeft;
         this.FPage.LabelPage = this.FAwardShow.MC_ChangeSlotPage.TF_Page;
         this.FPage.PageSize = 12;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FAwardShow.visible = false;
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FAwardShow["Btn_close"];
         this.FClose.OnClick = this.AwardShowOnClose;
         this.FSP_ShowUI = new TShowAwardUI(this);
         this.FSP_ShowUI.UIDispatch(FScene["MC_FinalGift"]);
         this.FBtn_GetPrize = new TUIButton();
         this.FBtn_GetPrize.Substrate = FScene["MC_FinalGift"]["Btn_Get"];
         this.FBtn_GetPrize.OnClick = this.ProcessorGetPrizeOnClick;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_FinalGift"]["Btn_FightReport"];
         this.FBtn_Report.OnClick = this.ProcessorReportOnClick;
         this.FSP_AlreadyGet = FScene["MC_FinalGift"]["MC_Get"];
         this.FTF_ShowUICost = FScene["MC_FinalGift"]["TF_Condition"];
      }
   }
}

