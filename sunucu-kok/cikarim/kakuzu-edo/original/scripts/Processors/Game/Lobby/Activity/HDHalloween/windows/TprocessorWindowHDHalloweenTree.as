package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.HDActivityHalloween.TActivityHalloweenTreeData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.TPlayAnimaEffect;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITYHALLOWEEN;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TprocessorWindowHDHalloweenTree extends TUIComponent
   {
      
      protected const Props_Count:int = 4;
      
      protected const Award_Count:int = 9;
      
      protected const Gift_Count:int = 5;
      
      protected const Anima_Time:Number = 1000;
      
      protected var FMC_Scene:Sprite;
      
      protected var FPropSlots:Vector.<TUISlot>;
      
      protected var FPropPosTF:Vector.<TextField>;
      
      protected var FAwardSlots:Vector.<TUISlot>;
      
      protected var FAwardSps:Vector.<Sprite>;
      
      protected var FAnimaBgList:Vector.<Sprite>;
      
      protected var FRechargeTF:TextField;
      
      protected var FRechargeBtn:TUIButton;
      
      protected var FWaterBtn:TUIButton;
      
      protected var FResidueWaterTimesTF:TextField;
      
      protected var FWaterTimesTF:TextField;
      
      protected var FTreeLevelTF:TextField;
      
      protected var FTreesMc:MovieClip;
      
      protected var FGetAwardBtn:TUIButton;
      
      protected var FMC_PercentTF:TextField;
      
      protected var FMC_ScrollBar:Sprite;
      
      protected var FGiftsList:Vector.<TUIButton>;
      
      protected var FCurrentGetExp:int;
      
      protected var FMC_Anima:MovieClip;
      
      protected var FIsWater:Boolean;
      
      protected var FHint:THint;
      
      protected var FEffect:TPlayAnimaEffect;
      
      protected var FActivityHalloweenTreeData:TActivityHalloweenTreeData;
      
      protected var FWateringFun:Function;
      
      protected var FGetAwardFun:Function;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      public function TprocessorWindowHDHalloweenTree(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.FPropSlots = new Vector.<TUISlot>();
         this.FPropPosTF = new Vector.<TextField>();
         this.FAwardSlots = new Vector.<TUISlot>();
         this.FAwardSps = new Vector.<Sprite>();
         this.FAnimaBgList = new Vector.<Sprite>();
         this.FGiftsList = new Vector.<TUIButton>();
         this.FHint = new THint();
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FCurrentGetExp = 0;
         this.FRechargeTF = this.FMC_Scene["MC_RechargeTF"];
         this.FRechargeBtn = new TUIButton();
         this.FRechargeBtn.Substrate = this.FMC_Scene["MC_RechagerBtn"];
         this.FRechargeBtn.OnClick = this.RechargeOnClick;
         this.FWaterBtn = new TUIButton();
         this.FWaterBtn.Substrate = this.FMC_Scene["MC_WaterBtn"];
         this.FWaterBtn.OnClick = this.WaterOnClick;
         this.FWaterBtn.OnOut = this.OutHandler;
         this.FWaterBtn.OnMove = this.OverHandler;
         this.FResidueWaterTimesTF = this.FMC_Scene["MC_ResidueTF"];
         this.FWaterTimesTF = this.FMC_Scene["MC_WaterTF"];
         this.FTreeLevelTF = this.FMC_Scene["MC_TreeLevelTF"];
         this.FTreesMc = this.FMC_Scene["MC_Trees"];
         this.FGetAwardBtn = new TUIButton();
         this.FGetAwardBtn.Substrate = this.FMC_Scene["MC_GetAward"];
         this.FGetAwardBtn.OnClick = this.GetAwardOnClick;
         this.FMC_PercentTF = this.FMC_Scene["MC_PercentTF"];
         this.FMC_ScrollBar = this.FMC_Scene["MC_ScrollBar"]["MC_EXPBar"];
         this.FMC_Anima = this.FMC_Scene["MC_Anima"];
         this.InitPropItemsResource();
         this.InitWaterAwardResource();
         this.InitGiftResource();
      }
      
      protected function UpdateUIConfig() : void
      {
      }
      
      protected function UpdatePropSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FPropSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FPropSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function UpdateAwardShowSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FAwardSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function InitPropItemsResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Sprite = null;
         _loc2_ = this.Props_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_Scene["Item" + _loc1_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc4_["Slot"];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FPropSlots.push(_loc3_);
            this.FPropPosTF.push(_loc4_["MC_TreePosTF"]);
            _loc1_++;
         }
      }
      
      protected function InitWaterAwardResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUISlot = null;
         _loc2_ = this.Award_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Award"]["Award" + _loc1_];
            _loc4_ = _loc3_["SelectBox"] as MovieClip;
            _loc4_.visible = false;
            (_loc4_ as MovieClip).gotoAndStop(2);
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc3_["Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FAwardSlots.push(_loc5_);
            this.FAwardSps.push(_loc3_);
            this.FAnimaBgList.push(_loc4_);
            _loc1_++;
         }
         this.FEffect = new TPlayAnimaEffect();
         this.FEffect.SelectVec = this.FAnimaBgList;
         this.FEffect.FMix_ax = 2;
         this.FEffect.Fax = 40;
         this.FEffect.FMax_ax = 10;
         this.FEffect.FRotationTurns = 1;
      }
      
      protected function InitGiftResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Sprite = null;
         _loc2_ = this.Gift_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FMC_Scene["MC_Gift_" + _loc1_];
            _loc3_.OnMove = this.GiftBagOnMove;
            _loc3_.OnOut = this.GiftBagOnOut;
            this.FGiftsList.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function RenderShowPorpList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FActivityHalloweenTreeData.ShowInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityHalloweenTreeData.ShowInventories[_loc1_];
            this.FPropSlots[_loc1_].Context = null;
            this.FPropSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      protected function RenderShowWaterAwardList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FActivityHalloweenTreeData.WaterAwardInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityHalloweenTreeData.WaterAwardInventories[_loc1_];
            this.FAwardSlots[_loc1_].Context = null;
            this.FAwardSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      protected function RenderGiftFinishState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Boolean = false;
         _loc2_ = int(this.FActivityHalloweenTreeData.DataList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FGiftsList[_loc1_];
            if(this.FActivityHalloweenTreeData.DataList[_loc1_].CurrentGiftState == CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskFinish || this.FActivityHalloweenTreeData.DataList[_loc1_].CurrentGiftState == CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskAlreadyFinish)
            {
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
            _loc3_.Enabled = _loc4_;
            _loc1_++;
         }
      }
      
      protected function UpdateBaseView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         this.FResidueWaterTimesTF.text = this.FActivityHalloweenTreeData.ResidueWaterTimes.toString();
         this.FWaterTimesTF.text = this.FActivityHalloweenTreeData.WaterTimes.toString();
         this.FTreeLevelTF.text = (this.FActivityHalloweenTreeData.TreesLevel + 1).toString();
         _loc5_ = TUtilityString.Format(this.FActivityHalloweenTreeData.GetFreePromptStr,this.FActivityHalloweenTreeData.RechargeGold);
         this.FRechargeTF.text = _loc5_;
         this.FMC_PercentTF.text = this.FActivityHalloweenTreeData.CurrentExp + "/" + this.FActivityHalloweenTreeData.LevelExpList[this.FActivityHalloweenTreeData.TreesLevel];
         _loc2_ = int(this.FPropPosTF.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPropPosTF[_loc1_];
            _loc5_ = this.FActivityHalloweenTreeData.GetPromptStr;
            _loc5_ = TUtilityString.Format(_loc5_,this.FActivityHalloweenTreeData.TreePosList[_loc1_]);
            _loc3_.text = _loc5_;
            _loc1_++;
         }
         this.FTreesMc.gotoAndStop(this.FActivityHalloweenTreeData.TreesLevel + 1);
         _loc4_ = this.FActivityHalloweenTreeData.CurrentExp / this.FActivityHalloweenTreeData.LevelExpList[this.FActivityHalloweenTreeData.TreesLevel];
         this.FMC_ScrollBar.scaleX = _loc4_;
      }
      
      protected function SetGetAwardBtnState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = int(this.FActivityHalloweenTreeData.DataList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FActivityHalloweenTreeData.DataList[_loc1_].CurrentGiftState == CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskFinish)
            {
               _loc3_ = true;
               break;
            }
            _loc3_ = false;
            _loc1_++;
         }
         this.FGetAwardBtn.Enabled = _loc3_;
         if(this.FActivityHalloweenTreeData.CurrentExp >= this.FActivityHalloweenTreeData.LevelExpList[this.FActivityHalloweenTreeData.TreesLevel])
         {
            this.FWaterBtn.Enabled = false;
         }
         else
         {
            this.FWaterBtn.Enabled = true;
         }
      }
      
      protected function UpdateUI() : void
      {
         this.RenderShowPorpList();
         this.RenderShowWaterAwardList();
         this.RenderGiftFinishState();
         this.UpdateBaseView();
         this.SetGetAwardBtnState();
         this.StopAnima();
      }
      
      private function StopAnima() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FActivityHalloweenTreeData.CurrrntGetAwardIndex;
         if(this.FEffect.CurrentState != 0)
         {
            this.FEffect.FindRewardPos(_loc1_);
         }
      }
      
      protected function StartAnimation(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(SUtilityOverLayer.UIWindowConfirmation.Tag);
         if(this.FWateringFun != null)
         {
            if(this.FEffect.CurrentState == 0)
            {
               this.FWateringFun(_loc2_);
               this.FEffect.startPlay();
            }
         }
      }
      
      protected function RechargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function WaterOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = this.FActivityHalloweenTreeData.WaterTimes + this.FActivityHalloweenTreeData.ResidueWaterTimes;
         if(SLogicsCore.Character.CreditGold < this.FActivityHalloweenTreeData.waterSpendCost && _loc4_ <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FActivityHalloweenTreeData.WaterTimes > 0 || this.FActivityHalloweenTreeData.ResidueWaterTimes > 0)
         {
            SUtilityOverLayer.UIWindowConfirmation.Tag = this.FActivityHalloweenTreeData.WateIndex;
            this.StartAnimation(this);
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityHalloweenTreeData.waterSpendCost);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.StartAnimation;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FActivityHalloweenTreeData.WateIndex;
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityHalloweenTreeData.GetAwardIndex;
         if(this.FGetAwardFun != null)
         {
            this.GetAwardFun(_loc3_);
         }
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftsList.indexOf(param1 as TUIButton);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityHalloweenTreeData.DataList[_loc3_].Inventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      protected function OverHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FActivityHalloweenTreeData.waterSpendCost;
         _loc4_ = this.FActivityHalloweenTreeData.WatrePromptStr;
         _loc4_ = TUtilityString.Format(_loc4_,_loc3_);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OutHandler(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set ActivityHalloweenTreeData(param1:TActivityHalloweenTreeData) : void
      {
         this.FActivityHalloweenTreeData = param1;
      }
      
      public function get WateringFun() : Function
      {
         return this.FWateringFun;
      }
      
      public function set WateringFun(param1:Function) : void
      {
         this.FWateringFun = param1;
      }
      
      public function get GetAwardFun() : Function
      {
         return this.FGetAwardFun;
      }
      
      public function set GetAwardFun(param1:Function) : void
      {
         this.FGetAwardFun = param1;
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
      
      public function ShowView() : void
      {
         this.UpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdatePropSlots();
            this.UpdateAwardShowSlots();
            this.FMC_Anima.play();
            this.FEffect.update();
         }
      }
   }
}

