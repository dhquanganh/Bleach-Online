package Processors.Game.Lobby.Activity.HDNewYearDay.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear.THDNewYearLuckEggData;
   import Logics.HDNewYear.VO.TNewYearLuckEggGiftVO;
   import Logics.HDNewYear.VO.TNewYearLuckEggVO;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearDay.components.TNewYearLuckEggRewardCom;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowHDNewYearLuckEgg extends TProcessorHDSingleWindowBase
   {
      
      protected const TUNKEGG_FRAMELABEL:String = "tunk";
      
      protected const GGROLLGIFTOVER_FRAME:uint = 2;
      
      protected const GGROLLGIFTOUT_FRAME:uint = 1;
      
      protected const GGROLLGIFTNOT_FRAME:uint = 3;
      
      protected var FData:THDNewYearLuckEggData;
      
      protected var FEggRewardCom:TNewYearLuckEggRewardCom;
      
      protected var FLoginGiftGetBtns:Vector.<TUIButton>;
      
      protected var FLoginGiftGetMCs:Vector.<MovieClip>;
      
      protected var FEggMCs:Vector.<MovieClip>;
      
      protected var FLookAwardBtns:Vector.<TUIButton>;
      
      protected var FEggRollGiftMCs:Vector.<MovieClip>;
      
      protected var FEggRollGiftGetBtns:Vector.<TUIButton>;
      
      protected var FEggBtns:Vector.<TUIButton>;
      
      protected var FLastTick:Number;
      
      protected var FCurTunkEggIndex:uint;
      
      public function TProcessorWindowHDNewYearLuckEgg(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
         this.FEggRewardCom.Visible = false;
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
         var _loc3_:TUIButton = null;
         var _loc4_:TNewYearLuckEggGiftVO = null;
         var _loc5_:TNewYearLuckEggVO = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         this.FData = param1 as THDNewYearLuckEggData;
         this.FLastTick = STimingCore.TickCount / 1000;
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LOGINGIFTS_COUNT)
         {
            _loc3_ = this.FLoginGiftGetBtns[_loc2_];
            _loc7_ = this.FLoginGiftGetMCs[_loc2_];
            _loc4_ = this.FData.LoginGifts[_loc2_];
            _loc3_.Enabled = _loc4_.GiftState == Activity_CanReceive;
            _loc7_.visible = _loc4_.GiftState == Activity_AlreadyReceive;
            _loc2_++;
         }
         _loc6_ = FScene["TF_HammerCount"];
         _loc6_.text = this.FData.HammerCount.toString();
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LUCKEGG_COUNT)
         {
            _loc7_ = this.FEggMCs[_loc2_];
            _loc5_ = this.FData.Eggs[_loc2_];
            _loc6_ = _loc7_["TF_GetEggRoll"];
            _loc6_.text = _loc5_.GetEggRollCount.toString();
            if(_loc5_.IsFree)
            {
               _loc6_ = _loc7_["TF_FreeCount"];
               _loc6_.text = _loc5_.CurCount + "/" + _loc5_.TotalCount;
            }
            else
            {
               _loc6_ = _loc7_["TF_NeedHammerCount"];
               _loc6_.text = _loc5_.NeedHammerCount.toString();
               _loc6_ = _loc7_["TF_NeedGoldCount"];
               _loc6_.text = _loc5_.NeedGold.toString();
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.EGGROLLGIFTS_COUNT)
         {
            _loc4_ = this.FData.EggRollGifts[_loc2_];
            _loc8_ = this.FEggRollGiftMCs[_loc2_];
            _loc7_ = _loc8_["MC_Get"];
            _loc6_ = _loc8_["TF_Count"];
            _loc6_.text = _loc4_.Condition.toString();
            _loc3_ = this.FEggRollGiftGetBtns[_loc2_];
            _loc3_.Enabled = _loc4_.GiftState == Activity_CanReceive;
            _loc7_.visible = _loc4_.GiftState == Activity_AlreadyReceive;
            _loc7_ = _loc8_["MC_Gift"];
            if(_loc4_.GiftState == Activity_AlreadyReceive)
            {
               _loc7_.gotoAndStop(this.GGROLLGIFTNOT_FRAME);
            }
            _loc2_++;
         }
         _loc8_ = FScene["MC_EggGiftScene"];
         _loc6_ = _loc8_["TF_EggCount"];
         _loc6_.text = this.FData.EggRollCount.toString();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FData != null)
         {
            this.EggFrameProcessor();
         }
         if(!this.Visible)
         {
            return;
         }
         this.FEggRewardCom.LogicsPerform();
         this.CountDown();
      }
      
      protected function EggFrameProcessor() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LUCKEGG_COUNT)
         {
            _loc1_ = this.FEggMCs[_loc2_];
            _loc4_ = this.FEggBtns[_loc2_];
            if(_loc1_.currentFrameLabel == this.TUNKEGG_FRAMELABEL)
            {
               _loc3_ = uint(this.FData.GetEggDataIndexByVecIndex(_loc2_));
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
            }
            if(_loc1_.currentFrame == 1)
            {
               _loc4_.Visible = true;
            }
            _loc2_++;
         }
      }
      
      protected function CountDown() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TNewYearLuckEggVO = null;
         _loc1_ = STimingCore.TickCount / 1000 - this.FLastTick;
         this.FLastTick += _loc1_;
         this.FData.UpdateFreeEggRemainTime(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LUCKEGG_COUNT)
         {
            _loc5_ = this.FData.Eggs[_loc2_];
            if(_loc5_.IsFree)
            {
               _loc3_ = this.FEggMCs[_loc2_];
               _loc4_ = _loc3_["TF_Time"];
               _loc4_.text = TUtilityTiming.fomatTime(_loc5_.RemainTime);
            }
            _loc2_++;
         }
      }
      
      protected function TunkEgg() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TUIButton = null;
         _loc1_ = this.FEggMCs[this.FCurTunkEggIndex];
         _loc1_.gotoAndPlay(2);
         _loc2_ = this.FEggBtns[this.FCurTunkEggIndex];
         _loc2_.Visible = false;
      }
      
      protected function OnLoginGiftBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         _loc3_ = uint(this.FData.Config.LoginAward[_loc3_].index);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      protected function OnLoginGiftBtnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TNewYearLuckEggGiftVO = null;
         _loc3_ = uint((param1 as TUIButton).Tag);
         _loc4_ = this.FData.LoginGifts[_loc3_];
         ProcessorOnGiftBoxMove(this,_loc4_.Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnLoginGiftBtnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnLookAwardBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         this.FEggRewardCom.Show(this.FData,_loc3_);
      }
      
      protected function OnEggRollAwardGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         _loc3_ = uint(this.FData.Config.EggTicketAward[_loc3_].index);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      protected function OnEggBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         var _loc5_:TNewYearLuckEggVO = null;
         var _loc6_:uint = 0;
         this.FCurTunkEggIndex = (param1 as TUIButton).Tag;
         _loc5_ = this.FData.Eggs[this.FCurTunkEggIndex];
         if(_loc5_.IsFree)
         {
            if(_loc5_.CurCount >= _loc5_.TotalCount)
            {
               SToolReward.ShowMessage(this.FData.Language.GetStr2());
               return;
            }
            if(_loc5_.RemainTime > 0)
            {
               SToolReward.ShowMessage(this.FData.Language.GetStr0());
               return;
            }
         }
         else
         {
            _loc6_ = uint(this.FData.GetEggNeedGold(this.FCurTunkEggIndex));
            if(_loc6_ != 0)
            {
               if(_loc6_ <= SLogicsCore.Character.CreditGold)
               {
                  FUIWindowConfirmation.Text = this.FData.Language.GetStr1(_loc6_);
                  FUIWindowConfirmation.OnOK = this.OnEggBtnClickOK;
                  FUIWindowConfirmation.Visible = true;
                  return;
               }
               FUIWindowRecharge.SetGoldNum(_loc6_);
               FUIWindowRecharge.Visible = true;
               return;
            }
         }
         this.TunkEgg();
      }
      
      protected function OnRollGiftMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TNewYearLuckEggGiftVO = null;
         _loc3_ = param1.target as MovieClip;
         _loc2_ = uint(_loc3_.Tag);
         _loc4_ = this.FData.EggRollGifts[_loc2_];
         ProcessorOnGiftBoxMove(this,_loc4_.Inventories,TOverlayerGiftBox.TYPE_ALL);
         if(_loc3_.currentFrame != this.GGROLLGIFTNOT_FRAME)
         {
            _loc3_.gotoAndStop(this.GGROLLGIFTOVER_FRAME);
         }
      }
      
      protected function OnRollGiftOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.target as MovieClip;
         ProcessorOnGiftBoxOut(this);
         if(_loc2_.currentFrame != this.GGROLLGIFTNOT_FRAME)
         {
            _loc2_.gotoAndStop(this.GGROLLGIFTOUT_FRAME);
         }
      }
      
      protected function OnEggBtnClickOK(param1:Object) : void
      {
         this.TunkEgg();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUIButton = null;
         super.InitWindow(param1);
         this.FLoginGiftGetBtns = new Vector.<TUIButton>(THDNewYearLuckEggData.LOGINGIFTS_COUNT);
         this.FLoginGiftGetMCs = new Vector.<MovieClip>(THDNewYearLuckEggData.LOGINGIFTS_COUNT);
         this.FEggMCs = new Vector.<MovieClip>(THDNewYearLuckEggData.LUCKEGG_COUNT);
         this.FLookAwardBtns = new Vector.<TUIButton>(THDNewYearLuckEggData.LUCKEGG_COUNT);
         this.FEggRollGiftMCs = new Vector.<MovieClip>(THDNewYearLuckEggData.EGGROLLGIFTS_COUNT);
         this.FEggRollGiftGetBtns = new Vector.<TUIButton>(THDNewYearLuckEggData.EGGROLLGIFTS_COUNT);
         this.FEggBtns = new Vector.<TUIButton>(THDNewYearLuckEggData.LUCKEGG_COUNT);
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LOGINGIFTS_COUNT)
         {
            _loc6_ = new TUIButton();
            _loc6_.Tag = _loc2_;
            _loc6_.Substrate = FScene["MC_GetLogin"]["Btn_LoginGift_" + _loc2_];
            _loc6_.OnClick = this.OnLoginGiftBtnClick;
            _loc6_.OnMove = this.OnLoginGiftBtnMove;
            _loc6_.OnOut = this.OnLoginGiftBtnOut;
            this.FLoginGiftGetBtns[_loc2_] = _loc6_;
            _loc4_ = FScene["MC_GetLogin"]["MC_GetLoginGift_" + _loc2_];
            this.FLoginGiftGetMCs[_loc2_] = _loc4_;
            _loc4_.mouseEnabled = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.LUCKEGG_COUNT)
         {
            _loc4_ = FScene["MC_Egg_" + _loc2_];
            this.FEggMCs[_loc2_] = _loc4_;
            _loc6_ = new TUIButton();
            _loc6_.Tag = _loc2_;
            _loc6_.Substrate = _loc4_["Btn_LookAward"];
            _loc6_.OnClick = this.OnLookAwardBtnClick;
            this.FLookAwardBtns[_loc2_] = _loc6_;
            _loc6_ = new TUIButton();
            _loc6_.Tag = _loc2_;
            _loc6_.Substrate = _loc4_["Btn_Egg"];
            _loc6_.OnClick = this.OnEggBtnClick;
            this.FEggBtns[_loc2_] = _loc6_;
            _loc2_++;
         }
         _loc3_ = FScene["MC_EggGiftScene"];
         _loc3_.mouseEnabled = false;
         _loc2_ = 0;
         while(_loc2_ < THDNewYearLuckEggData.EGGROLLGIFTS_COUNT)
         {
            _loc4_ = _loc3_["MC_EggRollGift_" + _loc2_];
            _loc4_.mouseEnabled = false;
            this.FEggRollGiftMCs[_loc2_] = _loc4_;
            _loc6_ = new TUIButton();
            _loc6_.Tag = _loc2_;
            _loc6_.Substrate = _loc4_["Btn_Get"];
            _loc6_.OnClick = this.OnEggRollAwardGetBtnClick;
            this.FEggRollGiftGetBtns[_loc2_] = _loc6_;
            _loc5_ = _loc4_["MC_Gift"];
            _loc5_.Tag = _loc2_;
            _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnRollGiftMove);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.OnRollGiftOut);
            _loc5_.gotoAndStop(this.GGROLLGIFTOUT_FRAME);
            _loc2_++;
         }
         this.FEggRewardCom = new TNewYearLuckEggRewardCom(FParent);
         this.FEggRewardCom.Visible = false;
         this.FEggRewardCom.UIDispatch(FScene["MC_EggRewardCom"]);
      }
   }
}

