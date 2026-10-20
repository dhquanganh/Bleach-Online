package Resources.Constants
{
   public class CONST_INVENTORY
   {
      
      public static const CATEGORY_Normal:uint = 1;
      
      public static const CATEGORY_Equipment:uint = 2;
      
      public static const CATEGORY_Gem:uint = 3;
      
      public static const CATEGORY_Treasure:uint = 4;
      
      public static const CATEGORY_Material:uint = 5;
      
      public static const CATEGORY_Ornament:uint = 6;
      
      public static const CATEGORY_TitleCard:uint = 12;
      
      public static const CATEGORY_WakeEquip:uint = 13;
      
      public static const CATEGORY_CrashJade:uint = 20;
      
      public static const CATEGORY_Equipments:Vector.<uint> = Vector.<uint>([CATEGORY_Equipment,CATEGORY_Treasure,CATEGORY_Ornament]);
      
      public static const CATEGORY_Appliances:Vector.<uint> = Vector.<uint>([CATEGORY_Normal,CATEGORY_Gem,CATEGORY_Material]);
      
      public static const CATEGORY_CrashJades:Vector.<uint> = Vector.<uint>([CATEGORY_CrashJade]);
      
      public static const CATEGORY_WakeEquips:Vector.<uint> = Vector.<uint>([CATEGORY_WakeEquip]);
      
      public static const CATEGORYSECOND_Weapon:uint = 1;
      
      public static const CATEGORYSECOND_Headgear:uint = 2;
      
      public static const CATEGORYSECOND_Clothing:uint = 3;
      
      public static const CATEGORYSECOND_Cloak:uint = 4;
      
      public static const CATEGORYSECOND_Shoe:uint = 5;
      
      public static const CATEGORYSECOND_Sash:uint = 6;
      
      public static const INDEXEQUIPMENTMOUNTED:Vector.<uint> = Vector.<uint>([CATEGORYSECOND_Weapon,CATEGORYSECOND_Headgear,CATEGORYSECOND_Clothing,CATEGORYSECOND_Cloak,CATEGORYSECOND_Shoe,CATEGORYSECOND_Sash]);
      
      public static const CATEGORYSECOND_TreasurePower:uint = 7;
      
      public static const CATEGORYSECOND_TreasureIntelligence:uint = 8;
      
      public static const CATEGORYSECOND_TreasureAgile:uint = 9;
      
      public static const CATEGORYSECOND_TreasureLife:uint = 10;
      
      public static const INDEXTREASUREMOUNTED:Vector.<uint> = Vector.<uint>([CATEGORYSECOND_TreasurePower,CATEGORYSECOND_TreasureIntelligence,CATEGORYSECOND_TreasureAgile,CATEGORYSECOND_TreasureLife]);
      
      public static const CATEGORY_OrnamentNecklace:uint = 11;
      
      public static const CATEGORY_OrnamentTalisman:uint = 12;
      
      public static const CATEGORY_OrnamentRing:uint = 13;
      
      public static const CATEGORY_OrnamentEarrings:uint = 14;
      
      public static const CATEGORY_OrnamentGlove:uint = 15;
      
      public static const CATEGORY_OrnamentBangle:uint = 16;
      
      public static const CATEGORY_OrnamentBracelet:uint = 17;
      
      public static const CATEGORY_OrnamentAnklet:uint = 18;
      
      public static const INDEXORNAMENTMOUNTED:Vector.<uint> = Vector.<uint>([CATEGORY_OrnamentNecklace,CATEGORY_OrnamentTalisman,CATEGORY_OrnamentRing,CATEGORY_OrnamentEarrings,CATEGORY_OrnamentGlove,CATEGORY_OrnamentBangle,CATEGORY_OrnamentBracelet,CATEGORY_OrnamentAnklet]);
      
      public static const CATEGORYSECOND_MakeEquipMaterial:uint = 1;
      
      public static const CATEGORYSECOND_FlushSpriteWater:uint = 2;
      
      public static const CATEGORYSECOND_HeroTitle:uint = 22;
      
      public static const CATEGORYSECOND_BagExtend:uint = 70;
      
      public static const CATEGORYSECOND_PsychicReel:uint = 71;
      
      public static const CATEGORYSECOND_FiveGhostTreasure:uint = 72;
      
      public static const CATEGORYSECOND_TreasureUpgrade:uint = 73;
      
      public static const CATEGORYSECOND_TreasureTransform:uint = 74;
      
      public static const CATEGORYSECOND_RefiningSoul:uint = 75;
      
      public static const CATEGORYSECOND_KnifeBook:uint = 77;
      
      public static const CATEGORYSECOND_MagicStone:uint = 78;
      
      public static const CATEGORYSECOND_SilverCard:uint = 80;
      
      public static const CATEGORYSECOND_ExperienceReel:uint = 90;
      
      public static const CATEGORYSECOND_GemTreasure:uint = 95;
      
      public static const CATEGORYSECOND_CommenMaterial:uint = 96;
      
      public static const CATEGORYSECOND_SpecialMaterial:uint = 97;
      
      public static const CATEGORYSECOND_LevelPacks:uint = 98;
      
      public static const CATEGORYSECOND_ChangeName:uint = 99;
      
      public static const CATEGORYSECOND_ChangeCountry:uint = 100;
      
      public static const CATEGORYSECOND_ProfessionRefine:uint = 101;
      
      public static const CATEGORYSECOND_ActivityChargeCard:uint = 1000;
      
      public static const CATEGORYSECOND_Hero:uint = 300;
      
      public static const CATEGORY_EQUIPMENT_Base:uint = CATEGORYSECOND_Weapon;
      
      public static const CATEGORY_EQUIPMENT_End:uint = CATEGORYSECOND_Sash;
      
      public static const CATEGORY_EQUIPMENT_TREASURE_Base:uint = CATEGORYSECOND_TreasurePower;
      
      public static const CATEGORY_EQUIPMENT_TREASURE_End:uint = CATEGORYSECOND_TreasureLife;
      
      public static const TIMINGCATEGORY_Permant:uint = 0;
      
      public static const TIMINGCATEGORY_Pick:uint = 1;
      
      public static const TIMINGCATEGORY_Equip:uint = 2;
      
      public static const TIMINGSTATE_Unstarted:uint = 1;
      
      public static const TIMINGSTATE_Started:uint = 2;
      
      public static const TIMINGSTATE_Expired:uint = 3;
      
      public static const TIMINGSTATE_Permant:uint = 4;
      
      public static const UPGRADINGCATEGORY_Enchant:uint = 1;
      
      public static const UPGRADINGCATEGORY_Compound:uint = 2;
      
      public static const UPGRADINGCATEGORY_None:uint = 3;
      
      public static const REQUIREMENTCAREER_None:uint = CONST_CHARACTER.PROFESSION_None;
      
      public static const REQUIREMENTCAREER_Agility:uint = CONST_CHARACTER.PROFESSION_Agility;
      
      public static const REQUIREMENTCAREER_Defending:uint = CONST_CHARACTER.PROFESSION_Defending;
      
      public static const REQUIREMENTCAREER_Intellect:uint = CONST_CHARACTER.PROFESSION_Intellect;
      
      public static const REQUIREMENTCAREER_Strength:uint = CONST_CHARACTER.PROFESSION_Strength;
      
      public static const REQUIREMENTCAREER_Warlock:uint = CONST_CHARACTER.PROFESSION_Warlock;
      
      public static const QUALITYCOLOR_INVENTORY_None:uint = 4294967295;
      
      public static const QUALITYCOLOR_INVENTORY_White:uint = 4294967295;
      
      public static const QUALITYCOLOR_INVENTORY_Green:uint = 4278255360;
      
      public static const QUALITYCOLOR_INVENTORY_Blue:uint = 4278239487;
      
      public static const QUALITYCOLOR_INVENTORY_Purple:uint = 4294902015;
      
      public static const QUALITYCOLOR_INVENTORY_Yellow:uint = 4294967040;
      
      public static const QUALITYCOLOR_INVENTORY_Red:uint = 4294901760;
      
      public static const QUALITYCOLOR_INVENTORY_Orange:uint = 4294931200;
      
      public static const QUALITYCOLOR_INVENTORY_INDEX:Vector.<uint> = Vector.<uint>([QUALITYCOLOR_INVENTORY_None,QUALITYCOLOR_INVENTORY_White,QUALITYCOLOR_INVENTORY_Green,QUALITYCOLOR_INVENTORY_Blue,QUALITYCOLOR_INVENTORY_Purple,QUALITYCOLOR_INVENTORY_Yellow,QUALITYCOLOR_INVENTORY_Red,QUALITYCOLOR_INVENTORY_Orange]);
      
      public function CONST_INVENTORY()
      {
         super();
      }
   }
}

