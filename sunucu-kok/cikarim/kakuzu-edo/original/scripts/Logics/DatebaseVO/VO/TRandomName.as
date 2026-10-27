package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRandomName extends TDatebaseVO
   {
      
      protected var FLastNames:Array;
      
      protected var FMaleNames:Array;
      
      protected var FFemaleNames:Array;
      
      public function TRandomName()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FLastNames = _loc2_.split(",");
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FMaleNames = _loc2_.split(",");
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FFemaleNames = _loc2_.split(",");
      }
      
      public function get LastNames() : Array
      {
         return this.FLastNames;
      }
      
      public function get MaleNames() : Array
      {
         return this.FMaleNames;
      }
      
      public function get FemaleNames() : Array
      {
         return this.FFemaleNames;
      }
      
      override public function Clear() : void
      {
         super.Clear();
         this.FLastNames.length = 0;
         this.FMaleNames.length = 0;
         this.FFemaleNames.length = 0;
         this.FLastNames = null;
         this.FMaleNames = null;
         this.FFemaleNames = null;
      }
   }
}

