package Processors.Game.Lobby.Activity.HDActivityGiftBag.windows
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityGB.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowGBLevel extends TProcessorWindowGiftBase
   {
      
      protected static const Activity_LevelGiftBag:uint = CONST_ACTIVITY_MODE.Activity_LevelGiftBag;
      
      protected static const COUNT_Slot_Award:uint = 6;
      
      protected static const COUNT_Prompt_Award:uint = 1;
      
      protected static const COUNT_MC_Award:uint = 10;
      
      protected static const HEIGHT_Record:uint = 65;
      
      protected static const HEIGHT_BarList:uint = 266;
      
      protected static const PROFESSIONS_TYPE:Vector.<uint> = Vector.<uint>([1,2,3]);
      
      protected var FMC_List:MovieClip;
      
      protected var FMC_Record:MovieClip;
      
      protected var FTF_Title:String;
      
      protected var FMC_AlreadyGet:MovieClip;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_Slot:Vector.<TUISlot>;
      
      protected var FTF_Subscript:String;
      
      protected var FMC_Bmp_Icon:MovieClip;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FHDGBLevel:THDGBLevel;
      
      protected var FDataGBLevel:TActivityGBLevel;
      
      protected var FAwardMcList:Vector.<Sprite>;
      
      protected var FCharacter:TCharacter;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      public function TProcessorWindowGBLevel(param1:TUIComponent)
      {
         super(param1);
         ActivityID = Activity_LevelGiftBag;
         this.FDataGBLevel = new TActivityGBLevel();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityLeveGiftBag);
      }
      
      override protected function InitWindow() : void
      {
         FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_LevelGiftBag) as Sprite;
         addChild(FMC);
         super.InitWindow();
         this.FMC_List = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         this.FUIScrollBar = new TScrollBar(this.FMC_List,242,false,0,73);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
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
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function GetConfig(param1:TActivityAtoms) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Sprite = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:uint = 0;
         super.GetConfig(param1);
         this.FCharacter = SLogicsCore.Character;
         switch(this.FCharacter.Profession)
         {
            case 4:
               _loc7_ = 0;
               break;
            case 1:
               _loc7_ = 1;
               break;
            case 3:
               _loc7_ = 2;
         }
         this.FHDGBLevel = FHDActivityConfig as THDGBLevel;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDGBLevel.AwardValueVect[_loc7_]);
         this.FAwardPromptVect = this.FHDGBLevel.AwardPromptVect;
         _loc3_ = int(this.FAwardInventoriesVect.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc6_ = new Vector.<String>(COUNT_Prompt_Award);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSLevelBag) as Sprite;
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_Prompt_Award,COUNT_Slot_Award);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            this.FUIScrollBar.AddItem(_loc4_);
            _loc4_.y = _loc2_ * HEIGHT_Record;
            this.FAwardListVect[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FUIScrollBar.Visible = true;
      }
      
      protected function SetTopRecord(param1:uint, param2:uint, param3:Vector.<int>) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.length;
         _loc4_ = _loc6_ - Math.round(param1 / param2);
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc5_ = param3.indexOf(Activity_CanReceive);
         if(_loc5_ > _loc4_)
         {
            _loc5_ = _loc4_;
         }
         if(_loc5_ > -1)
         {
            this.FUIScrollBar.CurBarPosY = param2 * _loc5_;
            return;
         }
         _loc5_ = param3.indexOf(Activity_CanNotReceive);
         if(_loc5_ > -1)
         {
            this.FUIScrollBar.CurBarPosY = param2 * _loc5_;
            return;
         }
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         ActivityGetBoxReq(FActivityAtoms.Identifier,param2);
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
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUI();
         if(FBoxStatus == null)
         {
            return;
         }
         _loc2_ = int(FBoxStatus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
         }
         if(this.FAwardListVect == null)
         {
            return;
         }
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new Vector.<String>(COUNT_Prompt_Award);
            _loc3_[0] = this.FAwardPromptVect[_loc1_];
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_],_loc3_);
            this.FAwardListVect[_loc1_].UpDateBtn(FBoxStatus[_loc1_]);
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:ByteArray) : void
      {
         super.UpdateDataBase(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         FUnstreamizerActivityGB.UnstreamizeUpdateLevelGiftBag(this.FDataGBLevel,FActivityInitRetData);
         FDataActivity = this.FDataGBLevel;
         FBoxStatus = this.FDataGBLevel.BoxStatus;
         CheckActivityStatusNotification();
         FIsInitWindow = true;
         if(this.Visible)
         {
            this.UpdateUI();
            this.SetTopRecord(HEIGHT_BarList,HEIGHT_Record,FBoxStatus);
         }
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         if(this.FDataGBLevel.BoxStatus == null || !FIsInitWindow)
         {
            ProcessorOnActiveInfoReq();
            return;
         }
         this.FDataGBLevel.BoxStatus[param1] = param2;
         CheckActivityStatusNotification();
         if(this.CheckActivityEnding())
         {
            ProcessorWindowClose();
            return;
         }
         this.UpdateUI();
      }
      
      override public function Hide() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Hide();
      }
      
      override protected function CheckActivityEnding() : Boolean
      {
         var _loc1_:Boolean = false;
         if(FBoxStatus.indexOf(Activity_CanNotReceive) == -1 && FBoxStatus.indexOf(Activity_CanReceive) == -1)
         {
            _loc1_ = true;
            FActivityModes.DeleteByIdentifier(FActivityAtoms.Identifier);
            if(FCheckOnOff != null)
            {
               FCheckOnOff(this);
            }
         }
         return _loc1_;
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
      }
   }
}

