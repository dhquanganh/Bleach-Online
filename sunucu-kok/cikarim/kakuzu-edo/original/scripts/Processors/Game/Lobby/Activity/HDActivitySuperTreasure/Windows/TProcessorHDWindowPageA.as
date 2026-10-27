package Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDSuperTreasure;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDActivitySingle.TActivitySingleSuperTreasure;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Component.TUIActivitySingleAwardTypeA;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowPageA extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_Award:uint = 3;
      
      protected var FAwardList:Vector.<TUIActivitySingleAwardTypeA>;
      
      protected var FHDSuperTreasure:THDSuperTreasure;
      
      protected var FDataSuperTreasure:TActivitySingleSuperTreasure;
      
      public function TProcessorHDWindowPageA(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_PageTypeA;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivitySingleAwardTypeA = null;
         var _loc5_:Sprite = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_Award);
         this.FAwardList = new Vector.<TUIActivitySingleAwardTypeA>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc2_];
            _loc4_ = new TUIActivitySingleAwardTypeA(this);
            _loc4_.Perform_UIDispatch(_loc5_);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.Visible = false;
            this.FAwardList[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.UpdateUIConfig();
         this.FHDSuperTreasure = FHDActivityConfig as THDSuperTreasure;
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDSuperTreasure.Page1Awards);
         _loc2_ = int(COUNT_MC_Award);
         _loc4_ = int(this.FHDSuperTreasure.Page1.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FPageIndex * COUNT_MC_Award + _loc1_;
            if(_loc3_ < _loc4_)
            {
               this.FAwardList[_loc1_].Visible = true;
               this.FAwardList[_loc1_].ProcessorUpdateConfigUI(_loc3_,this.FHDSuperTreasure.Page1[_loc3_].Prompt,FInventoriesVect[_loc3_],this.FHDSuperTreasure.Page1[_loc3_].Gold);
            }
            else
            {
               this.FAwardList[_loc1_].Visible = false;
               this.FAwardList[_loc1_].Clear();
            }
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super.UpdateDataBase(param1);
         this.FDataSuperTreasure = param1 as TActivitySingleSuperTreasure;
         _loc3_ = int(this.FHDSuperTreasure.Page1.length);
         FBoxStatus = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = int(this.FHDSuperTreasure.Page1[_loc2_].Index);
            _loc5_ = this.FHDSuperTreasure.Page1[_loc2_].Count - this.FDataSuperTreasure.StatusInfos.GetStatusInfoByLimitID(_loc4_).Count;
            if(_loc5_ >= Activity_CanReceive)
            {
               _loc6_ = Activity_CanReceive;
            }
            else
            {
               _loc6_ = Activity_AlreadyReceive;
            }
            FBoxStatus[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         super.UpdateUI();
         _loc2_ = int(this.FAwardList.length);
         _loc3_ = int(this.FHDSuperTreasure.Page1.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = FPageIndex * COUNT_MC_Award + _loc1_;
            if(_loc6_ < _loc3_)
            {
               _loc5_ = this.FHDSuperTreasure.Page1[_loc6_].Index;
               _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_33),this.FDataSuperTreasure.StatusInfos.GetStatusInfoByLimitID(_loc5_).Count,this.FHDSuperTreasure.Page1[_loc6_].Count);
               this.FAwardList[_loc1_].ProcessorUpdateUI(_loc4_);
               this.FAwardList[_loc1_].ProcessorUpdateBtn(FBoxStatus[_loc6_]);
               this.FAwardList[_loc1_].Visible = true;
            }
            else
            {
               this.FAwardList[_loc1_].Clear();
               this.FAwardList[_loc1_].Visible = false;
            }
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FAwardList != null && this.FAwardList.length > 0)
         {
            _loc2_ = int(this.FAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardList[_loc1_].Clear();
               _loc1_++;
            }
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSuperTreasure.Page1[FPageIndex * COUNT_MC_Award + FBoxIndex].Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      override protected function WindowInformationOnCancel(param1:Object) : void
      {
         super.WindowInformationOnCancel(param1);
         this.FAwardList[FBoxIndex].ProcessorUpdateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
         FBoxIndex = param2;
         if(FCharacter.CreditGold >= this.FHDSuperTreasure.Page1[FPageIndex * COUNT_MC_Award + FBoxIndex].Gold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHDSuperTreasure.Page1[FBoxIndex].Gold);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(this.FHDSuperTreasure.Page1[FBoxIndex].Gold);
            FUIWindowRecharge.Visible = true;
            this.FAwardList[FBoxIndex].ProcessorUpdateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
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

