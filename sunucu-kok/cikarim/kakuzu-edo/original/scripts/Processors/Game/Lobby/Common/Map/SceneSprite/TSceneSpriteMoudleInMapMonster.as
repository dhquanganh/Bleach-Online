package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Registries.TRegistryRoutine;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityFilter;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationCircleMonster;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationIconMonster;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationNameMonster;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationPointHP;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationQuestFlag;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationShadow;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteActionContorlMainSceneSprite;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteMoudleContorlMonster;
   import Resources.Constants.CONST_WORLDMAP;
   
   public class TSceneSpriteMoudleInMapMonster extends TSceneSpriteMoudleInMap
   {
      
      protected static const MonsterStates:Vector.<int> = Vector.<int>([CONST_WORLDMAP.MonsterState_Dead,CONST_WORLDMAP.MonsterState_PreView,CONST_WORLDMAP.MonsterState_Latest,CONST_WORLDMAP.MonsterState_MainQuest,CONST_WORLDMAP.MonsterState_BranchQuest,CONST_WORLDMAP.MonsterState_NextLevel]);
      
      protected static const GREAVE_TEXTUREID:uint = 13610075;
      
      protected var FName:String;
      
      protected var FMonsterState:int;
      
      protected var FRegistryRoutine:TRegistryRoutine;
      
      protected var FIsBoss:Boolean;
      
      protected var FHeroLevelNeed:int;
      
      protected var FHP:TDecorationPointHP;
      
      public function TSceneSpriteMoudleInMapMonster()
      {
         super();
         this.FRegistryRoutine = new TRegistryRoutine();
         this.ConsturctRoutines();
      }
      
      override protected function CreateDecoration() : void
      {
         var _loc1_:TDecorationNameMonster = null;
         var _loc2_:TDecorationIconMonster = null;
         var _loc3_:TDecorationCircleMonster = null;
         var _loc4_:TDecorationQuestFlag = null;
         var _loc5_:TDecorationShadow = null;
         _loc1_ = new TDecorationNameMonster();
         AddHeadDecoration(_loc1_);
         _loc4_ = new TDecorationQuestFlag();
         AddHeadDecoration(_loc4_);
         _loc2_ = new TDecorationIconMonster();
         AddHeadDecoration(_loc2_);
         _loc3_ = new TDecorationCircleMonster();
         AddHeadDecoration(_loc3_);
         _loc5_ = new TDecorationShadow();
         AddHeadDecoration(_loc5_);
         this.FHP = new TDecorationPointHP();
         this.HP_Visible = false;
         AddHeadDecoration(this.FHP);
         addChild(_loc1_);
         addChild(_loc2_);
         addChildAt(_loc3_,0);
         addChild(_loc4_);
         addChildAt(_loc5_,0);
         addChild(this.FHP);
      }
      
      override protected function CreateSpriteMoudleContorl() : void
      {
         FSpriteMoudleContorl = new TSpriteMoudleContorlMonster();
      }
      
      override protected function CreateSpriteActionQuery() : void
      {
         FActionQuery = new TSpriteActionContorlMainSceneSprite();
      }
      
      protected function ConsturctRoutines() : void
      {
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_Dead,this.Routine_MonsterDead);
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_Latest,this.Routine_MonsterLatest);
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_MainQuest,this.Routine_MonsterMainQuest);
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_BranchQuest,this.Routine_MonsterBranchQuest);
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_PreView,this.Routine_MonsterPreView);
         this.FRegistryRoutine.Register(CONST_WORLDMAP.MonsterState_NextLevel,this.Routine_MonsterPreView);
      }
      
      protected function Routine_MonsterDead() : void
      {
         ChangeRoleMoudle(GREAVE_TEXTUREID,1);
      }
      
      protected function Routine_MonsterLatest() : void
      {
         UpdateHeadDecoration();
      }
      
      protected function Routine_MonsterMainQuest() : void
      {
         UpdateHeadDecoration();
      }
      
      protected function Routine_MonsterBranchQuest() : void
      {
         UpdateHeadDecoration();
      }
      
      protected function Routine_MonsterPreView() : void
      {
         this.FRoleBitMap.filters = [TUtilityFilter.GaryColorFiltersTwo];
      }
      
      protected function BeforeChangeState() : void
      {
         if((this.FMonsterState & CONST_WORLDMAP.MonsterState_Dead) != 0)
         {
            FReplaceID = 0;
         }
         else if((this.FMonsterState & CONST_WORLDMAP.MonsterState_PreView) != 0)
         {
            this.FRoleBitMap.filters = null;
         }
         else if((this.FMonsterState & CONST_WORLDMAP.MonsterState_NextLevel) != 0)
         {
            this.FRoleBitMap.filters = null;
         }
      }
      
      protected function ChangeState_Perform(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Function = null;
         var _loc5_:int = 0;
         this.BeforeChangeState();
         _loc3_ = MonsterStates;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc2_];
            if((_loc5_ & param1) != 0)
            {
               _loc4_ = this.FRegistryRoutine.GetRoutineByIndentifier(_loc5_);
               break;
            }
            _loc2_++;
         }
         if(_loc4_ != null)
         {
            _loc4_();
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get MonsterState() : int
      {
         return this.FMonsterState;
      }
      
      public function set MonsterState(param1:int) : void
      {
         this.BeforeChangeState();
         this.FMonsterState = param1;
         this.ChangeState_Perform(param1);
      }
      
      public function get IsBoss() : Boolean
      {
         return this.FIsBoss;
      }
      
      public function set IsBoss(param1:Boolean) : void
      {
         this.FIsBoss = param1;
      }
      
      public function get HeroLevelNeed() : int
      {
         return this.FHeroLevelNeed;
      }
      
      public function set HeroLevelNeed(param1:int) : void
      {
         this.FHeroLevelNeed = param1;
      }
      
      public function set HP_Visible(param1:Boolean) : void
      {
         this.FHP.visible = param1;
      }
      
      public function get HP_Visible() : Boolean
      {
         return this.FHP.visible;
      }
      
      public function ChangeBlood(param1:Number) : void
      {
         this.FHP.ChangeBlood(param1);
      }
      
      override public function Release() : void
      {
         this.ReleaseModuleResource();
         super.Release();
         this.FMonsterState = 0;
         this.FIsBoss = false;
         this.FName = "";
         FReplaceID = 0;
         this.HP_Visible = false;
         this.FRoleBitMap.filters = null;
      }
      
      override public function ReleaseModuleResource() : void
      {
         var _loc1_:int = 0;
         SResourcesCore.TexturesModel.DeleteByIdentifier(FTextrueID,true);
      }
   }
}

