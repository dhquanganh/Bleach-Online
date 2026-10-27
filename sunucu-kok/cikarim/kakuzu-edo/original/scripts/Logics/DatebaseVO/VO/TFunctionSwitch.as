package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TFunctionSwitch extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FIsOpen:Boolean;
      
      protected var FPosition:int;
      
      protected var FIndex:int;
      
      protected var FCombineType:int;
      
      protected var FConditionType:int;
      
      protected var FConditiontValue:int;
      
      protected var FDesc:String;
      
      public function TFunctionSwitch()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIsOpen = param1.readInt() != 0;
         this.FPosition = param1.readUnsignedInt();
         this.FIndex = param1.readUnsignedInt();
         this.FCombineType = param1.readUnsignedInt();
         this.FConditionType = param1.readUnsignedInt();
         this.FConditiontValue = param1.readUnsignedInt();
         this.FDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get IsOpen() : Boolean
      {
         return this.FIsOpen;
      }
      
      public function get Position() : int
      {
         return this.FPosition;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function get CombineType() : int
      {
         return this.FCombineType;
      }
      
      public function get ConditionType() : int
      {
         return this.FConditionType;
      }
      
      public function get ConditiontValue() : int
      {
         return this.FConditiontValue;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
   }
}

