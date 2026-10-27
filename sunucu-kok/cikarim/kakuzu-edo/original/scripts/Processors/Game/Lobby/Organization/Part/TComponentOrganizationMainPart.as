package Processors.Game.Lobby.Organization.Part
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.SensitiveWord.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Organization.*;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Organization.Component.*;
   import Processors.Game.Lobby.Organization.Part.SecondPart.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Processors.Game.Windows.Input.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TComponentOrganizationMainPart extends TUIComponent
   {
      
      protected static const MAX_TABCOUNT:uint = 7;
      
      public static const STAGE_Width:Number = CONST_ORGANIZATION.STAGE_Width;
      
      public static const STAGE_Height:Number = CONST_ORGANIZATION.STAGE_Height;
      
      protected static const TYPE_ORGACTIVITY_CAMP:uint = 1;
      
      protected static const TYPE_ORGACTIVITY_MUYEGUARD:uint = 2;
      
      protected static const TYPE_ORGACTIVITY_PETBATTLE:uint = 3;
      
      protected static const TYPE_ORGACTIVITY_MUYEBATTLE:uint = 4;
      
      protected var FIsInitialization:Boolean;
      
      protected var FMC:MovieClip;
      
      protected var FMC_OrgCamp:TCompOrgCamp;
      
      protected var FMC_OrgBags:TCompOrgBags;
      
      protected var FMC_OrgMemberList:TCompOrgMembers;
      
      protected var FMC_OrgLogs:TCompOrgLogs;
      
      protected var FMC_OrgGroupCopy:TCompOrgGroupCopy;
      
      protected var FMC_OrgSingleCopy:TCompOrgSingleCopy;
      
      protected var FMC_OrgShop:TCompOrgShop;
      
      protected var FUIWindowInputString:TUIWindowInputString;
      
      protected var FMC_OrgActivityInfo:MovieClip;
      
      protected var FMC_OrgActivityPic:MovieClip;
      
      protected var FMC_Award_0:MovieClip;
      
      protected var FMC_Award_1:MovieClip;
      
      protected var FMC_OrgActivityUpgrade:TUIOrgActivityUpgrade;
      
      protected var FTF_OrgName:TextField;
      
      protected var FTF_LeaderName:TextField;
      
      protected var FTF_OrgLevel:TextField;
      
      protected var FTF_OrgMoney:TextField;
      
      protected var FTF_OrgMember:TextField;
      
      protected var FTF_OrgContribution:TextField;
      
      protected var FTF_OrgExploit:TextField;
      
      protected var FTF_OrgNotice:TextField;
      
      protected var FTF_OrgActivityInfo:TextField;
      
      protected var FTF_OrgQuitBtnCaption:TextField;
      
      protected var FTF_MyActive:TextField;
      
      protected var FTF_GroupActive:TextField;
      
      protected var FMC_Farmliy:MovieClip;
      
      protected var FMC_ApplyCount:Sprite;
      
      protected var FBtn_Donate:TUIButton;
      
      protected var FBtn_AdjustNotice:TUIButton;
      
      protected var FBtn_GotoOrgList:TUIButton;
      
      protected var FBtn_GotoPower:TUIButton;
      
      protected var FBtn_ApplyList:TUIButton;
      
      protected var FBtn_SwitchPower:TUIButton;
      
      protected var FBtn_QuitOrg:TUIButton;
      
      protected var FTab_Org:TUITab;
      
      protected var FBtn_TabCamp:MovieClip;
      
      protected var FBtn_TabMember:MovieClip;
      
      protected var FBtn_TabLog:MovieClip;
      
      protected var FBtn_TabOrgBag:MovieClip;
      
      protected var FBtn_GroupCopy:MovieClip;
      
      protected var FBtn_SingleCopy:MovieClip;
      
      protected var FBtn_Shop:MovieClip;
      
      protected var FChangeTabIndex:int;
      
      protected var FTabVect:Vector.<MovieClip>;
      
      protected var FOrgBaseInfo:TBaseOrganization;
      
      protected var FOrgActivityType:uint;
      
      protected var FOrgApplyListCount:uint;
      
      protected var FHint:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FData:TNewOrgData;
      
      protected var FClickCampActivityOk:Function;
      
      protected var FClickBtnDonate:Function;
      
      protected var FClickBtnOrgList:Function;
      
      protected var FClickBtnGotoPower:Function;
      
      protected var FClickBtnApplyList:Function;
      
      protected var FClickBtnSwitchPowerList:Function;
      
      protected var FClickBtnQuitOrg:Function;
      
      protected var FClickBtnGotoSinglePointMap:Function;
      
      protected var FClickBtnGotoGroupPointMap:Function;
      
      protected var FDataMembersVect:Vector.<TBaseOrganizationMember>;
      
      protected var FOnAwardOver:Function;
      
      protected var FOnAwardOut:Function;
      
      protected var FOnActivityOver:Function;
      
      protected var FOnActivityOut:Function;
      
      protected var FOnOrgBagEffectGenerateText:Function;
      
      protected var FOnShowHeroInfo:Function;
      
      protected var FOnShowHeroAchievement:Function;
      
      protected var FOnChatWhisper:Function;
      
      protected var FOnInterpersonalRelationships:Function;
      
      protected var FOverHintUpgradeBtn:Function;
      
      protected var FOutHintUpgradeBtn:Function;
      
      protected var FOnOpenShopExchang:Function;
      
      protected var FGetMountInfo:Function;
      
      protected var FSetMountInfo:Function;
      
      public function TComponentOrganizationMainPart(param1:TUIComponent)
      {
         super(param1);
         this.FMC_OrgCamp = new TCompOrgCamp(this);
         this.FMC_OrgMemberList = new TCompOrgMembers(this);
         this.FMC_OrgLogs = new TCompOrgLogs(this);
         this.FMC_OrgBags = new TCompOrgBags(this);
         this.FMC_OrgGroupCopy = new TCompOrgGroupCopy(this);
         this.FMC_OrgSingleCopy = new TCompOrgSingleCopy(this);
         this.FMC_OrgShop = new TCompOrgShop(this);
         this.FMC_OrgGroupCopy.MainValueUpdate = this.UpdateActive;
         this.FMC_OrgActivityUpgrade = new TUIOrgActivityUpgrade(this);
         this.FChangeTabIndex = 0;
         this.FTabVect = new Vector.<MovieClip>();
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FMC = param1;
         addChild(this.FMC);
         setChildIndex(this.FMC,0);
         this.FMC_OrgCamp.Perform_UIDispatch(this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_Camp]);
         this.FMC_OrgCamp.x = 10;
         this.FMC_OrgCamp.y = 78;
         this.FMC_OrgCamp.ClickActivityOk = this.MCCampOnActivityOkClick;
         this.FMC_OrgCamp.ClickActivityUpLv = this.MCCampOnActivityUpLvClick;
         this.FMC_OrgCamp.OnActivityOver = this.OnActivityMouseOver;
         this.FMC_OrgCamp.OnActivityOut = this.OnActivityMouseOut;
         setChildIndex(this.FMC_OrgCamp,0);
         this.FMC_OrgMemberList.Perform_UIDispatch(this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_OrgMemberList]);
         this.FMC_OrgMemberList.x = 10;
         this.FMC_OrgMemberList.y = 78;
         this.FMC_OrgMemberList.EffectText = this.FOnOrgBagEffectGenerateText;
         this.FMC_OrgMemberList.OnChatWhisper = this.ProcessorOnChatWhisper;
         this.FMC_OrgMemberList.OnShowHeroInfo = this.ProcessorOnShowHeroInfo;
         this.FMC_OrgMemberList.OnShowHeroAchievement = this.ProcessorOnShowHeroAchievement;
         this.FMC_OrgMemberList.OnInterpersonalRelationships = this.ProcessorOnInterpersonalRelationships;
         setChildIndex(this.FMC_OrgMemberList,0);
         this.FMC_OrgLogs.Perform_UIDispatch(this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_OrgLogs]);
         this.FMC_OrgLogs.x = 10;
         this.FMC_OrgLogs.y = 78;
         setChildIndex(this.FMC_OrgLogs,0);
         this.FMC_OrgBags.Perform_UIDispatch(this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_OrgBags]);
         this.FMC_OrgBags.EffectGenerateText = this.OrgBagEffectGenerateText;
         this.FMC_OrgBags.x = 10;
         this.FMC_OrgBags.y = 78;
         setChildIndex(this.FMC_OrgBags,0);
         this.FMC_OrgGroupCopy.x = 10;
         this.FMC_OrgGroupCopy.y = 78;
         setChildIndex(this.FMC_OrgGroupCopy,0);
         this.FMC_OrgSingleCopy.x = 10;
         this.FMC_OrgSingleCopy.y = 78;
         setChildIndex(this.FMC_OrgSingleCopy,0);
         this.FMC_OrgShop.x = 10;
         this.FMC_OrgShop.y = 78;
         setChildIndex(this.FMC_OrgShop,0);
         this.HideTabWinAll();
         this.FMC_OrgCamp.Visible = true;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_OrgUpLevel) as MovieClip;
         this.FMC_OrgActivityUpgrade.Perform_UIDispatch(_loc3_);
         this.FMC_OrgActivityUpgrade.Visible = false;
         this.FMC_OrgActivityUpgrade.ClickBtnCancel = this.OnUpGradeCancelClick;
         this.FMC_OrgActivityUpgrade.OverHintUpgradeBtn = this.OnHintOverUpgradeBtn;
         this.FMC_OrgActivityUpgrade.OutHintUpgradeBtn = this.OnHintOutUpgradeBtn;
         this.FBtn_TabCamp = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_TabCamp];
         this.FBtn_TabMember = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_TabMember];
         this.FBtn_TabLog = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_TabLog];
         this.FBtn_TabOrgBag = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_TabOrgBag];
         this.FBtn_GroupCopy = this.FMC["Btn_GroupCopy"];
         this.FBtn_SingleCopy = this.FMC["Btn_SingleCopy"];
         this.FBtn_Shop = this.FMC["Btn_Shop"];
         this.FTabVect.push(this.FBtn_TabCamp);
         this.FTabVect.push(this.FBtn_TabMember);
         this.FTabVect.push(this.FBtn_TabLog);
         this.FTabVect.push(this.FBtn_TabOrgBag);
         this.FTabVect.push(this.FBtn_GroupCopy);
         this.FTabVect.push(this.FBtn_SingleCopy);
         this.FTabVect.push(this.FBtn_Shop);
         this.FTab_Org = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < MAX_TABCOUNT)
         {
            this.FTab_Org.SetTabByIndex(this.FTabVect[_loc2_],_loc2_);
            _loc2_++;
         }
         this.FTab_Org.OnSwitch = this.ChangeTabOnSwitch;
         this.FTab_Org.Init();
         this.FBtn_Donate = new TUIButton();
         this.FBtn_Donate.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Donate];
         this.FBtn_Donate.OnClick = this.OnOrgDonateClick;
         this.FBtn_AdjustNotice = new TUIButton();
         this.FBtn_AdjustNotice.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_AdjustNotice];
         this.FBtn_AdjustNotice.OnClick = this.OnOrgAdjustNoticeClick;
         this.FBtn_GotoOrgList = new TUIButton();
         this.FBtn_GotoOrgList.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_GotoOrgList];
         this.FBtn_GotoOrgList.OnClick = this.OnOrgGotoOrgListClick;
         this.FBtn_GotoPower = new TUIButton();
         this.FBtn_GotoPower.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_GotoPower];
         this.FBtn_GotoPower.OnClick = this.OnOrgGotoPowerClick;
         this.FBtn_ApplyList = new TUIButton();
         this.FBtn_ApplyList.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_ApplyList];
         this.FBtn_ApplyList.OnClick = this.OnOrgApplyListClick;
         this.FBtn_SwitchPower = new TUIButton();
         this.FBtn_SwitchPower.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_SwitchPower];
         this.FBtn_SwitchPower.OnClick = this.OnOrgSwitchPowerClick;
         this.FBtn_QuitOrg = new TUIButton();
         this.FBtn_QuitOrg.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_QuitOrg];
         this.FBtn_QuitOrg.OnClick = this.OnOrgQuitOrgClick;
         this.FTF_OrgQuitBtnCaption = this.FBtn_QuitOrg.Substrate["TF_Caption"];
         this.FHint = new THint();
         this.FMC_Farmliy = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_Farmliy];
         this.FTF_OrgName = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgName];
         this.FTF_LeaderName = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_LeaderName];
         this.FTF_OrgLevel = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgLevel];
         this.FTF_OrgMoney = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgMoney];
         this.FTF_OrgMember = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgMember];
         this.FTF_OrgContribution = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgContribution];
         this.FTF_OrgExploit = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgExploit];
         this.FTF_OrgNotice = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_OrgNotice];
         this.FMC_ApplyCount = this.FMC["MC_ApplyCount"];
         this.FTF_MyActive = this.FMC["TF_MyActive"];
         this.FTF_GroupActive = this.FMC["TF_GroupActive"];
         this.FTF_MyActive.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMyActiveTextOver);
         this.FTF_MyActive.addEventListener(MouseEvent.MOUSE_OUT,this.OnMyActiveTextOut);
         this.FTF_GroupActive.addEventListener(MouseEvent.MOUSE_MOVE,this.OnGroupActiveTextOver);
         this.FTF_GroupActive.addEventListener(MouseEvent.MOUSE_OUT,this.OnGroupActiveTextOut);
         this.FMC_Award_0 = this.FMC["MC_Award_0"];
         this.FMC_Award_1 = this.FMC["MC_Award_1"];
         this.FMC_Award_0.gotoAndStop(1);
         this.FMC_Award_1.gotoAndStop(2);
         this.FMC_Award_0.addEventListener(MouseEvent.MOUSE_MOVE,this.OnAwardMouseMove);
         this.FMC_Award_0.addEventListener(MouseEvent.MOUSE_OUT,this.OnAwardMouseOut);
         this.FMC_Award_1.addEventListener(MouseEvent.MOUSE_MOVE,this.OnAwardMouseMove);
         this.FMC_Award_1.addEventListener(MouseEvent.MOUSE_OUT,this.OnAwardMouseOut);
         this.FUIWindowInputString = new TUIWindowInputString(this);
         this.FUIWindowInputString.OnOK = this.FUIWindow_InputStringOnOk;
         this.FUIWindowInputString.EditorString = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_42);
         TUtilityUIWindow.SetupWindowInputString(this.FUIWindowInputString);
         this.FUIWindowInputString.X = -200;
         this.FUIWindowInputString.Y = -100;
         this.FUIWindowInputString.Visible = false;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowConfirmation.Visible = false;
      }
      
      protected function UpDateUI() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TOrganizationBase = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc2_ = _loc1_.GetDatebaseByIndex(this.FOrgBaseInfo.OrgLevel - 1) as TOrganizationBase;
         this.FMC_Farmliy.gotoAndStop(this.FOrgBaseInfo.OrgFamily > 0 ? this.FOrgBaseInfo.OrgFamily : 1);
         this.FTF_OrgName.text = this.FOrgBaseInfo.OrgName;
         this.FTF_LeaderName.text = this.FOrgBaseInfo.MasterName;
         this.FTF_OrgLevel.text = String(this.FOrgBaseInfo.OrgLevel);
         this.FTF_OrgMoney.text = String(this.FOrgBaseInfo.OrgMoney);
         this.FTF_OrgMember.text = this.FOrgBaseInfo.OrgMembers + "/" + _loc2_.OrgMaxNumber;
         this.FTF_OrgContribution.text = String(this.FOrgBaseInfo.OrgContribution);
         this.FTF_MyActive.text = this.FOrgBaseInfo.MyActive + "/" + _loc2_.DayMaxActivity;
         this.FTF_GroupActive.text = this.FOrgBaseInfo.GroupActive + "/" + _loc2_.GuildMaxActivity;
         this.FTF_OrgExploit.text = String(this.FOrgBaseInfo.OrgExploit);
         this.FTF_OrgNotice.text = String(this.FOrgBaseInfo.OrgNotice);
         TextField(this.FMC_ApplyCount["TXT_ApplyCount"]).text = String(this.FOrgApplyListCount);
         if(this.FOrgBaseInfo.OrgPower != 2)
         {
            this.FTF_OrgQuitBtnCaption.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_43);
         }
         else
         {
            this.FTF_OrgQuitBtnCaption.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_44);
         }
         if(_loc2_.GetMoreExp > 0)
         {
            this.FMC_Award_0.gotoAndStop(1);
            this.FMC_Award_0.visible = true;
         }
         if(_loc2_.GetMoreSiv > 0)
         {
            this.FMC_Award_1.gotoAndStop(2);
            this.FMC_Award_1.visible = true;
         }
         if(this.FOrgBaseInfo.OrgPower == 0)
         {
            this.FBtn_AdjustNotice.Visible = false;
            this.FBtn_ApplyList.Visible = false;
            this.FBtn_SwitchPower.Visible = false;
            this.FMC_ApplyCount.visible = false;
         }
         else if(this.FOrgBaseInfo.OrgPower == 1)
         {
            this.FBtn_AdjustNotice.Visible = true;
            this.FBtn_ApplyList.Visible = true;
            this.FBtn_SwitchPower.Visible = false;
            this.FMC_ApplyCount.visible = Boolean(this.FOrgApplyListCount > 0);
         }
         else
         {
            this.FBtn_AdjustNotice.Visible = true;
            this.FBtn_ApplyList.Visible = true;
            this.FBtn_SwitchPower.Visible = true;
            this.FMC_ApplyCount.visible = Boolean(this.FOrgApplyListCount > 0);
         }
         this.FMC_OrgCamp.UpData(this.FOrgBaseInfo);
         this.FMC_OrgCamp.UpDateUI();
      }
      
      protected function OnMyActiveTextOver(param1:MouseEvent) : void
      {
         this.FHint.Caption = this.FData.NewOrgSystemLanguage.GetStr6();
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnGroupActiveTextOver(param1:MouseEvent) : void
      {
         this.FHint.Caption = this.FData.NewOrgSystemLanguage.GetStr7();
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnMyActiveTextOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnGroupActiveTextOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function ChangeTabOnSwitch(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = param1 as int;
         if(_loc3_ == this.FChangeTabIndex)
         {
            return;
         }
         this.FChangeTabIndex = _loc3_;
         switch(this.FChangeTabIndex)
         {
            case 0:
               this.HideTabWinAll();
               this.FMC_OrgCamp.Visible = true;
               break;
            case 1:
               this.HideTabWinAll();
               this.FMC_OrgMemberList.Visible = true;
               _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadMemberListReq);
               SNetworkCore.Transceiver.PacketTransmit(_loc2_);
               break;
            case 2:
               this.HideTabWinAll();
               this.FMC_OrgLogs.Visible = true;
               this.FMC_OrgLogs.UpDateUI();
               _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GuildLogReq);
               SNetworkCore.Transceiver.PacketTransmit(_loc2_);
               break;
            case 3:
               this.HideTabWinAll();
               this.FMC_OrgBags.Visible = true;
               _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadGulidDepotReq);
               SNetworkCore.Transceiver.PacketTransmit(_loc2_);
               break;
            case 4:
               this.FUnstreamizerOrganizationNew.GroupInitReq();
               break;
            case 5:
               this.FUnstreamizerOrganizationNew.SingleInitReq();
               break;
            case 6:
               this.FUnstreamizerOrganizationNew.MallInitReq(this.FMC_OrgShop.CurrentShopType);
         }
      }
      
      protected function MCCampOnActivityOkClick(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FClickCampActivityOk == null)
         {
            return;
         }
         this.FClickCampActivityOk(param1,param2,param3);
      }
      
      protected function MCCampOnActivityUpLvClick(param1:Object, param2:uint) : void
      {
         switch(param2)
         {
            case TYPE_ORGACTIVITY_CAMP:
               this.FMC_OrgActivityUpgrade.UpData(TYPE_ORGACTIVITY_CAMP,this.FOrgBaseInfo);
               break;
            case TYPE_ORGACTIVITY_MUYEGUARD:
               this.FMC_OrgActivityUpgrade.UpData(TYPE_ORGACTIVITY_MUYEGUARD,this.FOrgBaseInfo);
               break;
            case TYPE_ORGACTIVITY_PETBATTLE:
               this.FMC_OrgActivityUpgrade.UpData(TYPE_ORGACTIVITY_PETBATTLE,this.FOrgBaseInfo);
               break;
            case TYPE_ORGACTIVITY_MUYEBATTLE:
               this.FMC_OrgActivityUpgrade.UpData(TYPE_ORGACTIVITY_MUYEBATTLE,this.FOrgBaseInfo);
         }
         this.FMC_OrgActivityUpgrade.UpDateUI();
         this.FMC_OrgActivityUpgrade.Visible = true;
      }
      
      protected function OnUpGradeCancelClick(param1:Object) : void
      {
         this.FMC_OrgActivityUpgrade.Visible = false;
      }
      
      protected function OnHintOverUpgradeBtn(param1:Object, param2:THint) : void
      {
         if(this.FOverHintUpgradeBtn != null)
         {
            this.FOverHintUpgradeBtn(param1,param2);
         }
      }
      
      protected function OnHintOutUpgradeBtn(param1:Object, param2:THint) : void
      {
         if(this.FOutHintUpgradeBtn != null)
         {
            this.FOutHintUpgradeBtn(param1,param2);
         }
      }
      
      protected function OnOrgDonateClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnDonate == null)
         {
            return;
         }
         this.FClickBtnDonate(this);
      }
      
      protected function OnOrgAdjustNoticeClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowInputString.Visible = true;
      }
      
      protected function OnOrgGotoOrgListClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnOrgList == null)
         {
            return;
         }
         this.FClickBtnOrgList(this,true);
      }
      
      protected function OnOrgGotoPowerClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnGotoPower == null)
         {
            return;
         }
         this.FClickBtnGotoPower(this);
      }
      
      protected function OnOrgApplyListClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnApplyList == null)
         {
            return;
         }
         this.FClickBtnApplyList(this,1);
      }
      
      protected function OnOrgSwitchPowerClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FClickBtnSwitchPowerList == null)
         {
            return;
         }
         this.FClickBtnSwitchPowerList(this,2);
      }
      
      protected function OnOrgQuitOrgClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmation.OnOK = this.WindowConfirm_OnQuitOrgOk;
         if(this.FOrgBaseInfo.OrgPower == 2)
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_45);
         }
         else
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_46);
         }
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function FUIWindow_InputStringOnOk(param1:Object, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         if(param2 != null)
         {
            _loc3_ = SSensitiveWord.Filter(param2);
            _loc3_.substr(0,90);
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_BoardModifyReq);
            _loc5_ = _loc4_.Data;
            TUtilityString.FlushUTF(_loc5_,_loc3_);
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
            this.FUIWindowInputString.Visible = false;
         }
      }
      
      protected function WindowConfirm_OnQuitOrgOk(param1:Object) : void
      {
         if(this.FClickBtnQuitOrg == null)
         {
            return;
         }
         this.FClickBtnQuitOrg(this);
      }
      
      protected function OnAwardMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TOrganizationBase = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc3_ = _loc2_.GetDatebaseByIndex(this.FOrgBaseInfo.OrgLevel - 1) as TOrganizationBase;
         if(this.FOnAwardOver == null)
         {
            return;
         }
         if(param1.currentTarget.name == "MC_Award_0")
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_47) + _loc3_.GetMoreExp / 10 + "%";
            this.FOnAwardOver(this,this.FHint);
         }
         else
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_48) + _loc3_.GetMoreSiv / 10 + "%";
            this.FOnAwardOver(this,this.FHint);
         }
      }
      
      protected function OnAwardMouseOut(param1:MouseEvent) : void
      {
         if(this.FOnAwardOut == null)
         {
            return;
         }
         this.FOnAwardOut(this,this.FHint);
      }
      
      protected function OnActivityMouseOver(param1:Object, param2:uint) : void
      {
         var _loc3_:TBins = null;
         var _loc4_:TOrganizationBase = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         if(this.FOnActivityOver != null)
         {
            if(param2 == TYPE_ORGACTIVITY_MUYEBATTLE)
            {
               _loc4_ = _loc3_.GetDatebaseByIndex(this.FOrgBaseInfo.GetOrgActivityLevelByType(TYPE_ORGACTIVITY_MUYEBATTLE) - 1) as TOrganizationBase;
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_49) + "\n" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_50) + _loc4_.MuyebattleUpgradeAddition / 10 + "%";
               this.FOnActivityOver(param1,this.FHint);
            }
            else if(param2 == TYPE_ORGACTIVITY_MUYEGUARD)
            {
               _loc4_ = _loc3_.GetDatebaseByIndex(this.FOrgBaseInfo.GetOrgActivityLevelByType(TYPE_ORGACTIVITY_MUYEGUARD) - 1) as TOrganizationBase;
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_51) + "\n" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_52) + _loc4_.MuyeguardUpgradeAddition / 10 + "%";
               this.FOnActivityOver(param1,this.FHint);
            }
         }
      }
      
      protected function OnActivityMouseOut(param1:Object) : void
      {
         if(this.FOnActivityOut != null)
         {
            this.FOnActivityOut(param1,this.FHint);
         }
      }
      
      protected function OrgBagEffectGenerateText(param1:Object, param2:String) : void
      {
         if(this.FOnOrgBagEffectGenerateText != null)
         {
            this.FOnOrgBagEffectGenerateText(param1,param2);
         }
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
      
      protected function HideTabWinAll() : void
      {
         this.FMC_OrgCamp.Visible = false;
         this.FMC_OrgBags.Visible = false;
         this.FMC_OrgMemberList.Visible = false;
         this.FMC_OrgLogs.Visible = false;
         this.FMC_OrgSingleCopy.Visible = false;
         this.FMC_OrgGroupCopy.Visible = false;
         this.FMC_OrgShop.Visible = false;
      }
      
      public function get ClickCampActivityOk() : Function
      {
         return this.FClickCampActivityOk;
      }
      
      public function set ClickCampActivityOk(param1:Function) : void
      {
         this.FClickCampActivityOk = param1;
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
      
      public function get DataMembersVect() : Vector.<TBaseOrganizationMember>
      {
         return this.FDataMembersVect;
      }
      
      public function set DataMembersVect(param1:Vector.<TBaseOrganizationMember>) : void
      {
         this.FDataMembersVect = param1;
      }
      
      public function get OnAwardOver() : Function
      {
         return this.FOnAwardOver;
      }
      
      public function set OnAwardOver(param1:Function) : void
      {
         this.FOnAwardOver = param1;
      }
      
      public function get OnAwardOut() : Function
      {
         return this.FOnAwardOut;
      }
      
      public function set OnAwardOut(param1:Function) : void
      {
         this.FOnAwardOut = param1;
      }
      
      public function get OnActivityOver() : Function
      {
         return this.FOnActivityOver;
      }
      
      public function set OnActivityOver(param1:Function) : void
      {
         this.FOnActivityOver = param1;
      }
      
      public function get OnActivityOut() : Function
      {
         return this.FOnActivityOut;
      }
      
      public function set OnActivityOut(param1:Function) : void
      {
         this.FOnActivityOut = param1;
      }
      
      public function get OnOrgBagEffectGenerateText() : Function
      {
         return this.FOnOrgBagEffectGenerateText;
      }
      
      public function set OnOrgBagEffectGenerateText(param1:Function) : void
      {
         this.FOnOrgBagEffectGenerateText = param1;
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
      
      public function get OutHintUpgradeBtn() : Function
      {
         return this.FOutHintUpgradeBtn;
      }
      
      public function set OutHintUpgradeBtn(param1:Function) : void
      {
         this.FOutHintUpgradeBtn = param1;
      }
      
      public function get OverHintUpgradeBtn() : Function
      {
         return this.FOverHintUpgradeBtn;
      }
      
      public function set OverHintUpgradeBtn(param1:Function) : void
      {
         this.FOverHintUpgradeBtn = param1;
      }
      
      public function set SelectSlotOnMove(param1:Function) : void
      {
         this.FMC_OrgBags.SelectSlotOnMove = param1;
      }
      
      public function set SelectSlotOnOut(param1:Function) : void
      {
         this.FMC_OrgBags.SelectSlotOnOut = param1;
      }
      
      public function set OnShowHeroAchievement(param1:Function) : void
      {
         this.FOnShowHeroAchievement = param1;
      }
      
      public function set Data(param1:TNewOrgData) : void
      {
         this.FData = param1;
         this.FMC_OrgSingleCopy.Data = param1;
         this.FMC_OrgGroupCopy.Data = param1;
         this.FMC_OrgShop.Data = param1;
      }
      
      public function set ClickBtnGotoSinglePointMap(param1:Function) : void
      {
         this.FClickBtnGotoSinglePointMap = param1;
         this.FMC_OrgSingleCopy.ClickBtnGotoSinglePointMap = param1;
      }
      
      public function set ClickBtnGotoGroupPointMap(param1:Function) : void
      {
         this.FClickBtnGotoGroupPointMap = param1;
         this.FMC_OrgGroupCopy.ClickBtnGotoGroupPointMap = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
         this.FMC_OrgGroupCopy.UnstreamizerOrganizationNew = param1;
         this.FMC_OrgShop.UnstreamizerOrganizationNew = param1;
      }
      
      public function set OrgBaseInfo(param1:TBaseOrganization) : void
      {
         this.FOrgBaseInfo = param1;
         this.FMC_OrgGroupCopy.BaseData = param1;
      }
      
      public function set OnOpenShopExchang(param1:Function) : void
      {
         this.FOnOpenShopExchang = param1;
         this.FMC_OrgShop.OnOpenShopExchang = param1;
      }
      
      public function get CurrentMallType() : int
      {
         return this.FMC_OrgShop.CurrentShopType;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         super.Visible = param1;
         if(this.FGetMountInfo == null)
         {
            return;
         }
         if(param1)
         {
            _loc4_ = this.FGetMountInfo();
            if(_loc4_ != null)
            {
               _loc2_ = _loc4_.readInt();
               _loc3_ = _loc4_.readInt();
               this.FData.LinkGlobalIndex = this.FData.GetCopyIndexByCityID(_loc3_);
               switch(_loc2_)
               {
                  case CONST_ORGANIZATION.ORGANIZATION_PAGE_CITY:
                     _loc5_ = this.FData.GetCopyTypeByCityID(_loc3_);
                     if(_loc5_ == this.FData.CopyType_Group)
                     {
                        this.FTab_Org.SwithTagManual(4);
                     }
                     else
                     {
                        this.FTab_Org.SwithTagManual(5);
                     }
               }
            }
         }
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpDataUI(param1:TBaseOrganization, param2:uint) : void
      {
         this.FOrgBaseInfo = param1;
         this.FOrgApplyListCount = param2;
         this.UpDateUI();
      }
      
      public function UpData_OrgBag(param1:TInventories, param2:Vector.<uint>, param3:Vector.<TBaseOrganizationMember>, param4:TBaseOrganization) : void
      {
         this.FOrgBaseInfo = param4;
         this.FMC_OrgBags.UpData(param1,param2,param3,param4);
      }
      
      public function UpDateUI_OrgBag() : void
      {
         this.FMC_OrgBags.UpDateUI();
      }
      
      public function UpData_Members(param1:Vector.<TBaseOrganizationMember>) : void
      {
         this.FDataMembersVect = param1;
         this.FMC_OrgMemberList.UpData(this.FDataMembersVect,this.FOrgBaseInfo);
      }
      
      public function UpDateUI_OrgMemberList() : void
      {
         this.FMC_OrgMemberList.UpDateUI();
      }
      
      public function UpDateUI_OrgActivityUpgrade(param1:uint) : void
      {
         this.FMC_OrgActivityUpgrade.UpData(param1,this.FOrgBaseInfo);
         this.FMC_OrgActivityUpgrade.UpDateUI();
      }
      
      public function UpDateUI_OrgCamp() : void
      {
         this.FMC_OrgCamp.UpData(this.FOrgBaseInfo);
         this.FMC_OrgCamp.UpDateUI();
      }
      
      public function UpDateUI_OrgLog(param1:Vector.<Object>) : void
      {
         this.FMC_OrgLogs.UpData(param1);
         this.FMC_OrgLogs.UpDateUI();
      }
      
      public function UpDateUI_OrgMemberCount(param1:uint) : void
      {
         this.FTF_OrgMember.text = param1 + "/" + this.FOrgBaseInfo.OrgMaxMemberCount;
      }
      
      public function UpDataUI_OrgActivityBtnStatus(param1:uint, param2:uint) : void
      {
         this.FMC_OrgCamp.UpDataUI_BtnActivity(param1,param2);
      }
      
      public function UpDateUI_ApplyListCount(param1:uint) : void
      {
         this.FOrgApplyListCount = param1;
         TextField(this.FMC_ApplyCount["TXT_ApplyCount"]).text = String(this.FOrgApplyListCount);
      }
      
      public function LogicsPerform() : void
      {
         this.FMC_OrgBags.LogicsPerform();
         this.FMC_OrgCamp.LogicsPerform();
         this.FMC_OrgMemberList.LogicsPerform();
         this.FMC_OrgGroupCopy.LogicsPerform();
         this.FMC_OrgSingleCopy.LogicsPerform();
         this.FMC_OrgShop.LogicsPerform();
      }
      
      public function Unmount() : void
      {
         this.FTab_Org.Reset();
         this.FMC_OrgBags.UnMount();
      }
      
      public function InitWindow() : void
      {
         this.FMC_OrgSingleCopy.UIDispatch(this.FMC["MC_SingleCopy"]);
         this.FMC_OrgGroupCopy.UIDispatch(this.FMC["MC_GroupCopy"]);
         this.FMC_OrgShop.UIDispatch(this.FMC["MC_Shop"]);
      }
      
      public function OpenSingleTab() : void
      {
         this.HideTabWinAll();
         this.FMC_OrgSingleCopy.Visible = true;
      }
      
      public function OpenGroupTab() : void
      {
         this.HideTabWinAll();
         this.FMC_OrgGroupCopy.Visible = true;
      }
      
      public function OpenMallTab() : void
      {
         this.HideTabWinAll();
         this.FMC_OrgShop.Visible = true;
      }
      
      public function UpdateActive() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TOrganizationBase = null;
         if(this.FMC == null)
         {
            return;
         }
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc2_ = _loc1_.GetDatebaseByIndex(this.FOrgBaseInfo.OrgLevel - 1) as TOrganizationBase;
         this.FTF_MyActive.text = this.FOrgBaseInfo.MyActive + "/" + _loc2_.DayMaxActivity;
         this.FTF_GroupActive.text = this.FOrgBaseInfo.GroupActive + "/" + _loc2_.GuildMaxActivity;
      }
      
      public function StartCopyUpdateUI() : void
      {
         this.FMC_OrgGroupCopy.StartCopyUpdateUI();
      }
      
      public function ResetCopyUpdateUI() : void
      {
         this.FMC_OrgGroupCopy.ResetCopyUpdateUI();
      }
      
      public function MallUpdate() : void
      {
         this.FMC_OrgShop.Update();
      }
      
      public function UpdateShopCurrentPage() : void
      {
         this.FMC_OrgShop.UpdateCurrentPage();
      }
      
      public function set GetMountInfo(param1:Function) : void
      {
         this.FGetMountInfo = param1;
         this.FMC_OrgSingleCopy.GetMountInfo = param1;
         this.FMC_OrgGroupCopy.GetMountInfo = param1;
      }
      
      public function set SetMountInfo(param1:Function) : void
      {
         this.FSetMountInfo = param1;
         this.FMC_OrgSingleCopy.SetMountInfo = param1;
         this.FMC_OrgGroupCopy.SetMountInfo = param1;
      }
   }
}

