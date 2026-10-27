package Processors.Game.Lobby.Organization.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIOrgActivitySlot extends TUIComponent
   {
      
      protected static const TYPE_ORGACTIVITY_CAMP:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_CAMP;
      
      protected static const TYPE_ORGACTIVITY_MUYEGUARD:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEGUARD;
      
      protected static const TYPE_ORGACTIVITY_PETBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_PETBATTLE;
      
      protected static const TYPE_ORGACTIVITY_MUYEBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE;
      
      protected static const STATUS_ORGACTIVITY_NotOpen:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_NotOpen;
      
      protected static const STATUS_ORGACTIVITY_SignUp:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_SignUp;
      
      protected static const STATUS_ORGACTIVITY_Battle:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Battle;
      
      protected static const STATUS_ORGACTIVITY_End:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_End;
      
      protected static const STATUS_ORGACTIVITY_Added:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Added;
      
      protected static const STATUS_ORGACTIVITY_EndJoin:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_EndJoin;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FBtn_UpLv:TUIButton;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FTF_CurLv:TextField;
      
      protected var FTF_Prompt:TextField;
      
      protected var FBtn_SelectMc:Sprite;
      
      protected var FTF_Caption:TextField;
      
      protected var FMC_Pic:MovieClip;
      
      protected var FTypeOrgActivity:uint;
      
      protected var FStatusOrgActivity:uint;
      
      protected var FData_OrgBaseInfo:TBaseOrganization;
      
      protected var FOrgActivityLevel:uint;
      
      protected var FOrgPlayerPower:uint;
      
      protected var FIsInitialization:Boolean;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FActivityBtnOkCaption:Vector.<String>;
      
      protected var FMC:MovieClip;
      
      protected var FClickActivityOk:Function;
      
      protected var FClickUpLevel:Function;
      
      protected var FClickSelectMc:Function;
      
      protected var FOnMCOver:Function;
      
      protected var FOnMCOut:Function;
      
      public function TUIOrgActivitySlot(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Ok];
         this.FBtn_Ok.OnClick = this.OnOkClick;
         this.FTF_Caption = this.FBtn_Ok.Substrate["TF_Caption"];
         this.FBtn_UpLv = new TUIButton();
         this.FBtn_UpLv.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_UpLv];
         this.FBtn_UpLv.OnClick = this.OnUpLvClick;
         this.FMC_Bg = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_Bg];
         this.FTF_CurLv = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_CurLv];
         this.FTF_Prompt = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Prompt];
         this.FBtn_SelectMc = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_SelectMc];
         this.FMC_Bg.gotoAndStop(1);
         this.FMC_Pic = this.FMC["MC_ActivityPic"];
         this.FBtn_SelectMc.addEventListener(MouseEvent.CLICK,this.OnClickSelectMc);
         this.FBtn_SelectMc.addEventListener(MouseEvent.MOUSE_MOVE,this.OnRollOverSelectMc);
         this.FBtn_SelectMc.addEventListener(MouseEvent.MOUSE_OUT,this.OnRollOutSelectMc);
         this.FActivityBtnOkCaption = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_01);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:Vector.<uint> = null;
         this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60230002) as TConfigValue;
         this.FTF_CurLv.text = "Lv." + this.FOrgActivityLevel.toString();
         this.FMC_Pic.gotoAndStop(this.FTypeOrgActivity);
         if(this.FTypeOrgActivity == TYPE_ORGACTIVITY_CAMP)
         {
            this.FTF_Prompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_25);
         }
         else if(this.FTypeOrgActivity == TYPE_ORGACTIVITY_MUYEGUARD)
         {
            _loc1_ = this.FConfigValue.Value as Vector.<uint>;
            this.FTF_Prompt.text = this.ExpandTwoCharcter(_loc1_[0]) + ":" + this.ExpandTwoCharcter(_loc1_[1]) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_26);
         }
         if(this.FOrgPlayerPower == 2)
         {
            this.FBtn_UpLv.Substrate.visible = true;
         }
         else
         {
            this.FBtn_UpLv.Substrate.visible = false;
         }
      }
      
      protected function ExpandTwoCharcter(param1:int) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return param1 + "";
      }
      
      protected function UpdateUI_BtnOk() : void
      {
         var _loc1_:Vector.<uint> = null;
         this.FBtn_Ok.Enabled = false;
         if(this.FTypeOrgActivity == TYPE_ORGACTIVITY_CAMP)
         {
            this.FTF_Caption.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_26);
         }
         else if(this.FTypeOrgActivity == TYPE_ORGACTIVITY_MUYEBATTLE)
         {
            if(this.FStatusOrgActivity == STATUS_ORGACTIVITY_NotOpen || this.FStatusOrgActivity == STATUS_ORGACTIVITY_End)
            {
               this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60220002) as TConfigValue;
               _loc1_ = this.FConfigValue.Value as Vector.<uint>;
               this.FTF_Prompt.text = this.ExpandTwoCharcter(_loc1_[0]) + ":" + this.ExpandTwoCharcter(_loc1_[1]) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_27);
            }
            else
            {
               this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60220004) as TConfigValue;
               _loc1_ = this.FConfigValue.Value as Vector.<uint>;
               this.FTF_Prompt.text = this.ExpandTwoCharcter(_loc1_[0]) + ":" + this.ExpandTwoCharcter(_loc1_[1]) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_28);
            }
         }
         if(this.FTypeOrgActivity == TYPE_ORGACTIVITY_CAMP)
         {
            this.FBtn_Ok.Enabled = true;
         }
         else
         {
            this.FTF_Caption.text = this.FActivityBtnOkCaption[this.FStatusOrgActivity];
            if(this.FStatusOrgActivity != STATUS_ORGACTIVITY_Added && this.FStatusOrgActivity != STATUS_ORGACTIVITY_EndJoin)
            {
               this.FBtn_Ok.Enabled = true;
            }
         }
      }
      
      protected function OnOkClick(param1:Object, param2:MouseEvent) : void
      {
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FClickActivityOk == null)
         {
            return;
         }
         this.FClickActivityOk(this,this.FTypeOrgActivity,this.FStatusOrgActivity);
      }
      
      protected function OnUpLvClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickUpLevel == null)
         {
            return;
         }
         this.FClickUpLevel(this,this.FTypeOrgActivity);
      }
      
      protected function OnClickSelectMc(param1:MouseEvent) : void
      {
         if(this.FClickSelectMc == null)
         {
            return;
         }
         this.FClickSelectMc(this,this.FTypeOrgActivity);
      }
      
      protected function OnRollOverSelectMc(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(2);
         if(this.FOnMCOver != null)
         {
            this.FOnMCOver(this,this.FTypeOrgActivity);
         }
      }
      
      protected function OnRollOutSelectMc(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(1);
         if(this.FOnMCOut != null)
         {
            this.FOnMCOut(this);
         }
      }
      
      public function get ClickActivityOk() : Function
      {
         return this.FClickActivityOk;
      }
      
      public function set ClickActivityOk(param1:Function) : void
      {
         this.FClickActivityOk = param1;
      }
      
      public function get ClickUpLevel() : Function
      {
         return this.FClickUpLevel;
      }
      
      public function set ClickUpLevel(param1:Function) : void
      {
         this.FClickUpLevel = param1;
      }
      
      public function get ClickSelectMc() : Function
      {
         return this.FClickSelectMc;
      }
      
      public function set ClickSelectMc(param1:Function) : void
      {
         this.FClickSelectMc = param1;
      }
      
      public function get OnMCOver() : Function
      {
         return this.FOnMCOver;
      }
      
      public function set OnMCOver(param1:Function) : void
      {
         this.FOnMCOver = param1;
      }
      
      public function get OnMCOut() : Function
      {
         return this.FOnMCOut;
      }
      
      public function set OnMCOut(param1:Function) : void
      {
         this.FOnMCOut = param1;
      }
      
      public function get MC() : MovieClip
      {
         return this.FMC;
      }
      
      public function set MC(param1:MovieClip) : void
      {
         this.FMC = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpDateUI(param1:TBaseOrganization, param2:uint) : void
      {
         this.FData_OrgBaseInfo = param1;
         this.FTypeOrgActivity = param2;
         this.FOrgActivityLevel = this.FData_OrgBaseInfo.GetOrgActivityLevelByType(this.FTypeOrgActivity);
         this.FOrgPlayerPower = this.FData_OrgBaseInfo.OrgPower;
         this.UpdateUI();
      }
      
      public function UpDataUI_BtnOk(param1:uint) : void
      {
         this.FStatusOrgActivity = param1;
         this.UpdateUI_BtnOk();
      }
      
      public function Clear() : void
      {
         this.FTypeOrgActivity = 0;
         this.FStatusOrgActivity = 0;
         this.FOrgActivityLevel = 0;
         this.FTF_Caption.text = "";
         this.FTF_CurLv.text = "";
         this.FTF_Prompt.text = "";
         this.FBtn_UpLv.Substrate.visible = false;
         this.FBtn_Ok.Enabled = false;
      }
   }
}

