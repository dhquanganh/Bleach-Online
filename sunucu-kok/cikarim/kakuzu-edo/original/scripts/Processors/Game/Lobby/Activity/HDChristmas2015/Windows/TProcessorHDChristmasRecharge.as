package Processors.Game.Lobby.Activity.HDChristmas2015.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDChrismasRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TActivityChristmasRecharge;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDChristmasRecharge extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Cheer:TUIButton;
      
      protected var FBtn_Buys:Vector.<TUIButton>;
      
      protected var FConfig:THDChrismasRecharge;
      
      protected var FData:TActivityChristmasRecharge;
      
      public function TProcessorHDChristmasRecharge(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDChrismasRecharge = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDChrismasRecharge;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 5;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Gift_" + _loc1_]["TF_Progress_0"].text = _loc3_.ChallengeInfo[_loc1_].Limit + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TActivityChristmasRecharge;
         FScene["TF_Free"].text = this.FData.Free + "";
         FScene["TF_Recharge"].text = this.FData.Recharged + "";
         FScene["TF_Cards"].text = this.FData.Cards + "";
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Buys[_loc2_].Enabled = this.FData.GiftStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FBtn_Cheer.Enabled = this.FData.Free > 0 ? true : false;
      }
      
      protected function OnGiftsMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         _loc3_ = uint(param1.Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Gifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftsOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function TreeOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DrawLotteryIndex);
         FScene["MC_TreeEffect"].gotoAndPlay(1);
      }
      
      protected function SingleBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag + 1);
         FScene["MC_Effect_" + param1.Tag].gotoAndPlay(1);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBtn_Cheer = new TUIButton();
         this.FBtn_Cheer.Substrate = FScene["Btn_Cheer"];
         this.FBtn_Cheer.OnClick = this.TreeOnClick;
         _loc2_ = 5;
         this.FBtn_Buys = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Buys[_loc3_] = new TUIButton();
            this.FBtn_Buys[_loc3_].Tag = _loc3_;
            this.FBtn_Buys[_loc3_].Substrate = FScene["MC_Gift_" + _loc3_]["MC_Gift"];
            this.FBtn_Buys[_loc3_].OnMove = this.OnGiftsMove;
            this.FBtn_Buys[_loc3_].OnOut = this.OnGiftsOut;
            this.FBtn_Buys[_loc3_].OnClick = this.SingleBagOnClick;
            (FScene["MC_Gift_" + _loc3_] as Sprite).buttonMode = true;
            _loc3_++;
         }
      }
   }
}

