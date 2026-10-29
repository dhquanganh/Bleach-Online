package Processors.Game.Lobby.KingChallenge
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.KingChallenge.TBettingInfo;
   import Logics.KingChallenge.TKingChallenge;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TUIMyGamble extends TUIComponent
   {
      
      protected static const ITEM_MAX:uint = 6;
      
      protected var FMainScene:Sprite;
      
      protected var Btn_Close:TUIButton;
      
      protected var FBtns_Get:Vector.<TUIButton>;
      
      protected var FBtn_AllGet:TUIButton;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FData:Vector.<TBettingInfo>;
      
      public function TUIMyGamble(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FBtn_AllGet.Enabled = TKingChallenge.ArchivedBetRewards>0 && !TKingChallenge.RequestPending;
         _loc2_ = this.FData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData[_loc1_].RewardStatus == 0 && (this.FData[_loc1_].WinnerLowId!=0 || this.FData[_loc1_].WinnerHighId!=0) && this.FData[_loc1_].WinnerLowId==this.FData[_loc1_].ChooseLowId && this.FData[_loc1_].WinnerHighId==this.FData[_loc1_].ChooseHighId)
            {
               this.FBtn_AllGet.Enabled = true;
            }
            _loc1_++;
         }
         this.UpdateCurrentPage();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      protected function UpdateCurrentPage() : void
      {
         var _loc1_:* = 0;
         var _loc2_:uint = 0;
         this.FPageUI.PageSize = ITEM_MAX;
         this.FPageUI.TotalQuantity = this.FData.length;
         this.FPageUI.Update();
         _loc2_ = ITEM_MAX;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(ITEM_MAX * this.FCurrentPage + _loc1_ < this.FPageUI.TotalQuantity)
            {
               this.FMainScene["Item_" + _loc1_].visible = true;
               this.FMainScene["Item_" + _loc1_]["TF_RecordTitle_0"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText08),this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].AttUserName,this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].DefUserName,TUtilityLobby.GetConfigValue(61900008));
               if(this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].ChooseHighId == this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].WinnerHighId && this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].ChooseLowId == this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].WinnerLowId)
               {
                  this.FBtns_Get[_loc1_].Enabled = true;
                  this.FBtns_Get[_loc1_].Visible = true;
               }
               else
               {
                  this.FBtns_Get[_loc1_].Enabled = false;
                  this.FBtns_Get[_loc1_].Visible = false;
               }
               this.FBtns_Get[_loc1_].Visible = this.FBtns_Get[_loc1_].Enabled && this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].RewardStatus == 0;
               this.FBtns_Get[_loc1_].Enabled = this.FBtns_Get[_loc1_].Visible && !TKingChallenge.RequestPending;
            }
            else
            {
               this.FMainScene["Item_" + _loc1_].visible = false;
            }
            _loc1_--;
         }
      }
      
      protected function ProcessorGetOnce(param1:Object, param2:Event) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingAwardReq);
         _loc3_.Data.writeInt(1);
         _loc3_.Data.writeInt(this.FData[ITEM_MAX * this.FCurrentPage + param1.Tag].FighterNum);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorGetAll(param1:Object, param2:Event) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingAwardReq);
         _loc3_.Data.writeInt(0);
         _loc3_.Data.writeInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FMainScene = param1;
         addChild(this.FMainScene);
         this.Btn_Close = new TUIButton();
         this.Btn_Close.Substrate = this.FMainScene["Btn_Close"];
         this.Btn_Close.OnClick = this.ProcessorHide;
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = this.FMainScene["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = this.FMainScene["MC_PageLeft"];
         this.FPageUI.PageSize = ITEM_MAX;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
         _loc3_ = ITEM_MAX;
         this.FBtns_Get = new Vector.<TUIButton>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtns_Get[_loc2_] = new TUIButton();
            this.FBtns_Get[_loc2_].Substrate = this.FMainScene["Item_" + _loc2_]["Btn_Get"];
            this.FBtns_Get[_loc2_].OnClick = this.ProcessorGetOnce;
            this.FBtns_Get[_loc2_].Tag = _loc2_;
            _loc2_++;
         }
         this.FBtn_AllGet = new TUIButton();
         this.FBtn_AllGet.Substrate = this.FMainScene["Btn_AllGet"];
         this.FBtn_AllGet.OnClick = this.ProcessorGetAll;
      }
      
      protected function ProcessorHide(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      public function set Data(param1:Vector.<TBettingInfo>) : void
      {
         this.FData = param1;
         this.FCurrentPage = Math.max(0,Math.min(this.FCurrentPage,Math.ceil(this.FData.length / ITEM_MAX) - 1));
         this.UpdateUI();
      }
   }
}

