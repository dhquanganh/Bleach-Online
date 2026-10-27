package Logics.FreshGuide
{
   import Foundation.Common.TEntity;
   import flash.display.DisplayObjectContainer;
   
   public class TFreshStep extends TEntity
   {
      
      protected var FMC_ID:int;
      
      protected var FTriggerEventID:int;
      
      protected var FSpecialHandle:int;
      
      protected var FGuideMessage:String;
      
      protected var FGuideDetial:String;
      
      protected var FCompleteCondition:int;
      
      protected var FGenerateLocalID:int;
      
      protected var FGenerateServerID:int;
      
      protected var FArrowX:int;
      
      protected var FArrowY:int;
      
      protected var FJmpTriggerID:int;
      
      protected var FJmpGenerateCode:int;
      
      protected var FArrowParent:DisplayObjectContainer;
      
      public function TFreshStep(param1:uint)
      {
         super(param1);
      }
      
      public function get MC_ID() : int
      {
         return this.FMC_ID;
      }
      
      public function get TriggerEventID() : int
      {
         return this.FTriggerEventID;
      }
      
      public function get SpecialHandle() : int
      {
         return this.FSpecialHandle;
      }
      
      public function get GuideMessage() : String
      {
         return this.FGuideMessage;
      }
      
      public function get CompleteCondition() : int
      {
         return this.FCompleteCondition;
      }
      
      public function get GenerateLocalID() : int
      {
         return this.FGenerateLocalID;
      }
      
      public function get GenerateServerID() : int
      {
         return this.FGenerateServerID;
      }
      
      public function get ArrowX() : int
      {
         return this.FArrowX;
      }
      
      public function get ArrowY() : int
      {
         return this.FArrowY;
      }
      
      public function get JmpTriggerID() : int
      {
         return this.FJmpTriggerID;
      }
      
      public function get JmpGenerateCode() : int
      {
         return this.FJmpGenerateCode;
      }
      
      public function set MC_ID(param1:int) : void
      {
         this.FMC_ID = param1;
      }
      
      public function set TriggerEventID(param1:int) : void
      {
         this.FTriggerEventID = param1;
      }
      
      public function set SpecialHandle(param1:int) : void
      {
         this.FSpecialHandle = param1;
      }
      
      public function set GuideMessage(param1:String) : void
      {
         this.FGuideMessage = param1;
      }
      
      public function set CompleteCondition(param1:int) : void
      {
         this.FCompleteCondition = param1;
      }
      
      public function set GenerateLocalID(param1:int) : void
      {
         this.FGenerateLocalID = param1;
      }
      
      public function set GenerateServerID(param1:int) : void
      {
         this.FGenerateServerID = param1;
      }
      
      public function set ArrowX(param1:int) : void
      {
         this.FArrowX = param1;
      }
      
      public function set ArrowY(param1:int) : void
      {
         this.FArrowY = param1;
      }
      
      public function set JmpTriggerID(param1:int) : void
      {
         this.FJmpTriggerID = param1;
      }
      
      public function set JmpGenerateCode(param1:int) : void
      {
         this.FJmpGenerateCode = param1;
      }
      
      public function get ArrowParent() : DisplayObjectContainer
      {
         return this.FArrowParent;
      }
      
      public function set ArrowParent(param1:DisplayObjectContainer) : void
      {
         this.FArrowParent = param1;
      }
      
      public function get GuideDetial() : String
      {
         return this.FGuideDetial;
      }
      
      public function set GuideDetial(param1:String) : void
      {
         this.FGuideDetial = param1;
      }
   }
}

