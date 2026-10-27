package Processors.Game.Lobby.Activity.HDActivityGiftBag.windows
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityGB.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Rendering.Overlayers.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowGBSevenDayNew extends TProcessorWindowGiftBase
   {
      
      protected static const Activity_SevenDayGiftBag:uint = CONST_ACTIVITY_MODE.Activity_SevenDayGiftBag;
      
      protected static const COUNT_MC_AwardDayFirst:uint = 3;
      
      protected static const COUNT_MC_AwardDaySecond:uint = 4;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FBoxStage:int;
      
      protected var FHDGBSevenDay:THDGBSevenDay;
      
      protected var FDataGBSevenDay:TActivityGBSevenDay;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FAwardPrompt:Vector.<String>;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FGiftOverLayer:TOverlayer;
      
      protected var FAwardMcList:Vector.<Sprite>;
      
      protected var FCurChip:uint;
      
      protected var FBtn_Left:TUIButton;
      
      protected var FBtn_Right:TUIButton;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_Chips:Sprite;
      
      protected var FMC_ChipFirst:Sprite;
      
      protected var FMC_ChipSecond:Sprite;
      
      protected var FMC_TipList:Vector.<MovieClip>;
      
      protected var FMC_BorderList:Vector.<MovieClip>;
      
      protected var FMC_ComingList:Vector.<Sprite>;
      
      protected var FMC_AlreadyGetList:Vector.<Sprite>;
      
      protected var FBtn_OKList:Vector.<TUIButton>;
      
      public function TProcessorWindowGBSevenDayNew(param1:TUIComponent)
      {
         super(param1);
         ActivityID = Activity_SevenDayGiftBag;
         this.FDataGBSevenDay = new TActivityGBSevenDay();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_SevenDayNew) as Sprite;
         addChild(FMC);
         this.FBtn_Left = new TUIButton();
         this.FBtn_Left.Substrate = FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
         this.FBtn_Left.OnClick = this.ShowChipFirst;
         this.FBtn_Right = new TUIButton();
         this.FBtn_Right.Substrate = FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
         this.FBtn_Right.OnClick = this.ShowChipSecond;
         this.FMC_Effect = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_effect];
         this.FMC_Chips = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Chips];
         this.FMC_ChipFirst = this.FMC_Chips[CONST_ACTIVITY.RESOURCE_Link_MC_ChipFirst];
         this.FMC_ChipSecond = this.FMC_Chips[CONST_ACTIVITY.RESOURCE_Link_MC_ChipSecond];
         _loc2_ = int(COUNT_MC_AwardDayFirst);
         _loc3_ = int(COUNT_MC_AwardDaySecond);
         _loc4_ = _loc2_ + _loc3_;
         this.FMC_TipList = new Vector.<MovieClip>(_loc4_);
         this.FMC_BorderList = new Vector.<MovieClip>(_loc4_);
         this.FMC_ComingList = new Vector.<Sprite>(_loc4_);
         this.FMC_AlreadyGetList = new Vector.<Sprite>(_loc4_);
         this.FBtn_OKList = new Vector.<TUIButton>(_loc4_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_ + 1)
         {
            this.FMC_TipList[_loc1_] = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_MC_Tip + _loc1_];
            this.FMC_TipList[_loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.ShowTipOnMove);
            this.FMC_TipList[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.HideTipOnOut);
            this.FMC_BorderList[_loc1_] = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_MC_Border + _loc1_];
            this.FMC_ComingList[_loc1_] = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_MC_Coming + _loc1_];
            this.FMC_AlreadyGetList[_loc1_] = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGetBag + _loc1_];
            this.FBtn_OKList[_loc1_] = new TUIButton();
            this.FBtn_OKList[_loc1_].Substrate = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_Btn_OK + _loc1_];
            this.FBtn_OKList[_loc1_].OnClick = this.BoxOnClick;
            _loc1_++;
         }
         _loc1_ = _loc2_ + 1;
         while(_loc1_ < _loc2_ + _loc3_)
         {
            this.FMC_TipList[_loc1_] = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_MC_Tip + _loc1_];
            this.FMC_TipList[_loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.ShowTipOnMove);
            this.FMC_TipList[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.HideTipOnOut);
            this.FMC_BorderList[_loc1_] = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_MC_Border + _loc1_];
            this.FMC_ComingList[_loc1_] = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_MC_Coming + _loc1_];
            this.FMC_AlreadyGetList[_loc1_] = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGetBag + _loc1_];
            this.FBtn_OKList[_loc1_] = new TUIButton();
            this.FBtn_OKList[_loc1_].Substrate = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_Btn_OK + _loc1_];
            this.FBtn_OKList[_loc1_].OnClick = this.BoxOnClick;
            _loc1_++;
         }
         this.FMC_Effect.play();
         super.InitWindow();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySevenDayNew);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function ShowTipOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxOver != null)
         {
            FOnGiftBoxOver(this,this.FAwardInventories[_loc2_]);
         }
      }
      
      protected function HideTipOnOut(param1:MouseEvent) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function ShowChipFirst(param1:Object = null, param2:uint = 0) : void
      {
         this.FMC_ChipFirst.visible = this.FBtn_Right.Enabled = true;
         this.FMC_ChipSecond.visible = this.FBtn_Left.Enabled = false;
      }
      
      protected function ShowChipSecond(param1:Object = null, param2:uint = 0) : void
      {
         this.FMC_ChipSecond.visible = this.FBtn_Left.Enabled = true;
         this.FMC_ChipFirst.visible = this.FBtn_Right.Enabled = false;
      }
      
      protected function SetAwardDayStatus(param1:uint, param2:int) : void
      {
         switch(param2)
         {
            case Activity_CanReceive:
               this.FBtn_OKList[param1].Visible = true;
               this.FBtn_OKList[param1].Enabled = true;
               this.FMC_AlreadyGetList[param1].visible = false;
               this.FMC_ComingList[param1].visible = false;
               this.FMC_BorderList[param1].play();
               break;
            case Activity_CanNotReceive:
               this.FBtn_OKList[param1].Visible = false;
               this.FBtn_OKList[param1].Enabled = false;
               this.FMC_AlreadyGetList[param1].visible = false;
               this.FMC_ComingList[param1].visible = true;
               this.FMC_BorderList[param1].gotoAndStop(1);
               this.FMC_BorderList[param1].visible = false;
               break;
            case Activity_AlreadyReceive:
               this.FBtn_OKList[param1].Visible = false;
               this.FBtn_OKList[param1].Enabled = false;
               this.FMC_AlreadyGetList[param1].visible = true;
               this.FMC_ComingList[param1].visible = false;
               this.FMC_BorderList[param1].gotoAndStop(1);
               this.FMC_BorderList[param1].visible = false;
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         if(FBoxStatus == null)
         {
            return;
         }
         _loc2_ = int(FBoxStatus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetAwardDayStatus(_loc1_,FBoxStatus[_loc1_]);
            _loc1_++;
         }
         this.FMC_Effect.play();
      }
      
      override protected function UpdateDataBase(param1:ByteArray) : void
      {
         super.UpdateDataBase(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         FUnstreamizerActivityGB.UnstreamizeUpdateSevenDayGiftBag(this.FDataGBSevenDay,FActivityInitRetData);
         FDataActivity = this.FDataGBSevenDay;
         FBoxStatus = this.FDataGBSevenDay.BoxStatus;
         CheckActivityStatusNotification();
         FIsInitWindow = true;
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         if(this.FDataGBSevenDay.BoxStatus == null || !FIsInitWindow)
         {
            ProcessorOnActiveInfoReq();
            return;
         }
         this.FDataGBSevenDay.BoxStatus[param1] = param2;
         CheckActivityStatusNotification();
         ++this.FDataGBSevenDay.CurCount;
         if(CheckActivityEnding())
         {
            ProcessorWindowClose();
            return;
         }
         this.UpdateUI();
      }
      
      override protected function GetConfig(param1:TActivityAtoms) : void
      {
         super.GetConfig(param1);
         this.FHDGBSevenDay = FHDActivityConfig as THDGBSevenDay;
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(this.FHDGBSevenDay.AwardValueVect);
      }
      
      protected function BoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.name.split("_")[2]);
         ActivityGetBoxReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      protected function CheckChips() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc3_ = FBoxStatus.indexOf(Activity_CanReceive);
         if(_loc3_ >= 0 && _loc3_ < 4)
         {
            this.ShowChipFirst();
            return;
         }
         if(_loc3_ > 3 && _loc3_ < 7)
         {
            this.ShowChipSecond();
            return;
         }
         _loc3_ = FBoxStatus.indexOf(Activity_CanNotReceive);
         if(_loc3_ >= 0 && _loc3_ < 4)
         {
            this.ShowChipFirst();
            return;
         }
         if(_loc3_ > 3 && _loc3_ < 7)
         {
            this.ShowChipSecond();
            return;
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FMC_Chips == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < COUNT_MC_AwardDayFirst + 1)
         {
            this.FMC_TipList[_loc1_] = this.FMC_ChipFirst[CONST_ACTIVITY.RESOURCE_Link_MC_Tip + _loc1_];
            _loc1_++;
         }
         _loc1_ = COUNT_MC_AwardDayFirst + 1;
         while(_loc1_ < COUNT_MC_AwardDayFirst + COUNT_MC_AwardDaySecond)
         {
            this.FMC_TipList[_loc1_] = this.FMC_ChipSecond[CONST_ACTIVITY.RESOURCE_Link_MC_Tip + _loc1_];
            _loc1_++;
         }
         this.CheckChips();
         this.FMC_Effect.stop();
         if(this.FMC_BorderList == null)
         {
            return;
         }
         _loc2_ = this.FMC_BorderList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_BorderList[_loc1_].stop();
            _loc1_++;
         }
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         if(!FIsInitWindow)
         {
            ActivityInitReq(FActivityAtoms.Identifier);
         }
         else
         {
            this.UpdateUI();
         }
      }
      
      override public function Hide() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Hide();
         this.DoClear();
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         if(this.Visible)
         {
            FBoxStatus[param2.Index] = param2.Status;
         }
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
      
      override public function ActivityInitRet(param1:ByteArray, param2:TActivityAtoms) : void
      {
         super.ActivityInitRet(param1,param2);
         FActivityAtoms = param2;
         this.UpdateDataBase(param1);
         this.CheckChips();
      }
   }
}

