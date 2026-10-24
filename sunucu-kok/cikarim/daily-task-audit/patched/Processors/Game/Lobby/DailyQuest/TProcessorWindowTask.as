package Processors.Game.Lobby.DailyQuest
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Characters.*;
   import Logics.Dailytask.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.DailyQuest.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTask extends TProcessorLobbyWindow
   {
      
      protected static const TARGAT_SLOTS:uint = 3;
      
      protected static const TASK_SLOTS:uint = 5;
      
      protected static const DOUBLE_TYPE:uint = 18;
      
      protected static const TASK_TYPE_ACCEPT:uint = 1;
      
      protected static const TASK_TYPE_GIVEUP:uint = 2;
      
      protected static const TASK_TYPE_FINISH:uint = 3;
      
      protected static const TASK_TYPE_FINISHNOW:uint = 4;
      
      protected static const TASK_COUNT:uint = 10;
      
      protected var FMC_Task:MovieClip;
      
      protected var FHint:THint;
      
      protected var FMC_TargetTasks:Vector.<TUISlot>;
      
      protected var FMC_FinishTargetTasks:Vector.<Sprite>;
      
      protected var FMC_RefreshTask:MovieClip;
      
      protected var FTF_ExtraPoint:TextField;
      
      protected var FTF_FinisTaskNum:TextField;
      
      protected var FTF_TaskName:TextField;
      
      protected var FTF_RewardSilver:TextField;
      
      protected var FTF_RewardPoint:TextField;
      
      protected var FTF_FinishCount:TextField;
      
      protected var FTF_Description:TextField;
      
      protected var FMC_RefreshBT:TUIButton;
      
      protected var FMC_FinishNowBT:TUIButton;
      
      protected var FMC_GiveUpTaskBT:TUIButton;
      
      protected var FMC_DoTaskBT:TUIButton;
      
      protected var FMC_FinishTaskBT:TUIButton;
      
      protected var FMC_AcceptTaskBT:TUIButton;
      
      protected var FMC_FlyPoint:MovieClip;
      
      protected var FTaskList:TUITaskList;
      
      protected var FDailytask:TDailytask;
      
      protected var FIndex:uint;
      
      protected var FIsInitialization:Boolean;
      
      protected var FType:uint;
      
      protected var FID:uint;
      
      protected var FUIWindowInformation:TUIWindowConfirmation;
      
      protected var FUIWindowRefresh:TUIWindowConfirmation;
      
      protected var FUIWindowFinishNow:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FIsRefresh:Boolean;
      
      protected var FIsFinishUnstream:Boolean;
      
      protected var FIsGiveAndAccept:Boolean;
      
      protected var FIsRefreshSelected:Boolean;
      
      protected var FIsFinishNowSelected:Boolean;
      
      protected var FTempPoint:uint;
      
      protected var FDailyTaskBin:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FOnRefrsh:Function;
      
      protected var FOnPointUpdate:Function;
      
      protected var FOnTaskReq:Function;
      
      protected var FOnGoto:Function;
      
      protected var FOnUpdateDouble:Function;
      
      protected var FOnEffectExtraPoint:Function;
      
      protected var FOnGotoMap:Function;
      
      protected var FHintOnTargetOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowTask(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FBAData = SLogicsCore.BleachAgentData;
         this.FMC_TargetTasks = new Vector.<TUISlot>(TARGAT_SLOTS);
         this.FMC_FinishTargetTasks = new Vector.<Sprite>(TARGAT_SLOTS);
         this.FHint = new THint();
         this.FDailytask = SLogicsCore.Character.DailyTask;
         this.FCharacter = SLogicsCore.Character;
         this.FMC_Task = param2;
         this.InitTask();
      }
      
      protected function InitTask() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Sprite = null;
         this.FMC_RefreshBT = new TUIButton();
         this.FMC_RefreshBT.Substrate = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_RefreshBT];
         this.FMC_RefreshBT.OnClick = this.RefreshOnClick;
         this.FMC_RefreshBT.OnOver = this.RefreshOnOver;
         this.FMC_RefreshBT.OnOut = this.RefreshOnOut;
         _loc4_ = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_BTS];
         this.FMC_FinishNowBT = new TUIButton();
         this.FMC_FinishNowBT.Substrate = _loc4_[CONST_DAILY_QUEST.RESOURCE_Link_MC_FinishNowBT];
         this.FMC_FinishNowBT.Substrate.tf_btName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_19);
         this.FMC_FinishNowBT.OnClick = this.TaskOnClick;
         this.FMC_GiveUpTaskBT = new TUIButton();
         this.FMC_GiveUpTaskBT.Substrate = _loc4_[CONST_DAILY_QUEST.RESOURCE_Link_MC_GiveUpTaskBT];
         this.FMC_GiveUpTaskBT.Substrate.tf_btName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_20);
         this.FMC_GiveUpTaskBT.OnClick = this.TaskOnClick;
         this.FMC_FinishTaskBT = new TUIButton();
         this.FMC_FinishTaskBT.Substrate = _loc4_[CONST_DAILY_QUEST.RESOURCE_Link_MC_FinishTaskBT];
         this.FMC_FinishTaskBT.Substrate.tf_btName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_21);
         this.FMC_FinishTaskBT.OnClick = this.TaskOnClick;
         this.FMC_AcceptTaskBT = new TUIButton();
         this.FMC_AcceptTaskBT.Substrate = _loc4_[CONST_DAILY_QUEST.RESOURCE_Link_MC_AcceptTaskBT];
         this.FMC_AcceptTaskBT.Substrate.tf_btName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_22);
         this.FMC_AcceptTaskBT.OnClick = this.TaskOnClick;
         this.FMC_DoTaskBT = new TUIButton();
         this.FMC_DoTaskBT.Substrate = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_DoTaskBT];
         this.FMC_DoTaskBT.OnClick = this.DoTaskOnClick;
         this.FMC_DoTaskBT.StopPropagation();
         this.FMC_DoTaskBT.Visible = false;
         this.FMC_FinishTaskBT.Visible = false;
         this.FMC_AcceptTaskBT.Visible = false;
         this.FMC_GiveUpTaskBT.Visible = false;
         this.FMC_FinishNowBT.Visible = false;
         this.FTF_ExtraPoint = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_ExtraPoint];
         this.FTF_FinisTaskNum = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_FinisTaskNum];
         this.FTF_RewardSilver = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_RewardSilver];
         this.FTF_RewardPoint = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_RewardPoint];
         this.FTF_FinishCount = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_FinishCount];
         this.FTF_Description = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_Description];
         this.FTF_TaskName = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_TF_TaskName];
         this.FMC_FlyPoint = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_FlyPoint];
         this.FMC_FlyPoint.visible = false;
         _loc2_ = TARGAT_SLOTS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_TargetTasks + _loc1_];
            _loc3_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnOver = this.TargetTaskSlotOnOverlay;
            _loc3_.OnOut = this.OnOut;
            _loc3_.Init();
            this.FMC_TargetTasks[_loc1_] = _loc3_;
            _loc4_ = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_Finishs + _loc1_];
            _loc4_.visible = false;
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            this.FMC_FinishTargetTasks[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FMC_RefreshTask = this.FMC_Task[CONST_DAILY_QUEST.RESOURCE_Link_MC_RefreshTask] as MovieClip;
         this.FTaskList = new TUITaskList(this,this.FMC_RefreshTask);
         this.FTaskList.OnTaskClick = this.TaskListOnClick;
         this.FTaskList.OnTaskOver = this.TaskOnOver;
         this.FTaskList.OnTaskOut = this.OnOut;
         this.FTaskList.TutorialNextStep = TutorialNextStep;
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRefresh = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowRefresh.OnOK = this.WindowRefreshOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowRefresh);
         this.FUIWindowRefresh.SetCheckBoxUsable(true);
         this.FUIWindowFinishNow = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowFinishNow.OnOK = this.WindowFinishNowOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowFinishNow);
         this.FUIWindowFinishNow.SetCheckBoxUsable(true);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FIsInitialization = true;
         this.FDailyTaskBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DailyTask);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_DailyTask,FParent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_DailyTask,this);
      }
      
      private function RefreshOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      private function RefreshOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<uint> = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Dailytask_Fresh) as TConfigValue;
         _loc5_ = _loc3_.Value as Vector.<uint>;
         _loc4_ = TUtilityLobby.GetItemName(_loc5_[0],1);
         if(this.FDailytask.FreshCount == 0 || this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayTaskRefreshCout) > 0)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_05);
         }
         else
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_04),_loc5_[2]);
         }
         if(this.FHintOnTargetOver != null)
         {
            this.FHintOnTargetOver(this,this.FHint);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!this.FIsInitialization)
         {
            return;
         }
         _loc2_ = this.FMC_TargetTasks.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_TargetTasks[_loc1_].Update();
            _loc1_++;
         }
         if(this.FMC_FlyPoint != null)
         {
            if(this.FMC_FlyPoint.currentFrame == 55)
            {
               if(this.FOnPointUpdate != null)
               {
                  this.FOnPointUpdate();
               }
            }
         }
      }
      
      protected function TargetTaskSlotOnOverlay(param1:Object, param2:TTargetTaskList) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:TDailyTask = null;
         var _loc7_:uint = 0;
         _loc5_ = "";
         _loc4_ = param2.EventType;
         _loc7_ = uint(this.FDailyTaskBin.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc6_ = this.FDailyTaskBin.GetDatebaseByIndex(_loc3_) as TDailyTask;
            if(_loc6_.EventType == _loc4_)
            {
               break;
            }
            _loc3_++;
         }
         _loc5_ += _loc6_.Taskname;
         if(param2.IsFinish == 0)
         {
            _loc5_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_18);
         }
         else
         {
            _loc5_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_17);
         }
         this.FHint.Caption = _loc5_;
         if(this.FHintOnTargetOver != null)
         {
            this.FHintOnTargetOver(this,this.FHint);
         }
      }
      
      protected function OnOut(param1:Object, param2:Object) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function WindowRefreshOnOK(param1:Object) : void
      {
         if(this.FOnRefrsh != null)
         {
            this.FOnRefrsh();
         }
      }
      
      protected function WindowFinishNowOnOK(param1:Object) : void
      {
         if(this.FOnTaskReq != null)
         {
            this.FOnTaskReq(this.FID,this.FType);
         }
         this.FType = 0;
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         if(this.FIsRefresh)
         {
            if(this.FOnRefrsh != null)
            {
               this.FOnRefrsh();
            }
            this.FIsRefresh = false;
            if(this.FDailytask.CurrentID == 0)
            {
               this.FIsRefreshSelected = true;
            }
         }
         if(this.FType == TASK_TYPE_GIVEUP)
         {
            if(this.FOnTaskReq != null)
            {
               this.FOnTaskReq(this.FID,this.FType);
            }
            this.FType = 0;
         }
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
         this.FIsRefresh = false;
         this.FIsGiveAndAccept = false;
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TTargetTaskList = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TTargetTaskList;
         _loc6_ = SResourcesCore.TexturesDailytaskPicture;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.EventType);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.EventType);
         }
      }
      
      protected function UpdateText(param1:TQuestDaily) : void
      {
         this.FMC_DoTaskBT.Visible = false;
         this.FMC_FinishTaskBT.Visible = false;
         this.FMC_GiveUpTaskBT.Visible = false;
         this.FMC_FinishNowBT.Visible = false;
         this.FMC_AcceptTaskBT.Visible = false;
         if(param1 == null) return;
         this.FTF_TaskName.text = param1.Name;
         this.FTF_TaskName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[param1.Rate];
         this.FTF_RewardSilver.text = param1.Rewards[0].Amount * (this.FDailytask.IsDouble == 1 ? 2 : 1) + TUtilityLobby.GetItemName(param1.Rewards[0].Type,param1.Rewards[0].Code);
         this.FTF_RewardPoint.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_15),param1.AwardPoint);
         this.FTF_FinishCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_01),param1.Identifier == this.FDailytask.CurrentID ? Math.min(this.FDailytask.CurrentProgress,param1.KillTime) : 0,param1.KillTime);
         this.FTF_Description.multiline = true;
         this.FTF_Description.wordWrap = true;
         this.FTF_Description.text = param1.Description;
         if(this.FDailytask.CurrentID != 0)
         {
            if(param1.IsGoto == 1)
            {
               this.FMC_DoTaskBT.Visible = true;
               if(param1.Identifier != this.FDailytask.CurrentID)
               {
                  this.FMC_DoTaskBT.Visible = false;
               }
            }
            this.FMC_FinishNowBT.Visible = false;
            this.FMC_AcceptTaskBT.Visible = true;
            if(param1.Identifier != this.FDailytask.CurrentID)
            {
               this.FTF_FinishCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_01),0,param1.KillTime);
            }
         }
         else
         {
            this.FMC_AcceptTaskBT.Visible = true;
         }
         if(this.FDailytask.FinishCount >= TASK_COUNT)
         {
            this.FMC_AcceptTaskBT.Visible = false;
         }
      }
      
      protected function UnderDoingUpdate() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TQuestDaily = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID);
         if(_loc2_ == null) return;
         _loc1_ = 0;
         while(_loc1_ < TASK_SLOTS)
         {
            if(_loc2_ == this.FDailytask.GetTaskByIndex(_loc1_))
            {
               _loc3_ = _loc1_;
               break;
            }
            _loc1_++;
         }
         this.FIndex = _loc3_;
         this.UpdateText(_loc2_);
         if(this.FDailytask.CurrentProgress < _loc2_.KillTime)
         {
            this.FMC_FinishNowBT.Visible = true;
            this.FMC_GiveUpTaskBT.Visible = true;
            this.FMC_AcceptTaskBT.Visible = false;
            _loc4_ = 1;
         }
         else
         {
            this.FMC_FinishTaskBT.Visible = true;
            this.FMC_FinishNowBT.Visible = false;
            this.FMC_AcceptTaskBT.Visible = false;
            this.FMC_GiveUpTaskBT.Visible = true;
            _loc4_ = 2;
         }
         this.FTaskList.SetTag(_loc4_,_loc3_);
      }
      
      protected function UpdateTargetTaskSlot() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TTargetTaskList = null;
         _loc2_ = this.FDailytask.CountForTargetTask();
         if(_loc2_ != 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FDailytask.GetTargetTaskByIndex(_loc1_);
               this.FMC_TargetTasks[_loc1_].Context = _loc3_;
               this.FMC_TargetTasks[_loc1_].Resource.visible = true;
               if(_loc3_.IsFinish == 0)
               {
                  this.FMC_TargetTasks[_loc1_].SetDefaultFilters(true);
                  this.FMC_FinishTargetTasks[_loc1_].visible = false;
               }
               else
               {
                  this.FMC_TargetTasks[_loc1_].SetDefaultFilters(false);
                  this.FMC_FinishTargetTasks[_loc1_].visible = true;
               }
               _loc1_++;
            }
            _loc1_ = _loc2_;
            while(_loc1_ < TARGAT_SLOTS)
            {
               this.FMC_TargetTasks[_loc1_].Resource.visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < TARGAT_SLOTS)
            {
               this.FMC_TargetTasks[_loc1_].Resource.visible = false;
               _loc1_++;
            }
         }
      }
      
      protected function TaskListOnClick(param1:uint) : void
      {
         var _loc2_:TQuestDaily = null;
         this.FIndex = param1;
         _loc2_ = this.FDailytask.GetTaskByIndex(this.FIndex);
         if(_loc2_ == null) return;
         if(_loc2_.Identifier == this.FDailytask.CurrentID)
         {
            this.UnderDoingUpdate();
         }
         else
         {
            this.UpdateText(_loc2_);
         }
      }
      
      protected function TaskOnOver(param1:Object, param2:uint) : void
      {
         var _loc3_:TQuestDaily = null;
         var _loc4_:uint = 0;
         _loc4_ = this.FDailytask.CountForTask();
         if(_loc4_ == 0)
         {
            return;
         }
         _loc3_ = this.FDailytask.GetTaskByIndex(param2);
         this.FHint.Caption = _loc3_.Name;
         if(this.FHintOnTargetOver != null)
         {
            this.FHintOnTargetOver(this,this.FHint);
         }
      }
      
      protected function ResetText() : void
      {
         this.FTF_TaskName.text = "";
         this.FTF_RewardSilver.text = "";
         this.FTF_RewardPoint.text = "";
         this.FTF_FinishCount.text = "";
         this.FTF_Description.text = "";
         this.FTF_FinisTaskNum.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_01),this.FDailytask.FinishCount,TASK_COUNT);
         this.FMC_DoTaskBT.Visible = false;
         this.FMC_FinishTaskBT.Visible = false;
         this.FMC_AcceptTaskBT.Visible = false;
         this.FMC_GiveUpTaskBT.Visible = false;
         this.FMC_FinishNowBT.Visible = false;
      }
      
      protected function TargetTaskUpdate(param1:TQuestDaily) : void
      {
         var _loc2_:TTargetTaskList = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         _loc6_ = 0;
         _loc5_ = false;
         _loc4_ = this.FDailytask.CountForTargetTask();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FDailytask.GetTargetTaskByIndex(_loc3_);
            if(_loc2_.EventType == param1.EventType)
            {
               if(_loc2_.IsFinish == 0)
               {
                  this.FMC_TargetTasks[_loc3_].SetDefaultFilters(false);
                  this.FMC_FinishTargetTasks[_loc3_].visible = true;
                  _loc2_.IsFinish = 1;
                  _loc5_ = true;
                  break;
               }
            }
            _loc3_++;
         }
         if(_loc5_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc2_ = this.FDailytask.GetTargetTaskByIndex(_loc3_);
               if(_loc2_.IsFinish == 1)
               {
                  _loc6_++;
               }
               _loc3_++;
            }
            if(_loc6_ == _loc4_)
            {
               this.FDailytask.Point += this.FTempPoint;
               if(this.FOnEffectExtraPoint != null)
               {
                  this.FOnEffectExtraPoint(this.FTempPoint);
               }
               this.FMC_FlyPoint.visible = true;
               this.FMC_FlyPoint.play();
               _loc4_ = this.FDailytask.CountForTargetTask();
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  this.FMC_FinishTargetTasks[_loc3_].visible = false;
                  _loc3_++;
               }
            }
         }
      }
      
      protected function UpdateTargetPoint() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = this.FDailytask.CountForTargetTask();
         if(_loc4_ != 0)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Dailytask_TargetAndPoint) as TConfigValue;
            _loc2_ = _loc1_.Value as Vector.<Object>;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc2_[_loc3_][0] == _loc4_)
               {
                  this.FTempPoint = _loc2_[_loc3_][1];
                  break;
               }
               _loc3_++;
            }
            this.FTF_ExtraPoint.visible = true;
            this.FTF_ExtraPoint.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_14),this.FTempPoint);
         }
         else
         {
            this.FTF_ExtraPoint.visible = false;
         }
      }
      
      protected function UpdateEffectList() : void
      {
         var _loc1_:TQuestDaily = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FDailytask.CountForTask();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FDailytask.GetTaskByIndex(_loc2_);
            if(_loc1_.EventType == DOUBLE_TYPE)
            {
               this.FTaskList.SetEffect(_loc2_,true);
               break;
            }
            this.FTaskList.SetEffect(_loc2_,false);
            _loc2_++;
         }
      }
      
      protected function TaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TQuestDaily = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:TUIButton = null;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = "";
         _loc8_ = param1 as TUIButton;
         switch(_loc8_)
         {
            case this.FMC_AcceptTaskBT:
               if(this.FDailytask.FinishCount >= TASK_COUNT)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_10));
                  return;
               }
               this.FID = this.FDailytask.GetTaskByIndex(this.FIndex).Identifier;
               this.FType = TASK_TYPE_ACCEPT;
               if(this.FDailytask.CurrentID != 0)
               {
                  this.FType = TASK_TYPE_GIVEUP;
                  this.FID = this.FDailytask.CurrentID;
                  this.FUIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_12);
                  this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
                  this.FUIWindowInformation.OnCancel = this.WindowInformationOnCancel;
                  this.FUIWindowInformation.Visible = true;
                  this.FIsGiveAndAccept = true;
                  return;
               }
               break;
            case this.FMC_GiveUpTaskBT:
               this.FID = this.FDailytask.CurrentID;
               this.FType = TASK_TYPE_GIVEUP;
               this.FUIWindowInformation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_06));
               this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
               this.FUIWindowInformation.OnCancel = this.WindowInformationOnCancel;
               this.FUIWindowInformation.Visible = true;
               return;
            case this.FMC_FinishTaskBT:
               this.FID = this.FDailytask.CurrentID;
               this.FType = TASK_TYPE_FINISH;
               break;
            case this.FMC_FinishNowBT:
               if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayTaskFinishCout) > 0)
               {
                  this.FID = this.FDailytask.CurrentID;
                  this.FType = TASK_TYPE_FINISHNOW;
                  if(this.FOnTaskReq != null)
                  {
                     this.FOnTaskReq(this.FID,this.FType);
                  }
                  this.FType = 0;
               }
               else
               {
                  _loc3_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID);
                  _loc6_ = uint(_loc3_.Instant[1]);
                  if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc6_)
                  {
                     this.FUIWindowRecharge.Visible = true;
                     return;
                  }
                  this.FID = this.FDailytask.CurrentID;
                  this.FType = TASK_TYPE_FINISHNOW;
                  _loc7_ = TUtilityLobby.GetItemName(_loc4_,_loc5_);
                  if(!this.FUIWindowFinishNow.IsSelected)
                  {
                     this.FUIWindowFinishNow.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_13),_loc6_);
                     this.FUIWindowFinishNow.Visible = true;
                     return;
                  }
                  if(this.FOnTaskReq != null)
                  {
                     this.FOnTaskReq(this.FID,this.FType);
                  }
                  this.FType = 0;
               }
         }
         if(this.FType != 0 && this.FID != 0)
         {
            if(this.FOnTaskReq != null)
            {
               this.FOnTaskReq(this.FID,this.FType);
            }
            this.FType = 0;
         }
      }
      
      protected function RefreshOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:String = null;
         if(this.FDailytask.FinishCount >= TASK_COUNT) return;
         if(this.FDailytask.FreshCount > 0 && this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayTaskRefreshCout) <= 0)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Dailytask_Fresh) as TConfigValue;
            _loc5_ = _loc3_.Value as Vector.<uint>;
            _loc4_ = TUtilityLobby.GetItemName(_loc5_[0],1);
            if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc5_[2])
            {
               this.FUIWindowRecharge.Visible = true;
               return;
            }
            if(this.FDailytask.CurrentID != 0)
            {
               this.FIsRefresh = true;
               _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_02);
               this.FUIWindowInformation.Text = TUtilityString.Format(_loc6_,_loc5_[2]);
               this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
               this.FUIWindowInformation.OnCancel = this.WindowInformationOnCancel;
               this.FUIWindowInformation.Visible = true;
               return;
            }
            if(this.FDailytask.FinishCount >= TASK_COUNT)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_10));
               return;
            }
            if(!this.FUIWindowRefresh.IsSelected)
            {
               _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_03);
               this.FUIWindowRefresh.Text = TUtilityString.Format(_loc6_,_loc5_[2]);
               this.FUIWindowRefresh.Visible = true;
               return;
            }
            if(this.FOnRefrsh != null)
            {
               this.FOnRefrsh();
            }
         }
         else
         {
            if(this.FDailytask.CurrentID != 0)
            {
               this.FIsRefresh = true;
               this.FUIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_11);
               this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
               this.FUIWindowInformation.OnCancel = this.WindowInformationOnCancel;
               this.FUIWindowInformation.Visible = true;
               return;
            }
            if(this.FOnRefrsh != null)
            {
               this.FOnRefrsh();
            }
         }
      }
      
      protected function TaskReset() : void
      {
         this.FDailytask.CurrentID = 0;
         this.FDailytask.CurrentProgress = 0;
         this.FDailytask.Type = 0;
         this.FTaskList.SetTag(0,9);
         this.ResetText();
      }
      
      protected function DoTaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TQuestDaily = null;
         var _loc4_:uint = 0;
         _loc3_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID);
         _loc4_ = uint(_loc3_.EventType);
         param2.stopImmediatePropagation();
         switch(_loc4_)
         {
            case CONST_DAILY_QUEST.Battle:
               ProcessorWindowClose();
               if(this.FOnGotoMap != null)
               {
                  this.FOnGotoMap(this);
               }
               return;
            case CONST_DAILY_QUEST.Arena:
               ProcessorWindowClose();
               _loc4_ = TUtilityHyperLink.HyperLink_Arena;
               break;
            case CONST_DAILY_QUEST.Tavern:
               ProcessorWindowClose();
               _loc4_ = TUtilityHyperLink.HyperLink_Tavern;
               break;
            case CONST_DAILY_QUEST.Strengthen:
               _loc4_ = TUtilityHyperLink.HyperLink_Strengthen;
               break;
            case CONST_DAILY_QUEST.Refined:
               _loc4_ = TUtilityHyperLink.HyperLink_Strengthen;
               break;
            case CONST_DAILY_QUEST.KillHeros:
               _loc4_ = TUtilityHyperLink.HyperLink_KillHeros;
               break;
            case CONST_DAILY_QUEST.Pet:
               _loc4_ = TUtilityHyperLink.HyperLink_KnifeSoul;
         }
         if(this.FOnGoto != null)
         {
            this.FOnGoto(this,_loc4_);
         }
      }
      
      public function get OnRefrsh() : Function
      {
         return this.FOnRefrsh;
      }
      
      public function set OnRefrsh(param1:Function) : void
      {
         this.FOnRefrsh = param1;
      }
      
      public function get OnPointUpdate() : Function
      {
         return this.FOnPointUpdate;
      }
      
      public function set OnPointUpdate(param1:Function) : void
      {
         this.FOnPointUpdate = param1;
      }
      
      public function get OnTaskReq() : Function
      {
         return this.FOnTaskReq;
      }
      
      public function set OnTaskReq(param1:Function) : void
      {
         this.FOnTaskReq = param1;
      }
      
      public function get OnGoto() : Function
      {
         return this.FOnGoto;
      }
      
      public function set OnGoto(param1:Function) : void
      {
         this.FOnGoto = param1;
      }
      
      public function get OnUpdateDouble() : Function
      {
         return this.FOnUpdateDouble;
      }
      
      public function set OnUpdateDouble(param1:Function) : void
      {
         this.FOnUpdateDouble = param1;
      }
      
      public function get OnEffectExtraPoint() : Function
      {
         return this.FOnEffectExtraPoint;
      }
      
      public function set OnEffectExtraPoint(param1:Function) : void
      {
         this.FOnEffectExtraPoint = param1;
      }
      
      public function get OnGotoMap() : Function
      {
         return this.FOnGotoMap;
      }
      
      public function set OnGotoMap(param1:Function) : void
      {
         this.FOnGotoMap = param1;
      }
      
      public function get HintOnTargetOver() : Function
      {
         return this.FHintOnTargetOver;
      }
      
      public function set HintOnTargetOver(param1:Function) : void
      {
         this.FHintOnTargetOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function TaskInit() : void
      {
         this.FMC_RefreshBT.Enabled = this.FDailytask.FinishCount < TASK_COUNT;
         this.FMC_RefreshTask.play();
         this.ResetText();
         this.FTaskList.SetTag(0,9);
         if(this.FDailytask.CurrentID != 0)
         {
            this.UnderDoingUpdate();
         }
         this.UpdateTargetPoint();
         this.UpdateEffectList();
         this.UpdateTargetTaskSlot();
         this.FIsFinishUnstream = true;
         this.FTaskList.UpdataTaskList();
         if(this.FDailytask.CurrentID == 0 && this.FDailytask.CountForTask() > 0)
         {
            this.TaskListOnClick(0);
         }
         this.FMC_Task.MC_TargetEffect.MC_TargetEffectInner.play();
      }
      
      public function UpdateRefresh() : void
      {
         this.FMC_RefreshTask.play();
         this.FTaskList.SetTag(0,9);
         this.TaskReset();
         this.FTaskList.UpdataTaskList();
         if(this.FDailytask.CurrentID == 0 && this.FDailytask.CountForTask() > 0)
         {
            this.TaskListOnClick(0);
         }
         this.UpdateEffectList();
      }
      
      public function Update(param1:uint) : void
      {
         var _loc2_:TQuestDaily = null;
         switch(param1)
         {
            case TASK_TYPE_ACCEPT:
               this.UnderDoingUpdate();
               break;
            case TASK_TYPE_GIVEUP:
               this.TaskReset();
               this.FTaskList.SetTag(0,9);
               if(this.FIsGiveAndAccept)
               {
                  this.FID = this.FDailytask.GetTaskByIndex(this.FIndex).Identifier;
                  this.FType = TASK_TYPE_ACCEPT;
                  if(this.FOnTaskReq != null)
                  {
                     this.FOnTaskReq(this.FID,this.FType);
                  }
                  this.FType = 0;
                  this.FIsGiveAndAccept = false;
               }
               break;
            case TASK_TYPE_FINISH:
            case TASK_TYPE_FINISHNOW:
               if(this.FOnPointUpdate != null)
               {
                  _loc2_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID);
                  this.FDailytask.Point += _loc2_.AwardPoint;
                  this.FOnPointUpdate();
               }
               if(_loc2_.EventType == CONST_DAILY_QUEST.Pay)
               {
                  if(this.FOnUpdateDouble != null)
                  {
                     this.FOnUpdateDouble();
                  }
               }
               this.TargetTaskUpdate(_loc2_);
               ++this.FDailytask.FinishCount;
               this.TaskReset();
         }
      }
      
      public function UpdateExtraText() : void
      {
         this.UpdateTargetPoint();
         this.UpdateTargetTaskSlot();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = TARGAT_SLOTS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_TargetTasks[_loc1_].Context = null;
            this.FMC_TargetTasks[_loc1_].Resource.visible = false;
            _loc1_++;
         }
         this.FTaskList.ResetBmp();
         this.FMC_Task.MC_TargetEffect.MC_TargetEffectInner.stop();
      }
   }
}

