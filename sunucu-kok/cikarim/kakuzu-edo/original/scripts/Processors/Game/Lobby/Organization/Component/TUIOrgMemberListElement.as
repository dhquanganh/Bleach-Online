package Processors.Game.Lobby.Organization.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.Organization.TBaseOrganiztionList;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TUIOrgMemberListElement extends TUIComponent
   {
      
      protected var FTF_Ranking:TextField;
      
      protected var FMC_Home:MovieClip;
      
      protected var FTF_OrgName:TextField;
      
      protected var FTF_OrgLevel:TextField;
      
      protected var FTF_OrgMasterName:TextField;
      
      protected var FTF_OrgMembers:TextField;
      
      protected var FBTN_ApplyOrg:TUIButton;
      
      protected var FIsInitialization:Boolean;
      
      protected var FElementData:TBaseOrganiztionList;
      
      protected var FOrgID:uint;
      
      protected var FRank:uint;
      
      protected var FBAddOrg:Boolean;
      
      protected var FMC:MovieClip;
      
      protected var FClickApplyOrg:Function;
      
      public function TUIOrgMemberListElement(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         this.FTF_Ranking = this.FMC["TF_Ranking"];
         this.FMC_Home = this.FMC["MC_Home"];
         this.FTF_OrgName = this.FMC["TF_OrgName"];
         this.FTF_OrgLevel = this.FMC["TF_OrgLevel"];
         this.FTF_OrgMasterName = this.FMC["TF_OrgMasterName"];
         this.FTF_OrgMembers = this.FMC["TF_OrgMembers"];
         this.FBTN_ApplyOrg = new TUIButton();
         this.FBTN_ApplyOrg.Substrate = this.FMC["BTN_ApplyOrg"];
         this.FBTN_ApplyOrg.OnClick = this.OnApplyOrgClick;
      }
      
      protected function UpdateElement(param1:TBaseOrganiztionList) : void
      {
         this.FOrgID = param1.OrgID;
         this.FTF_Ranking.text = String(this.FRank);
         this.FMC_Home.gotoAndStop(param1.OrgFamily > 0 ? param1.OrgFamily : 1);
         this.FTF_OrgName.text = param1.OrgName;
         this.FTF_OrgLevel.text = String(param1.OrgLevel);
         this.FTF_OrgMasterName.text = param1.OrgMasterName;
         this.FTF_OrgMembers.text = param1.OrgMembersCount + "/" + param1.OrgMaxMemberCount;
         if(!this.FBAddOrg)
         {
            if(SLogicsCore.Character.Country == param1.OrgFamily)
            {
               if(!param1.OrgIsApply)
               {
                  this.FBTN_ApplyOrg.Visible = true;
               }
               else
               {
                  this.FBTN_ApplyOrg.Visible = false;
               }
            }
            else
            {
               this.FBTN_ApplyOrg.Visible = false;
            }
         }
         else
         {
            this.FBTN_ApplyOrg.Visible = false;
         }
      }
      
      protected function OnApplyOrgClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(this.FOrgID > 0)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_ApplyJoinGulidReq);
            _loc4_ = _loc3_.Data;
            _loc4_.writeUnsignedInt(this.FOrgID);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
         this.FBTN_ApplyOrg.Visible = false;
      }
      
      public function get ClickApplyOrg() : Function
      {
         return this.FClickApplyOrg;
      }
      
      public function set ClickApplyOrg(param1:Function) : void
      {
         this.FClickApplyOrg = param1;
      }
      
      public function get MC() : MovieClip
      {
         return this.FMC;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpDateElement(param1:TBaseOrganiztionList, param2:uint, param3:Boolean) : void
      {
         this.FBAddOrg = param3;
         this.FRank = param2;
         this.UpdateElement(param1);
      }
   }
}

