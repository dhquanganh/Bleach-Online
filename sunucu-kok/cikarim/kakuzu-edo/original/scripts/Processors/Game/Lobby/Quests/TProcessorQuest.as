package Processors.Game.Lobby.Quests
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Quests.*;
   import Logics.Signals.*;
   import Logics.Streamization.Quest.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Quests.QuestNew.*;
   import Processors.Game.Lobby.Shortcuts.Window.*;
   import Processors.Game.Plot.*;
   import Resources.Constants.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.operation.quest.*;
   
   public class TProcessorQuest extends TProcessorLobbyWindows
   {
      
      protected var SIZE_WIDTH_QUESTWINDOW:int = 584;
      
      protected var SIZE_HEIGHT_QUESTWINDOW:int = 400;
      
      protected var FUnstreamizerQuests:TUnstreamizerQuests;
      
      protected var FUnstreamizerFinishedQuests:TUnstreamizerFinishedQuests;
      
      protected var FUnstreamizerQuestAction:TUnstreamizerQuestAction;
      
      protected var FBaseSubQuest:TQuests;
      
      protected var FBaseMainQuest:TQuests;
      
      protected var FBaseQuests:Vector.<TQuests>;
      
      protected var FQuestMainComplete:TQuests;
      
      protected var FQuestSubComplete:TQuests;
      
      protected var FMainQuestsAlreadyAccept:TQuests;
      
      protected var FSubQuestsAlreadyAccept:TQuests;
      
      protected var FMainQuestsCanAccept:TQuests;
      
      protected var FSubQuestsCanAccept:TQuests;
      
      protected var FTaskAction:TTaskAction;
      
      protected var FQuestActionRoutines:TRegistryRoutine;
      
      protected var FWindowQuest:TProcessorWindowQuest;
      
      protected var FBoundsQuest:TBounds;
      
      protected var FQuestHandlerMainQuest:TQuestHandle;
      
      protected var FQuestHandlerBranchQuest:TQuestHandle;
      
      protected var FQuestHandlers:Vector.<TQuestHandle>;
      
      protected var FLoadQuestComplete:Boolean;
      
      protected var FOnQuestUpdate:Function;
      
      protected var FOnLoadQuestOver:Function;
      
      protected var FOnProcessorCheckPlot:Function;
      
      protected var FOnAcceptTaskEffect:Function;
      
      protected var FOnCompleteTaskEffect:Function;
      
      public function TProcessorQuest(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FUnstreamizerFinishedQuests = new TUnstreamizerFinishedQuests();
         this.FUnstreamizerQuests = new TUnstreamizerQuests();
         this.FUnstreamizerQuestAction = new TUnstreamizerQuestAction();
         this.FQuestMainComplete = SLogicsCore.Character.MainQuestComplete;
         this.FQuestSubComplete = SLogicsCore.Character.SubQuestComplete;
         this.FMainQuestsAlreadyAccept = SLogicsCore.Character.MainQuestsAlreadyAccept;
         this.FSubQuestsAlreadyAccept = SLogicsCore.Character.SubQuestsAlreadyAccept;
         this.FMainQuestsCanAccept = SLogicsCore.Character.MainQuestsCanAccept;
         this.FSubQuestsCanAccept = SLogicsCore.Character.SubQuestsCanAccept;
         this.FBaseMainQuest = SLogicsCore.Character.MainQuestBase;
         this.FBaseSubQuest = SLogicsCore.Character.SubQuestBase;
         this.FBaseQuests = new Vector.<TQuests>();
         this.FBaseQuests.push(this.FBaseMainQuest);
         this.FBaseQuests.push(this.FBaseSubQuest);
         this.FTaskAction = new TTaskAction();
         this.FQuestHandlerMainQuest = new TQuestHandleMainQuest();
         this.FQuestHandlerBranchQuest = new TQuestHandleBranchQuest();
         this.FQuestHandlers = new Vector.<TQuestHandle>();
         this.FQuestHandlers.push(this.FQuestHandlerMainQuest);
         this.FQuestHandlers.push(this.FQuestHandlerBranchQuest);
         this.FWindowQuest = new TProcessorWindowQuest(this);
         this.FBoundsQuest = new TBounds();
         this.FBoundsQuest.Width = this.SIZE_WIDTH_QUESTWINDOW;
         this.FBoundsQuest.Height = this.SIZE_HEIGHT_QUESTWINDOW;
         ComponentBoundsCenter(this.FWindowQuest,this.FBoundsQuest);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_QUEST.RESOURCESID_Swf_Quest);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Task_QuestActionRet,this.PerformPacket_SC_QuestActionRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Task_AlreadyAcceptTaskRet,this.PerformPacket_SC_AlreadyAcceptTask);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Task_AlreadyFinishTaskRet,this.PerformPacket_SC_AlreadyFinishTask);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Task_CompleteSendInfor,this.PerformPacket_SC_SendInforFinish);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Task_SendTaskSchedule,this.PerformPacket_SC_SendTaskSchedule);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Signals();
      }
      
      protected function PerformPacket_SC_QuestActionRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TQuestHandle = null;
         var _loc4_:int = 0;
         this.FUnstreamizerQuestAction.Unstreamize(param1.Data,this.FTaskAction,null);
         if(this.FTaskAction.ResultCode == 0)
         {
            _loc4_ = this.GetQuestTypeByID(this.FTaskAction.QuestID);
            _loc3_ = this.FQuestHandlers[_loc4_];
            _loc3_.QuestActionRet(this.FTaskAction);
            if(this.FTaskAction.ActionID == CONST_QUEST.ACTIONID_ACCEPT)
            {
               TutorialNextStep(this.FTaskAction.QuestID);
               this.ProcessorCheckPlot(TProcessorPlot.PLOT_POS_Befor,this.FTaskAction.QuestID);
               this.FOnAcceptTaskEffect(this);
            }
            else if(this.FTaskAction.ActionID == CONST_QUEST.ACTIONID_COMPLETE)
            {
               TutorialNextStep(this.FTaskAction.QuestID * 10);
               this.ProcessorCheckPlot(TProcessorPlot.PLOT_POS_End,this.FTaskAction.QuestID);
               this.FOnCompleteTaskEffect(this);
            }
            this.NotifyListeners();
            this.CheckCanAcceptQuest();
         }
         else
         {
            EffectGenerateTextByErrorCode(this.FTaskAction.ResultCode);
         }
      }
      
      protected function PerformPacket_SC_AlreadyAcceptTask(param1:TPacket) : void
      {
         this.FUnstreamizerQuests.Unstreamize(param1.Data,this.FBaseQuests,null);
      }
      
      protected function PerformPacket_SC_AlreadyFinishTask(param1:TPacket) : void
      {
         this.FUnstreamizerFinishedQuests.Unstreamize(param1.Data,this.FBaseQuests,null);
      }
      
      protected function PerformPacket_SC_SendInforFinish(param1:TPacket) : void
      {
         this.DispatchQuest();
         this.CheckCanAcceptQuest();
         this.NotifyListeners();
         if(this.FOnLoadQuestOver != null)
         {
            this.FOnLoadQuestOver(this);
         }
         this.FLoadQuestComplete = true;
      }
      
      protected function PerformPacket_SC_SendTaskSchedule(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TQuest = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc3_ = this.FMainQuestsAlreadyAccept.GetQuestByIdentifier(_loc4_);
         if(_loc3_ == null)
         {
            _loc3_ = this.FSubQuestsAlreadyAccept.GetQuestByIdentifier(_loc4_);
         }
         if(_loc3_ != null)
         {
            _loc3_.CurrentfKillTime = _loc5_;
            if(_loc3_.CurrentfKillTime >= _loc3_.KillTime)
            {
               _loc3_.TaskState = CONST_QUEST.STATE_TASKBACK;
            }
         }
         this.NotifyListeners();
         this.CheckCanAcceptQuest();
      }
      
      protected function DispatchQuest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TQuestHandle = null;
         _loc1_ = 0;
         while(_loc1_ < this.FQuestHandlers.length)
         {
            _loc2_ = this.FQuestHandlers[_loc1_];
            _loc2_.DispatchQuest();
            _loc1_++;
         }
      }
      
      protected function CheckCanAcceptQuest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TQuestHandle = null;
         var _loc3_:Boolean = false;
         _loc3_ = false;
         _loc1_ = 0;
         while(_loc1_ < this.FQuestHandlers.length)
         {
            _loc2_ = this.FQuestHandlers[_loc1_];
            _loc3_ = _loc2_.CheckCanAcceptQuest() || _loc3_;
            _loc1_++;
         }
         if(_loc3_)
         {
            this.NotifyListeners();
         }
      }
      
      protected function CheckCanCompleteQuest(param1:TQuestInfor) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TQuestHandle = null;
         var _loc4_:Boolean = false;
         _loc4_ = false;
         _loc2_ = 0;
         while(_loc2_ < this.FQuestHandlers.length)
         {
            _loc3_ = this.FQuestHandlers[_loc2_];
            _loc4_ ||= _loc3_.QuestInforHandle(param1);
            _loc2_++;
         }
         if(_loc4_)
         {
            this.NotifyListeners();
            this.CheckCanAcceptQuest();
         }
      }
      
      protected function ProcessorInitQuests() : void
      {
         var _loc1_:int = 0;
         this.FUnstreamizerQuests.UnstreamizeQuestsByDatabases(null,this.FBaseQuests,null);
         _loc1_ = 0;
         while(_loc1_ < this.FBaseQuests.length)
         {
            this.FBaseQuests[_loc1_].UpdateQuestBounds();
            _loc1_++;
         }
      }
      
      protected function ProcessorCheckPlot(param1:uint, param2:uint) : void
      {
         if(this.FOnProcessorCheckPlot != null)
         {
            this.FOnProcessorCheckPlot(this,TProcessorPlot.PLOT_TYPE_Task,param1,param2);
         }
      }
      
      protected function GetQuestTypeByID(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TQuests = null;
         _loc2_ = 0;
         while(_loc2_ < this.FBaseQuests.length)
         {
            _loc3_ = this.FBaseQuests[_loc2_];
            if(param1 >= _loc3_.QuestIDMin && param1 <= _loc3_.QuestIDMax)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:Boolean = false;
         while(true)
         {
            _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_QUEST);
            if(_loc1_ == null)
            {
               break;
            }
            this.CheckCanCompleteQuest(_loc1_.UserData as TQuestInfor);
         }
      }
      
      protected function NotifyListeners() : void
      {
         if(this.FOnQuestUpdate != null)
         {
            this.FOnQuestUpdate();
         }
      }
      
      public function OnTaskBtnClick(param1:Object) : void
      {
         if(this.FWindowQuest.visible)
         {
            this.FWindowQuest.Close();
         }
      }
      
      override public function set OnClose(param1:Function) : void
      {
         FOnClose = param1;
         this.FWindowQuest.OnClose = param1;
      }
      
      public function set OnQuestUpdate(param1:Function) : void
      {
         this.FOnQuestUpdate = param1;
      }
      
      public function set OnLoadQuestOver(param1:Function) : void
      {
         this.FOnLoadQuestOver = param1;
      }
      
      public function set OnProcessorCheckPlot(param1:Function) : void
      {
         this.FOnProcessorCheckPlot = param1;
      }
      
      public function set OnAcceptTaskEffect(param1:Function) : void
      {
         this.FOnAcceptTaskEffect = param1;
      }
      
      public function set OnCompleteTaskEffect(param1:Function) : void
      {
         this.FOnCompleteTaskEffect = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowQuest.Load();
            return;
         }
         this.FWindowQuest.AlreadyAcceptMainQuestes = this.FMainQuestsAlreadyAccept;
         this.FWindowQuest.AlreadyAcceptSubQuestes = this.FSubQuestsAlreadyAccept;
         this.FWindowQuest.CanAcceptMainQuestes = this.FMainQuestsCanAccept;
         this.FWindowQuest.CanAcceptSubQuestes = this.FSubQuestsCanAccept;
         this.FWindowQuest.Update();
         this.FWindowQuest.visible = true;
      }
      
      public function InitQuests() : void
      {
         this.ProcessorInitQuests();
      }
      
      public function RoleLevelUp() : void
      {
         if(this.FLoadQuestComplete)
         {
            this.CheckCanAcceptQuest();
         }
      }
   }
}

