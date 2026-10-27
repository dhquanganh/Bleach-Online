package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRankMoney extends TDatebaseVO
   {
      
      protected var FPrestige:int;
      
      public function TRankMoney()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FPrestige = param1.readUnsignedInt();
      }
      
      public function get Prestige() : int
      {
         return this.FPrestige;
      }
   }
}

