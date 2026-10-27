package Processors.Game.Lobby.Chat.HyperString.Importers
{
   import Foundation.Common.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.SensitiveWord.SSensitiveWord;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.Streamization.HyperStrings.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.RTTIs.*;
   import flash.utils.*;
   
   public class THyperStringImporter
   {
      
      protected static const STRING_ThickSquareLeft:String = CONST_COMMON.STRING_ThickSquareLeft;
      
      protected static const STRING_ThickSquareRight:String = CONST_COMMON.STRING_ThickSquareRight;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const CAPACITY_Channels:int = CONST_CHAT.CAPACITY_Channels;
      
      protected static const CHANNEL_TYPE_Whisper:int = CONST_CHAT.CHANNEL_TYPE_Whisper;
      
      protected static const CHANNEL_TYPE_SystemOne:int = CONST_CHAT.CHANNEL_TYPE_SystemOne;
      
      protected static const WHISPER_Receive:int = CONST_CHAT.WHISPER_Receive;
      
      protected static const WHISPER_Echoplex:int = CONST_CHAT.WHISPER_Echoplex;
      
      protected var FUnstreamizerHyperString:TUnstreamizerHyperString;
      
      protected var FPoolHyperString:TPoolHyperString;
      
      protected var FArticles:TBins;
      
      protected var FChannelsColor:Vector.<uint>;
      
      protected var FChannelsName:Vector.<String>;
      
      protected var FStringYou:String;
      
      protected var FStringSpeak:String;
      
      protected var FStringFilled:String;
      
      protected var FStringModifiers:String;
      
      public function THyperStringImporter()
      {
         super();
         this.FUnstreamizerHyperString = new TUnstreamizerHyperString();
         this.FPoolHyperString = SLogicsCore.PoolHyperString;
         this.FChannelsColor = new Vector.<uint>(CAPACITY_Channels);
         this.FChannelsName = new Vector.<String>(CAPACITY_Channels);
         this.FStringYou = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_12);
         this.FStringModifiers = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_13);
         this.FStringFilled = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_14);
         this.FStringSpeak = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_15);
      }
      
      protected function ImportUniversalContent(param1:ByteArray, param2:THyperString, param3:uint) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:THyperStringElementLinkItem = null;
         var _loc9_:THyperStringElement = null;
         if(param1 != null)
         {
            this.FUnstreamizerHyperString.Unstreamize(param1,param2,null);
         }
         _loc5_ = param2.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = param2.GetElementByIndex(_loc4_);
            _loc6_ = param3;
            if(_loc9_ is THyperStringElementLinkItem)
            {
               _loc8_ = _loc9_ as THyperStringElementLinkItem;
               _loc7_ = this.FArticles.GetDatebaseByIdentifier(_loc8_.IDTemplate) as TArticle;
               if(_loc7_ != null)
               {
                  _loc8_.Text = _loc7_.Name;
                  _loc6_ = QUALITYCOLOR_INDEX[_loc7_.Quality];
               }
               else
               {
                  _loc8_.Text = _loc8_.IDTemplate.toString();
               }
            }
            this.FindMaskword(_loc9_);
            this.FormatContent(_loc9_,_loc6_);
            _loc4_++;
         }
         _loc4_ = int(_loc5_ - 1);
         while(_loc4_ >= 0)
         {
            _loc9_ = param2.GetElementByIndex(_loc4_);
            if(_loc9_ is THyperStringElementLinkItem)
            {
               _loc8_ = _loc9_ as THyperStringElementLinkItem;
               _loc7_ = this.FArticles.GetDatebaseByIdentifier(_loc8_.IDTemplate) as TArticle;
               if(!_loc7_.ExpandIsCanReveal)
               {
                  param2.Delete(_loc4_);
               }
            }
            _loc4_--;
         }
      }
      
      protected function ImportUniversalPrefix(param1:ByteArray, param2:THyperString, param3:String, param4:uint, param5:uint, param6:String, param7:uint, param8:Boolean = false) : void
      {
         var _loc9_:* = 0;
         var _loc10_:THyperStringElementText = null;
         var _loc11_:THyperStringElementText = null;
         var _loc12_:THyperStringElementLinkCharacter = null;
         var _loc13_:THyperStringElementIcon = null;
         this.ImportUniversalContent(param1,param2,param7);
         _loc9_ = 0;
         _loc10_ = this.FormatChannelName(param6,param7);
         param2.Insert(_loc9_++,_loc10_);
         if(param8)
         {
            _loc13_ = this.FUnstreamizerHyperString.GetIconElementByID(RTTI_HYPERSTRING.ELEMENTCLASS_Icon) as THyperStringElementIcon;
            _loc13_.IDIcon = CONST_CHAT.SPECIEL_BleachAgent;
            param2.Insert(_loc9_++,_loc13_);
         }
         _loc12_ = this.FormatPlayerName(param3,param4,param5,param7);
         param2.Insert(_loc9_++,_loc12_);
         _loc11_ = this.FormatText(this.FStringSpeak,param7);
         param2.Insert(_loc9_++,_loc11_);
      }
      
      protected function FormatChannelName(param1:String, param2:uint) : THyperStringElementText
      {
         var _loc3_:THyperStringElementText = null;
         _loc3_ = this.FPoolHyperString.AcquireElementText();
         _loc3_.Text = STRING_ThickSquareLeft + param1 + STRING_ThickSquareRight;
         _loc3_.ColorOverride(param2);
         return _loc3_;
      }
      
      protected function FormatPlayerName(param1:String, param2:uint, param3:uint, param4:uint) : THyperStringElementLinkCharacter
      {
         var _loc5_:THyperStringElementLinkCharacter = null;
         _loc5_ = this.FPoolHyperString.AcquireElementLinkCharacter();
         _loc5_.Text = param1;
         _loc5_.Identifier0 = param2;
         _loc5_.Identifier1 = param3;
         _loc5_.ColorOverride(param4);
         return _loc5_;
      }
      
      protected function FindMaskword(param1:THyperStringElement) : void
      {
         var _loc2_:THyperStringElementTextual = null;
         if(param1 is THyperStringElementTextual)
         {
            _loc2_ = param1 as THyperStringElementTextual;
            _loc2_.Text = SSensitiveWord.Filter(_loc2_.Text);
         }
      }
      
      protected function FormatContent(param1:THyperStringElement, param2:uint) : void
      {
         var _loc3_:THyperStringElementTextual = null;
         if(param1 is THyperStringElementText)
         {
            _loc3_ = param1 as THyperStringElementText;
            if(_loc3_.Color == 4278190080 || _loc3_.Color == 0)
            {
               _loc3_.ColorOverride(param2);
            }
            else
            {
               _loc3_.ColorOverride(_loc3_.Color);
            }
         }
      }
      
      protected function FormatText(param1:String, param2:uint) : THyperStringElementText
      {
         var _loc3_:THyperStringElementText = null;
         _loc3_ = this.FPoolHyperString.AcquireElementText();
         _loc3_.Text = param1;
         _loc3_.ColorOverride(param2);
         return _loc3_;
      }
      
      public function get Articles() : TBins
      {
         return this.FArticles;
      }
      
      public function set Articles(param1:TBins) : void
      {
         this.FArticles = param1;
      }
      
      public function GetChannelsColor(param1:int) : uint
      {
         return this.FChannelsColor[param1];
      }
      
      public function SetChannelsColor(param1:uint, param2:uint) : void
      {
         this.FChannelsColor[param1] = param2;
      }
      
      public function GetChannelsName(param1:int) : String
      {
         return this.FChannelsName[param1];
      }
      
      public function SetChannelsName(param1:uint, param2:String) : void
      {
         this.FChannelsName[param1] = param2;
      }
      
      public function ImportAsUniversalChannel(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:Boolean = false) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         _loc9_ = this.FChannelsName[param3];
         _loc8_ = this.FChannelsColor[param3];
         this.ImportUniversalPrefix(param1,param2,param4,param5,param6,_loc9_,_loc8_,param7);
      }
      
      public function ImportAsWhisperChannel(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int, param8:Boolean = false) : void
      {
         var _loc9_:* = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:THyperStringElementText = null;
         var _loc13_:THyperStringElementText = null;
         var _loc14_:THyperStringElementText = null;
         var _loc15_:THyperStringElementLinkCharacter = null;
         var _loc16_:THyperStringElementIcon = null;
         _loc11_ = this.FChannelsName[param3];
         _loc10_ = this.FChannelsColor[param3];
         this.ImportUniversalContent(param1,param2,_loc10_);
         _loc9_ = 0;
         _loc12_ = this.FormatChannelName(_loc11_,_loc10_);
         param2.Insert(_loc9_++,_loc12_);
         if(param7 == WHISPER_Receive)
         {
            _loc13_ = this.FormatText(this.FStringYou,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
            _loc13_ = this.FormatText(this.FStringFilled,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
            _loc15_ = this.FormatPlayerName(param4,param5,param6,_loc10_);
            param2.Insert(_loc9_++,_loc15_);
            _loc13_ = this.FormatText(this.FStringSpeak,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
         }
         if(param7 == WHISPER_Echoplex)
         {
            if(param8)
            {
               _loc16_ = this.FUnstreamizerHyperString.GetIconElementByID(RTTI_HYPERSTRING.ELEMENTCLASS_Icon) as THyperStringElementIcon;
               _loc16_.IDIcon = CONST_CHAT.SPECIEL_BleachAgent;
               param2.Insert(_loc9_++,_loc16_);
            }
            _loc15_ = this.FormatPlayerName(param4,param5,param6,_loc10_);
            param2.Insert(_loc9_++,_loc15_);
            _loc14_ = this.FormatText(this.FStringModifiers,_loc10_);
            param2.Insert(_loc9_++,_loc14_);
            _loc13_ = this.FormatText(this.FStringFilled,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
            _loc13_ = this.FormatText(this.FStringYou,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
            _loc13_ = this.FormatText(this.FStringSpeak,_loc10_);
            param2.Insert(_loc9_++,_loc13_);
         }
      }
      
      public function ImportAsSystemChannel(param1:ByteArray, param2:THyperString, param3:uint) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:THyperStringElementText = null;
         var _loc9_:THyperStringElement = null;
         _loc7_ = this.FChannelsName[param3];
         _loc6_ = this.FChannelsColor[param3];
         if(param1 != null)
         {
            this.FUnstreamizerHyperString.Unstreamize(param1,param2,null);
         }
         _loc5_ = param2.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = param2.GetElementByIndex(_loc4_);
            this.FormatContent(_loc9_,_loc6_);
            _loc4_++;
         }
         _loc4_ = 0;
         _loc8_ = this.FormatChannelName(_loc7_,_loc6_);
         param2.Insert(_loc4_++,_loc8_);
      }
   }
}

