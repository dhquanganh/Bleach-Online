package Logics.Streamization.Post
{
   import Foundation.Registries.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.InteractionLog.*;
   import Logics.Spaces.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerPost extends TUnstreamizer
   {
      
      protected static var FPoolHyperString:TPoolHyperString;
      
      protected static const POSTKEY_HeroName:uint = CONST_POST.POSTKEY_HeroName;
      
      protected static const POSTKEY_HeroNameQuality:uint = CONST_POST.POSTKEY_HeroNameQuality;
      
      protected static const POSTKEY_HeroNameQualityUnderline:uint = CONST_POST.POSTKEY_HeroNameQualityUnderline;
      
      protected static const POSTKEY_PlayerQualityUnderline:uint = CONST_POST.POSTKEY_PlayerQualityUnderline;
      
      protected static const POSTKEY_PlayerCountryUnderline:uint = CONST_POST.POSTKEY_PlayerCountryUnderline;
      
      protected static const POSTKEY_Country:uint = CONST_POST.POSTKEY_Country;
      
      protected static const POSTKEY_CountryColor:uint = CONST_POST.POSTKEY_CountryColor;
      
      protected static const POSTKEY_Job:uint = CONST_POST.POSTKEY_Job;
      
      protected static const POSTKEY_Boss:uint = CONST_POST.POSTKEY_Boss;
      
      protected static const POSTKEY_Item:uint = CONST_POST.POSTKEY_Item;
      
      protected static const POSTKEY_ItemUnderline:uint = CONST_POST.POSTKEY_ItemUnderline;
      
      protected static const POSTKEY_Reward:uint = CONST_POST.POSTKEY_Reward;
      
      protected static const POSTKEY_EventName:uint = CONST_POST.POSTKEY_EventName;
      
      protected static const POSTKEY_Name:uint = CONST_POST.POSTKEY_Name;
      
      protected static const POSTKEY_Number:uint = CONST_POST.POSTKEY_Number;
      
      protected static const POSTKEY_Corps:uint = CONST_POST.POSTKEY_Corps;
      
      protected static const POSTKEY_Single:uint = CONST_POST.POSTKEY_Single;
      
      protected static const POSTKEY_OutlandArmy:uint = CONST_POST.POSTKEY_OutlandArmy;
      
      protected static const POSTKEY_CityQuality:uint = CONST_POST.POSTKEY_CityQuality;
      
      protected static const POSTKEY_Pet:uint = CONST_POST.POSTKEY_Pet;
      
      protected static const POSTKEY_OutLineUnderline:uint = CONST_POST.POSTKEY_OutLineUnderline;
      
      protected static const POSTKEY_EventLink:uint = CONST_POST.POSTKEY_EventLink;
      
      protected static const POSTKEY_LeagueMap:uint = CONST_POST.POSTKEY_LeagueMap;
      
      protected static const POSTKEY_Difficulty:uint = CONST_POST.POSTKEY_Difficulty;
      
      public static const POSTKEY_BableTowerName:uint = CONST_POST.POSTKEY_BableTowerName;
      
      public static const POSTKEY_ArenaName:uint = CONST_POST.POSTKEY_ArenaName;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const QUALITYCOLOR_TEAMBATTLE:Vector.<uint> = CONST_TEAMBATTLE.QUALITYCOLOR_INDEX;
      
      protected static const POSTKEY_ITEMS:Vector.<String> = CONST_POST.POSTKEY_ITEMS;
      
      protected static const EVENT_TYPE_PLAYER:String = CONST_POST.EVENT_TYPE_PLAYER;
      
      protected static const EVENT_TYPE_HERO:String = CONST_POST.EVENT_TYPE_HERO;
      
      protected static const EVENT_TYPE_ITEM:String = CONST_POST.EVENT_TYPE_ITEM;
      
      protected static const EVENT_TYPE_EVENT:String = CONST_POST.EVENT_TYPE_EVENT;
      
      protected static const EVENT_TYPE_LINKURL:String = CONST_POST.EVENT_TYPE_LINKURL;
      
      protected static const FORMAT_PostPlayer:String = STRING_POST.STRING_01;
      
      protected static const FORMAT_PostHero:String = STRING_POST.STRING_02;
      
      protected static const FORMAT_PostItem:String = STRING_POST.STRING_03;
      
      protected static const FORMAT_PostEvent:String = STRING_POST.STRING_04;
      
      protected static const FORMAT_PostLinkURL:String = STRING_POST.STRING_05;
      
      protected static const FORMAT_CommonText:String = STRING_POST.STRING_06;
      
      protected static const DEFAULT_COLOR:uint = 13421670;
      
      protected static const STRING_OutLineUnderline:String = "OutLineUnderline";
      
      protected var FPostRoutines:TRegistryRoutine;
      
      protected var FHtmlRoutines:TRegistryRoutine;
      
      public function TUnstreamizerPost()
      {
         super();
         this.FPostRoutines = new TRegistryRoutine();
         this.FHtmlRoutines = new TRegistryRoutine();
         this.PostRegisterRountines();
         this.HtmlRegisterRountines();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolHyperString) : void
      {
         FPoolHyperString = param1;
      }
      
      protected function PostRegisterRountines() : void
      {
         this.FPostRoutines.Register(POSTKEY_HeroName,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_HeroNameQuality,this.Perform_Post_NameQuality);
         this.FPostRoutines.Register(POSTKEY_HeroNameQualityUnderline,this.Perform_Post_HeroNameTemplateQualityUnderline);
         this.FPostRoutines.Register(POSTKEY_PlayerQualityUnderline,this.Perform_Post_NameQualityUnderline);
         this.FPostRoutines.Register(POSTKEY_PlayerCountryUnderline,this.Perform_Post_NameQualityUnderline);
         this.FPostRoutines.Register(POSTKEY_Country,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_CountryColor,this.Perform_Post_NameQuality);
         this.FPostRoutines.Register(POSTKEY_Job,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Boss,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Item,this.Perform_Post_NameQuality);
         this.FPostRoutines.Register(POSTKEY_ItemUnderline,this.Perform_Post_ItemNameTemplateQualityUnderline);
         this.FPostRoutines.Register(POSTKEY_Reward,this.Perform_Post_RewardQualityCount);
         this.FPostRoutines.Register(POSTKEY_EventName,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Name,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Number,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Corps,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_Single,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_OutlandArmy,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_CityQuality,this.Perform_Post_NameQuality);
         this.FPostRoutines.Register(POSTKEY_Pet,this.Perform_Post_Name);
         this.FPostRoutines.Register(POSTKEY_OutLineUnderline,this.Perform_Post_LinkURL);
         this.FPostRoutines.Register(POSTKEY_LeagueMap,this.Perform_Post_LeagueMap);
         this.FPostRoutines.Register(POSTKEY_Difficulty,this.Perform_Post_Difficulty);
         this.FPostRoutines.Register(POSTKEY_BableTowerName,this.Perform_Post_BableTowerName);
         this.FPostRoutines.Register(POSTKEY_ArenaName,this.Perform_Post_ArenaName);
         this.FPostRoutines.Register(POSTKEY_EventLink,this.Perform_Post_EventLink);
      }
      
      protected function Perform_Post_Name(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = FPoolHyperString.AcquireElementText();
         _loc4_.Text = param1[0];
         _loc4_.Color = param2.TextColor;
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_NameQuality(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementText = null;
         _loc5_ = FPoolHyperString.AcquireElementText();
         _loc5_.Text = param1[0];
         _loc4_ = QUALITYCOLOR_INDEX[param1[1]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_HeroNameTemplateQualityUnderline(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementLinkHero = null;
         _loc5_ = FPoolHyperString.AcquireElementLinkHero();
         _loc5_.Text = param1[0];
         _loc5_.IDTemplate = param1[1];
         _loc4_ = QUALITYCOLOR_INDEX[param1[2]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_ItemNameTemplateQualityUnderline(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementLinkItem = null;
         _loc5_ = FPoolHyperString.AcquireElementLinkItem();
         _loc5_.Text = param1[0];
         _loc5_.IDTemplate = param1[1];
         _loc4_ = QUALITYCOLOR_INDEX[param1[2]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_NameQualityUnderline(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementLinkCharacter = null;
         _loc5_ = FPoolHyperString.AcquireElementLinkCharacter();
         _loc5_.Text = param1[0];
         _loc5_.Identifier0 = param1[1];
         _loc5_.Identifier1 = param1[2];
         _loc4_ = QUALITYCOLOR_INDEX[param1[3]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_RewardQualityCount(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementText = null;
         _loc5_ = FPoolHyperString.AcquireElementText();
         _loc5_.Text = param1[0] + "x" + param1[2];
         _loc4_ = QUALITYCOLOR_INDEX[param1[1]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_LinkURL(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementLinkURL = null;
         _loc4_ = FPoolHyperString.AcquireElementLinkURL();
         _loc4_.Text = param1[0];
         _loc4_.HyperlinkAddress = param1[1];
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_LeagueMap(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THyperStringElementText = null;
         _loc5_ = FPoolHyperString.AcquireElementText();
         _loc5_.Text = param1[0];
         _loc4_ = QUALITYCOLOR_TEAMBATTLE[param1[1]];
         _loc5_.ColorOverride(_loc4_);
         param3.Add(_loc5_);
      }
      
      protected function Perform_Post_Difficulty(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = FPoolHyperString.AcquireElementText();
         _loc4_.Text = param1[0];
         _loc4_.ColorOverride(param2.TextColor);
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_BableTowerName(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = FPoolHyperString.AcquireElementText();
         _loc4_.Text = param1[0];
         _loc4_.ColorOverride(param2.TextColor);
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_ArenaName(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = FPoolHyperString.AcquireElementText();
         _loc4_.Text = param1[0];
         _loc4_.ColorOverride(param2.TextColor);
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_EventLink(param1:Array, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementLinkEvent = null;
         _loc4_ = FPoolHyperString.AcquireElementLinkEvent();
         _loc4_.Text = param2.Event.Name;
         _loc4_.EventID = param2.Event.Identifier;
         _loc4_.Color = param2.TextColor;
         if(param1 != null)
         {
            _loc4_.Tag = param1[0];
         }
         param3.Add(_loc4_);
      }
      
      protected function Perform_Post_Common(param1:String, param2:TPost, param3:THyperString) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = FPoolHyperString.AcquireElementText();
         _loc4_.Text = param1;
         _loc4_.Color = param2.TextColor;
         param3.Add(_loc4_);
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Post(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Post(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPost = null;
         var _loc7_:THyperString = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Function = null;
         var _loc14_:Boolean = false;
         _loc7_ = param2 as THyperString;
         _loc6_ = param3 as TPost;
         _loc9_ = TUtilityString.FetchUTF(param1);
         _loc11_ = Json.decode(_loc9_);
         if(_loc6_ != null && _loc6_.Identifier != CONST_POST.IDENTIFIER_GM_POST)
         {
            _loc9_ = _loc6_.TemplateTaskFront;
         }
         else
         {
            _loc9_ = _loc11_[STRING_OutLineUnderline][2];
         }
         _loc10_ = _loc9_.split("$");
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc10_[_loc4_];
            if(!TUtilityString.Empty(_loc8_))
            {
               _loc14_ = !isNaN(Number(_loc8_));
               if(_loc14_)
               {
                  _loc12_ = int(POSTKEY_EventLink);
                  _loc8_ = "Paramete";
               }
               else
               {
                  _loc12_ = POSTKEY_ITEMS.indexOf(_loc8_.split("_")[0]);
               }
               _loc13_ = this.FPostRoutines.GetRoutineByIndentifier(_loc12_);
               if(_loc13_ != null)
               {
                  _loc13_(_loc11_[_loc8_],_loc6_,_loc7_);
               }
               else
               {
                  this.Perform_Post_Common(_loc8_,_loc6_,_loc7_);
               }
            }
            _loc4_++;
         }
      }
      
      protected function HtmlRegisterRountines() : void
      {
         this.FHtmlRoutines.Register(POSTKEY_HeroName,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_HeroNameQuality,this.Perform_Html_NameQuality);
         this.FHtmlRoutines.Register(POSTKEY_HeroNameQualityUnderline,this.Perform_Html_HeroNameTemplateQualityUnderline);
         this.FHtmlRoutines.Register(POSTKEY_PlayerQualityUnderline,this.Perform_Html_NameQualityUnderline);
         this.FHtmlRoutines.Register(POSTKEY_PlayerCountryUnderline,this.Perform_Html_NameQualityUnderline);
         this.FHtmlRoutines.Register(POSTKEY_Country,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_CountryColor,this.Perform_Html_NameQuality);
         this.FHtmlRoutines.Register(POSTKEY_Job,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Boss,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Item,this.Perform_Html_NameQuality);
         this.FHtmlRoutines.Register(POSTKEY_ItemUnderline,this.Perform_Html_ItemNameTemplateQualityUnderline);
         this.FHtmlRoutines.Register(POSTKEY_Reward,this.Perform_Html_RewardQualityCount);
         this.FHtmlRoutines.Register(POSTKEY_EventName,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Name,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Number,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Corps,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_Single,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_OutlandArmy,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_CityQuality,this.Perform_Html_NameQuality);
         this.FHtmlRoutines.Register(POSTKEY_Pet,this.Perform_Html_Name);
         this.FHtmlRoutines.Register(POSTKEY_OutLineUnderline,this.Perform_Html_LinkURL);
         this.FHtmlRoutines.Register(POSTKEY_EventLink,this.Perform_Html_EventLink);
      }
      
      protected function Perform_Html_Name(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         param3.HtmlText += param1[0];
      }
      
      protected function Perform_Html_NameQuality(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityColor.TransUintToWeb(QUALITYCOLOR_INDEX[param1[1]]);
         param3.HtmlText += TUtilityString.Format(FORMAT_CommonText,_loc4_,param1[0]);
      }
      
      protected function Perform_Html_HeroNameTemplateQualityUnderline(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityColor.TransUintToWeb(QUALITYCOLOR_INDEX[param1[2]]);
         param3.HtmlText += TUtilityString.Format(FORMAT_PostHero,_loc4_,EVENT_TYPE_HERO,param1[1],param1[0]);
      }
      
      protected function Perform_Html_ItemNameTemplateQualityUnderline(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityColor.TransUintToWeb(QUALITYCOLOR_INDEX[param1[2]]);
         param3.HtmlText += TUtilityString.Format(FORMAT_PostItem,_loc4_,EVENT_TYPE_ITEM,param1[1],param1[0]);
      }
      
      protected function Perform_Html_NameQualityUnderline(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityColor.TransUintToWeb(QUALITYCOLOR_INDEX[param1[3]]);
         param3.HtmlText += TUtilityString.Format(FORMAT_PostPlayer,_loc4_,EVENT_TYPE_PLAYER,param1[1],param1[2],param1[0]);
      }
      
      protected function Perform_Html_RewardQualityCount(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityColor.TransUintToWeb(QUALITYCOLOR_INDEX[param1[1]]);
         param3.HtmlText += TUtilityString.Format(FORMAT_CommonText,_loc4_,param1[0] + "x" + param1[2]);
      }
      
      protected function Perform_Html_LinkURL(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         param3.HtmlText += TUtilityString.Format(FORMAT_PostLinkURL,EVENT_TYPE_LINKURL,param1[1],param1[0]);
      }
      
      protected function Perform_Html_EventLink(param1:Array, param2:TPost, param3:TInteractionLog) : void
      {
         param3.HtmlText += TUtilityString.Format(FORMAT_PostEvent,EVENT_TYPE_EVENT,param2.Event.Identifier,param2.Event.Name);
      }
      
      protected function Perform_Html_Common(param1:String, param2:TPost, param3:TInteractionLog) : void
      {
         param3.HtmlText += param1;
      }
      
      protected function UnstreamizationPerform_HtmlByPost(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPost = null;
         var _loc7_:TInteractionLog = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Function = null;
         var _loc14_:Boolean = false;
         _loc7_ = param2 as TInteractionLog;
         _loc6_ = param3 as TPost;
         _loc9_ = TUtilityString.FetchUTF(param1);
         _loc11_ = Json.decode(_loc9_);
         if(_loc6_ != null)
         {
            _loc9_ = _loc6_.TemplateTaskFront;
            _loc10_ = _loc9_.split("$");
         }
         else
         {
            _loc9_ = _loc11_[STRING_OutLineUnderline][2];
            _loc10_ = _loc9_.split("$");
         }
         _loc7_.HtmlText = "<p align=\'left\'><font face=\'宋体\' size=\'12\' color=\'" + TUtilityColor.TransUintToWeb(_loc6_.TextColor) + "\' letterspacing=\'0\' kerning=\'0\'>";
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc10_[_loc4_];
            if(!TUtilityString.Empty(_loc8_))
            {
               _loc14_ = !isNaN(Number(_loc8_));
               if(_loc14_)
               {
                  _loc12_ = int(POSTKEY_EventLink);
               }
               else
               {
                  _loc12_ = POSTKEY_ITEMS.indexOf(_loc8_.split("_")[0]);
               }
               _loc13_ = this.FHtmlRoutines.GetRoutineByIndentifier(_loc12_);
               if(_loc13_ != null)
               {
                  _loc13_(_loc11_[_loc8_],_loc6_,_loc7_);
               }
               else
               {
                  this.Perform_Html_Common(_loc8_,_loc6_,_loc7_);
               }
            }
            _loc4_++;
         }
         _loc7_.HtmlText += "</font></p>";
      }
      
      public function UnstreamizeHtmlByPost(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_HtmlByPost(param1,param2,param3);
      }
   }
}

