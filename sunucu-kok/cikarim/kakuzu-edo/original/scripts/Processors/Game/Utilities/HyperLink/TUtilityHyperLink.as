package Processors.Game.Utilities.HyperLink
{
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TUtilityHyperLink
   {
      
      public static const HyperLink_Strengthen:uint = 1;
      
      public static const HyperLink_Military:uint = 2;
      
      public static const HyperLink_TacticalDeployment:uint = 3;
      
      public static const HyperLink_Star:uint = 4;
      
      public static const HyperLink_Backpack:uint = 5;
      
      public static const HyperLink_HellButterfly:uint = 6;
      
      public static const HyperLink_Organization:uint = 7;
      
      public static const HyperLink_KnifeSoul:uint = 8;
      
      public static const HyperLink_Friend:uint = 9;
      
      public static const HyperLink_Heros:uint = 10;
      
      public static const HyperLink_Arena:uint = 11;
      
      public static const HyperLink_Tavern:uint = 12;
      
      public static const HyperLink_Instance:uint = 13;
      
      public static const HyperLink_WorldMap:uint = 14;
      
      public static const HyperLink_Treasure:uint = 15;
      
      public static const HyperLink_Jade:uint = 16;
      
      public static const HyperLink_TreasureMap:uint = 17;
      
      public static const HyperLink_Sign:uint = 18;
      
      public static const HyperLink_DailyQuest:uint = 19;
      
      public static const HyperLink_Mall:uint = 20;
      
      public static const HyperLink_MakeEquip:uint = 21;
      
      public static const HyperLink_DailyActivity:uint = 22;
      
      public static const HyperLink_Slave:uint = 23;
      
      public static const HyperLink_SkyTower:uint = 24;
      
      public static const HyperLink_Achievement:uint = 25;
      
      public static const HyperLink_SevenHeroMap:uint = 26;
      
      public static const HyperLink_SevenKing:uint = 27;
      
      public static const HyperLink_GongFuFight:uint = 28;
      
      public static const HyperLink_VIP:uint = 29;
      
      public static const HyperLink_ReturnCity:uint = 30;
      
      public static const HyperLink_Home:uint = 31;
      
      public static const HyperLink_GirlFriend:uint = 32;
      
      public static const HyperLink_Gamble:uint = 33;
      
      public static const HyperLink_TeamBattle:uint = 34;
      
      public static const HyperLink_GirlGame:uint = 35;
      
      public static const HyperLink_KillHeros:uint = 36;
      
      public static const HyperLink_OrnamentStrengthen:uint = 37;
      
      public static const HyperLink_KnifeOfKillSoul:uint = 38;
      
      public static const HyperLink_OfficeLady:uint = 39;
      
      public static const HyperLink_SuperMarket:uint = 40;
      
      public static const HyperLink_LevelGiftBag:uint = 41;
      
      public static const HyperLink_ChangeHero:uint = 42;
      
      public static const HyperLink_SpeicalFighter:uint = 43;
      
      public static const HyperLink_Pet:uint = 44;
      
      public static const HyperLink_VainTravel:uint = 45;
      
      public static const HyperLink_RelatedPartner:uint = 46;
      
      public static const HyperLink_NightmareTrial:uint = 47;
      
      public static const HyperLink_ExpDuplicate:uint = 48;
      
      public static const HyperLink_ChangeInfo:uint = 49;
      
      public static const HyperLink_CustomHero:uint = 50;
      
      public static const HyperLink_Collectsoul:uint = 51;
      
      public static const HyperLink_Rebirth:uint = 52;
      
      public static const HyperLink_Smelt:uint = 53;
      
      public static const HyperLink_KingChallenge:uint = 54;
      
      public static const HyperLink_ProfessionRefine:uint = 55;
      
      protected var FOnHyperLink:Function;
      
      protected var FOnHyperLinkEx:Function;
      
      public function TUtilityHyperLink()
      {
         super();
      }
      
      public function set OnHyperLink(param1:Function) : void
      {
         this.FOnHyperLink = param1;
      }
      
      public function set OnHyperLinkEx(param1:Function) : void
      {
         this.FOnHyperLinkEx = param1;
      }
      
      public function ShortcutHyperlink(param1:uint, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc6_ = -1;
         _loc7_ = -1;
         switch(param1)
         {
            case HyperLink_ChangeInfo:
               if(this.FOnHyperLinkEx != null)
               {
                  this.FOnHyperLinkEx(param1,param2,param3);
               }
               return;
            case HyperLink_Strengthen:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Strengthen);
               _loc6_ = param2;
               break;
            case HyperLink_Military:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Avatar);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Avatar_Military);
               _loc6_ = int(CONST_SHORTCUTS.TYPE_Avatar_Military);
               break;
            case HyperLink_TacticalDeployment:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_TacticalDeployment);
               _loc6_ = param2;
               break;
            case HyperLink_Star:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Star);
               _loc6_ = param2;
               _loc7_ = param3;
               break;
            case HyperLink_Backpack:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Backpack);
               break;
            case HyperLink_HellButterfly:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Home);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Home_HellButterfly);
               _loc6_ = int(CONST_SHORTCUTS.TYPE_Home_HellButterfly);
               break;
            case HyperLink_Organization:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Organization);
               _loc6_ = param2;
               _loc7_ = param3;
               break;
            case HyperLink_KnifeSoul:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Avatar);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Avatar_KnifeSoul);
               break;
            case HyperLink_Friend:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Map);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Map_Friend);
               break;
            case HyperLink_Heros:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Heros);
               _loc6_ = param2;
               break;
            case HyperLink_Arena:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_Arena);
               break;
            case HyperLink_Tavern:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_NPC);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_NPC_Tavern);
               break;
            case HyperLink_Instance:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Map);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Map_EnterWorldMap);
               break;
            case HyperLink_WorldMap:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Map);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Map_EnterWorldMap);
               break;
            case HyperLink_Treasure:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_Treasure);
               break;
            case HyperLink_Jade:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_NPC);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_NPC_Jade);
               break;
            case HyperLink_TreasureMap:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TreasureMap);
               break;
            case HyperLink_Sign:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign);
               break;
            case HyperLink_DailyQuest:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest);
               break;
            case HyperLink_Mall:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunction_Mall);
               break;
            case HyperLink_MakeEquip:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_NPC);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_NPC_MakeEquip);
               break;
            case HyperLink_DailyActivity:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyActivity);
               break;
            case HyperLink_Slave:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Home);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Home_Slave);
               break;
            case HyperLink_SkyTower:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_SkyTower);
               break;
            case HyperLink_Achievement:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Achievement);
               break;
            case HyperLink_SevenHeroMap:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_SevenHeroMap);
               break;
            case HyperLink_SevenKing:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_SevenKing);
               break;
            case HyperLink_GongFuFight:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_GongFuFight);
               break;
            case HyperLink_VIP:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Avatar);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Avatar_VIP);
               break;
            case HyperLink_ReturnCity:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_ReturnCity);
               break;
            case HyperLink_Home:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction_Special);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Function_Special_Home);
               break;
            case HyperLink_GirlFriend:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Home);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Home_GirlFriend);
               _loc6_ = param2;
               break;
            case HyperLink_Gamble:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Home);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Home_Gamble);
               break;
            case HyperLink_TeamBattle:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TeamBattle);
               break;
            case HyperLink_GirlGame:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_Constantly);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_Constantly_GirlGame);
               break;
            case HyperLink_KillHeros:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_KillHeros);
               break;
            case HyperLink_OrnamentStrengthen:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_OrnamentStrengthen);
               break;
            case HyperLink_KnifeOfKillSoul:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_KnifeOfKillSoul);
               _loc6_ = param2;
               break;
            case HyperLink_OfficeLady:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionC);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionC_OfficeLady);
               break;
            case HyperLink_SuperMarket:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionC);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionC_SuperMarket);
               break;
            case HyperLink_LevelGiftBag:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_ActiveListSecondary);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_ActiveListSecondary_LevelGiftBag);
               break;
            case HyperLink_ChangeHero:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_HeroChange);
               break;
            case HyperLink_SpeicalFighter:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_SpecialFight);
               break;
            case HyperLink_Pet:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunction_Pet);
               break;
            case HyperLink_Rebirth:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunction_Rebirth);
               break;
            case HyperLink_KingChallenge:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunction_KingChallenge);
               break;
            case HyperLink_Smelt:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunction_Smelt);
               break;
            case HyperLink_VainTravel:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_VainTravel);
               break;
            case HyperLink_RelatedPartner:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_RelatedPartner);
               break;
            case HyperLink_NightmareTrial:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionB);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionB_NightmareTrial);
               break;
            case HyperLink_ExpDuplicate:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_ExpDuplicate);
               break;
            case HyperLink_CustomHero:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CustomHero);
               break;
            case HyperLink_Collectsoul:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_SecondaryFunctionA);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CollectSoul);
               break;
            case HyperLink_ProfessionRefine:
               _loc4_ = int(CONST_SHORTCUTS.POSITION_MainFunction);
               _loc5_ = int(CONST_SHORTCUTS.TYPE_MainFunction_ProfessionRefine);
               _loc6_ = param2;
         }
         if(_loc6_ == -1 && _loc7_ == -1)
         {
            if(this.FOnHyperLink != null)
            {
               this.FOnHyperLink(this,_loc4_,_loc5_);
            }
         }
         else if(_loc6_ != -1 && _loc7_ == -1)
         {
            if(this.FOnHyperLink != null)
            {
               this.FOnHyperLink(this,_loc4_,_loc5_,_loc6_);
            }
         }
         else if(_loc7_ != -1 && _loc6_ == -1)
         {
            if(this.FOnHyperLink != null)
            {
               this.FOnHyperLink(this,_loc4_,_loc5_,_loc7_);
            }
         }
         else if(this.FOnHyperLink != null)
         {
            this.FOnHyperLink(this,_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
   }
}

