package Processors.Game.Lobby.CityDefend
{
   import Foundation.Network.*;
   import Foundation.Timing.STimingCore;
   import Processors.Game.Battle.TBattleHandle;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.*;
   import Logics.CityDefend.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowDoorHeroList extends TProcessorGame
   {
      
      protected static const MAX_COUNT:uint = 10;
      
      protected var Bg_Sp:Shape;
      
      protected var FScene:MovieClip;
      
      protected var FCityDefendData:TCityDefendData;
      
      protected var FCurPage:uint;
      
      protected var FTotlePage:uint;
      
      protected var FOnEffectText:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      public function TProcessorWindowDoorHeroList(param1:TUIComponent)
      {
         super(param1);
         this.FCurPage = 1;
         this.FTotlePage = 1;
         this.Bg_Sp = new Shape();
         this.Bg_Sp.graphics.beginFill(0,0.3);
         this.Bg_Sp.graphics.drawRect(0,0,CONST_COMMON.STAGE_Max_Width,CONST_COMMON.STAGE_Max_Height);
         this.Bg_Sp.graphics.endFill();
         addChild(this.Bg_Sp);
      }
      
      protected function CheckBtn() : void
      {
         this.FScene.btn_left.visible = Boolean(this.FCurPage != 1);
         this.FScene.btn_right.visible = Boolean(this.FCurPage != this.FTotlePage);
         this.FScene.tf_page.text = this.FCurPage + "/" + this.FTotlePage;
      }
      
      protected function OnCloseWindow(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_CityDoorReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         Visible = false;
      }
      
      protected function CanRequestFight() : Boolean
      {
         if(TProcessorCityDefend.FightPending || TProcessorCityDefend.StageTransition || TBattleHandle.IsInBattle) return false;
         if(STimingCore.ServerTick < TProcessorCityDefend.FightReadyAt)
         {
            if(this.FOnEffectText != null) this.FOnEffectText("Ch\u1edd " + (TProcessorCityDefend.FightReadyAt - STimingCore.ServerTick) + " gi\u00e2y \u0111\u1ec3 ti\u1ebfp t\u1ee5c.");
            return false;
         }
         return true;
      }

      protected function OnAttackDoor(param1:MouseEvent = null) : void
      {
         if(!this.CanRequestFight()) return;
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_FightReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeUnsignedInt(0);
         TProcessorCityDefend.FightPending = true;
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);

      }
      
      protected function OnFightHero(param1:MouseEvent) : void
      {
         if(!this.CanRequestFight()) return;
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TCityDefendHero = null;
         _loc4_ = int(String(param1.target.parent.name).slice(8)) + (this.FCurPage - 1) * MAX_COUNT;
         _loc5_ = this.FCityDefendData.DoorHeroList.GetHeroByIndex(_loc4_);
         if(_loc5_ == null)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_09));
            }
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_FightReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc5_.Identifier0);
         _loc3_.writeUnsignedInt(_loc5_.Identifier1);
         TProcessorCityDefend.FightPending = true;
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);

      }
      
      protected function OnLeft(param1:MouseEvent) : void
      {
         --this.FCurPage;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.UpdataDoorHeroList();
         this.CheckBtn();
      }
      
      protected function OnRight(param1:MouseEvent) : void
      {
         ++this.FCurPage;
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         this.UpdataDoorHeroList();
         this.CheckBtn();
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function SetScene(param1:MovieClip) : void
      {
         this.FScene = param1;
         addChild(this.FScene);
      }
      
      public function InitUI(param1:TCityDefendData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FCityDefendData = param1;
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         TGameUtil.setButtonMode(this.FScene.mc_door.btn_Attack,true);
         this.FScene.mc_door.btn_Attack.addEventListener(MouseEvent.CLICK,this.OnAttackDoor);
         _loc2_ = 0;
         while(_loc2_ < MAX_COUNT)
         {
            _loc3_ = this.FScene["mc_hero_" + _loc2_];
            TGameUtil.setButtonMode(_loc3_.btn_exchange,true);
            _loc3_.btn_exchange.addEventListener(MouseEvent.CLICK,this.OnFightHero);
            _loc2_++;
         }
         TGameUtil.setButtonMode(this.FScene.btn_left,true);
         this.FScene.btn_left.addEventListener(MouseEvent.CLICK,this.OnLeft);
         TGameUtil.setButtonMode(this.FScene.btn_right,true);
         this.FScene.btn_right.addEventListener(MouseEvent.CLICK,this.OnRight);
         this.UpdataDoorHeroList();
      }
      
      public function UpdataDoorHeroList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TCityDefendHero = null;
         var _loc3_:MovieClip = null;
         this.FTotlePage = Math.max(int(this.FCityDefendData.DoorHeroList.Count - 1) / MAX_COUNT + 1,1);
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc3_ = this.FScene["mc_hero_" + _loc1_];
            if(_loc1_ + (this.FCurPage - 1) * MAX_COUNT < this.FCityDefendData.DoorHeroList.Count)
            {
               _loc3_.visible = true;
               _loc2_ = this.FCityDefendData.DoorHeroList.GetHeroByIndex(_loc1_ + (this.FCurPage - 1) * MAX_COUNT);
               _loc3_.tf_name.text = _loc2_.UserName;
               _loc3_.tf_level.text = _loc2_.UserLevel;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc1_++;
         }
         this.CheckBtn();
         if(this.FCityDefendData.CityDefendType == 0)
         {
            this.FScene.mc_door.visible = false;
            this.FScene.tf_title.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_07);
         }
         else
         {
            if(this.FCityDefendData.DoorHeroList.Count <= 0)
            {
               this.FScene.mc_door.visible = true;
            }
            else
            {
               this.FScene.mc_door.visible = false;
            }
            this.FScene.tf_title.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_08);
         }
      }
      
      public function OnFightHeroAuto() : void
      {
         if(TProcessorCityDefend.FightPending || TProcessorCityDefend.StageTransition || TBattleHandle.IsInBattle || STimingCore.ServerTick < TProcessorCityDefend.FightReadyAt) return;
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TCityDefendHero = null;
         if(this.FCityDefendData.DoorHeroList.Count <= 0)
         {
            this.OnAttackDoor();
            return;
         }
         _loc3_ = 0;
         _loc4_ = this.FCityDefendData.DoorHeroList.GetHeroByIndex(_loc3_);
         if(_loc4_ == null)
         {
            return;
         }
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_FightReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(_loc4_.Identifier0);
         _loc2_.writeUnsignedInt(_loc4_.Identifier1);
         TProcessorCityDefend.FightPending = true;
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);

      }
   }
}

