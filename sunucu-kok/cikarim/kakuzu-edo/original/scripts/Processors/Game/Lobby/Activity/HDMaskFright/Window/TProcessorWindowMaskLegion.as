package Processors.Game.Lobby.Activity.HDMaskFright.Window
{
   import Externals.SExternalCore;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDDailyTotalCost;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDActivityRecharge.TAwardData;
   import Logics.HDActivityRecharge.THDDailyTotalCostData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityRecharge.TUnstreamizerActivityRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDMaskFright.Component.TMaskItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowMaskLegion extends THDOSTabWindowBase
   {
      
      protected static const MASKITEM_NUM:uint = 9;
      
      protected var FDailyTotalCostBin:THDDailyTotalCost;
      
      protected var FDailyTotalCostData:THDDailyTotalCostData;
      
      protected var FStateBox:Vector.<int>;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FTF_NextNeed:TextField;
      
      protected var FTF_TodayCur:TextField;
      
      protected var FTF_Bar:TextField;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FMaskItemList:Vector.<TMaskItem>;
      
      public function TProcessorWindowMaskLegion(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_DailyTotaleCost;
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FStateBox = new Vector.<int>();
         FBoxStatus = this.FStateBox;
         this.FMaskItemList = new Vector.<TMaskItem>(MASKITEM_NUM);
         this.FDailyTotalCostData = new THDDailyTotalCostData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityMaskFright);
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TMaskItem = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_MaskLegion) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc3_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Exp];
         this.FTF_NextNeed = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_NextNeed];
         this.FTF_TodayCur = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_TodayCur];
         this.FTF_Bar = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_Bar];
         this.FMC_Bar = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         _loc2_ = int(MASKITEM_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Masks + _loc1_];
            _loc5_ = new TMaskItem(this,_loc4_);
            _loc5_.Init();
            this.FMaskItemList[_loc1_] = _loc5_;
            _loc1_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUIConfig();
         this.FDailyTotalCostBin = FHDActivityConfig as THDDailyTotalCost;
         this.FStateBox.length = this.FDailyTotalCostBin.ActAwards.length;
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
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FDailyTotalCostData = param1 as THDDailyTotalCostData;
         this.FStateBox.length = 0;
         _loc3_ = this.FDailyTotalCostData.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStateBox.push(this.FDailyTotalCostData.GetAwardByIndex(_loc2_).State);
            _loc2_++;
         }
         FBoxStatus = this.FStateBox;
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateDailyTotalCost();
      }
      
      protected function UpdateDailyTotalCost() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TAwardData = null;
         var _loc5_:TInventories = null;
         var _loc6_:TMaskItem = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         _loc2_ = MASKITEM_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FDailyTotalCostData.GetAwardByIndex(_loc1_);
            _loc6_ = this.FMaskItemList[_loc1_];
            _loc5_ = ProcessorGetInventories(_loc4_.ItemIdList[0]);
            _loc7_ = _loc5_.GetInventoryByIndex(0).Quantity;
            _loc6_.UpdateItem(_loc4_.Name,_loc7_);
            _loc6_.UpdateState(_loc4_.State);
            _loc1_++;
         }
         this.FTF_TodayCur.text = this.FDailyTotalCostData.DailyTotalCost.toString();
         _loc2_ = MASKITEM_NUM;
         _loc8_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FDailyTotalCostData.GetAwardByIndex(_loc1_);
            if(_loc4_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               _loc8_ = uint(_loc4_.Name) - this.FDailyTotalCostData.DailyTotalCost;
               break;
            }
            _loc1_++;
         }
         _loc10_ = uint(this.FDailyTotalCostData.GetAwardByIndex(MASKITEM_NUM - 1).Name);
         _loc9_ = this.FDailyTotalCostData.DailyTotalCost / _loc10_;
         if(_loc9_ > 1)
         {
            _loc9_ = 1;
         }
         this.FMC_Bar.scaleX = _loc9_;
         if(_loc1_ == MASKITEM_NUM)
         {
            this.FTF_Bar.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_18),_loc10_,_loc10_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_19));
            this.FTF_NextNeed.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_22);
         }
         else
         {
            this.FTF_Bar.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_18),this.FDailyTotalCostData.DailyTotalCost,_loc10_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_19));
            this.FTF_NextNeed.text = _loc8_.toString();
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDDailyTotalCost,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FDailyTotalCostBin = FHDActivityConfig as THDDailyTotalCost;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetDailyTotalCostData(FActivityInitRetData,this.FDailyTotalCostData);
         this.UpdateDataBase(this.FDailyTotalCostData);
      }
      
      private function SetDailyTotalCostData(param1:TActivityInitRetData, param2:THDDailyTotalCostData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TAwardData = null;
         param2.ClearAward();
         _loc4_ = param1.MailStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.MailStates[_loc3_];
            _loc6_ = new TAwardData();
            _loc6_.State = _loc5_.State;
            _loc6_.BoxIndex = _loc5_.BoxIndex;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         param2.DailyTotalCost = param1.ParameterVec[0];
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateDailyTotalCost(param2,this.FDailyTotalCostBin);
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
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
         _loc3_ = this.FDailyTotalCostData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         this.UpdateDataBase(this.FDailyTotalCostData);
      }
   }
}

