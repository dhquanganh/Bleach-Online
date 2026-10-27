package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSlaveMessage extends TDatebaseVO
   {
      
      protected var FType:uint;
      
      protected var FMasterTemplateId:uint;
      
      protected var FSlaveTemplateId:uint;
      
      protected var FEventName:String;
      
      public function TSlaveMessage()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FType = param1.readUnsignedInt();
         this.FMasterTemplateId = param1.readUnsignedInt();
         this.FSlaveTemplateId = param1.readUnsignedInt();
         this.FEventName = TUtilityString.FetchUTF(param1);
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get MasterTemplateId() : uint
      {
         return this.FMasterTemplateId;
      }
      
      public function get SlaveTemplateId() : uint
      {
         return this.FSlaveTemplateId;
      }
      
      public function get EventName() : String
      {
         return this.FEventName;
      }
   }
}

