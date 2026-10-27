package Processors.Game.Lobby.Activity.HDNewYearDay.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear.TActivityNewYearFlyData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearDay.components.TNewYearFlyItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorNewYearFlyView extends TProcessorHDSingleWindowBase
   {
      
      protected static const Shop_Gift_Num:int = 8;
      
      protected static const Good_Gift_Num:int = 4;
      
      protected static const Charm_Gift_Num:int = 4;
      
      protected var FTFFriendName:TextField;
      
      protected var FTFGoodCount:TextField;
      
      protected var FTFCharmCount:TextField;
      
      protected var FTFNoticeLabel:TextField;
      
      protected var FTFInviteLabel:TextField;
      
      protected var FBtnInvite:TUIButton;
      
      protected var FBtnNotice:TUIButton;
      
      protected var FGiftIcons:Vector.<TUIButton>;
      
      protected var FGiftCostTexts:Vector.<TextField>;
      
      protected var FGiftBuyBtns:Vector.<TUIButton>;
      
      protected var FGoodGifts:Vector.<TNewYearFlyItem>;
      
      protected var FCharmGifts:Vector.<TNewYearFlyItem>;
      
      protected var FActivityData:TActivityNewYearFlyData;
      
      protected var FConfigData:THDNewYearFly;
      
      protected var FIsNotice:Boolean;
      
      protected var FInviteView:TNewYearInviteView;
      
      protected var FActCurIndex:int;
      
      protected var FMask:Sprite;
      
      public function TProcessorNewYearFlyView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         super.UpdateUI();
         this.FTFGoodCount.text = this.FActivityData.GoodCount + "";
         this.FTFCharmCount.text = this.FActivityData.CharmCount + "";
         if(this.FActivityData.Friend != null)
         {
            this.FTFFriendName.text = this.FActivityData.Friend.Name;
            this.FTFInviteLabel.text = this.FConfigData.StringMsgVec[THDNewYearFly.STRING_MSG_3];
         }
         else
         {
            this.FTFFriendName.text = "";
            this.FTFInviteLabel.text = this.FConfigData.StringMsgVec[THDNewYearFly.STRING_MSG_2];
         }
         _loc1_ = 0;
         while(_loc1_ < Good_Gift_Num)
         {
            this.FGoodGifts[_loc1_].Count = this.FConfigData.GoodCardNumVec[_loc1_];
            this.FGoodGifts[_loc1_].SetStatus(this.FActivityData.GoodStatusVec[_loc1_],this.FActivityData.GoodCount);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Charm_Gift_Num)
         {
            this.FCharmGifts[_loc1_].Count = this.FConfigData.CharmCardNumVec[_loc1_];
            this.FCharmGifts[_loc1_].SetStatus(this.FActivityData.CharmStatusVec[_loc1_],this.FActivityData.CharmCount);
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as TActivityNewYearFlyData;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         super.UpdateUIConfig();
         this.FConfigData = FHDActivityConfig as THDNewYearFly;
         _loc1_ = 0;
         while(_loc1_ < Good_Gift_Num)
         {
            this.FGoodGifts[_loc1_].Data = this.FConfigData.GoodInventories[_loc1_];
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Charm_Gift_Num)
         {
            this.FCharmGifts[_loc1_].Data = this.FConfigData.CharmInventories[_loc1_];
            _loc1_++;
         }
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      protected function UpdateShopUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FIsNotice ? int(this.FActivityData.CurDay + 1) : this.FActivityData.CurDay;
         this.FTFNoticeLabel.text = this.FIsNotice ? this.FConfigData.StringMsgVec[THDNewYearFly.STRING_MSG_1] : this.FConfigData.StringMsgVec[THDNewYearFly.STRING_MSG_0];
         this.FMask.visible = this.FIsNotice;
         _loc1_ = 0;
         while(_loc1_ < Shop_Gift_Num)
         {
            this.FGiftBuyBtns[_loc1_].Visible = !this.FIsNotice;
            this.FGiftCostTexts[_loc1_].text = this.FConfigData.GetActGoldsByPos(_loc1_)[_loc2_] + "";
            _loc1_++;
         }
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function BtnInviteOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FInviteView.Show();
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this.FActivityData.Friend == null)
         {
            this.FInviteView.Show();
            return;
         }
         _loc3_ = this.FGiftBuyBtns.indexOf(param1 as TUIButton);
         _loc4_ = this.FConfigData.GetActGoldsByPos(_loc3_)[this.FActivityData.CurDay];
         if(_loc4_ > SLogicsCore.Character.CreditGold)
         {
            FUIWindowRecharge.Visible = true;
            return;
         }
         _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02),_loc4_);
         FUIWindowConfirmation.Text = _loc5_;
         FUIWindowConfirmation.Visible = true;
         FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FActCurIndex = _loc3_;
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         this.SendServerData(this.FConfigData.ActIndexVec[this.FActCurIndex]);
      }
      
      protected function BtnNoticeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FIsNotice = !this.FIsNotice;
         this.UpdateShopUI();
      }
      
      protected function GoodGiftOnClick(param1:int, param2:MouseEvent) : void
      {
         this.SendServerData(this.FConfigData.GoodCardIndexVec[param1]);
      }
      
      protected function CharmGiftOnClick(param1:int, param2:MouseEvent) : void
      {
         this.SendServerData(this.FConfigData.CharmCardIndexVec[param1]);
      }
      
      protected function GiftBoxOnOver(param1:TInventories) : void
      {
         ProcessorOnGiftBoxMove(FParent,param1);
      }
      
      protected function GiftBoxOnOut() : void
      {
         ProcessorOnGiftBoxOut(FParent);
      }
      
      protected function GiftOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         _loc3_ = this.FGiftIcons.indexOf(param1 as TUIButton);
         _loc4_ = this.FIsNotice ? this.FActivityData.NextActInventories[_loc3_] : this.FActivityData.ActInventories[_loc3_];
         ProcessorOnGiftBoxMove(FParent,_loc4_);
      }
      
      protected function GiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(FParent);
      }
      
      protected function FriendInviteOnSend(param1:int, param2:int) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = Vector.<int>([param1,param2]);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfigData.FriendIndex,0,_loc3_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TextField = null;
         var _loc7_:TUIButton = null;
         var _loc8_:TNewYearFlyItem = null;
         super.InitWindow(param1);
         _loc3_ = FScene["MC_Invite"];
         this.FTFFriendName = _loc3_["TF_Friend"];
         this.FTFInviteLabel = _loc3_["Btn_Invite"]["TF_Label"];
         this.FBtnInvite = new TUIButton();
         this.FBtnInvite.Substrate = _loc3_["Btn_Invite"];
         this.FBtnInvite.OnClick = this.BtnInviteOnClick;
         this.FTFNoticeLabel = FScene["Btn_Daily"]["TF_Label"];
         this.FBtnNotice = new TUIButton();
         this.FBtnNotice.Substrate = FScene["Btn_Daily"];
         this.FBtnNotice.OnClick = this.BtnNoticeOnClick;
         this.FGiftIcons = new Vector.<TUIButton>();
         this.FGiftCostTexts = new Vector.<TextField>();
         this.FGiftBuyBtns = new Vector.<TUIButton>();
         _loc2_ = 0;
         while(_loc2_ < Shop_Gift_Num)
         {
            _loc5_ = new TUIButton();
            _loc5_.Substrate = FScene["MC_Gift_" + _loc2_];
            _loc5_.OnMove = this.GiftOnOver;
            _loc5_.OnOut = this.GiftOnOut;
            this.FGiftIcons.push(_loc5_);
            _loc6_ = FScene["MC_Item_" + _loc2_]["TF_Cost"];
            this.FGiftCostTexts.push(_loc6_);
            _loc7_ = new TUIButton();
            _loc7_.Substrate = FScene["MC_Item_" + _loc2_]["Btn_Buy"];
            _loc7_.OnClick = this.BtnBuyOnClick;
            this.FGiftBuyBtns.push(_loc7_);
            _loc2_++;
         }
         _loc4_ = FScene["MC_Rewards"];
         this.FTFGoodCount = _loc4_["TF_Good"];
         this.FTFCharmCount = _loc4_["TF_Charm"];
         this.FGoodGifts = new Vector.<TNewYearFlyItem>();
         this.FCharmGifts = new Vector.<TNewYearFlyItem>();
         _loc2_ = 0;
         while(_loc2_ < Good_Gift_Num)
         {
            _loc8_ = new TNewYearFlyItem(_loc4_["MC_Good_" + _loc2_]);
            _loc8_.OnClick = this.GoodGiftOnClick;
            _loc8_.ItemIndex = _loc2_;
            _loc8_.GiftMoveFun = this.GiftBoxOnOver;
            _loc8_.GiftOutFun = this.GiftBoxOnOut;
            this.FGoodGifts.push(_loc8_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < Charm_Gift_Num)
         {
            _loc8_ = new TNewYearFlyItem(_loc4_["MC_Charm_" + _loc2_]);
            _loc8_.OnClick = this.CharmGiftOnClick;
            _loc8_.ItemIndex = _loc2_;
            _loc8_.GiftMoveFun = this.GiftBoxOnOver;
            _loc8_.GiftOutFun = this.GiftBoxOnOut;
            this.FCharmGifts.push(_loc8_);
            _loc2_++;
         }
         this.FInviteView = new TNewYearInviteView(FParent);
         this.FInviteView.InviteOnSend = this.FriendInviteOnSend;
         this.FInviteView.UIDispatch();
         this.FInviteView.Visible = false;
         this.FMask = FScene["MC_Mask"];
         this.FMask.mouseChildren = false;
         this.FMask.mouseEnabled = false;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.FIsNotice = false;
         this.FBtnNotice.Enabled = this.FActivityData.CurDay < this.FConfigData.ActAwardCount;
         this.UpdateShopUI();
         this.UpdateUI();
      }
   }
}

