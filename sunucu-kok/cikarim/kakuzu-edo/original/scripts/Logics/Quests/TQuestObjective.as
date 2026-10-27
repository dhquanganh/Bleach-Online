package Logics.Quests
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TQuestObjective
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FTargetId:uint;
      
      protected var FCompleted:Boolean;
      
      protected var FDescription:String;
      
      protected var FProgress:uint;
      
      protected var FProgressMax:uint;
      
      public function TQuestObjective()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Completed() : Boolean
      {
         return this.FCompleted;
      }
      
      public function set Completed(param1:Boolean) : void
      {
         this.FCompleted = param1;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function set Description(param1:String) : void
      {
         this.FDescription = param1;
      }
      
      public function get Progress() : uint
      {
         return this.FProgress;
      }
      
      public function set Progress(param1:uint) : void
      {
         this.FProgress = param1;
      }
      
      public function get ProgressMax() : uint
      {
         return this.FProgressMax;
      }
      
      public function set ProgressMax(param1:uint) : void
      {
         this.FProgressMax = param1;
      }
      
      public function get TargetId() : uint
      {
         return this.FTargetId;
      }
      
      public function set TargetId(param1:uint) : void
      {
         this.FTargetId = param1;
      }
      
      public function Reset() : void
      {
         this.FTargetId = 0;
         this.FCompleted = false;
         this.FDescription = "";
         this.FProgress = 0;
         this.FProgressMax = 0;
      }
   }
}

