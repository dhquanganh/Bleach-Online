package Processors.Game.Lobby.Activity.HDGrowthPlan
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDGrowthPlan.TActivityGrowthPlanData;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowGrowthPlan extends TProcessorHDSingleWindowBase
   {
      
      private var FCurRechargeTxt:TextField;
      
      private var FRechargeConditonTxt:TextField;
      
      private var FRechargeBtn:TUIButton;
      
      private var FSpendGoldTxt:TextField;
      
      private var FBuyBtn:TUIButton;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FItemsSpVec:Vector.<Sprite>;
      
      protected var FButtonVec:Vector.<TUIButton>;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      protected var FActivityData:TActivityGrowthPlanData;
      
      public function TProcessorHDWindowGrowthPlan(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_GrowthPlan";
         FActivityID = CONST_ACTIVITY_MODE.Activity_GrowthPlan;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatch();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function UIDispatch() : void
      {
         this.FCurRechargeTxt = FScene["TF_CurRecharge"];
         this.FRechargeConditonTxt = FScene["TF_RechargeCondition"];
         this.FRechargeBtn = new TUIButton();
         this.FRechargeBtn.Substrate = FScene["Btn_Recharge"];
         this.FRechargeBtn.OnClick = this.OnRightNowRecharge;
         this.FSpendGoldTxt = FScene["TF_Gold"];
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = FScene["Btn_Buy"];
         this.FBuyBtn.OnClick = this.OnBuyPlan;
         this.FScrollBar = new TScrollBar(FScene["MC_List"],340,false,3,60);
         this.FScrollBar.Visible = false;
         this.FItemsSpVec = new Vector.<Sprite>();
         this.FButtonVec = new Vector.<TUIButton>();
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function RenderList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIButton = null;
         _loc2_ = int(this.FActivityData.GrowPlanVec.length);
         this.CreateRenderItem(_loc2_);
         this.FScrollBar.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FItemsSpVec[_loc1_];
            _loc3_["TF_Level"].text = this.FActivityData.GrowPlanVec[_loc1_].Level.toString();
            _loc3_["TF_Gold"].text = this.FActivityData.GrowPlanVec[_loc1_].Gold.toString();
            this.FScrollBar.AddItem(_loc3_);
            _loc4_ = this.FButtonVec[_loc1_];
            _loc4_.Enabled = this.FActivityData.GrowPlanVec[_loc1_].GetAwardState == CONST_GROWTHPLAN.Activity_ScanOperate;
            _loc1_++;
         }
         this.FScrollBar.ScrollToUp();
         this.FScrollBar.Visible = true;
      }
      
      private function CreateRenderItem(param1:int) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIButton = null;
         _loc4_ = param1 - this.FItemsSpVec.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("LevelGrowPlanItem") as Sprite;
            _loc2_.name = "Item_" + _loc3_;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc2_["Btn_GetAward"];
            _loc5_.OnClick = this.OnGetGrowAward;
            this.FButtonVec.push(_loc5_);
            this.FItemsSpVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnRightNowRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function OnBuyPlan(param1:Object, param2:MouseEvent) : void
      {
         this.WindowUIPopUp.visible = true;
         this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityData.ActivityConfig.SpendGoldValue);
         this.WindowUIPopUp.OnOK = this.WindowLowOk;
         this.WindowUIPopUp.Tag = this.FActivityData.ActivityConfig.BuyIndex;
      }
      
      private function WindowLowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc2_);
      }
      
      private function OnGetGrowAward(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         _loc4_ = param1 as TUIButton;
         _loc3_ = this.FButtonVec.indexOf(_loc4_);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      public function set ActivityData(param1:TActivityGrowthPlanData) : void
      {
         this.FActivityData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RefreshBaseInfo();
      }
      
      public function RefreshBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FCurRechargeTxt.text = this.FActivityData.RechargeGoldValue.toString();
         this.FRechargeConditonTxt.text = this.FActivityData.ActivityConfig.Condition.toString();
         this.FSpendGoldTxt.text = this.FActivityData.ActivityConfig.SpendGoldValue.toString();
         this.FBuyBtn.Enabled = this.FActivityData.BuyGrowthPlanState == CONST_GROWTHPLAN.Activity_ScanOperate;
         this.RenderList();
      }
   }
}

