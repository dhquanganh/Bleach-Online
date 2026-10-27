package Processors.Game.Lobby.GongFuFight
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentBaseInfor;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentBeyondLevelFight;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentFightRecord;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentPlayerGroup;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentSelectEnemy;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TComponentSubFunction;
   import Processors.Game.Lobby.GongFuFight.MainUIComponent.TOverLayerPlayerInfor;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TWindowMainUI extends TProcessorLobbyWindow
   {
      
      protected var FMainScene:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FComponentBaseInfor:TComponentBaseInfor;
      
      protected var FComponentSelectEnemy:TComponentSelectEnemy;
      
      protected var FComponentPlayerGroup:TComponentPlayerGroup;
      
      protected var FComponentBeyondLevelFight:TComponentBeyondLevelFight;
      
      protected var FComponentFightRecord:TComponentFightRecord;
      
      protected var FComponentSubFunction:TComponentSubFunction;
      
      protected var FPlayerTip:TOverLayerPlayerInfor;
      
      protected var FGongFuData:TGongFuFightData;
      
      protected var FOnOpenGongFuFightWindow:Function;
      
      protected var FOnOpenTokenShop:Function;
      
      protected var FOnOpenStoneShop:Function;
      
      public function TWindowMainUI(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FPlayerTip != null && this.FPlayerTip.Visible)
         {
            this.FPlayerTip.UpdatePosition();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("GongFuFightUI") as Sprite;
         addChild(this.FMainScene);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["Title"]["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClose;
         this.FPlayerTip = new TOverLayerPlayerInfor(Parent.Parent);
         this.FPlayerTip.visible = false;
         this.FPlayerTip.UIDispatch();
         this.FComponentBaseInfor = new TComponentBaseInfor(this);
         this.FComponentBaseInfor.UIDispatch(this.FMainScene);
         this.FComponentSelectEnemy = new TComponentSelectEnemy(this);
         this.FComponentSelectEnemy.UIDispatch(this.FMainScene);
         this.FComponentSelectEnemy.OnStartFight = this.ComponentSelectEnemyOnClick;
         this.FComponentPlayerGroup = new TComponentPlayerGroup(this);
         this.FComponentPlayerGroup.OnPlayerClick = this.PlayerOnMouseClick;
         this.FComponentPlayerGroup.OnPlayerOver = this.PlayerOnMouseMove;
         this.FComponentPlayerGroup.OnPlayerOut = this.PlayerOnMouseOut;
         this.FComponentPlayerGroup.UIDispatch(this.FMainScene);
         this.FComponentBeyondLevelFight = new TComponentBeyondLevelFight(this);
         this.FComponentBeyondLevelFight.OnPlayerClick = this.PlayerOnMouseClick;
         this.FComponentBeyondLevelFight.OnPlayerOver = this.PlayerOnMouseMove;
         this.FComponentBeyondLevelFight.OnPlayerOut = this.PlayerOnMouseOut;
         this.FComponentBeyondLevelFight.UIDispatch(this.FMainScene);
         this.FComponentFightRecord = new TComponentFightRecord(this);
         this.FComponentFightRecord.UIDispatch(this.FMainScene);
         this.FComponentSubFunction = new TComponentSubFunction(this);
         this.FComponentSubFunction.OnOpenStoneShop = this.OpenStoneShop;
         this.FComponentSubFunction.OnOpenTokenShop = this.OpenTokenShop;
         this.FComponentSubFunction.UIDispatch(this.FMainScene);
         this.FComponentSubFunction.OnOpenSubWindow = this.OnOpenSubWindow;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      public function OnOpenSubWindow(param1:Object, param2:uint) : void
      {
         if(this.FOnOpenGongFuFightWindow != null)
         {
            this.FOnOpenGongFuFightWindow(param1,param2);
         }
      }
      
      protected function BtnCloseOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set GongFuData(param1:TGongFuFightData) : void
      {
         this.FGongFuData = param1;
      }
      
      public function PlayerOnMouseClick(param1:TGongFuFightPlayerInfor) : void
      {
         this.FComponentSelectEnemy.Update(param1);
      }
      
      protected function PlayerOnMouseMove(param1:TGongFuFightPlayerInfor) : void
      {
         this.FPlayerTip.Update(param1);
         this.FPlayerTip.Visible = true;
      }
      
      protected function PlayerOnMouseOut(param1:TGongFuFightPlayerInfor) : void
      {
         this.FPlayerTip.Visible = false;
      }
      
      public function ComponentSelectEnemyOnClick(param1:TGongFuFightPlayerInfor) : void
      {
         if(TProcessorPlateGongFuFight.FightPending)
         {
            return;
         }
         var _loc2_:TPacket = null;
         if(this.FGongFuData.GongFuFightBaseInfor.CurFightTimes <= 0)
         {
            this.FComponentBaseInfor.NotEnoughFightTime();
         }
         else
         {
            TProcessorPlateGongFuFight.FightPending = true;
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_FightReq);
            _loc2_.Data.writeByte(param1.Type);
            _loc2_.Data.writeUnsignedInt(param1.PlayerIndex);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
      }
      
      public function OpenTokenShop(param1:Object) : void
      {
         if(this.FOnOpenTokenShop != null)
         {
            this.FOnOpenTokenShop(param1);
         }
      }
      
      public function OpenStoneShop(param1:Object) : void
      {
         if(this.FOnOpenStoneShop != null)
         {
            this.FOnOpenStoneShop(param1);
         }
      }
      
      public function set OnOpenGongFuFightWindow(param1:Function) : void
      {
         this.FOnOpenGongFuFightWindow = param1;
      }
      
      public function set OnOpenTokenShop(param1:Function) : void
      {
         this.FOnOpenTokenShop = param1;
      }
      
      public function set OnOpenStoneShop(param1:Function) : void
      {
         this.FOnOpenStoneShop = param1;
      }
      
      public function Update() : void
      {
         var phase:String;
         var packet:TPacket;
         if(this.FMainScene == null)
         {
            return;
         }
         phase = "base";
         try
         {
            this.FComponentBaseInfor.Update(this.FGongFuData.GongFuFightBaseInfor);
            phase = "selectEnemy";
            this.FComponentSelectEnemy.Update(null);
            phase = "playerGroups";
            this.FComponentPlayerGroup.Update(this.FGongFuData);
            phase = "superGroups";
            this.FComponentBeyondLevelFight.Update(this.FGongFuData);
            phase = "records";
            this.FComponentFightRecord.Update(this.FGongFuData);
         }
         catch(error:Error)
         {
            packet = SNetworkCore.PacketAcquire(25293569);
            packet.Data.writeUTF("CrossUI " + phase + " " + error.toString() + " " + error.getStackTrace());
            SNetworkCore.Transceiver.PacketTransmit(packet);
            throw error;
         }
      }
      
      public function OpenView() : void
      {
         this.FComponentSelectEnemy.OpenView();
         this.FComponentSelectEnemy.Visible = true;
         this.FComponentPlayerGroup.OpenView();
         this.FComponentPlayerGroup.Visible = true;
         this.FComponentBeyondLevelFight.OpenView();
         this.FComponentBeyondLevelFight.Visible = true;
         this.FComponentFightRecord.OpenView();
         this.FComponentFightRecord.Visible = true;
         this.FComponentSubFunction.OpenView();
         this.FComponentSubFunction.Visible = true;
      }
      
      public function AddBeyondChanllgeFight() : void
      {
         this.FComponentBeyondLevelFight.AddBeyondChanllgeFight();
         this.FComponentBaseInfor.Update(this.FGongFuData.GongFuFightBaseInfor);
      }
      
      public function ReciveBox() : void
      {
         this.FComponentPlayerGroup.Update(this.FGongFuData);
      }
      
      public function AddTime() : void
      {
         this.FComponentBaseInfor.Update(this.FGongFuData.GongFuFightBaseInfor);
      }
      
      public function ApplySuccess() : void
      {
         this.FComponentBaseInfor.Update(this.FGongFuData.GongFuFightBaseInfor);
      }
      
      public function PaySuccess() : void
      {
         this.FComponentBaseInfor.Update(this.FGongFuData.GongFuFightBaseInfor);
      }
      
      public function Reset() : void
      {
         this.FComponentBaseInfor.Reset();
         this.FComponentSelectEnemy.Reset();
         this.FComponentSelectEnemy.Visible = false;
         this.FComponentPlayerGroup.Reset();
         this.FComponentPlayerGroup.Visible = false;
         this.FComponentBeyondLevelFight.Reset();
         this.FComponentBeyondLevelFight.Visible = false;
         this.FComponentFightRecord.Reset();
         this.FComponentFightRecord.Visible = false;
         this.FComponentSubFunction.Reset();
         this.FComponentSubFunction.Visible = false;
         this.FPlayerTip.Reset();
      }
   }
}

