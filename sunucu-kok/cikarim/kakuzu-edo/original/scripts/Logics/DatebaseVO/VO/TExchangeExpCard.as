package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TExchangeExpCard extends TDatebaseVO
   {
      
      protected var FGrade:uint;
      
      protected var FItem:uint;
      
      protected var FQuality:uint;
      
      protected var FValue:uint;
      
      public function TExchangeExpCard()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FGrade = param1.readUnsignedInt();
         this.FItem = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FValue = param1.readUnsignedInt();
      }
      
      public function get Grade() : uint
      {
         return this.FGrade;
      }
      
      public function get Item() : uint
      {
         return this.FItem;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
   }
}

