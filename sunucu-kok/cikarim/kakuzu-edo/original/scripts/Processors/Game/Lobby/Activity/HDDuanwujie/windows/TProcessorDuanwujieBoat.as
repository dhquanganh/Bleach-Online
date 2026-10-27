package Processors.Game.Lobby.Activity.HDDuanwujie.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDDuanwujieBoat;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDuanwujie.TDuanwujieBoat;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorDuanwujieBoat extends TProcessorHDSingleWindowBase
   {
      
      public static const BAREACHLEN:Number = 651 / 6;
      
      protected var events:Vector.<int> = Vector.<int>([10,20,30,50,105]);
      
      protected var FBtn_AddCount:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FBtn_Start:TUIButton;
      
      protected var FBtn_Over:TUIButton;
      
      protected var FBtn_Cheer:TUIButton;
      
      protected var FBtn_CheerTen:TUIButton;
      
      protected var FBtn_LevelAwards:Vector.<TUIButton>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FSpeedBlock:Vector.<uint>;
      
      protected var FSpeedBlockEx:Vector.<uint>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FData:TDuanwujieBoat;
      
      public function TProcessorDuanwujieBoat(param1:TUIComponent)
      {
         super(param1);
         FHint = new THint();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDDuanwujieBoat = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDDuanwujieBoat;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_CostOnce"].text = _loc3_.Cheer.gold + "";
         FScene["TF_CostTen"].text = _loc3_.Cheer.gold * 10 + "";
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["TF_M_" + _loc1_].text = _loc3_.Morale.nums[_loc1_] + "";
            _loc1_++;
         }
         FScene["MC_Boat2"]["TF_Name"].text = SLogicsCore.Character.NickName;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TDuanwujieBoat;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.ShowAwards.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         FScene["TF_Count"].text = this.FData.GameCount + "";
         FScene["TF_Score"].text = this.FData.Score + "";
         FScene["TF_AddSpeed"].text = this.FData.Morale * this.FData.Config.Morale.speeds + "";
         this.GetBuffs(this.FData.Buffs);
         this.SetParams();
         this.Final();
         this.UpdateTheFuckingBar();
         this.UpdateJackPoint();
         this.FBtn_Cheer.Enabled = this.FData.Config.Morale.nums[5] - this.FData.Morale < this.FData.Config.Cheer.morale ? false : true;
         this.FBtn_CheerTen.Enabled = this.FData.Config.Morale.nums[5] - this.FData.Morale < this.FData.Config.Cheer.morale * 10 ? false : true;
         this.FBtn_Start.Enabled = this.FData.GameCount > 0 ? true : false;
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         FScene["MC_MountPoint"]["SP_ShowUI"]["TF_Cost"].text = this.FData.Config.BigAward.gold + "";
         if(this.FData.LastBigAward == -1)
         {
            FScene["MC_MountPoint"]["SP_ShowUI"]["SP_AlreadyBuy"].visible = true;
            this.FBtn_JackPointGet.Visible = false;
         }
         else
         {
            FScene["MC_MountPoint"]["SP_ShowUI"]["SP_AlreadyBuy"].visible = false;
            this.FBtn_JackPointGet.Visible = true;
            this.FBtn_JackPointGet.Enabled = true;
         }
      }
      
      protected function UpdateTheFuckingBar() : void
      {
         FScene["MC_Bar"].width = (this.FData.Morale - this.FData.Config.Morale.nums[this.FData.CurPeriod - 1]) / (this.FData.Config.Morale.nums[this.FData.CurPeriod] - this.FData.Config.Morale.nums[this.FData.CurPeriod - 1]) * BAREACHLEN + this.FData.CurPeriod * BAREACHLEN;
         if(this.FData.Morale == this.FData.Config.Morale.nums[5])
         {
            FScene["MC_Bar"].width = 6 * BAREACHLEN;
         }
      }
      
      protected function GetBuffs(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 == 0)
         {
            return;
         }
         _loc2_ = 5;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.events[_loc3_] = this.FData.Buffs % 10;
            this.FData.Buffs = uint(this.FData.Buffs / 100);
            _loc3_++;
         }
         _loc2_ = 5;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.FData.Config.Events[this.events[_loc3_] - 1].type == 1)
            {
               this.events[_loc3_] = this.FData.Config.Events[this.events[_loc3_] - 1].value * -1;
            }
            else
            {
               this.events[_loc3_] = this.FData.Config.Events[this.events[_loc3_] - 1].value * 1;
            }
            _loc3_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
            _loc1_ = 4;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.FSlots[_loc2_].Update();
               _loc2_++;
            }
            _loc3_ = this.FData.TimeEnd - STimingCore.ServerTick;
            if(_loc3_ > 0)
            {
               FScene["MC_Level"].visible = false;
               FScene["MC_Buffs"].visible = true;
               if(this.FBtn_Cheer.Enabled != false)
               {
                  this.FBtn_Cheer.Enabled = false;
                  this.FBtn_CheerTen.Enabled = false;
               }
               this.FBtn_Start.Visible = false;
               this.FBtn_Over.Visible = true;
               FScene["MC_Boat2"].x = this.GetPosByTime(STimingCore.ServerTickM);
               _loc4_ = (STimingCore.ServerTickM - this.FData.TimeStart * 1000) / 1000 / this.FData.Config.NpcSpeed;
               if(_loc4_ <= 1)
               {
                  FScene["MC_Boat1"].x = _loc4_ * 600;
               }
            }
            else
            {
               FScene["MC_Level"].visible = false;
               FScene["MC_Buffs"].visible = false;
               FScene["MC_Boat2"]["Effect_fast"].visible = false;
               FScene["MC_Boat2"]["Effect_slow"].visible = false;
               this.FBtn_Start.Visible = true;
               this.FBtn_Over.Visible = false;
               if(this.FData.Evaluation == 0)
               {
                  FScene["TF_Speed"].text = "";
                  FScene["TF_Time"].text = "00:00:00";
                  FScene["MC_Boat1"].x = 0;
                  FScene["MC_Boat2"].x = 0;
                  _loc1_ = 5;
                  _loc2_ = 0;
                  while(_loc2_ < _loc1_)
                  {
                     this.FBtn_LevelAwards[_loc2_].Enabled = false;
                     FScene["Btn_Level_" + _loc2_]["effect"].gotoAndStop(1);
                     _loc2_++;
                  }
               }
               else if(this.FData.Evaluation == 1)
               {
                  FScene["MC_Level"].visible = true;
                  FScene["TF_Speed"].text = "";
                  this.FBtn_Start.Enabled = false;
                  FScene["MC_Boat1"].x = 600;
                  FScene["MC_Boat2"].x = 600;
                  if(this.FBtn_Cheer.Enabled != false)
                  {
                     this.FBtn_Cheer.Enabled = false;
                     this.FBtn_CheerTen.Enabled = false;
                  }
                  FScene["TF_Time"].text = TUtilityTiming.fomatTimeTwo(this.FData.Level).toString();
                  _loc1_ = 5;
                  _loc2_ = 0;
                  while(_loc2_ < _loc1_)
                  {
                     this.FBtn_LevelAwards[_loc2_].Enabled = false;
                     if(this.FData.Level < this.FData.Config.Evaluation.evaluation[_loc2_])
                     {
                        this.FBtn_LevelAwards[_loc2_].Enabled = true;
                        FScene["Btn_Level_" + _loc2_]["effect"].play();
                        break;
                     }
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      protected function updataUI(param1:int) : void
      {
         if(param1 > 0)
         {
            FScene["MC_Buffs"].gotoAndStop(1);
            FScene["MC_Boat2"]["Effect_fast"].visible = true;
            FScene["MC_Boat2"]["Effect_slow"].visible = false;
         }
         else if(param1 < 0)
         {
            FScene["MC_Buffs"].gotoAndStop(2);
            FScene["MC_Boat2"]["Effect_slow"].visible = true;
            FScene["MC_Boat2"]["Effect_fast"].visible = false;
         }
         else
         {
            FScene["MC_Buffs"].gotoAndStop(4);
            FScene["MC_Boat2"]["Effect_slow"].visible = false;
            FScene["MC_Boat2"]["Effect_fast"].visible = false;
         }
         FScene["TF_Time"].text = TUtilityTiming.fomatTimeTwo(STimingCore.ServerTick - this.FData.TimeStart).toString();
      }
      
      protected function Final() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         _loc1_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FData.Level < this.FData.Config.Evaluation.evaluation[_loc2_])
            {
               FScene["MC_Level"].gotoAndStop(_loc2_ + 1);
               return;
            }
            _loc2_++;
         }
      }
      
      protected function GetPosByTime(param1:Number) : Number
      {
         var _loc2_:uint = 0;
         var _loc3_:* = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         this.FData.TimeStart = this.FData.TimeEnd - this.FSpeedBlockEx[4];
         _loc7_ = param1 - this.FData.TimeStart * 1000;
         _loc7_ = _loc7_ / 1000;
         _loc2_ = 5;
         _loc3_ = 4;
         while(_loc3_ >= 0)
         {
            if(_loc7_ >= this.FSpeedBlockEx[_loc3_])
            {
               _loc5_ = _loc3_ + 1;
               break;
            }
            _loc3_--;
         }
         if(_loc7_ < this.FSpeedBlockEx[0])
         {
            _loc6_ = _loc7_ / this.FSpeedBlockEx[0];
            _loc8_ = 0;
         }
         else
         {
            _loc6_ = (_loc7_ - this.FSpeedBlockEx[_loc5_]) / this.FSpeedBlock[_loc5_];
            _loc8_ = 120;
         }
         if(this.events[_loc5_] >= 0)
         {
            FScene["TF_Speed"].text = this.FData.Config.Speed + this.FData.Morale * this.FData.Config.Morale.speeds + " +" + this.events[_loc5_];
         }
         else
         {
            FScene["TF_Speed"].text = this.FData.Config.Speed + this.FData.Morale * this.FData.Config.Morale.speeds + " " + this.events[_loc5_];
         }
         this.updataUI(this.events[_loc5_]);
         return _loc6_ * 120 + _loc5_ * 120 + _loc8_;
      }
      
      protected function SetParams() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FSpeedBlock = new Vector.<uint>(5);
         this.FSpeedBlockEx = new Vector.<uint>(5);
         _loc1_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSpeedBlock[_loc2_] = this.FData.Config.Length / 5 / (this.FData.Config.Speed + this.FData.Morale * this.FData.Config.Morale.speeds + this.events[_loc2_]);
            _loc2_++;
         }
         this.FSpeedBlockEx[0] = this.FSpeedBlock[0];
         _loc1_ = 5;
         _loc2_ = 1;
         while(_loc2_ < _loc1_)
         {
            this.FSpeedBlockEx[_loc2_] = this.FSpeedBlock[_loc2_] + this.FSpeedBlockEx[_loc2_ - 1];
            _loc2_++;
         }
      }
      
      protected function ProcessorCheer(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cheer.gold,this.ProcessorCheerGold);
      }
      
      protected function ProcessorCheerGold(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Cheer.index,0,_loc2_);
      }
      
      protected function ProcessorCheerTen(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cheer.gold * 10,this.ProcessorCheerTenGold);
      }
      
      protected function ProcessorCheerTenGold(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Cheer.index,0,_loc2_);
      }
      
      protected function ProcessorStart(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Start);
      }
      
      protected function ProcessorOver(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Over.gold,this.ProcessorOverGold);
      }
      
      protected function ProcessorOverGold(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Over.index);
      }
      
      protected function ProcessorAddCount(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.GameCount.gold,this.ProcessorAddCountGold);
      }
      
      protected function ProcessorAddCountGold(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.GameCount.index);
      }
      
      protected function ProcessorLevelAward(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Evaluation.index);
      }
      
      protected function ShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
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
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
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
            SToolReward.ShowMessage(this.FData.Config.Texts[0] + "");
         }
      }
      
      protected function ProcessorLevelAwardsOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.BoatAwards[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorTextOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name);
      }
      
      protected function ProcessorLevelAwardsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function ProcessorOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         FHint.Caption = this.FData.Config.Texts[1] + ": " + this.FData.Config.Morale.score[_loc2_] + "";
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorJackPoint(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BigAward.index);
      }
      
      protected function ProcessorGoldBuyJackPoint(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.BigAward.gold,this.ProcessorJackPoint);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Slot" + _loc3_]["Slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FBtn_AddCount = new TUIButton();
         this.FBtn_AddCount.Substrate = FScene["Btn_AddCount"];
         this.FBtn_AddCount.OnClick = this.ProcessorAddCount;
         this.FBtn_Start = new TUIButton();
         this.FBtn_Start.Substrate = FScene["Btn_Start"];
         this.FBtn_Start.OnClick = this.ProcessorStart;
         this.FBtn_Over = new TUIButton();
         this.FBtn_Over.Substrate = FScene["Btn_Over"];
         this.FBtn_Over.OnClick = this.ProcessorOver;
         this.FBtn_Cheer = new TUIButton();
         this.FBtn_Cheer.Substrate = FScene["Btn_Cheer"];
         this.FBtn_Cheer.OnClick = this.ProcessorCheer;
         this.FBtn_CheerTen = new TUIButton();
         this.FBtn_CheerTen.Substrate = FScene["Btn_CheerTen"];
         this.FBtn_CheerTen.OnClick = this.ProcessorCheerTen;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ShowShopOnClick;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_DuanwujieBoatShop") as MovieClip);
         _loc2_ = 5;
         this.FBtn_LevelAwards = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_LevelAwards[_loc3_] = new TUIButton();
            this.FBtn_LevelAwards[_loc3_].Substrate = FScene["Btn_Level_" + _loc3_];
            this.FBtn_LevelAwards[_loc3_].Tag = _loc3_;
            this.FBtn_LevelAwards[_loc3_].OnClick = this.ProcessorLevelAward;
            this.FBtn_LevelAwards[_loc3_].OnMove = this.ProcessorLevelAwardsOnMove;
            this.FBtn_LevelAwards[_loc3_].OnOut = this.ProcessorLevelAwardsOnOut;
            _loc3_++;
         }
         FScene["MC_Boat2"]["Effect_slow"].play();
         FScene["MC_Boat2"]["Effect_fast"].play();
         _loc2_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene["TF_M_" + _loc3_].addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorOnMove);
            FScene["TF_M_" + _loc3_].addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorOnOut);
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_MountPoint"]["SP_ShowUI"]);
         this.FBtn_JackPointGet = new TUIButton();
         this.FBtn_JackPointGet.Substrate = FScene["MC_MountPoint"]["SP_ShowUI"]["Btn_Buy"];
         this.FBtn_JackPointGet.OnClick = this.ProcessorGoldBuyJackPoint;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_MountPoint"]["SP_ShowUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

