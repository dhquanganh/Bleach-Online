package Processors.Game.Lobby.MainSceneTwo
{
   import Logics.*;
   import Logics.Characters.TCharacter;
   import Logics.Map.*;
   import Logics.Quests.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.Map.MouseEventHander.TMouseEventHanderNpc;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Resources.Constants.*;
   
   public class TNpcManager
   {
      
      protected var FNpcs:Vector.<TSceneSpriteMoudleInMapNpc>;
      
      protected var FNpcsCanShow:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FCheckCondition:Vector.<Function>;
      
      protected var FUnstreamizerRoleNPC:TUnstreamizerRoleNPCTwo;
      
      protected var FMouseEventHander:TMouseEventHanderNpc;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FCheckAcceptQuests:Vector.<TQuests>;
      
      protected var FCheckCompleteQuests:Vector.<TQuests>;
      
      protected var FCurrentCityID:uint;
      
      protected var FFunOnNpcClicked:Function;
      
      public function TNpcManager(param1:TMapParameter)
      {
         var _loc2_:TCharacter = null;
         super();
         _loc2_ = SLogicsCore.Character;
         this.FMapParameter = param1;
         this.FCheckAcceptQuests = new Vector.<TQuests>();
         this.FCheckCompleteQuests = new Vector.<TQuests>();
         this.FCheckAcceptQuests.push(_loc2_.MainQuestsAlreadyAccept);
         this.FCheckAcceptQuests.push(_loc2_.SubQuestsAlreadyAccept);
         this.FCheckCompleteQuests.push(_loc2_.MainQuestComplete);
         this.FCheckCompleteQuests.push(_loc2_.SubQuestComplete);
         this.ConstructionComponent();
      }
      
      protected function ConstructionComponent() : void
      {
         this.FNpcs = new Vector.<TSceneSpriteMoudleInMapNpc>();
         this.FNpcsCanShow = new Vector.<TSceneSpriteMoudleInMap>();
         this.FCheckCondition = new Vector.<Function>();
         this.FCheckCondition.push(this.CheckByCity);
         this.FCheckCondition.push(this.CheckByQuest);
         this.FCheckCondition.push(this.CheckByLevel);
         this.FUnstreamizerRoleNPC = new TUnstreamizerRoleNPCTwo();
         this.FMouseEventHander = new TMouseEventHanderNpc();
         this.FMouseEventHander.Callback = this.ProcessorOnNpcCliked;
      }
      
      protected function SelectNpcCanShow(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudleInMapNpc = null;
         var _loc5_:Function = null;
         var _loc6_:Boolean = false;
         this.FNpcsCanShow.length = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FNpcs.length)
         {
            _loc4_ = this.FNpcs[_loc2_];
            _loc3_ = 0;
            while(_loc3_ < this.FCheckCondition.length)
            {
               _loc5_ = this.FCheckCondition[_loc3_];
               _loc6_ = _loc5_(_loc4_);
               if(!_loc6_)
               {
                  break;
               }
               _loc3_++;
            }
            if(_loc6_)
            {
               _loc4_.IfOpenUserFunction = this.CheckIfNpcFunctionOpen(_loc4_);
               _loc4_.UpdateHeadDecoration();
               _loc4_.ShowRoleMoudle();
               this.FNpcsCanShow.push(_loc4_);
            }
            _loc2_++;
         }
      }
      
      protected function CheckByCity(param1:TSceneSpriteMoudleInMapNpc) : Boolean
      {
         return param1.NpcCityID == this.FCurrentCityID;
      }
      
      protected function CheckByLevel(param1:TSceneSpriteMoudleInMapNpc) : Boolean
      {
         if(param1.NpcFunctionOpenConditionType == 3)
         {
            return param1.NpcFunctionOpenCondition <= SLogicsCore.Character.GetMainLevel();
         }
         return true;
      }
      
      protected function CheckByQuest(param1:TSceneSpriteMoudleInMapNpc) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:TQuests = null;
         _loc3_ = SLogicsCore.Character.MainQuestComplete;
         if(_loc3_.Count == 0)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = _loc3_.GetQuestByIndex(_loc3_.Count - 1).Identifier;
         }
         return param1.NpcQuestMin <= _loc2_ && param1.NpcQuestMax >= _loc2_;
      }
      
      public function InitAllNpc_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc1_ = 0;
         while(_loc1_ < this.FNpcs.length)
         {
            _loc2_ = this.FNpcs[_loc1_];
            _loc2_.MouseEventHander = this.FMouseEventHander;
            _loc2_.UpdateHeadDecoration();
            _loc2_.MapParameter = this.FMapParameter;
            _loc2_.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_NPC;
            _loc1_++;
         }
      }
      
      public function AddNewQuests(param1:TQuests) : void
      {
         var _loc2_:TQuest = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.GetQuestByIndex(_loc3_);
            this.AddNewQuest(_loc2_);
            _loc3_++;
         }
      }
      
      public function AddNewQuest(param1:TQuest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = this.GetQuestCareNpcID(param1.TaskState,param1);
         _loc3_ = this.GetNpcByNpcID(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_.Questes.Add(param1);
         }
      }
      
      protected function GetNpcByNpcID(param1:uint) : TSceneSpriteMoudleInMapNpc
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = 0;
         while(_loc2_ < this.FNpcs.length)
         {
            _loc3_ = this.FNpcs[_loc2_];
            if(_loc3_.RoleTempleteID == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function GetQuestCareNpcID(param1:int, param2:TQuest) : int
      {
         switch(param1)
         {
            case CONST_QUEST.STATE_ACCEPT:
               return param2.AcceptTaskNpc;
            case CONST_QUEST.STATE_TASKING:
               if(param2.EventType == CONST_QUEST.QuestEventTypeJustRun)
               {
                  return param2.BackTaskNpc;
               }
               return param2.AcceptTaskNpc;
               break;
            case CONST_QUEST.STATE_TASKBACK:
               return param2.BackTaskNpc;
            case CONST_QUEST.STATE_ALREADYBACK:
               return param2.BackTaskNpc;
            default:
               return 0;
         }
      }
      
      protected function UpdateQuest_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc1_ = 0;
         while(_loc1_ < this.FNpcs.length)
         {
            _loc2_ = this.FNpcs[_loc1_];
            _loc2_.Questes.Clear();
            _loc1_++;
         }
         this.AddNewQuests(SLogicsCore.Character.MainQuestsAlreadyAccept);
         this.AddNewQuests(SLogicsCore.Character.SubQuestsAlreadyAccept);
         this.AddNewQuests(SLogicsCore.Character.MainQuestsCanAccept);
         this.AddNewQuests(SLogicsCore.Character.SubQuestsCanAccept);
         _loc1_ = 0;
         while(_loc1_ < this.FNpcs.length)
         {
            _loc2_ = this.FNpcs[_loc1_];
            _loc2_.Questes.SortByQuestState();
            _loc2_.UpdateHeadDecoration();
            _loc1_++;
         }
      }
      
      protected function GetNpcByID_Perform(param1:uint) : TSceneSpriteMoudleInMapNpc
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = 0;
         while(_loc2_ < this.FNpcs.length)
         {
            _loc3_ = this.FNpcs[_loc2_];
            if(_loc3_.RoleTempleteID == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function CheckIfNpcFunctionOpen(param1:TSceneSpriteMoudleInMapNpc) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:TQuests = null;
         var _loc4_:int = 0;
         if(param1.UserType == 1)
         {
            return false;
         }
         switch(param1.NpcFunctionOpenConditionType)
         {
            case 0:
               return true;
            case CONST_NPC.NpcFunctionOpenType_AcceptQuest:
               _loc2_ = 0;
               while(true)
               {
                  if(_loc2_ < this.FCheckAcceptQuests.length)
                  {
                     _loc3_ = this.FCheckAcceptQuests[_loc2_];
                     if(_loc3_.Count != 0)
                     {
                        _loc4_ = int(_loc3_.GetQuestByIndex(_loc3_.Count - 1).Identifier);
                     }
                     else
                     {
                        _loc4_ = 0;
                     }
                     if(param1.NpcFunctionOpenCondition <= _loc4_ && param1.NpcFunctionCloseCondition >= _loc4_)
                     {
                        break;
                     }
                     _loc2_++;
                     continue;
                  }
               }
               return true;
            case CONST_NPC.NpcFunctionOpenType_CompleteQuest:
               _loc2_ = 0;
               while(_loc2_ < this.FCheckCompleteQuests.length)
               {
                  _loc3_ = this.FCheckCompleteQuests[_loc2_];
                  if(_loc3_.Count != 0)
                  {
                     _loc4_ = int(_loc3_.GetQuestByIndex(_loc3_.Count - 1).Identifier);
                  }
                  else
                  {
                     _loc4_ = 0;
                  }
                  if(param1.NpcFunctionOpenCondition <= _loc4_ && param1.NpcFunctionCloseCondition >= _loc4_)
                  {
                     return true;
                  }
                  _loc2_++;
               }
               break;
            case CONST_NPC.NpcFunctionOpenType_Level:
               if(param1.NpcFunctionOpenCondition < SLogicsCore.Character.GetMainLevel())
               {
                  return true;
               }
         }
         return false;
      }
      
      protected function ProcessorOnNpcCliked(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         if(this.FFunOnNpcClicked != null)
         {
            this.FFunOnNpcClicked(param1);
         }
      }
      
      public function get NpcsCanShow() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FNpcsCanShow;
      }
      
      public function set FunOnNpcClicked(param1:Function) : void
      {
         this.FFunOnNpcClicked = param1;
      }
      
      public function get Npcs() : Vector.<TSceneSpriteMoudleInMapNpc>
      {
         return this.FNpcs;
      }
      
      public function ShowNpcByCityID(param1:uint) : void
      {
         this.FCurrentCityID = param1;
         this.SelectNpcCanShow(this.FCurrentCityID);
      }
      
      public function InitAllNpc() : void
      {
         this.FUnstreamizerRoleNPC.Unstreamize(null,this.FNpcs,null);
         this.InitAllNpc_Perform();
      }
      
      public function UpdateQuest() : void
      {
         this.UpdateQuest_Perform();
         this.ShowNpcByCityID(this.FCurrentCityID);
      }
      
      public function GetNpcByID(param1:uint) : TSceneSpriteMoudleInMapNpc
      {
         return this.GetNpcByID_Perform(param1);
      }
   }
}

