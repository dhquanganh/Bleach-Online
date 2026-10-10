package Processors.Game.Lobby.KnifeSoul
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeSoul.*;
   import Logics.SpiritSchool.TSpiritSchoolData;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.KnifeSoul.Component.TUISchoolItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowKnifeSoul extends TProcessorLobbyWindow
   {
      
      protected static const DescriptionID:int = 70170006;
      
      protected static const SPIRITSCHOOLTRAINNUM:uint = 1;
      
      protected static const SPIRITSCHOOLONEKEYTRAINNUM:uint = 50;
      
      protected static const COUNT_SPIRITSCHOOL:uint = 6;
      
      protected var FMainScene:MovieClip;
      
      protected var FMainKnifeSoulScene:MovieClip;
      
      protected var FMainSpiritSchoolScene:MovieClip;
      
      protected var FCurrentPower:TextField;
      
      protected var FCurrentAgile:TextField;
      
      protected var FCurrentIntelligence:TextField;
      
      protected var FCurrentLife:TextField;
      
      protected var FNextPower:TextField;
      
      protected var FNextAgile:TextField;
      
      protected var FNextIntelligence:TextField;
      
      protected var FNextLife:TextField;
      
      protected var FKnifeOfKillSoulAdded:TextField;
      
      protected var FTF_CurrentLeveL:TextField;
      
      protected var FTF_EXP:TextField;
      
      protected var FExpBar:Sprite;
      
      protected var FTF_TrainPellet:TextField;
      
      protected var FTF_CurrentLeveLLimit:TextField;
      
      protected var FTF_NextSegmentLevelLimit:TextField;
      
      protected var FTF_Description:TextField;
      
      protected var FColorBall:MovieClip;
      
      protected var FEffectTop:MovieClip;
      
      protected var FEffectMiddle:MovieClip;
      
      protected var FEffectBottom:MovieClip;
      
      protected var FBtn_NormalTrain:TUIButton;
      
      protected var FBtn_TrainOfOneKey:TUIButton;
      
      protected var FBtn_HighGradeTrain:TUIButton;
      
      protected var FBtn_LimitTrain:TUIButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:TUIButton;
      
      protected var FToolKnifeSoul:TKnifeSoulData;
      
      protected var FHit:THint;
      
      protected var FHitHelp:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FCostGoldWidthNoQuestion:Boolean;
      
      protected var FCostTime:int;
      
      protected var FLevelLimit:int;
      
      protected var FCurrentLevelLimit:int;
      
      protected var FTF_NowLv:TextField;
      
      protected var FTF_FreeNum:TextField;
      
      protected var FSP_LevelLimit:Sprite;
      
      protected var FSP_VipLimit:Sprite;
      
      protected var FTF_ItemNum:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FBtn_OneKey:TUIButton;
      
      protected var FSP_List:Sprite;
      
      protected var FMC_SchoolItems:Vector.<TUISchoolItem>;
      
      protected var FData_School:TSpiritSchoolData;
      
      protected var FTabs:TUITab;
      
      protected var FCurrentVisibleWindowIndex:uint;
      
      protected var FSpiritSchool_ItemID:uint;
      
      protected var FSpiritSchool_OnceCost:uint;
      
      protected var FSpiritSchool_FreeNum:uint;
      
      protected var FConfigValue:TBins;
      
      protected var FUIWindowSchoolConfirm:TUIWindowConfirmation;
      
      protected var FNoMoreQuestion:Boolean;
      
      protected var FSpiritSchoolTrainNum:uint;
      
      protected var FSpiritSchoolLvLimit:uint;
      
      protected var FSpiritSchoolVipLimit:uint;
      
      protected var FKnifeSoul:TKnifeSoulData;
      
      protected var FOnHitOut:Function;
      
      protected var FOnHitMove:Function;
      
      public function TProcessorWindowKnifeSoul(param1:TUIComponent)
      {
         super(param1);
         this.FKnifeSoul = SLogicsCore.Character.KnifeSoul;
         this.FToolKnifeSoul = new TKnifeSoulData();
         this.FHit = new THint();
         this.FHitHelp = new THint();
      }
      
      public function UIDispatch_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("KnifeSoul") as MovieClip;
         this.FMainKnifeSoulScene = this.FMainScene["MC_KnifeSoul"];
         this.FMainSpiritSchoolScene = this.FMainScene["MC_School"];
         addChild(this.FMainScene);
         this.FTabs = new TUITab(this);
         _loc2_ = CONST_DAILYWELFARE.CAPACITY_TABS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMainScene[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FTabs.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FTabs.OnSwitch = this.TabClick;
         this.FTabs.Init();
         this.SpiritSchoolUIDispatch();
         this.AttributeUIDispatch();
         this.ExpBarUIDispatch();
         this.BaseInforUIDispatch();
         this.BtnUIDispatch();
         this.ToolUIDispatch();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_KnifeSoulView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_KnifeSoulView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      public function UILocation_Perform() : void
      {
         var _loc1_:TUnlock = null;
         super.ResourcesPerform_UILocations();
         this.AttributeUILocation();
         this.ExpBarUILocation();
         this.BaseInforUILocation();
         this.BtnUILocation();
         this.ToolUILocation();
         this.FTabs.SetTabEnabledByIndex(1,false);
         this.FTabs.SetTabHideByIndex(1);
         _loc1_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_KnifeSoulSchool);
         if(_loc1_ != null)
         {
            if(_loc1_.State != TUnlock.UNLOCKSTATE_ForcedOff)
            {
               this.FTabs.SetTabEnabledByIndex(1,true);
               this.FTabs.SetTabShowByIndex(1);
            }
         }
      }
      
      protected function AttributeUIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FMainKnifeSoulScene["AttributeTable"];
         this.FCurrentPower = _loc1_["CurrentPower"];
         this.FCurrentAgile = _loc1_["CurrentAgile"];
         this.FCurrentIntelligence = _loc1_["CurrentIntelligence"];
         this.FCurrentLife = _loc1_["CurrentLife"];
         this.FNextPower = _loc1_["NextPower"];
         this.FNextAgile = _loc1_["NextAgile"];
         this.FNextIntelligence = _loc1_["NextIntelligence"];
         this.FNextLife = _loc1_["NextLife"];
         this.FKnifeOfKillSoulAdded = _loc1_["property"]["KnifeAdd"];
      }
      
      protected function SpiritSchoolUIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISchoolItem = null;
         this.FSP_LevelLimit = this.FMainSpiritSchoolScene["MC_LevelLimit"];
         this.FTF_NowLv = this.FMainSpiritSchoolScene["MC_Title"]["TF_Lv"];
         this.FTF_FreeNum = this.FMainSpiritSchoolScene["TF_FreeNum"];
         this.FTF_ItemNum = this.FMainSpiritSchoolScene["TF_ItemNum"];
         this.FSP_VipLimit = this.FMainSpiritSchoolScene["MC_VipLimit"];
         this.FSP_VipLimit.visible = false;
         this.FSP_List = this.FMainSpiritSchoolScene["MC_List"];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.OnMove = this.SchoolOkOnMove;
         this.FBtn_Ok.OnOut = this.BtnOnOut;
         this.FBtn_Ok.Substrate = this.FMainSpiritSchoolScene["Btn_Ok"];
         this.FBtn_Ok.OnClick = this.SpiritSchoolTrainOnClick;
         this.FBtn_OneKey = new TUIButton();
         this.FBtn_OneKey.OnMove = this.SchoolOneKeyOkOnMove;
         this.FBtn_OneKey.OnOut = this.BtnOnOut;
         this.FBtn_OneKey.Substrate = this.FMainSpiritSchoolScene["Btn_OneKey"];
         this.FBtn_OneKey.OnClick = this.SpiritSchoolTrainOneKeyOnClick;
         _loc2_ = COUNT_SPIRITSCHOOL;
         this.FMC_SchoolItems = new Vector.<TUISchoolItem>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISchoolItem(this);
            _loc3_.Perform_UIDispatch(this.FSP_List["MC_Item_" + _loc1_]);
            this.FMC_SchoolItems[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIWindowSchoolConfirm = new TUIWindowConfirmation(Parent);
         this.FUIWindowSchoolConfirm.OnOK = this.WindowSchoolOnOK;
         this.FUIWindowSchoolConfirm.OnCancel = this.WindowSchoolOnCancel;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowSchoolConfirm);
         this.FNoMoreQuestion = false;
         this.FUIWindowSchoolConfirm.SetCheckBoxUsable(true);
      }
      
      protected function SpiritSchoolTrainOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FSpiritSchoolTrainNum = SPIRITSCHOOLTRAINNUM;
         if(this.FNoMoreQuestion)
         {
            this.RequestSchoolTrain(this.FSpiritSchoolTrainNum);
         }
         else
         {
            this.FUIWindowSchoolConfirm.visible = true;
            this.FUIWindowSchoolConfirm.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_18);
         }
      }
      
      protected function SpiritSchoolTrainOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FSpiritSchoolTrainNum = SPIRITSCHOOLONEKEYTRAINNUM;
         if(this.FNoMoreQuestion)
         {
            this.RequestSchoolTrain(this.FSpiritSchoolTrainNum);
         }
         else
         {
            this.FUIWindowSchoolConfirm.visible = true;
            this.FUIWindowSchoolConfirm.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_19);
         }
      }
      
      protected function AttributeUILocation() : void
      {
      }
      
      protected function UpdateAttribute() : void
      {
         var _loc1_:TKnifeOfKillSoulData = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         this.ResetAttribute();
         _loc1_ = SLogicsCore.Character.KnifeOfKillSoul.GetByIndentifier(SLogicsCore.Character.KnifeSoul.ChangedID);
         this.AssginKnifeSoulInfor(this.FKnifeSoul);
         _loc2_ = 1;
         if(_loc1_ != null)
         {
            this.FKnifeOfKillSoulAdded.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_3),_loc1_.KnifeSoulAdded);
            _loc2_ = _loc1_.KnifeSoulAdded / 100;
         }
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_6);
         this.FCurrentPower.htmlText = TUtilityString.Format(_loc3_,int((this.FKnifeSoul.Power + this.FKnifeSoul.AddedPower) * _loc2_));
         this.FCurrentAgile.htmlText = TUtilityString.Format(_loc3_,int((this.FKnifeSoul.Agile + this.FKnifeSoul.AddedAgile) * _loc2_));
         this.FCurrentIntelligence.htmlText = TUtilityString.Format(_loc3_,int((this.FKnifeSoul.Intelligence + this.FKnifeSoul.AddedIntelligence) * _loc2_));
         this.FCurrentLife.htmlText = TUtilityString.Format(_loc3_,int((this.FKnifeSoul.Life + this.FKnifeSoul.AddedLife) * _loc2_));
         if(this.FKnifeSoul.NextID == 0)
         {
            return;
         }
         this.FToolKnifeSoul.ID = this.FKnifeSoul.NextID;
         this.AssginKnifeSoulInfor(this.FToolKnifeSoul);
         this.FNextPower.text = "+" + (this.FToolKnifeSoul.Power - this.FKnifeSoul.Power).toString();
         this.FNextAgile.text = "+" + (this.FToolKnifeSoul.Agile - this.FKnifeSoul.Agile).toString();
         this.FNextIntelligence.text = "+" + (this.FToolKnifeSoul.Intelligence - this.FKnifeSoul.Intelligence).toString();
         this.FNextLife.text = "+" + (this.FToolKnifeSoul.Life - this.FKnifeSoul.Life).toString();
      }
      
      protected function ResetAttribute() : void
      {
         this.FNextPower.text = "";
         this.FNextAgile.text = "";
         this.FNextIntelligence.text = "";
         this.FNextLife.text = "";
         this.FKnifeOfKillSoulAdded.text = "";
      }
      
      protected function AssginKnifeSoulInfor(param1:TKnifeSoulData) : void
      {
         var _loc2_:TKnifeSoul = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeSoul,param1.ID) as TKnifeSoul;
         param1.Power = _loc2_.Power;
         param1.Agile = _loc2_.Agile;
         param1.Intelligence = _loc2_.Intelligence;
         param1.Life = _loc2_.Life;
         param1.NextID = _loc2_.NextID;
         param1.Level = _loc2_.Level;
         param1.NeedExp = _loc2_.NeedExp;
      }
      
      protected function ExpBarUIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FMainKnifeSoulScene["ExpBar"];
         this.FTF_CurrentLeveL = _loc1_["Level"];
         this.FTF_EXP = _loc1_["Exp"];
         this.FExpBar = _loc1_["RedBar"]["RedBarMask"];
      }
      
      protected function ExpBarUILocation() : void
      {
      }
      
      protected function UpdateExpBar() : void
      {
         this.FTF_CurrentLeveL.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_0),this.FKnifeSoul.Level);
         if(this.FKnifeSoul.NextID == 0)
         {
            this.FTF_EXP.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_1);
            this.FExpBar.scaleX = 0;
         }
         else
         {
            this.FTF_EXP.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_2),this.FKnifeSoul.CurrentExp,this.FKnifeSoul.NeedExp);
            this.FExpBar.scaleX = this.FKnifeSoul.CurrentExp / this.FKnifeSoul.NeedExp;
         }
      }
      
      protected function BaseInforUIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         this.FTF_TrainPellet = this.FMainKnifeSoulScene["TrainPellet"];
         this.FTF_CurrentLeveLLimit = this.FMainKnifeSoulScene["CurrentLeveLLimit"];
         this.FTF_NextSegmentLevelLimit = this.FMainKnifeSoulScene["NextSegmentLevelLimit"];
         _loc1_ = this.FMainKnifeSoulScene["description"];
         this.FColorBall = this.FMainKnifeSoulScene["Ball"];
         this.FEffectTop = this.FColorBall["EffectTop"];
         this.FEffectMiddle = this.FColorBall["EffectMiddle"];
         this.FEffectBottom = this.FColorBall["EffectBottom"];
      }
      
      protected function BaseInforUILocation() : void
      {
      }
      
      protected function UpdateBaseInfor() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TKnifeSoul = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = SLogicsCore.Character.Appliances;
         this.FTF_TrainPellet.text = "" + _loc1_.GetCountByTempleteID(CONST_KNIFESOUL.KNIFESOUL_PELLETID);
         this.FCurrentLevelLimit = this.GetKnifeSoulLevelLimit();
         this.FTF_CurrentLeveLLimit.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_4),this.FCurrentLevelLimit);
         _loc2_ = this.GetNextSegementKnifeSoulLevelLimit();
         this.FLevelLimit = _loc2_.Level;
         if(_loc2_.Level == this.FCurrentLevelLimit)
         {
            this.FTF_NextSegmentLevelLimit.text = "";
         }
         else
         {
            this.FTF_NextSegmentLevelLimit.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_5),_loc2_.HeroLevelLimit,_loc2_.Level);
         }
         _loc3_ = this.FKnifeSoul.Level >= 80 ? 80 : this.FKnifeSoul.Level;
         _loc4_ = int(Math.ceil(_loc3_ / 10));
         this.FColorBall.gotoAndStop(_loc4_);
         this.FEffectBottom.stop();
         this.FEffectTop.stop();
         this.FEffectMiddle.stop();
         this.FEffectBottom.visible = false;
         this.FEffectTop.visible = false;
         this.FEffectMiddle.visible = false;
         if(_loc4_ == 1)
         {
            this.FEffectBottom.play();
            this.FEffectBottom.visible = true;
         }
         else if(_loc4_ == 8)
         {
            this.FEffectTop.play();
            this.FEffectTop.visible = true;
         }
         else
         {
            this.FEffectMiddle.play();
            this.FEffectMiddle.visible = true;
         }
      }
      
      protected function ResetBaseInfor() : void
      {
      }
      
      protected function GetKnifeSoulLevelLimit() : int
      {
         var _loc1_:* = 0;
         var _loc2_:TBins = null;
         var _loc3_:TKnifeSoul = null;
         var _loc4_:int = 0;
         _loc4_ = int(SLogicsCore.Character.GetMainLevel());
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeSoul);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_) as TKnifeSoul;
            if(_loc3_.HeroLevelLimit > _loc4_)
            {
               _loc1_--;
               break;
            }
            _loc1_++;
         }
         _loc1_ = _loc1_ >= _loc2_.Count ? int(_loc1_ - 1) : int(_loc1_);
         _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_) as TKnifeSoul;
         return _loc3_.Level;
      }
      
      protected function GetNextSegementKnifeSoulLevelLimit() : TKnifeSoul
      {
         var _loc1_:int = 0;
         var _loc2_:TBins = null;
         var _loc3_:TKnifeSoul = null;
         var _loc4_:int = 0;
         _loc4_ = int(SLogicsCore.Character.GetMainLevel());
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeSoul);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_) as TKnifeSoul;
            if(_loc3_.HeroLevelLimit > _loc4_)
            {
               _loc4_ = _loc3_.HeroLevelLimit;
               break;
            }
            _loc1_++;
         }
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_) as TKnifeSoul;
            if(_loc3_.HeroLevelLimit > _loc4_)
            {
               _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_ - 1) as TKnifeSoul;
               break;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function BtnUIDispatch() : void
      {
         this.FBtn_NormalTrain = new TUIButton();
         this.FBtn_NormalTrain.Substrate = this.FMainKnifeSoulScene["NormalTrain"];
         this.FBtn_TrainOfOneKey = new TUIButton();
         this.FBtn_TrainOfOneKey.Substrate = this.FMainKnifeSoulScene["TrainOfOneKey"];
         this.FBtn_HighGradeTrain = new TUIButton();
         this.FBtn_HighGradeTrain.Substrate = this.FMainKnifeSoulScene["GoldTrain"];
         this.FBtn_LimitTrain = new TUIButton();
         this.FBtn_LimitTrain.Substrate = this.FMainKnifeSoulScene["LimitTrain"];
         this.FBtn_Close = this.FMainScene["Board"]["Close"];
         this.FBtn_Help = new TUIButton();
         this.FBtn_Help.Substrate = this.FMainScene["Board"]["Help"];
         this.FHitHelp.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_KnifeSoul);
      }
      
      protected function BtnUILocation() : void
      {
         this.FBtn_NormalTrain.OnClick = this.NormalTrainBtnClick;
         this.FBtn_NormalTrain.OnMove = this.TrainBtnOnMove;
         this.FBtn_NormalTrain.OnOut = this.BtnOnOut;
         this.FBtn_TrainOfOneKey.OnClick = this.TrainOfOneKeyBtnClick;
         this.FBtn_TrainOfOneKey.OnMove = this.TrainBtnOnMove;
         this.FBtn_TrainOfOneKey.OnOut = this.BtnOnOut;
         this.FBtn_HighGradeTrain.OnClick = this.HighGradeBtnClick;
         this.FBtn_HighGradeTrain.OnMove = this.TrainBtnOnMove;
         this.FBtn_HighGradeTrain.OnOut = this.BtnOnOut;
         this.FBtn_LimitTrain.OnClick = this.LimitGradeBtnClick;
         this.FBtn_LimitTrain.OnMove = this.TrainBtnOnMove;
         this.FBtn_LimitTrain.OnOut = this.BtnOnOut;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         this.FBtn_Help.OnMove = this.HelpBtnOnMove;
         this.FBtn_Help.OnOut = this.HelpBtnOnOut;
      }
      
      protected function UpdateBtn() : void
      {
         this.FBtn_TrainOfOneKey.Enabled = SLogicsCore.Character.VipData.OneTimePet;
         this.FBtn_LimitTrain.Enabled = SLogicsCore.Character.VipData.OneTimePet;
      }
      
      protected function RequestTrain(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeTrainRequest);
         _loc3_.Data.writeShort(param1);
         _loc3_.Data.writeByte(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function RequestSchoolTrain(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SpiritSchoolTrainReq);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function NormalTrainBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCurrentLevelLimit <= this.FKnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_16));
         }
         else
         {
            this.RequestTrain(1,CONST_KNIFESOUL.TRAINTYPE_NORMAL);
         }
      }
      
      protected function TrainOfOneKeyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCurrentLevelLimit <= this.FKnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_16));
         }
         else
         {
            this.RequestTrain(CONST_KNIFESOUL.TRAINTYPE_BATHTRAINNUM,CONST_KNIFESOUL.TRAINTYPE_NORMAL);
         }
      }
      
      protected function HighGradeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCurrentLevelLimit <= this.FKnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_16));
         }
         else if(this.FCostGoldWidthNoQuestion)
         {
            this.RequestTrain(1,CONST_KNIFESOUL.TRAINTYPE_GOAL);
         }
         else
         {
            this.FUIWindowConfirmation.visible = true;
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_11);
            this.FCostTime = 1;
         }
      }
      
      protected function LimitGradeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:int = 0;
         if(this.FCurrentLevelLimit <= this.FKnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_16));
         }
         else if(this.FCostGoldWidthNoQuestion)
         {
            this.RequestTrain(CONST_KNIFESOUL.TRAINTYPE_BATHTRAINNUM,CONST_KNIFESOUL.TRAINTYPE_GOAL);
         }
         else
         {
            this.FUIWindowConfirmation.visible = true;
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_13);
            this.FCostTime = CONST_KNIFESOUL.TRAINTYPE_BATHTRAINNUM;
         }
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.ResetBaseInfor();
      }
      
      protected function TrainBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = param2.currentTarget as MovieClip;
         if(_loc3_ == this.FBtn_NormalTrain.Substrate)
         {
            this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_10);
         }
         else if(_loc3_ == this.FBtn_TrainOfOneKey.Substrate)
         {
            if(SLogicsCore.Character.VipData.OneTimePet)
            {
               this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_12);
            }
            else
            {
               this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_14);
            }
         }
         else if(_loc3_ == this.FBtn_HighGradeTrain.Substrate)
         {
            this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_11);
         }
         else if(_loc3_ == this.FBtn_LimitTrain.Substrate)
         {
            if(SLogicsCore.Character.VipData.OneTimePet)
            {
               this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_13);
            }
            else
            {
               this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_15);
            }
         }
         if(this.FOnHitMove != null)
         {
            this.FOnHitMove(this,this.FHit);
         }
      }
      
      protected function HelpBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHitHelp);
      }
      
      protected function HelpBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHitHelp);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHitOut != null)
         {
            this.FOnHitOut(this,this.FHit);
         }
      }
      
      protected function SchoolOneKeyOkOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_19);
         if(this.FOnHitMove != null)
         {
            this.FOnHitMove(this,this.FHit);
         }
      }
      
      protected function SchoolOkOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHit.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_18);
         if(this.FOnHitMove != null)
         {
            this.FOnHitMove(this,this.FHit);
         }
      }
      
      protected function ToolUIDispatch() : void
      {
         this.FUIWindowConfirmation = new TUIWindowConfirmation(Parent);
         this.FUIWindowConfirmation.OnOK = this.WindowOnOK;
         this.FUIWindowConfirmation.OnCancel = this.WindowOnCancel;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
      }
      
      protected function ToolUILocation() : void
      {
         this.FCostGoldWidthNoQuestion = false;
         this.FUIWindowConfirmation.SetCheckBoxUsable(true);
      }
      
      protected function WindowOnOK(param1:Object) : void
      {
         if(this.FUIWindowConfirmation.IsSelected)
         {
            this.FCostGoldWidthNoQuestion = true;
         }
         this.RequestTrain(this.FCostTime,CONST_KNIFESOUL.TRAINTYPE_GOAL);
      }
      
      protected function WindowOnCancel(param1:Object) : void
      {
      }
      
      protected function WindowSchoolOnOK(param1:Object) : void
      {
         if(this.FUIWindowSchoolConfirm.IsSelected)
         {
            this.FNoMoreQuestion = true;
         }
         this.RequestSchoolTrain(this.FSpiritSchoolTrainNum);
      }
      
      protected function WindowSchoolOnCancel(param1:Object) : void
      {
         this.FUIWindowSchoolConfirm.IsSelected = false;
         this.FNoMoreQuestion = false;
      }
      
      protected function TabClick(param1:Object) : void
      {
         this.SwitchTab(param1 as int);
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.FCurrentVisibleWindowIndex = param1;
         this.FMainKnifeSoulScene.visible = false;
         this.FMainSpiritSchoolScene.visible = false;
         if(this.FCurrentVisibleWindowIndex == 0)
         {
            this.Update();
         }
         else
         {
            this.UpdateSchool();
         }
      }
      
      protected function InitConfig() : void
      {
         var _loc1_:TConfigValue = null;
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SpiritSchool_ItemID) as TConfigValue;
         this.FSpiritSchool_ItemID = _loc1_.Value as uint;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SpiritSchool_OnceCost) as TConfigValue;
         this.FSpiritSchool_OnceCost = _loc1_.Value as uint;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SpiritSchool_FreeNum) as TConfigValue;
         this.FSpiritSchool_FreeNum = _loc1_.Value as uint;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SpiritSchool_LvLimit) as TConfigValue;
         this.FSpiritSchoolLvLimit = _loc1_.Value as uint;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SpiritSchool_VipLimit) as TConfigValue;
         this.FSpiritSchoolVipLimit = _loc1_.Value as uint;
      }
      
      protected function SchoolIsClose(param1:Object, param2:MouseEvent) : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_1));
      }
      
      public function set OnHitOut(param1:Function) : void
      {
         this.FOnHitOut = param1;
      }
      
      public function set OnHitMove(param1:Function) : void
      {
         this.FOnHitMove = param1;
      }
      
      public function set Data_School(param1:TSpiritSchoolData) : void
      {
         this.FData_School = param1;
      }
      
      public function Update() : void
      {
         this.UpdateAttribute();
         this.UpdateExpBar();
         this.UpdateBtn();
         this.UpdateBaseInfor();
         this.FMainKnifeSoulScene.visible = true;
         this.FMainSpiritSchoolScene.visible = false;
      }
      
      public function UpdateSchool() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         var _loc5_:TInventory = null;
         var _loc6_:TUnlock = null;
         if(this.FCurrentVisibleWindowIndex != 1)
         {
            return;
         }
         this.InitConfig();
         _loc3_ = 0;
         _loc4_ = SLogicsCore.Character.Appliances;
         _loc3_ = uint(_loc4_.GetCountByTempleteID(this.FSpiritSchool_ItemID));
         this.FTF_ItemNum.text = _loc3_.toString();
         _loc2_ = this.FMC_SchoolItems.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_SchoolItems[_loc1_].UpdateUI(_loc1_,this.FData_School);
            _loc1_++;
         }
         this.FTF_NowLv.text = this.FData_School.NowLv.toString();
         this.FTF_FreeNum.text = (this.FSpiritSchool_FreeNum - this.FData_School.FreeNum).toString();
         this.FSP_LevelLimit.visible = false;
         this.FSP_LevelLimit.visible = true;
         this.FBtn_Ok.Enabled = false;
         this.FBtn_OneKey.Enabled = false;
         _loc6_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_KnifeSoulSchool);
         if(_loc6_ != null)
         {
            if(_loc6_.State == TUnlock.UNLOCKSTATE_Unlocked)
            {
               this.FSP_LevelLimit.visible = false;
               this.FBtn_Ok.Enabled = true;
               this.FBtn_OneKey.Enabled = true;
            }
         }
         if(this.FData_School.IsOver == 1)
         {
            this.FBtn_Ok.OnClick = this.SchoolIsClose;
            this.FBtn_OneKey.OnClick = this.SchoolIsClose;
         }
         if(SLogicsCore.Character.VipLevel < this.FSpiritSchoolVipLimit)
         {
            this.FBtn_OneKey.Enabled = false;
            this.FSP_VipLimit.visible = true;
         }
         else
         {
            this.FSP_VipLimit.visible = false;
         }
         this.FMainSpiritSchoolScene.visible = true;
         this.FMainKnifeSoulScene.visible = false;
      }
      
      public function UIDispatch() : void
      {
         this.UIDispatch_Perform();
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function Reset() : void
      {
         this.FEffectBottom.stop();
         this.FEffectTop.stop();
         this.FEffectMiddle.stop();
         this.FEffectBottom.visible = false;
         this.FEffectTop.visible = false;
         this.FEffectMiddle.visible = false;
      }
   }
}

