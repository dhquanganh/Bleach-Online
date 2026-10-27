package Logics.HDChristmas
{
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDChristmasCarnivalConfig;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class THDChristmasCarnivalLanguage
   {
      
      protected var FStr0:String;
      
      protected var FStr1:String;
      
      protected var FStr2:String;
      
      protected var FStr3:String;
      
      protected var FStr4:String;
      
      protected var FStr5:String;
      
      protected var FStr6:String;
      
      public function THDChristmasCarnivalLanguage()
      {
         super();
      }
      
      public function FillLanguage(param1:THDChristmasCarnivalConfig) : void
      {
         var _loc2_:Array = param1.Language;
         this.FStr0 = _loc2_[0];
         this.FStr1 = _loc2_[1];
         this.FStr2 = _loc2_[2];
         this.FStr3 = _loc2_[3];
         this.FStr4 = _loc2_[4];
         this.FStr5 = _loc2_[5];
         this.FStr6 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06);
      }
      
      public function GetStr0(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr0,param1);
      }
      
      public function GetStr1(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr1,param1);
      }
      
      public function GetStr2() : String
      {
         return this.FStr2;
      }
      
      public function GetStr3(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr3,param1);
      }
      
      public function GetStr4(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr4,param1);
      }
      
      public function GetStr5() : String
      {
         return this.FStr5;
      }
      
      public function GetStr6(param1:Number) : String
      {
         return TUtilityString.Format(this.FStr6,param1);
      }
   }
}

