package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Network.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.GongFuFight.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.GongFuFight.TProcessorPlateGongFuFight;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TComponentFightRecord extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FTFRecord:TextField;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnOpen:TUIButton;
      
      protected var FWinFormat:String;
      
      protected var FLoseFormat:String;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      public function TComponentFightRecord(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function ComponentsResize() : void
      {
         super.ComponentsResize();
         if(Visible && this.FMainUI != null)
         {
            this.FMainUI.x = FUICore.StageWidth - (1250 - 956);
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         this.FMainUI = param1["rankList"];
         _loc2_ = this.FMainUI["View"];
         this.FTFRecord = _loc2_["RecordTF"];
         this.FTFRecord.addEventListener(TextEvent.LINK,this.LookBattleReport);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = _loc2_["MC_btn"]["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnOpen = new TUIButton();
         this.FBtnOpen.Substrate = _loc2_["MC_btn"]["Btn_Open"];
         this.FBtnOpen.OnClick = this.BtnOpenOnClick;
         this.FWinFormat = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_24);
         this.FLoseFormat = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_25);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMainUI.play();
         this.FBtnClose.Visible = false;
      }
      
      protected function BtnOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMainUI.play();
         this.FBtnClose.Visible = true;
      }
      
      protected function RenderView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TGongFuFightRecord = null;
         _loc3_ = "";
         _loc2_ = this.FGongFuFightData.GongFuRecordEffectNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FGongFuFightData.GongFuFightRecords[_loc1_];
            if(_loc4_.IsWin)
            {
               _loc3_ += TUtilityString.Format(this.FWinFormat,_loc4_.Name,_loc4_.ReportID);
            }
            else
            {
               _loc3_ += TUtilityString.Format(this.FLoseFormat,_loc4_.Name,_loc4_.ReportID);
            }
            _loc1_++;
         }
         this.FTFRecord.htmlText = _loc3_;
      }
      
      protected function LookBattleReport(param1:TextEvent) : void
      {
         if(TProcessorPlateGongFuFight.FightPending)
         {
            return;
         }
         var packet:TPacket = SNetworkCore.PacketAcquire(25247101);
         packet.Data.writeUTF(param1.text);
         TProcessorPlateGongFuFight.FightPending = true;
         SNetworkCore.Transceiver.PacketTransmit(packet);
      }
      
      public function Update(param1:TGongFuFightData) : void
      {
         this.FGongFuFightData = param1;
         this.RenderView();
      }
      
      public function OpenView() : void
      {
         this.FMainUI.gotoAndStop(15);
         this.FBtnClose.Visible = true;
      }
      
      public function Reset() : void
      {
         this.FBtnClose.Visible = true;
         this.FMainUI.gotoAndStop(1);
      }
   }
}

