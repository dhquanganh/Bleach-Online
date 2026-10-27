package Processors.Game.Lobby.Activity.HDChildrenDay.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.THDChildrenDayShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayShop;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowChildrenDayShop extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Bags:Vector.<TUIButton>;
      
      protected var FBtn_GoldShop:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FGoldExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FCurGoldIndex:int;
      
      protected var FBtnRecharge:TUIButton;
      
      protected var FConfig:THDChildrenDayShop;
      
      protected var FData:TChildrenDayShop;
      
      public function TProcessorHDWindowChildrenDayShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDChildrenDayShop;
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
         var _loc4_:uint = 0;
         this.FData = param1 as TChildrenDayShop;
         FScene["TF_Score"].text = this.FData.Score + "";
         FScene["TF_TodayRecharge"].text = this.FData.TodayPay + "";
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         this.FGoldExchangeShop.Update(SLogicsCore.Character.CreditGold,this.FData.MailMoneyStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Bags[_loc2_].Enabled = this.FData.BagStatus[_loc2_] == 1 ? true : false;
            FScene["MC_Item" + _loc2_]["MC_Get"].visible = this.FData.BagStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         _loc2_ = 2;
         while(_loc2_ < 6)
         {
            FScene["MC_Item" + _loc2_]["TF_Consume"].text = this.FData.Config.PayAward[_loc2_ - 1].cond + "";
            _loc2_++;
         }
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
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
         _loc2_ = new Vector.<uint>();
         for each(_loc1_ in this.FData.Config.GoldMall)
         {
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FGoldExchangeShop.SetupBasicInfo(this.FData.MailMoneyInvs,_loc2_,_loc3_);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreMall[param1];
         _loc2_ = uint(_loc3_.cost);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
         }
      }
      
      protected function ExchangeGoldCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.GoldMall[param1];
         _loc2_ = uint(_loc3_.cost);
         this.FCurGoldIndex = _loc3_.index;
         if(SLogicsCore.Character.CreditGold >= _loc2_)
         {
            GoldBuy(_loc2_,this.ProcessorGoldShopBuy);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_11));
         }
      }
      
      protected function ProcessorGoldShopBuy(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurGoldIndex);
      }
      
      protected function ProcessorBtnOnShop(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
      }
      
      protected function ProcessorBtnOnGoldShop(param1:Object, param2:MouseEvent) : void
      {
         this.FGoldExchangeShop.Visible = true;
         this.FGoldExchangeShop.Update(SLogicsCore.Character.CreditGold,this.FData.MailMoneyStatus);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Bags_Award[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag + 3);
      }
      
      protected function ProcessorRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 6;
         this.FBtn_Bags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Bags[_loc3_] = new TUIButton();
            this.FBtn_Bags[_loc3_].Substrate = FScene["MC_Item" + _loc3_]["Btn_Gift"];
            this.FBtn_Bags[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_Bags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBtn_Bags[_loc3_].Tag = _loc3_;
            this.FBtn_Bags[_loc3_].OnClick = this.ProcessorGiftOnClick;
            _loc3_++;
         }
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["MC_Shop_0"];
         this.FBtn_Shop.OnClick = this.ProcessorBtnOnShop;
         this.FBtn_GoldShop = new TUIButton();
         this.FBtn_GoldShop.Substrate = FScene["MC_Shop_1"];
         this.FBtn_GoldShop.OnClick = this.ProcessorBtnOnGoldShop;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_CDScoreShop") as MovieClip);
         this.FGoldExchangeShop = new THDScoreExchangeShop(this);
         this.FGoldExchangeShop.ExchangeCall = this.ExchangeGoldCall;
         this.FGoldExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_CDGoldShop") as MovieClip);
         this.FBtnRecharge = new TUIButton();
         this.FBtnRecharge.Substrate = FScene["MC_Prompt"]["Btn_Recharge"];
         this.FBtnRecharge.OnClick = this.ProcessorRecharge;
      }
   }
}

