package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Quests.*;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.operation.quest.*;
   
   public class TWindowQuestGuide extends TUIComponent
   {
      
      protected static const TAG_ALREADYACCEPT:int = 0;
      
      protected static const TAG_CANACCEPT:int = 1;
      
      protected var FHint:THint;
      
      protected var FCurrentVisibleTag:int;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FTextField:TScrollTextField;
      
      protected var FRegisterAlreadyAccept:TRegistryInstance;
      
      protected var FRegisterCanAccept:TRegistryInstance;
      
      protected var FScene:MovieClip;
      
      protected var FBackground:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FAlreadyAcceptTag:TUIButton;
      
      protected var FCanAcceptTag:TUIButton;
      
      protected var FBTN_Open:TUIButton;
      
      protected var FBTN_Close:TUIButton;
      
      protected var FWidth:int;
      
      protected var FIsInitialization:Boolean;
      
      protected var FQuests:Vector.<TQuests>;
      
      protected var FTabTaskIndex:int;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnTextClick:Function;
      
      protected var FTutorialNextStep:Function;
      
      public function TWindowQuestGuide(param1:TUIComponent)
      {
         super(param1);
         this.FRegisterAlreadyAccept = new TRegistryInstance();
         this.FRegisterCanAccept = new TRegistryInstance();
         this.FQuests = new Vector.<TQuests>();
         this.FQuests.push(SLogicsCore.Character.MainQuestsAlreadyAccept);
         this.FQuests.push(SLogicsCore.Character.SubQuestsAlreadyAccept);
         this.FQuests.push(SLogicsCore.Character.MainQuestsCanAccept);
         this.FQuests.push(SLogicsCore.Character.SubQuestsCanAccept);
         this.FWidth = 0;
         this.mouseEnabled = false;
         this.FIsInitialization = false;
      }
      
      public static function GetTaskNameStringByQuest(param1:TQuest) : String
      {
         var _loc2_:Vector.<String> = null;
         _loc2_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_0);
         return _loc2_[param1.Category] + param1.Name;
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         this.FHint = new THint();
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_11);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_QUEST.RESOURCE_ClassName_Task) as MovieClip;
         this.addChild(this.FScene);
         this.FScene.mouseEnabled = false;
         this.FScene.visible = false;
         this.FScene.addEventListener(MouseEvent.MOUSE_MOVE,this.QuestGuideOnMove,false,0,true);
         this.FScene.addEventListener(MouseEvent.ROLL_OVER,this.QuestGuideOnOver,false,0,true);
         this.FScene.addEventListener(MouseEvent.ROLL_OUT,this.QuestGuideOnOut,false,0,true);
         this.FScene.addEventListener(MouseEvent.CLICK,this.QuestGuideClick,false,0,true);
         this.FBackground = this.FScene.mc_scroll.mc_bg;
         this.FBackground.mouseEnabled = false;
         this.FBackground.visible = false;
         this.FTextField = new TScrollTextField(this.FScene.mc_scroll.tf_info);
         this.FTextField.OnTextClick = this.HandleTextClick;
         this.FScene.mc_scroll.addChild(this.FTextField);
         this.FScorll = new TScrollBarSimple(this,this.FScene.mc_scroll.mc_bar,this.FScene.mc_scroll.btn_up,this.FScene.mc_scroll.btn_down,82,this.FTextField);
         this.addChild(this.FScorll);
         this.FUITab = new TUITab(this);
         _loc1_ = this.FScene["btn_curTask"];
         this.FUITab.SetTabByIndex(_loc1_,0);
         _loc1_ = this.FScene["btn_nextTask"];
         this.FUITab.SetTabByIndex(_loc1_,1);
         this.FUITab.OnSwitch = this.TabTaskOnSwitch;
         this.FUITab.Init();
         this.FBTN_Open = new TUIButton();
         this.FBTN_Open.Substrate = this.FScene["btn_open"];
         this.FBTN_Open.OnClick = this.OnOpenTask;
         this.FBTN_Close = new TUIButton();
         this.FBTN_Close.Substrate = this.FScene["btn_close"];
         this.FBTN_Close.OnClick = this.OnCloseTask;
         this.Init();
         this.FIsInitialization = true;
      }
      
      protected function CreateTaskSubject(param1:TQuest) : String
      {
         var _loc2_:String = null;
         _loc2_ = this.GetTaskNameHtmlTextByQuest(param1);
         if(param1.TaskState == CONST_QUEST.STATE_TASKBACK)
         {
            param1.TaskGuideInforCompound = _loc2_;
         }
         return _loc2_;
      }
      
      protected function GetTaskNameHtmlTextByQuest(param1:TQuest) : String
      {
         var _loc2_:String = null;
         _loc2_ = GetTaskNameStringByQuest(param1);
         if(param1.TaskState == CONST_QUEST.STATE_TASKBACK)
         {
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_1),param1.Identifier.toString(),_loc2_);
         }
         if(SLogicsCore.Character.GetMainLevel() < param1.RequirementLevelMin && param1.Category == CONST_QUEST.QuestCategory_Main)
         {
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_3),_loc2_,param1.RequirementLevelMin.toString());
         }
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_2),_loc2_);
      }
      
      protected function CreateTaskInfor(param1:TQuest) : String
      {
         var _loc2_:String = null;
         _loc2_ = this.GetTaskInforByQuest(param1);
         if(param1.TaskState != CONST_QUEST.STATE_TASKBACK)
         {
            param1.TaskGuideInforCompound = _loc2_;
         }
         return _loc2_;
      }
      
      protected function GetTaskInforByQuest(param1:TQuest) : String
      {
         var _loc2_:TNPC = null;
         var _loc3_:String = null;
         if(param1.TaskState == CONST_QUEST.STATE_ACCEPT)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_NPC,param1.AcceptTaskNpc) as TNPC;
            if(_loc2_.Cityid == 23100001)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_7);
            }
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_4),param1.Identifier.toString(),_loc2_.Name + _loc3_);
         }
         if(param1.TaskState == CONST_QUEST.STATE_TASKING)
         {
            _loc3_ = this.GetTaskInfoAlreadyAcceptHtmlTextByQuest(param1);
            if(param1.EventType != CONST_QUEST.QuestEventTypeJustRun)
            {
               _loc3_ += this.GetTaskInfoProgressByQuest(param1);
            }
            return _loc3_ + "\n";
         }
         return "";
      }
      
      protected function GetTaskInfoAlreadyAcceptHtmlTextByQuest(param1:TQuest) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = param1.Guiding;
         _loc5_ = _loc4_.split("#");
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_5),_loc5_[0],param1.Identifier.toString(),_loc5_[1],_loc5_[2],param1.Identifier.toString(),_loc5_[3]);
      }
      
      protected function GetTaskInfoProgressByQuest(param1:TQuest) : String
      {
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_6),param1.CurrentfKillTime.toString(),param1.KillTime.toString());
      }
      
      protected function UpdateQuestInfor(param1:TQuest) : void
      {
         var _loc2_:TQuestGuideInfor = null;
         _loc2_ = this.FRegisterAlreadyAccept.GetInstanceByIdentifier(param1.Identifier) as TQuestGuideInfor;
         if(_loc2_ != null)
         {
            _loc2_.Subject = this.CreateTaskSubject(param1);
            _loc2_.Infor = this.CreateTaskInfor(param1);
            if(this.FCurrentVisibleTag == TAG_ALREADYACCEPT)
            {
               this.SwitchTag(TAG_ALREADYACCEPT);
            }
         }
         _loc2_ = this.FRegisterCanAccept.GetInstanceByIdentifier(param1.Identifier) as TQuestGuideInfor;
         if(_loc2_ != null)
         {
            _loc2_.Subject = this.CreateTaskSubject(param1);
            _loc2_.Infor = this.CreateTaskInfor(param1);
            if(this.FCurrentVisibleTag == TAG_CANACCEPT)
            {
               this.SwitchTag(TAG_CANACCEPT);
            }
         }
      }
      
      protected function FreshVisibleQuestsInfor(param1:TRegistryInstance) : void
      {
         var _loc2_:TQuestGuideInfor = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FTextField.Clear();
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.GetInstanceByIndex(_loc3_) as TQuestGuideInfor;
            this.FTextField.AppendText(_loc2_.Subject + _loc2_.Infor + "\n");
            _loc3_++;
         }
      }
      
      protected function GetQuestInfor(param1:TQuest) : TQuestGuideInfor
      {
         var _loc2_:TQuestGuideInfor = null;
         _loc2_ = this.FRegisterAlreadyAccept.GetInstanceByIdentifier(param1.Identifier) as TQuestGuideInfor;
         if(_loc2_ == null)
         {
            _loc2_ = this.FRegisterCanAccept.GetInstanceByIdentifier(param1.Identifier) as TQuestGuideInfor;
         }
         return _loc2_;
      }
      
      protected function SwitchTag(param1:int) : void
      {
         this.FCurrentVisibleTag = param1;
         switch(param1)
         {
            case TAG_ALREADYACCEPT:
               this.FreshVisibleQuestsInfor(this.FRegisterAlreadyAccept);
               break;
            case TAG_CANACCEPT:
               this.FreshVisibleQuestsInfor(this.FRegisterCanAccept);
         }
      }
      
      protected function UpdateBounds() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         if(this.FIsInitialization)
         {
            this.FWidth = this.width;
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      protected function QuestGuideOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function QuestGuideOnOver(param1:MouseEvent) : void
      {
         this.FBackground.visible = true;
      }
      
      protected function QuestGuideOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
         this.FBackground.visible = false;
      }
      
      protected function QuestGuideClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      protected function HandleTextClick(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TQuest = null;
         var _loc4_:int = 0;
         _loc2_ = parseInt(param1);
         _loc4_ = 0;
         while(_loc4_ < this.FQuests.length)
         {
            _loc3_ = this.FQuests[_loc4_].GetQuestByIdentifier(_loc2_);
            if(_loc3_ != null)
            {
               break;
            }
            _loc4_++;
         }
         SLogicsCore.QuestAutoSearchWay.AutoSearyWay(_loc3_);
         this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_QuestClicked);
      }
      
      protected function OnOpenTask(param1:Object, param2:MouseEvent) : void
      {
         this.FBTN_Open.Visible = false;
         this.FBTN_Close.Visible = true;
         this.FScorll.visible = false;
         this.FScene.mc_scroll.visible = false;
      }
      
      protected function OnCloseTask(param1:Object, param2:MouseEvent) : void
      {
         this.FBTN_Open.Visible = true;
         this.FBTN_Close.Visible = false;
         this.FScorll.visible = true;
         this.FScene.mc_scroll.visible = true;
      }
      
      protected function TabTaskOnSwitch(param1:Object) : void
      {
         this.FTabTaskIndex = param1 as int;
         switch(this.FTabTaskIndex)
         {
            case TAG_ALREADYACCEPT:
               this.SwitchTag(TAG_ALREADYACCEPT);
               break;
            case TAG_CANACCEPT:
               this.SwitchTag(TAG_CANACCEPT);
         }
      }
      
      public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set OnTextClick(param1:Function) : void
      {
         this.FOnTextClick = param1;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function Init() : void
      {
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
      }
      
      public function UpdateTaskInfor(param1:TQuest) : void
      {
         this.UpdateQuestInfor(param1);
      }
      
      public function AddTask(param1:TQuest, param2:int) : void
      {
         var _loc3_:TQuestGuideInfor = null;
         _loc3_ = new TQuestGuideInfor();
         _loc3_.Subject = this.CreateTaskSubject(param1);
         _loc3_.Infor = this.CreateTaskInfor(param1);
         switch(param2)
         {
            case TAG_ALREADYACCEPT:
               this.FRegisterAlreadyAccept.Register(param1.Identifier,_loc3_);
               break;
            case TAG_CANACCEPT:
               this.FRegisterCanAccept.Register(param1.Identifier,_loc3_);
         }
      }
      
      public function DeleteTask(param1:TQuest) : void
      {
         var _loc2_:TQuestGuideInfor = null;
         var _loc3_:Boolean = false;
         _loc3_ = this.FRegisterCanAccept.DeleteInstanceByIdentifier(param1.Identifier);
         if(_loc3_ && this.FCurrentVisibleTag == TAG_CANACCEPT)
         {
            this.FreshVisibleQuestsInfor(this.FRegisterCanAccept);
         }
         _loc3_ = this.FRegisterAlreadyAccept.DeleteInstanceByIdentifier(param1.Identifier);
         if(_loc3_ && this.FCurrentVisibleTag == TAG_ALREADYACCEPT)
         {
            this.FreshVisibleQuestsInfor(this.FRegisterAlreadyAccept);
         }
      }
      
      protected function FlushQuests(param1:TQuests, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.Count)
         {
            this.AddTask(param1.GetQuestByIndex(_loc3_),param2);
            _loc3_++;
         }
      }
      
      public function QuestUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TQuest = null;
         this.FTextField.SetHtmlText("");
         this.FRegisterAlreadyAccept.Clear();
         this.FRegisterCanAccept.Clear();
         this.FlushQuests(SLogicsCore.Character.MainQuestsAlreadyAccept,TAG_ALREADYACCEPT);
         this.FlushQuests(SLogicsCore.Character.SubQuestsAlreadyAccept,TAG_ALREADYACCEPT);
         this.FlushQuests(SLogicsCore.Character.MainQuestsCanAccept,TAG_CANACCEPT);
         this.FlushQuests(SLogicsCore.Character.SubQuestsCanAccept,TAG_CANACCEPT);
         _loc1_ = 0;
         _loc1_ = SLogicsCore.Character.MainQuestsAlreadyAccept.Count + SLogicsCore.Character.SubQuestsAlreadyAccept.Count;
         if(SLogicsCore.Character.MainQuestsCanAccept.Count != 0)
         {
            _loc2_ = SLogicsCore.Character.MainQuestsCanAccept.GetQuestByIndex(0);
         }
         if(_loc2_ != null && _loc2_.RequirementLevelMin <= SLogicsCore.Character.GetMainLevel())
         {
            this.FUITab.SwithTagManual(TAG_CANACCEPT);
         }
         else if(_loc1_ != 0)
         {
            this.FUITab.SwithTagManual(TAG_ALREADYACCEPT);
         }
         else
         {
            this.FUITab.SwithTagManual(TAG_CANACCEPT);
         }
      }
      
      public function Update() : void
      {
         if(this.FScorll != null)
         {
            this.FScorll.Update();
         }
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FScene.visible = true;
      }
      
      public function HideAllShortcuts() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FScene.visible = false;
      }
   }
}

