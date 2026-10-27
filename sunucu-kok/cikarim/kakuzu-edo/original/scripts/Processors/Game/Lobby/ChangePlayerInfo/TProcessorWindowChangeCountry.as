package Processors.Game.Lobby.ChangePlayerInfo
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowChangeCountry extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtn_Joins:Vector.<TUIButton>;
      
      protected var FSP_Recommand:Vector.<Sprite>;
      
      protected var FPromotWindow:TUIWindowConfirmation;
      
      protected var FSelectFamilyID:int;
      
      protected var FCountry:uint;
      
      public function TProcessorWindowChangeCountry(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("Family") as Sprite;
         addChild(this.FMainUI);
         _loc1_ = 3;
         this.FBtn_Joins = new Vector.<TUIButton>(_loc1_);
         this.FSP_Recommand = new Vector.<Sprite>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FBtn_Joins[_loc2_] = new TUIButton();
            this.FBtn_Joins[_loc2_].Substrate = this.FMainUI["BTN_Join" + (_loc2_ + 1)];
            this.FBtn_Joins[_loc2_].OnClick = this.ProcessorBtnOnClick;
            this.FSP_Recommand[_loc2_] = this.FMainUI["Recommand" + (_loc2_ + 1)];
            this.FSP_Recommand[_loc2_].visible = false;
            _loc2_++;
         }
         this.FPromotWindow = SUtilityOverLayer.UIWindowConfirmation;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.WindowClose;
         this.FCountry = SLogicsCore.Character.Country;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function WindowClose(param1:Object, param2:Event) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ProcessorBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtn_Joins.indexOf(param1 as TUIButton);
         this.FSelectFamilyID = _loc3_ + 1;
         this.FPromotWindow.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FreshGuide_STRING_0),TUtilityLobby.GetFamilyNameByIndex(this.FSelectFamilyID));
         this.FPromotWindow.OnOK = this.PromotWindowOk;
         this.FPromotWindow.Visible = true;
      }
      
      protected function PromotWindowOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ChangeInfo_ChangeCountryReq);
         _loc2_.Data.writeByte(this.FSelectFamilyID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         ProcessorWindowClose();
      }
      
      public function set Country(param1:uint) : void
      {
         this.FCountry = param1;
      }
      
      public function UpdateBtn() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         _loc1_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FBtn_Joins[_loc2_].Enabled = true;
            _loc2_++;
         }
         if(this.FCountry == 0)
         {
            return;
         }
         this.FBtn_Joins[this.FCountry - 1].Enabled = false;
      }
   }
}

