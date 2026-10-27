package Processors.Game.Lobby.Activity.HDNewYear2016.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDNewYear2016Pocket;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Pocket;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowNewYearPocket extends TProcessorHDSingleWindowBase
   {
      
      protected var FSP_Bags:Sprite;
      
      protected var FTF_RedLast:TextField;
      
      protected var FTF_Red:TextField;
      
      protected var FTF_Candy:TextField;
      
      protected var FTF_Cost:TextField;
      
      protected var FTF_Score:TextField;
      
      protected var FBtn_Open:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FMC_Bags:Vector.<MovieClip>;
      
      protected var FSP_Slots:Vector.<TUISlot>;
      
      protected var FBtn_Look:TUIButton;
      
      protected var FBtn_Reflash:TUIButton;
      
      protected var FBtn_OpenBag:TUIButton;
      
      protected var FBtn_OneKey:TUIButton;
      
      protected var FLastBagsStatus:Vector.<uint>;
      
      protected var FIsLooked:Boolean;
      
      protected var FIsPlaying:Boolean;
      
      protected var FSP_ShowUI:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_GetPrize:TUIButton;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_ShowUICost:TextField;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FFirstInit:Boolean;
      
      protected var FConfig:THDNewYear2016Pocket;
      
      protected var FData:TNewYear2016Pocket;
      
      public function TProcessorHDWindowNewYearPocket(param1:TUIComponent)
      {
         super(param1);
         this.FLastBagsStatus = new Vector.<uint>(15);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc1_ = this.FConfig.PocketIndexs.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSP_Slots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2016Pocket;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         this.FTF_Cost.text = this.FConfig.GoldToScore[0] + "";
         this.FTF_Score.text = this.FConfig.GoldToScore[1] + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc8_:TInventories = null;
         var _loc9_:TInventories = null;
         this.FData = param1 as TNewYear2016Pocket;
         this.FTF_RedLast.text = this.FConfig.PocketsCount.count - this.FData.RedLast >= 0 ? (this.FConfig.PocketsCount.count - this.FData.RedLast).toString() : "0";
         this.FTF_Red.text = this.FData.Candy + "";
         this.FTF_Candy.text = this.FData.Red + "";
         _loc3_ = this.FData.BagsID.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new TInventories();
            _loc5_ = this.FConfig.PocketsBin.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this.FData.BagsID[_loc2_] == this.FConfig.PocketsBin[_loc4_].itemId)
               {
                  this.FData.BagsID[_loc2_] = this.FConfig.PocketsBin[_loc4_].awardId;
               }
               _loc4_++;
            }
            if(this.FConfig.PocketsBin[_loc2_].type == 0)
            {
               SToolReward.GetAwardsByAwardID(this.FData.BagsID[_loc2_],_loc8_);
            }
            else
            {
               _loc9_ = new TInventories();
               SToolReward.GetInventoryByIDAmount(this.FData.BagsID[_loc2_],this.FConfig.PocketsBin[_loc2_].count,_loc9_);
               _loc8_.Add(_loc9_.GetInventoryByIndex(0));
            }
            this.FSP_Slots[_loc2_].Context = _loc8_.GetInventoryByIndex(0);
            this.FMC_Bags[_loc2_]["SP_Allready"].visible = this.FData.BagsStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         if(this.FData.IsReFlash)
         {
            this.BagsReset();
         }
         this.CurBagMoive();
         if(!this.FFirstInit)
         {
            this.SetupScoreShop();
            this.BagsReset();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FData.BagsStatus[_loc2_] == 0)
               {
                  this.FMC_Bags[_loc2_]["MC_Box"].gotoAndStop(1);
                  this.FSP_Slots[_loc2_].Visible = false;
                  this.FLastBagsStatus[_loc2_] = 0;
               }
               else
               {
                  this.FMC_Bags[_loc2_]["MC_Box"].gotoAndStop(18);
                  this.FSP_Slots[_loc2_].Visible = true;
                  this.FLastBagsStatus[_loc2_] = 1;
               }
               _loc2_++;
            }
         }
         this.FFirstInit = true;
         this.FScoreExchangeShop.Update(this.FData.Candy,this.FData.ShopStates);
         this.UpdateJackPoint();
      }
      
      protected function CurBagMoive() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FIsPlaying)
         {
            return;
         }
         _loc2_ = this.FData.BagsID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData.BagsStatus[_loc1_] != this.FLastBagsStatus[_loc1_])
            {
               this.FMC_Bags[_loc1_]["MC_Box"].gotoAndPlay(1);
               this.FSP_Slots[_loc1_].Visible = true;
               this.FLastBagsStatus[_loc1_] = this.FData.BagsStatus[_loc1_];
            }
            _loc1_++;
         }
      }
      
      protected function BagsReset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FData.BagsID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Bags[_loc1_]["MC_Box"].gotoAndStop(1);
            this.FSP_Slots[_loc1_].Visible = false;
            this.FIsLooked = false;
            this.FIsPlaying = false;
            this.FLastBagsStatus = new Vector.<uint>(15);
            _loc1_++;
         }
      }
      
      protected function UpdateJackPoint() : void
      {
         this.FSP_ShowUI.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         this.FTF_ShowUICost.text = this.FData.Config.BigAward.gold + "";
         if(this.FData.BigAwardStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
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
      
      protected function ProcessorBtnOnOpen(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RedPackageIndex);
      }
      
      protected function ProcessorBtnOnLook(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = this.FData.BagsID.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FMC_Bags[_loc3_]["MC_Box"].gotoAndPlay(1);
            this.FSP_Slots[_loc3_].Visible = true;
            _loc3_++;
         }
         this.FIsLooked = true;
      }
      
      protected function ProcessorBtnOnReflash(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.Refresh.gold,this.GoldBtnOnReflash);
      }
      
      protected function GoldBtnOnReflash(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Refresh.index);
         this.BagsReset();
      }
      
      protected function ProcessorBtnOnOpenBag(param1:Object, param2:MouseEvent) : void
      {
         if(uint(this.FTF_RedLast.text) == 0)
         {
            GoldBuy(this.FConfig.OnceOpen.gold,this.GoldBtnOnOpenBag);
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OnceOpen.index);
            this.FIsPlaying = true;
         }
      }
      
      protected function GoldBtnOnOpenBag(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OnceOpen.index);
         this.FIsPlaying = true;
      }
      
      protected function ProcessorBtnOnOneKey(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = new uint();
         _loc5_ = this.FData.BagsID.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(this.FData.BagsStatus[_loc4_] == 0)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         if(_loc3_ >= uint(this.FTF_RedLast.text))
         {
            _loc3_ -= uint(this.FTF_RedLast.text);
            GoldBuy(this.FConfig.OnekeyOpen.discount * this.FConfig.OnceOpen.gold * _loc3_ / 100,this.GoldBtnOnOneKey);
         }
         else
         {
            this.GoldBtnOnOneKey(this);
         }
      }
      
      protected function GoldBtnOnOneKey(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OnekeyOpen.index);
         this.BagsReset();
      }
      
      protected function ProcessorGetPrizeOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.BigAward.gold,this.GoldBtnOnGetPrize);
      }
      
      protected function GoldBtnOnGetPrize(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BigAward.index);
      }
      
      protected function ProcessorReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToBattleReportUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      protected function ProcessorBtnOnShop(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Candy,this.FData.ShopStates);
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
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreShop[param1];
         _loc2_ = uint(_loc3_.cost);
         if(this.FData.Candy >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FSP_Bags = FScene["SP_Bags"];
         this.FTF_RedLast = this.FSP_Bags["TF_RedLast"];
         this.FTF_Red = this.FSP_Bags["TF_Red"];
         this.FTF_Candy = this.FSP_Bags["TF_Candy"];
         this.FTF_Cost = this.FSP_Bags["TF_Cost"];
         this.FTF_Score = this.FSP_Bags["TF_Score"];
         this.FBtn_Open = new TUIButton();
         this.FBtn_Open.Substrate = this.FSP_Bags["Btn_Open"];
         this.FBtn_Open.OnClick = this.ProcessorBtnOnOpen;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = this.FSP_Bags["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ProcessorBtnOnShop;
         this.FBtn_Look = new TUIButton();
         this.FBtn_Look.Substrate = this.FSP_Bags["Btn_Look"];
         this.FBtn_Look.OnClick = this.ProcessorBtnOnLook;
         this.FBtn_Reflash = new TUIButton();
         this.FBtn_Reflash.Substrate = this.FSP_Bags["Btn_Reflash"];
         this.FBtn_Reflash.OnClick = this.ProcessorBtnOnReflash;
         this.FBtn_OpenBag = new TUIButton();
         this.FBtn_OpenBag.Substrate = this.FSP_Bags["Btn_OpenBag"];
         this.FBtn_OpenBag.OnClick = this.ProcessorBtnOnOpenBag;
         this.FBtn_OneKey = new TUIButton();
         this.FBtn_OneKey.Substrate = this.FSP_Bags["Btn_OneKey"];
         this.FBtn_OneKey.OnClick = this.ProcessorBtnOnOneKey;
         this.FSP_ShowUI = new TShowAwardUI(this);
         this.FSP_ShowUI.UIDispatch(FScene["SP_ShowUI"]);
         this.FBtn_GetPrize = new TUIButton();
         this.FBtn_GetPrize.Substrate = FScene["SP_ShowUI"]["Btn_Exchange"];
         this.FBtn_GetPrize.OnClick = this.ProcessorGetPrizeOnClick;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["SP_ShowUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReportOnClick;
         this.FSP_AlreadyGet = FScene["SP_ShowUI"]["MC_Exchangeed"];
         this.FTF_ShowUICost = FScene["SP_ShowUI"]["TF_Cost"];
         _loc2_ = 15;
         this.FMC_Bags = new Vector.<MovieClip>(_loc2_);
         this.FSP_Slots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_Bags[_loc3_] = this.FSP_Bags["MC_Box_" + _loc3_];
            this.FSP_Slots[_loc3_] = new TUISlot(this);
            this.FSP_Slots[_loc3_].Resource = this.FMC_Bags[_loc3_]["slot"];
            this.FSP_Slots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSP_Slots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSP_Slots[_loc3_]);
            this.FSP_Slots[_loc3_].Init();
            _loc3_++;
         }
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_Christmas2015Shop") as MovieClip);
      }
   }
}

