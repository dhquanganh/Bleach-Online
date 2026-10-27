package Processors.Game.Lobby.Quests
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Quests.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowQuest extends TProcessorLobbyWindow
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var TAG_ShowAlreadyAcceptTask:int = 0;
      
      protected var TAG_ShowCanAcceptTask:int = 1;
      
      protected var QuestList1_Index:int = 0;
      
      protected var QuestList2_Index:int = 1;
      
      protected var QuestList3_Index:int = 2;
      
      protected var QuestList4_Index:int = 3;
      
      protected var FMC_MainTaskList:MovieClip;
      
      protected var FMC_MainScrollBar:MovieClip;
      
      protected var FBtn_MainTaskHide:MovieClip;
      
      protected var FMC_SubTaskList:MovieClip;
      
      protected var FMC_SubScrollBar:MovieClip;
      
      protected var FBtn_SubTaskHide:MovieClip;
      
      protected var FMC_MainTaskInforBacks:Vector.<MovieClip>;
      
      protected var FMC_MainTaskInforItems:Vector.<MovieClip>;
      
      protected var FTF_MainTaskInforItems:Vector.<TextField>;
      
      protected var FMC_SubTaskInforBacks:Vector.<MovieClip>;
      
      protected var FMC_SubTaskInforItems:Vector.<MovieClip>;
      
      protected var FTF_SubTaskInforItems:Vector.<TextField>;
      
      protected var FCurrentQuestRewards:TInventories;
      
      protected var FTF_QuestDescribe:TextField;
      
      protected var FTF_CompleteCondition:TextField;
      
      protected var FTF_Reward:TextField;
      
      protected var FMC_Rewards:Vector.<MovieClip>;
      
      protected var FRewards:Vector.<TUISlot>;
      
      protected var FUITab:TUITab;
      
      protected var FBtn_Infor:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FTF_DoQuest:TextField;
      
      protected var FQustesList:Vector.<TQuestListInfor>;
      
      protected var FCurrentTag:int;
      
      protected var FCurrentShowQuest:TQuest;
      
      protected var FInitialization:Boolean;
      
      protected var FHelpTips:THint;
      
      protected var FAlreadyAcceptMainQuestes:TQuests;
      
      protected var FAlreadyAcceptSubQuestes:TQuests;
      
      protected var FCanAcceptMainQuestes:TQuests;
      
      protected var FCanAcceptSubQuestes:TQuests;
      
      protected var FOnTextClick:Function;
      
      protected var FRewardName:Vector.<String>;
      
      public function TProcessorWindowQuest(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_QUEST.RESOURCESID_Swf_Quest);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:TUISlot = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("TaskUI") as MovieClip;
         addChild(_loc3_);
         this.FUITab = new TUITab(this);
         _loc2_ = _loc3_["Btn_AlreadyAccept"];
         _loc2_.mouseChildren = false;
         this.FUITab.SetTabByIndex(_loc2_,0);
         _loc2_ = _loc3_["Btn_CanAccept"];
         _loc2_.mouseChildren = false;
         this.FUITab.SetTabByIndex(_loc2_,1);
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FTF_QuestDescribe = _loc3_["TF_QuestDescribe"];
         this.FTF_CompleteCondition = _loc3_["TF_CompleteCondition"];
         this.FTF_Reward = _loc3_["TF_Reward"];
         this.FMC_Rewards = new Vector.<MovieClip>();
         this.FRewards = new Vector.<TUISlot>();
         _loc1_ = 0;
         while(_loc1_ < CONST_QUEST.TaskRewardAddIconMCNum)
         {
            _loc2_ = _loc3_["MC_Reward" + (_loc1_ + 1)];
            _loc7_ = new TUISlot(this);
            _loc7_.Resource = _loc2_;
            this.FRewards.push(_loc7_);
            this.FMC_Rewards.push(_loc2_);
            _loc1_++;
         }
         this.FCurrentQuestRewards = new TInventories();
         this.FMC_MainTaskList = _loc3_["MC_MainTaskList"];
         this.FMC_MainScrollBar = this.FMC_MainTaskList["MC_ScrollBar"];
         _loc4_ = this.FMC_MainTaskList["MC_TaskLable"];
         this.FBtn_MainTaskHide = _loc4_["Btn_TaskHide"];
         _loc4_["TF_TaskType"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_9);
         _loc4_["TF_TaskType"].mouseEnabled = false;
         this.FMC_SubTaskList = _loc3_["MC_SubTaskList"];
         this.FMC_SubScrollBar = this.FMC_SubTaskList["MC_ScrollBar"];
         _loc5_ = this.FMC_SubTaskList["MC_TaskLable"];
         this.FBtn_SubTaskHide = _loc5_["Btn_TaskHide"];
         _loc5_["TF_TaskType"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_10);
         _loc5_["TF_TaskType"].mouseEnabled = false;
         this.FMC_MainTaskInforItems = new Vector.<MovieClip>();
         this.FTF_MainTaskInforItems = new Vector.<TextField>();
         this.FMC_MainTaskInforBacks = new Vector.<MovieClip>();
         this.FMC_SubTaskInforItems = new Vector.<MovieClip>();
         this.FTF_SubTaskInforItems = new Vector.<TextField>();
         this.FMC_SubTaskInforBacks = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < CONST_QUEST.TaskInforItemNum)
         {
            _loc2_ = this.FMC_MainTaskList["MC_TaskItem" + (_loc1_ + 1)];
            _loc2_.gotoAndStop("base");
            _loc6_ = _loc2_["TF_ItemText"];
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnMainTaskItemClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
            this.FMC_MainTaskInforItems.push(_loc2_);
            this.FTF_MainTaskInforItems.push(_loc6_);
            _loc2_ = this.FMC_SubTaskList["MC_TaskItem" + (_loc1_ + 1)];
            _loc2_.gotoAndStop("base");
            _loc6_ = _loc2_["TF_ItemText"];
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnSubTaskItemClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
            this.FMC_SubTaskInforItems.push(_loc2_);
            this.FTF_SubTaskInforItems.push(_loc6_);
            _loc1_++;
         }
         this.FBtn_MainTaskHide.addEventListener(MouseEvent.CLICK,this.OnMainTaskHideClick);
         this.FBtn_SubTaskHide.addEventListener(MouseEvent.CLICK,this.OnSubTaskHideClick);
         this.FBtn_Close = _loc3_["Btn_Close"];
         this.FBtn_Infor = _loc3_["Btn_Infor"];
         this.FTF_DoQuest = _loc3_["DoQuest"];
         this.FRewardName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_12);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:int = 0;
         var _loc4_:SimpleButton = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         this.FBtn_Infor.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Infor.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FTF_DoQuest.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_11);
         this.FTF_DoQuest.addEventListener(TextEvent.LINK,this.OnBtnDoQuestClick);
         _loc1_ = 0;
         while(_loc1_ < this.FRewards.length)
         {
            _loc2_ = this.FRewards[_loc1_];
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc2_.Init();
            _loc1_++;
         }
         this.FTF_CompleteCondition.addEventListener(TextEvent.LINK,this.HandleOnTextClick);
         this.FQustesList = new Vector.<TQuestListInfor>();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.FQustesList.push(new TQuestListInfor());
            _loc1_++;
         }
         _loc4_ = this.FMC_MainScrollBar["Up"];
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnMainQuestBarUpArrowClick);
         _loc4_ = this.FMC_MainScrollBar["Down"];
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnMainQuestBarDownArrowClick);
         _loc4_ = this.FMC_SubScrollBar["Up"];
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnSubQuestBarUpArrowClick);
         _loc4_ = this.FMC_SubScrollBar["Down"];
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnSubQuestBarDownArrowClick);
         this.Reset();
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            _loc2_ = int(this.FRewards.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FRewards[_loc1_].Update();
               _loc1_++;
            }
         }
      }
      
      protected function SwitchTag(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.FCurrentTag = param1;
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               this.ShowOneQuestsListInfor(this.FMC_MainTaskInforItems,this.FTF_MainTaskInforItems,this.FMC_MainScrollBar,this.FQustesList[this.QuestList1_Index]);
               if(this.FQustesList[this.QuestList1_Index].IfHide)
               {
                  this.FBtn_MainTaskHide.gotoAndStop("down");
               }
               else
               {
                  this.FBtn_MainTaskHide.gotoAndStop("up");
               }
               _loc2_ = CONST_QUEST.TaskInforItemNum - this.FQustesList[this.QuestList1_Index].ShowQuestNum;
               this.FMC_SubTaskList.y = CONST_QUEST.SUBTASKLIST_BASEY - _loc2_ * CONST_QUEST.SINGLETASKNAME_HEIGHT;
               this.ShowOneQuestsListInfor(this.FMC_SubTaskInforItems,this.FTF_SubTaskInforItems,this.FMC_SubScrollBar,this.FQustesList[this.QuestList2_Index]);
               if(this.FQustesList[this.QuestList2_Index].IfHide)
               {
                  this.FBtn_SubTaskHide.gotoAndStop("down");
               }
               else
               {
                  this.FBtn_SubTaskHide.gotoAndStop("up");
               }
               break;
            case this.TAG_ShowCanAcceptTask:
               this.ShowOneQuestsListInfor(this.FMC_MainTaskInforItems,this.FTF_MainTaskInforItems,this.FMC_MainScrollBar,this.FQustesList[this.QuestList3_Index]);
               if(this.FQustesList[this.QuestList3_Index].IfHide)
               {
                  this.FBtn_MainTaskHide.gotoAndStop("down");
               }
               else
               {
                  this.FBtn_MainTaskHide.gotoAndStop("up");
               }
               _loc2_ = CONST_QUEST.TaskInforItemNum - this.FQustesList[this.QuestList3_Index].ShowQuestNum;
               this.FMC_SubTaskList.y = CONST_QUEST.SUBTASKLIST_BASEY - _loc2_ * CONST_QUEST.SINGLETASKNAME_HEIGHT;
               this.ShowOneQuestsListInfor(this.FMC_SubTaskInforItems,this.FTF_SubTaskInforItems,this.FMC_SubScrollBar,this.FQustesList[this.QuestList4_Index]);
               if(this.FQustesList[this.QuestList4_Index].IfHide)
               {
                  this.FBtn_SubTaskHide.gotoAndStop("down");
               }
               else
               {
                  this.FBtn_SubTaskHide.gotoAndStop("up");
               }
         }
      }
      
      protected function ClearQuestInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         this.FTF_QuestDescribe.text = "";
         this.FTF_CompleteCondition.text = "";
         this.FTF_Reward.text = "";
         _loc1_ = 0;
         while(_loc1_ < this.FRewards.length)
         {
            _loc2_ = this.FRewards[_loc1_];
            this.FMC_Rewards[_loc1_].visible = false;
            _loc2_.Context = null;
            _loc1_++;
         }
         this.FTF_DoQuest.visible = false;
      }
      
      protected function ShowOneQuestsListInfor(param1:Vector.<MovieClip>, param2:Vector.<TextField>, param3:MovieClip, param4:TQuestListInfor) : void
      {
         var _loc5_:TQuest = null;
         this.HideTaskListMC(param1,param3,param4);
         if(param4.SelectedQuestIndex != -1 && param4.FirstShowQuesteIndex <= param4.SelectedQuestIndex && param4.SelectedQuestIndex <= param4.FirstShowQuesteIndex + CONST_QUEST.TaskInforItemNum - 1)
         {
            param1[param4.SelectedQuestIndex - param4.FirstShowQuesteIndex].gotoAndStop("chosen");
         }
         this.ShowOneGroupTaskInfor(param1,param4);
         if(param4.SelectedQuestIndex != -1)
         {
            _loc5_ = param4.BindingQuestes.GetQuestByIndex(param4.SelectedQuestIndex);
            this.ShowOneQuestInfor(_loc5_);
            this.FCurrentShowQuest = _loc5_;
         }
      }
      
      protected function ShowOneGroupTaskInfor(param1:Vector.<MovieClip>, param2:TQuestListInfor) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         var _loc6_:TQuest = null;
         var _loc7_:MovieClip = null;
         if(param2.IfHide)
         {
            return;
         }
         _loc4_ = param2.BindingQuestes.Count - param2.FirstShowQuesteIndex;
         param2.ShowQuestNum = 0;
         _loc3_ = 0;
         while(_loc3_ < CONST_QUEST.TaskInforItemNum && _loc3_ < _loc4_)
         {
            _loc7_ = param1[_loc3_];
            _loc5_ = _loc7_["TF_ItemText"];
            _loc6_ = param2.BindingQuestes.GetQuestByIndex(_loc3_ + param2.FirstShowQuesteIndex);
            _loc5_.text = _loc6_.Name;
            ++param2.ShowQuestNum;
            _loc3_++;
         }
      }
      
      protected function HideTaskListMC(param1:Vector.<MovieClip>, param2:MovieClip, param3:TQuestListInfor) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param3.IfHide)
         {
            _loc5_ = 0;
         }
         else
         {
            _loc5_ = param3.BindingQuestes.Count;
         }
         _loc4_ = 0;
         while(_loc4_ < CONST_QUEST.TaskInforItemNum)
         {
            if(_loc4_ < _loc5_)
            {
               param1[_loc4_].visible = true;
               param1[_loc4_].gotoAndStop("base");
            }
            else
            {
               param1[_loc4_].visible = false;
            }
            _loc4_++;
         }
         if(_loc5_ < CONST_QUEST.TaskInforItemNum)
         {
            param2.visible = false;
         }
         else
         {
            param2.visible = true;
         }
      }
      
      protected function ShowOneQuestInfor(param1:TQuest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TItems = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:String = null;
         this.FTF_QuestDescribe.text = param1.Description;
         this.FTF_CompleteCondition.htmlText = param1.TaskGuideInforCompound;
         this.FTF_Reward.text = this.GetRewardDescription(param1.RewardsInventory);
         this.FCurrentQuestRewards.Clear();
         this.GetRewardsOfInventory(param1.RewardsInventory,this.FCurrentQuestRewards);
         _loc4_ = this.FCurrentQuestRewards.Count;
         _loc5_ = int(CONST_QUEST.TaskRewardAddIconMCNum);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc6_ = this.FRewards[_loc2_];
            if(_loc2_ < _loc4_)
            {
               this.FMC_Rewards[_loc2_].visible = true;
               _loc6_.Context = this.FCurrentQuestRewards.GetInventoryByIndex(_loc2_);
            }
            else
            {
               this.FMC_Rewards[_loc2_].visible = false;
            }
            _loc2_++;
         }
         this.FTF_DoQuest.visible = true;
      }
      
      protected function GetRewardDescription(param1:TInventories) : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<uint> = null;
         _loc6_ = "";
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetInventoryByIndex(_loc3_);
            _loc2_ = this.IfInventory(_loc5_.IDTemplate);
            if(!_loc2_)
            {
               _loc10_ = CONST_COMMON.REWARDIDNotInventory_DATA;
               _loc9_ = _loc10_.indexOf(_loc5_.IDTemplate);
               _loc7_ = int(CONST_COMMON.REWARDID_TOMAINCODE[_loc9_]);
               _loc8_ = int(CONST_COMMON.REWARDID_TOSUBCODE[_loc9_]);
               _loc6_ += TUtilityLobby.GetItemName(_loc7_,_loc8_);
               _loc6_ = _loc6_ + (":" + _loc5_.Quantity + "    ");
            }
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function GetRewardsOfInventory(param1:TInventories, param2:TInventories) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         _loc5_ = param1.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.GetInventoryByIndex(_loc4_);
            _loc3_ = this.IfInventory(_loc6_.IDTemplate);
            if(_loc3_)
            {
               param2.Add(_loc6_);
            }
            _loc4_++;
         }
      }
      
      protected function IfInventory(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc3_ = CONST_COMMON.REWARDIDNotInventory_DATA;
         _loc2_ = _loc3_.indexOf(param1);
         return _loc2_ < 0;
      }
      
      protected function HandleOneReward(param1:TItem, param2:TextField) : void
      {
         var _loc3_:String = null;
         var _loc4_:TAppliance = null;
         var _loc5_:TEquipment = null;
         switch(param1.Type)
         {
            case 0:
               _loc3_ = this.FRewardName[param1.ID];
               param2.appendText(_loc3_ + ":" + param1.Count);
               break;
            case 1:
               _loc4_ = SLogicsCore.PoolInventory.AcquireAppliance(0);
               _loc4_.IDTemplate = param1.ID;
               _loc4_.Quantity = param1.Count;
               break;
            case 2:
               param2.appendText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Quest_STRING_8) + param1.Count);
         }
      }
      
      protected function OnMainTaskItemClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_MainTaskInforItems.indexOf(_loc3_);
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               this.FQustesList[this.QuestList1_Index].SelectedQuestIndex = this.FQustesList[this.QuestList1_Index].FirstShowQuesteIndex + _loc2_;
               this.FQustesList[this.QuestList2_Index].SelectedQuestIndex = -1;
               break;
            case this.TAG_ShowCanAcceptTask:
               this.FQustesList[this.QuestList3_Index].SelectedQuestIndex = this.FQustesList[this.QuestList3_Index].FirstShowQuesteIndex + _loc2_;
               this.FQustesList[this.QuestList4_Index].SelectedQuestIndex = -1;
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnSubTaskItemClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_SubTaskInforItems.indexOf(_loc3_);
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               this.FQustesList[this.QuestList2_Index].SelectedQuestIndex = this.FQustesList[this.QuestList2_Index].FirstShowQuesteIndex + _loc2_;
               this.FQustesList[this.QuestList1_Index].SelectedQuestIndex = -1;
               break;
            case this.TAG_ShowCanAcceptTask:
               this.FQustesList[this.QuestList4_Index].SelectedQuestIndex = this.FQustesList[this.QuestList4_Index].FirstShowQuesteIndex + _loc2_;
               this.FQustesList[this.QuestList3_Index].SelectedQuestIndex = -1;
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.ClearQuestInfor();
         this.SwitchTag(_loc2_);
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent = null) : void
      {
         this.Reset();
         super.ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSystemLanguage = null;
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.HELPTIPS_Quest) as TSystemLanguage;
            this.FHelpTips.Content = _loc2_.Desc;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHelpTips);
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHelpTips);
      }
      
      protected function HandleOnTextClick(param1:TextEvent) : void
      {
         if(this.FOnTextClick != null)
         {
            this.FOnTextClick(param1.text);
         }
         this.OnCloseBtnClick();
      }
      
      protected function OnMainTaskHideClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               this.FQustesList[this.QuestList1_Index].IfHide = !this.FQustesList[this.QuestList1_Index].IfHide;
               this.FQustesList[this.QuestList1_Index].ShowQuestNum = 0;
               break;
            case this.TAG_ShowCanAcceptTask:
               this.FQustesList[this.QuestList3_Index].IfHide = !this.FQustesList[this.QuestList3_Index].IfHide;
               this.FQustesList[this.QuestList3_Index].ShowQuestNum = 0;
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnSubTaskHideClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               this.FQustesList[this.QuestList2_Index].IfHide = !this.FQustesList[this.QuestList2_Index].IfHide;
               this.FQustesList[this.QuestList2_Index].ShowQuestNum = 0;
               break;
            case this.TAG_ShowCanAcceptTask:
               this.FQustesList[this.QuestList4_Index].IfHide = !this.FQustesList[this.QuestList4_Index].IfHide;
               this.FQustesList[this.QuestList4_Index].ShowQuestNum = 0;
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnMainQuestBarUpArrowClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               if(this.FQustesList[this.QuestList1_Index].FirstShowQuesteIndex > 0)
               {
                  --this.FQustesList[this.QuestList1_Index].FirstShowQuesteIndex;
               }
               break;
            case this.TAG_ShowCanAcceptTask:
               if(this.FQustesList[this.QuestList3_Index].FirstShowQuesteIndex > 0)
               {
                  --this.FQustesList[this.QuestList3_Index].FirstShowQuesteIndex;
               }
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnMainQuestBarDownArrowClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               if(this.FQustesList[this.QuestList1_Index].FirstShowQuesteIndex + CONST_QUEST.TaskInforItemNum < this.FQustesList[this.QuestList1_Index].BindingQuestes.Count)
               {
                  ++this.FQustesList[this.QuestList1_Index].FirstShowQuesteIndex;
               }
               break;
            case this.TAG_ShowCanAcceptTask:
               if(this.FQustesList[this.QuestList3_Index].FirstShowQuesteIndex + CONST_QUEST.TaskInforItemNum < this.FQustesList[this.QuestList3_Index].BindingQuestes.Count)
               {
                  ++this.FQustesList[this.QuestList3_Index].FirstShowQuesteIndex;
               }
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnSubQuestBarUpArrowClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               if(this.FQustesList[this.QuestList2_Index].FirstShowQuesteIndex > 0)
               {
                  --this.FQustesList[this.QuestList2_Index].FirstShowQuesteIndex;
               }
               break;
            case this.TAG_ShowCanAcceptTask:
               if(this.FQustesList[this.QuestList4_Index].FirstShowQuesteIndex > 0)
               {
                  --this.FQustesList[this.QuestList4_Index].FirstShowQuesteIndex;
               }
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnSubQuestBarDownArrowClick(param1:MouseEvent) : void
      {
         switch(this.FCurrentTag)
         {
            case this.TAG_ShowAlreadyAcceptTask:
               if(this.FQustesList[this.QuestList2_Index].FirstShowQuesteIndex + CONST_QUEST.TaskInforItemNum < this.FQustesList[this.QuestList2_Index].BindingQuestes.Count)
               {
                  ++this.FQustesList[this.QuestList2_Index].FirstShowQuesteIndex;
               }
               break;
            case this.TAG_ShowCanAcceptTask:
               if(this.FQustesList[this.QuestList4_Index].FirstShowQuesteIndex + CONST_QUEST.TaskInforItemNum < this.FQustesList[this.QuestList4_Index].BindingQuestes.Count)
               {
                  ++this.FQustesList[this.QuestList4_Index].FirstShowQuesteIndex;
               }
         }
         this.SwitchTag(this.FCurrentTag);
      }
      
      protected function OnBtnDoQuestClick(param1:TextEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this.FCurrentShowQuest != null)
         {
            SLogicsCore.QuestAutoSearchWay.AutoSearyWay(this.FCurrentShowQuest);
         }
         this.OnCloseBtnClick();
      }
      
      protected function OnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrameLabel == "chosen")
         {
            return;
         }
         _loc3_ = _loc2_["TF_ItemText"];
         _loc4_ = _loc3_.text;
         _loc2_.gotoAndStop("over");
         _loc3_ = _loc2_["TF_ItemText"];
         _loc3_.text = _loc4_;
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrameLabel == "chosen")
         {
            return;
         }
         _loc3_ = _loc2_["TF_ItemText"];
         _loc4_ = _loc3_.text;
         _loc2_.gotoAndStop("base");
         _loc3_ = _loc2_["TF_ItemText"];
         _loc3_.text = _loc4_;
      }
      
      public function set AlreadyAcceptMainQuestes(param1:TQuests) : void
      {
         this.FQustesList[this.QuestList1_Index].BindingQuestes = param1;
         if(param1.Count > 0)
         {
            this.FQustesList[0].FirstShowQuesteIndex = 0;
            this.FQustesList[0].SelectedQuestIndex = 0;
         }
      }
      
      public function set AlreadyAcceptSubQuestes(param1:TQuests) : void
      {
         this.FQustesList[this.QuestList2_Index].BindingQuestes = param1;
      }
      
      public function set CanAcceptMainQuestes(param1:TQuests) : void
      {
         this.FQustesList[this.QuestList3_Index].BindingQuestes = param1;
      }
      
      public function set CanAcceptSubQuestes(param1:TQuests) : void
      {
         this.FQustesList[this.QuestList4_Index].BindingQuestes = param1;
      }
      
      public function set OnTextClick(param1:Function) : void
      {
         this.FOnTextClick = param1;
      }
      
      public function Update() : void
      {
         this.FQustesList[0].IfHide = this.FQustesList[0].BindingQuestes.Count == 0;
         this.TabOnSwitch(0);
      }
      
      protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:TQuestListInfor = null;
         if(this.FCurrentTag != 0)
         {
            this.FUITab.SwithTagManual(0);
         }
         _loc1_ = 0;
         while(_loc1_ < this.FQustesList.length)
         {
            _loc3_ = this.FQustesList[_loc1_];
            if(_loc3_ != null)
            {
               _loc3_.BindingQuestes = null;
               _loc3_.FirstShowQuesteIndex = 0;
               _loc3_.IfHide = true;
               _loc3_.SelectedQuestIndex = -1;
               _loc3_.ShowQuestNum = 0;
            }
            _loc1_++;
         }
         this.FCurrentShowQuest = null;
         this.ClearQuestInfor();
      }
   }
}

