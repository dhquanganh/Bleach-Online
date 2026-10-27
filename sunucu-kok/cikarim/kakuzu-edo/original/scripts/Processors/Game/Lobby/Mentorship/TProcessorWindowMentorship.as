package Processors.Game.Lobby.Mentorship
{
   import Components.ScrollBar.*;
   import Components.Standard.TUIButton;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.InteractionLog.TInteractionLog;
   import Logics.InteractionLog.TInteractionLogs;
   import Logics.Mentorship.*;
   import Logics.Mentorship.Elements.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Mentorship.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowMentorship extends TProcessorLobbyWindow
   {
      
      public static const STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static const STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected const CAPACITY_DiscipleStatus:uint = 3;
      
      protected const IDENTITY_Freedom:uint = 0;
      
      protected const IDENTITY_Master:uint = 1;
      
      protected const IDENTITY_Disciple:uint = 2;
      
      protected const CAPACITY_InteractionLogs:uint = 15;
      
      protected const ID_MainHero:uint = 11100000;
      
      protected var FMC_Mentorship:Sprite;
      
      protected var FMC_Freedom:Sprite;
      
      protected var FMC_Master:Sprite;
      
      protected var FMC_Disciple:Sprite;
      
      protected var FBTN_RescueMembers:TUIButton;
      
      protected var FBTN_GetDisciple:TUIButton;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_Help:SimpleButton;
      
      protected var FTF_Explanation:TextField;
      
      protected var FMC_DiscipleStatus:Sprite;
      
      protected var FHeroInfo:THeroInfo;
      
      protected var FMC_InteractionCDTime:Sprite;
      
      protected var FTF_InteractionCDTime:TextField;
      
      protected var FBTN_Interaction:TUIButton;
      
      protected var FBTN_SOS:TUIButton;
      
      protected var FBTN_Resist:TUIButton;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FInteractionTextFieldVect:Vector.<TextField>;
      
      protected var FMC_DiscipleStatusList:Vector.<TDiscipleStatus>;
      
      protected var FMentorship:TMentorship;
      
      protected var FInteractionLogs:TInteractionLogs;
      
      protected var FFunctions:Vector.<Function>;
      
      protected var FBTNList:Vector.<MovieClip>;
      
      protected var FFilterList:Vector.<String>;
      
      protected var FLogInfoTextFieldList:Vector.<TextField>;
      
      protected var FInitialized:Boolean;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FCommandType:uint;
      
      protected var FConfigValueBins:TBins;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FHelpTips:THint;
      
      protected var FMainHeroID:uint;
      
      protected var FOnArrest:Function;
      
      protected var FOnRescueMembers:Function;
      
      protected var FOnInteraction:Function;
      
      protected var FOnResist:Function;
      
      protected var FOnRedeem:Function;
      
      protected var FOnWatchOhterPlayerInfo:Function;
      
      protected var FOnDrawExp:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      public function TProcessorWindowMentorship(param1:TUIComponent)
      {
         super(param1);
         this.FMC_DiscipleStatusList = new Vector.<TDiscipleStatus>(this.CAPACITY_DiscipleStatus);
         this.FInteractionTextFieldVect = new Vector.<TextField>();
         this.FFunctions = new Vector.<Function>();
         this.FBTNList = new Vector.<MovieClip>();
         this.FFilterList = new Vector.<String>();
         this.FLogInfoTextFieldList = new Vector.<TextField>();
         this.FInitialized = false;
         this.FHelpTips = new THint();
         this.ConstructIdentityBaseInfo();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MENTORSHIP.RESOURCESID_Swf_Mentorship);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TDiscipleStatus = null;
         this.FMC_Mentorship = TUtilityReflection.CreateDisplayObjectInstance(CONST_MENTORSHIP.RESOURCE_ClassName_MC_Mentorship) as Sprite;
         addChild(this.FMC_Mentorship);
         this.FMC_Freedom = this.FMC_Mentorship["MC_Freedom"];
         this.FMC_Master = this.FMC_Mentorship["MC_Master"];
         this.FMC_Disciple = this.FMC_Mentorship["MC_Disciple"];
         this.FBTN_RescueMembers = new TUIButton();
         this.FBTN_RescueMembers.Substrate = this.FMC_Mentorship[CONST_MENTORSHIP.RESOURCE_Link_BTN_RescueMembers];
         this.FBTN_RescueMembers.OnClick = this.BTNRescueMembersOnClick;
         this.FBTN_GetDisciple = new TUIButton();
         this.FBTN_GetDisciple.Substrate = this.FMC_Mentorship[CONST_MENTORSHIP.RESOURCE_Link_BTN_GetDisciple];
         this.FBTN_GetDisciple.OnClick = this.ProcessorOnArrest;
         this.FBTN_Close = this.FMC_Mentorship[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBTN_Help = this.FMC_Mentorship[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FTF_Explanation = this.FMC_Mentorship[CONST_MENTORSHIP.RESOURCE_Link_TF_Explanation];
         _loc2_ = this.CAPACITY_DiscipleStatus;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TDiscipleStatus(this);
            _loc3_.Resource = this.FMC_Mentorship[CONST_MENTORSHIP.RESOURCE_Link_MC_DiscipleStatuses + _loc1_];
            _loc3_.OnInteraction = this.ProcessorOnInteraction;
            _loc3_.OnDrawExp = this.ProcessorOnDrawExp;
            _loc3_.OnEffectGenerateText = this.ProcessorOnEffectGenerateText;
            _loc3_.OnWatchOhterPlayerInfo = this.ProcessorOnWatchOhterPlayerInfo;
            _loc3_.Init();
            _loc3_.Visible = false;
            this.FMC_DiscipleStatusList[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FScrollBar = new TScrollBar(this.FMC_Mentorship["mc_list"],258);
         this.FMC_DiscipleStatus = this.FMC_Mentorship[CONST_MENTORSHIP.RESOURCE_Link_MC_DiscipleStatus];
         this.FHeroInfo = new THeroInfo(this);
         this.FHeroInfo.Resource = this.FMC_DiscipleStatus[CONST_MENTORSHIP.RESOURCE_Link_MC_Hero];
         this.FHeroInfo.Init();
         this.FMC_InteractionCDTime = this.FMC_DiscipleStatus[CONST_MENTORSHIP.RESOURCE_Link_MC_InteractionCDTime];
         this.FTF_InteractionCDTime = this.FMC_InteractionCDTime[CONST_MENTORSHIP.RESOURCE_Link_TF_InteractionCDTime];
         this.FBTN_Interaction = new TUIButton();
         this.FBTN_Interaction.Substrate = this.FMC_DiscipleStatus[CONST_MENTORSHIP.RESOURCE_Link_BTN_Interaction];
         this.FBTN_Interaction.OnClick = this.BTNInteractionOnClick;
         this.FBTN_SOS = new TUIButton();
         this.FBTN_SOS.Substrate = this.FMC_DiscipleStatus[CONST_MENTORSHIP.RESOURCE_Link_BTN_SOS];
         this.FBTN_SOS.OnClick = this.BTNSOSOnClick;
         this.FBTN_Resist = new TUIButton();
         this.FBTN_Resist.Substrate = this.FMC_DiscipleStatus[CONST_MENTORSHIP.RESOURCE_Link_BTN_Resist];
         this.FBTN_Resist.OnClick = this.BTNResistOnClick;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FInitialized = true;
         this.FMainHeroID = SLogicsCore.Character.MainHero.Identifier;
         MovieClip(this.FMC_Freedom["MC_MainHeroHead"]).gotoAndStop(this.FMainHeroID - this.ID_MainHero);
         MovieClip(this.FMC_Master["MC_MainHeroHead"]).gotoAndStop(this.FMainHeroID - this.ID_MainHero);
         MovieClip(this.FMC_Disciple["MC_MainHeroHead"]).gotoAndStop(this.FMainHeroID - this.ID_MainHero);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.BTNCloseOnClick,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FConfigValueBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue) as TBins;
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TConfigValue = null;
         if(!this.Visible)
         {
            return;
         }
         if(this.FMentorship == null)
         {
            return;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Slave_InteractionCDTime) as TConfigValue;
         _loc2_ = uint(STimingCore.ServerTick);
         _loc1_ = this.FMentorship.InteractionCDTime + uint(_loc4_.Value) * 60;
         if(this.FInitialized)
         {
            _loc3_ = _loc1_ - _loc2_;
            if(this.FMC_DiscipleStatus.visible)
            {
               if(_loc3_ >= 0)
               {
                  this.FTF_InteractionCDTime.text = TUtilityTiming.fomatTime(_loc3_);
                  this.ShowMasterInfo(true);
               }
               else
               {
                  this.ShowMasterInfo(false);
               }
            }
         }
         super.LogicsPerform();
      }
      
      protected function ConstructIdentityBaseInfo() : void
      {
         this.FFunctions.push(this.UpdateFreedomBaseInfo);
         this.FFunctions.push(this.UpdateMasterBaseInfo);
         this.FFunctions.push(this.UpdateDiscipleBaseInfo);
      }
      
      protected function UpdateIdentityBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         _loc1_ = int(this.FMentorship.Identity);
         this.FFunctions[_loc1_]();
         _loc2_ = true;
         switch(_loc1_)
         {
            case this.IDENTITY_Freedom:
               this.ShowBaseInfo(_loc2_,!_loc2_,!_loc2_);
               this.ShowStatusInfo(_loc2_);
               this.UpdateDiscipleStatus();
               break;
            case this.IDENTITY_Master:
               this.ShowBaseInfo(!_loc2_,_loc2_,!_loc2_);
               this.ShowStatusInfo(_loc2_);
               this.UpdateDiscipleStatus();
               break;
            case this.IDENTITY_Disciple:
               this.ShowBaseInfo(!_loc2_,!_loc2_,_loc2_);
               this.ShowStatusInfo(!_loc2_);
               this.UpdateMasterInfo();
         }
      }
      
      protected function UpdateMasterInfo() : void
      {
         this.FHeroInfo.Update(this.FMentorship);
         this.ShowMasterInfo(this.FMentorship.InteractionCDTime != 0);
      }
      
      protected function ShowMasterInfo(param1:Boolean) : void
      {
         this.FMC_InteractionCDTime.visible = param1;
         this.FBTN_Interaction.Visible = !param1;
         this.FBTN_SOS.Visible = !param1;
         this.FBTN_Resist.Visible = !param1;
      }
      
      protected function UpdateDiscipleStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TDiscipleStatus = null;
         var _loc4_:TDisciple = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = this.CAPACITY_DiscipleStatus;
         _loc5_ = this.FMentorship.Identity;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_DiscipleStatusList[_loc1_];
            _loc6_ = this.FMentorship.DiscipleList.length;
            if(_loc6_ > _loc1_)
            {
               _loc4_ = this.FMentorship.DiscipleList[_loc1_];
               _loc3_.Update(_loc4_,_loc5_ == CONST_MENTORSHIP.IDENTITY_Master && _loc4_ != null);
               _loc3_.Visible = true;
            }
            else
            {
               _loc3_.Update(null,false);
               _loc3_.Visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function SetGetExp(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.GetLimitedExp();
         if(this.FMentorship.TodayGetExp > _loc2_)
         {
            param1["TF_ExpLimited"].text = _loc2_ + "/" + _loc2_;
         }
         else
         {
            param1["TF_ExpLimited"].text = this.FMentorship.TodayGetExp + "/" + _loc2_;
         }
      }
      
      protected function GetLimitedExp() : uint
      {
         var _loc1_:TSlaveGainExp = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveGainExp,SLogicsCore.Character.GetMainRebirthLevel()) as TSlaveGainExp;
         if(_loc1_ != null)
         {
            return _loc1_.Extractable;
         }
         return 0;
      }
      
      protected function UpdateFreedomBaseInfo() : void
      {
         this.FMC_Freedom["TF_TodayArrestCount"].text = this.FMentorship.TodayArrestCount;
         this.FMC_Freedom["TF_TodayRescueCount"].text = this.FMentorship.TodayRescueCount;
         this.FMC_Freedom["TF_TodayInteractionCount"].text = this.FMentorship.TodayInteractionCount;
         this.SetGetExp(this.FMC_Freedom);
      }
      
      protected function UpdateMasterBaseInfo() : void
      {
         this.FMC_Master["TF_TodayArrestCount"].text = this.FMentorship.TodayArrestCount;
         this.FMC_Master["TF_TodayRescueCount"].text = this.FMentorship.TodayRescueCount;
         this.FMC_Master["TF_TodayInteractionCount"].text = this.FMentorship.TodayInteractionCount;
         this.SetGetExp(this.FMC_Master);
      }
      
      protected function UpdateDiscipleBaseInfo() : void
      {
         this.FMC_Disciple["TF_TodayInteractionCount"].text = this.FMentorship.TodayInteractionCount;
         this.FMC_Disciple["TF_TodaySOSCount"].text = this.FMentorship.TodaySOSCount;
         this.FMC_Disciple["TF_TodayResistCount"].text = this.FMentorship.TodayResistCount;
      }
      
      protected function ShowBaseInfo(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.FMC_Freedom.visible = param1;
         this.FMC_Master.visible = param2;
         this.FMC_Disciple.visible = param3;
         this.FBTN_RescueMembers.Visible = !param3;
         this.FBTN_GetDisciple.Visible = !param3;
      }
      
      protected function ShowStatusInfo(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TDiscipleStatus = null;
         _loc3_ = this.CAPACITY_DiscipleStatus;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FMC_DiscipleStatusList[_loc2_];
            _loc4_.Resource.visible = param1;
            _loc2_++;
         }
         this.FMC_DiscipleStatus.visible = !param1;
      }
      
      protected function UpdateInteractionLogText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TextField = null;
         var _loc4_:TextFormat = null;
         this.MakeHtmlTextStr();
         _loc2_ = uint(this.FScrollBar.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FLogInfoTextFieldList.push(this.FScrollBar.Items[_loc1_]);
            _loc1_++;
         }
         this.FScrollBar.Clear();
         _loc2_ = this.CAPACITY_InteractionLogs;
         _loc4_ = new TextFormat();
         _loc4_.leading = 2;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FLogInfoTextFieldList.length > 0)
            {
               _loc3_ = this.FLogInfoTextFieldList.pop();
            }
            else
            {
               _loc3_ = new TextField();
               _loc3_.selectable = false;
               _loc3_.wordWrap = true;
               _loc3_.width = 160;
               _loc3_.addEventListener(TextEvent.LINK,this.WatchReportOnCLick,false,0,true);
            }
            if(_loc1_ >= this.FFilterList.length)
            {
               break;
            }
            _loc3_.htmlText = this.FFilterList[_loc1_];
            _loc3_.setTextFormat(_loc4_);
            _loc3_.height = _loc3_.textHeight + 5;
            this.FScrollBar.AddItem(_loc3_);
            _loc1_++;
         }
      }
      
      protected function MakeHtmlTextStr() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInteractionLog = null;
         _loc2_ = this.FFilterList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FFilterList.pop();
            _loc1_++;
         }
         _loc2_ = uint(this.FInteractionLogs.Count);
         _loc3_ = this.CAPACITY_InteractionLogs;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == _loc3_)
            {
               break;
            }
            _loc4_ = this.FInteractionLogs.GetInteractionLogByIndex(_loc2_ - 1 - _loc1_);
            this.FFilterList.push(_loc4_.HtmlText);
            _loc1_++;
         }
      }
      
      protected function UpdateExplanation() : void
      {
         switch(this.FMentorship.Identity)
         {
            case CONST_MENTORSHIP.IDENTITY_Freedom:
               this.FTF_Explanation.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_15);
               break;
            case CONST_MENTORSHIP.IDENTITY_Master:
               this.FTF_Explanation.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_16);
               break;
            case CONST_MENTORSHIP.IDENTITY_Disciple:
               this.FTF_Explanation.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_14);
         }
      }
      
      protected function BTNRescueMembersOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnRescueMembers != null)
         {
            this.FOnRescueMembers(this,CONST_MENTORSHIP.TYPE_Rescue);
         }
      }
      
      protected function BTNInteractionOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnInteraction != null)
         {
            this.FOnInteraction(this,this.FMentorship);
         }
      }
      
      protected function BTNRedeemOnClick(param1:MouseEvent) : void
      {
         this.FConfigValue = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Slave_RedeemCost) as TConfigValue;
         this.FCommandType = CONST_MENTORSHIP.COMMAND_Redeem;
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_26),this.FConfigValue.Value);
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BTNSOSOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnRescueMembers != null)
         {
            this.FOnRescueMembers(this,CONST_MENTORSHIP.TYPE_SOS);
         }
      }
      
      protected function BTNResistOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnResist != null)
         {
            this.FOnResist(this,CONST_MENTORSHIP.COMMAND_Resist,0,this.FMentorship.MasterID0,this.FMentorship.MasterID1);
         }
      }
      
      protected function BTNCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ProcessorOnArrest(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnArrest != null)
         {
            this.FOnArrest(this);
         }
      }
      
      protected function ProcessorOnInteraction(param1:Object, param2:TDisciple) : void
      {
         if(this.FOnInteraction != null)
         {
            this.FOnInteraction(this,param2);
         }
      }
      
      protected function WatchReportOnCLick(param1:TextEvent) : void
      {
         var _loc2_:Array = null;
         _loc2_ = param1.text.split("_");
         switch(_loc2_[0])
         {
            case CONST_POST.EVENT_TYPE_PLAYER:
               this.FOnWatchOhterPlayerInfo(this,_loc2_[1],_loc2_[2]);
         }
      }
      
      protected function ProcessorOnDrawExp(param1:Object, param2:uint, param3:uint, param4:TDisciple) : void
      {
         if(this.FOnDrawExp != null)
         {
            this.FOnDrawExp(this,param2,param3,param4.DiscipleID0,param4.DiscipleID1);
         }
      }
      
      protected function ProcessorOnEffectGenerateText(param1:Object, param2:String) : void
      {
         EffectGenerateText(param2);
      }
      
      protected function ProcessorOnWatchOhterPlayerInfo(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnWatchOhterPlayerInfo != null)
         {
            this.FOnWatchOhterPlayerInfo(this,param2,param3);
         }
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         if(this.FOnRedeem != null)
         {
            this.FOnRedeem(this,this.FCommandType,0,0,0);
         }
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Mentorship);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      public function get OnArrest() : Function
      {
         return this.FOnArrest;
      }
      
      public function set OnArrest(param1:Function) : void
      {
         this.FOnArrest = param1;
      }
      
      public function get OnRescueMembers() : Function
      {
         return this.FOnRescueMembers;
      }
      
      public function set OnRescueMembers(param1:Function) : void
      {
         this.FOnRescueMembers = param1;
      }
      
      public function get OnInteraction() : Function
      {
         return this.FOnInteraction;
      }
      
      public function set OnInteraction(param1:Function) : void
      {
         this.FOnInteraction = param1;
      }
      
      public function get OnWatchOhterPlayerInfo() : Function
      {
         return this.FOnWatchOhterPlayerInfo;
      }
      
      public function set OnWatchOhterPlayerInfo(param1:Function) : void
      {
         this.FOnWatchOhterPlayerInfo = param1;
      }
      
      public function get OnDrawExp() : Function
      {
         return this.FOnDrawExp;
      }
      
      public function set OnDrawExp(param1:Function) : void
      {
         this.FOnDrawExp = param1;
      }
      
      public function get OnRedeem() : Function
      {
         return this.FOnRedeem;
      }
      
      public function set OnRedeem(param1:Function) : void
      {
         this.FOnRedeem = param1;
      }
      
      public function get OnResist() : Function
      {
         return this.FOnResist;
      }
      
      public function set OnResist(param1:Function) : void
      {
         this.FOnResist = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function UpdateUI(param1:TMentorship) : void
      {
         if(!this.FInitialized)
         {
            return;
         }
         this.FMentorship = param1;
         this.UpdateIdentityBaseInfo();
         this.UpdateExplanation();
      }
      
      public function UpdateLog(param1:TInteractionLogs) : void
      {
         this.FInteractionLogs = param1;
         this.UpdateInteractionLogText();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FHeroInfo.Reset();
         _loc2_ = this.CAPACITY_DiscipleStatus;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_DiscipleStatusList[_loc1_].Reset();
            _loc1_++;
         }
      }
   }
}

