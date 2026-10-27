package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSevenHeroSoul extends TDatebaseVO
   {
      
      protected var FHeroid:uint;
      
      protected var FSoultips:String;
      
      protected var FName:String;
      
      protected var FStringColor:String;
      
      protected var FColor:String;
      
      protected var FTextColor:uint;
      
      public function TSevenHeroSoul()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FHeroid = param1.readUnsignedInt();
         this.FSoultips = TUtilityString.FetchUTF(param1);
         this.FName = TUtilityString.FetchUTF(param1);
         this.FColor = TUtilityString.FetchUTF(param1);
         this.FTextColor = parseInt(this.FColor);
      }
      
      public function get Heroid() : uint
      {
         return this.FHeroid;
      }
      
      public function get Soultips() : String
      {
         return this.FSoultips;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Color() : String
      {
         return this.FColor;
      }
      
      public function get TextColor() : uint
      {
         return this.FTextColor;
      }
   }
}

