package Logics.Quests
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolQuest extends TPoolAutomatic
   {
      
      protected var FIndexQuest:int;
      
      protected var FIndexQuestObjective:int;
      
      public function TPoolQuest()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexQuest = RegisterClass(TQuest,this.ReleasingPerform_Quest);
         this.FIndexQuestObjective = RegisterClass(TQuestObjective,this.ReleasingPerform_QuestObjective);
      }
      
      protected function ReleasingPerform_Quest(param1:Object) : void
      {
         var _loc2_:TQuest = null;
         _loc2_ = param1 as TQuest;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_QuestObjective(param1:Object) : void
      {
         var _loc2_:TQuestObjective = null;
         _loc2_ = param1 as TQuestObjective;
         _loc2_.Reset();
      }
      
      public function AcquireQuest(param1:uint = 0) : TQuest
      {
         var _loc2_:TQuest = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexQuest) as TQuest;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TQuest(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireQuestObjective() : TQuestObjective
      {
         var _loc1_:TQuestObjective = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexQuestObjective) as TQuestObjective;
         if(_loc1_ == null)
         {
            _loc1_ = new TQuestObjective();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

