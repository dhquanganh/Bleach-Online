package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TMusicConfig extends TDatebaseVO
   {
      
      protected var FFighting:int;
      
      protected var FBackground:int;
      
      protected var FIstab:Boolean;
      
      public function TMusicConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FFighting = param1.readUnsignedInt();
         this.FBackground = param1.readUnsignedInt();
         this.FIstab = param1.readBoolean();
      }
      
      public function get Fighting() : int
      {
         return this.FFighting;
      }
      
      public function get Background() : int
      {
         return this.FBackground;
      }
      
      public function get Istab() : Boolean
      {
         return this.FIstab;
      }
   }
}

