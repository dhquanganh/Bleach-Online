package Processors.Game.Lobby.HeroCompanion.CardMap
{
   import Components.Standard.TUITab;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionCardDatas;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Common.Effects.ListScroller.TListScroller;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionMapItem;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Resources.Constants.CONST_HEROCOMPANION;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class TProcessorCompanionMap extends TCompanionBaseView
   {
      
      protected static const Tab_Num:int = 2;
      
      protected static const TabType_Own:int = 0;
      
      protected static const TabType_NotOwn:int = 1;
      
      protected static const MapIndex_Default:int = -2;
      
      protected static const Card_Animation_time:int = 1000;
      
      protected var FTab:TUITab;
      
      protected var FCardInfo:TCompanionMapCardInfo;
      
      protected var FScroll:TListScroller;
      
      protected var FOwns:THeroCompanionCardDatas;
      
      protected var FNotOwns:THeroCompanionCardDatas;
      
      protected var FTabIndex:int;
      
      protected var FStarEffectVec:Vector.<MovieClip>;
      
      protected var FItemVec:Vector.<TCompanionMapItem>;
      
      protected var FCurMapIndex:int;
      
      protected var FCardEffect:MovieClip;
      
      protected var FBigCard:TCompanionCardItem;
      
      protected var FComposeCardId:int;
      
      protected var FCardMovement:TMovementLinear;
      
      protected var FCardDestinationX:int;
      
      protected var FCardDestinationY:int;
      
      protected var FCardOrginX:int;
      
      protected var FCardOrginY:int;
      
      protected var FCardStartTick:int;
      
      public function TProcessorCompanionMap(param1:TUIComponent)
      {
         super(param1);
         this.FOwns = new THeroCompanionCardDatas();
         this.FNotOwns = new THeroCompanionCardDatas();
         this.FItemVec = new Vector.<TCompanionMapItem>();
         this.FStarEffectVec = new Vector.<MovieClip>();
         this.FCurMapIndex = MapIndex_Default;
      }
      
      protected function RenderUI(param1:THeroCompanionCardDatas) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroCompanionCardData = null;
         var _loc5_:TCompanionMapItem = null;
         this.FScroll.Clear();
         this.FItemVec.length = 0;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetCardByIndex(_loc2_);
            _loc5_ = new TCompanionMapItem();
            _loc5_.SetData(_loc4_,FData.GetChipByChipId(_loc4_.GetCurCard().ChipId),_loc4_.Level > 0);
            _loc5_.EffectVec = this.FStarEffectVec;
            _loc5_.buttonMode = true;
            _loc5_.TipOnOver = this.OnOver;
            _loc5_.TipOnOut = this.OnOut;
            _loc5_.CardOnEmploy = this.CardOnEmploy;
            _loc5_.CardOnUpgrade = this.CardOnUpgrade;
            _loc5_.UICore = FParent;
            _loc5_.OnClick = this.ItemOnClick;
            this.FScroll.AddItem(_loc5_);
            this.FItemVec.push(_loc5_);
            _loc2_++;
         }
      }
      
      protected function CardOnEmploy(param1:Object, param2:TCompanionCard) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_ComposeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param2.ChipId);
         _loc4_.writeUnsignedInt(param2.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FComposeCardId = param2.Identifier;
      }
      
      protected function CardOnUpgrade(param1:Object, param2:TCompanionCard) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_UpgrateReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param2.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FCurMapIndex = this.FItemVec.indexOf(param1 as TCompanionMapItem);
      }
      
      protected function ItemOnClick(param1:THeroCompanionCardData) : void
      {
         this.FCardInfo.SetInfoData(param1);
         this.FCardInfo.Visible = true;
         this.FCardInfo.SetData(FData);
      }
      
      protected function OnOver(param1:TCompanionCard) : void
      {
         FTipOnOver(param1);
      }
      
      protected function OnOut() : void
      {
         FTipOnOut();
      }
      
      private function TabOnSwitch(param1:int) : void
      {
         this.FTabIndex = param1;
         switch(param1)
         {
            case TabType_Own:
               this.RenderUI(this.FOwns);
               break;
            case TabType_NotOwn:
               this.RenderUI(this.FNotOwns);
         }
      }
      
      protected function CardOnEffectEnd() : void
      {
         this.FCardEffect.visible = false;
         this.FCardEffect.stop();
         this.FCardMovement.SetupSegmentByDuration(this.FCardDestinationX,this.FCardDestinationY,this.FCardOrginX,this.FCardOrginY,Card_Animation_time);
         this.FCardStartTick = STimingCore.TickCount;
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         super.UIDispatch(param1);
         this.FTab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < Tab_Num)
         {
            this.FTab.SetTabByIndex(FMainUI["MC_Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FTab.OnSwitch = this.TabOnSwitch;
         this.FTab.Init();
         this.FCardInfo = new TCompanionMapCardInfo(this);
         this.FCardInfo.UIDispatch(FMainUI["MC_CardInfo"]);
         this.FCardInfo.CardOnEmploy = this.CardOnEmploy;
         this.FCardInfo.CardOnUpgrade = this.CardOnUpgrade;
         this.FCardInfo.EffectVec = this.FStarEffectVec;
         this.FCardInfo.Visible = false;
         this.FScroll = new TListScroller(FMainUI["MC_List"],290,false,190,160);
         this.FScroll.HCount = CONST_HEROCOMPANION.Map_List_HoriCount;
         this.FScroll.HSpace = CONST_HEROCOMPANION.Map_List_HoriSpace;
         this.FCardEffect = FMainUI["MC_CardEffect"];
         this.FCardEffect.addFrameScript(this.FCardEffect.totalFrames - 1,this.CardOnEffectEnd);
         this.FCardEffect.visible = false;
         this.FCardEffect.gotoAndStop(1);
         this.FBigCard = new TCompanionCardItem(FMainUI["MC_Card"]);
         this.FCardMovement = new TMovementLinear();
         this.FCardDestinationX = FMainUI["MC_Tab_0"].x;
         this.FCardDestinationY = FMainUI["MC_Tab_0"].y;
         this.FCardOrginX = this.FBigCard.Substrate.x;
         this.FCardOrginY = this.FBigCard.Substrate.y;
         this.FBigCard.Visible = false;
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroCompanionCardData = null;
         super.SetData(param1);
         this.FOwns.Clear();
         this.FNotOwns.Clear();
         _loc3_ = FData.CardDatas.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FData.CardDatas.GetCardByIndex(_loc2_);
            if(_loc4_.Level > 0)
            {
               this.FOwns.AddCard(_loc4_);
            }
            else
            {
               this.FNotOwns.AddCard(_loc4_);
            }
            _loc2_++;
         }
         this.FCardInfo.SetData(FData);
         this.FTab.SwithTagManual(this.FTabIndex);
         if(FData.ServerState == CONST_HEROCOMPANION.EffectType_Upgrade)
         {
            if(this.FCurMapIndex == -1)
            {
               this.FCardInfo.PlayEffects();
            }
            else
            {
               this.FItemVec[this.FCurMapIndex].PlayEffects();
            }
         }
         else if(FData.ServerState == CONST_HEROCOMPANION.EffectType_Compose)
         {
            this.FBigCard.SetCardData(this.FComposeCardId);
            this.FBigCard.Substrate.x = this.FCardOrginX;
            this.FBigCard.Substrate.y = this.FCardOrginY;
            this.FBigCard.Substrate.scaleX = this.FBigCard.Substrate.scaleY = 1;
            this.FBigCard.Visible = true;
            this.FCardEffect.visible = true;
            this.FCardEffect.gotoAndPlay(1);
            this.FCardInfo.Close();
         }
         this.FCurMapIndex = MapIndex_Default;
         FData.ServerState = 0;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:Number = NaN;
         super.LogicsPerform();
         if(this.FBigCard == null || this.FCardStartTick <= 0)
         {
            return;
         }
         this.FCardMovement.Move(STimingCore.TickCount - this.FCardStartTick);
         this.FBigCard.Substrate.x = this.FCardMovement.X;
         this.FBigCard.Substrate.y = this.FCardMovement.Y;
         _loc1_ = 1 - this.FCardMovement.Ratio;
         this.FBigCard.Substrate.scaleX = _loc1_;
         this.FBigCard.Substrate.scaleY = _loc1_;
         if(this.FCardMovement.MoveOver)
         {
            this.FBigCard.Visible = false;
            this.FTab.SwithTagManual(0);
            this.FCardStartTick = 0;
         }
      }
   }
}

