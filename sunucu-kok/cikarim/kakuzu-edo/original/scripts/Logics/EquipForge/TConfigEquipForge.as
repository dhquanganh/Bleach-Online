package Logics.EquipForge
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TConfigEquipForge extends TDatebaseVO
   {
      
      protected var FItemId:uint;
      
      protected var FRetCount:uint;
      
      public function TConfigEquipForge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FItemId = param1.readUnsignedInt();
         this.FRetCount = param1.readUnsignedInt();
      }
      
      public function get ItemId() : uint
      {
         return this.FItemId;
      }
      
      public function get RetCount() : uint
      {
         return this.FRetCount;
      }
   }
}

