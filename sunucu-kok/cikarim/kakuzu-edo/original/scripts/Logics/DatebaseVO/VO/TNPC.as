package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TNPC extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FNpcTitle:String;
      
      protected var FTalk:String;
      
      protected var FStartTime:int;
      
      protected var FEndTime:int;
      
      protected var FCityid:int;
      
      protected var FUserType:int;
      
      protected var FX:int;
      
      protected var FY:int;
      
      protected var FTalkX:int;
      
      protected var FTalkY:int;
      
      protected var FNpcFunctionOpenType:int;
      
      protected var FNpcFunctionOpenCondition:int;
      
      protected var FNpcFunctionCloseCondition:int;
      
      public function TNPC()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FNpcTitle = TUtilityString.FetchUTF(param1);
         this.FTalk = TUtilityString.FetchUTF(param1);
         this.FStartTime = param1.readUnsignedInt();
         this.FEndTime = param1.readUnsignedInt();
         this.FCityid = param1.readUnsignedInt();
         this.FUserType = param1.readUnsignedInt();
         this.FX = param1.readUnsignedInt();
         this.FY = param1.readUnsignedInt();
         this.FTalkX = param1.readUnsignedInt();
         this.FTalkY = param1.readUnsignedInt();
         this.FNpcFunctionOpenType = param1.readUnsignedInt();
         this.FNpcFunctionOpenCondition = param1.readUnsignedInt();
         this.FNpcFunctionCloseCondition = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get NpcTitle() : String
      {
         return this.FNpcTitle;
      }
      
      public function get Talk() : String
      {
         return this.FTalk;
      }
      
      public function get StartTime() : int
      {
         return this.FStartTime;
      }
      
      public function get EndTime() : int
      {
         return this.FEndTime;
      }
      
      public function get Cityid() : int
      {
         return this.FCityid;
      }
      
      public function get UserType() : int
      {
         return this.FUserType;
      }
      
      public function get X() : int
      {
         return this.FX;
      }
      
      public function get Y() : int
      {
         return this.FY;
      }
      
      public function get TalkX() : int
      {
         return this.FTalkX;
      }
      
      public function get TalkY() : int
      {
         return this.FTalkY;
      }
      
      public function get NpcFunctionOpenType() : int
      {
         return this.FNpcFunctionOpenType;
      }
      
      public function get NpcFunctionOpenCondition() : int
      {
         return this.FNpcFunctionOpenCondition;
      }
      
      public function get NpcFunctionCloseCondition() : int
      {
         return this.FNpcFunctionCloseCondition;
      }
   }
}

