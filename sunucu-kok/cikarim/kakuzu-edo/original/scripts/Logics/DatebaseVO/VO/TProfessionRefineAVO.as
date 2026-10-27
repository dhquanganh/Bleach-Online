package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TProfessionRefineAVO extends TDatebaseVO
   {
      
      protected var FCost:int;
      
      protected var FPhyAtk:Number;
      
      protected var FMagicAtk:Number;
      
      protected var FPhyDef:Number;
      
      protected var FMagicDef:Number;
      
      protected var FHp:Number;
      
      protected var FSpeed:Number;
      
      public function TProfessionRefineAVO()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCost = param1.readInt();
         this.FPhyAtk = param1.readFloat();
         this.FMagicAtk = param1.readFloat();
         this.FPhyDef = param1.readFloat();
         this.FMagicDef = param1.readFloat();
         this.FHp = param1.readFloat();
         this.FSpeed = param1.readFloat();
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function get PhyAtk() : Number
      {
         return this.FPhyAtk;
      }
      
      public function get MagicAtk() : Number
      {
         return this.FMagicAtk;
      }
      
      public function get PhyDef() : Number
      {
         return this.FPhyDef;
      }
      
      public function get MagicDef() : Number
      {
         return this.FMagicDef;
      }
      
      public function get Hp() : Number
      {
         return this.FHp;
      }
      
      public function get Speed() : Number
      {
         return this.FSpeed;
      }
   }
}

