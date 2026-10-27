package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGirlsRecommend extends TDatebaseVO
   {
      
      protected var FLable:String;
      
      protected var FLevel:int;
      
      protected var FHeroID:uint;
      
      protected var FDescription:String;
      
      public function TGirlsRecommend()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FLable = TUtilityString.FetchUTF(param1);
         this.FLevel = param1.readUnsignedInt();
         this.FHeroID = param1.readUnsignedInt();
         this.FDescription = TUtilityString.FetchUTF(param1);
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get HeroID() : uint
      {
         return this.FHeroID;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get Lable() : String
      {
         return this.FLable;
      }
   }
}

