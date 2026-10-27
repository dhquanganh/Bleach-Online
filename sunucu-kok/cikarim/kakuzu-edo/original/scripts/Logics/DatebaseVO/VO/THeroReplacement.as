package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THeroReplacement extends TDatebaseVO
   {
      
      protected var FDesc:String;
      
      protected var FName:String;
      
      protected var FIsOpen:int;
      
      protected var FHeroID:int;
      
      protected var FModelLv:int;
      
      protected var FTimeLimit:int;
      
      protected var FNewModelHeroId:int;
      
      public function THeroReplacement()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIsOpen = param1.readUnsignedInt();
         this.FHeroID = param1.readUnsignedInt();
         this.FModelLv = param1.readUnsignedInt();
         this.FTimeLimit = param1.readUnsignedInt();
         this.FNewModelHeroId = param1.readUnsignedInt();
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get IsOpen() : int
      {
         return this.FIsOpen;
      }
      
      public function get HeroID() : int
      {
         return this.FHeroID;
      }
      
      public function get ModelLv() : int
      {
         return this.FModelLv;
      }
      
      public function get TimeLimit() : int
      {
         return this.FTimeLimit;
      }
      
      public function get NewModelHeroId() : int
      {
         return this.FNewModelHeroId;
      }
   }
}

