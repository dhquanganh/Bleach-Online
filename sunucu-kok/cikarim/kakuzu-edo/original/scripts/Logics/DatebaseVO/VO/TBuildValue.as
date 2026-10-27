package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TBuildValue extends TDatebaseVO
   {
      
      protected var FBuildLevel:int;
      
      protected var FQuality:int;
      
      protected var FEquipType:int;
      
      protected var FValue:int;
      
      protected var FAddValue:int;
      
      public function TBuildValue()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FBuildLevel = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FEquipType = param1.readUnsignedInt();
         this.FValue = param1.readUnsignedInt();
         this.FAddValue = param1.readUnsignedInt();
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function get BuildLevel() : int
      {
         return this.FBuildLevel;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get EquipType() : int
      {
         return this.FEquipType;
      }
      
      public function get AddValue() : int
      {
         return this.FAddValue;
      }
   }
}

