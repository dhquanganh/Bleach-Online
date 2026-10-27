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
   import Logics.HDActivityRecharge.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitFund.*;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowFundLevel extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_Award:uint = 2;
      
      protected static const COUNT_Slot_Award:uint = 4;
      
      protected static const BOX_NUM:uint = 3;
      
      protected var FFundLvBin:THDGrowFundLv;
      
      protected var FFundLvData:THDFundLvData;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FUnstreamizerActivityFund:TUnstreamizerActivityFund;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FAwardIndex:int;
      
      protected var FCharacter:TCharacter;
      
      public function TProcessorWindowFundLevel(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_FundLv;
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(BOX_NUM);
         this.FUnstreamizerActivityFund = new TUnstreamizerActivityFund();
         this.FAwardIndex = -1;
         this.FCharacter = SLogicsCore.Character;
         this.FFundLvData = new THDFundLvData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityFund);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FAwardListVect != null && this.FAwardListVect.length > 0)
         {
            _loc2_ = int(this.FAwardListVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardListVect[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_FundLevel) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc2_ = int(BOX_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc3_.OnSlotOver = ProcessorOnSlotOver;
            _loc3_.OnSlotOut = ProcessorOnSlotOut;
            _loc3_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award][CONST_ACTIVITY.RESOURCE_Link_MC_Boxes + _loc1_];
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Award,COUNT_Slot_Award,false);
            this.FAwardListVect[_loc1_] = _loc3_;
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
         this.FFundLvBin = FHDActivityConfig as THDGrowFundLv;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateFundLevel();
      }
      
      private function UpdateFundLevel() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:TFundLvAwardData = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:TInventory = null;
         _loc6_ = new Vector.<String>();
         _loc2_ = this.FAwardListVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_.length = 0;
            _loc4_ = this.FAwardListVect[_loc1_];
            _loc7_ = this.FFundLvData.GetAwardByIndex(_loc1_);
            _loc5_ = new TInventories();
            FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc5_,_loc7_.InventoriesId);
            _loc6_.push(_loc7_.Name);
            _loc6_.push(_loc7_.Gold.toString());
            _loc4_.UpDateUI(_loc1_,_loc5_,_loc6_);
            if(_loc7_.State != CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               _loc4_.UpDateBtn(_loc7_.State);
            }
            else if(this.FCharacter.GetMainLevel() >= _loc7_.Level)
            {
               _loc4_.UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            }
            else
            {
               _loc4_.UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanNotReceive);
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
         var _loc6_:TFundLvAwardData = null;
         _loc4_ = Activity_CanNotReceive;
         _loc6_ = this.FFundLvData.GetAwardByIndex(param1);
         _loc6_.State = param2;
         _loc6_ = this.FFundLvData.GetAwardByIndex(this.FFundLvData.CountForAward() - 1);
         if(_loc6_.State == Activity_AlreadyReceive)
         {
            _loc4_ = Activity_AlreadyReceive;
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
         this.FFundLvBin = FHDActivityConfig as THDGrowFundLv;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FFundLvData);
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      private function SetData(param1:TActivityInitRetData, param2:THDFundLvData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TFundLvAwardData = null;
         param2.ClearAward();
         _loc4_ = param1.BuyStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.BuyStates[_loc3_];
            _loc6_ = new TFundLvAwardData();
            _loc6_.State = _loc5_.State;
            _loc6_.BoxIndex = _loc5_.BoxIndex;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         this.FUnstreamizerActivityFund.UnstreamizeUpdateFundLevel(param2,this.FFundLvBin);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TFundLvAwardData = null;
         var _loc4_:uint = 0;
         this.FAwardIndex = param2;
         _loc3_ = this.FFundLvData.GetAwardByIndex(this.FAwardIndex);
         _loc4_ = this.FCharacter.CreditGold;
         if(_loc4_ >= _loc3_.Gold)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_.Gold);
            this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowRecharge.SetGoldNum(_loc3_.Gold);
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
         var _loc3_:TAwardData = null;
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FFundLvData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         this.UpdateUI();
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

