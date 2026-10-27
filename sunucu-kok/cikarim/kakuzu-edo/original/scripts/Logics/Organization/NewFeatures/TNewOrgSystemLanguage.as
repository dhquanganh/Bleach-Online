package Logics.Organization.NewFeatures
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.Organization.VO.TOrgSpoilsBarVO;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TNewOrgSystemLanguage
   {
      
      protected var FStr0:String;
      
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
      
      protected var FStr15:String;
      
      protected var FStr16:String;
      
      protected var FStr17:String;
      
      protected var FStr18:String;
      
      protected var FStr19:String;
      
      protected var FStr20:String;
      
      protected var FStr21:Vector.<String>;
      
      protected var FStr22:String;
      
      protected var FStr23:String;
      
      protected var FStr24:String;
      
      protected var FStr25:String;
      
      protected var FStr26:String;
      
      protected var FStr27:String;
      
      protected var FStr28:String;
      
      protected var FStr29:String;
      
      protected var FStr30:String;
      
      protected var FStr31:String;
      
      protected var FStr32:String;
      
      protected var FStr33:String;
      
      protected var FStr34:String;
      
      protected var FStr35:String;
      
      protected var FData:TNewOrgData;
      
      public function TNewOrgSystemLanguage(param1:TNewOrgData)
      {
         super();
         this.FData = param1;
         this.FData.NewOrgSystemLanguage = this;
         this.initStr();
      }
      
      protected function initStr() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FStr0 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_01);
         this.FStr1 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_02);
         this.FStr2 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_03);
         this.FStr3 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_04);
         this.FStr4 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_05);
         this.FStr5 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_06);
         this.FStr6 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_07);
         this.FStr7 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_08);
         this.FStr8 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_09));
         this.FStr9 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_10);
         this.FStr10 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_11);
         this.FStr11 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_12));
         this.FStr12 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_13);
         this.FStr13 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_14));
         this.FStr14 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_15);
         this.FStr15 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_16));
         this.FStr16 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_17));
         this.FStr17 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_38);
         this.FStr18 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_19);
         this.FStr19 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_20);
         this.FStr20 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_21);
         _loc2_ = CONST_SYSTEMLANGUAGE.ORG_RAIDERS.length;
         this.FStr21 = new Vector.<String>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FStr21[_loc1_] = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORG_RAIDERS[_loc1_]));
            _loc1_++;
         }
         this.FStr22 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_35);
         this.FStr23 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_36);
         this.FStr24 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_37);
         this.FStr25 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_40);
         this.FStr26 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_41);
         this.FStr27 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_42);
         this.FStr28 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_43);
         this.FStr29 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_44);
         this.FStr30 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_45);
         this.FStr31 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_46);
         this.FStr32 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_47);
         this.FStr33 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_39);
         this.FStr34 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_48);
         this.FStr35 = this.FormatText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_57));
      }
      
      protected function FormatText(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = "";
         _loc5_ = param1.split("%n");
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc4_ + _loc5_[_loc2_] + "\n";
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetStr0() : String
      {
         return TUtilityString.Format(this.FStr0,1);
      }
      
      public function GetStr1() : String
      {
         return this.FStr1;
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
         return TUtilityString.Format(this.FStr4,this.FData.CurrentPointResetGold(),this.FData.CurrentPointReaminReset());
      }
      
      public function GetStr5() : String
      {
         return this.FStr5;
      }
      
      public function GetStr6() : String
      {
         return TUtilityString.Format(this.FStr6,this.FData.OrgConfigValue.ActionForce_LegionActive);
      }
      
      public function GetStr7() : String
      {
         return TUtilityString.Format(this.FStr7,this.FData.OrgConfigValue.ActionForce_LegionActive);
      }
      
      public function GetStr8(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:TCity = null;
         var _loc5_:TCity = null;
         _loc4_ = this.FData.GroupCopys[param1].City;
         _loc5_ = this.FData.GetSingleCopyByID(_loc4_.PreCity).City;
         _loc3_ = _loc4_.OpenLevel;
         _loc2_ = _loc5_.Name;
         return TUtilityString.Format(this.FStr8,_loc3_,_loc2_);
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
         return TUtilityString.Format(this.FStr11,this.FData.OrgConfigValue.Legion_Open_Consumption[param1]);
      }
      
      public function GetStr12() : String
      {
         return this.FStr12;
      }
      
      public function GetStr13(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr13,this.FData.OrgConfigValue.Legion_Reset_Consumption[param1]);
      }
      
      public function GetStr14() : String
      {
         return this.FStr14;
      }
      
      public function GetStr15() : String
      {
         return this.FStr15;
      }
      
      public function GetStr16() : String
      {
         return this.FStr16;
      }
      
      public function GetStr17() : String
      {
         return this.FStr17;
      }
      
      public function GetStr18(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr18,this.FData.CurrentCopy.SpoilsVOs[param1].AppCount);
      }
      
      public function GetStr19(param1:uint) : String
      {
         return TUtilityString.Format(this.FStr19,this.FData.CurrentCopy.SpoilsVOs[param1].Rank);
      }
      
      public function GetStr20(param1:uint, param2:uint, param3:uint) : String
      {
         return TUtilityString.Format(this.FStr20,param1,param2,param3);
      }
      
      public function GetStr21(param1:uint) : String
      {
         return this.FStr21[param1];
      }
      
      public function GetStr22() : String
      {
         return this.FStr22;
      }
      
      public function GetStr23() : String
      {
         return this.FStr23;
      }
      
      public function GetStr24(param1:Number, param2:Number, param3:Number, param4:Number) : String
      {
         return TUtilityString.Format(this.FStr24,param1,param2,param3,param4);
      }
      
      public function GetStr25() : String
      {
         return this.FStr25;
      }
      
      public function GetStr26() : String
      {
         return this.FStr26;
      }
      
      public function GetStr27() : String
      {
         return this.FStr27;
      }
      
      public function GetStr28() : String
      {
         return TUtilityString.Format(this.FStr28,this.FData.OrgConfigValue.Mall_Reset_Price[this.FData.MallRefreshCounts]);
      }
      
      public function GetStr29() : String
      {
         return this.FStr29;
      }
      
      public function GetStr30() : String
      {
         return this.FStr30;
      }
      
      public function GetStr31() : String
      {
         return this.FStr31;
      }
      
      public function GetStr32() : String
      {
         return this.FStr32;
      }
      
      public function GetStr33(param1:uint) : String
      {
         var _loc2_:TOrgSpoilsBarVO = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<TOrgSpoilsBarVO> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:TBins = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc4_ = this.FData.CurrentCopy.SpoilsVOs;
         _loc2_ = _loc4_[param1];
         _loc5_ = CONST_COMMON.RewardIDToTemplateID(this.FData.ApplyType,this.FData.ApplyCode);
         _loc6_ = CONST_COMMON.RewardIDToTemplateID(_loc2_.Type,_loc2_.Code);
         _loc7_ = _loc8_.GetDatebaseByIdentifier(_loc5_) as TArticle;
         _loc9_ = _loc7_.Name;
         _loc7_ = _loc8_.GetDatebaseByIdentifier(_loc6_) as TArticle;
         _loc10_ = _loc7_.Name;
         return TUtilityString.Format(this.FStr33,_loc9_,this.FData.ApplyRank,_loc9_,_loc10_);
      }
      
      public function GetStr34(param1:int) : String
      {
         return TUtilityString.Format(this.FStr34,param1);
      }
      
      public function GetStr35(param1:uint) : String
      {
         var _loc2_:TCity = null;
         var _loc3_:TCity = null;
         _loc2_ = this.FData.SingleCopys[param1].City;
         _loc3_ = param1 == 0 ? null : this.FData.SingleCopys[param1 - 1].City;
         if(_loc3_ == null)
         {
            return TUtilityString.Format(this.FStr35,_loc2_.OpenLevel);
         }
         return TUtilityString.Format(this.FStr8,_loc2_.OpenLevel,_loc3_.Name);
      }
   }
}

