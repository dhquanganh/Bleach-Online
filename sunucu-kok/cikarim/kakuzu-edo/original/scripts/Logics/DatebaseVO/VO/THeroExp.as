package Logics.DatebaseVO.VO
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THeroExp extends TDatebaseVO
   {
      
      protected var FNeedExp:UInt64;
      
      protected var FAllExp:UInt64;
      
      public function THeroExp()
      {
         super();
         this.FNeedExp = new UInt64();
         this.FAllExp = new UInt64();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FNeedExp.High = 0;
         this.FNeedExp.Low = param1.readUnsignedInt();
         this.FAllExp.High = param1.readUnsignedInt();
         this.FAllExp.Low = param1.readUnsignedInt();
      }
      
      public function get NeedExp() : UInt64
      {
         return this.FNeedExp;
      }
      
      public function get AllExp() : UInt64
      {
         return this.FAllExp;
      }
   }
}

