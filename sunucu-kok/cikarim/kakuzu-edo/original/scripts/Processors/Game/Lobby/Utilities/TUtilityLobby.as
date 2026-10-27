package Processors.Game.Lobby.Utilities
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TTitle;
   import Logics.Achievenment.TTitles;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.SLogicsCore;
   import Logics.Skills.TSkill;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Resources.Constants.*;
   import flash.utils.Dictionary;
   import ghostcat.util.data.*;
   
   public class TUtilityLobby
   {
      
      protected static var FConfigValues:TBins;
      
      protected static var FSystemLanguages:TBins;
      
      protected static var FReturnWindowsList:Dictionary;
      
      protected static var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected static var FUIWindowRecharge:TUIWindowRecharge;
      
      protected static var FOnCreateKnifeOfSkillSoulData:Function;
      
      protected static const RESOURCEID_SystemLanguage:uint = CONST_DATEBASEVO.RESOURCEID_SystemLanguage;
      
      protected static const RESOURCEID_ConfigValue:uint = CONST_DATEBASEVO.RESOURCEID_ConfigValue;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const SOUL_BLUE:int = 14100061;
      
      protected static const SOUL_PURPLE:int = 14100062;
      
      protected static const SOUL_GOLD:int = 14100063;
      
      protected static const SOUL_ORANGE:int = 14100064;
      
      public function TUtilityLobby()
      {
         super();
         throw new Error("TUtilityLobby Class Is Static Container Only");
      }
      
      public static function set OnCreateKnifeOfSkillSoulData(param1:Function) : void
      {
         FOnCreateKnifeOfSkillSoulData = param1;
      }
      
      public static function GetObjectByIdentifier(param1:uint) : Object
      {
         var _loc2_:String = null;
         var _loc3_:TConfigValue = null;
         _loc2_ = "";
         if(FConfigValues == null)
         {
            FConfigValues = SResourcesCore.ResourceBin.GetBinsByResourceID(RESOURCEID_ConfigValue);
         }
         _loc3_ = FConfigValues.GetDatebaseByIdentifier(param1) as TConfigValue;
         if(_loc3_ != null)
         {
            return _loc3_.Value;
         }
         return null;
      }
      
      public static function GetStringByIdentifier(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:TSystemLanguage = null;
         _loc2_ = "";
         if(FSystemLanguages == null)
         {
            FSystemLanguages = SResourcesCore.ResourceBin.GetBinsByResourceID(RESOURCEID_SystemLanguage);
         }
         _loc3_ = FSystemLanguages.GetDatebaseByIdentifier(param1) as TSystemLanguage;
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.Desc;
         }
         else
         {
            _loc2_ = "ID:" + param1.toString();
         }
         return _loc2_;
      }
      
      public static function GetStringsByIdentifier(param1:uint) : Vector.<String>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Vector.<String> = null;
         _loc4_ = GetStringByIdentifier(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc2_ = int(_loc5_.length);
         _loc6_ = new Vector.<String>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_[_loc3_] = _loc5_[_loc3_];
            _loc3_++;
         }
         return _loc6_;
      }
      
      public static function GetProfessionByIndex(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_Professions);
         return _loc3_[param1];
      }
      
      public static function GetBaseAttributeNameByIndex(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_BASEATTRIBUTENAMES);
         return _loc3_[param1];
      }
      
      public static function GetBaseAttributeNameByType(param1:uint) : String
      {
         var _loc2_:TStarPointDesc = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + param1) as TStarPointDesc;
         return _loc2_.Desc;
      }
      
      public static function GetFamilyNameByIndex(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_FAMILYNAMES);
         return _loc3_[param1];
      }
      
      public static function GetTargetNameByIndex(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_TARGETNAME);
         return _loc3_[param1];
      }
      
      public static function GetColorNameByIndex(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_QUALITYCOLOR);
         return _loc3_[param1];
      }
      
      public static function GetItemName(param1:uint, param2:uint) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:TArticle = null;
         _loc4_ = "";
         switch(param1)
         {
            case CONST_COMMON.FIRSTTYPE_ITEM_CREDIT:
               switch(param2)
               {
                  case CONST_COMMON.SECONDTYPE_ITEM_CREDIT_COIN:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Coin;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_CREDIT_Gold:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Gold;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_CREDIT_Vouchers:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Vouchers;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_CREDIT_Integral:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Integral;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_INVENTORY:
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param2) as TArticle;
               _loc4_ = _loc5_.Name;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_EXP:
               _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Exp;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_MILITARY:
               _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Military;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_PRESTIGE:
               _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Prestige;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_SOUL:
               _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Soul;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_SOULS:
               switch(param2)
               {
                  case CONST_COMMON.SECONDTYPE_ITEM_SOULS_BlueSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_BlueSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_SOULS_PurpleSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_PurpleSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_SOULS_GoldenSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_GoldenSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_SOULS_RedSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_RedSoul;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_STARS:
               switch(param2)
               {
                  case CONST_COMMON.SECONDTYPE_ITEM_STARS_BlueStar:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_BlueStar;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_STARS_RedStar:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_RedStar;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_VIRTUALSOULS:
               switch(param2)
               {
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_ColorSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_ColorSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_WindSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_WindSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_WaterSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_WaterSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_DustSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_DustSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_ThunderSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_ThunderSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_FireSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_FireSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_FourthSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_FourthSoul;
                     break;
                  case CONST_COMMON.SECONDTYPE_ITEM_VIRTUALSOULS_FirstSoul:
                     _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_FirstSoul;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_SPECIAL:
               if(param2 == CONST_COMMON.SECONDTYPE_ITEM_SPECIAL_Fish)
               {
                  _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Fish;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_EXPLOIT:
               _loc3_ = CONST_SYSTEMLANGUAGE.ITEMNAME_Exploit;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_HeroChangeCommonChip:
               _loc3_ = CONST_SYSTEMLANGUAGE.STRING_HeroChange_43;
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_CrashJadeChip:
               if(param2 == CONST_COMMON.SECONDTYPE_ITEM_CRASHJADE_Shop)
               {
                  _loc3_ = CONST_SYSTEMLANGUAGE.STRING_CrashJade_46;
               }
               else if(param2 == CONST_COMMON.SECONDTYPE_ITEM_CRASHJADE_Dan)
               {
                  _loc3_ = CONST_SYSTEMLANGUAGE.STRING_CrashJade_45;
               }
               break;
            case CONST_COMMON.FIRSTTYPE_ITEM_LegionCoinChest:
               if(param2 == CONST_COMMON.SECONDTYPE_ITEM_LegionCoin)
               {
                  _loc3_ = CONST_SYSTEMLANGUAGE.STRING_NREORG_63;
               }
         }
         if(_loc3_ != 0)
         {
            _loc4_ = GetStringByIdentifier(_loc3_);
         }
         return _loc4_;
      }
      
      public static function GetAttributeName(param1:int) : String
      {
         var _loc2_:TStarPointDesc = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + param1) as TStarPointDesc;
         return _loc2_.Desc;
      }
      
      public static function GetTitleByID(param1:Vector.<TTitles>, param2:int) : TTitle
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTitle = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1[_loc3_].GetTitleByID(param2);
            if(_loc5_ != null)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function IfInventory(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc3_ = CONST_COMMON.REWARDIDNotInventory_DATA;
         _loc2_ = _loc3_.indexOf(param1);
         return _loc2_ < 0;
      }
      
      public static function GetStandPositionWithProfession(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case CONST_CHARACTER.PROFESSION_Agility:
            case CONST_CHARACTER.PROFESSION_Strength:
               _loc2_ = uint(INDEX_Station_Middle);
               break;
            case CONST_CHARACTER.PROFESSION_Defending:
               _loc2_ = uint(INDEX_Station_Front);
               break;
            case CONST_CHARACTER.PROFESSION_Intellect:
               _loc2_ = uint(INDEX_Station_After);
         }
         return _loc2_;
      }
      
      public static function GetSoulCount(param1:int) : uint
      {
         var _loc2_:uint = 0;
         if(param1 == SOUL_BLUE)
         {
            _loc2_ = uint(SLogicsCore.Character.HeroSoulBlueSoul);
         }
         else if(param1 == SOUL_PURPLE)
         {
            _loc2_ = uint(SLogicsCore.Character.HeroSoulPurpleSoul);
         }
         else if(param1 == SOUL_GOLD)
         {
            _loc2_ = uint(SLogicsCore.Character.HeroSoulGoldSoul);
         }
         else if(param1 == SOUL_ORANGE)
         {
            _loc2_ = uint(SLogicsCore.Character.HeroSoulOrangeSoul);
         }
         else
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public static function CreateKnifeOfSkillSoulData(param1:int) : TKnifeOfKillSoulData
      {
         if(FOnCreateKnifeOfSkillSoulData != null)
         {
            return FOnCreateKnifeOfSkillSoulData(param1);
         }
         return null;
      }
      
      public static function GetViewtypeByAttributeName(param1:int) : Boolean
      {
         var _loc2_:TStarPointDesc = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,CONST_COMMON.STARPOINTDESC_PRE + param1) as TStarPointDesc;
         return _loc2_.ViewType == 1;
      }
      
      public static function GetColorStringByCount(param1:int, param2:int, param3:String) : String
      {
         var _loc4_:String = null;
         if(param1 >= param2)
         {
            _loc4_ = CONST_COMMON.HTMLCOLOR_Green;
         }
         else
         {
            _loc4_ = CONST_COMMON.HTMLCOLOR_Red;
         }
         return "<font color=\'" + _loc4_ + "\'>" + param3 + "</font>";
      }
      
      public static function SetReturnWindows(param1:Class, param2:uint, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:Object = null;
         if(FReturnWindowsList == null)
         {
            FReturnWindowsList = new Dictionary();
         }
         _loc5_ = {
            "To":param2,
            "Parameter0":param3,
            "Parameter1":param4
         };
         FReturnWindowsList[param1] = _loc5_;
      }
      
      public static function ReturnWindows(param1:Class) : Boolean
      {
         var _loc2_:Object = null;
         if(FReturnWindowsList == null)
         {
            return false;
         }
         _loc2_ = FReturnWindowsList[param1];
         if(_loc2_ != null)
         {
            FReturnWindowsList[param1] = null;
            SUtilityHyperLink.ShortcutHyperlink(_loc2_.To,_loc2_.Parameter0,_loc2_.Parameter1);
            return true;
         }
         return false;
      }
      
      public static function GetArticleQuantity(param1:uint, param2:uint, param3:Boolean = false) : uint
      {
         var _loc4_:TInventories = null;
         var _loc5_:TInventories = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TInventory = null;
         var _loc9_:uint = 0;
         _loc4_ = SLogicsCore.Character.TemporaryInventories;
         _loc5_ = SLogicsCore.Character.Backpack[param2 - 1];
         _loc9_ = 0;
         if(param3)
         {
            _loc7_ = uint(_loc4_.Count);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc4_.GetInventoryByIndex(_loc6_);
               if(_loc8_.IDTemplate == param1)
               {
                  _loc9_ = _loc9_ + _loc8_.Quantity;
               }
               _loc6_++;
            }
         }
         _loc7_ = uint(_loc5_.Count);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc5_.GetInventoryByIndex(_loc6_);
            if(_loc8_.IDTemplate == param1)
            {
               _loc9_ = _loc9_ + _loc8_.Quantity;
            }
            _loc6_++;
         }
         return _loc9_;
      }
      
      public static function GoldBuy(param1:uint, param2:Function, param3:String = null, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         _loc6_ = uint(SLogicsCore.Character.CreditGold);
         if(param4)
         {
            _loc6_ = _loc6_ + SLogicsCore.Character.CreditGiftCertificate;
         }
         if(FUIWindowConfirmation == null)
         {
            FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
            FUIWindowConfirmation.SetCheckBoxUsable(param5);
            FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         }
         if(_loc6_ >= param1)
         {
            if(FUIWindowConfirmation.IsSelected)
            {
               param2(null);
            }
            else
            {
               if(TUtilityString.Empty(param3))
               {
                  _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06);
               }
               else
               {
                  _loc7_ = param3;
               }
               FUIWindowConfirmation.Text = TUtilityString.Format(_loc7_,param1);
               FUIWindowConfirmation.OnOK = param2;
               FUIWindowConfirmation.Visible = true;
            }
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(param1);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      public static function SamePlatform(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:UInt64 = null;
         var _loc6_:UInt64 = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         _loc5_ = new UInt64(param2,param1);
         _loc6_ = new UInt64(param4,param3);
         _loc7_ = String(_loc5_.ToNumber());
         _loc8_ = String(_loc6_.ToNumber());
         return _loc7_.substr(0,3) == _loc8_.substr(0,3);
      }
      
      public static function ConstructSkillByID(param1:uint, param2:TSkill) : void
      {
         var _loc3_:TSkillConfig = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,param1) as TSkillConfig;
         param2.Name = _loc3_.Name;
         param2.Description = _loc3_.Desc;
         param2.Sort = _loc3_.SortId;
         param2.IDTexture = _loc3_.Icon;
         param2.SkillID = _loc3_.SkillId;
      }
      
      public static function GetConfigValue(param1:uint) : Object
      {
         var _loc2_:TBins = null;
         var _loc3_:TConfigValue = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = _loc2_.GetDatebaseByIdentifier(param1) as TConfigValue;
         return _loc3_.Value;
      }
   }
}

