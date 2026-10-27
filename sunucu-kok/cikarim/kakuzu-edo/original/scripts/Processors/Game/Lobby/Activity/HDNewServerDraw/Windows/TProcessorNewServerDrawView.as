package Processors.Game.Lobby.Activity.HDNewServerDraw.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewServerDraw.TNewServerDrawData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewServerDraw.Components.TNewServerDrawLottery;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNewServerDrawView extends TProcessorHDSingleWindowBase
   {
      
      public static const GiftCount:uint = 7;
      
      protected var FData:TNewServerDrawData;
      
      protected var FLotteryCom:TNewServerDrawLottery;
      
      protected var FGifts:Vector.<TUIButton>;
      
      protected var FCurSelectedIndex:int;
      
      public function TProcessorNewServerDrawView(param1:TUIComponent)
      {
         super(param1);
         this.FCurSelectedIndex = -1;
      }
      
      override protected function Reset() : void
      {
         var _loc1_:uint = 0;
         if(this.FLotteryCom != null)
         {
            this.FLotteryCom.Reset();
         }
         if(FScene != null)
         {
            _loc1_ = 0;
            while(_loc1_ < GiftCount)
            {
               FScene["MC_Gift_" + _loc1_].MC_Selected.visible = false;
               _loc1_++;
            }
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.FData = param1 as TNewServerDrawData;
         _loc2_ = 0;
         while(_loc2_ < GiftCount)
         {
            _loc3_ = this.FData.GiftsState[_loc2_];
            _loc4_ = FScene["MC_Gift_" + _loc2_];
            if(_loc3_ == Activity_CanReceive)
            {
               _loc4_.MC_ReciveFlag.visible = false;
            }
            else
            {
               _loc4_.MC_ReciveFlag.visible = true;
               if(this.FCurSelectedIndex == _loc2_)
               {
                  _loc4_.MC_Selected.visible = false;
                  this.FCurSelectedIndex = -1;
               }
            }
            _loc2_++;
         }
         this.FLotteryCom.UpdateUI(this.FData);
         this.UpdateLotteryBtn();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FLotteryCom != null)
         {
            this.FLotteryCom.LogicsPerform();
         }
      }
      
      protected function Lottery_C2S() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.StudIndex,0,Vector.<int>([this.FData.Config.GiftIndexs[this.FCurSelectedIndex].index]));
      }
      
      protected function UpdateLotteryBtn() : void
      {
         if(this.FData.TodayReceiveState == Activity_CanReceive && this.FCurSelectedIndex != -1)
         {
            this.FLotteryCom.BtnEnabled = true;
         }
         else
         {
            this.FLotteryCom.BtnEnabled = false;
         }
      }
      
      protected function OnGiftsClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param1.Tag);
         if(this.FData.GiftsState[_loc3_] == Activity_CanReceive)
         {
            if(this.FCurSelectedIndex != -1)
            {
               FScene["MC_Gift_" + this.FCurSelectedIndex].MC_Selected.visible = false;
            }
            this.FCurSelectedIndex = _loc3_;
            FScene["MC_Gift_" + this.FCurSelectedIndex].MC_Selected.visible = true;
         }
         this.UpdateLotteryBtn();
      }
      
      protected function OnGiftsMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param1.Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Invs[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftsOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:TUIButton = null;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FGifts = new Vector.<TUIButton>(GiftCount);
         _loc3_ = 0;
         while(_loc3_ < GiftCount)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = FScene["MC_Gift_" + _loc3_].MC_Box;
            _loc2_.OnMove = this.OnGiftsMove;
            _loc2_.OnOut = this.OnGiftsOut;
            _loc2_.OnClick = this.OnGiftsClick;
            _loc2_.Tag = _loc3_;
            this.FGifts[_loc3_] = _loc2_;
            FScene["MC_Gift_" + _loc3_].MC_ReciveFlag.mouseEnabled = false;
            FScene["MC_Gift_" + _loc3_].MC_Selected.mouseEnabled = false;
            FScene["MC_Gift_" + _loc3_].MC_Selected.visible = false;
            _loc3_++;
         }
         this.FLotteryCom = new TNewServerDrawLottery(this);
         this.FLotteryCom.InitWindow(FScene["MC_DrawPanel"]);
         this.FLotteryCom.Lottery_C2S = this.Lottery_C2S;
      }
   }
}

