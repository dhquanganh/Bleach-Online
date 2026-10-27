package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TFreshGuide extends TDatebaseVO
   {
      
      protected var FTaskStartFlag:Boolean;
      
      protected var FMC_ID:int;
      
      protected var FTriggerEventID:int;
      
      protected var FSpecialHandle:int;
      
      protected var FGuideMessage:String;
      
      protected var FGuideDetail:String;
      
      protected var FCompleteCondition:int;
      
      protected var FGenerateLocalID:int;
      
      protected var FGenerateServerID:int;
      
      protected var FArrowX:int;
      
      protected var FArrowY:int;
      
      protected var FJmpTriggerID:int;
      
      protected var FJmpGenerateCode:int;
      
      public function TFreshGuide()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FTaskStartFlag = param1.readInt() != 0;
         this.FMC_ID = param1.readInt();
         this.FTriggerEventID = param1.readInt();
         this.FSpecialHandle = param1.readInt();
         this.FGuideMessage = TUtilityString.FetchUTF(param1);
         this.FGuideDetail = TUtilityString.FetchUTF(param1);
         this.FCompleteCondition = param1.readInt();
         this.FGenerateLocalID = param1.readInt();
         this.FGenerateServerID = param1.readInt();
         this.FArrowX = param1.readInt();
         this.FArrowY = param1.readInt();
         this.FJmpTriggerID = param1.readInt();
         this.FJmpGenerateCode = param1.readInt();
      }
      
      public function get TaskStartFlag() : Boolean
      {
         return this.FTaskStartFlag;
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
      
      public function get GuideDetail() : String
      {
         return this.FGuideDetail;
      }
   }
}

