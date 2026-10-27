package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Resources.Constants.CONST_CHARACTER;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TEnemy extends TDatebaseVO
   {
      
      public static const PROFESSION_Agility:uint = CONST_CHARACTER.PROFESSION_Agility;
      
      public static const PROFESSION_Defending:uint = CONST_CHARACTER.PROFESSION_Defending;
      
      public static const PROFESSION_Intellect:uint = CONST_CHARACTER.PROFESSION_Intellect;
      
      public static const PROFESSION_Strength:uint = CONST_CHARACTER.PROFESSION_Strength;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected var FName:String;
      
      protected var FType:int;
      
      protected var FProfession:int;
      
      protected var FHeroIcon:int;
      
      protected var FQuality:int;
      
      protected var FLevel:int;
      
      protected var FSex:int;
      
      protected var FHp:int;
      
      protected var FSpeed:int;
      
      protected var FAnger:int;
      
      protected var FState:int;
      
      protected var FNormal:int;
      
      protected var FSkill:int;
      
      protected var FEffects:String;
      
      protected var FTalentId:int;
      
      protected var FSound:int;
      
      protected var FIsBoss:Boolean;
      
      protected var FAttacks:String;
      
      protected var FDefenses:String;
      
      protected var FRates:String;
      
      protected var FSkillDesc:Array;
      
      protected var FAttrPower:int;
      
      protected var FAttackEffect:int;
      
      public function TEnemy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIsBoss = param1.readInt() != 0;
         this.FType = param1.readUnsignedInt();
         this.FProfession = param1.readUnsignedInt();
         this.FHeroIcon = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FLevel = param1.readUnsignedInt();
         this.FSex = param1.readUnsignedInt();
         this.FHp = param1.readUnsignedInt();
         this.FSpeed = param1.readUnsignedInt();
         this.FAnger = param1.readUnsignedInt();
         this.FState = param1.readUnsignedInt();
         this.FAttacks = TUtilityString.FetchUTF(param1);
         this.FDefenses = TUtilityString.FetchUTF(param1);
         this.FRates = TUtilityString.FetchUTF(param1);
         this.FNormal = param1.readUnsignedInt();
         this.FSkill = param1.readUnsignedInt();
         this.FEffects = TUtilityString.FetchUTF(param1);
         this.FTalentId = param1.readUnsignedInt();
         this.FSound = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FSkillDesc = _loc2_ == "" ? null : Json.decode(_loc2_);
         this.FAttrPower = param1.readUnsignedInt();
         this.FAttackEffect = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Profession() : int
      {
         return this.FProfession;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get Sex() : int
      {
         return this.FSex;
      }
      
      public function get Hp() : int
      {
         return this.FHp;
      }
      
      public function get Speed() : int
      {
         return this.FSpeed;
      }
      
      public function get Anger() : int
      {
         return this.FAnger;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function get Normal() : int
      {
         return this.FNormal;
      }
      
      public function get Skill() : int
      {
         return this.FSkill;
      }
      
      public function get Effects() : String
      {
         return this.FEffects;
      }
      
      public function get TalentId() : int
      {
         return this.FTalentId;
      }
      
      public function get Sound() : uint
      {
         return this.FSound;
      }
      
      public function get IsBoss() : Boolean
      {
         return this.FIsBoss;
      }
      
      public function get HeroIcon() : int
      {
         return this.FHeroIcon;
      }
      
      public function get Attacks() : String
      {
         return this.FAttacks;
      }
      
      public function get Defenses() : String
      {
         return this.FDefenses;
      }
      
      public function get Rates() : String
      {
         return this.FRates;
      }
      
      public function get StandPositionWithProfession() : uint
      {
         var _loc1_:uint = 0;
         switch(this.FProfession)
         {
            case PROFESSION_Agility:
            case PROFESSION_Strength:
               _loc1_ = uint(INDEX_Station_Middle);
               break;
            case PROFESSION_Defending:
               _loc1_ = uint(INDEX_Station_Front);
               break;
            case PROFESSION_Intellect:
               _loc1_ = uint(INDEX_Station_After);
         }
         return _loc1_;
      }
      
      public function get BaseAttributePhysicalDefends() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         _loc1_ = Json.decode(this.FDefenses) as Object;
         return _loc1_.strength as Number;
      }
      
      public function get BaseAttributeMagicDefends() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         _loc1_ = Json.decode(this.FDefenses) as Object;
         return _loc1_.intellect as Number;
      }
      
      public function get BaseAttributePhysicalAttack() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         _loc1_ = Json.decode(this.FAttacks) as Object;
         return _loc1_.strength as Number;
      }
      
      public function get BaseAttributeMagicAttack() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         _loc1_ = Json.decode(this.FAttacks) as Object;
         return _loc1_.intellect as Number;
      }
      
      public function get SkillDesc() : Array
      {
         return this.FSkillDesc;
      }
      
      public function get AttrPower() : int
      {
         return this.FAttrPower;
      }
      
      public function get AttackEffect() : int
      {
         return this.FAttackEffect;
      }
      
      public function set Effects(param1:String) : void
      {
      }
   }
}

