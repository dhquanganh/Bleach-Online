package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TMap extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FType:int;
      
      protected var FOpenTask:int;
      
      public function TMap()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FType = param1.readUnsignedInt();
         this.FOpenTask = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get OpenTask() : int
      {
         return this.FOpenTask;
      }
   }
}

