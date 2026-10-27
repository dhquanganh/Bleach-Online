package Processors.Game.Lobby.ChangePlayerInfo
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowChangeName extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnOK:TUIButton;
      
      protected var FText:TextField;
      
      protected var FPromotWindow:TUIWindowConfirmation;
      
      public function TProcessorWindowChangeName(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:TBins = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_Activity_CDK") as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.WindowClose;
         this.FBtnOK = new TUIButton();
         this.FBtnOK.Substrate = this.FMainUI["Btn_OK"];
         this.FBtnOK.OnClick = this.BtnOKClick;
         this.FText = new TextField();
         this.FText = this.FMainUI["TF_Input"];
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = _loc4_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ChangeNameLength) as TConfigValue;
         this.FText.maxChars = _loc3_.Value as uint;
         this.FText.text = "";
         this.FPromotWindow = SUtilityOverLayer.UIWindowConfirmation;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function WindowClose(param1:Object, param2:Event) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnOKClick(param1:Object, param2:Event) : void
      {
         this.FPromotWindow.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ChangeInfo_01) + this.FText.text;
         this.FPromotWindow.OnOK = this.PromotWindowOk;
         this.FPromotWindow.Visible = true;
      }
      
      private function PromotWindowOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ChangeInfo_ChangeNameReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUTF(this.FText.text);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
   }
}

