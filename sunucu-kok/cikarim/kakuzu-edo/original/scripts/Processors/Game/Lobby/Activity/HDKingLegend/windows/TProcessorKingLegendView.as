package Processors.Game.Lobby.Activity.HDKingLegend.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.Agent.SParametersCore;
   import Logics.HDKingLegend.TActivityKingLegendData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.TPlayAnimaEffect;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_KingLegend;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorKingLegendView extends TUIComponent
   {
      
      public static const Extract_Count:int = 10;
      
      public static const Task_Count:int = 4;
      
      protected var FMC_Scene:Sprite;
      
      protected var FRechargeAwardBtn:TUIButton;
      
      protected var FRechargeTF:TextField;
      
      protected var FFreeGoldTF:TextField;
      
      protected var FRechargeBtn:TUIButton;
      
      protected var FRechargeStateMc:Sprite;
      
      protected var FCostGoldTF:TextField;
      
      protected var FCostGiftBtn:TUIButton;
      
      protected var FCostStateMc:Sprite;
      
      protected var FCurrentCostTF:TextField;
      
      protected var FPlayerOrderTF:TextField;
      
      protected var FSpeedOrderOneTF:TextField;
      
      protected var FSpeedOrderTwoTF:TextField;
      
      protected var FGetCouponOneTF:TextField;
      
      protected var FGetCouponTwoTF:TextField;
      
      protected var FExchargeOneBtn:TUIButton;
      
      protected var FExchargeTwoBtn:TUIButton;
      
      protected var FSelectBoxVec:Vector.<Sprite>;
      
      protected var FExtractAwardSlots:Vector.<TUISlot>;
      
      protected var FExtractBtn:TUIButton;
      
      protected var FTurntableEffect:TPlayAnimaEffect;
      
      protected var FExtractSpendGoldTF:TextField;
      
      protected var FChestsGiftBtn:TUIButton;
      
      protected var FStartChestsBtn:TUIButton;
      
      protected var FInfoTFList:Vector.<TextField>;
      
      protected var FTaskStateMcList:Vector.<Sprite>;
      
      protected var FTaskDecBgMCList:Vector.<Sprite>;
      
      private var TESTTF:TextField;
      
      protected var FData:TActivityKingLegendData;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FSendData:Function;
      
      public function TProcessorKingLegendView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         this.FRechargeAwardBtn = new TUIButton();
         this.FRechargeAwardBtn.Substrate = this.FMC_Scene["MC_GiftFirst"];
         this.FRechargeAwardBtn.OnMove = this.GiftBagOnMove;
         this.FRechargeAwardBtn.OnOut = this.GiftBagOnOut;
         this.FRechargeAwardBtn.OnClick = this.GetRechargeGift;
         this.FRechargeTF = this.FMC_Scene["TF_Recharge"];
         this.FFreeGoldTF = this.FMC_Scene["TF_FreeGold"];
         this.FRechargeBtn = new TUIButton();
         this.FRechargeBtn.Substrate = this.FMC_Scene["Btn_Recharge"];
         this.FRechargeBtn.OnClick = this.RechargeOnClick;
         this.FRechargeStateMc = this.FMC_Scene["MC_FinishFirst"];
         this.FRechargeStateMc.visible = false;
         this.FCostGoldTF = this.FMC_Scene["TF_DailyGold"];
         this.FCurrentCostTF = this.FMC_Scene["TF_CurrentCostGold"];
         this.FCostStateMc = this.FMC_Scene["MC_FinishSecond"];
         this.FCostStateMc.visible = false;
         this.FCostGiftBtn = new TUIButton();
         this.FCostGiftBtn.Substrate = this.FMC_Scene["MC_GiftSecond"];
         this.FCostGiftBtn.OnMove = this.CostOnMove;
         this.FCostGiftBtn.OnOut = this.GiftBagOnOut;
         this.FCostGiftBtn.OnClick = this.GetCostGiftOnClick;
         this.FPlayerOrderTF = this.FMC_Scene["TF_CurOrder"];
         this.FSpeedOrderOneTF = this.FMC_Scene["TF_SpendOrderOne"];
         this.FSpeedOrderTwoTF = this.FMC_Scene["TF_SpendOrderTwo"];
         this.FGetCouponOneTF = this.FMC_Scene["TF_GetCouponOne"];
         this.FGetCouponTwoTF = this.FMC_Scene["TF_GetCouponTwo"];
         this.FExchargeOneBtn = new TUIButton();
         this.FExchargeOneBtn.Substrate = this.FMC_Scene["Btn_ExchargeOne"];
         this.FExchargeOneBtn.OnClick = this.ExchargeCouponFun;
         this.FExchargeTwoBtn = new TUIButton();
         this.FExchargeTwoBtn.Substrate = this.FMC_Scene["Btn_ExchargeTwo"];
         this.FExchargeTwoBtn.OnClick = this.ExchargeCouponFun;
         this.FSelectBoxVec = new Vector.<Sprite>();
         this.FExtractAwardSlots = new Vector.<TUISlot>();
         _loc2_ = Extract_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_ExtractView"];
            this.FSelectBoxVec[_loc1_] = _loc3_["Item" + _loc1_]["SelectBox"];
            this.FSelectBoxVec[_loc1_].visible = false;
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["Item" + _loc1_]["Slot"];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FExtractAwardSlots[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FExtractBtn = new TUIButton();
         this.FExtractBtn.Substrate = this.FMC_Scene["Btn_Extract"];
         this.FExtractBtn.OnClick = this.ExtractOnClickFun;
         this.FExtractSpendGoldTF = this.FMC_Scene["TF_ExtractGold"];
         this.FChestsGiftBtn = new TUIButton();
         this.FChestsGiftBtn.Substrate = this.FMC_Scene["MC_Chests"];
         this.FChestsGiftBtn.OnMove = this.ChestsGiftOnMove;
         this.FChestsGiftBtn.OnOut = this.GiftBagOnOut;
         this.FStartChestsBtn = new TUIButton();
         this.FStartChestsBtn.Substrate = this.FMC_Scene["Btn_Chests"];
         this.FStartChestsBtn.OnClick = this.StartChestsOnClickFun;
         _loc2_ = Task_Count;
         this.FInfoTFList = new Vector.<TextField>();
         this.FTaskStateMcList = new Vector.<Sprite>();
         this.FTaskDecBgMCList = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Task_" + _loc1_];
            this.FInfoTFList[_loc1_] = _loc3_["InfoTF"];
            this.FTaskStateMcList[_loc1_] = _loc3_["MC_Right"];
            this.FTaskDecBgMCList[_loc1_] = _loc3_["MC_Bg"];
            _loc1_++;
         }
         this.FTurntableEffect = new TPlayAnimaEffect();
         this.FTurntableEffect.SelectVec = this.FSelectBoxVec;
         this.FTurntableEffect.FMix_ax = 2;
         this.FTurntableEffect.Fax = 40;
         this.FTurntableEffect.FMax_ax = 10;
         this.FTurntableEffect.FRotationTurns = 2;
         this.TESTTF = new TextField();
         this.TESTTF.width = 400;
         this.TESTTF.y = 150;
         this.TESTTF.visible = false;
         this.TESTTF.background = true;
         this.TESTTF.backgroundColor = 16711680;
         this.TESTTF.height = 200;
         this.FMC_Scene.addChild(this.TESTTF);
      }
      
      protected function RenderShowExtractList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FData.ExtractInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.ExtractInventories[_loc1_];
            this.FExtractAwardSlots[_loc1_].Context = null;
            this.FExtractAwardSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
         this.FExtractSpendGoldTF.text = this.FData.ActivityConfig.TurnTableGold.toString();
      }
      
      protected function RefreshTaskRecharge() : void
      {
         this.FRechargeTF.text = this.FData.ActivityConfig.RechargeGold.toString();
         this.FFreeGoldTF.text = this.FData.ActivityConfig.GetGold.toString();
         if(this.FData.TaskList[0].taskState == CONST_KingLegend.Task_UnFinish)
         {
            this.FRechargeAwardBtn.Enabled = false;
            this.FRechargeStateMc.visible = false;
         }
         else if(this.FData.TaskList[0].taskState == CONST_KingLegend.Task_Finish)
         {
            this.FRechargeAwardBtn.Enabled = false;
            this.FRechargeStateMc.visible = true;
         }
         else if(this.FData.TaskList[0].taskState == CONST_KingLegend.Task_GetAward)
         {
            this.FRechargeAwardBtn.Enabled = true;
            this.FRechargeStateMc.visible = false;
         }
      }
      
      protected function RefreshTaskCostGold() : void
      {
         this.FCostGoldTF.text = this.FData.ActivityConfig.CostGoldValue.toString();
         this.FCurrentCostTF.text = this.FData.CurCostGold.toString();
         if(this.FData.TaskList[1].taskState == CONST_KingLegend.Task_UnFinish)
         {
            this.FCostGiftBtn.Enabled = false;
            this.FCostStateMc.visible = false;
         }
         else if(this.FData.TaskList[1].taskState == CONST_KingLegend.Task_Finish)
         {
            this.FCostGiftBtn.Enabled = false;
            this.FCostStateMc.visible = true;
         }
         else if(this.FData.TaskList[1].taskState == CONST_KingLegend.Task_GetAward)
         {
            this.FCostGiftBtn.Enabled = true;
            this.FCostStateMc.visible = false;
         }
      }
      
      protected function RefreshTaskOrder() : void
      {
         this.FPlayerOrderTF.text = this.FData.PlayerOrderValue.toString();
         this.FSpeedOrderOneTF.text = this.FData.ActivityConfig.OrderArr[0].toString();
         this.FSpeedOrderTwoTF.text = this.FData.ActivityConfig.OrderArr[1].toString();
         this.FGetCouponOneTF.text = this.FData.ActivityConfig.TicketArr[0].toString();
         this.FGetCouponTwoTF.text = this.FData.ActivityConfig.TicketArr[1].toString();
         if(this.FData.ExchargeFirstState == CONST_KingLegend.Task_Finish)
         {
            this.FExchargeOneBtn.Enabled = false;
         }
         else
         {
            this.FExchargeOneBtn.Enabled = true;
         }
         if(this.FData.ExchargeSecondState == CONST_KingLegend.Task_Finish)
         {
            this.FExchargeTwoBtn.Enabled = false;
         }
         else
         {
            this.FExchargeTwoBtn.Enabled = true;
         }
      }
      
      protected function RefreshTaskChests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         _loc2_ = Task_Count;
         _loc6_ = true;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == 2)
            {
               _loc5_ = false;
               if(this.FData.ExchargeFirstState == CONST_KingLegend.Task_GetAward || this.FData.ExchargeFirstState == CONST_KingLegend.Task_Finish)
               {
                  _loc5_ = true;
               }
               else
               {
                  _loc5_ = false;
               }
               _loc4_ = _loc5_;
               if(this.FData.ExchargeSecondState == CONST_KingLegend.Task_GetAward || this.FData.ExchargeSecondState == CONST_KingLegend.Task_Finish)
               {
                  _loc5_ = true;
               }
               else
               {
                  _loc5_ = false;
               }
               _loc4_ ||= _loc5_;
               this.FTaskStateMcList[_loc1_].visible = _loc4_;
               if(_loc4_)
               {
                  this.FData.TaskList[_loc1_].taskCurValue = 1;
               }
               else
               {
                  this.FData.TaskList[_loc1_].taskCurValue = 0;
               }
            }
            else
            {
               _loc5_ = false;
               if(this.FData.TaskList[_loc1_].taskState == CONST_KingLegend.Task_GetAward || this.FData.TaskList[_loc1_].taskState == CONST_KingLegend.Task_Finish)
               {
                  this.FTaskStateMcList[_loc1_].visible = true;
                  _loc5_ = true;
               }
               else if(this.FData.TaskList[_loc1_].taskState == CONST_KingLegend.Task_UnFinish)
               {
                  this.FTaskStateMcList[_loc1_].visible = false;
                  _loc5_ = false;
               }
               _loc6_ &&= _loc5_;
            }
            this.FInfoTFList[_loc1_].text = this.FData.TaskList[_loc1_].taskCurValue + "/" + this.FData.TaskList[_loc1_].taskTotalValue;
            _loc3_ = this.FData.TaskList[_loc1_].taskCurValue / this.FData.TaskList[_loc1_].taskTotalValue;
            _loc3_ = _loc3_ >= 1 ? 1 : _loc3_;
            this.FTaskDecBgMCList[_loc1_].scaleX = _loc3_;
            _loc1_++;
         }
         if(this.FData.BagBtnState == 0)
         {
            if(_loc4_ && _loc6_)
            {
               this.FStartChestsBtn.Enabled = true;
            }
            else
            {
               this.FStartChestsBtn.Enabled = false;
            }
         }
         else
         {
            this.FStartChestsBtn.Enabled = false;
         }
      }
      
      protected function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FExtractAwardSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FExtractAwardSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function RechargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function ExtractOnClickFun(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FData.ActivityConfig.TurntableIndex;
         if(SLogicsCore.Character.CreditGold < this.FData.ActivityConfig.TurnTableGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FTurntableEffect.CurrentState == 0)
         {
            this.SendServiceData(_loc3_);
            this.FTurntableEffect.startPlay();
         }
      }
      
      protected function StartChestsOnClickFun(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FData.ActivityConfig.BagIndex;
         this.SendServiceData(_loc3_);
      }
      
      protected function GetRechargeGift(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FData.ActivityConfig.RechargeAwardIndex;
         this.SendServiceData(_loc3_);
      }
      
      protected function GetCostGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FData.ActivityConfig.CostGoldAwardIndex;
         this.SendServiceData(_loc3_);
      }
      
      protected function ExchargeCouponFun(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case this.FExchargeOneBtn:
               _loc3_ = this.FData.ActivityConfig.ExchargeIndexArr[0];
               break;
            case this.FExchargeTwoBtn:
               _loc3_ = this.FData.ActivityConfig.ExchargeIndexArr[1];
         }
         this.SendServiceData(_loc3_);
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FData.RechargeInventories);
         }
      }
      
      protected function CostOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FData.GetAwardInventories);
         }
      }
      
      protected function ChestsGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FData.BagAwardInventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      public function get GiftMoveFun() : Function
      {
         return this.FGiftMoveFun;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function get GiftOutFun() : Function
      {
         return this.FGiftOutFun;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function set Data(param1:TActivityKingLegendData) : void
      {
         this.FData = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdateExtractSlots();
            this.FTurntableEffect.update();
         }
      }
      
      public function ClearRecordDdata() : void
      {
      }
      
      protected function UpdateUI() : void
      {
         this.RenderShowExtractList();
         this.RefreshTaskRecharge();
         this.RefreshTaskCostGold();
         this.RefreshTaskOrder();
         this.RefreshTaskChests();
      }
      
      public function StopAnima(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 != this.FData.ActivityConfig.TurntableIndex)
         {
            return;
         }
         if(this.FData.GetExtractInfoVec == null)
         {
            return;
         }
         _loc2_ = int(this.FData.GetExtractInfoVec.length);
         if(this.FTurntableEffect.CurrentState != 0 && _loc2_ == 1)
         {
            this.FTurntableEffect.FindRewardPos(this.FData.GetExtractInfoVec[0]);
         }
         else if(this.FTurntableEffect.CurrentState != 0 && _loc2_ > 1)
         {
            this.FTurntableEffect.ClearSelectBox();
         }
         this.TESTTF.text = "";
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.TESTTF.appendText(this.FData.GetExtractInfoVec[_loc3_].toString() + "--------");
            _loc3_++;
         }
      }
   }
}

