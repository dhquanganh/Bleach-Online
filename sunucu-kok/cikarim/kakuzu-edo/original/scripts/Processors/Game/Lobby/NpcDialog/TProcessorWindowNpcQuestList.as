package Processors.Game.Lobby.NpcDialog
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.TCharacter;
   import Logics.Quests.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowNpcQuestList extends TUIComponent
   {
      
      protected static const SHOUTCUTS_NUM:int = 5;
      
      protected static const USERTYPE_COLOR:uint = 16762394;
      
      public static const SHORTCUTTYPE_USERTYPE:int = 1;
      
      public static const SHORTCUTTYPE_QUEST:int = 2;
      
      protected var FQuestShortcuts:Vector.<MovieClip>;
      
      protected var FQuestShortcutsLable:Vector.<TextField>;
      
      protected var FNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FUserTypeNames:Vector.<String>;
      
      protected var FQuestStateText:Vector.<String>;
      
      protected var FCheckAcceptQuests:Vector.<TQuests>;
      
      protected var FCheckCompleteQuests:Vector.<TQuests>;
      
      protected var FShortCutClicked:Function;
      
      public function TProcessorWindowNpcQuestList(param1:TUIComponent)
      {
         var _loc2_:TCharacter = null;
         super(param1);
         _loc2_ = SLogicsCore.Character;
         this.FQuestShortcuts = new Vector.<MovieClip>();
         this.FQuestShortcutsLable = new Vector.<TextField>();
         this.FCheckAcceptQuests = new Vector.<TQuests>();
         this.FCheckCompleteQuests = new Vector.<TQuests>();
         this.FCheckAcceptQuests.push(_loc2_.MainQuestsAlreadyAccept);
         this.FCheckAcceptQuests.push(_loc2_.SubQuestsAlreadyAccept);
         this.FCheckCompleteQuests.push(_loc2_.MainQuestComplete);
         this.FCheckCompleteQuests.push(_loc2_.SubQuestComplete);
      }
      
      public function UIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         param1.gotoAndStop(2);
         _loc4_ = param1["UI_QuestList"];
         this.x = _loc4_.x;
         this.y = _loc4_.y;
         _loc4_.x = 0;
         _loc4_.y = 0;
         addChild(_loc4_);
         _loc2_ = 0;
         while(_loc2_ < SHOUTCUTS_NUM)
         {
            _loc3_ = _loc4_["MC_QuestItem" + (_loc2_ + 1)];
            this.FQuestShortcuts.push(_loc3_);
            this.FQuestShortcutsLable.push(_loc3_["TF_ItemText"]);
            _loc2_++;
         }
         this.FUserTypeNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_0);
         this.FQuestStateText = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.NpcDialog_STRING_0);
      }
      
      public function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < SHOUTCUTS_NUM)
         {
            _loc2_ = this.FQuestShortcuts[_loc1_];
            TGameUtil.setButtonMode(_loc2_,true);
            _loc2_.addEventListener(MouseEvent.CLICK,this.QuestShortcutClicked);
            _loc1_++;
         }
      }
      
      protected function CheckIfNpcFunctionOpen() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:TQuests = null;
         var _loc3_:int = 0;
         if(this.FNpc.UserType == 1)
         {
            return false;
         }
         switch(this.FNpc.NpcFunctionOpenConditionType)
         {
            case 0:
               return true;
            case CONST_NPC.NpcFunctionOpenType_AcceptQuest:
               _loc1_ = 0;
               while(true)
               {
                  if(_loc1_ < this.FCheckAcceptQuests.length)
                  {
                     _loc2_ = this.FCheckAcceptQuests[_loc1_];
                     if(_loc2_.Count != 0)
                     {
                        _loc3_ = int(_loc2_.GetQuestByIndex(_loc2_.Count - 1).Identifier);
                     }
                     else
                     {
                        _loc3_ = 0;
                     }
                     if(this.FNpc.NpcFunctionOpenCondition <= _loc3_ && this.FNpc.NpcFunctionCloseCondition >= _loc3_)
                     {
                        break;
                     }
                     _loc1_++;
                     continue;
                  }
               }
               return true;
            case CONST_NPC.NpcFunctionOpenType_CompleteQuest:
               _loc1_ = 0;
               while(_loc1_ < this.FCheckCompleteQuests.length)
               {
                  _loc2_ = this.FCheckCompleteQuests[_loc1_];
                  if(_loc2_.Count != 0)
                  {
                     _loc3_ = int(_loc2_.GetQuestByIndex(_loc2_.Count - 1).Identifier);
                  }
                  else
                  {
                     _loc3_ = 0;
                  }
                  if(this.FNpc.NpcFunctionOpenCondition <= _loc3_ && this.FNpc.NpcFunctionCloseCondition >= _loc3_)
                  {
                     return true;
                  }
                  _loc1_++;
               }
         }
         return false;
      }
      
      protected function InitUIByNpc(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc2_ = 0;
         if(param1.IfOpenUserFunction)
         {
            _loc2_ += 1;
         }
         _loc2_ += param1.Questes.Count;
         _loc2_ = _loc2_ > SHOUTCUTS_NUM ? SHOUTCUTS_NUM : _loc2_;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FQuestShortcuts[_loc3_].visible = true;
            _loc3_++;
         }
         _loc3_ = _loc2_;
         while(_loc3_ < this.FQuestShortcuts.length)
         {
            this.FQuestShortcuts[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      protected function ShowQuests(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TQuest = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc2_ = param1.Questes.Count;
         _loc2_ = _loc2_ > SHOUTCUTS_NUM ? SHOUTCUTS_NUM : _loc2_;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.Questes.GetQuestByIndex(_loc3_);
            _loc5_ = this.GetQuestStateDescriptionString(_loc4_.TaskState);
            _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NpcDialog_STRING_2),_loc4_.Name,_loc5_);
            this.FQuestShortcutsLable[_loc3_].text = _loc5_;
            _loc6_ = _loc4_.TaskState;
            if(_loc4_.Category == CONST_QUEST.QuestCategory_Main && _loc4_.RequirementLevelMin > SLogicsCore.Character.GetMainLevel())
            {
               _loc6_ = CONST_QUEST.STATE_PREVIEW;
            }
            this.FQuestShortcutsLable[_loc3_].textColor = this.GetQuestStateColor(_loc6_);
            _loc3_++;
         }
      }
      
      protected function ShowUserType(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         var _loc2_:int = 0;
         if(param1.UserType == 1)
         {
            return;
         }
         if(param1.Questes.Count >= SHOUTCUTS_NUM)
         {
            return;
         }
         _loc2_ = param1.Questes.Count;
         this.FQuestShortcutsLable[_loc2_].text = this.FUserTypeNames[param1.UserType];
         this.FQuestShortcutsLable[_loc2_].textColor = USERTYPE_COLOR;
      }
      
      protected function GetQuestStateDescriptionString(param1:int) : String
      {
         return this.FQuestStateText[param1];
      }
      
      protected function GetQuestStateColor(param1:int) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         _loc3_ = CONST_NPC.QUESTICON_STATE;
         _loc2_ = _loc3_.indexOf(param1);
         return CONST_NPC.QUESTICON_STATE_COLOR[_loc2_];
      }
      
      private function QuestShortcutClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FQuestShortcuts.indexOf(_loc3_);
         if(_loc2_ < this.FNpc.Questes.Count)
         {
            this.FShortCutClicked(SHORTCUTTYPE_QUEST,_loc2_);
         }
         else
         {
            this.FShortCutClicked(SHORTCUTTYPE_USERTYPE,this.FNpc.UserType);
         }
      }
      
      public function get ShortCutClicked() : Function
      {
         return this.FShortCutClicked;
      }
      
      public function set ShortCutClicked(param1:Function) : void
      {
         this.FShortCutClicked = param1;
      }
      
      public function ShowByNpc(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         this.FNpc = param1;
         this.InitUIByNpc(param1);
         this.ShowQuests(param1);
         this.ShowUserType(param1);
      }
   }
}

