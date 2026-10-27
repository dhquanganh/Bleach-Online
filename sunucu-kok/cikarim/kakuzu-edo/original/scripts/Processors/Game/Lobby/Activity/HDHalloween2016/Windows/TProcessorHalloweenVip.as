package Processors.Game.Lobby.Activity.HDHalloween2016.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDHalloweenVip;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDHalloween2016.THalloweenVip;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHalloweenVip extends TProcessorHDSingleWindowBase
   {
      
      protected var FBags:Vector.<TUIButton>;
      
      protected var FItems:Vector.<TUIButton>;
      
      protected var FBigBag:TUIButton;
      
      protected var FConfig:THDHalloweenVip;
      
      protected var FData:THalloweenVip;
      
      public function TProcessorHalloweenVip(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDHalloweenVip = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDHalloweenVip;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 5;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Item" + _loc1_]["TF_Gold"].text = this.FConfig.DayChargeGifts[_loc1_].limit + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as THalloweenVip;
         FScene["MC_Bag"]["TF_Gold"].text = (this.FData.Period + 1) * this.FConfig.ProgressChargeGifts[0].ratio + "";
         FScene["TF_Recharge"].text = this.FData.Recharge + "";
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBags[_loc2_].Enabled = this.FData.BagStatus[_loc2_] == 1 ? true : false;
            FScene["MC_Already_" + _loc2_].visible = this.FData.BagStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FItems[_loc2_].Enabled = this.FData.BagStatus[_loc2_ + 3] == 1 ? true : false;
            FScene["MC_Item" + _loc2_]["MC_Get"].visible = this.FData.BagStatus[_loc2_ + 3] == -1 ? true : false;
            _loc2_++;
         }
         this.FBigBag.Enabled = this.FData.BagStatus[8] == 1 ? true : false;
         FScene["MC_Bag"]["MC_Get"].visible = false;
      }
      
      protected function ProcessorBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag);
      }
      
      protected function ProcessorOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = (param1 as TUIButton).Tag - 1;
         ProcessorOnGiftBoxMove(this,this.FData.Gifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         _loc2_ = 3;
         this.FBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBags[_loc3_] = new TUIButton();
            this.FBags[_loc3_].Substrate = FScene["MC_Bag_" + _loc3_];
            this.FBags[_loc3_].OnClick = this.ProcessorBagOnClick;
            this.FBags[_loc3_].OnMove = this.ProcessorOnMove;
            this.FBags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBags[_loc3_].Tag = _loc3_ + 1;
            FScene["MC_Effect_" + _loc3_].play();
            _loc3_++;
         }
         _loc2_ = 5;
         this.FItems = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FItems[_loc3_] = new TUIButton();
            this.FItems[_loc3_].Substrate = FScene["MC_Item" + _loc3_]["Btn_Gift"];
            this.FItems[_loc3_].OnClick = this.ProcessorBagOnClick;
            this.FItems[_loc3_].OnMove = this.ProcessorOnMove;
            this.FItems[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FItems[_loc3_].Tag = _loc3_ + 4;
            _loc3_++;
         }
         this.FBigBag = new TUIButton();
         this.FBigBag.Substrate = FScene["MC_Bag"]["MC_Gift"];
         this.FBigBag.OnClick = this.ProcessorBagOnClick;
         this.FBigBag.OnMove = this.ProcessorOnMove;
         this.FBigBag.OnOut = this.ProcessorGiftOnOut;
         this.FBigBag.Tag = 9;
      }
   }
}

