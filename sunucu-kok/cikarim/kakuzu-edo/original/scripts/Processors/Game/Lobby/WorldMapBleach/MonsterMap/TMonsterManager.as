package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Foundation.Common.*;
   import Logics.*;
   import Logics.Map.*;
   import Logics.Quests.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.Map.MouseEventHander.TMouseEventHanderMonster;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Resources.Constants.*;
   import ghostcat.operation.quest.*;
   
   public class TMonsterManager
   {
      
      protected var FGuideElement:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FMonstersWaitToShow:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FGuideElementWaitToShow:Vector.<TSceneSpriteMoudleInMapGuide>;
      
      protected var FJustMonster:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FUnstreamizerRoleMonster:TUnstreamizerRoleMonster;
      
      protected var FMonseEventHander:TMouseEventHanderMonster;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FOnMonsterClicked:Function;
      
      public function TMonsterManager(param1:TMapParameter)
      {
         super();
         this.FMapParameter = param1;
         this.FGuideElement = new Vector.<TSceneSpriteMoudleInMap>();
         this.FMonstersWaitToShow = new Vector.<TSceneSpriteMoudleInMap>();
         this.FGuideElementWaitToShow = new Vector.<TSceneSpriteMoudleInMapGuide>();
         this.FJustMonster = new Vector.<TSceneSpriteMoudleInMap>();
         this.FMonseEventHander = new TMouseEventHanderMonster();
         this.FMonseEventHander.Callback = this.HandleMonsterClicked;
         this.FUnstreamizerRoleMonster = new TUnstreamizerRoleMonster();
      }
      
      protected function CreateMonster_Perform(param1:Vector.<int>) : void
      {
         this.FUnstreamizerRoleMonster.Unstreamize(null,this.FGuideElement,param1);
         this.SelectJustMonster(this.FJustMonster);
         this.InitMonster(this.FGuideElement);
      }
      
      protected function SelectJustMonster(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         param1.length = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FGuideElement.length)
         {
            _loc3_ = this.FGuideElement[_loc2_];
            if(_loc3_ is TSceneSpriteMoudleInMapMonster)
            {
               param1.push(_loc3_);
               _loc3_.ChangeRoleMoudle(_loc3_.MouduleID,1);
            }
            _loc2_++;
         }
      }
      
      protected function InitMonster(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc3_.MapParameter = this.FMapParameter;
            _loc3_.UpdateHeadDecoration();
            _loc2_++;
         }
      }
      
      protected function InitClickMonster() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudleInMap = null;
         _loc1_ = 0;
         while(_loc1_ < this.FJustMonster.length)
         {
            _loc2_ = this.FJustMonster[_loc1_];
            _loc2_.MouseEventHander = this.FMonseEventHander;
            _loc1_++;
         }
      }
      
      protected function SetLastMonster_Perform(param1:uint, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudleInMapMonster = null;
         var _loc5_:int = 0;
         _loc5_ = int(SLogicsCore.Character.GetMainLevel());
         _loc3_ = 0;
         while(_loc3_ < this.FJustMonster.length)
         {
            _loc4_ = this.FJustMonster[_loc3_] as TSceneSpriteMoudleInMapMonster;
            if(_loc4_.RoleTempleteID == param1)
            {
               _loc4_.MonsterState |= CONST_WORLDMAP.MonsterState_Latest;
            }
            if(_loc4_.RoleTempleteID < param1 && param2)
            {
               _loc4_.MonsterState |= CONST_WORLDMAP.MonsterState_Dead;
               _loc4_.mouseEnabled = false;
               _loc4_.mouseChildren = false;
            }
            if(_loc4_.RoleTempleteID > param1)
            {
               _loc4_.MonsterState |= CONST_WORLDMAP.MonsterState_PreView;
               _loc4_.mouseEnabled = false;
               _loc4_.mouseChildren = false;
            }
            if(_loc5_ < _loc4_.HeroLevelNeed)
            {
               _loc4_.MonsterState = CONST_WORLDMAP.MonsterState_NextLevel;
               _loc4_.mouseEnabled = false;
               _loc4_.mouseChildren = false;
            }
            _loc4_.UpdateHeadDecoration();
            _loc3_++;
         }
      }
      
      protected function CheckQuestToMonstr(param1:TQuest, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudleInMapMonster = null;
         _loc3_ = 0;
         while(_loc3_ < this.FJustMonster.length)
         {
            _loc4_ = this.FJustMonster[_loc3_] as TSceneSpriteMoudleInMapMonster;
            if(_loc4_.RoleTempleteID == param1.CampId && param1.CurrentfKillTime < param1.KillTime)
            {
               _loc4_.MonsterState |= param2;
            }
            _loc4_.UpdateHeadDecoration();
            _loc3_++;
         }
      }
      
      protected function CheckQuestsToMonster(param1:TQuests, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TQuest = null;
         _loc3_ = 0;
         while(_loc3_ < param1.Count)
         {
            _loc4_ = param1.GetQuestByIndex(_loc3_);
            this.CheckQuestToMonstr(_loc4_,param2);
            _loc3_++;
         }
      }
      
      protected function CheckIfQuestMonster() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         _loc1_ = 0;
         while(_loc1_ < this.FJustMonster.length)
         {
            _loc2_ = this.FJustMonster[_loc1_] as TSceneSpriteMoudleInMapMonster;
            _loc2_.MonsterState &= ~CONST_WORLDMAP.MonsterState_BranchQuest;
            _loc2_.MonsterState &= ~CONST_WORLDMAP.MonsterState_MainQuest;
            _loc1_++;
         }
         this.CheckQuestsToMonster(SLogicsCore.Character.SubQuestsAlreadyAccept,CONST_WORLDMAP.MonsterState_BranchQuest);
         this.CheckQuestsToMonster(SLogicsCore.Character.MainQuestsAlreadyAccept,CONST_WORLDMAP.MonsterState_MainQuest);
      }
      
      protected function GuideActionComplete(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapGuideBomb = null;
         if(param1 is TSceneSpriteMoudleInMapGuideBomb)
         {
            _loc2_ = param1 as TSceneSpriteMoudleInMapGuideBomb;
            _loc2_.ShowEnd();
            this.FGuideElement.push(this.FMonstersWaitToShow[0]);
            this.FMonstersWaitToShow.splice(0,1);
         }
         this.StartOneGuideElmenetShow();
      }
      
      protected function DispatchGuideElement(param1:uint) : void
      {
         var _loc2_:* = 0;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         var _loc4_:TSceneSpriteMoudleInMapGuideBomb = null;
         var _loc5_:TSceneSpriteMoudleInMapGuidePoint = null;
         _loc2_ = 0;
         while(_loc2_ < this.FGuideElement.length)
         {
            _loc3_ = this.FGuideElement[_loc2_];
            if(_loc3_ is TSceneSpriteMoudleInMapMonster)
            {
               if(_loc3_.RoleTempleteID >= param1)
               {
                  this.FMonstersWaitToShow.push(_loc3_);
                  this.FGuideElement.splice(_loc2_,1);
                  _loc2_--;
               }
            }
            else if(_loc3_ is TSceneSpriteMoudleInMapGuideBomb)
            {
               _loc4_ = _loc3_ as TSceneSpriteMoudleInMapGuideBomb;
               if(_loc4_.GuideMonsterID >= param1)
               {
                  this.FGuideElementWaitToShow.push(_loc4_);
                  this.FGuideElement.splice(_loc2_,1);
                  _loc2_--;
               }
               else
               {
                  _loc4_.ShowEnd();
               }
            }
            else if(_loc3_ is TSceneSpriteMoudleInMapGuidePoint)
            {
               _loc5_ = _loc3_ as TSceneSpriteMoudleInMapGuidePoint;
               if(_loc5_.GuideMonsterID > param1)
               {
                  this.FGuideElementWaitToShow.push(_loc5_);
                  this.FGuideElement.splice(_loc2_,1);
                  _loc2_--;
               }
               else
               {
                  _loc5_.ShowEnd();
               }
            }
            _loc2_++;
         }
      }
      
      protected function InitGuideElement(param1:Vector.<TSceneSpriteMoudleInMapGuide>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapGuide = null;
         _loc2_ = 0;
         while(_loc2_ < this.FGuideElementWaitToShow.length)
         {
            _loc3_ = this.FGuideElementWaitToShow[_loc2_];
            _loc3_.CallBack = this.GuideActionComplete;
            _loc2_++;
         }
      }
      
      protected function StartOneGuideElmenetShow() : void
      {
         var _loc1_:TSceneSpriteMoudleInMapGuide = null;
         if(this.FGuideElementWaitToShow.length != 0)
         {
            _loc1_ = this.FGuideElementWaitToShow[0];
            this.FGuideElementWaitToShow.splice(0,1);
            this.FGuideElement.push(_loc1_);
            _loc1_.StartShow();
         }
      }
      
      protected function HandleMonsterClicked(param1:TSceneSpriteMoudleInMapMonster) : void
      {
         if(this.FOnMonsterClicked != null)
         {
            this.FOnMonsterClicked(param1);
         }
      }
      
      protected function ReleaseGuideElement(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         SLogicsCore.PoolMap.Release(param1);
         param1.Release();
         param1.visible = false;
      }
      
      public function get Monsters() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FGuideElement;
      }
      
      public function get MonstersWaitToShow() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FMonstersWaitToShow;
      }
      
      public function set OnMonsterClicked(param1:Function) : void
      {
         this.FOnMonsterClicked = param1;
      }
      
      public function get JustMonster() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FJustMonster;
      }
      
      public function CreateMonster(param1:Vector.<int>, param2:TCoordinate) : void
      {
         this.CreateMonster_Perform(param1);
         this.CheckIfQuestMonster();
      }
      
      public function SetLastMonster(param1:uint, param2:Boolean) : void
      {
         this.InitClickMonster();
         this.SetLastMonster_Perform(param1,param2);
      }
      
      public function SetLastShowMonster(param1:uint) : void
      {
         this.DispatchGuideElement(param1);
         this.InitGuideElement(this.FGuideElementWaitToShow);
         this.StartOneGuideElmenetShow();
      }
      
      public function ClearMonster() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudleInMapGuide = null;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         _loc1_ = 0;
         while(_loc1_ < this.FGuideElement.length)
         {
            _loc3_ = this.FGuideElement[_loc1_] as TSceneSpriteMoudleInMap;
            if(_loc3_ is TSceneSpriteMoudleInMapGuide)
            {
               (_loc3_ as TSceneSpriteMoudleInMapGuide).ShowEnd();
            }
            this.ReleaseGuideElement(_loc3_);
            _loc1_++;
         }
         this.FGuideElement.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FMonstersWaitToShow.length)
         {
            _loc3_ = this.FMonstersWaitToShow[_loc1_] as TSceneSpriteMoudleInMap;
            this.ReleaseGuideElement(_loc3_);
            _loc1_++;
         }
         this.FMonstersWaitToShow.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FGuideElementWaitToShow.length)
         {
            _loc2_ = this.FGuideElementWaitToShow[_loc1_] as TSceneSpriteMoudleInMapGuide;
            _loc2_.ShowEnd();
            this.ReleaseGuideElement(_loc2_);
            _loc1_++;
         }
         this.FGuideElementWaitToShow.length = 0;
         this.FJustMonster.length = 0;
      }
      
      public function UpdateQuest() : void
      {
         this.CheckIfQuestMonster();
      }
      
      public function GetMonsterByID(param1:int) : TSceneSpriteMoudleInMap
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudleInMap = null;
         _loc3_ = int(this.FJustMonster.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FJustMonster[_loc2_];
            if(_loc4_.RoleTempleteID == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

