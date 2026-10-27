package Processors.Game.Lobby.HeroCompanion.CardSeat
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Components.Standard.TUIImage;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TCompanionProperty;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.PropertyScroll.TCompanionScrollPropertyRender;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionSeatItem;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorCompanionSeat extends TCompanionBaseView
   {
      
      protected static const PositionTable:Vector.<int> = CONST_HEROCOMPANION.PositionTable;
      
      protected var FTFFever:TextField;
      
      protected var FBar:Sprite;
      
      protected var FBtnHelp:TUIButton;
      
      protected var FPageCard:TCompanionSeatPageCard;
      
      protected var FPageEquip:TCompanionSeatPageEquip;
      
      protected var FUIImage:TUIImage;
      
      protected var FAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FIsDrag:Boolean;
      
      protected var FIsOver:Boolean;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FIsSeated:Boolean;
      
      protected var FCurCardData:TCompanionCard;
      
      protected var FCurSeat:int;
      
      protected var FHelpHint:THint;
      
      public function TProcessorCompanionSeat(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function SetSeatEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeroCompanionCardData = null;
         var _loc4_:Vector.<TCompanionProperty> = null;
         var _loc5_:Vector.<Vector.<TCompanionProperty>> = null;
         var _loc6_:int = 0;
         var _loc7_:TCompanionScrollPropertyRender = null;
         var _loc8_:String = null;
         this.FScrollBar.Clear();
         _loc4_ = new Vector.<TCompanionProperty>();
         _loc2_ = FData.CardDatas.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FData.CardDatas.GetCardByIndex(_loc1_);
            if(_loc3_.Seat > 0)
            {
               _loc4_ = _loc4_.concat(_loc3_.GetCurCard().BaseProperties);
               if(_loc3_.Seat == CONST_HEROCOMPANION.Leader_Seat)
               {
                  _loc4_ = _loc4_.concat(_loc3_.GetCurCard().LeaderProperties);
               }
            }
            _loc1_++;
         }
         _loc5_ = new Vector.<Vector.<TCompanionProperty>>(PositionTable.length);
         _loc2_ = int(_loc4_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = PositionTable.indexOf(_loc4_[_loc1_].Pos);
            if(_loc5_[_loc6_] == null)
            {
               _loc5_[_loc6_] = new Vector.<TCompanionProperty>();
            }
            _loc5_[_loc6_].push(_loc4_[_loc1_]);
            _loc1_++;
         }
         _loc2_ = int(_loc5_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc5_[_loc1_] != null)
            {
               _loc7_ = new TCompanionScrollPropertyRender();
               _loc7_.SetData(_loc5_[_loc1_]);
               this.FScrollBar.AddItem(_loc7_);
            }
            _loc1_++;
         }
      }
      
      protected function SeatedOnEnd(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         FUICore.MouseStopDrag(this.FUIImage);
         this.FIsDrag = false;
         if(this.FIsOver && this.FCurCardData != null)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_SeatedReq);
            _loc3_ = _loc2_.Data;
            _loc3_.writeUnsignedInt(this.FCurCardData.Identifier);
            _loc3_.writeUnsignedInt(this.FCurSeat + this.FPageEquip.CurPage * CONST_HEROCOMPANION.Seat_Equip_Num + 1);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
            this.FIsSeated = true;
         }
      }
      
      protected function OnOver(param1:TCompanionCard) : void
      {
         if(FTipOnOver != null)
         {
            FTipOnOver(param1);
         }
      }
      
      protected function OnOut() : void
      {
         if(FTipOnOut != null)
         {
            FTipOnOut();
         }
      }
      
      protected function CardOnDown(param1:int) : void
      {
         this.FIsDrag = true;
         this.FCurCardData = this.FPageCard.CardVec[param1].Data;
         this.FUIImage.Sequence = this.FPageCard.CardVec[param1].AnimationSequence;
         FUICore.MouseStartDrag(this.FUIImage,true);
      }
      
      protected function EquipOnOver(param1:int) : void
      {
         var _loc2_:TCompanionSeatItem = null;
         _loc2_ = this.FPageEquip.CardVec[param1];
         if(_loc2_.IsLock)
         {
            return;
         }
         if(_loc2_.Data != null)
         {
            return;
         }
         this.FIsOver = true;
         if(this.FIsDrag)
         {
            this.FCurSeat = param1;
         }
      }
      
      protected function EquipOnOut() : void
      {
         this.FIsOver = false;
         FTipOnOut();
      }
      
      protected function HelpOnOver(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHelpHint);
      }
      
      protected function HelpOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHelpHint);
      }
      
      protected function OnDisMount(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_UnseatedReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FIsSeated = true;
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         super.UIDispatch(param1);
         this.FPageCard = new TCompanionSeatPageCard(this,FMainUI["MC_CardPage"]);
         this.FPageCard.OnDown = this.CardOnDown;
         this.FPageCard.OnOut = this.OnOut;
         this.FPageCard.TipOnOver = this.OnOver;
         this.FPageEquip = new TCompanionSeatPageEquip(this,FMainUI["MC_SeatPage"]);
         this.FPageEquip.OnOver = this.EquipOnOver;
         this.FPageEquip.OnOut = this.EquipOnOut;
         this.FPageEquip.TipOnOver = this.OnOver;
         this.FPageEquip.OnDismount = this.OnDisMount;
         this.FBtnHelp = new TUIButton();
         this.FBtnHelp.Substrate = FMainUI["Btn_Help"];
         this.FBtnHelp.OnOver = this.HelpOnOver;
         this.FBtnHelp.OnOut = this.HelpOnOut;
         this.FHelpHint = new THint();
         this.FHelpHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_02);
         this.FAnimationSequence = new Vector.<TAnimationSequence>(CONST_HEROCOMPANION.Seat_Card_Num);
         this.FUIImage = new TUIImage(FParent);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.SeatedOnEnd);
         this.FTFFever = FMainUI["TF_Fever"];
         this.FBar = FMainUI["MC_Bar"];
         this.FScrollBar = new TScrollBar(FMainUI["MC_List"],75,false,4,21);
         this.FIsSeated = true;
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         super.SetData(param1);
         this.FPageCard.SetCardData(FData);
         this.FPageEquip.SetCardData(FData);
         this.FTFFever.text = FData.Fever + "/" + FData.TotalFever;
         this.FBar.scaleX = FData.Fever / FData.TotalFever;
         if(this.FIsSeated)
         {
            this.SetSeatEffect();
            this.FIsSeated = false;
         }
      }
   }
}

