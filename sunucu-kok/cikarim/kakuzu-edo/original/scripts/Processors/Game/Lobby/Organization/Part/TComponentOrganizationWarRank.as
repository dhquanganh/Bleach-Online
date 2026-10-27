package Processors.Game.Lobby.Organization.Part
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.Organization.TBaseOrganizationMember;
   import Logics.Organization.TBaseOrganiztionList;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ORGANIZATION;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TComponentOrganizationWarRank extends TUIComponent
   {
      
      protected static const RANK_COUNT:int = 10;
      
      protected var FInitialized:Boolean;
      
      protected var FMC_Scene:MovieClip;
      
      protected var FMC_FactionRank:Vector.<MovieClip>;
      
      protected var FMC_PersonalRank:Vector.<MovieClip>;
      
      protected var FFactionRankData:Array;
      
      protected var FPersonalRankData:Array;
      
      protected var FOnClose:Function;
      
      public function TComponentOrganizationWarRank(param1:TUIComponent)
      {
         super(param1);
         this.FMC_FactionRank = new Vector.<MovieClip>();
         this.FMC_PersonalRank = new Vector.<MovieClip>();
         this.FFactionRankData = [];
         this.FPersonalRankData = [];
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FMC_Scene = param1;
         addChild(this.FMC_Scene);
         var _loc4_:int = int(this.FMC_FactionRank.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.FMC_FactionRank.pop();
            _loc3_.parent.removeChild(_loc3_);
            _loc2_++;
         }
         this.FMC_FactionRank.length = 0;
         _loc2_ = 0;
         while(_loc2_ < RANK_COUNT)
         {
            _loc3_ = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_MC_FactionRank + _loc2_];
            this.FMC_FactionRank.push(_loc3_);
            this.FMC_FactionRank[_loc2_].visible = false;
            _loc2_++;
         }
         _loc4_ = int(this.FMC_PersonalRank.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.FMC_PersonalRank.pop();
            _loc3_.parent.removeChild(_loc3_);
            _loc2_++;
         }
         this.FMC_PersonalRank.length = 0;
         _loc2_ = 0;
         while(_loc2_ < RANK_COUNT)
         {
            _loc3_ = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_MC_PersonalRank + _loc2_];
            this.FMC_PersonalRank.push(_loc3_);
            this.FMC_PersonalRank[_loc2_].visible = false;
            _loc2_++;
         }
         this.FMC_Scene.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
      }
      
      public function LogicsPerform() : void
      {
         if(this.FInitialized && this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      protected function UpdateUI() : void
      {
      }
      
      private function UpdateFactionRank(param1:Vector.<TBaseOrganiztionList>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < RANK_COUNT)
         {
            _loc3_ = this.FMC_FactionRank[_loc2_];
            if(_loc2_ < param1.length)
            {
               _loc3_.visible = true;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_Ranking].text = _loc2_ + 1;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_MC_FamilyIcon].gotoAndStop(param1[_loc2_].OrgFamily);
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_FactionName].text = param1[_loc2_].OrgName;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_Point].text = param1[_loc2_].Score.toString();
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function UpdatePersonalRank(param1:Vector.<TBaseOrganizationMember>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < RANK_COUNT)
         {
            _loc3_ = this.FMC_PersonalRank[_loc2_];
            if(_loc2_ < param1.length)
            {
               _loc3_.visible = true;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_Ranking].text = _loc2_ + 1;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_MC_FamilyIcon].gotoAndStop(param1[_loc2_].PlayerFamily);
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_Name].text = param1[_loc2_].PlayerName;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_FactionName].text = param1[_loc2_].OrgName;
               _loc3_[CONST_ORGANIZATION.RESOURCE_Link_TF_Point].text = param1[_loc2_].Score.toString();
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
      }
      
      public function get FactionRankData() : Array
      {
         return this.FFactionRankData;
      }
      
      public function set FactionRankData(param1:Array) : void
      {
         this.FFactionRankData = param1;
      }
      
      public function get PersonalRankData() : Array
      {
         return this.FPersonalRankData;
      }
      
      public function set PersonalRankData(param1:Array) : void
      {
         this.FPersonalRankData = param1;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FInitialized = true;
      }
      
      public function Update(param1:Vector.<TBaseOrganiztionList>, param2:Vector.<TBaseOrganizationMember>) : void
      {
         this.UpdateFactionRank(param1);
         this.UpdatePersonalRank(param2);
      }
      
      public function MuyeBattleRankReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_MuyeBattleReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

