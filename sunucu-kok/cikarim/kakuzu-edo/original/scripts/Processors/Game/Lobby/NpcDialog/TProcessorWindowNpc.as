package Processors.Game.Lobby.NpcDialog
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityStandardBTN;
   import Logics.Quests.TQuest;
   import Logics.Quests.TQuests;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Quests.QuestNew.TQuestInfor;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NPC;
   import Resources.Constants.CONST_QUEST;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowNpc extends TProcessorLobbyWindow
   {
      
      protected var STATE_NONE:int = -1;
      
      protected var STATE_WAITFORACCEPT:int = 0;
      
      protected var STATE_WAITFORCOMPLETE:int = 1;
      
      protected var CONTINUE_TIME:int = 1000;
      
      protected var SpecialQuestForComplete:Vector.<int> = Vector.<int>([]);
      
      protected var SpecialQuestIDForAddNew:Vector.<int> = Vector.<int>([16100006,16100010,16100011,16100014,16100015,16100047,16100021]);
      
      protected var FTF_NpcName:TextField;
      
      protected var FTalkContent:TextField;
      
      protected var FPicBitMap:Bitmap;
      
      protected var FPicID:uint;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Continue:MovieClip;
      
      protected var FNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FCurrentQuest:TQuest;
      
      protected var FWindowNpcQuestList:TProcessorWindowNpcQuestList;
      
      protected var FWindowNpcQuestReward:TProcessorWindowNpcQuestReward;
      
      protected var FCurrentState:int;
      
      protected var FQuests:Vector.<TQuests>;
      
      protected var FCloseTime:int;
      
      protected var FClickedShortcut:Boolean;
      
      protected var FInitComplete:Boolean;
      
      protected var FClickUserType:Function;
      
      protected var FOpenDialog:Function;
      
      public function TProcessorWindowNpc(param1:TUIComponent)
      {
         super(param1);
         this.FWindowNpcQuestList = new TProcessorWindowNpcQuestList(this);
         this.FWindowNpcQuestList.ShortCutClicked = this.ShortcutClick;
         this.FWindowNpcQuestReward = new TProcessorWindowNpcQuestReward(this);
         this.FQuests = new Vector.<TQuests>();
         this.FQuests.push(SLogicsCore.Character.MainQuestsCanAccept);
         this.FQuests.push(SLogicsCore.Character.SubQuestsCanAccept);
         this.FQuests.push(SLogicsCore.Character.MainQuestsAlreadyAccept);
         this.FQuests.push(SLogicsCore.Character.SubQuestsAlreadyAccept);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FWindowNpcQuestReward.UpdateSlots();
         }
      }
      
      protected function NpcPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FPicID == param3)
         {
            this.FPicBitMap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      public function UIDispath(param1:MovieClip) : void
      {
         var _loc2_:Sprite = null;
         addChild(param1);
         this.FTF_NpcName = param1["NpcName"]["NpcNameInner"];
         this.FTalkContent = param1["TalkContent"];
         this.FBtn_Close = param1["BtnClose"];
         this.FBtn_Continue = param1["ShortcutBack"];
         this.FPicBitMap = new Bitmap();
         _loc2_ = param1["NpcPic"];
         while(_loc2_.numChildren)
         {
            _loc2_.removeChildAt(0);
         }
         _loc2_.addChild(this.FPicBitMap);
         this.FWindowNpcQuestList.UIDispath(param1["Total"]);
         this.FWindowNpcQuestList.x = param1["Total"].x;
         this.FWindowNpcQuestList.y = param1["Total"].y;
         this.FWindowNpcQuestReward.UIDispath(param1["Total"]);
         this.FWindowNpcQuestReward.x = param1["Total"].x;
         this.FWindowNpcQuestReward.y = param1["Total"].y;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_NpcDialogBtn,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_NpcDialogBtn,FParent);
      }
      
      public function UILocation() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         this.FBtn_Continue.buttonMode = true;
         this.FBtn_Continue.mouseChildren = false;
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Continue,this.OnContinueClick);
         this.FCurrentState = this.STATE_NONE;
         this.FWindowNpcQuestList.UILocation();
         this.FWindowNpcQuestReward.UILocation();
         this.FInitComplete = true;
      }
      
      protected function ShowName() : void
      {
         if(this.FNpc.RoleTempleteID == 22100028)
         {
            this.FTF_NpcName.text = "";
         }
         else
         {
            this.FTF_NpcName.text = this.FNpc.Name;
         }
      }
      
      protected function ShowNpcPic() : void
      {
         this.FPicID = this.FNpc.NpcStyleTextureID;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPicID,this.NpcPicArrive);
         this.FPicBitMap.bitmapData = null;
      }
      
      protected function ShowTalkContent() : void
      {
         this.FTalkContent.text = this.GetTalkContent();
      }
      
      protected function ShowBtn() : void
      {
         var _loc1_:Boolean = false;
         this.FBtn_Continue.visible = this.FCurrentQuest != null;
         this.FBtn_Continue["BtnLable"].text = this.GetBtnLable();
      }
      
      protected function GetBtnLable() : String
      {
         var _loc1_:Boolean = false;
         if(this.FCurrentQuest != null)
         {
            _loc1_ = this.CheckIfQuestAndNpcMatching(this.FCurrentQuest);
            switch(this.FCurrentQuest.TaskState)
            {
               case CONST_QUEST.STATE_ACCEPT:
                  return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NpcDialog_STRING_3);
               case CONST_QUEST.STATE_TASKBACK:
                  return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NpcDialog_STRING_4);
            }
         }
         return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NpcDialog_STRING_5);
      }
      
      public function GetTalkContent() : String
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         if(this.FCurrentQuest == null)
         {
            return this.FNpc.NormalTalkText;
         }
         _loc1_ = "";
         _loc2_ = this.CheckIfQuestAndNpcMatching(this.FCurrentQuest);
         if(this.FCurrentQuest.TaskState == CONST_QUEST.STATE_TASKBACK && _loc2_)
         {
            return this.FCurrentQuest.TalkEnd;
         }
         return this.FCurrentQuest.TalkBefor;
      }
      
      protected function RequestAccept() : void
      {
         var _loc1_:TQuestInfor = null;
         _loc1_ = new TQuestInfor();
         _loc1_.InforID = CONST_QUEST.QUEST_INFOR_NPC_CLICKACCEPTBUTTON;
         _loc1_.InforArray.push(this.FCurrentQuest.Identifier);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_QUEST,0,0,_loc1_);
      }
      
      protected function RequestComplete() : void
      {
         var _loc1_:TQuestInfor = null;
         _loc1_ = new TQuestInfor();
         _loc1_.InforID = CONST_QUEST.QUEST_INFOR_NPC_CLICKCOMPLETEBUTTON;
         _loc1_.InforArray.push(this.FCurrentQuest.Identifier);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_QUEST,0,0,_loc1_);
      }
      
      protected function CheckIfQuestAndNpcMatching(param1:TQuest) : Boolean
      {
         var _loc2_:uint = 0;
         switch(param1.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               _loc2_ = uint(param1.AcceptTaskNpc);
               break;
            case CONST_QUEST.STATE_TASKING:
               _loc2_ = uint(param1.AcceptTaskNpc);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               _loc2_ = uint(param1.BackTaskNpc);
         }
         return this.FNpc.RoleTempleteID == _loc2_;
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnContinueClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TQuest = null;
         param1.stopImmediatePropagation();
         _loc3_ = this.FCurrentQuest;
         switch(this.FCurrentQuest.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               _loc2_ = this.CheckIfQuestAndNpcMatching(this.FCurrentQuest);
               if(_loc2_)
               {
                  this.RequestAccept();
                  this.FCurrentState = this.STATE_WAITFORACCEPT;
               }
               else
               {
                  ProcessorWindowClose();
                  SLogicsCore.QuestAutoSearchWay.AutoSearyWay(_loc3_);
               }
               break;
            case CONST_QUEST.STATE_TASKING:
               ProcessorWindowClose();
               SLogicsCore.QuestAutoSearchWay.AutoSearyWay(_loc3_);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               _loc2_ = this.CheckIfQuestAndNpcMatching(this.FCurrentQuest);
               if(_loc2_)
               {
                  this.RequestComplete();
                  this.FCurrentState = this.STATE_WAITFORCOMPLETE;
               }
               else
               {
                  ProcessorWindowClose();
                  SLogicsCore.QuestAutoSearchWay.AutoSearyWay(_loc3_);
               }
         }
      }
      
      protected function ShortcutClick(param1:int, param2:int) : void
      {
         if(param1 == TProcessorWindowNpcQuestList.SHORTCUTTYPE_USERTYPE)
         {
            if(this.FClickUserType != null)
            {
               if(param2 == CONST_NPC.NPC_FUNCTION_PUB)
               {
                  TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickTavernNpcShortcut);
               }
               this.FClickUserType(param2);
            }
         }
         else
         {
            this.FCurrentQuest = this.FNpc.Questes.GetQuestByIndex(param2);
            this.FClickedShortcut = true;
            this.ShowTalkContent();
            this.ShowDetailInfor();
            this.ShowBtn();
         }
      }
      
      protected function ShowDetailInfor() : void
      {
         var _loc1_:Boolean = false;
         if(this.FCurrentQuest != null && (this.FCurrentQuest.TaskState == CONST_QUEST.STATE_TASKBACK || this.FClickedShortcut))
         {
            this.FClickedShortcut = false;
            _loc1_ = this.CheckIfQuestAndNpcMatching(this.FCurrentQuest);
            if(_loc1_)
            {
               this.FWindowNpcQuestReward.ShowByQuest(this.FCurrentQuest);
               this.FWindowNpcQuestList.visible = false;
               this.FWindowNpcQuestReward.visible = true;
               return;
            }
         }
         this.FWindowNpcQuestList.ShowByNpc(this.FNpc);
         this.FWindowNpcQuestList.visible = true;
         this.FWindowNpcQuestReward.visible = false;
      }
      
      protected function GetRelationQuestByQuests(param1:TQuests) : TQuest
      {
         var _loc2_:TQuest = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.Count)
         {
            _loc2_ = param1.GetQuestByIndex(_loc3_);
            if(_loc2_.AcceptTaskNpc == this.FNpc.RoleTempleteID && _loc2_.CurrentfKillTime == 0)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function HandleQuestAddNew() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TQuest = null;
         var _loc3_:Vector.<int> = null;
         if(STimingCore.TickCount - this.FCloseTime > this.CONTINUE_TIME)
         {
            return;
         }
         _loc3_ = this.SpecialQuestIDForAddNew;
         _loc1_ = 0;
         while(_loc1_ < this.FQuests.length)
         {
            _loc2_ = this.GetRelationQuestByQuests(this.FQuests[_loc1_]);
            if(_loc2_ != null)
            {
               _loc1_ = _loc3_.indexOf(_loc2_.Identifier);
               if(_loc1_ < 0)
               {
                  this.FOpenDialog(this.FNpc);
                  return;
               }
            }
            _loc1_++;
         }
         if(SLogicsCore.Character.MainQuestsCanAccept.Count != 0)
         {
            this.FCurrentQuest = SLogicsCore.Character.MainQuestsCanAccept.GetQuestByIndex(0);
            this.ShowTalkContent();
            this.ShowDetailInfor();
            this.ShowBtn();
         }
      }
      
      protected function HandleQuestAccept() : void
      {
         if(this.FCurrentState != this.STATE_WAITFORACCEPT)
         {
            return;
         }
         if(this.FCurrentQuest.TaskState != CONST_QUEST.STATE_ACCEPT)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenNpcDialog);
            this.ShowTalkContent();
            this.ShowDetailInfor();
            this.ShowBtn();
         }
      }
      
      protected function HandleQuestComplete() : void
      {
         var _loc1_:TQuest = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         if(this.FCurrentState != this.STATE_WAITFORCOMPLETE)
         {
            return;
         }
         if(this.FNpc.Questes.Count > 0)
         {
            _loc1_ = this.FCurrentQuest;
            _loc3_ = this.SpecialQuestForComplete;
            _loc2_ = _loc3_.indexOf(_loc1_.Identifier);
            if(_loc2_ < 0)
            {
               this.ShowByNpc(this.FNpc);
               return;
            }
         }
         this.FWindowNpcQuestReward.PlayRewardIntoBackpack();
         ProcessorWindowClose();
      }
      
      public function get ClickUserType() : Function
      {
         return this.FClickUserType;
      }
      
      public function set ClickUserType(param1:Function) : void
      {
         this.FClickUserType = param1;
      }
      
      public function set OpenDialog(param1:Function) : void
      {
         this.FOpenDialog = param1;
      }
      
      public function set SlotOver(param1:Function) : void
      {
         this.FWindowNpcQuestReward.SlotOver = param1;
      }
      
      public function set SlotOut(param1:Function) : void
      {
         this.FWindowNpcQuestReward.SlotOut = param1;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FWindowNpcQuestReward.OnEffectAcquireInventory = param1;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FWindowNpcQuestReward.OnQueryShortcutCoordinate = param1;
      }
      
      public function ShowByNpc(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         if(param1.Questes.Count != 0)
         {
            this.FCurrentQuest = param1.Questes.GetQuestByIndex(0);
         }
         this.FNpc = param1;
         this.ShowName();
         this.ShowNpcPic();
         this.ShowTalkContent();
         this.ShowDetailInfor();
         this.ShowBtn();
      }
      
      public function UpdateQuest() : void
      {
         if(this.FInitComplete)
         {
            this.HandleQuestAddNew();
            this.HandleQuestAccept();
            this.HandleQuestComplete();
            this.FWindowNpcQuestList.ShowByNpc(this.FNpc);
         }
      }
      
      public function Reset() : void
      {
         if(this.FInitComplete)
         {
            this.FCloseTime = STimingCore.TickCount;
            this.FCurrentQuest = null;
            this.FCurrentState = this.STATE_NONE;
            this.FPicBitMap.bitmapData = null;
         }
      }
   }
}

