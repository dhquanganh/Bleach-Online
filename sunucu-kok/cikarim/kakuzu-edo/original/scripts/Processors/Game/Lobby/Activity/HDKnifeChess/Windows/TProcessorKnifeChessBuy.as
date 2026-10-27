package Processors.Game.Lobby.Activity.HDKnifeChess.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDKnifeChessBuy;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKnifeChess.TKnifeChessBuy;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorKnifeChessBuy extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Step:TUIButton;
      
      protected var FBtn_Steps:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FBtn_Zones:Vector.<TUIButton>;
      
      protected var FZoneIndex:uint;
      
      protected var FBtn_Bags:Vector.<TUIButton>;
      
      protected var FBtn_Help:TUIButton;
      
      protected var FDescHint:THint;
      
      protected var FConfig:THDKnifeChessBuy;
      
      protected var FData:TKnifeChessBuy;
      
      public function TProcessorKnifeChessBuy(param1:TUIComponent)
      {
         super(param1);
         this.FDescHint = new THint();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDKnifeChessBuy = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDKnifeChessBuy;
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
         this.FData = param1 as TKnifeChessBuy;
         if(!this.FIsinit)
         {
            this.SetupShop();
            this.FIsinit = true;
         }
         this.FBtn_Step.Enabled = this.FData.CurZone * 10 - this.FData.CurStep > 0 ? true : false;
         this.FBtn_Steps.Enabled = this.FData.CurZone * 10 - this.FData.CurStep >= 5 ? true : false;
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Zones[_loc2_].Enabled = this.FData.CurZone <= _loc2_;
            _loc2_++;
         }
         _loc3_ = 40;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.CurZone * 10 > _loc2_)
            {
               FScene["MC_Chess_" + _loc2_].visible = true;
            }
            else
            {
               FScene["MC_Chess_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         FScene["TF_Recharge"].text = this.FConfig.Recharge + "";
         FScene["TF_Freesteps"].text = this.FData.FreeSteps + "";
         if(this.FData.CurStep == 0)
         {
            FScene["MC_Man"].visible = false;
         }
         else
         {
            FScene["MC_Man"].visible = true;
            FScene["MC_Man"].gotoAndStop(this.FData.CurStep);
         }
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
         this.FDescHint.Caption = this.FData.Config.Desc;
      }
      
      protected function ProcessorStepOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.FreeSteps < 1)
         {
            GoldBuy(this.FData.Config.StepGold,this.ProcessorGoldStepOnClick);
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OperIndex);
         }
      }
      
      protected function ProcessorStepsOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.FreeSteps < 5)
         {
            GoldBuy(this.FData.Config.StepGold * (5 - this.FData.FreeSteps),this.ProcessorGoldStepsOnClick);
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OnekeyIndex);
         }
      }
      
      protected function ProcessorGoldStepOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OperIndex);
      }
      
      protected function ProcessorGoldStepsOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OnekeyIndex);
      }
      
      protected function ProcessorShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FExchangeShop.Visible = true;
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
      }
      
      protected function ProcessorClickZone(param1:Object, param2:MouseEvent) : void
      {
         this.FZoneIndex = param1.Tag;
         GoldBuy(this.FData.Config.StageGold[param1.Tag],this.ProcessorGoldClickZone);
      }
      
      protected function ProcessorGoldClickZone(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = this.FZoneIndex + 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OpenStageIndex,0,_loc2_);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Bags[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      protected function SetupShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc4_ = new TInventories();
         _loc5_ = this.FData.Config.Mall.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.Mall[_loc6_].score);
            _loc3_.push(this.FData.Config.Mall[_loc6_].limit == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.Mall[_loc6_].award,_loc4_);
            _loc6_++;
         }
         this.FExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function DescOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(param1,this.FDescHint);
      }
      
      protected function DescOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(param1,this.FDescHint);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_Step = new TUIButton();
         this.FBtn_Step.Substrate = FScene["Btn_step"];
         this.FBtn_Step.OnClick = this.ProcessorStepOnClick;
         this.FBtn_Steps = new TUIButton();
         this.FBtn_Steps.Substrate = FScene["Btn_steps"];
         this.FBtn_Steps.OnClick = this.ProcessorStepsOnClick;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ProcessorShopOnClick;
         _loc2_ = 4;
         this.FBtn_Zones = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Zones[_loc3_] = new TUIButton();
            this.FBtn_Zones[_loc3_].Substrate = FScene["MC_Zone_" + _loc3_];
            this.FBtn_Zones[_loc3_].OnClick = this.ProcessorClickZone;
            this.FBtn_Zones[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         _loc2_ = 4;
         this.FBtn_Bags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Bags[_loc3_] = new TUIButton();
            this.FBtn_Bags[_loc3_].Substrate = FScene["MC_Chess_" + (9 + _loc3_ * 10)];
            this.FBtn_Bags[_loc3_].Tag = _loc3_;
            this.FBtn_Bags[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_Bags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            _loc3_++;
         }
         _loc2_ = 40;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Chess_" + _loc3_]["TF_Prompt"].text = _loc3_ + 1;
            _loc3_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Shop") as MovieClip;
         this.FExchangeShop = new THDScoreExchangeShop(this);
         this.FExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FExchangeShop.UIDispatch(_loc4_);
         this.FExchangeShop.Visible = false;
         this.FBtn_Help = new TUIButton();
         this.FBtn_Help.Substrate = FScene["MC_HDDesc"];
         this.FBtn_Help.OnMove = this.DescOnMove;
         this.FBtn_Help.OnOut = this.DescOnOut;
      }
   }
}

