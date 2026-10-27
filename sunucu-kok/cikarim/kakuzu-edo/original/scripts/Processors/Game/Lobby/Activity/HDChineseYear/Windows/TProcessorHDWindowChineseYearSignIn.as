package Processors.Game.Lobby.Activity.HDChineseYear.Windows
{
   import Components.Standard.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityChineseYear.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityChineseYear.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowChineseYearSignIn extends THDOSTabWindowBase
   {
      
      protected static const COUNT_MC_SingleDate:uint = 20;
      
      protected var FDataSignIn:TActivityChineseYearSignIn;
      
      protected var FHDSignIn:THDChineseYearSignIn;
      
      protected var FUnstreamizerActivityChineseYear:TUnstreamizerActivityChineseYear;
      
      protected var FDateVect:Vector.<TUISignInSingle>;
      
      protected var FMC_SelectVect:Vector.<Sprite>;
      
      protected var FCurSignInInfo:TActivityDateSign;
      
      protected var FMC_GiftBag:MovieClip;
      
      protected var FMC_OpenGiftBagEffect:MovieClip;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FAwardIDs:Vector.<uint>;
      
      protected var FInventoriesVect:Vector.<TInventories>;
      
      public function TProcessorHDWindowChineseYearSignIn(param1:TUIComponent)
      {
         super(param1);
         this.FDataSignIn = new TActivityChineseYearSignIn();
         FActivityID = CONST_ACTIVITY_MODE.Activity_ChineseYearSignIn;
         this.FUnstreamizerActivityChineseYear = new TUnstreamizerActivityChineseYear();
         this.FDateVect = new Vector.<TUISignInSingle>(COUNT_MC_SingleDate);
         this.FAwardIDs = new Vector.<uint>();
         this.FInventoriesVect = new Vector.<TInventories>();
         this.FMC_SelectVect = new Vector.<Sprite>(COUNT_MC_SingleDate - 1);
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISignInSingle = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ChineseYearSignIn) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc2_ = int(COUNT_MC_SingleDate);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISignInSingle(this);
            _loc3_.OnSceneOut = this.ProcessorSignInOnOut;
            _loc3_.OnSceneOver = this.ProcessorSignInOnOver;
            _loc3_.Perform_UIDispatch(FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Boxes + _loc1_]);
            this.FDateVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FMC_AlreadyGet = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FMC_AlreadyGet.mouseChildren = false;
         this.FMC_AlreadyGet.mouseEnabled = false;
         this.FMC_AlreadyGet.visible = false;
         this.FMC_GiftBag = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_GiftBag];
         this.FMC_GiftBag.mouseChildren = false;
         this.FMC_GiftBag.addEventListener(MouseEvent.MOUSE_MOVE,this.McGiftBagOnOver);
         this.FMC_GiftBag.addEventListener(MouseEvent.MOUSE_OUT,this.McGiftBagOnOut);
         this.FMC_OpenGiftBagEffect = this.FMC_GiftBag[CONST_ACTIVITY.RESOURCE_Link_MC_OpenGiftBagEffect];
         this.FMC_OpenGiftBagEffect.mouseChildren = false;
         this.FMC_OpenGiftBagEffect.mouseEnabled = false;
         this.FMC_OpenGiftBagEffect.visible = false;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.ProcessorBtnOKOnClick;
         this.FBtn_OK.Visible = false;
         _loc2_ = COUNT_MC_SingleDate - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_SelectVect[_loc1_] = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Select + _loc1_];
            this.FMC_SelectVect[_loc1_].mouseChildren = false;
            this.FMC_SelectVect[_loc1_].mouseEnabled = false;
            this.FMC_SelectVect[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FMC_OpenGiftBagEffect != null)
         {
            if(this.FMC_OpenGiftBagEffect.currentFrame == this.FMC_OpenGiftBagEffect.totalFrames)
            {
               this.FMC_OpenGiftBagEffect.stop();
               this.FMC_OpenGiftBagEffect.visible = false;
            }
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUIConfig();
         this.FHDSignIn = FHDActivityConfig as THDChineseYearSignIn;
         _loc2_ = int(this.FHDSignIn.DateSigns.length);
         this.FAwardIDs.length = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardIDs.push(this.FHDSignIn.DateSigns[_loc1_].Award[0]);
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
         this.FDataSignIn = param1 as TActivityChineseYearSignIn;
         this.ProcessorCheckEffects();
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc2_ = COUNT_MC_SingleDate - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDateVect[_loc1_].UpdateUI(this.FDataSignIn.GetSignByIndex(_loc1_));
            if(this.FDataSignIn.GetSignByIndex(_loc1_).IsCur)
            {
               this.FMC_SelectVect[_loc1_].visible = true;
            }
            else
            {
               this.FMC_SelectVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
         if(this.FCurSignInInfo.Status >= Activity_CanReceive)
         {
            this.FBtn_OK.Visible = true;
         }
         else if(this.FCurSignInInfo.Status == Activity_AlreadyReceive)
         {
            this.FBtn_OK.Visible = false;
         }
         this.ProcessorSetGiftBagStatus();
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FUnstreamizerActivityChineseYear.UnstreamizeUpdateChineseYearSignIn(FActivityInitRetData,this.FDataSignIn,this.FHDSignIn);
         this.FormatCurDate();
         this.UpdateDataBase(this.FDataSignIn);
      }
      
      protected function ProcessorSetGiftBagStatus(param1:Boolean = false) : void
      {
         this.FMC_OpenGiftBagEffect.stop();
         this.FMC_OpenGiftBagEffect.visible = false;
         if(this.FCurSignInInfo.Status == Activity_AlreadyReceive)
         {
            this.FMC_AlreadyGet.visible = true;
            this.FMC_GiftBag.gotoAndStop(2);
         }
         else
         {
            this.FMC_AlreadyGet.visible = false;
            this.FMC_GiftBag.gotoAndStop(1);
         }
         if(param1)
         {
            this.FMC_OpenGiftBagEffect.gotoAndPlay(1);
            this.FMC_OpenGiftBagEffect.visible = true;
         }
      }
      
      protected function ProcessorCheckEffects() : void
      {
         var _loc1_:TActivityDateSign = null;
         _loc1_ = this.FDataSignIn.GetCurSign();
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.Status >= Activity_CanReceive)
         {
            FActivityAtoms.Status = Activity_CanReceive;
         }
         else
         {
            FActivityAtoms.Status = Activity_CanNotReceive;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,FActivityAtoms.Status);
         }
      }
      
      protected function FormatCurDate() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TActivityDateSign = null;
         _loc1_ = uint(STimingCore.ServerTime);
         _loc2_ = Math.floor((_loc1_ - FActivityAtoms.StartTime) / CONST_ACTIVITY.ALLDAY_TIME);
         if(_loc2_ > COUNT_MC_SingleDate)
         {
            _loc2_ = 0;
         }
         this.FDataSignIn.SetCurSignByUniqueIndex((this.FCurSignInInfo = this.FDataSignIn.GetSignByIndex(_loc2_)).Index);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         _loc2_ = int(COUNT_MC_SingleDate);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDateVect[_loc1_].Clear();
            _loc1_++;
         }
         this.FMC_OpenGiftBagEffect.stop();
         this.FMC_OpenGiftBagEffect.visible = false;
      }
      
      protected function ProcessorBtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurSignInInfo = this.FDataSignIn.GetCurSign();
         if(this.FCurSignInInfo == null)
         {
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurSignInInfo.Index);
      }
      
      protected function ProcessorSignInOnOver(param1:uint) : void
      {
         var _loc2_:TInventories = null;
         var _loc3_:int = 0;
         _loc3_ = this.FDataSignIn.GetIndexByUniqueIndex(param1);
         if(_loc3_ == -1)
         {
            return;
         }
         ProcessorOnGiftBoxMove(this,this.FInventoriesVect[_loc3_],null);
      }
      
      protected function ProcessorSignInOnOut(param1:uint) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function McGiftBagOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FCurSignInInfo == null)
         {
            return;
         }
         _loc2_ = this.FDataSignIn.GetIndexByUniqueIndex(this.FCurSignInInfo.Index);
         if(_loc2_ == -1)
         {
            return;
         }
         ProcessorOnGiftBoxMove(this,this.FInventoriesVect[_loc2_]);
      }
      
      protected function McGiftBagOnOut(param1:MouseEvent) : void
      {
         if(this.FCurSignInInfo == null)
         {
            return;
         }
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         Perform_CS_ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.FDataSignIn.GetSignByUniqueIndex(param2.Index).Status = param2.Status;
         this.FormatCurDate();
         this.UpdateDataBase(this.FDataSignIn);
         this.ProcessorSetGiftBagStatus(true);
      }
   }
}

