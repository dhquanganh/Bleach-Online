package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TOrganizationDevotion extends TDatebaseVO
   {
      
      protected var FPlayerLevel:uint;
      
      protected var FDevotionSivMax:uint;
      
      public function TOrganizationDevotion()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FPlayerLevel = param1.readUnsignedInt();
         this.FDevotionSivMax = param1.readUnsignedInt();
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function get DevotionSivMax() : uint
      {
         return this.FDevotionSivMax;
      }
   }
}

