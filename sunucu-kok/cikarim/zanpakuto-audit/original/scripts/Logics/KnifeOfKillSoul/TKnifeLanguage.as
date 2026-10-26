package Logics.KnifeOfKillSoul
{
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TKnifeLanguage
   {
      
      protected var FStr0:Vector.<String>;
      
      protected var FStr1:String;
      
      protected var FStr2:String;
      
      protected var FStr3:String;
      
      protected var FStr4:String;
      
      protected var FStr5:String;
      
      protected var FStr6:String;
      
      protected var FStr7:String;
      
      protected var FStr8:String;
      
      protected var FStr9:String;
      
      protected var FStr10:String;
      
      protected var FStr11:String;
      
      protected var FStr12:String;
      
      protected var FStr13:String;
      
      protected var FStr14:String;
      
      public function TKnifeLanguage()
      {
         super();
      }
      
      public function initStr() : void
      {
         this.FStr0 = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_31);
         this.FStr1 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_32);
         this.FStr2 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_33);
         this.FStr3 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_34);
         this.FStr4 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_35);
         this.FStr5 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_36);
         this.FStr6 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_37);
         this.FStr7 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_38);
         this.FStr8 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_39);
         this.FStr9 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_40);
         this.FStr10 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_41);
         this.FStr11 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_42);
         this.FStr12 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_43);
         this.FStr13 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_44);
         this.FStr14 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_45);
      }
      
      public function GetStr0(param1:uint) : String
      {
         return this.FStr0[param1];
      }
      
      public function GetStr1(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr1,param1);
      }
      
      public function GetStr2() : String
      {
         return this.FStr2;
      }
      
      public function GetStr3() : String
      {
         return this.FStr3;
      }
      
      public function GetStr4() : String
      {
         return this.FStr4;
      }
      
      public function GetStr5() : String
      {
         return this.FStr5;
      }
      
      public function GetStr6(param1:String) : String
      {
         return TUtilityString.Format(this.FStr6,param1);
      }
      
      public function GetStr7() : String
      {
         return this.FStr7;
      }
      
      public function GetStr8(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr8,param1);
      }
      
      public function GetStr9() : String
      {
         return this.FStr9;
      }
      
      public function GetStr10() : String
      {
         return this.FStr10;
      }
      
      public function GetStr11(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr11,param1);
      }
      
      public function GetStr12() : String
      {
         return this.FStr12;
      }
      
      public function GetStr13(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr13,param1);
      }
      
      public function GetStr14() : String
      {
         return this.FStr14;
      }
   }
}

