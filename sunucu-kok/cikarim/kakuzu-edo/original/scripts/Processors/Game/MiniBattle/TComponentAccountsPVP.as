package Processors.Game.MiniBattle
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TComponentAccountsPVP extends TProcessorLobbyWindow
   {
      
      protected static const RewardMaxSize:int = 3;
      
      protected static const RewardScreenX:int = (1250 - 622) / 2;
      
      protected static const RewardScreenY:Vector.<int> = Vector.<int>([200,150,100]);
      
      protected var FWinView:MovieClip;
      
      protected var FWinSlotBoard:Sprite;
      
      protected var FWinRewardSlot:TUISlot;
      
      protected var FWinRewardNum:TextField;
      
      protected var FWinHonor:TextField;
      
      protected var FWinBtnContinue:TUIButton;
      
      protected var FLoseView:MovieClip;
      
      protected var FLoseSlotBoard:Sprite;
      
      protected var FLoseRewardSlot:TUISlot;
      
      protected var FLoseRewardNum:TextField;
      
      protected var FLoseHonor:TextField;
      
      protected var FLoseBtnContinue:TUIButton;
      
      protected var FMiniBattleInfor:TMiniBattleInfor;
      
      protected var FOnBtnBackClick:Function;
      
      public function TComponentAccountsPVP(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function LoadResource_Perform() : void
      {
         this.LoadWinResource();
         this.LoadLoseResource();
      }
      
      protected function LoadWinResource() : void
      {
         this.FWinView = TUtilityReflection.CreateDisplayObjectInstance("PVPWin") as MovieClip;
         this.addChild(this.FWinView);
         this.FWinView.x = (CONST_COMMON.STAGE_Width - this.FWinView.width) / 2;
         this.FWinView.y = (CONST_COMMON.STAGE_Height - this.FWinView.height) / 2;
         this.FWinRewardSlot = new TUISlot(this);
         this.FWinSlotBoard = this.FWinView["Slot"];
         this.FWinRewardSlot.Resource = this.FWinView["Slot"]["mc_slot"];
         TJadeCommon.InitSlot(this.FWinRewardSlot);
         this.FWinRewardSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWinRewardSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWinRewardSlot.Init();
         this.FWinRewardNum = this.FWinView["Slot"]["KillNum"];
         this.FWinHonor = this.FWinView["mc_info"]["mc_exp"]["tf_value"];
         this.FWinBtnContinue = new TUIButton();
         this.FWinBtnContinue.Substrate = this.FWinView["btn_get"];
         this.FWinBtnContinue.OnClick = this.BtnBackOnMouseClick;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(Visible)
         {
            this.FWinRewardSlot.Update();
            this.FLoseRewardSlot.Update();
         }
      }
      
      protected function LoadLoseResource() : void
      {
         this.FLoseView = TUtilityReflection.CreateDisplayObjectInstance("PVPLose") as MovieClip;
         addChild(this.FLoseView);
         this.FLoseView.x = (CONST_COMMON.STAGE_Width - this.FLoseView.width) / 2;
         this.FLoseView.y = (CONST_COMMON.STAGE_Height - this.FLoseView.height) / 2;
         this.FLoseRewardSlot = new TUISlot(this);
         this.FLoseSlotBoard = this.FLoseView["Slot"];
         this.FLoseRewardSlot.Resource = this.FLoseView["Slot"]["mc_slot"];
         TJadeCommon.InitSlot(this.FLoseRewardSlot);
         this.FLoseRewardSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FLoseRewardSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FLoseRewardSlot.Init();
         this.FLoseRewardNum = this.FLoseView["Slot"]["KillNum"];
         this.FLoseHonor = this.FLoseView["mc_info"]["mc_exp"]["tf_value"];
         this.FLoseBtnContinue = new TUIButton();
         this.FLoseBtnContinue.Substrate = this.FLoseView["btn_get"];
         this.FLoseBtnContinue.OnClick = this.BtnBackOnMouseClick;
      }
      
      protected function FindMySelfSoliderReward() : TSoliderReward
      {
         var _loc1_:TSoliderReward = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FMiniBattleInfor.SoliderRewards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FMiniBattleInfor.SoliderRewards[_loc2_];
            if(_loc1_.SoliderName == SLogicsCore.Character.NickName)
            {
               return _loc1_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function RenderingWinView() : void
      {
         var _loc1_:TSoliderReward = null;
         var _loc2_:TInventory = null;
         _loc1_ = this.FindMySelfSoliderReward();
         if(_loc1_ == null)
         {
            this.FWinRewardSlot.Context = null;
            this.FWinRewardNum.text = "x0";
            this.FWinHonor.text = "0";
            this.FWinView.gotoAndStop(1);
            this.FWinView.play();
            this.FWinSlotBoard.visible = false;
            return;
         }
         this.FWinSlotBoard.visible = true;
         _loc2_ = _loc1_.AddedReward.GetInventoryByIndex(0);
         this.FWinRewardSlot.Context = _loc2_;
         this.FWinRewardNum.text = "x" + _loc2_.Quantity.toString();
         this.FWinHonor.text = _loc1_.RewardHonor.toString();
         this.FWinView.gotoAndStop(1);
         this.FWinView.play();
      }
      
      protected function RenderingLoseView() : void
      {
         var _loc1_:TSoliderReward = null;
         var _loc2_:TInventory = null;
         _loc1_ = this.FindMySelfSoliderReward();
         if(_loc1_ == null)
         {
            this.FLoseRewardSlot.Context = null;
            this.FLoseRewardNum.text = "x0";
            this.FLoseHonor.text = "0";
            this.FLoseSlotBoard.visible = false;
            this.FLoseView.gotoAndStop(1);
            this.FLoseView.play();
            return;
         }
         this.FLoseSlotBoard.visible = true;
         _loc2_ = _loc1_.AddedReward.GetInventoryByIndex(0);
         this.FLoseRewardSlot.Context = _loc2_;
         this.FLoseRewardNum.text = "x" + _loc2_.Quantity.toString();
         this.FLoseHonor.text = _loc1_.RewardHonor.toString();
         this.FLoseView.gotoAndStop(1);
         this.FLoseView.play();
      }
      
      protected function RenderingByData() : void
      {
         this.FWinView.visible = this.FMiniBattleInfor.BattleResult == CONST_MINIBATTLE.BattleResult_Win;
         this.FLoseView.visible = this.FMiniBattleInfor.BattleResult != CONST_MINIBATTLE.BattleResult_Win;
         if(this.FMiniBattleInfor.BattleResult == CONST_MINIBATTLE.BattleResult_Win)
         {
            this.RenderingWinView();
         }
         else
         {
            this.RenderingLoseView();
         }
      }
      
      protected function BtnBackOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnBackClick != null)
         {
            this.FOnBtnBackClick(this);
         }
      }
      
      public function set OnBtnBackClick(param1:Function) : void
      {
         this.FOnBtnBackClick = param1;
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function Reset() : void
      {
      }
      
      public function ShowRewardAccount(param1:TMiniBattleInfor) : void
      {
         this.FMiniBattleInfor = param1;
         this.RenderingByData();
      }
   }
}

