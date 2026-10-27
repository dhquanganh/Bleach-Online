package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TKnifeSoul extends TDatebaseVO
   {
      
      protected var FNextID:uint;
      
      protected var FLevel:int;
      
      protected var FHeroLevelLimit:int;
      
      protected var FNeedExp:int;
      
      protected var FPower:int;
      
      protected var FAgile:int;
      
      protected var FIntelligence:int;
      
      protected var FLife:int;
      
      public function TKnifeSoul()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FNextID = param1.readUnsignedInt();
         this.FLevel = param1.readInt();
         this.FHeroLevelLimit = param1.readInt();
         this.FNeedExp = param1.readInt();
         this.FPower = param1.readInt();
         this.FAgile = param1.readInt();
         this.FIntelligence = param1.readInt();
         this.FLife = param1.readInt();
      }
      
      public function get NextID() : uint
      {
         return this.FNextID;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get HeroLevelLimit() : int
      {
         return this.FHeroLevelLimit;
      }
      
      public function get NeedExp() : int
      {
         return this.FNeedExp;
      }
      
      public function get Power() : int
      {
         return this.FPower;
      }
      
      public function get Agile() : int
      {
         return this.FAgile;
      }
      
      public function get Intelligence() : int
      {
         return this.FIntelligence;
      }
      
      public function get Life() : int
      {
         return this.FLife;
      }
   }
}

