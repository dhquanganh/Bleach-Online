package Processors.Game.Lobby.Activity.HDActivityFund.Window
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityFund.*;
   import Logics.HDActivityMode.*;
   import Logics.Streamization.HDActivitFund.*;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowFundInvestment extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_Award:uint = 2;
      
      protected static const BOX_NUM:uint = 5;
      
      protected static const NO_BUY:uint = 1;
      
      protected static const ALREADY_BUY:uint = 2;
      
      protected var FFundInvestmentBin:THDGrowFundGamble;
      
      protected var FFundInvestmentData:THDFundInvestmentData;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FUnstreamizerActivityFund:TUnstreamizerActivityFund;
      
      protected var FIncomes:Vector.<MovieClip>;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FAwardIndex:int;
      
      protected var FCharacter:TCharacter;
      
      public function TProcessorWindowFundInvestment(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_FundInvestment;
         this.FFundInvestmentData = new THDFundInvestmentData();
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(BOX_NUM);
         this.FIncomes = new Vector.<MovieClip>(BOX_NUM);
         this.FUnstreamizerActivityFund = new TUnstreamizerActivityFund();
         this.FAwardIndex = -1;
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityFund);
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:MovieClip = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_FundInvestment) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc2_ = int(BOX_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award][CONST_ACTIVITY.RESOURCE_Link_MC_Boxes + _loc1_];
            _loc5_ = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_BoxeInner];
            _loc3_.Perform_UIDispatch(_loc5_,COUNT_TF_Award,0,false);
            this.FAwardListVect[_loc1_] = _loc3_;
            _loc6_ = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_InCome];
            this.FIncomes[_loc1_] = _loc6_;
            _loc1_++;
         }
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FAwardIndex);
         this.FAwardIndex = -1;
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
         this.FAwardIndex = -1;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FFundInvestmentBin = FHDActivityConfig as THDGrowFundGamble;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateFundInvestment();
      }
      
      private function UpdateFundInvestment() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:TFundInvestment = null;
         var _loc7_:String = null;
         var _loc8_:TextField = null;
         _loc5_ = new Vector.<String>();
         _loc2_ = this.FAwardListVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_.length = 0;
            _loc4_ = this.FAwardListVect[_loc1_];
            _loc6_ = this.FFundInvestmentData.GetAwardByIndex(_loc1_);
            _loc5_.push(_loc6_.NeedGold);
            _loc5_.push(_loc6_.Decs);
            _loc4_.UpDateUI(_loc1_,null,_loc5_);
            _loc4_.UpDateBtn(_loc6_.State);
            if(_loc6_.State == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               this.FIncomes[_loc1_].gotoAndStop(ALREADY_BUY);
               _loc8_ = this.FIncomes[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Money];
               _loc8_.text = _loc6_.Income.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Vouchers);
            }
            else
            {
               this.FIncomes[_loc1_].gotoAndStop(NO_BUY);
               _loc8_ = this.FIncomes[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Money];
               _loc8_.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_05),_loc6_.Range[0],_loc6_.Range[1]);
            }
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TFundInvestment = null;
         _loc4_ = Activity_AlreadyReceive;
         _loc6_ = this.FFundInvestmentData.GetAwardByIndex(param1);
         _loc6_.State = param2;
         _loc5_ = this.FFundInvestmentData.CountForAward();
         param1 = 0;
         while(param1 < _loc5_)
         {
            _loc6_ = this.FFundInvestmentData.GetAwardByIndex(param1);
            if(_loc6_.State >= Activity_CanReceive)
            {
               _loc4_ = Activity_CanReceive;
               break;
            }
            if(_loc6_.State == Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
            }
            param1++;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,_loc4_);
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDGrowFundLv,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FFundInvestmentBin = FHDActivityConfig as THDGrowFundGamble;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FFundInvestmentData);
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      private function SetData(param1:TActivityInitRetData, param2:THDFundInvestmentData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TFundInvestment = null;
         var _loc7_:uint = 0;
         param2.ClearAward();
         _loc4_ = param1.ParameterVec.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = uint(param1.ParameterVec[_loc3_]);
            _loc6_ = new TFundInvestment();
            _loc6_.Income = _loc7_;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         this.FUnstreamizerActivityFund.UnstreamizeUpdateFundInvestment(param2,this.FFundInvestmentBin);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TFundInvestment = null;
         var _loc4_:uint = 0;
         this.FAwardIndex = param2;
         _loc3_ = this.FFundInvestmentData.GetAwardByIndex(this.FAwardIndex);
         _loc4_ = this.FCharacter.CreditGold;
         if(_loc4_ >= _loc3_.NeedGold)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_.NeedGold);
            this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowRecharge.SetGoldNum(_loc3_.NeedGold);
            this.FUIWindowRecharge.Visible = true;
         }
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:TFundInvestment = null;
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FFundInvestmentData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         UpdateDataBase(this.FFundInvestmentData);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

