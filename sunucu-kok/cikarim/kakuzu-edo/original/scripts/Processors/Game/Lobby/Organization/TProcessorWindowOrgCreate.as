package Processors.Game.Lobby.Organization
{
   import Components.Standard.TUIButton;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.SensitiveWord.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowOrgCreate extends TProcessorLobbyWindow
   {
      
      protected var FMC:Sprite;
      
      protected var FTF_InputOrgName:TextField;
      
      protected var FTF_Prompt:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FBtn_Cancel:SimpleButton;
      
      public function TProcessorWindowOrgCreate(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_CreateOrganization) as Sprite;
         addChild(this.FMC);
         this.FTF_InputOrgName = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_InputOrgName];
         if(false == true || false == true || false == true)
         {
            this.FTF_InputOrgName.restrict = "[a-zA-Z0-9#一-龥]";
         }
         this.FTF_InputOrgName.maxChars = 12;
         this.FTF_InputOrgName.text = "";
         this.FTF_Prompt = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Prompt];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Ok];
         this.FBtn_Ok.OnClick = this.OnOkClick;
         this.FBtn_Cancel = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Cancel];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Cancel.addEventListener(MouseEvent.CLICK,OnClose);
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateUI() : void
      {
         this.FTF_InputOrgName.text = "";
      }
      
      protected function OnOkClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         _loc3_ = this.FTF_InputOrgName.text;
         _loc3_ = SSensitiveWord.Filter(_loc3_);
         _loc4_ = _loc3_.indexOf("*");
         if(_loc4_ != -1)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_56));
            return;
         }
         if(_loc3_ == null || _loc3_ == "")
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_57));
            return;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_CreateGulidReq);
         _loc6_ = _loc5_.Data;
         _loc6_.writeUTF(_loc3_);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
   }
}

