package Processors.Game.Lobby.Activity.HDNationalDay2017.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDNationalDayThree2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay2017.TNationalDay2017Three;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class TProcessorNationalThree2017 extends TProcessorHDSingleWindowBase
   {
      
      public static const Split_Amount:int = 12;
      
      public static const Angle:int = 360;
      
      public static const ExtractIng:int = -1;
      
      public static const DelaySendTime:int = 1500;
      
      private var FLowTurntableMc:Sprite;
      
      private var FLowExtractBtn:TUIButton;
      
      private var FLowExtractInfoTF:TextField;
      
      private var FLowCloseAnima:MovieClip;
      
      private var FLowCircleMC:Sprite;
      
      private var FLowAnimaMc:MovieClip;
      
      private var FIsLowStopAnima:Boolean;
      
      private var FCurPlayAnima:MovieClip;
      
      private var FTargetA:Number;
      
      private var FCurTurntableMc:Sprite;
      
      private var FCurTurntableState:int;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_Buys:Vector.<TUIButton>;
      
      protected var FBtn_Refresh:TUIButton;
      
      protected var FCurBtnIndex:uint;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FConfig:THDNationalDayThree2017;
      
      protected var FData:TNationalDay2017Three;
      
      public function TProcessorNationalThree2017(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNationalDayThree2017;
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
         this.FData = param1 as TNationalDay2017Three;
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_Item_" + _loc2_]["MC_Already"].visible = this.FData.ItemsStatus[_loc2_] == -1 ? true : false;
            this.FSlots[_loc2_].Context = this.FData.GetItems()[_loc2_].inv;
            FScene["MC_Item_" + _loc2_]["TF_Cost"].text = this.FData.GetItems()[_loc2_].cost + "";
            this.FBtn_Buys[_loc2_].Enabled = this.FData.ItemsStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         FScene["TF_Score"].text = this.FData.Score.toString();
         FScene["TF_Ratio"].text = this.FData.Config.ScoreRatio.toString();
         FScene["MC_LowTurntable"]["TF_Score"].text = this.FData.Score.toString();
         FScene["MC_LowTurntable"]["TF_Info"].text = this.FData.LotteryCount.toString();
         FScene["MC_LowTurntable"]["TF_Ratio"].text = this.FData.Config.LotteryRatio.toString();
         _loc3_ = 10;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_LowTurntable"]["MC_Circle"]["MC_Already_" + _loc2_].visible = this.FData.LotteryStatus[_loc2_] == -1;
            _loc2_++;
         }
         this.GetTurntableAwardPos(this.FData.LotteryPos);
         this.FLowExtractBtn.Enabled = this.FData.LotteryCount > 0 && !this.FData.IsEmpty();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         for each(_loc3_ in this.FSlots)
         {
            _loc3_.Update();
         }
         if(this.FCurPlayAnima != null)
         {
            if(this.FCurPlayAnima.currentFrame >= this.FCurPlayAnima.totalFrames)
            {
               this.FCurPlayAnima.gotoAndStop(1);
               this.FCurPlayAnima.visible = false;
               this.FCurTurntableState = 0;
            }
         }
      }
      
      protected function OnLowExtract(param1:Object, param2:MouseEvent) : void
      {
         var Index:int = 0;
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         if(this.FCurTurntableState == ExtractIng)
         {
            return;
         }
         Index = int(this.FConfig.LotteryIndex);
         this.FCurTurntableMc = this.FLowCircleMC;
         this.FCurTurntableState = ExtractIng;
         if(!this.FIsLowStopAnima)
         {
            this.FCurPlayAnima = this.FLowAnimaMc;
            this.FLowAnimaMc.visible = true;
            this.FLowAnimaMc.play();
            setTimeout(function DelaySendMsg():void
            {
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
            },DelaySendTime);
         }
         else
         {
            this.FCurPlayAnima = null;
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
         }
      }
      
      protected function OnSelectLowAnimaState(param1:MouseEvent) : void
      {
         this.FIsLowStopAnima = this.SetMCState(this.FLowCloseAnima);
      }
      
      private function SetMCState(param1:MovieClip) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = param1.currentFrame;
         if(_loc2_ == 1)
         {
            param1.gotoAndStop(2);
            _loc3_ = false;
         }
         else
         {
            param1.gotoAndStop(1);
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      protected function ItemsOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.GetItems()[param1.Tag].cost,this.GoldItemsOnClick);
         this.FCurBtnIndex = param1.Tag;
      }
      
      protected function GoldItemsOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.ItemsID[this.FCurBtnIndex]);
      }
      
      protected function ShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
      }
      
      protected function RefreshOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.RefreshCost,this.GoldRefreshOnClick);
      }
      
      protected function GoldRefreshOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RefreshIndex);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.cost);
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
         for each(_loc1_ in this.FData.Config.Mall)
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
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FLowTurntableMc = FScene["MC_LowTurntable"];
         this.FLowExtractBtn = new TUIButton();
         this.FLowExtractBtn.Substrate = this.FLowTurntableMc["Btn_Extract"];
         this.FLowExtractBtn.OnClick = this.OnLowExtract;
         this.FLowExtractInfoTF = this.FLowTurntableMc["TF_Info"];
         this.FLowCircleMC = this.FLowTurntableMc["MC_Circle"];
         this.FLowCloseAnima = this.FLowTurntableMc["MC_CloseAnima"]["MC_SelectBox"];
         this.FLowCloseAnima.gotoAndStop(2);
         this.FLowCloseAnima.addEventListener(MouseEvent.CLICK,this.OnSelectLowAnimaState);
         this.FLowAnimaMc = this.FLowTurntableMc["MC_ExtractAnima"];
         this.FLowAnimaMc.visible = false;
         this.FLowAnimaMc.gotoAndStop(1);
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ShopOnClick;
         this.FBtn_Refresh = new TUIButton();
         this.FBtn_Refresh.Substrate = FScene["Btn_Refresh"];
         this.FBtn_Refresh.OnClick = this.RefreshOnClick;
         _loc2_ = 9;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         this.FBtn_Buys = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Item_" + _loc3_]["slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            this.FBtn_Buys[_loc3_] = new TUIButton();
            this.FBtn_Buys[_loc3_].Substrate = FScene["MC_Item_" + _loc3_]["Btn_Buy"];
            this.FBtn_Buys[_loc3_].OnClick = this.ItemsOnClick;
            this.FBtn_Buys[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_NationalDay2017Shop") as MovieClip);
      }
      
      public function GetTurntableAwardPos(param1:int) : void
      {
         var _loc2_:int = 0;
         param1 -= this.FData.Config.LotteryAward[0].index;
         _loc2_ = 20;
         if(param1 == 10)
         {
            param1 = 11;
         }
         this.FTargetA = (Split_Amount - param1) * Angle / Split_Amount;
         if(this.FCurTurntableMc != null)
         {
            this.FCurTurntableMc.rotation = this.FTargetA + _loc2_;
         }
         if(this.FCurPlayAnima == null)
         {
            this.FCurTurntableState = 0;
         }
      }
   }
}

