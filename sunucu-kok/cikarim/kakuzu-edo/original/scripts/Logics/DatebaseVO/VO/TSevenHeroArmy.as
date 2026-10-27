package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSevenHeroArmy extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FServenHero:int;
      
      protected var FPrePoint:int;
      
      protected var FIsServenHero:int;
      
      protected var FOpenLevel:int;
      
      protected var FLimitLevel:int;
      
      protected var FSortNumber:int;
      
      protected var FOneWinBuff:String;
      
      protected var FOneFailBuff:String;
      
      protected var FManyWinReward:String;
      
      protected var FImage:int;
      
      protected var FModel:int;
      
      public function TSevenHeroArmy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FServenHero = param1.readUnsignedInt();
         this.FPrePoint = param1.readInt();
         this.FIsServenHero = param1.readUnsignedInt();
         this.FOpenLevel = param1.readUnsignedInt();
         this.FLimitLevel = param1.readUnsignedInt();
         this.FSortNumber = param1.readUnsignedInt();
         this.FOneWinBuff = TUtilityString.FetchUTF(param1);
         this.FOneFailBuff = TUtilityString.FetchUTF(param1);
         this.FManyWinReward = TUtilityString.FetchUTF(param1);
         this.FImage = param1.readUnsignedInt();
         this.FModel = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get ServenHero() : int
      {
         return this.FServenHero;
      }
      
      public function get PrePoint() : int
      {
         return this.FPrePoint;
      }
      
      public function get IsServenHero() : int
      {
         return this.FIsServenHero;
      }
      
      public function get OpenLevel() : int
      {
         return this.FOpenLevel;
      }
      
      public function get LimitLevel() : int
      {
         return this.FLimitLevel;
      }
      
      public function get SortNumber() : int
      {
         return this.FSortNumber;
      }
      
      public function get OneWinBuff() : String
      {
         return this.FOneWinBuff;
      }
      
      public function get OneFailBuff() : String
      {
         return this.FOneFailBuff;
      }
      
      public function get ManyWinReward() : String
      {
         return this.FManyWinReward;
      }
      
      public function get Image() : int
      {
         return this.FImage;
      }
      
      public function get Model() : int
      {
         return this.FModel;
      }
   }
}

