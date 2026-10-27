package Processors.Game.Lobby.Organization.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TUIOrgActivityUpgrade extends TUIComponent
   {
      
      protected static const SIZE_Window_Width:uint = 330;
      
      protected static const SIZE_Window_Height:uint = 274;
      
      protected var FMC:MovieClip;
      
      protected var FTF_CurOrgLevel:TextField;
      
      protected var FTF_CurOrgMoney:TextField;
      
      protected var FTF_UpLvNeedMoney:TextField;
      
      protected var FTF_CurPrompt:TextField;
      
      protected var FTF_CurBuff:TextField;
      
      protected var FTF_NextPrompt:TextField;
      
      protected var FTF_NextBuff:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FBtn_Cancel:TUIButton;
      
      protected var FIsInitialization:Boolean;
      
      protected var FData_OrgBaseInfo:TBaseOrganization;
      
      protected var FData_Type:uint;
      
      protected var FUpgradeNeedMoney:uint;
      
      protected var FOrgBaseBin:TBins;
      
      protected var FOrgMaxLevel:uint;
      
      protected var FOrgActivityLevel:uint;
      
      protected var FHint:THint;
      
      protected var FClickBtnOk:Function;
      
      protected var FClickBtnCancel:Function;
      
      protected var FOverHintUpgradeBtn:Function;
      
      protected var FOutHintUpgradeBtn:Function;
      
      public function TUIOrgActivityUpgrade(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         addChild(this.FMC);
         this.FMC.x = (CONST_COMMON.STAGE_Width - SIZE_Window_Width) / 2 - 140;
         this.FMC.y = (CONST_COMMON.STAGE_Height - SIZE_Window_Height) / 2 - 50;
         this.FTF_CurOrgLevel = this.FMC["TF_CurOrgLevel"];
         this.FTF_CurOrgMoney = this.FMC["TF_CurOrgMoney"];
         this.FTF_UpLvNeedMoney = this.FMC["TF_UpLvNeedMoney"];
         this.FTF_CurPrompt = this.FMC["TF_CurPrompt"];
         this.FTF_CurBuff = this.FMC["TF_CurBuff"];
         this.FTF_NextPrompt = this.FMC["TF_NextPrompt"];
         this.FTF_NextBuff = this.FMC["TF_NextBuff"];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC["Btn_Ok"];
         this.FBtn_Ok.OnClick = this.OnBtnOkClick;
         this.FBtn_Ok.OnMove = this.OnBtnOkMove;
         this.FBtn_Ok.OnOut = this.OnBtnOkOut;
         this.FBtn_Cancel = new TUIButton();
         this.FBtn_Cancel.Substrate = this.FMC["Btn_Cancel"];
         this.FBtn_Cancel.OnClick = this.OnBtnCancelClick;
         this.FOrgBaseBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         this.FOrgMaxLevel = this.FOrgBaseBin.Count;
         this.FHint = new THint();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:TOrganizationBase = null;
         var _loc2_:TOrganizationBase = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc1_ = this.FOrgBaseBin.GetDatebaseByIndex(this.FOrgActivityLevel - 1) as TOrganizationBase;
         if(this.FOrgActivityLevel < this.FOrgMaxLevel)
         {
            _loc2_ = this.FOrgBaseBin.GetDatebaseByIndex(this.FOrgActivityLevel) as TOrganizationBase;
         }
         else
         {
            _loc2_ = _loc1_;
         }
         if(this.FData_OrgBaseInfo.OrgId > 0)
         {
            this.FTF_CurOrgLevel.text = "Lv." + this.FData_OrgBaseInfo.OrgLevel;
            this.FTF_CurOrgMoney.text = String(this.FData_OrgBaseInfo.OrgMoney);
            switch(this.FData_Type)
            {
               case 1:
                  this.FTF_UpLvNeedMoney.text = String(_loc2_.CampUpgradeMoney);
                  this.FTF_CurPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_29);
                  this.FTF_CurBuff.text = String(_loc1_.OrgMaxNumber);
                  this.FTF_NextPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_30);
                  this.FTF_NextBuff.text = String(_loc2_.OrgMaxNumber);
                  break;
               case 2:
                  this.FTF_UpLvNeedMoney.text = String(_loc2_.MuyeguardUpgradeMoney);
                  this.FTF_CurPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_31);
                  this.FTF_CurBuff.text = _loc1_.MuyeguardUpgradeAddition / 10 + "%";
                  this.FTF_NextPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_32);
                  this.FTF_NextBuff.text = _loc2_.MuyeguardUpgradeAddition / 10 + "%";
                  break;
               case 3:
                  break;
               case 4:
                  this.FTF_UpLvNeedMoney.text = String(_loc2_.MuyebattleUpgradeMoney);
                  this.FTF_CurPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_33);
                  this.FTF_CurBuff.text = _loc1_.MuyebattleUpgradeAddition / 10 + "%";
                  this.FTF_NextPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_34);
                  this.FTF_NextBuff.text = _loc2_.MuyebattleUpgradeAddition / 10 + "%";
            }
            _loc3_ = uint(this.FTF_UpLvNeedMoney.text);
            _loc4_ = int(this.FTF_CurOrgMoney.text);
            if(this.FData_Type == 1)
            {
               if(_loc4_ >= _loc3_)
               {
                  this.FBtn_Ok.Enabled = true;
               }
               else
               {
                  this.FBtn_Ok.Enabled = false;
               }
            }
            else if(_loc4_ >= _loc3_ && this.FData_OrgBaseInfo.OrgLevel > this.FData_OrgBaseInfo.GetOrgActivityLevelByType(this.FData_Type))
            {
               this.FBtn_Ok.Enabled = true;
            }
            else
            {
               this.FBtn_Ok.Enabled = false;
            }
         }
         else
         {
            this.FTF_CurOrgLevel.text = "";
            this.FTF_CurOrgMoney.text = "";
            this.FTF_UpLvNeedMoney.text = "";
            this.FTF_CurPrompt.text = "";
            this.FTF_CurBuff.text = "";
            this.FTF_NextPrompt.text = "";
            this.FTF_NextBuff.text = "";
         }
      }
      
      protected function OnBtnCancelClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnCancel == null)
         {
            return;
         }
         this.FClickBtnCancel(this);
      }
      
      protected function OnBtnOkClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(param2.currentTarget.buttonMode == false)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_UpGradeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FData_Type);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnBtnOkMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         if(Boolean(param2.currentTarget) && Boolean(param2.currentTarget.buttonMode))
         {
            return;
         }
         _loc4_ = uint(this.FTF_UpLvNeedMoney.text);
         _loc5_ = int(this.FTF_CurOrgMoney.text);
         _loc6_ = this.FData_OrgBaseInfo.GetOrgActivityLevelByType(this.FData_Type);
         if(_loc4_ > _loc5_)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_35);
         }
         else if(this.FData_OrgBaseInfo.OrgLevel <= _loc6_ && this.FData_Type != 1)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_36) + (_loc6_ + 1);
         }
         this.FHint.Caption = _loc3_;
         if(this.FOverHintUpgradeBtn != null)
         {
            this.FOverHintUpgradeBtn(this,this.FHint);
         }
      }
      
      protected function OnBtnOkOut(param1:Object, param2:MouseEvent) : void
      {
         if(Boolean(param2.currentTarget) && Boolean(param2.currentTarget.buttonMode))
         {
            return;
         }
         if(this.FOutHintUpgradeBtn != null)
         {
            this.FOutHintUpgradeBtn(this,this.FHint);
         }
      }
      
      public function get ClickBtnOk() : Function
      {
         return this.FClickBtnOk;
      }
      
      public function set ClickBtnOk(param1:Function) : void
      {
         this.FClickBtnOk = param1;
      }
      
      public function get ClickBtnCancel() : Function
      {
         return this.FClickBtnCancel;
      }
      
      public function set ClickBtnCancel(param1:Function) : void
      {
         this.FClickBtnCancel = param1;
      }
      
      public function get OverHintUpgradeBtn() : Function
      {
         return this.FOverHintUpgradeBtn;
      }
      
      public function set OverHintUpgradeBtn(param1:Function) : void
      {
         this.FOverHintUpgradeBtn = param1;
      }
      
      public function get OutHintUpgradeBtn() : Function
      {
         return this.FOutHintUpgradeBtn;
      }
      
      public function set OutHintUpgradeBtn(param1:Function) : void
      {
         this.FOutHintUpgradeBtn = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:int, param2:TBaseOrganization) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         this.FData_Type = param1;
         this.FData_OrgBaseInfo = param2;
         _loc3_ = 0;
         while(_loc3_ < this.FData_OrgBaseInfo.OrgCampData.length)
         {
            _loc4_ = this.FData_OrgBaseInfo.OrgCampData[_loc3_];
            if(_loc4_.type == this.FData_Type)
            {
               this.FOrgActivityLevel = _loc4_.level;
               break;
            }
            _loc3_++;
         }
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
   }
}

