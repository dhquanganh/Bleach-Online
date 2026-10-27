package Processors.Game.Lobby.Organization
{
   import Components.Pages.*;
   import Components.Standard.TUIButton;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Organization.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowOrgApplyAndPower extends TProcessorLobbyWindow
   {
      
      protected static const MAX_LISTCOUNT:uint = 14;
      
      protected static const STAGE_Width:Number = 618;
      
      protected static const STAGE_Height:Number = 488;
      
      protected var FMC:Sprite;
      
      protected var FMC_SwitchPowerList:Sprite;
      
      protected var FMC_ApplyList:Sprite;
      
      protected var FMC_ChangePage:Sprite;
      
      protected var FMC_PageLeft:MovieClip;
      
      protected var FMC_PageRight:MovieClip;
      
      protected var FTF_Page:TextField;
      
      protected var FBtn_Refuse:TUIButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_Title:MovieClip;
      
      protected var FApplyListElementVect:Vector.<TUIOrgApplyListElement>;
      
      protected var FSwitchPowerListElementVect:Vector.<TUIOrgSwitchPowerListElement>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FSelectPageIndex:int;
      
      protected var FPopupType:int;
      
      protected var FApplyListData:Vector.<TBaseOrganizationMember>;
      
      protected var FSwitchPowerListData:Vector.<TBaseOrganizationMember>;
      
      protected var FData_OrgbaseInfo:TBaseOrganization;
      
      protected var FUIWindow_Confirm:TUIWindowConfirmation;
      
      protected var FOnApplyListCount:Function;
      
      public function TProcessorWindowOrgApplyAndPower(param1:TUIComponent)
      {
         super(param1);
         this.FApplyListElementVect = new Vector.<TUIOrgApplyListElement>(MAX_LISTCOUNT);
         this.FSwitchPowerListElementVect = new Vector.<TUIOrgSwitchPowerListElement>(MAX_LISTCOUNT);
         this.FPopupType = 1;
         this.FPageIndex = 0;
         this.FSelectPageIndex = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIOrgApplyListElement = null;
         var _loc3_:TUIOrgSwitchPowerListElement = null;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_OrgApplyAndPower) as Sprite;
         addChild(this.FMC);
         this.FMC_Title = this.FMC["MC_Title"];
         this.FMC_SwitchPowerList = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_SwitchPowerList];
         this.FMC_ApplyList = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_ApplyList];
         this.FMC_ChangePage = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_ChangePage];
         this.FMC_PageLeft = this.FMC_ChangePage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageLeft];
         this.FMC_PageRight = this.FMC_ChangePage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageRight];
         this.FTF_Page = this.FMC_ChangePage[CONST_ORGANIZATION.RESOURCE_Link_TF_Page];
         this.FBtn_Refuse = new TUIButton();
         this.FBtn_Refuse.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Refuse];
         this.FBtn_Refuse.OnClick = this.OnBtnRefuseClick;
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.LabelPage = this.FTF_Page;
         this.FUIPage.ButtonPrevious.Substrate = this.FMC_PageLeft;
         this.FUIPage.ButtonNext.Substrate = this.FMC_PageRight;
         this.FUIPage.PageSize = MAX_LISTCOUNT;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc1_ = 0;
         while(_loc1_ < MAX_LISTCOUNT)
         {
            _loc2_ = new TUIOrgApplyListElement(this);
            _loc2_.Perform_UIDispatch(this.FMC_ApplyList[CONST_ORGANIZATION.RESOURCE_Link_MC_Element + _loc1_]);
            _loc2_.ClickBtn = this.OnApplyElementClick;
            this.FApplyListElementVect[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_LISTCOUNT)
         {
            _loc3_ = new TUIOrgSwitchPowerListElement(this);
            _loc3_.Perform_UIDispatch(this.FMC_SwitchPowerList[CONST_ORGANIZATION.RESOURCE_Link_MC_Element + _loc1_]);
            _loc3_.ClickOnOk = this.OnSwitchPowerElementClick;
            this.FSwitchPowerListElementVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FMC_ApplyList.visible = true;
         this.FMC_SwitchPowerList.visible = false;
         this.FUIWindow_Confirm = SUtilityOverLayer.UIWindowConfirmation;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,OnClose);
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateList(param1:TBaseOrganization, param2:Vector.<TBaseOrganizationMember>, param3:int) : void
      {
         this.FPopupType = param3;
         this.FData_OrgbaseInfo = param1;
         if(param3 == 1)
         {
            this.FMC_Title.gotoAndStop(1);
            this.FBtn_Refuse.Visible = true;
            this.FMC_ApplyList.visible = true;
            this.FMC_SwitchPowerList.visible = false;
            this.FApplyListData = param2;
            this.UpdataApplayList(param2);
         }
         else if(param3 == 2)
         {
            this.FMC_Title.gotoAndStop(2);
            this.FBtn_Refuse.Visible = false;
            this.FMC_SwitchPowerList.visible = true;
            this.FMC_ApplyList.visible = false;
            this.FSwitchPowerListData = param2;
            this.UpdataSwitchPowerList(param2);
         }
         this.FUIPage.TotalQuantity = param2.length;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdataApplayList(param1:Vector.<TBaseOrganizationMember>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         if(_loc3_ <= 0)
         {
            this.FBtn_Refuse.Enabled = false;
         }
         else
         {
            this.FBtn_Refuse.Enabled = true;
         }
         _loc2_ = 0;
         while(_loc2_ < MAX_LISTCOUNT)
         {
            if(_loc2_ < param1.length)
            {
               this.FApplyListElementVect[_loc2_].MC.visible = true;
               this.FApplyListElementVect[_loc2_].UpDateList(param1[_loc2_]);
            }
            else
            {
               this.FApplyListElementVect[_loc2_].MC.visible = false;
            }
            _loc2_++;
         }
         if(this.FOnApplyListCount != null)
         {
            this.FOnApplyListCount(this,param1.length);
         }
      }
      
      protected function UpdataSwitchPowerList(param1:Vector.<TBaseOrganizationMember>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < MAX_LISTCOUNT)
         {
            if(_loc2_ < param1.length)
            {
               this.FSwitchPowerListElementVect[_loc2_].MC.visible = true;
               this.FSwitchPowerListElementVect[_loc2_].UpDateList(param1[_loc2_]);
            }
            else
            {
               this.FSwitchPowerListElementVect[_loc2_].MC.visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null)
         {
         }
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         if(this.FPopupType == 1)
         {
            _loc5_ = int(this.FApplyListData.length);
            _loc3_ = 0;
            while(_loc3_ < MAX_LISTCOUNT)
            {
               _loc4_ = this.FPageIndex * MAX_LISTCOUNT + _loc3_;
               if(_loc4_ < _loc5_)
               {
                  if(this.FApplyListData[_loc4_] != null)
                  {
                     this.FApplyListElementVect[_loc3_].MC.visible = true;
                     this.FApplyListElementVect[_loc3_].UpDateList(this.FApplyListData[_loc4_]);
                  }
               }
               else
               {
                  this.FApplyListElementVect[_loc3_].MC.visible = false;
               }
               _loc3_++;
            }
         }
         else if(this.FPopupType == 2)
         {
            _loc5_ = int(this.FSwitchPowerListData.length);
            _loc3_ = 0;
            while(_loc3_ < MAX_LISTCOUNT)
            {
               _loc4_ = this.FPageIndex * MAX_LISTCOUNT + _loc3_;
               if(_loc4_ < _loc5_)
               {
                  if(this.FSwitchPowerListData[_loc4_] != null)
                  {
                     this.FSwitchPowerListElementVect[_loc3_].MC.visible = true;
                     this.FSwitchPowerListElementVect[_loc3_].UpDateList(this.FSwitchPowerListData[_loc4_]);
                  }
               }
               else
               {
                  this.FSwitchPowerListElementVect[_loc3_].MC.visible = false;
               }
               _loc3_++;
            }
         }
      }
      
      protected function OnApplyElementClick(param1:Object, param2:int, param3:uint, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.FOnApplyListCount != null)
         {
            this.FOnApplyListCount(this,this.FApplyListData.length);
         }
      }
      
      protected function OnBtnRefuseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_ConfirmApplyJoinGuildReq);
         _loc6_ = _loc5_.Data;
         _loc4_ = int(this.FApplyListData.length);
         _loc6_.writeShort(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_.writeUnsignedInt(this.FApplyListData[_loc3_].Identifier0);
            _loc6_.writeUnsignedInt(this.FApplyListData[_loc3_].Identifier1);
            _loc6_.writeByte(0);
            _loc3_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
         this.FApplyListData.length = 0;
         this.UpdataApplayList(this.FApplyListData);
      }
      
      protected function OnSwitchPowerElementClick(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:Object = null;
         _loc4_ = {
            "high":param2,
            "low":param3
         };
         this.FUIWindow_Confirm.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_55);
         this.FUIWindow_Confirm.Context = _loc4_;
         this.FUIWindow_Confirm.OnOK = this.UIWindowComfirm_OnOk;
         this.FUIWindow_Confirm.Visible = true;
      }
      
      protected function UIWindowComfirm_OnOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = uint(this.FUIWindow_Confirm.Context.high);
         _loc5_ = uint(this.FUIWindow_Confirm.Context.low);
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_SwitchPowerReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc4_);
         _loc3_.writeUnsignedInt(_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function get OnApplyListCount() : Function
      {
         return this.FOnApplyListCount;
      }
      
      public function set OnApplyListCount(param1:Function) : void
      {
         this.FOnApplyListCount = param1;
      }
      
      public function UpDateList(param1:TBaseOrganization, param2:Vector.<TBaseOrganizationMember>, param3:int = 1) : void
      {
         this.UpdateList(param1,param2,param3);
      }
   }
}

