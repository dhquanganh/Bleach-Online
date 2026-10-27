package Processors.Game.Lobby.Activity.HDActivityChristmas.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.THDChristmasGift;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.TActivityChristmasGiftData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.components.TRewardItem;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.components.TTreasureItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorChristmasGiftView extends TUIComponent
   {
      
      protected static const Treasure_Count:int = 3;
      
      protected static const Reward_Count:int = 5;
      
      protected static const Status_CanGet:int = 1;
      
      protected static const Status_NotGet:int = 0;
      
      protected static const Status_Get:int = -1;
      
      protected var FMainUI:Sprite;
      
      protected var FBlock0:Sprite;
      
      protected var FBlock1:Sprite;
      
      protected var FTreasureItems:Vector.<TTreasureItem>;
      
      protected var FRewardItems:Vector.<TRewardItem>;
      
      protected var FGiftRechargeReward:TUIButton;
      
      protected var FGiftDayAward:TUIButton;
      
      protected var FBtnRechargeReward:TUIButton;
      
      protected var FIconRechargeReward:Sprite;
      
      protected var FTFRechargeReward:TextField;
      
      protected var FTFCount:TextField;
      
      protected var FBtnDayAward:TUIButton;
      
      protected var FIconDayAward:Sprite;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FCurTreasureIndex:int;
      
      protected var FCurRewardIndex:int;
      
      protected var FCurTreasureCost:int;
      
      protected var FData:THDChristmasGift;
      
      protected var FActivityData:TActivityChristmasGiftData;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FSendData:Function;
      
      public function TProcessorChristmasGiftView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TTreasureItem = null;
         var _loc3_:TRewardItem = null;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FBlock0 = this.FMainUI["MC_block0"];
         this.FBlock1 = this.FMainUI["MC_block1"];
         this.FTFRechargeReward = this.FBlock0["TF_Money"];
         this.FIconRechargeReward = this.FBlock0["MC_Get"];
         this.FBtnRechargeReward = new TUIButton();
         this.FBtnRechargeReward.Substrate = this.FBlock0["Btn_ExchargeOne"];
         this.FBtnRechargeReward.OnClick = this.BtnRechargeOnClick;
         this.FGiftRechargeReward = new TUIButton();
         this.FGiftRechargeReward.Substrate = this.FBlock0["Btn_Gift"];
         this.FGiftRechargeReward.OnMove = this.GiftBagOnMove;
         this.FGiftRechargeReward.OnOut = this.GiftBagOnOut;
         this.FIconDayAward = this.FBlock1["MC_Get"];
         this.FBtnDayAward = new TUIButton();
         this.FBtnDayAward.Substrate = this.FBlock1["Btn_ExchargeOne"];
         this.FBtnDayAward.OnClick = this.BtnDayOnClick;
         this.FGiftDayAward = new TUIButton();
         this.FGiftDayAward.Substrate = this.FBlock1["Btn_Gift"];
         this.FGiftDayAward.OnMove = this.GiftBagOnMove;
         this.FGiftDayAward.OnOut = this.GiftBagOnOut;
         this.FTFCount = this.FMainUI["MC_awards"]["TF_Count"];
         this.FTreasureItems = new Vector.<TTreasureItem>();
         this.FRewardItems = new Vector.<TRewardItem>();
         _loc1_ = 0;
         while(_loc1_ < Treasure_Count)
         {
            _loc2_ = new TTreasureItem(this.FMainUI["MC_Treasure" + _loc1_]);
            _loc2_.ItemIndex = _loc1_;
            _loc2_.GiftMoveFun = this.GiftBagOnMove;
            _loc2_.GiftOutFun = this.GiftBagOnOut;
            _loc2_.OnClick = this.TreasureOnClick;
            this.FTreasureItems.push(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Reward_Count)
         {
            _loc3_ = new TRewardItem(this.FMainUI["MC_awards"]["MC_Item" + _loc1_]);
            _loc3_.ItemIndex = _loc1_;
            _loc3_.GiftMoveFun = this.GiftBagOnMove;
            _loc3_.GiftOutFun = this.GiftBagOnOut;
            _loc3_.OnClick = this.RewardOnClick;
            this.FRewardItems.push(_loc3_);
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
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         this.FTFRechargeReward.text = this.FData.RechargeAwardGold + "";
         this.SetIconStatus(this.FIconRechargeReward,this.FBtnRechargeReward,this.FActivityData.RechargeAwardStatus);
         this.SetIconStatus(this.FIconDayAward,this.FBtnDayAward,this.FActivityData.DayAwardStatus);
         this.FTFCount.text = this.FActivityData.BuyCount + "";
         _loc1_ = 0;
         while(_loc1_ < Treasure_Count)
         {
            this.FTreasureItems[_loc1_].Status = this.FActivityData.BagBuyStatusVec[_loc1_];
            this.FTreasureItems[_loc1_].Price = this.FData.GetGoldsByType(_loc1_)[this.FActivityData.CurDay];
            this.FTreasureItems[_loc1_].Data = this.FActivityData.BagBuyInventoriesVec[_loc1_];
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Reward_Count)
         {
            this.FRewardItems[_loc1_].Status = this.FActivityData.BagGetStatusVec[_loc1_];
            this.FRewardItems[_loc1_].Count = this.FData.BagGetLimitVec[_loc1_];
            this.FRewardItems[_loc1_].Data = this.FActivityData.BagGetInventoriesVec[_loc1_];
            _loc1_++;
         }
      }
      
      protected function SetIconStatus(param1:Sprite, param2:TUIButton, param3:int) : void
      {
         switch(param3)
         {
            case Status_CanGet:
               param1.visible = false;
               param2.Enabled = true;
               break;
            case Status_NotGet:
               param1.visible = false;
               param2.Enabled = false;
               break;
            case Status_Get:
               param1.visible = true;
               param2.Enabled = false;
         }
      }
      
      public function get Data() : THDChristmasGift
      {
         return this.FData;
      }
      
      public function set Data(param1:THDChristmasGift) : void
      {
         this.FData = param1;
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
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      protected function BtnRechargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FActivityData.RechargeAwardStatus == Status_CanGet)
         {
            this.SendServiceData(this.FData.RechargeAwardIndex);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_56));
      }
      
      protected function BtnDayOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FActivityData.DayAwardStatus == Status_CanGet)
         {
            this.SendServiceData(this.FData.DayAwardIndex);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_56));
      }
      
      protected function OnBuyGift(param1:Object) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FCurTreasureCost)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
            return;
         }
         this.SendServiceData(this.FCurTreasureIndex);
      }
      
      protected function TreasureOnClick(param1:int, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FData.GetGoldsByType(param1)[this.FActivityData.CurDay];
         _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02),_loc3_);
         this.FUIWindowConfirmation.Text = _loc4_;
         this.FUIWindowConfirmation.OnOK = this.OnBuyGift;
         this.FUIWindowConfirmation.Visible = true;
         this.FCurTreasureCost = _loc3_;
         this.FCurTreasureIndex = this.FData.BagBuyIndexVec[param1];
      }
      
      protected function RewardOnClick(param1:int, param2:MouseEvent) : void
      {
         if(this.FActivityData.BagGetStatusVec[param1] == Status_CanGet)
         {
            this.FCurRewardIndex = this.FData.BagGetIndexVec[param1];
            this.SendServiceData(this.FCurRewardIndex);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_10));
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TInventories = null;
         _loc3_ = param1 as TUIButton;
         if(this.FGiftMoveFun != null)
         {
            if(_loc3_ == this.FGiftRechargeReward)
            {
               this.FGiftMoveFun(this.FActivityData.RechargeInventories);
            }
            else if(_loc3_ == this.FGiftDayAward)
            {
               this.FGiftMoveFun(this.FActivityData.DayInventories);
            }
            else
            {
               _loc4_ = param1 as TInventories;
               this.FGiftMoveFun(_loc4_);
            }
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      public function ShowView(param1:TActivityOSBase) : void
      {
         this.FActivityData = param1 as TActivityChristmasGiftData;
         this.UpdateUI();
      }
   }
}

