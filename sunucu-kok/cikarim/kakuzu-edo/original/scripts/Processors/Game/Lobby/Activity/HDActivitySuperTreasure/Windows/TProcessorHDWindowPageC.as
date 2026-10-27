package Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDSuperTreasure;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDActivitySingle.TActivitySingleSuperTreasure;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowPageC extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_BOXSTAUTS_SinglePage:uint = 5;
      
      protected static const COUNT_AWARD_Major:uint = 1;
      
      protected static const COUNT_AWARD_Minor:uint = 4;
      
      protected static const COUNT_SLOT:uint = 1;
      
      protected static const COUNT_TF_Major:uint = 3;
      
      protected static const COUNT_TF_Minor:uint = 2;
      
      protected static const TAG_OnlyOne:uint = 0;
      
      protected static const TAG_MoreThanOne:uint = 1;
      
      protected var FMC_TagOne:Sprite;
      
      protected var FMC_TagMore:Sprite;
      
      protected var FTF_BuyedCount:TextField;
      
      protected var FTF_Tag0Name:TextField;
      
      protected var FTF_Tag0Desc:TextField;
      
      protected var FTF_Tag1Name:TextField;
      
      protected var FTF_Tag1Desc:TextField;
      
      protected var FTag0MajorAward:TUIActivityOSAwardList;
      
      protected var FTag0MinorAwardList:Vector.<TUIActivityOSAwardList>;
      
      protected var FTag1MajorAward:TUIActivityOSAwardList;
      
      protected var FTag1MinorAwardList:Vector.<TUIActivityOSAwardList>;
      
      protected var FHDSuperTreasure:THDSuperTreasure;
      
      protected var FDataSuperTreasure:TActivitySingleSuperTreasure;
      
      protected var FTypeResource:uint;
      
      public function TProcessorHDWindowPageC(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_PageTypeB;
         this.FTypeResource = TAG_OnlyOne;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(this.FTag0MajorAward != null && this.FMC_TagOne.visible)
         {
            this.FTag0MajorAward.UpDateSlot();
         }
         if(this.FTag0MinorAwardList != null && this.FTag0MinorAwardList.length > 0 && this.FMC_TagOne.visible)
         {
            _loc2_ = int(this.FTag0MinorAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTag0MinorAwardList[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
         if(this.FTag1MajorAward != null && this.FMC_TagMore.visible)
         {
            this.FTag1MajorAward.UpDateSlot();
         }
         if(this.FTag1MinorAwardList != null && this.FTag1MinorAwardList.length > 0 && this.FMC_TagMore.visible)
         {
            _loc2_ = int(this.FTag1MinorAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTag1MinorAwardList[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Sprite = null;
         super.InitWindow(param1);
         this.FMC_TagOne = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Tag + 0];
         this.FMC_TagOne.visible = false;
         this.FMC_TagMore = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Tag + 1];
         this.FMC_TagMore.visible = false;
         this.FTag0MajorAward = new TUIActivityOSAwardList(this);
         _loc5_ = this.FMC_TagOne[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FTag0MajorAward.OnBtnOkClick = this.ProcessorMajorBtnOnOk;
         this.FTag0MajorAward.OnSlotOver = ProcessorOnSlotOver;
         this.FTag0MajorAward.OnSlotOut = ProcessorOnSlotOut;
         this.FTag0MajorAward.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FTag0MajorAward.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FTag0MajorAward.Perform_UIDispatch(_loc5_,COUNT_TF_Major,COUNT_SLOT,false);
         _loc5_ = null;
         this.FTag1MajorAward = new TUIActivityOSAwardList(this);
         _loc5_ = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FTag1MajorAward.OnBtnOkClick = this.ProcessorMajorBtnOnOk;
         this.FTag1MajorAward.OnSlotOver = ProcessorOnSlotOver;
         this.FTag1MajorAward.OnSlotOut = ProcessorOnSlotOut;
         this.FTag1MajorAward.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FTag1MajorAward.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FTag1MajorAward.Perform_UIDispatch(_loc5_,COUNT_TF_Major,COUNT_SLOT,false);
         _loc3_ = int(COUNT_AWARD_Minor);
         this.FTag0MinorAwardList = new Vector.<TUIActivityOSAwardList>(_loc3_);
         this.FTag1MinorAwardList = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FMC_TagOne[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc2_];
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnBtnOkClick = this.ProcessorMinorBtnOnOk;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_TF_Minor,COUNT_SLOT,false);
            _loc4_.Visible = false;
            this.FTag0MinorAwardList[_loc2_] = _loc4_;
            _loc5_ = null;
            _loc4_ = null;
            _loc5_ = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc2_];
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnBtnOkClick = this.ProcessorMinorBtnOnOk;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_TF_Minor,COUNT_SLOT,false);
            _loc4_.Visible = false;
            this.FTag1MinorAwardList[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FTF_BuyedCount = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_TF_BuyTotalCount];
         this.FTF_Tag0Name = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_TF_Tag0Name];
         this.FTF_Tag0Desc = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_TF_Tag0Desc];
         this.FTF_Tag1Name = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_TF_Tag1Name];
         this.FTF_Tag1Desc = this.FMC_TagMore[CONST_ACTIVITY.RESOURCE_Link_TF_Tag1Desc];
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDSuperTreasure = FHDActivityConfig as THDSuperTreasure;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateDataBase(param1);
         this.FDataSuperTreasure = param1 as TActivitySingleSuperTreasure;
         FBoxStatus = new Vector.<int>(COUNT_BOXSTAUTS_SinglePage);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         super.UpdateUI();
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDSuperTreasure.Page3AwardsVect[FPageIndex]);
         this.UpdateBoxStatus(FPageIndex);
         if(this.FHDSuperTreasure.Page3[FPageIndex].TotalCount > TAG_MoreThanOne)
         {
            this.FTypeResource = TAG_MoreThanOne;
            this.FMC_TagOne.visible = false;
            this.FMC_TagMore.visible = true;
         }
         else
         {
            this.FTypeResource = TAG_OnlyOne;
            this.FMC_TagOne.visible = true;
            this.FMC_TagMore.visible = false;
         }
         _loc2_ = int(COUNT_BOXSTAUTS_SinglePage);
         _loc3_ = new Vector.<String>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == 0)
            {
               _loc3_.push(this.FHDSuperTreasure.Page3[FPageIndex].Value[_loc1_].Prompt);
               _loc3_.push(this.FHDSuperTreasure.Page3[FPageIndex].Value[_loc1_].Gold);
               _loc3_.push(this.FHDSuperTreasure.Page3[FPageIndex].Value[_loc1_].Prompt1);
               if(this.FTypeResource == TAG_OnlyOne)
               {
                  this.FTag0MajorAward.UpDateUI(_loc1_,FInventoriesVect[_loc1_],_loc3_);
                  this.FTag0MajorAward.UpDateBtn(FBoxStatus[_loc1_]);
               }
               else
               {
                  this.FTag1MajorAward.UpDateUI(_loc1_,FInventoriesVect[_loc1_],_loc3_);
                  this.FTag1MajorAward.UpDateBtn(FBoxStatus[_loc1_]);
               }
               _loc3_.length = 0;
            }
            else
            {
               _loc3_.push(FInventoriesVect[_loc1_].GetInventoryByIndex(0).Name);
               _loc3_.push(this.FHDSuperTreasure.Page3[FPageIndex].Value[_loc1_].Gold);
               if(this.FTypeResource == TAG_OnlyOne)
               {
                  this.FTag0MinorAwardList[_loc1_ - 1].UpDateUI(_loc1_ - 1,FInventoriesVect[_loc1_],_loc3_);
                  this.FTag0MinorAwardList[_loc1_ - 1].UpDateBtn(FBoxStatus[_loc1_]);
               }
               else
               {
                  this.FTag1MinorAwardList[_loc1_ - 1].UpDateUI(_loc1_ - 1,FInventoriesVect[_loc1_],_loc3_);
                  this.FTag1MinorAwardList[_loc1_ - 1].UpDateBtn(FBoxStatus[_loc1_]);
               }
               _loc3_.length = 0;
            }
            _loc1_++;
         }
         if(this.FTypeResource == TAG_MoreThanOne)
         {
            _loc4_ = this.FHDSuperTreasure.Page3[0].TotalCount - this.FDataSuperTreasure.Page3BuyedCount[0];
            this.FTF_BuyedCount.text = _loc4_.toString();
            this.FTF_Tag0Name.text = this.FHDSuperTreasure.Page3PromptVect[0][0];
            this.FTF_Tag0Desc.text = this.FHDSuperTreasure.Page3PromptVect[0][1];
            this.FTF_Tag1Name.text = this.FHDSuperTreasure.Page3PromptVect[1][0];
            this.FTF_Tag1Desc.text = this.FHDSuperTreasure.Page3PromptVect[1][1];
         }
      }
      
      protected function UpdateBoxStatus(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<String> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = int(COUNT_BOXSTAUTS_SinglePage);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataSuperTreasure.Page3BuyedCount[param1] >= this.FHDSuperTreasure.Page3[param1].TotalCount)
            {
               FBoxStatus[_loc2_] = Activity_AlreadyReceive;
            }
            else
            {
               _loc7_ = int(this.FHDSuperTreasure.Page3[param1].Value[_loc2_].Index);
               _loc4_ = int(this.FDataSuperTreasure.StatusInfos.GetStatusInfoByLimitID(_loc7_).Count);
               if(_loc4_ >= this.FHDSuperTreasure.Page3[param1].Value[_loc2_].Count)
               {
                  FBoxStatus[_loc2_] = Activity_AlreadyReceive;
               }
               else
               {
                  FBoxStatus[_loc2_] = Activity_CanReceive;
               }
            }
            _loc2_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FTag0MajorAward != null)
         {
            this.FTag0MajorAward.Clear();
         }
         if(this.FTag1MajorAward != null)
         {
            this.FTag1MajorAward.Clear();
         }
         if(this.FTag0MinorAwardList != null && this.FTag0MinorAwardList.length > 0)
         {
            _loc2_ = int(this.FTag0MinorAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTag0MinorAwardList[_loc1_].Clear();
               _loc1_++;
            }
         }
         if(this.FTag1MinorAwardList != null && this.FTag1MinorAwardList.length > 0)
         {
            _loc2_ = int(this.FTag1MinorAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTag1MinorAwardList[_loc1_].Clear();
               _loc1_++;
            }
         }
      }
      
      override protected function WindowInformationOnCancel(param1:Object) : void
      {
         super.WindowInformationOnCancel(param1);
         if(FBoxIndex == -1)
         {
            if(FResourcesState == TAG_OnlyOne)
            {
               this.FTag0MajorAward.UpDateBtn(Activity_CanReceive);
            }
            else
            {
               this.FTag1MajorAward.UpDateBtn(Activity_CanReceive);
            }
         }
         else if(FResourcesState == TAG_OnlyOne)
         {
            this.FTag0MinorAwardList[FBoxIndex].UpDateBtn(Activity_CanReceive);
         }
         else
         {
            this.FTag1MinorAwardList[FBoxIndex].UpDateBtn(Activity_CanReceive);
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         if(FBoxIndex == -1)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSuperTreasure.Page3[FPageIndex].Value[0].Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSuperTreasure.Page3[FPageIndex].Value[FBoxIndex + 1].Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
         }
      }
      
      protected function ProcessorMajorBtnOnOk(param1:Object, param2:int) : void
      {
         FBoxIndex = -1;
         if(FCharacter.CreditGold >= this.FHDSuperTreasure.Page3[FPageIndex].Value[0].Gold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHDSuperTreasure.Page3[FPageIndex].Value[0].Gold);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(this.FHDSuperTreasure.Page3[FPageIndex].Value[0].Gold);
            FUIWindowRecharge.Visible = true;
            if(FResourcesState == TAG_OnlyOne)
            {
               this.FTag0MajorAward.UpDateBtn(Activity_CanReceive);
            }
            else
            {
               this.FTag1MajorAward.UpDateBtn(Activity_CanReceive);
            }
         }
      }
      
      protected function ProcessorMinorBtnOnOk(param1:Object, param2:int) : void
      {
         FBoxIndex = param2;
         if(FCharacter.CreditGold >= this.FHDSuperTreasure.Page3[FPageIndex].Value[FBoxIndex + 1].Gold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHDSuperTreasure.Page3[FPageIndex].Value[FBoxIndex + 1].Gold);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(this.FHDSuperTreasure.Page3[FPageIndex].Value[FBoxIndex + 1].Gold);
            FUIWindowRecharge.Visible = true;
            if(FResourcesState == TAG_OnlyOne)
            {
               this.FTag0MinorAwardList[FBoxIndex].UpDateBtn(Activity_CanReceive);
            }
            else
            {
               this.FTag1MinorAwardList[FBoxIndex].UpDateBtn(Activity_CanReceive);
            }
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this,CONST_ACTIVITY_MODE.TYPE_SuperTreasure_PageEnter);
         }
      }
   }
}

