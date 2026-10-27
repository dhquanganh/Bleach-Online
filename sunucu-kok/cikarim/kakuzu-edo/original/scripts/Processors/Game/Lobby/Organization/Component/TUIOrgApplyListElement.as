package Processors.Game.Lobby.Organization.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.Organization.TBaseOrganizationMember;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TUIOrgApplyListElement extends TUIComponent
   {
      
      protected var FIsInitialization:Boolean;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Rank:TextField;
      
      protected var FTF_MilitaryPower:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FBtn_Refuse:TUIButton;
      
      protected var FPlayerData:TBaseOrganizationMember;
      
      protected var FMC:MovieClip;
      
      protected var FClickBtn:Function;
      
      public function TUIOrgApplyListElement(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         this.FTF_Name = this.FMC["TF_Name"];
         this.FTF_Level = this.FMC["TF_Level"];
         this.FTF_Rank = this.FMC["TF_Rank"];
         this.FTF_MilitaryPower = this.FMC["TF_MilitaryPower"];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC["Btn_Ok"];
         this.FBtn_Ok.OnClick = this.OnBtnOkClick;
         this.FBtn_Refuse = new TUIButton();
         this.FBtn_Refuse.Substrate = this.FMC["Btn_Refuse"];
         this.FBtn_Refuse.OnClick = this.OnBtnRefuseClick;
      }
      
      protected function UpdateList() : void
      {
         if(this.FPlayerData != null)
         {
            this.FTF_Name.text = String(this.FPlayerData.PlayerName);
            this.FTF_Level.text = String(this.FPlayerData.PlayerLevel);
            this.FTF_Rank.text = String(this.FPlayerData.Rank);
            this.FTF_MilitaryPower.text = String(this.FPlayerData.PlayerOrgPower);
         }
         else
         {
            this.FTF_Name.text = "";
            this.FTF_Level.text = "";
            this.FTF_Rank.text = "";
            this.FTF_MilitaryPower.text = "";
         }
      }
      
      protected function OnBtnOkClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_ConfirmApplyJoinGuildReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(1);
         _loc4_.writeUnsignedInt(this.FPlayerData.Identifier0);
         _loc4_.writeUnsignedInt(this.FPlayerData.Identifier1);
         _loc4_.writeByte(1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         if(this.FClickBtn != null)
         {
            this.FClickBtn(this,1,this.FPlayerData.Identifier0,this.FPlayerData.Identifier1);
         }
      }
      
      protected function OnBtnRefuseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_ConfirmApplyJoinGuildReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(1);
         _loc4_.writeUnsignedInt(this.FPlayerData.Identifier0);
         _loc4_.writeUnsignedInt(this.FPlayerData.Identifier1);
         _loc4_.writeByte(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         if(this.FClickBtn != null)
         {
            this.FClickBtn(this,0,this.FPlayerData.Identifier0,this.FPlayerData.Identifier1);
         }
      }
      
      public function get MC() : MovieClip
      {
         return this.FMC;
      }
      
      public function get ClickBtn() : Function
      {
         return this.FClickBtn;
      }
      
      public function set ClickBtn(param1:Function) : void
      {
         this.FClickBtn = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpDateList(param1:TBaseOrganizationMember) : void
      {
         this.FPlayerData = param1;
         this.UpdateList();
      }
   }
}

