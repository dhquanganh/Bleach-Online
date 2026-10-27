package Processors.Game.Lobby.Activity.HDEaster2016.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDEaster2016_1;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_1;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowEaster2016_1 extends TProcessorHDSingleWindowBase
   {
      
      protected var FMC_RechargeTasks:Vector.<Sprite>;
      
      protected var FBtn_RechargeTasks:Vector.<TUIButton>;
      
      protected var FMC_CostTasks:Vector.<Sprite>;
      
      protected var FBtn_CostTasks:Vector.<TUIButton>;
      
      protected var FMC_RechargeGifts:Vector.<Sprite>;
      
      protected var FBtn_RechargeGifts:Vector.<TUIButton>;
      
      protected var FMC_CostGifts:Vector.<Sprite>;
      
      protected var FBtn_CostGifts:Vector.<TUIButton>;
      
      protected var FTempIndex:uint;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FData:THDEasterData2016_1;
      
      protected var FConfig:THDEaster2016_1;
      
      public function TProcessorHDWindowEaster2016_1(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDEaster2016_1 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDEaster2016_1;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_RechargeTasks[_loc1_]["TF_0"].text = this.FConfig.RechargeTask[_loc1_].gold + "";
            this.FMC_RechargeTasks[_loc1_]["TF_1"].text = this.FConfig.RechargeTask[_loc1_].amount + "";
            this.FMC_CostTasks[_loc1_]["TF_1"].text = this.FConfig.ConsumeTask[_loc1_].amount + "";
            _loc1_++;
         }
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_RechargeGifts[_loc1_]["TF_Good"].text = this.FConfig.RechargeGift[_loc1_].amount + "";
            this.FMC_CostGifts[_loc1_]["TF_Good"].text = this.FConfig.ConsumeGift[_loc1_].amount + "";
            _loc1_++;
         }
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["TF_" + _loc1_].text = this.FConfig.BigAward.amount[_loc1_] + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as THDEasterData2016_1;
         FScene["TF_Consumed"].text = this.FData.Consumed + "";
         FScene["TF_HaveEgg01"].text = this.FData.HaveEgg01 + "";
         FScene["TF_HaveEgg02"].text = this.FData.HaveEgg02 + "";
         FScene["TF_HaveEgg03"].text = this.FData.HaveEgg03 + "";
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_RechargeTasks[_loc2_].Enabled = this.FData.RechargeTaskStatus[_loc2_] == 0 ? false : true;
            this.FBtn_CostTasks[_loc2_].Enabled = this.FData.ConsumeTaskStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_RechargeGifts[_loc2_].Enabled = this.FData.RechargeGiftStatus[_loc2_] == -1 ? false : true;
            this.FBtn_CostGifts[_loc2_].Enabled = this.FData.ConsumeGiftStatus[_loc2_] == -1 ? false : true;
            _loc2_++;
         }
         _loc4_ = this.FConfig.Rate;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_CostTask_" + _loc2_]["TF_0"].text = (this.FConfig.ConsumeTask[_loc2_].gold + this.FData.Round * _loc4_).toString();
            _loc2_++;
         }
         this.UpdateJackPoint();
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FConfig.BigAward.showType,this.FConfig.BigAward.awardId,this.FConfig.BigAward.showId);
         this.FBtn_Report.Visible = this.FConfig.BigAward.reportId != "";
         if(this.FData.JackPointStatus == 0)
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["MC_Already"].visible = false;
            this.FBtn_JackPointGet.Enabled = false;
         }
         if(this.FData.JackPointStatus == 1)
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["MC_Already"].visible = false;
            this.FBtn_JackPointGet.Enabled = true;
         }
         if(this.FData.JackPointStatus == -1)
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["MC_Already"].visible = true;
            this.FBtn_JackPointGet.Enabled = false;
         }
      }
      
      protected function ProcessorCostTasks(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ConsumeTask[param1.Tag].index);
      }
      
      protected function ProcessorRechargeTasks(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RechargeTask[param1.Tag].index);
      }
      
      protected function ProcessorCostGifts(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.HaveEgg03 + this.FData.HaveEgg01 < this.FConfig.ConsumeGift[param1.Tag].amount)
         {
            SToolReward.ShowMessage(this.FConfig.Text[2]);
            return;
         }
         this.FTempIndex = this.FConfig.ConsumeGift[param1.Tag].index;
         this.EggBuy(this.FData.HaveEgg03,this.FConfig.ConsumeGift[param1.Tag].amount,this.ConfirmCostBuy);
      }
      
      protected function ProcessorRechargeGifts(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.HaveEgg02 + this.FData.HaveEgg01 < this.FConfig.RechargeGift[param1.Tag].amount)
         {
            SToolReward.ShowMessage(this.FConfig.Text[1]);
            return;
         }
         this.FTempIndex = this.FConfig.RechargeGift[param1.Tag].index;
         this.EggBuy(this.FData.HaveEgg02,this.FConfig.RechargeGift[param1.Tag].amount,this.ConfirmRechargeBuy);
      }
      
      protected function ConfirmCostBuy(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FTempIndex);
      }
      
      protected function ConfirmRechargeBuy(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FTempIndex);
      }
      
      protected function EggBuy(param1:uint, param2:uint, param3:Function) : void
      {
         if(FUIWindowConfirmation == null)
         {
            FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         }
         if(param1 < param2)
         {
            if(FUIWindowConfirmation.IsSelected)
            {
               param3(null);
            }
            else
            {
               FUIWindowConfirmation.Text = TUtilityString.Format(this.FConfig.Text[0],param2 - param1);
               FUIWindowConfirmation.OnOK = param3;
               FUIWindowConfirmation.Visible = true;
            }
         }
         else
         {
            param3(null);
         }
      }
      
      protected function ProcessorCostGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.ConsunmeAwards[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorRechargeGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.RechargeAwards[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorJackPoint(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BigAward.index);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FConfig.BigAward.reportId);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 3;
         this.FMC_CostTasks = new Vector.<Sprite>(_loc2_);
         this.FBtn_CostTasks = new Vector.<TUIButton>(_loc2_);
         this.FMC_RechargeTasks = new Vector.<Sprite>(_loc2_);
         this.FBtn_RechargeTasks = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_CostTasks[_loc3_] = FScene["MC_CostTask_" + _loc3_];
            this.FBtn_CostTasks[_loc3_] = new TUIButton();
            this.FBtn_CostTasks[_loc3_].Substrate = this.FMC_CostTasks[_loc3_]["Btn_Get"];
            this.FBtn_CostTasks[_loc3_].Tag = _loc3_;
            this.FBtn_CostTasks[_loc3_].OnClick = this.ProcessorCostTasks;
            this.FMC_RechargeTasks[_loc3_] = FScene["MC_RechargeTask_" + _loc3_];
            this.FBtn_RechargeTasks[_loc3_] = new TUIButton();
            this.FBtn_RechargeTasks[_loc3_].Substrate = this.FMC_RechargeTasks[_loc3_]["Btn_Get"];
            this.FBtn_RechargeTasks[_loc3_].Tag = _loc3_;
            this.FBtn_RechargeTasks[_loc3_].OnClick = this.ProcessorRechargeTasks;
            _loc3_++;
         }
         _loc2_ = 3;
         this.FMC_CostGifts = new Vector.<Sprite>(_loc2_);
         this.FBtn_CostGifts = new Vector.<TUIButton>(_loc2_);
         this.FMC_RechargeGifts = new Vector.<Sprite>(_loc2_);
         this.FBtn_RechargeGifts = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_CostGifts[_loc3_] = FScene["MC_CostGift_" + _loc3_];
            this.FBtn_CostGifts[_loc3_] = new TUIButton();
            this.FBtn_CostGifts[_loc3_].Substrate = this.FMC_CostGifts[_loc3_]["MC_Gift"];
            this.FBtn_CostGifts[_loc3_].OnMove = this.ProcessorCostGiftOnMove;
            this.FBtn_CostGifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBtn_CostGifts[_loc3_].Tag = _loc3_;
            this.FBtn_CostGifts[_loc3_].OnClick = this.ProcessorCostGifts;
            this.FMC_RechargeGifts[_loc3_] = FScene["MC_RechargeGift_" + _loc3_];
            this.FBtn_RechargeGifts[_loc3_] = new TUIButton();
            this.FBtn_RechargeGifts[_loc3_].Substrate = this.FMC_RechargeGifts[_loc3_]["MC_Gift"];
            this.FBtn_RechargeGifts[_loc3_].OnMove = this.ProcessorRechargeGiftOnMove;
            this.FBtn_RechargeGifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBtn_RechargeGifts[_loc3_].Tag = _loc3_;
            this.FBtn_RechargeGifts[_loc3_].OnClick = this.ProcessorRechargeGifts;
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_JackPoint"]["MC_ShowAwardUI"]);
         this.FBtn_JackPointGet = new TUIButton();
         this.FBtn_JackPointGet.Substrate = FScene["MC_JackPoint"]["MC_ShowAwardUI"]["Btn_JackPiont_Get"];
         this.FBtn_JackPointGet.OnClick = this.ProcessorJackPoint;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_JackPoint"]["MC_ShowAwardUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

