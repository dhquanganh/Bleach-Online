package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TAutoActivityGain extends TDatebaseVO
   {
      
      protected var FMonsterCoin:uint;
      
      protected var FMonsterExp:uint;
      
      protected var FTraitorCoin:uint;
      
      protected var FTraitorExp:uint;
      
      public function TAutoActivityGain()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FMonsterCoin = param1.readUnsignedInt();
         this.FMonsterExp = param1.readUnsignedInt();
         this.FTraitorCoin = param1.readUnsignedInt();
         this.FTraitorExp = param1.readUnsignedInt();
      }
      
      public function get MonsterCoin() : uint
      {
         return this.FMonsterCoin;
      }
      
      public function get MonsterExp() : uint
      {
         return this.FMonsterExp;
      }
      
      public function get TraitorCoin() : uint
      {
         return this.FTraitorCoin;
      }
      
      public function get TraitorExp() : uint
      {
         return this.FTraitorExp;
      }
   }
}

