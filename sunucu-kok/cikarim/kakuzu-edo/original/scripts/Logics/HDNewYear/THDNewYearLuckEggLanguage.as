package Logics.HDNewYear
{
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDNewYearLuckEggConfig;
   
   public class THDNewYearLuckEggLanguage
   {
      
      protected var FStr0:String;
      
      protected var FStr1:String;
      
      protected var FStr2:String;
      
      public function THDNewYearLuckEggLanguage()
      {
         super();
      }
      
      public function FillLanguage(param1:THDNewYearLuckEggConfig) : void
      {
         var _loc2_:Array = param1.Language;
         this.FStr0 = _loc2_[0];
         this.FStr1 = _loc2_[1];
         this.FStr2 = _loc2_[2];
      }
      
      public function GetStr0() : String
      {
         return this.FStr0;
      }
      
      public function GetStr1(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr1,param1);
      }
      
      public function GetStr2() : String
      {
         return this.FStr2;
      }
   }
}

