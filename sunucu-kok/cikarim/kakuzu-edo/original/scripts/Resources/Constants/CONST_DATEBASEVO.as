package Resources.Constants
{
   import Logics.CustomHero.TCustomHeroExp;
   import Logics.CustomHero.TCustomHeroInfo;
   import Logics.DatebaseVO.VO.*;
   import Logics.EquipForge.TConfigEquipAdvance;
   import Logics.EquipForge.TConfigEquipForge;
   import Logics.SoulCollection.TSoulCollectionBase;
   import Logics.SoulCollection.TSoulCollectionRnd;
   import Logics.SoulCollection.TSoulCollectionShop;
   
   public class CONST_DATEBASEVO
   {
      
      public static const RESOURCE_PACKAGEID:uint = 251658240;
      
      public static const RESOURCE_PACKAGEID_Activity:uint = 251658241;
      
      public static const RESOURCEID_Base:uint = 16777216;
      
      public static const RESOURCEID_HDActivity:uint = RESOURCEID_Base + 1;
      
      public static const RESOURCEID_Article:uint = RESOURCEID_Base + 2;
      
      public static const RESOURCEID_Award:uint = RESOURCEID_Base + 3;
      
      public static const RESOURCEID_BaseEquip:uint = RESOURCEID_Base + 4;
      
      public static const RESOURCEID_BaseHero:uint = RESOURCEID_Base + 5;
      
      public static const RESOURCEID_KnifeSoul:uint = RESOURCEID_Base + 6;
      
      public static const RESOURCEID_BaseStone:uint = RESOURCEID_Base + 7;
      
      public static const RESOURCEID_BlockPoint:uint = RESOURCEID_Base + 8;
      
      public static const RESOURCEID_BuffEffect:uint = RESOURCEID_Base + 9;
      
      public static const RESOURCEID_BuildConsume:uint = RESOURCEID_Base + 10;
      
      public static const RESOURCEID_BuildValue:uint = RESOURCEID_Base + 11;
      
      public static const RESOURCEID_BuyMoney:uint = RESOURCEID_Base + 12;
      
      public static const RESOURCEID_ChannelChet:uint = RESOURCEID_Base + 14;
      
      public static const RESOURCEID_City:uint = RESOURCEID_Base + 15;
      
      public static const RESOURCEID_ConfigValue:uint = RESOURCEID_Base + 16;
      
      public static const RESOURCEID_DailyActivity:uint = RESOURCEID_Base + 17;
      
      public static const RESOURCEID_DailyAward:uint = RESOURCEID_Base + 18;
      
      public static const RESOURCEID_DailyTask:uint = RESOURCEID_Base + 19;
      
      public static const RESOURCEID_DialogueScript:uint = RESOURCEID_Base + 20;
      
      public static const RESOURCEID_Digging:uint = RESOURCEID_Base + 21;
      
      public static const RESOURCEID_Enemy:uint = RESOURCEID_Base + 22;
      
      public static const RESOURCEID_EnemyArmy:uint = RESOURCEID_Base + 23;
      
      public static const RESOURCEID_EquipAdditional:uint = RESOURCEID_Base + 24;
      
      public static const RESOURCEID_EquipGenerate:uint = RESOURCEID_Base + 25;
      
      public static const RESOURCEID_EquipUpgrade:uint = RESOURCEID_Base + 26;
      
      public static const RESOURCEID_ErrorCode:uint = RESOURCEID_Base + 27;
      
      public static const RESOURCEID_Exchange_ExpCard:uint = RESOURCEID_Base + 28;
      
      public static const RESOURCEID_HeroExp:uint = RESOURCEID_Base + 29;
      
      public static const RESOURCEID_HeroReplacement:uint = RESOURCEID_Base + 30;
      
      public static const RESOURCEID_HeroTalent:uint = RESOURCEID_Base + 31;
      
      public static const RESOURCEID_Mall:uint = RESOURCEID_Base + 32;
      
      public static const RESOURCEID_Map:uint = RESOURCEID_Base + 33;
      
      public static const RESOURCEID_Maskword:uint = RESOURCEID_Base + 34;
      
      public static const RESOURCEID_Military:uint = RESOURCEID_Base + 35;
      
      public static const RESOURCEID_MusicConfig:uint = RESOURCEID_Base + 36;
      
      public static const RESOURCEID_FunctionSwitch:uint = RESOURCEID_Base + 37;
      
      public static const RESOURCEID_TemplePliesNumber:uint = RESOURCEID_Base + 38;
      
      public static const RESOURCEID_FreshGuide:uint = RESOURCEID_Base + 39;
      
      public static const RESOURCEID_NPC:uint = RESOURCEID_Base + 40;
      
      public static const RESOURCEID_OrganizationAddition:uint = RESOURCEID_Base + 41;
      
      public static const RESOURCEID_OrganizationBase:uint = RESOURCEID_Base + 42;
      
      public static const RESOURCEID_OrganizationDevotion:uint = RESOURCEID_Base + 43;
      
      public static const RESOURCEID_PopTips:uint = RESOURCEID_Base + 47;
      
      public static const RESOURCEID_Post:uint = RESOURCEID_Base + 48;
      
      public static const RESOURCEID_RaidersDailyConfig:uint = RESOURCEID_Base + 49;
      
      public static const RESOURCEID_RandomName:uint = RESOURCEID_Base + 50;
      
      public static const RESOURCEID_RankComposeQuality:uint = RESOURCEID_Base + 51;
      
      public static const RESOURCEID_RankExpendCost:uint = RESOURCEID_Base + 52;
      
      public static const RESOURCEID_RankMoney:uint = RESOURCEID_Base + 53;
      
      public static const RESOURCEID_RankReward:uint = RESOURCEID_Base + 54;
      
      public static const RESOURCEID_RecommendStone:uint = RESOURCEID_Base + 55;
      
      public static const RESOURCEID_RoleModel:uint = RESOURCEID_Base + 56;
      
      public static const RESOURCEID_ServenStar:uint = RESOURCEID_Base + 57;
      
      public static const RESOURCEID_ServenStarExp:uint = RESOURCEID_Base + 58;
      
      public static const RESOURCEID_SignReward:uint = RESOURCEID_Base + 59;
      
      public static const RESOURCEID_Single:uint = RESOURCEID_Base + 60;
      
      public static const RESOURCEID_SinglePointPath:uint = RESOURCEID_Base + 61;
      
      public static const RESOURCEID_SingleResetCharge:uint = RESOURCEID_Base + 62;
      
      public static const RESOURCEID_SkillConfig:uint = RESOURCEID_Base + 63;
      
      public static const RESOURCEID_StarMap:uint = RESOURCEID_Base + 64;
      
      public static const RESOURCEID_StarPoint:uint = RESOURCEID_Base + 65;
      
      public static const RESOURCEID_StarPointDesc:uint = RESOURCEID_Base + 66;
      
      public static const RESOURCEID_Suit:uint = RESOURCEID_Base + 67;
      
      public static const RESOURCEID_SystemLanguage:uint = RESOURCEID_Base + 68;
      
      public static const RESOURCEID_Task:uint = RESOURCEID_Base + 69;
      
      public static const RESOURCEID_TaskDramaDialogue:uint = RESOURCEID_Base + 70;
      
      public static const RESOURCEID_Tavern_Grade:uint = RESOURCEID_Base + 71;
      
      public static const RESOURCEID_Tavern_PayConfig:uint = RESOURCEID_Base + 72;
      
      public static const RESOURCEID_Tavern_Warrior:uint = RESOURCEID_Base + 73;
      
      public static const RESOURCEID_TreasureLevelup:uint = RESOURCEID_Base + 74;
      
      public static const RESOURCEID_TreasureUpgrade:uint = RESOURCEID_Base + 75;
      
      public static const RESOURCEID_VipConfig:uint = RESOURCEID_Base + 76;
      
      public static const RESOURCEID_SoulSkill:uint = RESOURCEID_Base + 77;
      
      public static const RESOURCEID_MagicStone:uint = RESOURCEID_Base + 78;
      
      public static const RESOURCEID_WeaponSkillConfig:uint = RESOURCEID_Base + 79;
      
      public static const RESOURCEID_Knife:uint = RESOURCEID_Base + 80;
      
      public static const RESOURCEID_KnifeExpand:uint = RESOURCEID_Base + 81;
      
      public static const RESOURCEID_RecommendHero:uint = RESOURCEID_Base + 82;
      
      public static const RESOURCEID_SlaveGainExp:uint = RESOURCEID_Base + 83;
      
      public static const RESOURCEID_SlaveMessage:uint = RESOURCEID_Base + 84;
      
      public static const RESOURCEID_SlaveBleed:uint = RESOURCEID_Base + 85;
      
      public static const RESOURCEID_HomeLevel:uint = RESOURCEID_Base + 86;
      
      public static const RESOURCEID_Butterfly:uint = RESOURCEID_Base + 87;
      
      public static const RESOURCEID_ButterflyFeeding:uint = RESOURCEID_Base + 88;
      
      public static const RESOURCEID_HomeGirlFriend:uint = RESOURCEID_Base + 89;
      
      public static const RESOURCEID_HomeGirlAward:uint = RESOURCEID_Base + 90;
      
      public static const RESOURCEID_HomeGirlInteract:uint = RESOURCEID_Base + 91;
      
      public static const RESOURCEID_HomeGamble:uint = RESOURCEID_Base + 92;
      
      public static const RESOURCEID_HomeGambleCost:uint = RESOURCEID_Base + 93;
      
      public static const RESOURCEID_HomeGambleBox:uint = RESOURCEID_Base + 94;
      
      public static const RESOURCEID_HomeSoulAward:uint = RESOURCEID_Base + 96;
      
      public static const RESOURCEID_HomeFortune:uint = RESOURCEID_Base + 97;
      
      public static const RESOURCEID_HomeGirlMood:uint = RESOURCEID_Base + 98;
      
      public static const RESOURCEID_AutoActivityGain:uint = RESOURCEID_Base + 99;
      
      public static const RESOURCEID_SevenHeroLittleStar:uint = RESOURCEID_Base + 100;
      
      public static const RESOURCEID_SevenHeroStar:uint = RESOURCEID_Base + 101;
      
      public static const RESOURCEID_SevenHeroArmy:uint = RESOURCEID_Base + 102;
      
      public static const RESOURCEID_SevenHeroDailyAward:uint = RESOURCEID_Base + 103;
      
      public static const RESOURCEID_SevenHeroSoul:uint = RESOURCEID_Base + 104;
      
      public static const RESOURCEID_HDIcon:uint = RESOURCEID_Base + 105;
      
      public static const RESOURCEID_HDArenaRank:uint = RESOURCEID_Base + 106;
      
      public static const RESOURCEID_HDCampBattle:uint = RESOURCEID_Base + 107;
      
      public static const RESOURCEID_HDKillHero:uint = RESOURCEID_Base + 108;
      
      public static const RESOURCEID_HDLevelRank:uint = RESOURCEID_Base + 109;
      
      public static const RESOURCEID_HDPowerRank:uint = RESOURCEID_Base + 110;
      
      public static const RESOURCEID_HDRecruitPartner:uint = RESOURCEID_Base + 111;
      
      public static const RESOURCEID_HDGBOnline:uint = RESOURCEID_Base + 112;
      
      public static const RESOURCEID_HDGBGold:uint = RESOURCEID_Base + 113;
      
      public static const RESOURCEID_HDGBSevenDay:uint = RESOURCEID_Base + 114;
      
      public static const RESOURCEID_HDGBOpenSever:uint = RESOURCEID_Base + 115;
      
      public static const RESOURCEID_HDGBCollectgame:uint = RESOURCEID_Base + 116;
      
      public static const RESOURCEID_HDSinglePay:uint = RESOURCEID_Base + 117;
      
      public static const RESOURCEID_HDTotalPay:uint = RESOURCEID_Base + 118;
      
      public static const RESOURCEID_HDDailyPay:uint = RESOURCEID_Base + 119;
      
      public static const RESOURCEID_HDTotalCost:uint = RESOURCEID_Base + 120;
      
      public static const RESOURCEID_HDDailyCost:uint = RESOURCEID_Base + 121;
      
      public static const RESOURCEID_HDVipBox:uint = RESOURCEID_Base + 122;
      
      public static const RESOURCEID_HDFirstPay:uint = RESOURCEID_Base + 123;
      
      public static const RESOURCEID_HDYDDailyGiftBag:uint = RESOURCEID_Base + 124;
      
      public static const RESOURCEID_HDYDGrowGiftBag:uint = RESOURCEID_Base + 125;
      
      public static const RESOURCEID_HDYDLevelGiftBag:uint = RESOURCEID_Base + 126;
      
      public static const RESOURCEID_HDYDFreshGiftBag:uint = RESOURCEID_Base + 127;
      
      public static const RESOURCEID_HDYDBuyGold:uint = RESOURCEID_Base + 128;
      
      public static const RESOURCEID_HDDailyTotalPay:uint = RESOURCEID_Base + 129;
      
      public static const RESOURCEID_HDDailyTotalCost:uint = RESOURCEID_Base + 130;
      
      public static const RESOURCEID_SoundConfig:uint = RESOURCEID_Base + 131;
      
      public static const RESOURCEID_HDEquipCollection:uint = RESOURCEID_Base + 132;
      
      public static const RESOURCEID_HDMilitary:uint = RESOURCEID_Base + 133;
      
      public static const RESOURCEID_HDStone:uint = RESOURCEID_Base + 134;
      
      public static const RESOURCEID_HDTreasure:uint = RESOURCEID_Base + 135;
      
      public static const RESOURCEID_HDGrowFundLv:uint = RESOURCEID_Base + 136;
      
      public static const RESOURCEID_HDGrowFundGamble:uint = RESOURCEID_Base + 137;
      
      public static const RESOURCEID_HDGrowFundShop:uint = RESOURCEID_Base + 138;
      
      public static const RESOURCEID_Achievement:uint = RESOURCEID_Base + 139;
      
      public static const RESOURCEID_AchievementGroup:uint = RESOURCEID_Base + 140;
      
      public static const RESOURCEID_AchievementClass:uint = RESOURCEID_Base + 141;
      
      public static const RESOURCEID_AchievementTitle:uint = RESOURCEID_Base + 142;
      
      public static const RESOURCEID_HDSuperTreasure:uint = RESOURCEID_Base + 143;
      
      public static const RESOURCEID_HDChristmas:uint = RESOURCEID_Base + 144;
      
      public static const RESOURCEID_HDCityDefence:uint = RESOURCEID_Base + 145;
      
      public static const RESOURCEID_HDGroupLv:uint = RESOURCEID_Base + 146;
      
      public static const RESOURCEID_HDGroupWar:uint = RESOURCEID_Base + 147;
      
      public static const RESOURCEID_HDPetSoulDefence:uint = RESOURCEID_Base + 148;
      
      public static const RESOURCEID_HDPay:uint = RESOURCEID_Base + 149;
      
      public static const RESOURCEID_LeagueMapPve:uint = RESOURCEID_Base + 150;
      
      public static const RESOURCEID_LeagueMapPvp:uint = RESOURCEID_Base + 151;
      
      public static const RESOURCEID_NewYear:uint = RESOURCEID_Base + 152;
      
      public static const RESOURCEID_Espada:uint = RESOURCEID_Base + 153;
      
      public static const RESOURCEID_OrnamentValue:uint = RESOURCEID_Base + 154;
      
      public static const RESOURCEID_OrnamentUpgrade:uint = RESOURCEID_Base + 155;
      
      public static const RESOURCEID_LeaguePointPath:uint = RESOURCEID_Base + 156;
      
      public static const RESOURCEID_LeagueAction:uint = RESOURCEID_Base + 157;
      
      public static const RESOURCEID_HDExchangeChip:uint = RESOURCEID_Base + 158;
      
      public static const RESOURCEID_Beauty:uint = RESOURCEID_Base + 159;
      
      public static const RESOURCEID_BeautifulClothes:uint = RESOURCEID_Base + 160;
      
      public static const RESOURCEID_HDSinglePayTime:uint = RESOURCEID_Base + 161;
      
      public static const RESOURCEID_HDChineseYearSignIn:uint = RESOURCEID_Base + 162;
      
      public static const RESOURCEID_HDDoubleFish:uint = RESOURCEID_Base + 163;
      
      public static const RESOURCEID_HDChineseYearLukia:uint = RESOURCEID_Base + 164;
      
      public static const RESOURCEID_GirlsRecommend:uint = RESOURCEID_Base + 165;
      
      public static const RESOURCEID_GirlQuestion:uint = RESOURCEID_Base + 166;
      
      public static const RESOURCEID_GirlStrategy:uint = RESOURCEID_Base + 167;
      
      public static const RESOURCEID_HDMoneyPenny:uint = RESOURCEID_Base + 168;
      
      public static const RESOURCEID_GrowRoadDayTask:uint = RESOURCEID_Base + 169;
      
      public static const RESOURCEID_GrowRoadTask:uint = RESOURCEID_Base + 170;
      
      public static const RESOURCEID_GrowRoadGift:uint = RESOURCEID_Base + 171;
      
      public static const RESOURCEID_HDGambling:uint = RESOURCEID_Base + 172;
      
      public static const RESOURCEID_HDLimitBuy:uint = RESOURCEID_Base + 173;
      
      public static const RESOURCEID_HDIceHeros:uint = RESOURCEID_Base + 174;
      
      public static const RESOURCEID_TemplePoint:uint = RESOURCEID_Base + 175;
      
      public static const RESOURCEID_TemplePVP:uint = RESOURCEID_Base + 176;
      
      public static const RESOURCEID_TempleValue:uint = RESOURCEID_Base + 177;
      
      public static const RESOURCEID_GSPVP_DailyAward:uint = RESOURCEID_Base + 178;
      
      public static const RESOURCEID_GSPVP_Reward:uint = RESOURCEID_Base + 179;
      
      public static const RESOURCEID_TeamMemberExpand:uint = RESOURCEID_Base + 180;
      
      public static const RESOURCEID_HDTeamBuy:uint = RESOURCEID_Base + 181;
      
      public static const RESOURCEID_HDJigsaw:uint = RESOURCEID_Base + 182;
      
      public static const RESOURCEID_HDLevelGiftBag:uint = RESOURCEID_Base + 183;
      
      public static const RESOURCEID_HDBigTurnTable:uint = RESOURCEID_Base + 184;
      
      public static const RESOURCEID_HDOrder:uint = RESOURCEID_Base + 185;
      
      public static const RESOURCEID_DrillHoleCost:uint = RESOURCEID_Base + 186;
      
      public static const RESOURCEID_HDServerPay:uint = RESOURCEID_Base + 188;
      
      public static const RESOURCEID_CrashJade:uint = RESOURCEID_Base + 189;
      
      public static const RESOURCEID_DailyGetBackReward:uint = RESOURCEID_Base + 190;
      
      public static const RESOURCEID_DailyWelfareReward:uint = RESOURCEID_Base + 191;
      
      public static const RESOURCEID_DailyCrashJadeKind:uint = RESOURCEID_Base + 192;
      
      public static const RESOURCEID_HDRandCard:uint = RESOURCEID_Base + 193;
      
      public static const RESOURCEID_SpiritSchool:uint = RESOURCEID_Base + 194;
      
      public static const RESOURCEID_SpiritSchoolExp:uint = RESOURCEID_Base + 195;
      
      public static const RESOURCEID_HDTreasureShop:uint = RESOURCEID_Base + 196;
      
      public static const RESOURCEID_BleachJigsaw:uint = RESOURCEID_Base + 197;
      
      public static const RESOURCEID_HDChess:uint = RESOURCEID_Base + 198;
      
      public static const RESOURCEID_HDWorldCup:uint = RESOURCEID_Base + 199;
      
      public static const RESOURCEID_HDHerosMarket:uint = RESOURCEID_Base + 200;
      
      public static const RESOURCEID_PartnerChange:uint = RESOURCEID_Base + 201;
      
      public static const RESOURCEID_ChangeHeroPoint:uint = RESOURCEID_Base + 202;
      
      public static const RESOURCEID_BlackMarket:uint = RESOURCEID_Base + 203;
      
      public static const RESOURCEID_HeroChangeAttr:uint = RESOURCEID_Base + 204;
      
      public static const RESOURCEID_Lottery:uint = RESOURCEID_Base + 205;
      
      public static const RESOURCEID_MainPetRankUp:uint = RESOURCEID_Base + 206;
      
      public static const RESOURCEID_PetFamilyBag:uint = RESOURCEID_Base + 207;
      
      public static const RESOURCEID_PetLevelUp:uint = RESOURCEID_Base + 208;
      
      public static const RESOURCEID_VicePetMake:uint = RESOURCEID_Base + 209;
      
      public static const RESOURCEID_VicePetRankUp:uint = RESOURCEID_Base + 210;
      
      public static const RESOURCEID_VicePetTrain:uint = RESOURCEID_Base + 211;
      
      public static const RESOURCEID_JoyfunPay:uint = RESOURCEID_Base + 212;
      
      public static const RESOURCEID_Partner:uint = RESOURCEID_Base + 213;
      
      public static const RESOURCEID_LuckyJoy:uint = RESOURCEID_Base + 214;
      
      public static const RESOURCEID_FighterDetail:uint = RESOURCEID_Base + 215;
      
      public static const RESOURCEID_SwiftChange:uint = RESOURCEID_Base + 216;
      
      public static const RESOURCEID_PrivilegeLease:uint = RESOURCEID_Base + 218;
      
      public static const RESOURCEID_TimeHero:uint = RESOURCEID_Base + 219;
      
      public static const RESOURCEID_HalloweenPay:uint = RESOURCEID_Base + 220;
      
      public static const RESOURCEID_HalloweenTree:uint = RESOURCEID_Base + 221;
      
      public static const RESOURCEID_HalloweenPumpkin:uint = RESOURCEID_Base + 222;
      
      public static const RESOURCEID_HalloweenShop:uint = RESOURCEID_Base + 223;
      
      public static const RESOURCEID_OrgPointInfo:uint = RESOURCEID_Base + 224;
      
      public static const RESOURCEID_CircleTrial:uint = RESOURCEID_Base + 225;
      
      public static const RESOURCEID_CircleHero:uint = RESOURCEID_Base + 226;
      
      public static const RESOURCEID_KingLegend:uint = RESOURCEID_Base + 227;
      
      public static const RESOURCEID_KingGuard:uint = RESOURCEID_Base + 228;
      
      public static const RESOURCEID_ChristmasGift:uint = RESOURCEID_Base + 229;
      
      public static const RESOURCEID_ChristmasWish:uint = RESOURCEID_Base + 230;
      
      public static const RESOURCEID_ChristmasCarnival:uint = RESOURCEID_Base + 231;
      
      public static const RESOURCEID_NewYearDropEgg:uint = RESOURCEID_Base + 232;
      
      public static const RESOURCEID_NewYearFly:uint = RESOURCEID_Base + 233;
      
      public static const RESOURCEID_UniteTask:uint = RESOURCEID_Base + 234;
      
      public static const RESOURCEID_DreamsComeTrue:uint = RESOURCEID_Base + 235;
      
      public static const RESOURCEID_PetYear:uint = RESOURCEID_Base + 236;
      
      public static const RESOURCEID_NewYearRedPacket:uint = RESOURCEID_Base + 237;
      
      public static const RESOURCEID_Firecrackers:uint = RESOURCEID_Base + 238;
      
      public static const RESOURCEID_SheepGoodSell:uint = RESOURCEID_Base + 239;
      
      public static const RESOURCEID_TimeLimitTurntable:uint = RESOURCEID_Base + 240;
      
      public static const RESOURCEID_Feedback:uint = RESOURCEID_Base + 241;
      
      public static const RESOURCEID_DayBack:uint = RESOURCEID_Base + 242;
      
      public static const RESOURCEID_WakeUpEquip:uint = RESOURCEID_Base + 243;
      
      public static const RESOURCEID_WakeUp:uint = RESOURCEID_Base + 244;
      
      public static const RESOURCEID_CompanionCard:uint = RESOURCEID_Base + 245;
      
      public static const RESOURCEID_CompanionChip:uint = RESOURCEID_Base + 246;
      
      public static const RESOURCEID_CompanionEncounter:uint = RESOURCEID_Base + 247;
      
      public static const RESOURCEID_OrgPointAward:uint = RESOURCEID_Base + 248;
      
      public static const RESOURCEID_GrowthPlan:uint = RESOURCEID_Base + 249;
      
      public static const RESOURCEID_Easter:uint = RESOURCEID_Base + 250;
      
      public static const RESOURCEID_BleachBag:uint = RESOURCEID_Base + 251;
      
      public static const RESOURCEID_RelatedPartner:uint = RESOURCEID_Base + 252;
      
      public static const RESOURCEID_RelatedPartnerType:uint = RESOURCEID_Base + 253;
      
      public static const RESOURCEID_RelatedCondition:uint = RESOURCEID_Base + 254;
      
      public static const RESOURCEID_RelatedPartnerPoint:uint = RESOURCEID_Base + 255;
      
      public static const RESOURCEID_Gallery:uint = RESOURCEID_Base + 257;
      
      public static const RESOURCEID_DailyHero:uint = RESOURCEID_Base + 258;
      
      public static const RESOURCEID_Pyramid:uint = RESOURCEID_Base + 259;
      
      public static const RESOURCEID_RushInSeireitei:uint = RESOURCEID_Base + 260;
      
      public static const RESOURCEID_Astrology:uint = RESOURCEID_Base + 261;
      
      public static const RESOURCEID_KnifeHeroCollect:uint = RESOURCEID_Base + 262;
      
      public static const RESOURCEID_CoolSummer:uint = RESOURCEID_Base + 263;
      
      public static const RESOURCEID_EveryDayAward:uint = RESOURCEID_Base + 264;
      
      public static const RESOURCEID_NightmareTrial:uint = RESOURCEID_Base + 266;
      
      public static const RESOURCEID_NightmareTrialCity:uint = RESOURCEID_Base + 267;
      
      public static const RESOURCEID_NightmareTrialPoint:uint = RESOURCEID_Base + 265;
      
      public static const RESOURCEID_FirstPayBag:uint = RESOURCEID_Base + 270;
      
      public static const RESOURCEID_KnifeStrengExp:uint = RESOURCEID_Base + 268;
      
      public static const RESOURCEID_KnifeStrengthen:uint = RESOURCEID_Base + 269;
      
      public static const RESOURCEID_LeaderWakeUp:uint = RESOURCEID_Base + 271;
      
      public static const RESOURCEID_BrushHappy:uint = RESOURCEID_Base + 272;
      
      public static const RESOURCEID_NewServerDraw:uint = RESOURCEID_Base + 273;
      
      public static const RESOURCEID_NewHalloweenGame:uint = RESOURCEID_Base + 274;
      
      public static const RESOURCEID_NewHalloweenRecharge:uint = RESOURCEID_Base + 275;
      
      public static const RESOURCEID_NewHalloweenConsume:uint = RESOURCEID_Base + 276;
      
      public static const RESOURCEID_ThankYou:uint = RESOURCEID_Base + 277;
      
      public static const RESOURCEID_ThanksFeast:uint = RESOURCEID_Base + 278;
      
      public static const RESOURCEID_ThanksTreasure:uint = RESOURCEID_Base + 279;
      
      public static const RESOURCEID_ExpDuplicate:uint = RESOURCEID_Base + 280;
      
      public static const RESOURCEID_CustomHeros:uint = RESOURCEID_Base + 281;
      
      public static const RESOURCEID_CustomHeroExp:uint = RESOURCEID_Base + 288;
      
      public static const RESOURCEID_SnowBattle:uint = RESOURCEID_Base + 289;
      
      public static const RESOURCEID_Christmas2015Tree:uint = RESOURCEID_Base + 290;
      
      public static const RESOURCEID_Sock:uint = RESOURCEID_Base + 291;
      
      public static const RESOURCEID_Sled:uint = RESOURCEID_Base + 292;
      
      public static const RESOURCEID_SoulCollectionRnd:uint = RESOURCEID_Base + 293;
      
      public static const RESOURCEID_SoulCollectionShop:uint = RESOURCEID_Base + 294;
      
      public static const RESOURCEID_SoulCollectionBase:uint = RESOURCEID_Base + 295;
      
      public static const RESOURCEID_Check:uint = RESOURCEID_Base + 296;
      
      public static const RESOURCEID_Nian:uint = RESOURCEID_Base + 297;
      
      public static const RESOURCEID_Pocket:uint = RESOURCEID_Base + 298;
      
      public static const RESOURCEID_NewYearFund:uint = RESOURCEID_Base + 299;
      
      public static const RESOURCEID_NewYearChess:uint = RESOURCEID_Base + 300;
      
      public static const RESOURCEID_Easter2016_0:uint = RESOURCEID_Base + 301;
      
      public static const RESOURCEID_Easter2016_1:uint = RESOURCEID_Base + 302;
      
      public static const RESOURCEID_Easter2016_2:uint = RESOURCEID_Base + 303;
      
      public static const RESOURCEID_GhostKingForg:uint = RESOURCEID_Base + 304;
      
      public static const RESOURCEID_LaborDayCultivation:uint = RESOURCEID_Base + 305;
      
      public static const RESOURCEID_LaborLaborDayPet:uint = RESOURCEID_Base + 306;
      
      public static const RESOURCEID_LaborConsume:uint = RESOURCEID_Base + 307;
      
      public static const RESOURCEID_DuanwujiePet:uint = RESOURCEID_Base + 308;
      
      public static const RESOURCEID_DuanwujieBoat:uint = RESOURCEID_Base + 309;
      
      public static const RESOURCEID_TreasureHunt:uint = RESOURCEID_Base + 310;
      
      public static const RESOURCEID_TreasureShop:uint = RESOURCEID_Base + 311;
      
      public static const RESOURCEID_SoulDraw:uint = RESOURCEID_Base + 312;
      
      public static const RESOURCEID_SoulBuy:uint = RESOURCEID_Base + 313;
      
      public static const RESOURCEID_SoulRecharge:uint = RESOURCEID_Base + 314;
      
      public static const RESOURCEID_EquipForge:uint = RESOURCEID_Base + 315;
      
      public static const RESOURCEID_EquipAdvance:uint = RESOURCEID_Base + 316;
      
      public static const RESOURCEID_KnifeChessRecharge:uint = RESOURCEID_Base + 317;
      
      public static const RESOURCEID_KnifeChessBuy:uint = RESOURCEID_Base + 318;
      
      public static const RESOURCEID_AdvanceChange:uint = RESOURCEID_Base + 319;
      
      public static const RESOURCEID_NationalDayOne:uint = RESOURCEID_Base + 320;
      
      public static const RESOURCEID_NationalDayTwo:uint = RESOURCEID_Base + 321;
      
      public static const RESOURCEID_HalloweenVip:uint = RESOURCEID_Base + 322;
      
      public static const RESOURCEID_HalloweenRoundShop:uint = RESOURCEID_Base + 323;
      
      public static const RESOURCEID_ThanksGivingDay2016One:uint = RESOURCEID_Base + 324;
      
      public static const RESOURCEID_ThanksGivingDay2016Two:uint = RESOURCEID_Base + 325;
      
      public static const RESOURCEID_ThanksGivingDay2016Three:uint = RESOURCEID_Base + 326;
      
      public static const RESOURCEID_NewYear2017Task:uint = RESOURCEID_Base + 327;
      
      public static const RESOURCEID_NewYear2017Bags:uint = RESOURCEID_Base + 328;
      
      public static const RESOURCEID_NewYear2017Discount:uint = RESOURCEID_Base + 329;
      
      public static const RESOURCEID_FoolsDayRecharge:uint = RESOURCEID_Base + 330;
      
      public static const RESOURCEID_FoolsDayShop:uint = RESOURCEID_Base + 331;
      
      public static const RESOURCEID_ChildrenDayShop:uint = RESOURCEID_Base + 332;
      
      public static const RESOURCEID_ChildrenDayHero:uint = RESOURCEID_Base + 333;
      
      public static const RESOURCEID_ChildrenDayCollect:uint = RESOURCEID_Base + 334;
      
      public static const RESOURCEID_AnniversaryOne:uint = RESOURCEID_Base + 335;
      
      public static const RESOURCEID_AnniversaryTwo:uint = RESOURCEID_Base + 336;
      
      public static const RESOURCEID_AnniversaryThree:uint = RESOURCEID_Base + 337;
      
      public static const RESOURCEID_NationalDayOne2017:uint = RESOURCEID_Base + 338;
      
      public static const RESOURCEID_NationalDayTwo2017:uint = RESOURCEID_Base + 339;
      
      public static const RESOURCEID_NationalDayThree2017:uint = RESOURCEID_Base + 340;
      
      public static const RESOURCEID_ProfessionRefine:uint = RESOURCEID_Base + 341;
      
      public static const RESOURCESID_DATEBASE:Vector.<uint> = Vector.<uint>([RESOURCEID_HDActivity,RESOURCEID_Article,RESOURCEID_Award,RESOURCEID_BaseEquip,RESOURCEID_BaseHero,RESOURCEID_KnifeSoul,RESOURCEID_BaseStone,RESOURCEID_BlockPoint,RESOURCEID_BuffEffect,RESOURCEID_BuildConsume,RESOURCEID_BuildValue,RESOURCEID_BuyMoney,RESOURCEID_ChannelChet,RESOURCEID_City,RESOURCEID_ConfigValue,RESOURCEID_DailyActivity,RESOURCEID_DailyAward,RESOURCEID_DailyTask,RESOURCEID_DialogueScript,RESOURCEID_Digging,RESOURCEID_Enemy,RESOURCEID_EnemyArmy,RESOURCEID_EquipAdditional,RESOURCEID_EquipGenerate,RESOURCEID_EquipUpgrade,RESOURCEID_ErrorCode,RESOURCEID_Exchange_ExpCard,RESOURCEID_HeroExp,RESOURCEID_HeroReplacement,RESOURCEID_HeroTalent,RESOURCEID_Mall,RESOURCEID_Map,RESOURCEID_Maskword,RESOURCEID_Military,RESOURCEID_MusicConfig,RESOURCEID_FunctionSwitch,RESOURCEID_TemplePliesNumber,RESOURCEID_FreshGuide,RESOURCEID_NPC,RESOURCEID_OrganizationAddition,RESOURCEID_OrganizationBase,RESOURCEID_OrganizationDevotion
      ,RESOURCEID_PopTips,RESOURCEID_Post,RESOURCEID_RaidersDailyConfig,RESOURCEID_RandomName,RESOURCEID_RankComposeQuality,RESOURCEID_RankExpendCost,RESOURCEID_RankMoney,RESOURCEID_RankReward,RESOURCEID_RecommendStone,RESOURCEID_RoleModel,RESOURCEID_ServenStar,RESOURCEID_ServenStarExp,RESOURCEID_SignReward,RESOURCEID_Single,RESOURCEID_SinglePointPath,RESOURCEID_SingleResetCharge,RESOURCEID_SkillConfig,RESOURCEID_StarMap,RESOURCEID_StarPoint,RESOURCEID_StarPointDesc,RESOURCEID_Suit,RESOURCEID_SystemLanguage,RESOURCEID_Task,RESOURCEID_TaskDramaDialogue,RESOURCEID_Tavern_Grade,RESOURCEID_Tavern_PayConfig,RESOURCEID_Tavern_Warrior,RESOURCEID_TreasureLevelup,RESOURCEID_TreasureUpgrade,RESOURCEID_VipConfig,RESOURCEID_SoulSkill,RESOURCEID_MagicStone,RESOURCEID_WeaponSkillConfig,RESOURCEID_Knife,RESOURCEID_KnifeExpand,RESOURCEID_RecommendHero,RESOURCEID_SlaveGainExp,RESOURCEID_SlaveMessage,RESOURCEID_SlaveBleed,RESOURCEID_HomeLevel,RESOURCEID_Butterfly,RESOURCEID_ButterflyFeeding,RESOURCEID_HomeGirlFriend
      ,RESOURCEID_HomeGirlAward,RESOURCEID_HomeGirlInteract,RESOURCEID_HomeGamble,RESOURCEID_HomeGambleCost,RESOURCEID_HomeGambleBox,RESOURCEID_HomeSoulAward,RESOURCEID_HomeFortune,RESOURCEID_HomeGirlMood,RESOURCEID_AutoActivityGain,RESOURCEID_SevenHeroLittleStar,RESOURCEID_SevenHeroStar,RESOURCEID_SevenHeroArmy,RESOURCEID_SevenHeroDailyAward,RESOURCEID_SevenHeroSoul,RESOURCEID_HDIcon,RESOURCEID_HDArenaRank,RESOURCEID_HDCampBattle,RESOURCEID_HDKillHero,RESOURCEID_HDLevelRank,RESOURCEID_HDPowerRank,RESOURCEID_HDRecruitPartner,RESOURCEID_HDGBOnline,RESOURCEID_HDGBGold,RESOURCEID_HDGBSevenDay,RESOURCEID_HDGBOpenSever,RESOURCEID_HDGBCollectgame,RESOURCEID_HDSinglePay,RESOURCEID_HDTotalPay,RESOURCEID_HDDailyPay,RESOURCEID_HDTotalCost,RESOURCEID_HDDailyCost,RESOURCEID_HDVipBox,RESOURCEID_HDFirstPay,RESOURCEID_HDYDDailyGiftBag,RESOURCEID_HDYDGrowGiftBag,RESOURCEID_HDYDLevelGiftBag,RESOURCEID_HDYDFreshGiftBag,RESOURCEID_HDYDBuyGold,RESOURCEID_HDDailyTotalPay,RESOURCEID_HDDailyTotalCost,RESOURCEID_SoundConfig
      ,RESOURCEID_HDEquipCollection,RESOURCEID_HDMilitary,RESOURCEID_HDStone,RESOURCEID_HDTreasure,RESOURCEID_HDGrowFundLv,RESOURCEID_HDGrowFundGamble,RESOURCEID_HDGrowFundShop,RESOURCEID_Achievement,RESOURCEID_AchievementGroup,RESOURCEID_AchievementClass,RESOURCEID_AchievementTitle,RESOURCEID_HDSuperTreasure,RESOURCEID_HDChristmas,RESOURCEID_HDCityDefence,RESOURCEID_HDGroupLv,RESOURCEID_HDGroupWar,RESOURCEID_HDPetSoulDefence,RESOURCEID_HDPay,RESOURCEID_LeagueMapPve,RESOURCEID_LeagueMapPvp,RESOURCEID_NewYear,RESOURCEID_Espada,RESOURCEID_OrnamentValue,RESOURCEID_OrnamentUpgrade,RESOURCEID_LeaguePointPath,RESOURCEID_LeagueAction,RESOURCEID_HDExchangeChip,RESOURCEID_Beauty,RESOURCEID_BeautifulClothes,RESOURCEID_HDSinglePayTime,RESOURCEID_HDChineseYearSignIn,RESOURCEID_HDDoubleFish,RESOURCEID_HDChineseYearLukia,RESOURCEID_GirlsRecommend,RESOURCEID_GirlQuestion,RESOURCEID_GirlStrategy,RESOURCEID_HDMoneyPenny,RESOURCEID_GrowRoadDayTask,RESOURCEID_GrowRoadTask,RESOURCEID_GrowRoadGift,RESOURCEID_HDGambling
      ,RESOURCEID_HDLimitBuy,RESOURCEID_HDIceHeros,RESOURCEID_TemplePoint,RESOURCEID_TemplePVP,RESOURCEID_TempleValue,RESOURCEID_GSPVP_DailyAward,RESOURCEID_GSPVP_Reward,RESOURCEID_TeamMemberExpand,RESOURCEID_HDTeamBuy,RESOURCEID_HDJigsaw,RESOURCEID_HDLevelGiftBag,RESOURCEID_HDBigTurnTable,RESOURCEID_HDOrder,RESOURCEID_DrillHoleCost,RESOURCEID_HDServerPay,RESOURCEID_CrashJade,RESOURCEID_DailyGetBackReward,RESOURCEID_DailyWelfareReward,RESOURCEID_DailyCrashJadeKind,RESOURCEID_HDRandCard,RESOURCEID_SpiritSchool,RESOURCEID_SpiritSchoolExp,RESOURCEID_BleachJigsaw,RESOURCEID_HDTreasureShop,RESOURCEID_HDChess,RESOURCEID_HDWorldCup,RESOURCEID_HDHerosMarket,RESOURCEID_PartnerChange,RESOURCEID_ChangeHeroPoint,RESOURCEID_BlackMarket,RESOURCEID_HeroChangeAttr,RESOURCEID_Lottery,RESOURCEID_MainPetRankUp,RESOURCEID_PetFamilyBag,RESOURCEID_PetLevelUp,RESOURCEID_VicePetMake,RESOURCEID_VicePetRankUp,RESOURCEID_VicePetTrain,RESOURCEID_JoyfunPay,RESOURCEID_Partner,RESOURCEID_LuckyJoy,RESOURCEID_FighterDetail,RESOURCEID_SwiftChange
      ,RESOURCEID_PrivilegeLease,RESOURCEID_TimeHero,RESOURCEID_HalloweenPay,RESOURCEID_HalloweenTree,RESOURCEID_HalloweenPumpkin,RESOURCEID_HalloweenShop,RESOURCEID_OrgPointInfo,RESOURCEID_CircleTrial,RESOURCEID_CircleHero,RESOURCEID_KingLegend,RESOURCEID_KingGuard,RESOURCEID_ChristmasGift,RESOURCEID_ChristmasWish,RESOURCEID_ChristmasCarnival,RESOURCEID_NewYearDropEgg,RESOURCEID_NewYearFly,RESOURCEID_UniteTask,RESOURCEID_DreamsComeTrue,RESOURCEID_PetYear,RESOURCEID_NewYearRedPacket,RESOURCEID_Firecrackers,RESOURCEID_SheepGoodSell,RESOURCEID_TimeLimitTurntable,RESOURCEID_Feedback,RESOURCEID_DayBack,RESOURCEID_GrowthPlan,RESOURCEID_Easter,RESOURCEID_BleachBag,RESOURCEID_OrgPointAward,RESOURCEID_WakeUpEquip,RESOURCEID_WakeUp,RESOURCEID_CompanionCard,RESOURCEID_CompanionChip,RESOURCEID_CompanionEncounter,RESOURCEID_RelatedPartner,RESOURCEID_RelatedPartnerType,RESOURCEID_RelatedCondition,RESOURCEID_RelatedPartnerPoint,RESOURCEID_Gallery,RESOURCEID_DailyHero,RESOURCEID_Pyramid,RESOURCEID_RushInSeireitei
      ,RESOURCEID_Astrology,RESOURCEID_KnifeHeroCollect,RESOURCEID_CoolSummer,RESOURCEID_EveryDayAward,RESOURCEID_NightmareTrial,RESOURCEID_NightmareTrialCity,RESOURCEID_NightmareTrialPoint,RESOURCEID_FirstPayBag,RESOURCEID_KnifeStrengExp,RESOURCEID_KnifeStrengthen,RESOURCEID_LeaderWakeUp,RESOURCEID_BrushHappy,RESOURCEID_NewServerDraw,RESOURCEID_NewHalloweenGame,RESOURCEID_NewHalloweenRecharge,RESOURCEID_NewHalloweenConsume,RESOURCEID_ThankYou,RESOURCEID_ThanksFeast,RESOURCEID_ThanksTreasure,RESOURCEID_ExpDuplicate,RESOURCEID_SnowBattle,RESOURCEID_Christmas2015Tree,RESOURCEID_Sock,RESOURCEID_Sled,RESOURCEID_CustomHeros,RESOURCEID_CustomHeroExp,RESOURCEID_SoulCollectionRnd,RESOURCEID_SoulCollectionShop,RESOURCEID_SoulCollectionBase,RESOURCEID_Check,RESOURCEID_Nian,RESOURCEID_Pocket,RESOURCEID_NewYearFund,RESOURCEID_NewYearChess,RESOURCEID_Easter2016_0,RESOURCEID_Easter2016_1,RESOURCEID_Easter2016_2,RESOURCEID_GhostKingForg,RESOURCEID_LaborDayCultivation,RESOURCEID_LaborLaborDayPet,RESOURCEID_LaborConsume
      ,RESOURCEID_DuanwujiePet,RESOURCEID_DuanwujieBoat,RESOURCEID_TreasureHunt,RESOURCEID_TreasureShop,RESOURCEID_SoulDraw,RESOURCEID_SoulBuy,RESOURCEID_SoulRecharge,RESOURCEID_EquipForge,RESOURCEID_EquipAdvance,RESOURCEID_KnifeChessRecharge,RESOURCEID_KnifeChessBuy,RESOURCEID_AdvanceChange,RESOURCEID_NationalDayOne,RESOURCEID_NationalDayTwo,RESOURCEID_HalloweenVip,RESOURCEID_HalloweenRoundShop,RESOURCEID_ThanksGivingDay2016One,RESOURCEID_ThanksGivingDay2016Two,RESOURCEID_ThanksGivingDay2016Three,RESOURCEID_NewYear2017Task,RESOURCEID_NewYear2017Bags,RESOURCEID_NewYear2017Discount,RESOURCEID_FoolsDayRecharge,RESOURCEID_FoolsDayShop,RESOURCEID_ChildrenDayShop,RESOURCEID_ChildrenDayHero,RESOURCEID_ChildrenDayCollect,RESOURCEID_AnniversaryOne,RESOURCEID_AnniversaryTwo,RESOURCEID_AnniversaryThree,RESOURCEID_NationalDayOne2017,RESOURCEID_NationalDayTwo2017,RESOURCEID_NationalDayThree2017,RESOURCEID_ProfessionRefine]);
      
      private static const CLASSTYPE_HDActivity:Class = THDActivity;
      
      private static const CLASSTYPE_Article:Class = TArticle;
      
      private static const CLASSTYPE_Award:Class = TAward;
      
      private static const CLASSTYPE_BaseEquip:Class = TBaseEquip;
      
      private static const CLASSTYPE_BaseHero:Class = TBaseHero;
      
      private static const CLASSTYPE_KnifeSoul:Class = TKnifeSoul;
      
      private static const CLASSTYPE_BaseStone:Class = TBaseStone;
      
      private static const CLASSTYPE_BlockPoint:Class = TBlockPoint;
      
      private static const CLASSTYPE_BuffEffect:Class = TBuffEffect;
      
      private static const CLASSTYPE_BuildConsume:Class = TBuildConsume;
      
      private static const CLASSTYPE_BuildValue:Class = TBuildValue;
      
      private static const CLASSTYPE_BuyMoney:Class = TBuyMoney;
      
      private static const CLASSTYPE_ChannelChet:Class = TChannelChet;
      
      private static const CLASSTYPE_City:Class = TCity;
      
      private static const CLASSTYPE_ConfigValue:Class = TConfigValue;
      
      private static const CLASSTYPE_DailyActivity:Class = TDailyActivity;
      
      private static const CLASSTYPE_DailyAward:Class = TDailyAward;
      
      private static const CLASSTYPE_DailyTask:Class = TDailyTask;
      
      private static const CLASSTYPE_DialogueScript:Class = TDialogueScript;
      
      private static const CLASSTYPE_Digging:Class = TDigging;
      
      private static const CLASSTYPE_Enemy:Class = TEnemy;
      
      private static const CLASSTYPE_EnemyArmy:Class = TEnemyArmy;
      
      private static const CLASSTYPE_EquipAdditional:Class = TEquipAdditional;
      
      private static const CLASSTYPE_EquipGenerate:Class = TEquipGenerate;
      
      private static const CLASSTYPE_EquipUpgrade:Class = TEquipUpgrade;
      
      private static const CLASSTYPE_ErrorCode:Class = TErrorCode;
      
      private static const CLASSTYPE_Exchange_ExpCard:Class = TExchangeExpCard;
      
      private static const CLASSTYPE_HeroExp:Class = THeroExp;
      
      private static const CLASSTYPE_HeroReplacement:Class = THeroReplacement;
      
      private static const CLASSTYPE_HeroTalent:Class = THeroTalent;
      
      private static const CLASSTYPE_Mall:Class = TMall;
      
      private static const CLASSTYPE_Map:Class = TMap;
      
      private static const CLASSTYPE_Maskword:Class = TMaskword;
      
      private static const CLASSTYPE_Military:Class = TMilitary;
      
      private static const CLASSTYPE_MusicConfig:Class = TMusicConfig;
      
      private static const CLASSTYPE_FunctionSwitch:Class = TFunctionSwitch;
      
      private static const CLASSTYPE_TemplePliesNumber:Class = TTemplePliesNumber;
      
      private static const CLASSTYPE_FreshGuide:Class = TFreshGuide;
      
      private static const CLASSTYPE_NPC:Class = TNPC;
      
      private static const CLASSTYPE_OrganizationAddition:Class = TOrganizationAddition;
      
      private static const CLASSTYPE_OrganizationBase:Class = TOrganizationBase;
      
      private static const CLASSTYPE_OrganizationDevotion:Class = TOrganizationDevotion;
      
      private static const CLASSTYPE_PopTips:Class = TPopTips;
      
      private static const CLASSTYPE_Post:Class = TPost;
      
      private static const CLASSTYPE_RaidersDailyConfig:Class = TRaidersDailyConfig;
      
      private static const CLASSTYPE_RandomName:Class = TRandomName;
      
      private static const CLASSTYPE_RankComposeQuality:Class = TRankComposeQuality;
      
      private static const CLASSTYPE_RankExpendCost:Class = TRankExpendCost;
      
      private static const CLASSTYPE_RankMoney:Class = TRankMoney;
      
      private static const CLASSTYPE_RankReward:Class = TRankReward;
      
      private static const CLASSTYPE_RecommendStone:Class = TRecommendStone;
      
      private static const CLASSTYPE_RoleModel:Class = TRoleModel;
      
      private static const CLASSTYPE_ServenStar:Class = TServenStar;
      
      private static const CLASSTYPE_ServenStarExp:Class = TServenStarExp;
      
      private static const CLASSTYPE_SignReward:Class = TSignReward;
      
      private static const CLASSTYPE_Single:Class = TSingle;
      
      private static const CLASSTYPE_SinglePointPath:Class = TSinglePointPath;
      
      private static const CLASSTYPE_SingleResetCharge:Class = TSingleResetCharge;
      
      private static const CLASSTYPE_SkillConfig:Class = TSkillConfig;
      
      private static const CLASSTYPE_StarMap:Class = TStarMap;
      
      private static const CLASSTYPE_StarPoint:Class = TStarPoint;
      
      private static const CLASSTYPE_StarPointDesc:Class = TStarPointDesc;
      
      private static const CLASSTYPE_Suit:Class = TSuit;
      
      private static const CLASSTYPE_SystemLanguage:Class = TSystemLanguage;
      
      private static const CLASSTYPE_Task:Class = TTask;
      
      private static const CLASSTYPE_TaskDramaDialogue:Class = TTaskDramaDialogue;
      
      private static const CLASSTYPE_Tavern_Grade:Class = TTavernGrade;
      
      private static const CLASSTYPE_Tavern_PayConfig:Class = TTavernPayConfig;
      
      private static const CLASSTYPE_Tavern_Warrior:Class = TTavernWarrior;
      
      private static const CLASSTYPE_TreasureLevelup:Class = TTreasureLevelup;
      
      private static const CLASSTYPE_TreasureUpgrade:Class = TTreasureUpgrade;
      
      private static const CLASSTYPE_VipConfig:Class = TVipConfig;
      
      private static const CLASSTYPE_SoulSkill:Class = TSoulSkill;
      
      private static const CLASSTYPE_WeaponSkillConfig:Class = TWeaponSkillConfig;
      
      private static const CLASSTYPE_MagicStone:Class = TMagicStone;
      
      private static const CLASSTYPE_Knife:Class = TKnife;
      
      private static const CLASSTYPE_KnifeExpand:Class = TKnifeExpand;
      
      private static const CLASSTYPE_RecommandHero:Class = TRecommendHero;
      
      private static const CLASSTYPE_SlaveGainExp:Class = TSlaveGainExp;
      
      private static const CLASSTYPE_SlaveMessage:Class = TSlaveMessage;
      
      private static const CLASSTYPE_SlaveBleed:Class = TSlaveBleed;
      
      private static const CLASSTYPE_HomeLevel:Class = THomeLevel;
      
      private static const CLASSTYPE_Butterfly:Class = TButterfly;
      
      private static const CLASSTYPE_ButterflyFeeding:Class = TButterflyFeeding;
      
      private static const CLASSTYPE_HomeGirlFriend:Class = THomeGirlFriend;
      
      private static const CLASSTYPE_HomeGirlAward:Class = THomeGirlAward;
      
      private static const CLASSTYPE_HomeGirlInteract:Class = THomeGirlInteract;
      
      private static const CLASSTYPE_HomeGamble:Class = THomeGamble;
      
      private static const CLASSTYPE_HomeGambleCost:Class = THomeGambleCost;
      
      private static const CLASSTYPE_HomeGambleBox:Class = THomeGambleBox;
      
      private static const CLASSTYPE_HomeSoulAward:Class = THomeSoulAward;
      
      private static const CLASSTYPE_HomeFortune:Class = THomeFortune;
      
      private static const CLASSTYPE_HomeGirlMood:Class = THomeGirlMood;
      
      private static const CLASSTYPE_AutoActivityGain:Class = TAutoActivityGain;
      
      private static const CLASSTYPE_SevenHeroLittleStar:Class = TSevenHeroLittleStar;
      
      private static const CLASSTYPE_SevenHeroStar:Class = TSevenHeroStar;
      
      private static const CLASSTYPE_SevenHeroArmy:Class = TSevenHeroArmy;
      
      private static const CLASSTYPE_SevenHeroDailyAward:Class = TSevenHeroDailyAward;
      
      private static const CLASSTYPE_SevenHeroSoul:Class = TSevenHeroSoul;
      
      private static const CLASSTYPE_HDIcon:Class = THDIcon;
      
      private static const CLASSTYPE_HDArenaRank:Class = THDArenaRank;
      
      private static const CLASSTYPE_HDCampBattle:Class = THDCampBattle;
      
      private static const CLASSTYPE_HDKillHero:Class = THDKillHero;
      
      private static const CLASSTYPE_HDLevelRank:Class = THDLevelRank;
      
      private static const CLASSTYPE_HDPowerRank:Class = THDPowerRank;
      
      private static const CLASSTYPE_HDRecruitPartner:Class = THDRecruitPartner;
      
      private static const CLASSTYPE_HDGBOnline:Class = THDGBOnline;
      
      private static const CLASSTYPE_HDGBGold:Class = THDGBGold;
      
      private static const CLASSTYPE_HDGBSevenDay:Class = THDGBSevenDay;
      
      private static const CLASSTYPE_HDGBOpenServer:Class = THDGBOpenServer;
      
      private static const CLASSTYPE_HDGBCollectGame:Class = THDGBCollectGame;
      
      private static const CLASSTYPE_HDSinglePay:Class = THDSinglePay;
      
      private static const CLASSTYPE_HDTotalPay:Class = THDTotalPay;
      
      private static const CLASSTYPE_HDDailyPay:Class = THDDailyPay;
      
      private static const CLASSTYPE_HDTotalCost:Class = THDTotalCost;
      
      private static const CLASSTYPE_HDDailyCost:Class = THDDailyCost;
      
      private static const CLASSTYPE_HDVipBox:Class = THDVipBox;
      
      private static const CLASSTYPE_HDFirstPay:Class = THDFirstPay;
      
      private static const CLASSTYPE_YDGiftBagDailyBag:Class = THDYellowDiamonGiftBagDailyBag;
      
      private static const CLASSTYPE_YDGiftBagGrowBag:Class = THDYellowDiamonGiftBagGrowGift;
      
      private static const CLASSTYPE_YDGiftBagLevelBag:Class = THDYellowDiamonGiftBagLevelBag;
      
      private static const CLASSTYPE_YDGiftBagFreshBag:Class = THDYellowDiamonGiftBagFreshBag;
      
      private static const CLASSTYPE_YDBuyGold:Class = THD_YDBuyGold;
      
      private static const CLASSTYPE_HDDailyTotalPay:Class = THDDailyTotalPay;
      
      private static const CLASSTYPE_HDDailyTotalCost:Class = THDDailyTotalCost;
      
      private static const CLASSTYPE_SoundConfig:Class = TSoundConfig;
      
      private static const CLASSTYPE_HDEquipCollection:Class = THDEquipCollect;
      
      private static const CLASSTYPE_HDMilitary:Class = THDLevelSeat;
      
      private static const CLASSTYPE_HDStone:Class = THDCompoundStone;
      
      private static const CLASSTYPE_HDTreasure:Class = THDLevelTailsman;
      
      private static const CLASSTYPE_HDGrowFundLv:Class = THDGrowFundLv;
      
      private static const CLASSTYPE_HDGrowFundGamble:Class = THDGrowFundGamble;
      
      private static const CLASSTYPE_HDGrowFundShop:Class = THDGrowFundShop;
      
      private static const CLASSTYPE_Achievement:Class = TAchievement;
      
      private static const CLASSTYPE_AchievementGroup:Class = TAchievementGroup;
      
      private static const CLASSTYPE_AchievementClass:Class = TAchievementClass;
      
      private static const CLASSTYPE_AchievementTitle:Class = TAchievementTitle;
      
      private static const CLASSTYPE_SuperTreasure:Class = THDSuperTreasure;
      
      private static const CLASSTYPE_HDChristmas:Class = THDChristmas;
      
      private static const CLASSTYPE_HDCityDefence:Class = THDCityDefence;
      
      private static const CLASSTYPE_HDGroupLv:Class = THDGroupLv;
      
      private static const CLASSTYPE_HDGroupWar:Class = THDGroupWar;
      
      private static const CLASSTYPE_HDPetSoulDefence:Class = THDPetSoulDefence;
      
      private static const CLASSTYPE_HDPay:Class = THDPay;
      
      private static const CLASSTYPE_LeagueMapPve:Class = TLeagueMapPve;
      
      private static const CLASSTYPE_LeagueMapPvp:Class = TLeagueMapPvp;
      
      private static const CLASSTYPE_NewYear:Class = THDNewYearEgg;
      
      private static const CLASSTYPE_Espada:Class = THDActivityEspada;
      
      private static const CLASSTYPE_OrnamentValue:Class = TOrnamentValue;
      
      private static const CLASSTYPE_OrnamentUpgrade:Class = TOrnamentUpgrade;
      
      private static const CLASSTYPE_LeaguePointPath:Class = TLeaguePointPath;
      
      private static const CLASSTYPE_LeagueAction:Class = TLeagueAction;
      
      private static const CLASSTYPE_HDExchangeChip:Class = THDExchangeChip;
      
      private static const CLASSTYPE_Beauty:Class = TBeauty;
      
      private static const CLASSTYPE_BeautifulClothes:Class = TBeautifulClothes;
      
      private static const CLASSTYPE_HDSinglePayTime:Class = THDSinglePayTime;
      
      private static const CLASSTYPE_HDChineseYearSignIn:Class = THDChineseYearSignIn;
      
      private static const CLASSTYPE_HDDoubleFish:Class = THDDoubleFish;
      
      private static const CLASSTYPE_HDChineseYearLukia:Class = THDChineseYearLukia;
      
      private static const CLASSTYPE_GirlsRecommend:Class = TGirlsRecommend;
      
      private static const CLASSTYPE_GirlQuestion:Class = TGirlsQuestion;
      
      private static const CLASSTYPE_GirlsStrategy:Class = TGirlsStrategy;
      
      private static const CLASSTYPE_HDMoneyPenny:Class = THDMoneyPenny;
      
      private static const CLASSTYPE_GrowRoadDayTask:Class = TGrowRoadDayTask;
      
      private static const CLASSTYPE_GrowRoadTask:Class = TGrowRoadTask;
      
      private static const CLASSTYPE_GrowRoadGift:Class = TGrowRoadGift;
      
      private static const CLASSTYPE_HDGambling:Class = THDGambling;
      
      private static const CLASSTYPE_HDLimitBuy:Class = THDActivityLimitBuy;
      
      private static const CLASSTYPE_HDIceHeros:Class = THDIceHeros;
      
      private static const CLASSTYPE_TemplePoint:Class = TTemplePoint;
      
      private static const CLASSTYPE_TemplePVP:Class = TTemplePVP;
      
      private static const CLASSTYPE_TempleValue:Class = TTempleValue;
      
      private static const CLASSTYPE_GSPVPDailyAward:Class = TGSPVPDailyAward;
      
      private static const CLASSTYPE_GSPVP_Reward:Class = TGSPVP_Reward;
      
      private static const CLASSTYPE_TeamMemberExpand:Class = TTeamMemberExpand;
      
      private static const CLASSTYPE_HDTeamBuy:Class = THDTeamBuy;
      
      private static const CLASSTYPE_HDJigsaw:Class = THDJigSaw;
      
      private static const CLASSTYPE_HDGBLevel:Class = THDGBLevel;
      
      private static const CLASSTYPE_HDBigTurnTable:Class = THDBigTurnTable;
      
      private static const CLASSTYPE_HDOrderReward:Class = THD_OrderReward;
      
      private static const CLASSTYPE_TDrillHole:Class = TDrillHole;
      
      private static const CLASSTYPE_CrashedJade:Class = TCrashedJade;
      
      private static const CLASSTYPE_HDServerPay:Class = THDServerPay;
      
      private static const CLASSTYPE_DailyGetBackReward:Class = TDailyGetBackReward;
      
      private static const CLASSTYPE_DailyWelfareReward:Class = TDailyWelfareReward;
      
      private static const CLASSTYPE_CrashedJadeKind:Class = TCrashJadeKind;
      
      private static const CLASSTYPE_HDRandCard:Class = THDRandCard;
      
      private static const CLASSTYPE_SpiritSchool:Class = TSpiritSchool;
      
      private static const CLASSTYPE_SpiritSchoolExp:Class = TSpiritSchoolExp;
      
      private static const CLASSTYPE_HDBeachJigsaw:Class = THDBleachJigSaw;
      
      private static const CLASSTYPE_HDTreasureShop:Class = THDTreasureShop;
      
      private static const CLASSTYPE_HDChess:Class = THDChess;
      
      private static const CLASSTYPE_HDWorldCup:Class = THDWorldCup;
      
      private static const CLASSTYPE_HDHerosMarket:Class = THDHerosMarket;
      
      private static const CLASSTYPE_PartnerChange:Class = TPartnerChange;
      
      private static const CLASSTYPE_ChangeHeroPoint:Class = TChangeHeroPoint;
      
      private static const CLASSTYPE_BlackMarket:Class = TBlackMarket;
      
      private static const CLASSTYPE_HeroChangeAttr:Class = THeroChangeAttr;
      
      private static const CLASSTYPE_HDLottery:Class = THDLottery;
      
      private static const CLASSTYPE_MainPetRankUp:Class = TMainPetRankUp;
      
      private static const CLASSTYPE_PetFamilyBag:Class = TPetFamilyBag;
      
      private static const CLASSTYPE_PetLevelUp:Class = TPetLevelUp;
      
      private static const CLASSTYPE_VicePetMake:Class = TVicePetMake;
      
      private static const CLASSTYPE_VicePetRankUp:Class = TVicePetRankUp;
      
      private static const CLASSTYPE_VicePetTrain:Class = TVicePetTrain;
      
      private static const CLASSTYPE_JoyfunPay:Class = TJoyfunPay;
      
      private static const CLASSTYPE_HDPartner:Class = THDPartner;
      
      private static const CLASSTYPE_HDLuckyJoy:Class = THDLuckyJoy;
      
      private static const CLASSTYPE_FighterDetail:Class = TFighterDetail;
      
      private static const CLASSTYPE_SwiftChange:Class = THSwiftChangeConfig;
      
      private static const CLASSTYPE_PrivilegeLease:Class = THDPrivilegeLease;
      
      private static const CLASSTYPE_TimeHero:Class = TTimeHero;
      
      private static const CLASSTYPE_HalloweenPay:Class = THDHalloweenPay;
      
      private static const CLASSTYPE_HalloweenTree:Class = THDHalloweenTree;
      
      private static const CLASSTYPE_HalloweenPumpkin:Class = THDHalloweenPumpkin;
      
      private static const CLASSTYPE_HalloweenShop:Class = THDHalloweenExchange;
      
      private static const CLASSTYPE_OrgPointInfo:Class = TOrgPointInfo;
      
      private static const CLASSTYPE_CircleTrial:Class = THDCircleTrial;
      
      private static const CLASSTYPE_CircleHero:Class = THDCircleHero;
      
      private static const CLASSTYPE_KingLegend:Class = THDKingLegend;
      
      private static const CLASSTYPE_KingGuard:Class = THDKingGuard;
      
      private static const CLASSTYPE_ChiristmasGift:Class = THDChristmasGift;
      
      private static const CLASSTYPE_ChristmasWish:Class = THDChristmasWish;
      
      private static const CLASSTYPE_ChristmasCarnival:Class = THDChristmasCarnivalConfig;
      
      private static const CLASSTYPE_NewYearLuckEgg:Class = THDNewYearLuckEggConfig;
      
      private static const CLASSTYPE_NewYearFly:Class = THDNewYearFly;
      
      private static const CLASSTYPE_UniteTask:Class = THDUniteTaskConfig;
      
      private static const CLASSTYPE_DreamsComeTrue:Class = THDDreamsComeTrue;
      
      private static const CLASSTYPE_PetYear:Class = TPetYearConfig;
      
      private static const CLASSTYPE_RedPacketConfig:Class = THDSheepRedPacketConfig;
      
      private static const CLASSTYPE_Firecrackers:Class = TFirecrackersConfig;
      
      private static const CLASSTYPE_SheepGoodSell:Class = THDSheepGoodSell;
      
      private static const CLASSTYPE_Feedback:Class = THDFeedbackConfig;
      
      private static const CLASSTYPE_TimeLimitTurntable:Class = THDTimeLimitTurntableConfig;
      
      private static const CLASSTYPE_DayBack:Class = THDDayBackConfig;
      
      private static const CLASSTYPE_OrgPointAward:Class = TOrgPointAward;
      
      private static const CLASSTYPE_WakeUpEquip:Class = TWakeUpEquip;
      
      private static const CLASSTYPE_WakeUp:Class = TWakeUp;
      
      private static const CLASSTYPE_CompanionCard:Class = TCompanionCard;
      
      private static const CLASSTYPE_CompanionChip:Class = TCompanionChip;
      
      private static const CLASSTYPE_CompanionEncounter:Class = TCompanionEncounter;
      
      private static const CLASSTYPE_GrowthPlan:Class = THDGrowthPlanConfig;
      
      private static const CLASSTYPE_BleachBag:Class = THDBleachBagConfig;
      
      private static const CLASSTYPE_Gallery:Class = THDGallery;
      
      private static const CLASSTYPE_DailyHero:Class = THDDailyHero;
      
      private static const CLASSTYPE_Pyramid:Class = THDPyramid;
      
      private static const CLASSTYPE_RushInSeireitei:Class = THDRushInSeireitei;
      
      private static const CLASSTYPE_RelatedPartnerPoint:Class = TRelatedPartnerPoint;
      
      private static const CLASSTYPE_RelatedPartner:Class = TRelatedPartner;
      
      private static const CLASSTYPE_RelatedPartnerType:Class = TRelatedPartnerType;
      
      private static const CLASSTYPE_RelatedCondition:Class = TRelatedCondition;
      
      private static const CLASSTYPE_AstrologyConfig:Class = THDAstrologyConfig;
      
      private static const CLASSTYPE_KnifeHeroCollect:Class = THDKnifeHeroCollect;
      
      private static const CLASSTYPE_CoolSummer:Class = THDCoolSummer;
      
      private static const CLASSTYPE_EveryDayAward:Class = THDEveryDayAward;
      
      private static const CLASSTYPE_NightmareTrialConfig:Class = TNightmareTrialConfig;
      
      private static const CLASSTYPE_NightmareTrialCity:Class = TNightmareTrialCityConfig;
      
      private static const CLASSTYPE_NightmareTrialPoint:Class = TNightmareTrialPointConfig;
      
      private static const CLASSTYPE_FirstPayBag:Class = THDFirstPayBagConfig;
      
      private static const CLASSTYPE_BrushHappy:Class = THDBrushHappy;
      
      private static const CLASSTYPE_KnifeStrengExp:Class = TKnifeStrengExp;
      
      private static const CLASSTYPE_KnifeStrengthen:Class = TKnifeStrengthen;
      
      private static const CLASSTYPE_LeaderWakeUp:Class = TLeaderWakeUp;
      
      private static const CLASSTYPE_NewServerDraw:Class = THDNewServerDraw;
      
      private static const CLASSTYPE_NewHalloweenGame:Class = THDNewHalloweenGameConfig;
      
      private static const CLASSTYPE_NewHalloweenRecharge:Class = THDNewHalloweenRecharge;
      
      private static const CLASSTYPE_NewHalloweenConsume:Class = THDNewHalloweenConsume;
      
      private static const CLASSTYPE_ThankYou:Class = THDThankYou;
      
      private static const CLASSTYPE_ThanksFeast:Class = THDThanksFeast;
      
      private static const CLASSTYPE_ThanksTreasure:Class = THDThanksTreasure;
      
      private static const CLASSTYPE_ExpDuplicate:Class = TExpDuplicate;
      
      private static const CLASSTYPE_Christmas2015Tree:Class = THDChrismasRecharge;
      
      private static const CLASSTYPE_SnowBattle:Class = THDSnowBattle;
      
      private static const CLASSTYPE_Sock:Class = THDChristmasSock;
      
      private static const CLASSTYPE_Sled:Class = THDSled;
      
      private static const CLASSTYPE_CustomHeros:Class = TCustomHeroInfo;
      
      private static const CLASSTYPE_CustomHeroExp:Class = TCustomHeroExp;
      
      private static const CLASSTYPE_SoulCollectionRnd:Class = TSoulCollectionRnd;
      
      private static const CLASSTYPE_SoulCollectionShop:Class = TSoulCollectionShop;
      
      private static const CLASSTYPE_SoulCollectionBase:Class = TSoulCollectionBase;
      
      private static const CLASSTYPE_Check:Class = THDNewYear2016Check;
      
      private static const CLASSTYPE_Nian:Class = THDNewYear2016Nian;
      
      private static const CLASSTYPE_Pocket:Class = THDNewYear2016Pocket;
      
      private static const CLASSTYPE_NewYearFund:Class = THDNewYear2016Fund;
      
      private static const CLASSTYPE_NewYearChess:Class = THDNewYear2016Chess;
      
      private static const CLASSTYPE_Easter2016_0:Class = THDEaster2016_0;
      
      private static const CLASSTYPE_Easter2016_1:Class = THDEaster2016_1;
      
      private static const CLASSTYPE_Easter2016_2:Class = THDEaster2016_2;
      
      private static const CLASSTYPE_GhostKingForg:Class = THDGhostKingForg;
      
      private static const CLASSTYPE_LaborCultivation:Class = THDLaborDayCultivation;
      
      private static const CLASSTYPE_LaborDayPet:Class = THDLaborDayPet;
      
      private static const CLASSTYPE_LaborConsume:Class = THDLaborConsume;
      
      private static const CLASSTYPE_DuanwujiePet:Class = THDDuanwujiePet;
      
      private static const CLASSTYPE_DuanwujieBoat:Class = THDDuanwujieBoat;
      
      private static const CLASSTYPE_TreasureHunt:Class = THDTreasureHunt;
      
      private static const CLASSTYPE_TreasureShop:Class = THDTreasureHuntShop;
      
      private static const CLASSTYPE_SoulDraw:Class = THDSoulDraw;
      
      private static const CLASSTYPE_SoulBuy:Class = THDSoulBuy;
      
      private static const CLASSTYPE_SoulRecharge:Class = THDSoulRecharge;
      
      private static const CLASSTYPE_EquipForge:Class = TConfigEquipForge;
      
      private static const CLASSTYPE_EquipAdvance:Class = TConfigEquipAdvance;
      
      private static const CLASSTYPE_KnifeChessRecharge:Class = THDKnifeChessRecharge;
      
      private static const CLASSTYPE_KnifeChessBuy:Class = THDKnifeChessBuy;
      
      private static const CLASSTYPE_AdvanceChange:Class = TPantnerAdvanceChange;
      
      private static const CLASSTYPE_NationalDayOne:Class = THDNationalDayOne;
      
      private static const CLASSTYPE_NationalDayTwo:Class = THDNationalDayTwo;
      
      private static const CLASSTYPE_HalloweenVip:Class = THDHalloweenVip;
      
      private static const CLASSTYPE_HalloweenRoundShop:Class = THDHalloweenShop;
      
      private static const CLASSTYPE_ThanksGivingDay2016One:Class = THDTGD_1;
      
      private static const CLASSTYPE_ThanksGivingDay2016Two:Class = THDTGD_2;
      
      private static const CLASSTYPE_ThanksGivingDay2016Three:Class = THDTGD_3;
      
      private static const CLASSTYPE_NewYear2017Task:Class = THDNewYear2017Task;
      
      private static const CLASSTYPE_NewYear2017Bags:Class = THDNewYear2017Bags;
      
      private static const CLASSTYPE_NewYear2017Discount:Class = THDNewYear2017Discount;
      
      private static const CLASSTYPE_FoolsDayRecharge:Class = THDFoolsDayRecharge;
      
      private static const CLASSTYPE_FoolsDayShop:Class = THDFoolsDayShop;
      
      private static const CLASSTYPE_ChildrenDayShop:Class = THDChildrenDayShop;
      
      private static const CLASSTYPE_ChildrenDayHero:Class = THDChildrenDayHero;
      
      private static const CLASSTYPE_ChildrenDayCollect:Class = THDChildrenDayCollect;
      
      private static const CLASSTYPE_AnniversaryOne:Class = THDAnniversaryOne;
      
      private static const CLASSTYPE_AnniversaryTwo:Class = THDAnniversaryTwo;
      
      private static const CLASSTYPE_AnniversaryThree:Class = THDAnniversaryThree;
      
      private static const CLASSTYPE_NationalDayOne2017:Class = THDNationalDayOne2017;
      
      private static const CLASSTYPE_NationalDayTwo2017:Class = THDNationalDayTwo2017;
      
      private static const CLASSTYPE_NationalDayThree2017:Class = THDNationalDayThree2017;
      
      private static const CLASSTYPE_ProfessionRefine:Class = TProfessionRefineAVO;
      
      public static const CLASSTYPE_NAMES:Vector.<Class> = Vector.<Class>([CLASSTYPE_HDActivity,CLASSTYPE_Article,CLASSTYPE_Award,CLASSTYPE_BaseEquip,CLASSTYPE_BaseHero,CLASSTYPE_KnifeSoul,CLASSTYPE_BaseStone,CLASSTYPE_BlockPoint,CLASSTYPE_BuffEffect,CLASSTYPE_BuildConsume,CLASSTYPE_BuildValue,CLASSTYPE_BuyMoney,CLASSTYPE_ChannelChet,CLASSTYPE_City,CLASSTYPE_ConfigValue,CLASSTYPE_DailyActivity,CLASSTYPE_DailyAward,CLASSTYPE_DailyTask,CLASSTYPE_DialogueScript,CLASSTYPE_Digging,CLASSTYPE_Enemy,CLASSTYPE_EnemyArmy,CLASSTYPE_EquipAdditional,CLASSTYPE_EquipGenerate,CLASSTYPE_EquipUpgrade,CLASSTYPE_ErrorCode,CLASSTYPE_Exchange_ExpCard,CLASSTYPE_HeroExp,CLASSTYPE_HeroReplacement,CLASSTYPE_HeroTalent,CLASSTYPE_Mall,CLASSTYPE_Map,CLASSTYPE_Maskword,CLASSTYPE_Military,CLASSTYPE_MusicConfig,CLASSTYPE_FunctionSwitch,CLASSTYPE_TemplePliesNumber,CLASSTYPE_FreshGuide,CLASSTYPE_NPC,CLASSTYPE_OrganizationAddition,CLASSTYPE_OrganizationBase,CLASSTYPE_OrganizationDevotion,CLASSTYPE_PopTips,CLASSTYPE_Post,CLASSTYPE_RaidersDailyConfig
      ,CLASSTYPE_RandomName,CLASSTYPE_RankComposeQuality,CLASSTYPE_RankExpendCost,CLASSTYPE_RankMoney,CLASSTYPE_RankReward,CLASSTYPE_RecommendStone,CLASSTYPE_RoleModel,CLASSTYPE_ServenStar,CLASSTYPE_ServenStarExp,CLASSTYPE_SignReward,CLASSTYPE_Single,CLASSTYPE_SinglePointPath,CLASSTYPE_SingleResetCharge,CLASSTYPE_SkillConfig,CLASSTYPE_StarMap,CLASSTYPE_StarPoint,CLASSTYPE_StarPointDesc,CLASSTYPE_Suit,CLASSTYPE_SystemLanguage,CLASSTYPE_Task,CLASSTYPE_TaskDramaDialogue,CLASSTYPE_Tavern_Grade,CLASSTYPE_Tavern_PayConfig,CLASSTYPE_Tavern_Warrior,CLASSTYPE_TreasureLevelup,CLASSTYPE_TreasureUpgrade,CLASSTYPE_VipConfig,CLASSTYPE_SoulSkill,CLASSTYPE_MagicStone,CLASSTYPE_WeaponSkillConfig,CLASSTYPE_Knife,CLASSTYPE_KnifeExpand,CLASSTYPE_RecommandHero,CLASSTYPE_SlaveGainExp,CLASSTYPE_SlaveMessage,CLASSTYPE_SlaveBleed,CLASSTYPE_HomeLevel,CLASSTYPE_Butterfly,CLASSTYPE_ButterflyFeeding,CLASSTYPE_HomeGirlFriend,CLASSTYPE_HomeGirlAward,CLASSTYPE_HomeGirlInteract,CLASSTYPE_HomeGamble,CLASSTYPE_HomeGambleCost,CLASSTYPE_HomeGambleBox
      ,CLASSTYPE_HomeSoulAward,CLASSTYPE_HomeFortune,CLASSTYPE_HomeGirlMood,CLASSTYPE_AutoActivityGain,CLASSTYPE_SevenHeroLittleStar,CLASSTYPE_SevenHeroStar,CLASSTYPE_SevenHeroArmy,CLASSTYPE_SevenHeroDailyAward,CLASSTYPE_SevenHeroSoul,CLASSTYPE_HDIcon,CLASSTYPE_HDArenaRank,CLASSTYPE_HDCampBattle,CLASSTYPE_HDKillHero,CLASSTYPE_HDLevelRank,CLASSTYPE_HDPowerRank,CLASSTYPE_HDRecruitPartner,CLASSTYPE_HDGBOnline,CLASSTYPE_HDGBGold,CLASSTYPE_HDGBSevenDay,CLASSTYPE_HDGBOpenServer,CLASSTYPE_HDGBCollectGame,CLASSTYPE_HDSinglePay,CLASSTYPE_HDTotalPay,CLASSTYPE_HDDailyPay,CLASSTYPE_HDTotalCost,CLASSTYPE_HDDailyCost,CLASSTYPE_HDVipBox,CLASSTYPE_HDFirstPay,CLASSTYPE_YDGiftBagDailyBag,CLASSTYPE_YDGiftBagGrowBag,CLASSTYPE_YDGiftBagLevelBag,CLASSTYPE_YDGiftBagFreshBag,CLASSTYPE_YDBuyGold,CLASSTYPE_HDDailyTotalPay,CLASSTYPE_HDDailyTotalCost,CLASSTYPE_SoundConfig,CLASSTYPE_HDEquipCollection,CLASSTYPE_HDMilitary,CLASSTYPE_HDStone,CLASSTYPE_HDTreasure,CLASSTYPE_HDGrowFundLv,CLASSTYPE_HDGrowFundGamble,CLASSTYPE_HDGrowFundShop
      ,CLASSTYPE_Achievement,CLASSTYPE_AchievementGroup,CLASSTYPE_AchievementClass,CLASSTYPE_AchievementTitle,CLASSTYPE_SuperTreasure,CLASSTYPE_HDChristmas,CLASSTYPE_HDCityDefence,CLASSTYPE_HDGroupLv,CLASSTYPE_HDGroupWar,CLASSTYPE_HDPetSoulDefence,CLASSTYPE_HDPay,CLASSTYPE_LeagueMapPve,CLASSTYPE_LeagueMapPvp,CLASSTYPE_NewYear,CLASSTYPE_Espada,CLASSTYPE_OrnamentValue,CLASSTYPE_OrnamentUpgrade,CLASSTYPE_LeaguePointPath,CLASSTYPE_LeagueAction,CLASSTYPE_HDExchangeChip,CLASSTYPE_Beauty,CLASSTYPE_BeautifulClothes,CLASSTYPE_HDSinglePayTime,CLASSTYPE_HDChineseYearSignIn,CLASSTYPE_HDDoubleFish,CLASSTYPE_HDChineseYearLukia,CLASSTYPE_GirlsRecommend,CLASSTYPE_GirlQuestion,CLASSTYPE_GirlsStrategy,CLASSTYPE_HDMoneyPenny,CLASSTYPE_GrowRoadDayTask,CLASSTYPE_GrowRoadTask,CLASSTYPE_GrowRoadGift,CLASSTYPE_HDGambling,CLASSTYPE_HDLimitBuy,CLASSTYPE_HDIceHeros,CLASSTYPE_TemplePoint,CLASSTYPE_TemplePVP,CLASSTYPE_TempleValue,CLASSTYPE_GSPVPDailyAward,CLASSTYPE_GSPVP_Reward,CLASSTYPE_TeamMemberExpand,CLASSTYPE_HDTeamBuy
      ,CLASSTYPE_HDJigsaw,CLASSTYPE_HDGBLevel,CLASSTYPE_HDBigTurnTable,CLASSTYPE_HDOrderReward,CLASSTYPE_TDrillHole,CLASSTYPE_HDServerPay,CLASSTYPE_CrashedJade,CLASSTYPE_DailyGetBackReward,CLASSTYPE_DailyWelfareReward,CLASSTYPE_CrashedJadeKind,CLASSTYPE_HDRandCard,CLASSTYPE_SpiritSchool,CLASSTYPE_SpiritSchoolExp,CLASSTYPE_HDBeachJigsaw,CLASSTYPE_HDTreasureShop,CLASSTYPE_HDChess,CLASSTYPE_HDWorldCup,CLASSTYPE_HDHerosMarket,CLASSTYPE_PartnerChange,CLASSTYPE_ChangeHeroPoint,CLASSTYPE_BlackMarket,CLASSTYPE_HeroChangeAttr,CLASSTYPE_HDLottery,CLASSTYPE_MainPetRankUp,CLASSTYPE_PetFamilyBag,CLASSTYPE_PetLevelUp,CLASSTYPE_VicePetMake,CLASSTYPE_VicePetRankUp,CLASSTYPE_VicePetTrain,CLASSTYPE_JoyfunPay,CLASSTYPE_HDPartner,CLASSTYPE_HDLuckyJoy,CLASSTYPE_FighterDetail,CLASSTYPE_SwiftChange,CLASSTYPE_PrivilegeLease,CLASSTYPE_TimeHero,CLASSTYPE_HalloweenPay,CLASSTYPE_HalloweenTree,CLASSTYPE_HalloweenPumpkin,CLASSTYPE_HalloweenShop,CLASSTYPE_OrgPointInfo,CLASSTYPE_CircleTrial,CLASSTYPE_CircleHero,CLASSTYPE_KingLegend
      ,CLASSTYPE_KingGuard,CLASSTYPE_ChiristmasGift,CLASSTYPE_ChristmasWish,CLASSTYPE_ChristmasCarnival,CLASSTYPE_NewYearLuckEgg,CLASSTYPE_NewYearFly,CLASSTYPE_UniteTask,CLASSTYPE_DreamsComeTrue,CLASSTYPE_PetYear,CLASSTYPE_RedPacketConfig,CLASSTYPE_Firecrackers,CLASSTYPE_SheepGoodSell,CLASSTYPE_TimeLimitTurntable,CLASSTYPE_Feedback,CLASSTYPE_DayBack,CLASSTYPE_GrowthPlan,CLASSTYPE_SheepGoodSell,CLASSTYPE_BleachBag,CLASSTYPE_OrgPointAward,CLASSTYPE_WakeUpEquip,CLASSTYPE_WakeUp,CLASSTYPE_CompanionCard,CLASSTYPE_CompanionChip,CLASSTYPE_CompanionEncounter,CLASSTYPE_RelatedPartner,CLASSTYPE_RelatedPartnerType,CLASSTYPE_RelatedCondition,CLASSTYPE_RelatedPartnerPoint,CLASSTYPE_Gallery,CLASSTYPE_DailyHero,CLASSTYPE_Pyramid,CLASSTYPE_RushInSeireitei,CLASSTYPE_AstrologyConfig,CLASSTYPE_KnifeHeroCollect,CLASSTYPE_CoolSummer,CLASSTYPE_EveryDayAward,CLASSTYPE_NightmareTrialConfig,CLASSTYPE_NightmareTrialCity,CLASSTYPE_NightmareTrialPoint,CLASSTYPE_FirstPayBag,CLASSTYPE_KnifeStrengExp,CLASSTYPE_KnifeStrengthen
      ,CLASSTYPE_LeaderWakeUp,CLASSTYPE_BrushHappy,CLASSTYPE_NewServerDraw,CLASSTYPE_NewHalloweenGame,CLASSTYPE_NewHalloweenRecharge,CLASSTYPE_NewHalloweenConsume,CLASSTYPE_ThankYou,CLASSTYPE_ThanksFeast,CLASSTYPE_ThanksTreasure,CLASSTYPE_ExpDuplicate,CLASSTYPE_SnowBattle,CLASSTYPE_Christmas2015Tree,CLASSTYPE_Sock,CLASSTYPE_Sled,CLASSTYPE_CustomHeros,CLASSTYPE_CustomHeroExp,CLASSTYPE_SoulCollectionRnd,CLASSTYPE_SoulCollectionShop,CLASSTYPE_SoulCollectionBase,CLASSTYPE_Check,CLASSTYPE_Nian,CLASSTYPE_Pocket,CLASSTYPE_NewYearFund,CLASSTYPE_NewYearChess,CLASSTYPE_Easter2016_0,CLASSTYPE_Easter2016_1,CLASSTYPE_Easter2016_2,CLASSTYPE_GhostKingForg,CLASSTYPE_LaborCultivation,CLASSTYPE_LaborDayPet,CLASSTYPE_LaborConsume,CLASSTYPE_DuanwujiePet,CLASSTYPE_DuanwujieBoat,CLASSTYPE_TreasureHunt,CLASSTYPE_TreasureShop,CLASSTYPE_SoulDraw,CLASSTYPE_SoulBuy,CLASSTYPE_SoulRecharge,CLASSTYPE_EquipForge,CLASSTYPE_EquipAdvance,CLASSTYPE_KnifeChessRecharge,CLASSTYPE_KnifeChessBuy,CLASSTYPE_AdvanceChange,CLASSTYPE_NationalDayOne
      ,CLASSTYPE_NationalDayTwo,CLASSTYPE_HalloweenVip,CLASSTYPE_HalloweenRoundShop,CLASSTYPE_ThanksGivingDay2016One,CLASSTYPE_ThanksGivingDay2016Two,CLASSTYPE_ThanksGivingDay2016Three,CLASSTYPE_NewYear2017Task,CLASSTYPE_NewYear2017Bags,CLASSTYPE_NewYear2017Discount,CLASSTYPE_FoolsDayRecharge,CLASSTYPE_FoolsDayShop,CLASSTYPE_ChildrenDayShop,CLASSTYPE_ChildrenDayHero,CLASSTYPE_ChildrenDayCollect,CLASSTYPE_AnniversaryOne,CLASSTYPE_AnniversaryTwo,CLASSTYPE_AnniversaryThree,CLASSTYPE_NationalDayOne2017,CLASSTYPE_NationalDayTwo2017,CLASSTYPE_NationalDayThree2017,CLASSTYPE_ProfessionRefine]);
      
      public function CONST_DATEBASEVO()
      {
         super();
      }
   }
}

