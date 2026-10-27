package Logics.EquipForge
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TConfigEquipAdvance extends TDatebaseVO
   {
      
      protected var FItemId:uint;
      
      protected var FNeedCount:uint;
      
      public function TConfigEquipAdvance()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FItemId = param1.readUnsignedInt();
         this.FNeedCount = param1.readUnsignedInt();
      }
      
      public function get ItemId() : uint
      {
         return this.FItemId;
      }
      
      public function get NeedCount() : uint
      {
         return this.FNeedCount;
      }
   }
}

