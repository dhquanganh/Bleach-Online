package Processors.Game.Sound
{
   import Debugging.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Sound.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Signals.*;
   import Processors.*;
   import Resources.Constants.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorSounds extends TProcessor
   {
      
      protected static const KEY_UP:uint = CONST_KEYCODE.KEY_UP;
      
      protected static const KEY_DOWN:uint = CONST_KEYCODE.KEY_DOWN;
      
      protected static const FILE_MUSIC_RESOURCE_PATH:String = "Resources/Sound/";
      
      protected static const FILE_RESOURCE_SUFFIX:String = ".mp3";
      
      protected static const PLAY_SOUND_EFFECT:uint = CONST_MUSIC.PLAY_SOUND_EFFECT;
      
      protected static const PLAY_SCENE_MainCity:uint = CONST_MUSIC.PLAY_SCENE_MainCity;
      
      protected static const PLAY_SCENE_Nodal:uint = CONST_MUSIC.PLAY_SCENE_Nodal;
      
      protected static const PLAY_SCENE_Campaign:uint = CONST_MUSIC.PLAY_SCENE_Campaign;
      
      protected static const PLAY_SCENE_KillHeros:uint = CONST_MUSIC.PLAY_SCENE_KillHeros;
      
      protected static const PLAY_SCENE_Arena:uint = CONST_MUSIC.PLAY_SCENE_Arena;
      
      protected static const PLAY_SCENE_FightPet:uint = CONST_MUSIC.PLAY_SCENE_FightPet;
      
      protected static const PLAY_SCENE_OrganizationalWar:uint = CONST_MUSIC.PLAY_SCENE_OrganizationalWar;
      
      protected static const PLAY_SCENE_TraitorAttack:uint = CONST_MUSIC.PLAY_SCENE_TraitorAttack;
      
      protected static const PLAY_SCENE_TreasureMap:uint = CONST_MUSIC.PLAY_SCENE_TreasureMap;
      
      protected static const PLAY_SCENE_CityDefend:uint = CONST_MUSIC.PLAY_SCENE_CityDefend;
      
      protected static const PLAY_SCENE_Slave:uint = CONST_MUSIC.PLAY_SCENE_Slave;
      
      protected static const PLAY_SCENE_HomeMonster:uint = CONST_MUSIC.PLAY_SCENE_HomeMonster;
      
      protected static const PLAY_SCENE_SkyTower:uint = CONST_MUSIC.PLAY_SCENE_SkyTower;
      
      protected static const PLAY_SCENE_GongFuFight:uint = CONST_MUSIC.PLAY_SCENE_GongFuFight;
      
      protected static const PLAY_SCENE_HeroChange:uint = CONST_MUSIC.PLAY_SCENE_HeroChange;
      
      protected static const PLAY_SCENE_MonsterMap:uint = CONST_MUSIC.PLAY_SCENE_MonsterMap;
      
      protected var FCharacter:TCharacter;
      
      protected var FMusicConfigs:TBins;
      
      protected var FSoundConfigs:TBins;
      
      protected var FMusicID:int;
      
      protected var FSoundType:int;
      
      protected var FSoundID:uint;
      
      protected var FCdnRoot:String;
      
      protected var FRoleSencePosition:int;
      
      protected var FIsFighting:Boolean;
      
      protected var FResourceConfig:Dictionary;
      
      protected var FProcessorPlay:Function;
      
      public function TProcessorSounds(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FResourceConfig = SParametersCore.ResourceConfig;
         this.FRoleSencePosition = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMusicConfigs = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_MusicConfig);
         this.FSoundConfigs = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoundConfig);
         this.FCdnRoot = SParametersCore.CdnRoot;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Signals();
         this.LogicsPerform_PlaySound();
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:Boolean = false;
         _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_SOUND);
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = _loc1_.UserData as Boolean;
         this.FSoundType = _loc1_.Identifier;
         switch(this.FSoundType)
         {
            case PLAY_SOUND_EFFECT:
               this.FSoundID = _loc1_.Value;
               this.FProcessorPlay = this.ProcessorPlaySound;
               break;
            case PLAY_SCENE_KillHeros:
               this.FSoundID = uint(_loc1_.Value / 100) * 100;
               this.FProcessorPlay = this.ProcessorPlayMusic;
               break;
            case PLAY_SCENE_Nodal:
               this.FSoundID = this.GetMusicIDBySceneID(_loc1_.Value);
               this.FProcessorPlay = this.ProcessorPlayMusic;
               break;
            case PLAY_SCENE_MonsterMap:
            case PLAY_SCENE_Campaign:
            case PLAY_SCENE_MainCity:
            case PLAY_SCENE_Arena:
            case PLAY_SCENE_FightPet:
            case PLAY_SCENE_OrganizationalWar:
            case PLAY_SCENE_TraitorAttack:
            case PLAY_SCENE_TreasureMap:
            case PLAY_SCENE_CityDefend:
            case PLAY_SCENE_Slave:
            case PLAY_SCENE_HomeMonster:
            case PLAY_SCENE_SkyTower:
            case PLAY_SCENE_GongFuFight:
            case PLAY_SCENE_HeroChange:
               this.FSoundID = _loc1_.Value;
               this.FIsFighting = _loc2_;
               this.FProcessorPlay = this.ProcessorPlayMusic;
         }
      }
      
      protected function GetMusicIDBySceneID(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TCity = null;
         var _loc6_:TBins = null;
         _loc4_ = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc6_.GetDatebaseByIndex(_loc2_) as TCity;
            if(param1 >= _loc5_.Start && param1 <= _loc5_.Last)
            {
               _loc4_ = uint(_loc5_.Identifier);
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function LogicsPerform_PlaySound() : void
      {
         if(this.FSoundID != 0 && !SResourcesCore.Loading)
         {
            if(this.FProcessorPlay != null)
            {
               this.FProcessorPlay(this.FSoundID);
               this.FSoundID = 0;
               this.FProcessorPlay = null;
            }
         }
      }
      
      protected function ProcessorPlayMusic(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TMusicConfig = null;
         var _loc5_:String = null;
         _loc4_ = this.FMusicConfigs.GetDatebaseByIdentifier(param1) as TMusicConfig;
         if(_loc4_ == null)
         {
            return;
         }
         if(this.FIsFighting)
         {
            _loc2_ = _loc4_.Fighting;
         }
         else
         {
            _loc2_ = _loc4_.Background;
         }
         if(this.FMusicID == _loc2_)
         {
            return;
         }
         this.FMusicID = _loc2_;
         _loc3_ = FILE_MUSIC_RESOURCE_PATH + this.FMusicID.toString() + FILE_RESOURCE_SUFFIX;
         if(this.FResourceConfig)
         {
            _loc5_ = this.FResourceConfig[_loc3_];
         }
         if(_loc5_ == null)
         {
            if(SParametersCore.ClientVersion == 0)
            {
               _loc5_ = "";
            }
            else
            {
               _loc5_ = SParametersCore.ClientVersion.toString();
            }
         }
         if(_loc5_.length > 0)
         {
            _loc3_ = _loc5_ + "/" + _loc3_;
         }
         _loc3_ = this.FCdnRoot + _loc3_;
         SMusicPlayer.PlayBgSound(_loc3_);
      }
      
      protected function ProcessorPlaySound(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TSoundConfig = null;
         var _loc5_:String = null;
         _loc4_ = this.FSoundConfigs.GetDatebaseByIdentifier(param1) as TSoundConfig;
         if(_loc4_ == null)
         {
            return;
         }
         _loc2_ = _loc4_.SoundID;
         if(_loc2_ == 0)
         {
            return;
         }
         _loc3_ = FILE_MUSIC_RESOURCE_PATH + _loc2_.toString() + FILE_RESOURCE_SUFFIX;
         if(this.FResourceConfig)
         {
            _loc5_ = this.FResourceConfig[_loc3_];
         }
         if(_loc5_ == null)
         {
            if(SParametersCore.ClientVersion == 0)
            {
               _loc5_ = "";
            }
            else
            {
               _loc5_ = SParametersCore.ClientVersion.toString();
            }
         }
         if(_loc5_.length > 0)
         {
            _loc3_ = _loc5_ + "/" + _loc3_;
         }
         _loc3_ = this.FCdnRoot + _loc3_;
         SSoundPlayer.PlaySound(_loc3_);
      }
   }
}

