package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TKnifeStrengExp extends TDatebaseVO
   {
      
      protected var FQuality:int;
      
      protected var FLevel:int;
      
      protected var FExp:int;
      
      protected var FAccumulation:int;
      
      public function TKnifeStrengExp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FQuality = param1.readInt();
         this.FLevel = param1.readInt();
         this.FExp = param1.readInt();
         this.FAccumulation = param1.readInt();
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get Exp() : int
      {
         return this.FExp;
      }
      
      public function get Accumulation() : int
      {
         return this.FAccumulation;
      }
   }
}

