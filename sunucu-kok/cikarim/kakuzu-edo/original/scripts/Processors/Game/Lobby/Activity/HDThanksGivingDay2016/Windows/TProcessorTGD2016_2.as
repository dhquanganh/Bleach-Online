package Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDTGD_2;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksGivingDay2016.TTGD_2;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorTGD2016_2 extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Perview:TUIButton;
      
      protected var FBtn_ClosePerview:TUIButton;
      
      protected var FBtn_Refresh:TUIButton;
      
      protected var FBtn_OneKey:TUIButton;
      
      protected var FBtn_Exchange_0:TUIButton;
      
      protected var FBtn_Exchange_1:TUIButton;
      
      protected var FBtn_Exchange_2:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FBtn_Cards:Vector.<MovieClip>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FPerSlots:Vector.<TUISlot>;
      
      protected var FCurCardIndex:int;
      
      protected var FConfig:THDTGD_2;
      
      protected var FData:TTGD_2;
      
      public function TProcessorTGD2016_2(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDTGD_2 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDTGD_2;
         this.FConfig = _loc3_;
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
         this.FData = param1 as TTGD_2;
         this.FScoreExchangeShop.Update(this.FData.HaveCard_3,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
            this.FData.CurCard = -1;
            _loc3_ = 5;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FData.CurInsIndex[_loc2_] == 0)
               {
                  FScene["MC_CardEffect_" + _loc2_].gotoAndStop(1);
               }
               else
               {
                  FScene["MC_CardEffect_" + _loc2_].gotoAndStop(22);
               }
               _loc2_++;
            }
         }
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.CurIns[_loc2_] == null)
            {
               FScene["MC_CardEffect_" + _loc2_].gotoAndStop(1);
            }
            else
            {
               this.FSlots[_loc2_].Context = this.FData.CurIns[_loc2_] as TInventory;
               FScene["MC_Card_" + _loc2_]["MC_Award"]["TF_Prompt_0"].text = this.FData.CurIns[_loc2_].Name;
            }
            _loc2_++;
         }
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPerSlots[_loc2_].Context = this.FData.PerviewIns[_loc2_].GetInventoryByIndex(0);
            _loc2_++;
         }
         FScene["TF_HaveCard_0"].text = this.FData.HaveCard_0 + "";
         FScene["TF_HaveCard_1"].text = this.FData.HaveCard_1 + "";
         FScene["TF_HaveCard_2"].text = this.FData.HaveCard_2 + "";
         FScene["TF_HaveCard_3"].text = this.FData.HaveCard_3 + "";
         FScene["TF_CostCard_0"].text = this.FConfig.CardInfo[1].ratio + "";
         FScene["TF_CostCard_1"].text = this.FConfig.CardInfo[2].ratio + "";
         FScene["TF_CostCard_2"].text = this.FConfig.CardInfo[3].ratio + "";
         FScene["TF_FreeCount"].text = this.FData.FreeCount + "";
         if(this.FData.CurCard != -1 && this.FData.CurInsIndex[this.FData.CurCard] != 0 && (FScene["MC_Card_" + this.FData.CurCard] as MovieClip).currentFrame == 1)
         {
            (FScene["MC_CardEffect_" + this.FData.CurCard] as MovieClip).play();
            this.FData.CurCard = -1;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         _loc2_ = 5;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
         _loc2_ = 9;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FPerSlots[_loc1_].Context != null)
            {
               this.FPerSlots[_loc1_].Update();
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorCardOnMove(param1:MouseEvent) : void
      {
      }
      
      protected function ProcessorCardOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[2]);
         this.FCurCardIndex = _loc2_;
         if(this.FData.FreeCount > 0)
         {
            this.ProcessorCardOnGoldClick(null);
         }
         else
         {
            GoldBuy(this.FConfig.BuyCostGold,this.ProcessorCardOnGoldClick);
         }
      }
      
      protected function ProcessorCardOnGoldClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurCardIndex + 1);
      }
      
      protected function ProcessorCardOnOut(param1:MouseEvent) : void
      {
      }
      
      protected function ProcessorOnPerview(param1:Object, param2:MouseEvent) : void
      {
         FScene["MC_PerView"].visible = !FScene["MC_PerView"].visible;
      }
      
      protected function ProcessorOnRefresh(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.RefreshCostGold,this.ProcessorOnGoldRefresh);
      }
      
      protected function ProcessorOnGoldRefresh(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RefreshIndex);
         FScene["MC_Effect"].gotoAndPlay(1);
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_CardEffect_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
      }
      
      protected function ProcessorOnOneKey(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = 0;
         _loc6_ = 5;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(this.FData.CurInsIndex[_loc5_] != 0)
            {
               _loc4_++;
            }
            _loc5_++;
         }
         _loc3_ = 5 - (this.FData.FreeCount + _loc4_);
         if(_loc3_ > 0)
         {
            GoldBuy(this.FConfig.BuyCostGold * _loc3_,this.ProcessorOnGoldOneKey);
         }
         else
         {
            this.ProcessorOnGoldOneKey(null);
         }
      }
      
      protected function ProcessorOnGoldOneKey(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.AllBuyIndex);
         FScene["MC_Effect"].gotoAndPlay(1);
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_CardEffect_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
      }
      
      protected function ProcessorOnExchange_0(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.PurpleIndex);
      }
      
      protected function ProcessorOnExchange_1(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.GoldIndex);
      }
      
      protected function ProcessorOnExchange_2(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RedIndex);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.costScore);
         if(this.FData.HaveCard_3 >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Integral));
         }
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.Mall)
         {
            _loc2_.push(_loc1_.costScore);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
      }
      
      protected function ShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.HaveCard_3,this.FData.MailStatus);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_Perview = new TUIButton();
         this.FBtn_Perview.Substrate = FScene["Btn_Perview"];
         this.FBtn_Perview.OnClick = this.ProcessorOnPerview;
         this.FBtn_ClosePerview = new TUIButton();
         this.FBtn_ClosePerview.Substrate = FScene["MC_PerView"]["Btn_ClosePerview"];
         this.FBtn_ClosePerview.OnClick = this.ProcessorOnPerview;
         this.FBtn_Refresh = new TUIButton();
         this.FBtn_Refresh.Substrate = FScene["Btn_Reflash"];
         this.FBtn_Refresh.OnClick = this.ProcessorOnRefresh;
         this.FBtn_OneKey = new TUIButton();
         this.FBtn_OneKey.Substrate = FScene["Btn_OneKey"];
         this.FBtn_OneKey.OnClick = this.ProcessorOnOneKey;
         this.FBtn_Exchange_0 = new TUIButton();
         this.FBtn_Exchange_0.Substrate = FScene["Btn_Exchange_0"];
         this.FBtn_Exchange_0.OnClick = this.ProcessorOnExchange_0;
         this.FBtn_Exchange_1 = new TUIButton();
         this.FBtn_Exchange_1.Substrate = FScene["Btn_Exchange_1"];
         this.FBtn_Exchange_1.OnClick = this.ProcessorOnExchange_1;
         this.FBtn_Exchange_2 = new TUIButton();
         this.FBtn_Exchange_2.Substrate = FScene["Btn_Exchange_2"];
         this.FBtn_Exchange_2.OnClick = this.ProcessorOnExchange_2;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ShowShopOnClick;
         _loc2_ = 5;
         this.FBtn_Cards = new Vector.<MovieClip>(_loc2_);
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Cards[_loc3_] = new MovieClip();
            this.FBtn_Cards[_loc3_] = FScene["MC_CardEffect_" + _loc3_];
            this.FBtn_Cards[_loc3_].addEventListener(MouseEvent.CLICK,this.ProcessorCardOnClick);
            this.FBtn_Cards[_loc3_].buttonMode = true;
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Card_" + _loc3_]["MC_Award"]["MC_Slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 9;
         this.FPerSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FPerSlots[_loc3_] = new TUISlot(this);
            this.FPerSlots[_loc3_].Resource = FScene["MC_PerView"]["slot" + _loc3_];
            this.FPerSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FPerSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FPerSlots[_loc3_]);
            this.FPerSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_TGD2016Shop") as MovieClip);
         this.FScoreExchangeShop.Visible = false;
         FScene["MC_PerView"].visible = false;
      }
   }
}

