package Processors.Game.Lobby.Activity.HDFoolsDay.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDFoolsDayShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFoolsDay.TFoolsDayShop;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowFoolsDayShop extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Start:TUIButton;
      
      protected var FBtn_ReItem:TUIButton;
      
      protected var FBtn_RePrice:TUIButton;
      
      protected var FBtn_Lucky:TUIButton;
      
      protected var FBtn_PlayOne:TUIButton;
      
      protected var FIsPlayOnce:Boolean;
      
      protected var FBtn_PlayFive:TUIButton;
      
      protected var FBtn_Exchange:Vector.<TUIButton>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBeforeScore:int;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FData:TFoolsDayShop;
      
      protected var FConfig:THDFoolsDayShop;
      
      public function TProcessorHDWindowFoolsDayShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDFoolsDayShop;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TFoolsDayShop;
         FScene["TF_Price"].text = this.FData.Price + "";
         FScene["TF_Point"].text = this.FData.Score + "";
         this.FBtn_Lucky.Visible = this.FData.IsShowLuck;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.CurIns[_loc2_];
            _loc2_++;
         }
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Exchange[_loc2_].Enabled = this.FData.CurInsStatus[_loc2_] == -1 ? false : true;
            _loc2_++;
         }
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.CurInsStatus[_loc2_] == -1)
            {
               this.FBtn_Start.Enabled = true;
               this.FBtn_ReItem.Enabled = false;
               this.FBtn_RePrice.Enabled = false;
               break;
            }
            this.FBtn_Start.Enabled = false;
            this.FBtn_ReItem.Enabled = true;
            this.FBtn_RePrice.Enabled = true;
            _loc2_++;
         }
         if(this.FIsinit && this.FData.Score - this.FBeforeScore > 6)
         {
            FScene["RollIcon2"].gotoAndStop(7);
         }
         else if(this.FIsinit)
         {
            FScene["RollIcon2"].gotoAndStop(this.FData.Score - this.FBeforeScore);
         }
         this.FBeforeScore = this.FData.Score;
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible == false)
         {
            return;
         }
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorStart(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ReStart);
      }
      
      protected function ProcessorReItem(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.ReItemCost,this.ProcessorGoldReItem);
      }
      
      protected function ProcessorGoldReItem(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ReItemIndex);
      }
      
      protected function ProcessorRePrice(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.RePriceCost,this.ProcessorGoldRePrice);
      }
      
      protected function ProcessorGoldRePrice(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RePriceIndex);
      }
      
      protected function ProcessorLucky(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.LuckIndex);
      }
      
      protected function ProcessorPlayOne(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.Free >= 1)
         {
            this.ProcessorGoldPlayOne(null);
         }
         else
         {
            GoldBuy(this.FData.Config.PlayCost,this.ProcessorGoldPlayOne);
         }
      }
      
      protected function ProcessorGoldPlayOne(param1:Object) : void
      {
         FScene["TigerMachineEffect"].gotoAndPlay(1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.PlayOnceIndex);
      }
      
      protected function ProcessorPlayFive(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.Free >= 10)
         {
            this.ProcessorGoldPlayFive(null);
         }
         else
         {
            GoldBuy(this.FData.Config.PlayCost * (10 - this.FData.Free),this.ProcessorGoldPlayFive);
         }
      }
      
      protected function ProcessorGoldPlayFive(param1:Object) : void
      {
         FScene["TigerMachineEffect"].gotoAndPlay(1);
         FScene["RollIcon2"].gotoAndStop(int(Math.random() * 7) + 1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.PlayFiveIndex);
      }
      
      protected function ProcessorShop(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
      }
      
      protected function ProcessorBagsClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.CurItemsIndex[param1.Tag]);
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
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBtn_Start = new TUIButton();
         this.FBtn_Start.Substrate = FScene["Btn_Start"];
         this.FBtn_Start.OnClick = this.ProcessorStart;
         this.FBtn_ReItem = new TUIButton();
         this.FBtn_ReItem.Substrate = FScene["Btn_ReItem"];
         this.FBtn_ReItem.OnClick = this.ProcessorReItem;
         this.FBtn_RePrice = new TUIButton();
         this.FBtn_RePrice.Substrate = FScene["Btn_RePrice"];
         this.FBtn_RePrice.OnClick = this.ProcessorRePrice;
         this.FBtn_Lucky = new TUIButton();
         this.FBtn_Lucky.Substrate = FScene["Btn_Lucky"];
         this.FBtn_Lucky.OnClick = this.ProcessorLucky;
         this.FBtn_PlayOne = new TUIButton();
         this.FBtn_PlayOne.Substrate = FScene["Btn_PlayOne"];
         this.FBtn_PlayOne.OnClick = this.ProcessorPlayOne;
         this.FBtn_PlayFive = new TUIButton();
         this.FBtn_PlayFive.Substrate = FScene["Btn_PlayFive"];
         this.FBtn_PlayFive.OnClick = this.ProcessorPlayFive;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Buy"];
         this.FBtn_Shop.OnClick = this.ProcessorShop;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_FoolShop") as MovieClip);
         _loc2_ = 3;
         this.FBtn_Exchange = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Exchange[_loc3_] = new TUIButton();
            this.FBtn_Exchange[_loc3_].Substrate = FScene["Btn_Exchange_" + _loc3_];
            this.FBtn_Exchange[_loc3_].OnClick = this.ProcessorBagsClick;
            this.FBtn_Exchange[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         _loc2_ = 3;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["slot" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
      }
   }
}

