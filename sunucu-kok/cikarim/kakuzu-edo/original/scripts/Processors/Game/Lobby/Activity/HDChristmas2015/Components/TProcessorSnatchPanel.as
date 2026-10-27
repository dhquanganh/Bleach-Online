package Processors.Game.Lobby.Activity.HDChristmas2015.Components
{
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.HDChristmas2015.TSledData;
   import Logics.HDChristmas2015.VO.TSledVO;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorSnatchPanel extends TUIComponent
   {
      
      protected var FData:TSledData;
      
      protected var FMainUI:MovieClip;
      
      protected var FReceiveAwardBtn:TUIButton;
      
      protected var FAKeyServiceBtn:TUIButton;
      
      protected var FEffectGlow:TEffectBaseGlow;
      
      protected var FRemainTime:int;
      
      protected var FSleds:Vector.<TSledModel>;
      
      protected var FSledCon:Sprite;
      
      protected var FCSFun:Function;
      
      protected var FCSID:uint;
      
      protected var FUpdateView:Function;
      
      public function TProcessorSnatchPanel(param1:TUIComponent)
      {
         super(param1);
         this.FSleds = new Vector.<TSledModel>();
      }
      
      protected function ClearAllSled() : void
      {
         var _loc1_:TSledModel = null;
         for each(_loc1_ in this.FSleds)
         {
            this.FSledCon.removeChild(_loc1_);
            TSledModelPool.RelObj(_loc1_);
         }
         this.FSleds.length = 0;
      }
      
      protected function UpdateSleds() : void
      {
         var _loc1_:TSledModel = null;
         var _loc2_:TSledVO = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         this.ClearAllSled();
         _loc4_ = 0;
         for each(_loc2_ in this.FData.SledVOs)
         {
            _loc1_ = TSledModelPool.GetObj();
            _loc1_.Arrivals = this.SeldArrivals;
            this.FSleds.push(_loc1_);
            this.FSledCon.addChild(_loc1_);
            _loc1_.UpdateData(_loc2_,this.FData.Config.TransportTime,this.FData.Config.TransportProtect);
            _loc3_ = (this.FSledCon.height - _loc1_.height) / this.FData.SledVOs.length;
            _loc1_.y = _loc4_ * _loc3_;
            _loc4_++;
            _loc1_.buttonMode = !_loc2_.IsRobbed && _loc2_ != this.FData.GetMySled();
         }
      }
      
      protected function MySledArrivals() : void
      {
         this.FData.MySledArrivals();
         this.FUpdateView(this.FData);
      }
      
      protected function OnReceiveAwardBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.ReceiveAwardIndex);
      }
      
      protected function OnAKeyServiceBtnClick(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.Config.OnekeyArrival.gold,this.AKeyServiceOK);
      }
      
      protected function AKeyServiceOK(param1:Object) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.OnekeyArrival.index);
         this.MySledArrivals();
      }
      
      protected function SeldArrivals(param1:TSledModel) : void
      {
         if(param1.Data != this.FData.GetMySled())
         {
            this.FCSFun(this.FCSID,this.FData.Config.RobberyInterfaceIndex);
         }
         else
         {
            this.MySledArrivals();
         }
      }
      
      protected function OnSledConClick(param1:MouseEvent) : void
      {
         var _loc2_:TSledModel = null;
         _loc2_ = param1.target as TSledModel;
         if(_loc2_ != null && _loc2_.buttonMode)
         {
            if(this.FData.CurWheelSnatched)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.curWheelSnatched);
            }
            else if(this.FData.RemainSnatch == 0)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.snatchTimesLess);
            }
            else if(_loc2_.SuperTime)
            {
               SToolReward.ShowMessage(this.FData.Config.Language.superTime);
            }
            else
            {
               this.FCSFun(this.FCSID,this.FData.Config.RobberyIndex.index,0,Vector.<int>([_loc2_.Data.HighID,_loc2_.Data.LowID]));
            }
         }
      }
      
      public function set CSFun(param1:Function) : void
      {
         this.FCSFun = param1;
      }
      
      public function set CSID(param1:uint) : void
      {
         this.FCSID = param1;
      }
      
      public function set UpdateView(param1:Function) : void
      {
         this.FUpdateView = param1;
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FSledCon = this.FMainUI.MC_SledCon;
         this.FSledCon.addEventListener(MouseEvent.CLICK,this.OnSledConClick);
         this.FReceiveAwardBtn = new TUIButton();
         this.FReceiveAwardBtn.Substrate = this.FMainUI.Btn_ReceiveAward;
         this.FReceiveAwardBtn.OnClick = this.OnReceiveAwardBtnClick;
         this.FAKeyServiceBtn = new TUIButton();
         this.FAKeyServiceBtn.Substrate = this.FMainUI.Btn_AKeyService;
         this.FAKeyServiceBtn.OnClick = this.OnAKeyServiceBtnClick;
         this.FEffectGlow = new TEffectBaseGlow();
         this.FEffectGlow.SetParameters(this.FMainUI.Btn_ReceiveAward,16711680,1);
      }
      
      public function UpdateDataBase(param1:TSledData) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:TSledModel = null;
         var _loc6_:TSledVO = null;
         var _loc7_:uint = 0;
         this.FData = param1;
         if(this.FData.HaveTransportReward)
         {
            this.FReceiveAwardBtn.Enabled = true;
         }
         else
         {
            this.FEffectGlow.Stop();
            this.FReceiveAwardBtn.Enabled = false;
         }
         this.FAKeyServiceBtn.Enabled = this.FData.CurTransporting;
         this.FMainUI.TF_AKeyServiceCost.text = String(this.FData.Config.OnekeyArrival.gold);
         this.FMainUI.TF_FreeNumber.text = this.FData.CurFreeTransport.toString();
         if(!this.FData.CurTransporting)
         {
            this.FRemainTime = this.FData.Config.TransportTime;
            this.FMainUI.TF_RemainTime.text = TUtilityTiming.fomatTimeTwo(this.FRemainTime).toString();
         }
         this.UpdateSleds();
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:TSledModel = null;
         if(Boolean(this.FData) && Boolean(this.FMainUI))
         {
            if(this.FData.CurTransporting)
            {
               _loc1_ = STimingCore.ServerTick - this.FData.GetTransportTimestamp();
               this.FRemainTime = this.FData.Config.TransportTime - _loc1_;
               if(this.FRemainTime <= 0)
               {
                  this.FRemainTime = 0;
               }
               this.FMainUI.TF_RemainTime.text = TUtilityTiming.fomatTimeTwo(this.FRemainTime).toString();
            }
            for each(_loc2_ in this.FSleds)
            {
               _loc2_.LogicsPerform();
            }
            if(this.FData.HaveTransportReward)
            {
               this.FEffectGlow.Run();
            }
         }
      }
      
      public function Reset() : void
      {
         this.FEffectGlow.Stop();
      }
   }
}

