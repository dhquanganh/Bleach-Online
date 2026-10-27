package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRelatedPartner extends TDatebaseVO
   {
      
      protected var FHeroId:int;
      
      protected var FType:int;
      
      protected var FConnectId:int;
      
      protected var FConditionPoint:int;
      
      protected var FConditionStar:int;
      
      protected var FConditionId:int;
      
      public function TRelatedPartner()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FHeroId = param1.readUnsignedInt();
         this.FType = param1.readUnsignedInt();
         this.FConnectId = param1.readUnsignedInt();
         this.FConditionPoint = param1.readUnsignedInt();
         this.FConditionStar = param1.readUnsignedInt();
         this.FConditionId = param1.readUnsignedInt();
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get ConnectId() : int
      {
         return this.FConnectId;
      }
      
      public function get ConditionPoint() : int
      {
         return this.FConditionPoint;
      }
      
      public function get ConditionStar() : int
      {
         return this.FConditionStar;
      }
      
      public function get ConditionId() : int
      {
         return this.FConditionId;
      }
   }
}

