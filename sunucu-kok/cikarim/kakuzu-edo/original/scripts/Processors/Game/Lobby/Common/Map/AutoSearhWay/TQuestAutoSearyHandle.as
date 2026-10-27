package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TMap;
   import Logics.Quests.TQuest;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_QUESTAUTOSEARCHWAY;
   
   public class TQuestAutoSearyHandle
   {
      
      public static const QuestEventType_ArriveCityDoor:int = 1;
      
      public static const QuestEventType_NormalMove:int = 2;
      
      public static const QuestEventType_EnterMainCity:int = 3;
      
      protected var FQuest:TQuest;
      
      protected var FOnGotoNpc:Function;
      
      protected var FOnEnterMonsterMap:Function;
      
      protected var FOnEnterMainCity:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnEnterHome:Function;
      
      public function TQuestAutoSearyHandle()
      {
         super();
      }
      
      protected function HandleQuestInMainCity() : void
      {
      }
      
      protected function HandleQuestInWorldMap() : void
      {
      }
      
      protected function NotifyEventTypeArriveCityDoor() : void
      {
      }
      
      protected function NotifyEventTypeNormalMove() : void
      {
         this.FQuest = null;
      }
      
      protected function NotifyEventTypeEnterMainCity() : void
      {
         this.HandleQuestInMainCity();
      }
      
      protected function GotoNpc(param1:int) : void
      {
         if(this.FOnGotoNpc != null)
         {
            this.FOnGotoNpc(param1);
         }
      }
      
      protected function EnterMainCity() : void
      {
         if(this.FOnEnterMainCity != null)
         {
            this.FOnEnterMainCity(this,this.GetMapCityByDoorID(this.FQuest.DoorID));
         }
      }
      
      protected function EnterMonsterMap(param1:int = 0) : void
      {
         if(this.FOnEnterMonsterMap != null)
         {
            this.FOnEnterMonsterMap(this,true,this.GetMapCityByDoorID(this.FQuest.DoorID),param1);
         }
      }
      
      protected function OpenView(param1:int, param2:int, param3:int = 0) : void
      {
         if(this.FOnShortcutHyperlinks != null)
         {
            this.FOnShortcutHyperlinks(this,param1,param2,param3);
         }
      }
      
      protected function EnterHome() : void
      {
         if(this.FOnEnterHome != null)
         {
            this.FOnEnterHome(this);
         }
      }
      
      protected function GetMapCityByDoorID(param1:uint) : int
      {
         var _loc2_:TMap = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Map,param1) as TMap;
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.Type;
      }
      
      public function set OnGotoNpc(param1:Function) : void
      {
         this.FOnGotoNpc = param1;
      }
      
      public function set OnEnterMonsterMap(param1:Function) : void
      {
         this.FOnEnterMonsterMap = param1;
      }
      
      public function set OnEnterMainCity(param1:Function) : void
      {
         this.FOnEnterMainCity = param1;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function set OnEnterHome(param1:Function) : void
      {
         this.FOnEnterHome = param1;
      }
      
      public function HandleQuest(param1:TQuest) : void
      {
         this.FQuest = param1;
         switch(SLogicsCore.Character.RoleSencePosition)
         {
            case CONST_COMMON.SCENEPOSITION_MAINCITY:
               this.HandleQuestInMainCity();
               break;
            case CONST_COMMON.SCENEPOSITION_MONSTERMAP:
            case CONST_COMMON.SCENEPOSITION_WORLDMAP:
               this.HandleQuestInWorldMap();
         }
      }
      
      public function QuestEventNotify(param1:int) : void
      {
         switch(param1)
         {
            case CONST_QUESTAUTOSEARCHWAY.QuestEventType_ArriveCityDoor:
               this.NotifyEventTypeArriveCityDoor();
               break;
            case CONST_QUESTAUTOSEARCHWAY.QuestEventType_NormalMove:
               this.NotifyEventTypeNormalMove();
               break;
            case CONST_QUESTAUTOSEARCHWAY.QuestEventType_EnterMainCity:
               this.NotifyEventTypeEnterMainCity();
         }
      }
   }
}

