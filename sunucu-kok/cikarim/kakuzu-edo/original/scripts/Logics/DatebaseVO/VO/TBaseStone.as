package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TBaseStone extends TDatebaseVO
   {
      
      protected var FAddType:uint;
      
      protected var FAddValue:Number;
      
      protected var FNextId:uint;
      
      public function TBaseStone()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FAddType = param1.readUnsignedInt();
         this.FAddValue = param1.readDouble();
         this.FNextId = param1.readUnsignedInt();
      }
      
      public function get NextId() : uint
      {
         return this.FNextId;
      }
      
      public function get AddType() : uint
      {
         return this.FAddType;
      }
      
      public function set AddType(param1:uint) : void
      {
         this.FAddType = param1;
      }
      
      public function get AddValue() : Number
      {
         return this.FAddValue;
      }
      
      public function set AddValue(param1:Number) : void
      {
         this.FAddValue = param1;
      }
   }
}

