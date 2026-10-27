package Processors.Game.Lobby.Organization
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Logics.Organization.*;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Organization.Part.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowOrganizationMain extends TProcessorLobbyWindow
   {
      
      protected var FMC_Main:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FComponentOrganizationListPart:TComponentOrganizationListPart;
      
      protected var FComponentOrganizationMainPart:TComponentOrganizationMainPart;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FData:TNewOrgData;
      
      protected var FClickMainPartOrgActivityOk:Function;
      
      protected var FClickMainPartOrgActivityUpLv:Function;
      
      protected var FClickCreateOrg:Function;
      
      protected var FClickBtnDonate:Function;
      
      protected var FClickBtnOrgList:Function;
      
      protected var FClickBtnGotoPower:Function;
      
      protected var FClickBtnApplyList:Function;
      
      protected var FClickBtnSwitchPowerList:Function;
      
      protected var FClickBtnGotoSinglePointMap:Function;
      
      protected var FClickBtnGotoGroupPointMap:Function;
      
      protected var FClickBtnQuitOrg:Function;
      
      protected var FOverAward:Function;
      
      protected var FOutAward:Function;
      
      protected var FOnOpenShopExchang:Function;
      
      protected var FOnShowHeroInfo:Function;
      
      protected var FOnShowHeroAchievement:Function;
      
      protected var FOnChatWhisper:Function;
      
      protected var FOnInterpersonalRelationships:Function;
      
      protected var FOverHintUpgradeBtn:Function;
      
      protected var FOutHintUpgradeBtn:Function;
      
      protected var FBaseData:TBaseOrganization;
      
      public function TProcessorWindowOrganizationMain(param1:TUIComponent)
      {
         super(param1);
         this.FComponentOrganizationListPart = new TComponentOrganizationListPart(this);
         this.FComponentOrganizationListPart.ClickCreateOrg = this.OnCreateOrgClick;
         this.FComponentOrganizationMainPart = new TComponentOrganizationMainPart(this);
         this.FComponentOrganizationMainPart.ClickCampActivityOk = this.OnMainPartOrgActivityOkClick;
         this.FComponentOrganizationMainPart.ClickBtnDonate = this.OnOrgDonateClick;
         this.FComponentOrganizationMainPart.ClickBtnOrgList = this.OnOrgListClick;
         this.FComponentOrganizationMainPart.ClickBtnGotoPower = this.OnOrgGotoPowerClick;
         this.FComponentOrganizationMainPart.ClickBtnApplyList = this.OnOrgApplyListClick;
         this.FComponentOrganizationMainPart.ClickBtnSwitchPowerList = this.OnOrgSwitchPowerClick;
         this.FComponentOrganizationMainPart.ClickBtnQuitOrg = this.OnOrgQuitOrgClick;
         this.FComponentOrganizationMainPart.OnAwardOver = this.OnOverAward;
         this.FComponentOrganizationMainPart.OnAwardOut = this.OnOutAward;
         this.FComponentOrganizationMainPart.OnActivityOver = this.OnOverAward;
         this.FComponentOrganizationMainPart.OnActivityOut = this.OnOutAward;
         this.FComponentOrganizationMainPart.OnOrgBagEffectGenerateText = this.PorcessorOnEffectGaenerateText;
         this.FComponentOrganizationMainPart.OnShowHeroInfo = this.ProcessorOnShowHeroInfo;
         this.FComponentOrganizationMainPart.OnShowHeroAchievement = this.ProcessorOnShowHeroAchievement;
         this.FComponentOrganizationMainPart.OnChatWhisper = this.ProcessorOnChatWhisper;
         this.FComponentOrganizationMainPart.OnInterpersonalRelationships = this.ProcessorOnInterpersonalRelationships;
         this.FComponentOrganizationMainPart.OverHintUpgradeBtn = this.OnOverHintUpgradeBtn;
         this.FComponentOrganizationMainPart.OutHintUpgradeBtn = this.OnOutHintUpgradeBtn;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMC_Main = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_OrganizationMain) as Sprite;
         addChild(this.FMC_Main);
         this.FMC_EffectLeft = this.FMC_Main[CONST_ORGANIZATION.RESOURCE_Link_MC_EffectLeft];
         this.FMC_EffectRight = this.FMC_Main[CONST_ORGANIZATION.RESOURCE_Link_MC_EffectRight];
         this.FBtn_Close = this.FMC_Main[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FComponentOrganizationListPart.Perform_UIDispatch(this.FMC_Main[CONST_ORGANIZATION.RESOURCE_Link_MC_OrganizationList]);
         this.FComponentOrganizationMainPart.Perform_UIDispatch(this.FMC_Main[CONST_ORGANIZATION.RESOURCE_Link_MC_OrganizationMain]);
         addChild(this.FComponentOrganizationListPart);
         addChild(this.FComponentOrganizationMainPart);
         this.FComponentOrganizationListPart.Visible = false;
         this.FComponentOrganizationMainPart.Visible = false;
         this.InitWindow();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FComponentOrganizationMainPart.LogicsPerform();
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,OnClose);
         super.ResourcesPerform_UILocations();
      }
      
      protected function OnMainPartOrgActivityOkClick(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FClickMainPartOrgActivityOk == null)
         {
            return;
         }
         this.FClickMainPartOrgActivityOk(param1,param2,param3);
      }
      
      protected function OnMainPartOrgActivityUpLvClick(param1:Object, param2:uint) : void
      {
         if(this.FClickMainPartOrgActivityUpLv == null)
         {
            return;
         }
         this.FClickMainPartOrgActivityUpLv(param1,param2);
      }
      
      protected function OnCreateOrgClick(param1:Object) : void
      {
         if(this.FClickCreateOrg == null)
         {
            return;
         }
         this.FClickCreateOrg(this);
      }
      
      protected function OnOrgDonateClick(param1:Object) : void
      {
         if(this.FClickBtnDonate == null)
         {
            return;
         }
         this.FClickBtnDonate(param1);
      }
      
      protected function OnOrgListClick(param1:Object, param2:Boolean) : void
      {
         if(this.FClickBtnOrgList == null)
         {
            return;
         }
         this.FClickBtnOrgList(param1,param2);
      }
      
      protected function OnOrgGotoPowerClick(param1:Object) : void
      {
         if(this.FClickBtnGotoPower == null)
         {
            return;
         }
         this.FClickBtnGotoPower(param1);
      }
      
      protected function OnOrgApplyListClick(param1:Object, param2:int) : void
      {
         if(this.FClickBtnApplyList == null)
         {
            return;
         }
         this.FClickBtnApplyList(param1,param2);
      }
      
      protected function OnOrgSwitchPowerClick(param1:Object, param2:int) : void
      {
         if(this.FClickBtnSwitchPowerList == null)
         {
            return;
         }
         this.FClickBtnSwitchPowerList(param1,param2);
      }
      
      protected function OnOrgQuitOrgClick(param1:Object) : void
      {
         if(this.FClickBtnQuitOrg == null)
         {
            return;
         }
         this.FClickBtnQuitOrg(param1);
      }
      
      protected function OnOverAward(param1:Object, param2:THint) : void
      {
         this.FOverAward(param1,param2);
      }
      
      protected function OnOutAward(param1:Object, param2:THint) : void
      {
         this.FOutAward(param1,param2);
      }
      
      protected function ProcessorOnShowHeroInfo(param1:Object, param2:uint, param3:uint) : void
      {
         this.FOnShowHeroInfo(param1,param2,param3);
      }
      
      protected function ProcessorOnShowHeroAchievement(param1:Object, param2:uint, param3:uint) : void
      {
         this.FOnShowHeroAchievement(param1,param2,param3);
      }
      
      protected function ProcessorOnChatWhisper(param1:Object, param2:Object) : void
      {
         this.FOnChatWhisper(param1,param2);
      }
      
      protected function ProcessorOnInterpersonalRelationships(param1:Object, param2:uint, param3:Object) : void
      {
         this.FOnInterpersonalRelationships(param1,param2,param3);
      }
      
      protected function OnOverHintUpgradeBtn(param1:Object, param2:THint) : void
      {
         if(this.FOverHintUpgradeBtn != null)
         {
            this.FOverHintUpgradeBtn(param1,param2);
         }
      }
      
      protected function OnOutHintUpgradeBtn(param1:Object, param2:THint) : void
      {
         if(this.FOutHintUpgradeBtn != null)
         {
            this.FOutHintUpgradeBtn(param1,param2);
         }
      }
      
      protected function PorcessorOnEffectGaenerateText(param1:Object, param2:String) : void
      {
         if(FOnEffectText != null)
         {
            FOnEffectText(param1,param2);
         }
      }
      
      public function get ClickMainPartOrgActivityOk() : Function
      {
         return this.FClickMainPartOrgActivityOk;
      }
      
      public function set ClickMainPartOrgActivityOk(param1:Function) : void
      {
         this.FClickMainPartOrgActivityOk = param1;
      }
      
      public function get ClickMainPartOrgActivityUpLv() : Function
      {
         return this.FClickMainPartOrgActivityUpLv;
      }
      
      public function set ClickMainPartOrgActivityUpLv(param1:Function) : void
      {
         this.FClickMainPartOrgActivityUpLv = param1;
      }
      
      public function get ClickCreateOrg() : Function
      {
         return this.FClickCreateOrg;
      }
      
      public function set ClickCreateOrg(param1:Function) : void
      {
         this.FClickCreateOrg = param1;
      }
      
      public function get ClickBtnDonate() : Function
      {
         return this.FClickBtnDonate;
      }
      
      public function set ClickBtnDonate(param1:Function) : void
      {
         this.FClickBtnDonate = param1;
      }
      
      public function get ClickBtnOrgList() : Function
      {
         return this.FClickBtnOrgList;
      }
      
      public function set ClickBtnOrgList(param1:Function) : void
      {
         this.FClickBtnOrgList = param1;
      }
      
      public function get ClickBtnGotoPower() : Function
      {
         return this.FClickBtnGotoPower;
      }
      
      public function set ClickBtnGotoPower(param1:Function) : void
      {
         this.FClickBtnGotoPower = param1;
      }
      
      public function get ClickBtnApplyList() : Function
      {
         return this.FClickBtnApplyList;
      }
      
      public function set ClickBtnApplyList(param1:Function) : void
      {
         this.FClickBtnApplyList = param1;
      }
      
      public function get ClickBtnSwitchPowerList() : Function
      {
         return this.FClickBtnSwitchPowerList;
      }
      
      public function set ClickBtnSwitchPowerList(param1:Function) : void
      {
         this.FClickBtnSwitchPowerList = param1;
      }
      
      public function get ClickBtnQuitOrg() : Function
      {
         return this.FClickBtnQuitOrg;
      }
      
      public function set ClickBtnQuitOrg(param1:Function) : void
      {
         this.FClickBtnQuitOrg = param1;
      }
      
      public function get OverAward() : Function
      {
         return this.FOverAward;
      }
      
      public function set OverAward(param1:Function) : void
      {
         this.FOverAward = param1;
      }
      
      public function get OutAward() : Function
      {
         return this.FOutAward;
      }
      
      public function set OutAward(param1:Function) : void
      {
         this.FOutAward = param1;
      }
      
      public function get OnShowHeroInfo() : Function
      {
         return this.FOnShowHeroInfo;
      }
      
      public function set OnShowHeroInfo(param1:Function) : void
      {
         this.FOnShowHeroInfo = param1;
      }
      
      public function get OnChatWhisper() : Function
      {
         return this.FOnChatWhisper;
      }
      
      public function set OnChatWhisper(param1:Function) : void
      {
         this.FOnChatWhisper = param1;
      }
      
      public function get OnInterpersonalRelationships() : Function
      {
         return this.FOnInterpersonalRelationships;
      }
      
      public function set OnInterpersonalRelationships(param1:Function) : void
      {
         this.FOnInterpersonalRelationships = param1;
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
      
      public function set OnSelectSlotOnMove(param1:Function) : void
      {
         this.FComponentOrganizationMainPart.SelectSlotOnMove = param1;
      }
      
      public function set OnSelectSlotOnOut(param1:Function) : void
      {
         this.FComponentOrganizationMainPart.SelectSlotOnOut = param1;
      }
      
      public function set OnShowHeroAchievement(param1:Function) : void
      {
         this.FOnShowHeroAchievement = param1;
      }
      
      public function set Data(param1:TNewOrgData) : void
      {
         this.FData = param1;
         this.FComponentOrganizationMainPart.Data = param1;
      }
      
      public function set ClickBtnGotoSinglePointMap(param1:Function) : void
      {
         this.FClickBtnGotoSinglePointMap = param1;
         this.FComponentOrganizationMainPart.ClickBtnGotoSinglePointMap = param1;
      }
      
      public function set ClickBtnGotoGroupPointMap(param1:Function) : void
      {
         this.FClickBtnGotoGroupPointMap = param1;
         this.FComponentOrganizationMainPart.ClickBtnGotoGroupPointMap = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
         this.FComponentOrganizationMainPart.UnstreamizerOrganizationNew = param1;
      }
      
      public function set BaseData(param1:TBaseOrganization) : void
      {
         this.FBaseData = param1;
         this.FComponentOrganizationMainPart.OrgBaseInfo = param1;
      }
      
      public function set OnOpenShopExchang(param1:Function) : void
      {
         this.FOnOpenShopExchang = param1;
         this.FComponentOrganizationMainPart.OnOpenShopExchang = param1;
      }
      
      public function get CurrentMallType() : int
      {
         return this.FComponentOrganizationMainPart.CurrentMallType;
      }
      
      public function UpDataPartData(param1:TBaseOrganization, param2:Vector.<TBaseOrganiztionList>, param3:uint, param4:Boolean = true) : void
      {
         if(param1.OrgId > 0 && param4)
         {
            this.FComponentOrganizationMainPart.Visible = true;
            this.FComponentOrganizationListPart.Visible = false;
            this.FComponentOrganizationListPart.Unmount();
            this.FComponentOrganizationMainPart.UpDataUI(param1,param3);
         }
         else
         {
            this.FComponentOrganizationMainPart.Visible = false;
            this.FComponentOrganizationListPart.Visible = true;
            this.FComponentOrganizationListPart.UpDateOrgList(this,param2,param1.OrgId > 0 ? true : false);
         }
      }
      
      public function UpDataUI_OrgPart(param1:TBaseOrganization, param2:uint) : void
      {
         this.FComponentOrganizationMainPart.UpDataUI(param1,param2);
      }
      
      public function UpData_OrgBag(param1:TInventories, param2:Vector.<uint>, param3:Vector.<TBaseOrganizationMember>, param4:TBaseOrganization) : void
      {
         this.FComponentOrganizationMainPart.UpData_OrgBag(param1,param2,param3,param4);
         this.FComponentOrganizationMainPart.UpDateUI_OrgBag();
         this.FComponentOrganizationMainPart.UpDateUI_OrgMemberList();
      }
      
      public function UpData_OrgMember(param1:Vector.<TBaseOrganizationMember>) : void
      {
         this.FComponentOrganizationMainPart.UpData_Members(param1);
      }
      
      public function UpDateUI_OrgMember() : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_OrgMemberList();
      }
      
      public function UpDateUI_OrgActivityUpgrade(param1:uint) : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_OrgActivityUpgrade(param1);
      }
      
      public function UpDateUI_OrgCamp() : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_OrgCamp();
      }
      
      public function UpDateUI_OrgLog(param1:Vector.<Object>) : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_OrgLog(param1);
      }
      
      public function UpDateUI_OrgMemberCount(param1:uint) : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_OrgMemberCount(param1);
      }
      
      public function UpDataUI_OrgActivityBtnStatus(param1:uint, param2:uint) : void
      {
         this.FComponentOrganizationMainPart.UpDataUI_OrgActivityBtnStatus(param1,param2);
      }
      
      public function UpDateUI_OrgApplyListCount(param1:uint) : void
      {
         this.FComponentOrganizationMainPart.UpDateUI_ApplyListCount(param1);
      }
      
      public function Unmount() : void
      {
         this.FComponentOrganizationMainPart.Unmount();
      }
      
      public function InitWindow() : void
      {
         this.FComponentOrganizationMainPart.InitWindow();
      }
      
      public function OpenSingleTab() : void
      {
         this.FComponentOrganizationMainPart.OpenSingleTab();
      }
      
      public function OpenGroupTab() : void
      {
         this.FComponentOrganizationMainPart.OpenGroupTab();
      }
      
      public function OpenMallTab() : void
      {
         this.FComponentOrganizationMainPart.OpenMallTab();
      }
      
      public function UpdateActive() : void
      {
         this.FComponentOrganizationMainPart.UpdateActive();
      }
      
      public function StartCopyUpdateUI() : void
      {
         this.FComponentOrganizationMainPart.StartCopyUpdateUI();
      }
      
      public function ResetCopyUpdateUI() : void
      {
         this.FComponentOrganizationMainPart.ResetCopyUpdateUI();
      }
      
      public function MallUpdate() : void
      {
         this.FComponentOrganizationMainPart.MallUpdate();
      }
      
      public function UpdateShopCurrentPage() : void
      {
         this.FComponentOrganizationMainPart.UpdateShopCurrentPage();
      }
      
      public function set GetMountInfo(param1:Function) : void
      {
         this.FComponentOrganizationMainPart.GetMountInfo = param1;
      }
      
      public function set SetMountInfo(param1:Function) : void
      {
         this.FComponentOrganizationMainPart.SetMountInfo = param1;
      }
   }
}

