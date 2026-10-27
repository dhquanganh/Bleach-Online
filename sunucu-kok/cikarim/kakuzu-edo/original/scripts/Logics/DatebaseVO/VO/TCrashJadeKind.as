package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TCrashJadeKind extends TDatebaseVO
   {
      
      protected var FCostSiliver:int;
      
      public function TCrashJadeKind()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCostSiliver = param1.readInt();
      }
      
      public function get CostSiliver() : int
      {
         return this.FCostSiliver;
      }
   }
}

