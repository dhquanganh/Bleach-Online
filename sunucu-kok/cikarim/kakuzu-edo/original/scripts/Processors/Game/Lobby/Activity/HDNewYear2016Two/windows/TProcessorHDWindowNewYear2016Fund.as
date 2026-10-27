package Processors.Game.Lobby.Activity.HDNewYear2016Two.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNewYear2016Fund;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Fund;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowNewYear2016Fund extends TProcessorHDSingleWindowBase
   {
      
      protected var FSP_Funds:Vector.<Sprite>;
      
      protected var FBtn_FundGets:Vector.<TUIButton>;
      
      protected var FSP_RedBag:Sprite;
      
      protected var FSP_Bags:Vector.<Sprite>;
      
      protected var FBtn_Bags:Vector.<TUIButton>;
      
      protected var FBtnIndex:uint;
      
      protected var FConfig:THDNewYear2016Fund;
      
      protected var FData:TNewYear2016Fund;
      
      public function TProcessorHDWindowNewYear2016Fund(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2016Fund;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = this.FConfig.SpringFund.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_Funds[_loc1_]["TF_Reward"].text = this.FConfig.SpringFund[_loc1_].reward + "";
            this.FSP_Funds[_loc1_]["TF_Active"].text = this.FConfig.SpringFund[_loc1_].active + "";
            this.FSP_Funds[_loc1_]["TF_Duration"].text = this.FConfig.SpringFund[_loc1_].duration + "";
            this.FSP_Funds[_loc1_]["TF_Cost"].text = this.FConfig.SpringFund[_loc1_].cost + "";
            _loc1_++;
         }
         _loc2_ = this.FConfig.RedBag.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_Bags[_loc1_]["TF_Active"].text = this.FConfig.RedBag[_loc1_].active + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TNewYear2016Fund;
         _loc3_ = this.FConfig.SpringFund.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_FundGets[_loc2_].Enabled = this.FData.FundStatus[_loc2_] == 1 ? true : false;
            this.FSP_Funds[_loc2_]["SP_Already"].visible = this.FData.FundStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         _loc3_ = this.FConfig.RedBag.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Bags[_loc2_].Enabled = this.FData.BagsStatus[_loc2_] == 1 ? true : false;
            this.FSP_Bags[_loc2_]["SP_Already"].visible = this.FData.BagsStatus[_loc2_] == -1 ? true : false;
            this.FSP_Bags[_loc2_]["SP_Allready"].visible = this.FData.BagsStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         this.FSP_RedBag["TF_ReCharge"].text = this.FData.Recharge + "";
      }
      
      protected function ProcessorFundGet(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnIndex = param1.Tag;
         GoldBuy(this.FData.Config.SpringFund[param1.Tag].cost,this.ProcessorFundBuy);
      }
      
      protected function ProcessorFundBuy(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.SpringFund[this.FBtnIndex].index);
      }
      
      protected function ProcessorBagGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RedBag[param1.Tag].index);
      }
      
      protected function RightBagsOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.BagsIns[param1.Tag],TOverlayerGiftBox.TYPE_ONEOFALL);
      }
      
      protected function RightBagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 3;
         this.FSP_Funds = new Vector.<Sprite>(_loc2_);
         this.FBtn_FundGets = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSP_Funds[_loc3_] = FScene["SP_Fund_" + _loc3_];
            this.FBtn_FundGets[_loc3_] = new TUIButton();
            this.FBtn_FundGets[_loc3_].Substrate = this.FSP_Funds[_loc3_]["Btn_Get"];
            this.FBtn_FundGets[_loc3_].OnClick = this.ProcessorFundGet;
            this.FBtn_FundGets[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         this.FSP_RedBag = FScene["SP_RedBag"];
         _loc2_ = 9;
         this.FSP_Bags = new Vector.<Sprite>(_loc2_);
         this.FBtn_Bags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSP_Bags[_loc3_] = this.FSP_RedBag["SP_Bag_" + _loc3_];
            this.FBtn_Bags[_loc3_] = new TUIButton();
            this.FBtn_Bags[_loc3_].Substrate = this.FSP_Bags[_loc3_]["Btn_Get"];
            this.FBtn_Bags[_loc3_].OnClick = this.ProcessorBagGet;
            this.FBtn_Bags[_loc3_].Tag = _loc3_;
            this.FBtn_Bags[_loc3_].OnMove = this.RightBagsOnMove;
            this.FBtn_Bags[_loc3_].OnOut = this.RightBagsOnOut;
            _loc3_++;
         }
      }
   }
}

