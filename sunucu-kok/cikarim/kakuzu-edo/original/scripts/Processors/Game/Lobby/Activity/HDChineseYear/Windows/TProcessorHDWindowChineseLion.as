package Processors.Game.Lobby.Activity.HDChineseYear.Windows
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityChineseYear.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityChineseYear.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowChineseLion extends THDOSTabWindowBase
   {
      
      protected static const COUNT_AWARD_Lion:uint = 3;
      
      protected static const COUNT_TF_Lion:uint = 4;
      
      protected static const COUNT_MC_Eyes:uint = 6;
      
      protected var FBtn_Award:TUIButton;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FBtn_Drum:TUIButton;
      
      protected var FMC_Drum:MovieClip;
      
      protected var FMC_NoOpenVect:Vector.<Sprite>;
      
      protected var FMC_LionVect:Vector.<Sprite>;
      
      protected var FMC_LionSelectVect:Vector.<Sprite>;
      
      protected var FMC_LionEyesVect:Vector.<MovieClip>;
      
      protected var FMC_AwardVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FDataLion:TActivityChineseYearLion;
      
      protected var FHDLion:THDNewYearEgg;
      
      protected var FAwardIDs:Vector.<uint>;
      
      protected var FInventoriesVect:Vector.<TInventories>;
      
      protected var FUnstreamizerActivityChineseYear:TUnstreamizerActivityChineseYear;
      
      protected var FIsGetAward:Boolean;
      
      protected var FBuyBoxIndex:int;
      
      public function TProcessorHDWindowChineseLion(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_NewYear;
         this.FUnstreamizerActivityChineseYear = new TUnstreamizerActivityChineseYear();
         this.FAwardIDs = new Vector.<uint>();
         this.FInventoriesVect = new Vector.<TInventories>();
         this.FIsGetAward = false;
         this.FDataLion = new TActivityChineseYearLion();
         this.FBuyBoxIndex = -1;
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ChineseYearLion) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FBtn_Award = new TUIButton();
         this.FBtn_Award.Substrate = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_Award.OnClick = this.BtnAwardOnClick;
         this.FMC_AlreadyGet = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FBtn_Drum = new TUIButton();
         this.FBtn_Drum.Substrate = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_Btn_Drum];
         this.FBtn_Drum.OnOver = this.DrumOnOver;
         this.FBtn_Drum.OnOut = this.DrumOnOut;
         this.FMC_Drum = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_Btn_Drum][CONST_ACTIVITY.RESOURCE_Link_MC_Drum];
         this.FMC_Drum.mouseChildren = false;
         this.FMC_Drum.mouseEnabled = false;
         this.FMC_Drum.stop();
         _loc2_ = int(COUNT_AWARD_Lion);
         this.FMC_LionVect = new Vector.<Sprite>(_loc2_);
         this.FMC_LionSelectVect = new Vector.<Sprite>(_loc2_);
         this.FMC_LionEyesVect = new Vector.<MovieClip>(COUNT_MC_Eyes);
         this.FMC_NoOpenVect = new Vector.<Sprite>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_LionVect[_loc1_] = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_LionElement + _loc1_];
            this.FMC_LionVect[_loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.LionAwardOnOver);
            this.FMC_LionVect[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.LionAwardOnOut);
            this.FMC_LionSelectVect[_loc1_] = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_LionSelect + _loc1_];
            this.FMC_LionSelectVect[_loc1_].mouseChildren = false;
            this.FMC_LionSelectVect[_loc1_].mouseEnabled = false;
            this.FMC_LionSelectVect[_loc1_].visible = false;
            this.FMC_NoOpenVect[_loc1_] = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_NoOpen + _loc1_];
            this.FMC_NoOpenVect[_loc1_].mouseChildren = false;
            this.FMC_NoOpenVect[_loc1_].mouseEnabled = false;
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_Eyes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_LionEyesVect[_loc1_] = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_LionEyes + _loc1_];
            this.FMC_LionEyesVect[_loc1_].mouseChildren = false;
            this.FMC_LionEyesVect[_loc1_].mouseEnabled = false;
            this.FMC_LionEyesVect[_loc1_].stop();
            _loc1_++;
         }
         _loc2_ = int(COUNT_AWARD_Lion);
         this.FMC_AwardVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnBtnOkClick = this.BtnBuyOnClick;
            _loc3_.Perform_UIDispatch(FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Awards + _loc1_],COUNT_TF_Lion,0,false);
            this.FMC_AwardVect[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUIConfig();
         this.FHDLion = FHDActivityConfig as THDNewYearEgg;
         _loc2_ = int(this.FHDLion.LionList.length);
         this.FAwardIDs.length = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardIDs.push(this.FHDLion.LionList[_loc1_].Awards[0]);
            _loc1_++;
         }
         this.FInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FAwardIDs);
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataLion = param1 as TActivityChineseYearLion;
         this.ProcessorCheckEffects();
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUI();
         _loc2_ = int(COUNT_AWARD_Lion);
         _loc3_ = new Vector.<String>(COUNT_TF_Lion);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FDataLion.GetAwardByIndex(_loc1_ + 1).DefaultCost.toString();
            _loc3_[1] = this.FDataLion.GetAwardByIndex(_loc1_ + 1).Cost.toString();
            if(this.FDataLion.GetAwardByIndex(_loc1_ + 1).Limit == 1)
            {
               _loc3_[2] = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_50);
            }
            else
            {
               _loc3_[2] = this.FormatBuyCount(this.FDataLion.GetAwardByIndex(_loc1_ + 1)) + "/" + this.FDataLion.GetAwardByIndex(_loc1_ + 1).Limit;
            }
            _loc3_[3] = this.FDataLion.GetAwardByIndex(_loc1_ + 1).RateStr;
            this.FMC_AwardVect[_loc1_].UpDateUI(_loc1_ + 1,null,_loc3_);
            _loc1_++;
         }
         this.UpdateAwardBuyBtn();
         this.UpdateAwardGetBtn();
         this.ProcessorPlayMCDrum();
      }
      
      protected function FormatBuyCount(param1:TActivityLion) : uint
      {
         var _loc2_:uint = 0;
         if(param1.Status == Activity_AlreadyReceive)
         {
            _loc2_ = param1.Limit;
         }
         else
         {
            _loc2_ = param1.Limit - param1.Status;
         }
         return _loc2_;
      }
      
      protected function UpdateAwardGetBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityLion = null;
         _loc3_ = this.FDataLion.GetAwardData();
         if(_loc3_.Status >= Activity_CanReceive)
         {
            this.FBtn_Award.Enabled = true;
            this.FBtn_Award.Visible = true;
            this.FMC_AlreadyGet.visible = false;
         }
         else if(_loc3_.Status == Activity_CanNotReceive)
         {
            this.FBtn_Award.Enabled = false;
            this.FBtn_Award.Visible = true;
            this.FMC_AlreadyGet.visible = false;
         }
         else if(_loc3_.Status == Activity_AlreadyReceive)
         {
            this.FBtn_Award.Enabled = false;
            this.FBtn_Award.Visible = false;
            this.FMC_AlreadyGet.visible = true;
         }
         _loc2_ = int(COUNT_AWARD_Lion);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc3_.Status == Activity_CanNotReceive)
            {
               this.FMC_NoOpenVect[_loc1_].visible = true;
            }
            else
            {
               this.FMC_NoOpenVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateAwardBuyBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(COUNT_AWARD_Lion);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardVect[_loc1_].UpDateBtn(this.FDataLion.GetAwardByIndex(_loc1_ + 1).Status);
            _loc1_++;
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FUnstreamizerActivityChineseYear.UnstreamizeUpdateChineseYearLion(FActivityInitRetData,this.FDataLion,this.FHDLion);
         this.UpdateDataBase(this.FDataLion);
      }
      
      protected function ProcessorPlayMCDrum() : void
      {
         if(this.FMC_Drum == null)
         {
            return;
         }
         if(this.FDataLion.GetAwardByIndex(0).Status == Activity_CanReceive)
         {
            this.FMC_Drum.play();
         }
         else
         {
            this.FMC_Drum.stop();
         }
      }
      
      protected function ProcessorCheckEffects() : void
      {
         var _loc1_:TActivityLion = null;
         _loc1_ = this.FDataLion.GetAwardData();
         if(_loc1_ != null)
         {
            if(_loc1_.Status == Activity_CanReceive)
            {
               FActivityAtoms.Status = Activity_CanReceive;
            }
            else
            {
               FActivityAtoms.Status = Activity_CanNotReceive;
            }
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,FActivityAtoms.Status);
         }
      }
      
      protected function ProcessorPlayMCLionEyes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FMC_LionEyesVect == null || this.FMC_LionEyesVect.length <= 0)
         {
            return;
         }
         _loc2_ = int(COUNT_MC_Eyes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_LionEyesVect[_loc1_].play();
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FMC_Drum == null)
         {
            return;
         }
         this.FMC_Drum.stop();
         _loc2_ = int(COUNT_MC_Eyes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_LionEyesVect[_loc1_].stop();
            _loc1_++;
         }
         _loc2_ = int(COUNT_AWARD_Lion);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardVect[_loc1_].Clear();
            _loc1_++;
         }
      }
      
      protected function BtnAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FIsGetAward = true;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,0);
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:int) : void
      {
         this.FBuyBoxIndex = param2;
         if(SLogicsCore.Character.CreditGold >= this.FDataLion.GetAwardByUniqueIndex(param2).Cost)
         {
            FTabUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FDataLion.GetAwardByUniqueIndex(param2).Cost);
            FTabUIWindowConfirmation.OnOK = this.TabWindowInformationOnOK;
            FTabUIWindowConfirmation.OnCancel = TabWindowInformationOnCancel;
            FTabUIWindowConfirmation.Visible = true;
         }
         else
         {
            FTabUIWindowRecharge.Visible = true;
         }
      }
      
      override protected function TabWindowInformationOnOK(param1:Object) : void
      {
         super.TabWindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FBuyBoxIndex);
      }
      
      protected function DrumOnOver(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FInventoriesVect[0]);
      }
      
      protected function DrumOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function LionAwardOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TActivityLion = null;
         _loc4_ = this.FDataLion.GetAwardData();
         if(_loc4_ == null || _loc4_.Status == Activity_CanNotReceive)
         {
            return;
         }
         _loc3_ = param1.currentTarget.name;
         _loc2_ = int(_loc3_.split("_")[2]);
         this.FMC_LionSelectVect[_loc2_].visible = true;
         _loc2_ += 1;
         ProcessorOnGiftBoxMove(this,this.FInventoriesVect[_loc2_]);
      }
      
      protected function LionAwardOnOut(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.FDataLion.GetAwardData().Status == Activity_CanNotReceive)
         {
            return;
         }
         _loc2_ = param1.currentTarget.name;
         _loc3_ = int(_loc2_.split("_")[2]);
         this.FMC_LionSelectVect[_loc3_].visible = false;
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         Perform_CS_ActivityInitReq(param1.Identifier);
         this.ProcessorPlayMCLionEyes();
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:TActivityLion = null;
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FDataLion.GetAwardByUniqueIndex(param2.Index);
         if(_loc3_ != null)
         {
            _loc3_.Status = param2.Status;
         }
         this.ProcessorPlayMCDrum();
         this.UpdateDataBase(this.FDataLion);
      }
   }
}

