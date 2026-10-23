package Processors.Game.Lobby.DailyQuest
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Dailytask.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Quests.TQuest;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.DailyTask.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorDailyQuest extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_DAILY_QUEST:uint = 654;
      
      protected static const SIZE_HIGHT_DAILY_QUEST:uint = 493;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const TASK_TYPE_ACCEPT:uint = 1;
      
      protected static const TASK_TYPE_GIVEUP:uint = 2;
      
      protected static const TASK_TYPE_FINISH:uint = 3;
      
      protected static const TASK_TYPE_FINISHNOW:uint = 4;
      
      protected var FProcessorWindowTask:TProcessorWindowTask;
      
      protected var FProcessorWindowPoint:TProcessorWindowPoint;
      
      protected var FBackGround:MovieClip;
      
      protected var FBT_Close:SimpleButton;
      
      protected var FBT_Help:SimpleButton;
      
      protected var FMC_Left:MovieClip;
      
      protected var FMC_Right:MovieClip;
      
      protected var FUnstreamizerDailyTasks:TUnstreamizerDailyTasks;
      
      protected var FDailytask:TDailytask;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsInfo:Boolean;
      
      protected var FBoo:Boolean;
      
      protected var FBounds:TBounds;
      
      protected var FDailyAwardBin:TBins;
      
      protected var FHelpTips:THint;
      
      protected var FQuest:TQuest;
      
      protected var FIsEffect:Boolean;
      
      protected var FOnGotoMap:Function;
      
      protected var FOnPlayEffect:Function;
      
      public function TProcessorDailyQuest(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FQuest = new TQuest(0);
         this.FUnstreamizerDailyTasks = new TUnstreamizerDailyTasks();
         this.FDailytask = SLogicsCore.Character.DailyTask;
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DAILY_QUEST.RESOURCESID_DAILY_QUEST);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WIDTH_DAILY_QUEST;
         this.FBounds.Height = SIZE_HIGHT_DAILY_QUEST;
         ComponentBoundsCenter(this,this.FBounds);
         this.FBounds = null;
         this.FHelpTips = new THint();
         this.FBackGround = TUtilityReflection.CreateDisplayObjectInstance(CONST_DAILY_QUEST.RESOURCE_ClassName_DAILY_QUEST) as MovieClip;
         addChild(this.FBackGround);
         this.FBT_Help = this.FBackGround[CONST_DAILY_QUEST.RESOURCE_Link_BT_Help];
         this.FBT_Close = this.FBackGround[CONST_DAILY_QUEST.RESOURCE_Link_BT_Close];
         this.FProcessorWindowPoint = new TProcessorWindowPoint(this,this.FBackGround.MC_Point);
         this.FProcessorWindowPoint.Visible = true;
         this.FProcessorWindowPoint.ListRewardOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPoint.ListRewardOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPoint.Visible = false;
         this.FProcessorWindowTask = new TProcessorWindowTask(this,this.FBackGround.MC_Task);
         this.FProcessorWindowTask.Visible = true;
         this.FProcessorWindowTask.OnRefrsh = this.TaskRefresh;
         this.FProcessorWindowTask.OnPointUpdate = this.PointUpdate;
         this.FProcessorWindowTask.OnTaskReq = this.OnTaskReq;
         this.FProcessorWindowTask.OnGoto = this.OnGoto;
         this.FProcessorWindowTask.OnUpdateDouble = this.OnUpdateDouble;
         this.FProcessorWindowTask.OnEffectExtraPoint = this.OnEffectExtraPoint;
         this.FProcessorWindowTask.OnClose = this.OnCloseWindow;
         this.FProcessorWindowTask.OnGotoMap = this.OnGotoMap;
         this.FProcessorWindowTask.HintOnTargetOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTask.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTask.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowTask.Visible = false;
         this.FDailyAwardBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DailyAward);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.FBT_Close.addEventListener(MouseEvent.CLICK,this.CloseOnClick);
         this.FBT_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBT_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_InfoRet,this.PerformPacket_SC_DailyTask_InfoResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_TaskRet,this.PerformPacket_SC_DailyTask_TaskResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_FreshRet,this.PerformPacket_SC_DailyTask_FreshRetResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_RewardRet,this.PerformPacket_SC_DailyTask_RewardRetResponse);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_TargetTaskFreshRet,this.PerformPacket_SC_DailyTask_TargetTaskFreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyTask_FinishCountRet,this.PerformPacket_SC_DailyTask_FinishCountRet);
      }
      
      protected function DailyQusetInfoReq() : void
      {
         var _loc1_:TPacket = null;
         if(this.FCharacter.GetMainLevel() >= 2 && !this.FIsInfo)
         {
            _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyTask_InfoReq);
            SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         }
      }
      
      protected function PerformPacket_SC_DailyTask_InfoResponse(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:TQuestDaily = null;
         this.FIsInfo = true;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerDailyTasks.Unstreamize(_loc2_,this.FDailytask,null);
         if(FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowTask.TaskInit();
            this.FProcessorWindowTask.Visible = true;
            this.FProcessorWindowPoint.Update(true);
            this.FProcessorWindowPoint.Visible = true;
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenDailyTask);
         }
         if(this.FDailytask.CurrentID != 0)
         {
            _loc4_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID) as TQuestDaily;
            if(this.FDailytask.CurrentProgress == _loc4_.KillTime)
            {
               if(this.FOnPlayEffect != null)
               {
                  this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,true);
                  this.FIsEffect = true;
               }
               return;
            }
         }
         if(this.FOnPlayEffect != null)
         {
            this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,false);
            this.FIsEffect = false;
         }
      }
      
      protected function PerformPacket_SC_DailyTask_TaskResponse(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TQuestDaily = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FDailytask.CurrentID = _loc2_.readUnsignedInt();
         _loc4_ = uint(_loc2_.readByte());
         switch(_loc4_)
         {
            case TASK_TYPE_ACCEPT:
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_07));
               break;
            case TASK_TYPE_FINISHNOW:
            case TASK_TYPE_FINISHNOW:
               _loc5_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID);
               _loc6_ = TUtilityLobby.GetItemName(_loc5_.Rewards[0].Type,_loc5_.Rewards[0].Code) + "+" + _loc5_.Rewards[0].Amount.toString();
               _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_16),_loc5_.AwardPoint);
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_08) + "\n" + _loc6_ + "\n" + _loc7_);
         }
         this.FProcessorWindowTask.Update(_loc4_);
         if(this.FOnPlayEffect != null)
         {
            this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,false);
            this.FIsEffect = false;
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_RecevieDailyTask);
      }
      
      protected function PerformPacket_SC_DailyTask_FreshRetResponse(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FDailytask.FreshCount = _loc2_.readUnsignedShort();
         this.FUnstreamizerDailyTasks.UnstreamizationTask(_loc2_,this.FDailytask,null);
         this.FProcessorWindowTask.UpdateRefresh();
         if(this.FOnPlayEffect != null)
         {
            if(this.FIsEffect)
            {
               this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,false);
               this.FIsEffect = false;
            }
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_RefreshDailyTask);
      }
      
      protected function PerformPacket_SC_DailyTask_TargetTaskFreshRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerDailyTasks.UnstreamizationTargetTask(_loc2_,this.FDailytask,null);
         this.FProcessorWindowTask.UpdateExtraText();
      }
      
      protected function PerformPacket_SC_DailyTask_RewardRetResponse(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TDailyAward = null;
         var _loc6_:TArticle = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FDailytask.IsAward = _loc2_.readUnsignedShort();
         this.FProcessorWindowPoint.awardListUpdate();
         _loc4_ = "";
         _loc5_ = this.FDailyAwardBin.GetDatebaseByIndex(this.FProcessorWindowPoint.AwardIndex) as TDailyAward;
         _loc7_ = _loc5_.RewardsVect[0].Type;
         _loc8_ = _loc5_.RewardsVect[0].Code;
         _loc9_ = _loc5_.RewardsVect[0].Amount;
         if(_loc7_ == 1)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc8_) as TArticle;
            _loc4_ = _loc6_.Name;
         }
         else
         {
            _loc4_ = TUtilityLobby.GetItemName(_loc7_,_loc8_);
         }
         if(this.FDailytask.IsDouble == 1)
         {
            _loc9_ *= 2;
         }
         _loc4_ += "*" + _loc9_.toString();
         EffectGenerateText(_loc4_);
      }
      
      protected function PerformPacket_SC_DailyTask_FinishCountRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:TQuestDaily = null;
         _loc2_ = param1.Data;
         this.FDailytask.CurrentProgress = _loc2_.readByte();
         if(this.FDailytask.CurrentID != 0)
         {
            _loc3_ = this.FDailytask.GetTaskByIdentifier(this.FDailytask.CurrentID) as TQuestDaily;
            if(this.FDailytask.CurrentProgress == _loc3_.KillTime)
            {
               if(this.FOnPlayEffect != null)
               {
                  this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,true);
                  this.FIsEffect = true;
               }
               return;
            }
         }
         if(this.FOnPlayEffect != null)
         {
            this.FOnPlayEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest,false);
            this.FIsEffect = false;
         }
      }
      
      protected function TaskRefresh() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyTaskp_FreshReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function OnTaskReq(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyTask_TaskReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeByte(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function PointUpdate() : void
      {
         this.FProcessorWindowPoint.Update(false);
      }
      
      protected function OnUpdateDouble() : void
      {
         this.FProcessorWindowPoint.UpdateDouble();
      }
      
      protected function CloseOnClick(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSystemLanguage = null;
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.HELPTIPS_DaileQuest) as TSystemLanguage;
            this.FHelpTips.Content = _loc2_.Desc;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHelpTips);
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHelpTips);
      }
      
      protected function OnGotoMap(param1:Object) : void
      {
         var _loc2_:TQuest = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:Boolean = false;
         _loc6_ = false;
         _loc3_ = int(SLogicsCore.Character.MainQuestComplete.Count);
         _loc5_ = int(_loc3_ - 1);
         while(_loc5_ >= 0)
         {
            _loc2_ = SLogicsCore.Character.MainQuestComplete.GetQuestByIndex(_loc5_);
            if(_loc2_.EventType == CONST_QUEST.QuestEventTypeKillMonster)
            {
               _loc6_ = true;
               break;
            }
            _loc5_--;
         }
         if(!_loc6_)
         {
            _loc3_ = int(SLogicsCore.Character.MainQuestBase.Count);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = SLogicsCore.Character.MainQuestBase.GetQuestByIndex(_loc5_);
               if(_loc2_.EventType == CONST_QUEST.QuestEventTypeKillMonster)
               {
                  break;
               }
               _loc5_++;
            }
         }
         this.FQuest.Coerce(_loc2_.Identifier);
         this.FQuest.TaskState = CONST_QUEST.STATE_TASKING;
         this.FQuest.AcceptTaskNpc = _loc2_.AcceptTaskNpc;
         this.FQuest.BackTaskNpc = _loc2_.BackTaskNpc;
         this.FQuest.DoorID = _loc2_.DoorID;
         this.FQuest.CampId = _loc2_.CampId;
         this.FQuest.EventType = CONST_QUEST.QuestEventTypeKillMonster;
         if(this.FOnGotoMap != null)
         {
            this.FOnGotoMap(this,this.FQuest);
         }
      }
      
      protected function OnCloseWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function PlayAnimation() : void
      {
         this.FMC_Left.gotoAndPlay(1);
         this.FMC_Right.gotoAndPlay(1);
      }
      
      protected function OnGoto(param1:Object, param2:uint) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(param2);
      }
      
      protected function OnEffectExtraPoint(param1:uint) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_16),param1);
         EffectGenerateText(_loc2_);
      }
      
      public function get OnGotoBigMap() : Function
      {
         return this.FOnGotoMap;
      }
      
      public function set OnGotoBigMap(param1:Function) : void
      {
         this.FOnGotoMap = param1;
      }
      
      public function get OnPlayEffect() : Function
      {
         return this.FOnPlayEffect;
      }
      
      public function set OnPlayEffect(param1:Function) : void
      {
         this.FOnPlayEffect = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(!this.FIsInfo)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyTask_InfoReq);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
         if(this.FIsInfo)
         {
            this.FProcessorWindowTask.TaskInit();
            this.FProcessorWindowTask.Visible = true;
            this.FProcessorWindowPoint.Update(true);
            this.FProcessorWindowPoint.Visible = true;
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenDailyTask);
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseDailyTask);
         this.FProcessorWindowPoint.Reset();
         this.FProcessorWindowTask.Reset();
      }
      
      public function InfoReq() : void
      {
         this.DailyQusetInfoReq();
      }
   }
}

