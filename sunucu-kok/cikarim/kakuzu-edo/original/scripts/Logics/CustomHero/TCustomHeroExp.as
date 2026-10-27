package Logics.CustomHero
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TCustomHeroExp extends TDatebaseVO
   {
      
      protected var FExp:uint;
      
      protected var FNeedExp:uint;
      
      public function TCustomHeroExp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FExp = param1.readUnsignedInt();
         this.FNeedExp = param1.readUnsignedInt();
      }
      
      public function get Exp() : uint
      {
         return this.FExp;
      }
      
      public function get NeedExp() : uint
      {
         return this.FNeedExp;
      }
   }
}

