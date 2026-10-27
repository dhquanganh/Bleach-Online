package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TBuyMoney extends TDatebaseVO
   {
      
      protected var FCostGold:int;
      
      protected var FMoney:int;
      
      public function TBuyMoney()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCostGold = param1.readUnsignedInt();
         this.FMoney = param1.readUnsignedInt();
      }
      
      public function get CostGold() : int
      {
         return this.FCostGold;
      }
      
      public function get Money() : int
      {
         return this.FMoney;
      }
   }
}

