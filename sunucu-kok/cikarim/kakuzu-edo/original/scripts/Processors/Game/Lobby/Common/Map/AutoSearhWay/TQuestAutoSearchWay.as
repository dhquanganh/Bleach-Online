package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Logics.Quests.TQuest;
   
   public class TQuestAutoSearchWay
   {
      
      protected static const QuestHandlersClasses:Vector.<Class> = Vector.<Class>([TQuestAutoSearyHandleType1,TQuestAutoSearyHandleType2,TQuestAutoSearyHandleType3,TQuestAutoSearyHandleType4,TQuestAutoSearyHandleType5,TQuestAutoSearyHandleType6,TQuestAutoSearyHandleType7,TQuestAutoSearyHandleType8,TQuestAutoSearyHandleType9,TQuestAutoSearyHandleType10,TQuestAutoSearyHandleType11,TQuestAutoSearyHandleType12,TQuestAutoSearyHandleType13,TQuestAutoSearyHandleType14]);
      
      protected static const HandlerNumber:int = QuestHandlersClasses.length;
      
      protected var FQuest:TQuest;
      
      protected var FQuestAutoSearchHandlers:Vector.<TQuestAutoSearyHandle>;
      
      protected var FCurrentHandler:TQuestAutoSearyHandle;
      
      protected var FOnGotoNpc:Function;
      
      protected var FOnEnterMonsterMap:Function;
      
      protected var FOnEnterMainCity:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnEnterHome:Function;
      
      public function TQuestAutoSearchWay()
      {
         super();
         this.ConstructQuestAutoSearchHandler();
      }
      
      protected function ConstructQuestAutoSearchHandler() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Class = null;
         var _loc3_:TQuestAutoSearyHandle = null;
         this.FQuestAutoSearchHandlers = new Vector.<TQuestAutoSearyHandle>(HandlerNumber);
         _loc1_ = 0;
         while(_loc1_ < HandlerNumber)
         {
            _loc2_ = QuestHandlersClasses[_loc1_];
            _loc3_ = new _loc2_();
            this.FQuestAutoSearchHandlers[_loc1_] = _loc3_;
            _loc3_.OnGotoNpc = this.GotoNpc;
            _loc3_.OnEnterMonsterMap = this.EnterMonsterMap;
            _loc3_.OnEnterMainCity = this.EnterMainCity;
            _loc3_.OnShortcutHyperlinks = this.ShortcutHyperlinks;
            _loc3_.OnEnterHome = this.EnterHome;
            _loc1_++;
         }
      }
      
      protected function GotoNpc(param1:int) : void
      {
         if(this.FOnGotoNpc != null)
         {
            this.FOnGotoNpc(param1);
         }
      }
      
      protected function EnterMonsterMap(param1:Object, param2:Boolean = false, param3:int = 0, param4:int = 0) : void
      {
         if(this.FOnEnterMonsterMap != null)
         {
            this.FOnEnterMonsterMap(this,param2,param3,param4);
         }
      }
      
      protected function EnterMainCity(param1:Object, param2:int) : void
      {
         if(this.FOnEnterMainCity != null)
         {
            this.FOnEnterMainCity(this,param2);
         }
      }
      
      protected function ShortcutHyperlinks(param1:Object, param2:int, param3:int, param4:int = 0) : void
      {
         if(this.FOnShortcutHyperlinks != null)
         {
            this.FOnShortcutHyperlinks(param1,param2,param3,param4);
         }
      }
      
      protected function EnterHome(param1:Object) : void
      {
         if(this.FOnEnterHome != null)
         {
            this.FOnEnterHome(param1,null);
         }
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
      
      public function AutoSearyWay(param1:Object) : void
      {
         this.FQuest = param1 as TQuest;
         this.FCurrentHandler = this.FQuestAutoSearchHandlers[this.FQuest.EventType - 1];
         this.FCurrentHandler.HandleQuest(this.FQuest);
      }
      
      public function QuestEventNotify(param1:int) : void
      {
         if(this.FCurrentHandler != null)
         {
            this.FCurrentHandler.QuestEventNotify(param1);
         }
         this.FCurrentHandler = null;
      }
   }
}

