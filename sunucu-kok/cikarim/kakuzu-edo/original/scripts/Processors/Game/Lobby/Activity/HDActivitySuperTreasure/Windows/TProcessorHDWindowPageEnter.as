package Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows
{
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDSuperTreasure;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowPageEnter extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_BTN_Enter:uint = 3;
      
      protected static const COUNT_TF_Enter:uint = 1;
      
      protected var FEnterList:Vector.<TUIActivityOSAwardList>;
      
      protected var FHDSuperTreasure:THDSuperTreasure;
      
      public function TProcessorHDWindowPageEnter(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_PageEnter;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Sprite = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_BTN_Enter);
         this.FEnterList = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc2_];
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_TF_Enter,0,false);
            _loc4_.OnBtnOkClick = this.BtnEnterOnClick;
            _loc4_.UpDateUI(_loc2_,null,null);
            this.FEnterList[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUIConfig();
         this.FHDSuperTreasure = FHDActivityConfig as THDSuperTreasure;
         if(this.FEnterList != null)
         {
            _loc2_ = int(this.FEnterList.length);
            _loc3_ = new Vector.<String>(COUNT_TF_Enter);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_[0] = this.FHDSuperTreasure.EnterNames[_loc1_];
               this.FEnterList[_loc1_].UpDatePrompt(_loc3_);
               this.FEnterList[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
               _loc1_++;
            }
         }
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
      
      protected function BtnEnterOnClick(param1:Object, param2:int) : void
      {
         if(FOnBtnOkClick != null)
         {
            FOnBtnOkClick(this,param2 + 1);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this,CONST_ACTIVITY_MODE.TYPE_SuperTreasure_WindowClose);
         }
      }
   }
}

