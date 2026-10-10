package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TCity extends TDatebaseVO
   {
      
      protected var FType:int;
      
      protected var FMap:int;
      
      protected var FStart:int;
      
      protected var FLast:int;
      
      protected var FName:String;
      
      protected var FIcon:int;
      
      protected var FOpenLevel:uint;
      
      protected var FPreCity:uint;
      
      public function TCity()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FType = param1.readUnsignedInt();
         this.FMap = param1.readUnsignedInt();
         this.FStart = param1.readUnsignedInt();
         this.FLast = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIcon = param1.readUnsignedInt();
         this.FOpenLevel = param1.readUnsignedInt();
         this.FPreCity = param1.readUnsignedInt();
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Start() : int
      {
         return this.FStart;
      }
      
      public function get Last() : int
      {
         return this.FLast;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Icon() : int
      {
         return this.FIcon;
      }
      
      public function get Map() : int
      {
         return this.FMap;
      }
      
      public function get OpenLevel() : uint
      {
         return this.FOpenLevel;
      }
      
      public function get PreCity() : uint
      {
         return this.FPreCity;
      }
   }
}

