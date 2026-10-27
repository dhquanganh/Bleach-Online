package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRoleModel extends TDatebaseVO
   {
      
      protected var FModel:uint;
      
      protected var FRoleStyle:uint;
      
      protected var FRoleHead:uint;
      
      public function TRoleModel()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FModel = param1.readUnsignedInt();
         this.FRoleStyle = param1.readUnsignedInt();
         this.FRoleHead = param1.readUnsignedInt();
      }
      
      public function get Model() : uint
      {
         return this.FModel;
      }
      
      public function get RoleStyle() : uint
      {
         return this.FRoleStyle;
      }
      
      public function get RoleHead() : uint
      {
         return this.FRoleHead;
      }
   }
}

