package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import flash.utils.*;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBaseHero extends TDatebaseVO
   {
      
      protected var FIsMain:Boolean;
      
      protected var FDesc:String;
      
      protected var FName:String;
      
      protected var FSex:int;
      
      protected var FLevel:int;
      
      protected var FNeedLevel:int;
      
      protected var FProfession:int;
      
      protected var FSource:int;
      
      protected var FQuality:int;
      
      protected var FPower:int;
      
      protected var FAgile:int;
      
      protected var FIntelligence:int;
      
      protected var FLife:int;
      
      protected var FSpeed:int;
      
      protected var FPowerGrow:Number;
      
      protected var FAgileGrow:Number;
      
      protected var FIntelligenceGrow:Number;
      
      protected var FLifeGrow:Number;
      
      protected var FSpeedGrow:Number;
      
      protected var FNearAttack:int;
      
      protected var FNearDefense:int;
      
      protected var FFarAttack:int;
      
      protected var FFarDefense:int;
      
      protected var FStrategyAttack:int;
      
      protected var FStrategyDefense:int;
      
      protected var FHitRate:Number;
      
      protected var FDodgeRate:Number;
      
      protected var FCritRate:Number;
      
      protected var FBlockRate:Number;
      
      protected var FPunchRate:Number;
      
      protected var FHelpRate:Number;
      
      protected var FHurtRate:Number;
      
      protected var FAvoidHurtRate:Number;
      
      protected var FWreckRate:Number;
      
      protected var FAntiknockRate:Number;
      
      protected var FAttachRate:Number;
      
      protected var FDeFenceRate:Number;
      
      protected var FRecoverRate:Number;
      
      protected var FActive:int;
      
      protected var FNormalAttack:int;
      
      protected var FTalent:int;
      
      protected var FSound:uint;
      
      protected var FWeakness:int;
      
      protected var FHeadStyle:String;
      
      protected var FCountry:int;
      
      protected var FHeroSoul:String;
      
      protected var FAttackEffect:String;
      
      protected var FAssess:String;
      
      protected var FCrashJadeOpenLevel:Vector.<int>;
      
      public function TBaseHero()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FIsMain = param1.readInt() != 0;
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FName = TUtilityString.FetchUTF(param1);
         this.FAssess = TUtilityString.FetchUTF(param1);
         this.FSex = param1.readInt();
         this.FLevel = param1.readUnsignedInt();
         this.FNeedLevel = param1.readUnsignedInt();
         this.FProfession = param1.readUnsignedInt();
         this.FSource = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FPower = param1.readUnsignedInt();
         this.FAgile = param1.readUnsignedInt();
         this.FIntelligence = param1.readUnsignedInt();
         this.FLife = param1.readUnsignedInt();
         this.FSpeed = param1.readUnsignedInt();
         this.FPowerGrow = this.SetValueByFloat(param1.readFloat());
         this.FAgileGrow = this.SetValueByFloat(param1.readFloat());
         this.FIntelligenceGrow = this.SetValueByFloat(param1.readFloat());
         this.FLifeGrow = this.SetValueByFloat(param1.readFloat());
         this.FSpeedGrow = this.SetValueByFloat(param1.readFloat());
         this.FNearAttack = param1.readUnsignedInt();
         this.FNearDefense = param1.readUnsignedInt();
         this.FFarAttack = param1.readUnsignedInt();
         this.FFarDefense = param1.readUnsignedInt();
         this.FStrategyAttack = param1.readUnsignedInt();
         this.FStrategyDefense = param1.readUnsignedInt();
         this.FHitRate = this.SetValueByFloat(param1.readFloat());
         this.FDodgeRate = this.SetValueByFloat(param1.readFloat());
         this.FCritRate = this.SetValueByFloat(param1.readFloat());
         this.FBlockRate = this.SetValueByFloat(param1.readFloat());
         this.FPunchRate = this.SetValueByFloat(param1.readFloat());
         this.FHelpRate = this.SetValueByFloat(param1.readFloat());
         this.FHurtRate = this.SetValueByFloat(param1.readFloat());
         this.FAvoidHurtRate = this.SetValueByFloat(param1.readFloat());
         this.FWreckRate = this.SetValueByFloat(param1.readFloat());
         this.FAntiknockRate = this.SetValueByFloat(param1.readFloat());
         this.FAttachRate = this.SetValueByFloat(param1.readFloat());
         this.FDeFenceRate = this.SetValueByFloat(param1.readFloat());
         this.FRecoverRate = this.SetValueByFloat(param1.readFloat());
         this.FActive = param1.readUnsignedInt();
         this.FAttackEffect = TUtilityString.FetchUTF(param1);
         this.FNormalAttack = param1.readUnsignedInt();
         this.FTalent = param1.readUnsignedInt();
         this.FSound = param1.readUnsignedInt();
         this.FWeakness = param1.readUnsignedInt();
         this.FHeadStyle = TUtilityString.FetchUTF(param1);
         this.FCountry = param1.readUnsignedInt();
         this.FHeroSoul = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FCrashJadeOpenLevel = Vector.<int>(Json.decode(_loc2_));
      }
      
      protected function SetValueByFloat(param1:Number) : Number
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         _loc2_ = param1.toFixed(2);
         return parseFloat(_loc2_);
      }
      
      public function get IsMain() : Boolean
      {
         return this.FIsMain;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Sex() : int
      {
         return this.FSex;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get NeedLevel() : int
      {
         return this.FNeedLevel;
      }
      
      public function get Profession() : int
      {
         return this.FProfession;
      }
      
      public function get Source() : int
      {
         return this.FSource;
      }
      
      public function get Quality() : int
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return this.FQuality + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1];
         }
         return this.FQuality;
      }
      
      public function get Power() : int
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return this.FPower * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]);
         }
         return this.FPower;
      }
      
      public function get Agile() : int
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return this.FAgile * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]);
         }
         return this.FAgile;
      }
      
      public function get Intelligence() : int
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return this.FIntelligence * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]);
         }
         return this.FIntelligence;
      }
      
      public function get Life() : int
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return this.FLife * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]);
         }
         return this.FLife;
      }
      
      public function get Speed() : int
      {
         return this.FSpeed;
      }
      
      public function get PowerGrow() : Number
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return Math.round(this.FPowerGrow * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]) * 10) / 10;
         }
         return this.FPowerGrow;
      }
      
      public function get AgileGrow() : Number
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return Math.round(this.FAgileGrow * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]) * 10) / 10;
         }
         return this.FAgileGrow;
      }
      
      public function get IntelligenceGrow() : Number
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return Math.round(this.FIntelligenceGrow * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]) * 10) / 10;
         }
         return this.FIntelligenceGrow;
      }
      
      public function get LifeGrow() : Number
      {
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality != 0)
         {
            return Math.round(this.FLifeGrow * (1 + TUtilityLobby.GetConfigValue(60104008)[SLogicsCore.Character.Heros.GetHeroByIdentifier(Identifier).AddQuality - 1]) * 10) / 10;
         }
         return this.FLifeGrow;
      }
      
      public function get SpeedGrow() : Number
      {
         return this.FSpeedGrow;
      }
      
      public function get NearAttack() : int
      {
         return this.FNearAttack;
      }
      
      public function get NearDefense() : int
      {
         return this.FNearDefense;
      }
      
      public function get FarAttack() : int
      {
         return this.FFarAttack;
      }
      
      public function get FarDefense() : int
      {
         return this.FFarDefense;
      }
      
      public function get StrategyAttack() : int
      {
         return this.FStrategyAttack;
      }
      
      public function get StrategyDefense() : int
      {
         return this.FStrategyDefense;
      }
      
      public function get HitRate() : Number
      {
         return this.FHitRate;
      }
      
      public function get DodgeRate() : Number
      {
         return this.FDodgeRate;
      }
      
      public function get CritRate() : Number
      {
         return this.FCritRate;
      }
      
      public function get BlockRate() : Number
      {
         return this.FBlockRate;
      }
      
      public function get PunchRate() : Number
      {
         return this.FPunchRate;
      }
      
      public function get HelpRate() : Number
      {
         return this.FHelpRate;
      }
      
      public function get HurtRate() : Number
      {
         return this.FHurtRate;
      }
      
      public function get AvoidHurtRate() : Number
      {
         return this.FAvoidHurtRate;
      }
      
      public function get WreckRate() : Number
      {
         return this.FWreckRate;
      }
      
      public function get AntiknockRate() : Number
      {
         return this.FAntiknockRate;
      }
      
      public function get AttachRate() : Number
      {
         return this.FAttachRate;
      }
      
      public function get DeFenceRate() : Number
      {
         return this.FDeFenceRate;
      }
      
      public function get RecoverRate() : Number
      {
         return this.FRecoverRate;
      }
      
      public function get Active() : int
      {
         return this.FActive;
      }
      
      public function get NormalAttack() : int
      {
         return this.FNormalAttack;
      }
      
      public function get Talent() : int
      {
         return this.FTalent;
      }
      
      public function get Sound() : uint
      {
         return this.FSound;
      }
      
      public function get Weakness() : int
      {
         return this.FWeakness;
      }
      
      public function get HeadStyle() : String
      {
         return this.FHeadStyle;
      }
      
      public function get Country() : int
      {
         return this.FCountry;
      }
      
      public function get HeroSoul() : String
      {
         return this.FHeroSoul;
      }
      
      public function get AttackEffect() : String
      {
         return this.FAttackEffect;
      }
      
      public function get Assess() : String
      {
         return this.FAssess;
      }
      
      public function get CrashJadeOpenLevel() : Vector.<int>
      {
         return this.FCrashJadeOpenLevel;
      }
      
      public function set AttackEffect(param1:String) : void
      {
      }
   }
}

