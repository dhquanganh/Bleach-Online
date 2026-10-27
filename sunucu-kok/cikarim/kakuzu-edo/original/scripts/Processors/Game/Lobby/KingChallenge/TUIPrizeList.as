package Processors.Game.Lobby.KingChallenge
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.KingChallenge.TKingChallenge;
   import Logics.KingChallenge.TUserBaseInfo;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TUIPrizeList extends TUIComponent
   {
      
      protected var FMain:Sprite;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FSP_Already:Sprite;
      
      protected var Btn_Close:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FData:TUserBaseInfo;
      
      public function TUIPrizeList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ProcessorGetPrize(param1:Object, param2:Event) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending || this.FData.AwardStatus != 0)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BoxAwardReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         switch(this.FData.Rank)
         {
            case 0:
               this.FMain["TF_Rank"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText09);
               break;
            case 1:
               this.FMain["TF_Rank"].text = "1";
               break;
            case 2:
               this.FMain["TF_Rank"].text = "2";
               break;
            case 3:
               this.FMain["TF_Rank"].text = "3-4";
               break;
            case 4:
               this.FMain["TF_Rank"].text = "5-8";
         }
         this.FBtn_Get.Enabled = this.FData.AwardStatus == 0;
         this.FBtn_Get.Visible = this.FData.AwardStatus == 0;
         this.FMain["ReciveFlag"].visible = this.FData.AwardStatus == 1;
         var rank:uint = 0;
         while(rank < 4)
         {
            var prizes:TInventories = new TInventories();
            var ids:Object = TUtilityLobby.GetConfigValue(61900009 + this.FData.Group / 1000 - 1);
            SToolReward.GetAwardsByAwardID(ids[rank],prizes);
            var column:uint = 0;
            while(column < 4)
            {
               this.FSlots[rank * 4 + column].Context = column < prizes.Count ? prizes.GetInventoryByIndex(column) : null;
               column++;
            }
            rank++;
         }
      }
      
      protected function ProcessorHide(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(Visible && this.FMain != null)
         {
            _loc1_ = 16;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.FSlots[_loc2_].Update();
               _loc2_++;
            }
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FMain = param1;
         addChild(this.FMain);
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = this.FMain["BuyBtn"];
         this.FBtn_Get.OnClick = this.ProcessorGetPrize;
         this.Btn_Close = new TUIButton();
         this.Btn_Close.Substrate = this.FMain["Btn_Close"];
         this.Btn_Close.OnClick = this.ProcessorHide;
         _loc2_ = 16;
         this.FSlots = new Vector.<TUISlot>();
         _loc2_ = 4;
         _loc4_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.FSlots[_loc3_ * _loc2_ + _loc5_] = new TUISlot(this);
               this.FSlots[_loc3_ * _loc2_ + _loc5_].Resource = this.FMain["Item_" + _loc3_]["slot" + _loc5_];
               this.FSlots[_loc3_ * _loc2_ + _loc5_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
               this.FSlots[_loc3_ * _loc2_ + _loc5_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
               TJadeCommon.InitSlot(this.FSlots[_loc3_ * _loc2_ + _loc5_]);
               this.FSlots[_loc3_ * _loc2_ + _loc5_].Init();
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function set Data(param1:TUserBaseInfo) : void
      {
         this.FData = param1;
         if(this.FData.Group < 1000)
         {
            return;
         }
         this.UpdateUI();
      }
   }
}

