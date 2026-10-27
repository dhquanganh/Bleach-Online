package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Organization.VO.TEnemyVO;
   import Logics.Organization.VO.TOrgCopyVO;
   import Logics.Organization.VO.TPointInfoVO;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.Items.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowBarrierChoose extends TProcessorLobbyWindow
   {
      
      protected static const OffsetY:int = -40;
      
      protected static const MAX_TABCOUNT:uint = 2;
      
      protected static const MAX_ARMYCOUNT:uint = 7;
      
      protected static const MAX_KIDOUCOUNT:uint = 5;
      
      protected static const MAX_AWARDCOUNT:uint = 5;
      
      protected static const MAX_REPORTCOUNT:uint = 5;
      
      protected static const MAX_FORMATIONCOUNT:uint = 3;
      
      protected static const BattleType_Nodal:int = CONST_BATTLE.BattleType_Nodal;
      
      protected static const BattleType_Camp:int = CONST_BATTLE.BattleType_Camp;
      
      protected static const BattleType_KillHero:int = CONST_BATTLE.BattleType_KillHero;
      
      protected static const BattleType_HeroChange:int = CONST_BATTLE.BattleType_HeroChange;
      
      protected static const BattleType_OrgSingle:int = CONST_BATTLE.BattleType_OrgSingle;
      
      protected static const BattleType_OrgGroup:int = CONST_BATTLE.BattleType_OrgGroup;
      
      protected var FMC:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FTF_FirstTitle:TextField;
      
      protected var FTF_SecondTitle:TextField;
      
      protected var FTF_GroupDist:TextField;
      
      protected var FTF_Tired_Desc:TextField;
      
      protected var FTF_Remain_Desc:TextField;
      
      protected var FTF_ActionPoint:TextField;
      
      protected var FTF_Remain:TextField;
      
      protected var FMC_Info:MovieClip;
      
      protected var FMC_SelfArmy:MovieClip;
      
      protected var FMC_OpponentArmy:MovieClip;
      
      protected var FMC_Kidou:MovieClip;
      
      protected var FMC_Award:MovieClip;
      
      protected var FBtn_ChangeTeammate:TUIButton;
      
      protected var FBtn_ChangeSkill:TUIButton;
      
      protected var FBtn_Attack:TUIButton;
      
      protected var FBtn_AutoBattle:TUIButton;
      
      protected var FBtn_Reset:TUIButton;
      
      protected var FTF_Money:TextField;
      
      protected var FTF_Exp:TextField;
      
      protected var FTF_LimitCount:TextField;
      
      protected var FArmyTip:TArmyTip;
      
      protected var FMC_BattleReport:MovieClip;
      
      protected var FMC_Report:MovieClip;
      
      protected var FTF_UserName:TextField;
      
      protected var FTab:TUITab;
      
      protected var FTabIndex:uint;
      
      protected var FTabVect:Vector.<MovieClip>;
      
      protected var FSlot_SelfArmyVect:Vector.<TUISlot>;
      
      protected var FSlot_OpponentArmyVect:Vector.<TUISlot>;
      
      protected var FSlot_AwardVect:Vector.<TUISlot>;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FAwardVect:Vector.<TInventory>;
      
      protected var FRewards:Vector.<TItems>;
      
      protected var UnstreamizerRewards:TUnstreamizerRewards;
      
      protected var FInventories:TInventories;
      
      protected var FNormalChanceDropStr:String;
      
      protected var FNodalAutoMonsterInfo:TNodalAutoMonsterInfo;
      
      protected var FIsInitSlot:Boolean;
      
      protected var FArmySlotNameVect:Vector.<String> = Vector.<String>(["MC_Slot_1","MC_Slot_6","MC_Slot_7","MC_Slot_8","MC_Slot_11","MC_Slot_12","MC_Slot_13"]);
      
      protected var FMC_SlefFormationVect:Vector.<String> = Vector.<String>(["Slef_LogoFront","Slef_LogoMiddle","Slef_LogoAfter"]);
      
      protected var FMC_OppFormationVect:Vector.<String> = Vector.<String>(["Opp_LogoFront","Opp_LogoMiddle","Opp_LogoAfter"]);
      
      protected var FBattleType:int;
      
      protected var FCityID:int;
      
      protected var FBattleID:int;
      
      protected var FNodalModel:TNodal;
      
      protected var FCharacter:TCharacter;
      
      protected var FHeros:THeros;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FRoleModel:TBins;
      
      protected var FCityBins:TBins;
      
      protected var FSingleBins:TBins;
      
      protected var FSinglePointPathBins:TBins;
      
      protected var FBlockPointBins:TBins;
      
      protected var FRaidersDailyConfigBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FChangeHeroPointBins:TBins;
      
      protected var FOrgPointInfoBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FAwardBins:TBins;
      
      protected var FArticleBins:TBins;
      
      protected var FStarPointDesc:TBins;
      
      protected var FHint:THint;
      
      protected var FFormatHint:String;
      
      protected var FOnChangeTeammate:Function;
      
      protected var FOnChangeSkill:Function;
      
      protected var FOnAutoBattle:Function;
      
      protected var FOnBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnOverLayOver:Function;
      
      protected var FOnOverLayOut:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FOnAddPopTips:Function;
      
      protected var FOnReset:Function;
      
      protected var FOnResetMoveCall:Function;
      
      protected var FOnResetOutCall:Function;
      
      public function TProcessorWindowBarrierChoose(param1:TUIComponent)
      {
         super(param1);
         this.FTabIndex = 0;
         this.FTabVect = new Vector.<MovieClip>();
         this.FSlot_AwardVect = new Vector.<TUISlot>();
         this.FAwardVect = new Vector.<TInventory>();
         this.FIDTemplates = new Vector.<uint>();
         this.FInventories = new TInventories();
         this.FCharacter = SLogicsCore.Character;
         this.FNodalModel = SLogicsCore.Nodal;
         this.FPoolCampaign = SLogicsCore.PoolCampaign;
         this.FNodalAutoMonsterInfo = new TNodalAutoMonsterInfo();
         this.FIsInitSlot = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_BarrierChoose);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSinglePointPathBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         this.FChangeHeroPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ChangeHeroPoint);
         this.FOrgPointInfoBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         this.FArticleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FRaidersDailyConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig);
         this.FStarPointDesc = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarPointDesc);
         this.FNormalChanceDropStr = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_38);
         this.InitBarrierChoose();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FIsInitSlot)
         {
            _loc2_ = int(this.FSlot_AwardVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FSlot_AwardVect[_loc1_] != null)
               {
                  this.FSlot_AwardVect[_loc1_].Update();
               }
               _loc1_++;
            }
         }
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.UpdataBitmap();
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnWindowCloseClick,false,0,true);
         _loc2_ = int(MAX_FORMATIONCOUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Info[this.FMC_SlefFormationVect[_loc1_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnFormationMove,false,0,true);
            this.FMC_Info[this.FMC_SlefFormationVect[_loc1_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnFormationOut,false,0,true);
            this.FMC_Info[this.FMC_OppFormationVect[_loc1_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnFormationMove,false,0,true);
            this.FMC_Info[this.FMC_OppFormationVect[_loc1_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnFormationOut,false,0,true);
            _loc1_++;
         }
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitBarrierChoose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Bitmap = null;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_StartBattle) as MovieClip;
         addChild(this.FMC);
         this.FMC.y += OffsetY;
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FTF_FirstTitle = this.FMC[CONST_WORLDMAP.RESOURCE_Link_TF_FirstTitle];
         this.FTF_SecondTitle = this.FMC[CONST_WORLDMAP.RESOURCE_Link_TF_SecondTitle];
         this.FTabVect.push(this.FMC[CONST_COMMON.RESOURCE_Link_MC_Tab + 0]);
         this.FTabVect.push(this.FMC[CONST_COMMON.RESOURCE_Link_MC_Tab + 1]);
         this.FMC_Info = this.FMC[CONST_WORLDMAP.RESOURCE_Link_MC_Info];
         this.FMC_BattleReport = this.FMC[CONST_WORLDMAP.RESOURCE_Link_MC_BattleReport];
         this.FTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < MAX_TABCOUNT)
         {
            this.FTab.SetTabByIndex(this.FTabVect[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FTab.SetTabHideByIndex(1);
         this.FTab.OnSwitch = this.ChangeTabOnSwitch;
         this.FTab.Init();
         this.FMC_SelfArmy = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Teammate];
         this.FMC_OpponentArmy = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Opponent];
         this.FMC_Kidou = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Kidou];
         this.FMC_Award = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Award];
         this.FBtn_ChangeTeammate = new TUIButton();
         this.FBtn_ChangeTeammate.Substrate = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_Btn_ChangeTeammate];
         this.FBtn_ChangeTeammate.OnClick = this.OnChangeTeammateHandler;
         this.FBtn_ChangeSkill = new TUIButton();
         this.FBtn_ChangeSkill.Substrate = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_Btn_ChangeSkill];
         this.FBtn_ChangeSkill.OnClick = this.OnChangeSkillHandler;
         this.FBtn_AutoBattle = new TUIButton();
         this.FBtn_AutoBattle.Substrate = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_Btn_AutoBattle];
         this.FBtn_AutoBattle.OnClick = this.OnAutoBattleHandler;
         this.FBtn_Reset = new TUIButton();
         this.FBtn_Reset.Substrate = this.FMC_Info["Btn_Reset"];
         this.FBtn_Reset.OnClick = this.OnBtnResetHandler;
         this.FBtn_Reset.OnMove = this.OnResetMove;
         this.FBtn_Reset.OnOut = this.OnResetOut;
         this.FBtn_Attack = new TUIButton();
         this.FBtn_Attack.Substrate = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_Btn_Battle];
         this.FBtn_Attack.OnClick = this.OnAttackHandler;
         this.FTF_ActionPoint = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_TF_Tired];
         this.FTF_Remain = this.FMC_Info["TF_Remain"];
         this.FTF_GroupDist = this.FMC_Info["TF_GroupDist"];
         this.FTF_Tired_Desc = this.FMC_Info["TF_Tired_Desc"];
         this.FTF_Remain_Desc = this.FMC_Info["TF_Remain_Desc"];
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_StartBattleView,this.FBtn_Attack);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_StartBattleView,FParent);
         _loc1_ = 0;
         while(_loc1_ < MAX_REPORTCOUNT)
         {
            _loc4_ = this.FMC_BattleReport[CONST_WORLDMAP.RESOURCE_Link_MC_Report + _loc1_];
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_ARMYCOUNT)
         {
            _loc5_ = new Bitmap();
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]].HeroID = _loc1_;
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]]["MC_Bmp_Icon"] = _loc5_;
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]].addChild(_loc5_);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnArmyOver,false,0,true);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnArmyOut,false,0,true);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]].visible = false;
            _loc1_++;
         }
         _loc5_ = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_ARMYCOUNT)
         {
            _loc5_ = new Bitmap();
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]].HeroID = _loc1_;
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]]["MC_Bmp_Icon"] = _loc5_;
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]].addChild(_loc5_);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnArmyOver,false,0,true);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnArmyOut,false,0,true);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_KIDOUCOUNT)
         {
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_AWARDCOUNT)
         {
            _loc4_ = this.FMC_Award[CONST_WORLDMAP.RESOURCE_Link_MC_Slot + _loc1_];
            _loc3_ = new TUISlot(this);
            _loc3_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc3_.Resource = _loc4_;
            _loc3_.OnOver = this.OnSlotOver;
            _loc3_.OnOut = this.OnSlotOut;
            _loc3_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.Init();
            this.FSlot_AwardVect.push(_loc3_);
            _loc1_++;
         }
         this.FArmyTip = new TArmyTip(this);
         this.FArmyTip.Visible = false;
         this.FHint = new THint();
         this.FFormatHint = "<font color=\'#0099ff\'>%0:%1%</font>";
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TRoleModel = null;
         var _loc6_:TItem = null;
         var _loc7_:TInventory = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:TSinglePointPath = null;
         var _loc10_:TRaidersDailyConfig = null;
         var _loc11_:TChangeHeroPoint = null;
         var _loc12_:TOrgPointInfo = null;
         var _loc13_:TPointInfoVO = null;
         var _loc14_:TOrgCopyVO = null;
         var _loc15_:TEnemyArmy = null;
         var _loc16_:TCity = null;
         var _loc17_:TAward = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Vector.<TFixedAward> = null;
         var _loc21_:Vector.<uint> = null;
         var _loc22_:TInventories = null;
         var _loc23_:Vector.<uint> = null;
         var _loc24_:TUnstreamizerInventoryReference = null;
         var _loc25_:int = 0;
         var _loc26_:String = null;
         var _loc27_:Vector.<uint> = null;
         var _loc28_:Vector.<uint> = null;
         var _loc29_:int = 0;
         var _loc30_:TEnemy = null;
         var _loc31_:THero = null;
         var _loc32_:uint = 0;
         var _loc33_:TEnemyVO = null;
         this.UpdateArmyHead();
         _loc4_ = null;
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBattleID) as TBlockPoint;
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc8_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            _loc9_ = this.FSinglePointPathBins.GetDatebaseByIdentifier(this.FBattleID) as TSinglePointPath;
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc9_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            _loc10_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FBattleID) as TRaidersDailyConfig;
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc10_.EnemyArmy[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            _loc11_ = this.FChangeHeroPointBins.GetDatebaseByIdentifier(this.FBattleID) as TChangeHeroPoint;
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc11_.Army[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_OrgSingle || this.FBattleType == BattleType_OrgGroup)
         {
            _loc13_ = SLogicsCore.NewOrgData.CurrentPoint;
            _loc12_ = _loc13_.PointInfo;
            _loc14_ = SLogicsCore.NewOrgData.CurrentCopy;
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc12_.Army.army[0]) as TEnemyArmy;
         }
         _loc27_ = _loc15_.EnemyIdVect;
         _loc28_ = _loc15_.EnemyPosVect;
         _loc1_ = 0;
         while(_loc1_ < MAX_AWARDCOUNT)
         {
            if(this.FSlot_AwardVect[_loc1_] != null)
            {
               this.FSlot_AwardVect[_loc1_].Context = null;
            }
            _loc1_++;
         }
         this.GetAwardData();
         _loc2_ = int(this.FSlot_AwardVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlot_AwardVect[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.FInventories.Count)
            {
               _loc7_ = this.FInventories.GetInventoryByIndex(_loc1_);
               this.FSlot_AwardVect[_loc1_].Context = _loc7_;
               this.FSlot_AwardVect[_loc1_].Update();
            }
            _loc1_++;
         }
         this.FIsInitSlot = true;
         if(this.FBattleType == BattleType_Nodal)
         {
            this.FTF_ActionPoint.text = _loc8_.Spirit.toString();
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            this.FTF_ActionPoint.text = "0";
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            this.FTF_ActionPoint.text = "9";
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            this.FTF_ActionPoint.text = "0";
         }
         else if(this.FBattleType == BattleType_OrgSingle)
         {
            this.FTF_ActionPoint.text = _loc12_.ActionEexertion.toString();
         }
         else if(this.FBattleType == BattleType_OrgGroup)
         {
            this.FTF_ActionPoint.text = "0";
         }
         if(this.FBattleType == BattleType_OrgSingle)
         {
            this.FTF_Remain.text = SLogicsCore.NewOrgData.GetCurrentPointRemainFight().toString();
         }
         _loc16_ = this.FCityBins.GetDatebaseByIdentifier(this.FCityID) as TCity;
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc26_ = _loc8_.Identifier.toString();
            _loc26_ = _loc26_.slice(_loc26_.length - 3);
            _loc25_ = int(_loc26_);
            this.FTF_FirstTitle.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_12),_loc16_.Name);
            this.FTF_SecondTitle.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_13),_loc25_,_loc8_.Name);
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            this.FTF_FirstTitle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_14);
            this.FTF_SecondTitle.text = _loc9_.Name;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            this.FTF_FirstTitle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_15);
            this.FTF_SecondTitle.text = _loc16_.Name;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            this.FTF_FirstTitle.text = "";
            this.FTF_SecondTitle.text = _loc16_.Name;
         }
         else if(this.FBattleType == BattleType_OrgSingle || this.FBattleType == BattleType_OrgGroup)
         {
            this.FTF_FirstTitle.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_12),_loc14_.City.Name);
            this.FTF_SecondTitle.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_13),_loc13_.Index + 1,_loc12_.Name);
         }
         if(this.FBattleType == BattleType_OrgGroup)
         {
            this.FTF_GroupDist.visible = true;
         }
         else
         {
            this.FTF_GroupDist.visible = false;
         }
         _loc23_ = new Vector.<uint>();
         _loc22_ = new TInventories();
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc18_ = int(_loc8_.Armys[0]);
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            _loc18_ = int(_loc9_.Armys[0]);
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            _loc18_ = int(_loc10_.EnemyArmy[0]);
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            _loc18_ = int(_loc11_.Army[0]);
         }
         else if(this.FBattleType == BattleType_OrgSingle)
         {
            _loc19_ = int(_loc12_.ShowRateAward);
         }
         else if(this.FBattleType == BattleType_OrgGroup)
         {
            _loc19_ = int(_loc12_.GuildRateAward);
         }
         if(this.FBattleType != BattleType_OrgSingle && this.FBattleType != BattleType_OrgGroup)
         {
            _loc15_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc18_) as TEnemyArmy;
            _loc19_ = _loc15_.AwardId;
         }
         SToolReward.GetAwardsByAwardID(_loc19_,_loc22_);
         _loc2_ = _loc22_.Count;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            if(_loc1_ + 1 <= _loc2_)
            {
               _loc7_ = _loc22_.GetInventoryByIndex(_loc1_);
               TextField(this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_TF_Award + _loc1_]).text = String(_loc7_.Name + _loc7_.Quantity);
            }
            else
            {
               TextField(this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_TF_Award + _loc1_]).text = "";
            }
            _loc1_++;
         }
         if(this.FBattleType == BattleType_Nodal)
         {
            if(this.FNodalModel.GetMissionStarByID(this.FBattleID) > 0)
            {
               this.FBtn_AutoBattle.Visible = true;
            }
            else
            {
               this.FBtn_AutoBattle.Visible = false;
            }
            this.FBtn_Reset.Visible = false;
            this.FTF_Remain_Desc.visible = false;
            this.FTF_Remain.visible = false;
            this.FTF_Tired_Desc.visible = true;
            this.FTF_ActionPoint.visible = true;
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            this.FBtn_AutoBattle.Visible = false;
            this.FBtn_Reset.Visible = false;
            this.FTF_Remain_Desc.visible = false;
            this.FTF_Remain.visible = false;
            this.FTF_Tired_Desc.visible = true;
            this.FTF_ActionPoint.visible = true;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            this.FBtn_AutoBattle.Visible = false;
            this.FBtn_Reset.Visible = false;
            this.FTF_Remain_Desc.visible = false;
            this.FTF_Remain.visible = false;
            this.FTF_Tired_Desc.visible = true;
            this.FTF_ActionPoint.visible = true;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            this.FBtn_AutoBattle.Visible = false;
            this.FBtn_Reset.Visible = false;
            this.FTF_Remain_Desc.visible = false;
            this.FTF_Remain.visible = false;
            this.FTF_Tired_Desc.visible = true;
            this.FTF_ActionPoint.visible = true;
         }
         else if(this.FBattleType == BattleType_OrgSingle)
         {
            this.FBtn_AutoBattle.Visible = true;
            this.FBtn_AutoBattle.Enabled = _loc13_.Pass;
            this.FBtn_Reset.Visible = true;
            this.FTF_Remain_Desc.visible = true;
            this.FTF_Remain.visible = true;
            this.FTF_Tired_Desc.visible = true;
            this.FTF_ActionPoint.visible = true;
         }
         else if(this.FBattleType == BattleType_OrgGroup)
         {
            this.FBtn_AutoBattle.Visible = false;
            this.FBtn_Reset.Visible = false;
            this.FTF_Remain_Desc.visible = false;
            this.FTF_Remain.visible = false;
            this.FTF_Tired_Desc.visible = false;
            this.FTF_ActionPoint.visible = false;
         }
         _loc2_ = int(this.FArmySlotNameVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]];
            _loc4_.BloodBarBox.visible = false;
            _loc1_++;
         }
         if(this.FBattleType == BattleType_OrgGroup)
         {
            _loc2_ = int(_loc28_.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc32_ = _loc28_[_loc1_];
               _loc33_ = SLogicsCore.NewOrgData.GetEnemyVOByPos(SLogicsCore.NewOrgData.CurrentPoint,_loc32_);
               if(_loc32_ > 0 && _loc33_ != null)
               {
                  _loc4_ = this.FMC_OpponentArmy["MC_Slot_" + _loc32_];
                  _loc4_.BloodBarBox.BloodBar.scaleX = _loc33_.HP / TPointInfoVO.MAXHP;
                  _loc4_.BloodBarBox.visible = true;
                  _loc4_.addChild(_loc4_.BloodBarBox);
               }
               _loc1_++;
            }
         }
      }
      
      protected function GetAwardData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:TBlockPoint = null;
         var _loc5_:TSinglePointPath = null;
         var _loc6_:TRaidersDailyConfig = null;
         var _loc7_:TChangeHeroPoint = null;
         var _loc8_:TOrgPointInfo = null;
         var _loc9_:TUnstreamizerInventoryReference = null;
         var _loc10_:TInventories = null;
         var _loc11_:uint = 0;
         _loc9_ = new TUnstreamizerInventoryReference();
         _loc10_ = new TInventories();
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc4_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBattleID) as TBlockPoint;
            _loc3_ = _loc4_.ShowRateAwardVect;
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            _loc5_ = this.FSinglePointPathBins.GetDatebaseByIdentifier(this.FBattleID) as TSinglePointPath;
            _loc3_ = _loc5_.ShowRateAwardVect;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            _loc6_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FBattleID) as TRaidersDailyConfig;
            _loc3_ = _loc6_.RaiderAwards;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            _loc7_ = this.FChangeHeroPointBins.GetDatebaseByIdentifier(this.FBattleID) as TChangeHeroPoint;
            _loc3_ = _loc7_.ShowRateAward;
         }
         else if(this.FBattleType == BattleType_OrgSingle)
         {
            _loc8_ = SLogicsCore.NewOrgData.CurrentPoint.PointInfo;
            _loc11_ = _loc8_.ShowRateAward;
            _loc10_.Clear();
            SToolReward.GetAwardsByAwardID(_loc11_,_loc10_,true);
         }
         else if(this.FBattleType == BattleType_OrgGroup)
         {
            _loc8_ = SLogicsCore.NewOrgData.CurrentPoint.PointInfo;
            _loc11_ = _loc8_.GuildRateAward;
            _loc10_.Clear();
            SToolReward.GetAwardsByAwardID(_loc11_,_loc10_,true);
         }
         if(this.FBattleType != BattleType_OrgSingle && this.FBattleType != BattleType_OrgGroup)
         {
            _loc10_.Clear();
            _loc9_.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc10_,_loc3_);
         }
         this.FInventories = _loc10_;
      }
      
      protected function SelfArmyPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:MovieClip = null;
         this.FHeros = this.FCharacter.Heros;
         _loc5_ = this.FHeros.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = null;
            _loc6_ = this.FHeros.GetHeroByIndex(_loc4_);
            if(_loc6_.FightPosition > 0)
            {
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc6_.Identifier) as TRoleModel;
               if(_loc7_.RoleHead == param3)
               {
                  _loc8_ = this.FMC_SelfArmy["MC_Slot_" + _loc6_.FightPosition];
                  _loc8_["MC_Bmp_Icon"].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  _loc8_.visible = true;
               }
            }
            _loc4_++;
         }
      }
      
      protected function EnemyArmyPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:TEnemyArmy = null;
         var _loc12_:TBlockPoint = null;
         var _loc13_:TSinglePointPath = null;
         var _loc14_:TRaidersDailyConfig = null;
         var _loc15_:TChangeHeroPoint = null;
         var _loc16_:TOrgPointInfo = null;
         var _loc17_:TEnemy = null;
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc12_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBattleID) as TBlockPoint;
            _loc11_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc12_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            _loc13_ = this.FSinglePointPathBins.GetDatebaseByIdentifier(this.FBattleID) as TSinglePointPath;
            _loc11_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc13_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            _loc14_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FBattleID) as TRaidersDailyConfig;
            _loc11_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc14_.EnemyArmy[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            _loc15_ = this.FChangeHeroPointBins.GetDatebaseByIdentifier(this.FBattleID) as TChangeHeroPoint;
            _loc11_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc15_.Army[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_OrgSingle || this.FBattleType == BattleType_OrgGroup)
         {
            _loc16_ = SLogicsCore.NewOrgData.CurrentPoint.PointInfo;
            _loc11_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc16_.Army.army[0]) as TEnemyArmy;
         }
         _loc9_ = _loc11_.EnemyIdVect;
         _loc10_ = _loc11_.EnemyPosVect;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc10_[_loc4_] > 0)
            {
               _loc17_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc9_[_loc4_]) as TEnemy;
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc17_.HeroIcon) as TRoleModel;
               if(_loc7_.RoleHead == param3)
               {
                  _loc8_ = this.FMC_OpponentArmy["MC_Slot_" + _loc10_[_loc4_]];
                  _loc8_["MC_Bmp_Icon"].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  _loc8_.visible = true;
               }
            }
            _loc4_++;
         }
      }
      
      protected function UpdateArmyHead() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TRoleModel = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TEnemyArmy = null;
         var _loc9_:TBlockPoint = null;
         var _loc10_:TSinglePointPath = null;
         var _loc11_:TRaidersDailyConfig = null;
         var _loc12_:TChangeHeroPoint = null;
         var _loc13_:TOrgPointInfo = null;
         var _loc14_:TEnemy = null;
         _loc2_ = int(MAX_ARMYCOUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FMC_SelfArmy[this.FArmySlotNameVect[_loc1_]];
            Bitmap(_loc5_["MC_Bmp_Icon"]).bitmapData = null;
            _loc5_.visible = false;
            _loc1_++;
         }
         this.FHeros = this.FCharacter.Heros;
         _loc2_ = this.FHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = null;
            _loc3_ = this.FHeros.GetHeroByIndex(_loc1_);
            if(_loc3_.FightPosition > 0)
            {
               _loc4_ = this.FRoleModel.GetDatebaseByIdentifier(_loc3_.Identifier) as TRoleModel;
               _loc5_ = this.FMC_SelfArmy["MC_Slot_" + _loc3_.FightPosition];
               _loc5_.Hero = _loc3_;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc4_.RoleHead,this.SelfArmyPicArrive);
               _loc5_["MC_Bmp_Icon"].x = 3;
               _loc5_["MC_Bmp_Icon"].y = 3;
            }
            _loc1_++;
         }
         _loc5_ = null;
         if(this.FBattleType == BattleType_Nodal)
         {
            _loc9_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBattleID) as TBlockPoint;
            _loc8_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc9_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_Camp)
         {
            _loc10_ = this.FSinglePointPathBins.GetDatebaseByIdentifier(this.FBattleID) as TSinglePointPath;
            _loc8_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc10_.Armys[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_KillHero)
         {
            _loc11_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FBattleID) as TRaidersDailyConfig;
            _loc8_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc11_.EnemyArmy[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_HeroChange)
         {
            _loc12_ = this.FChangeHeroPointBins.GetDatebaseByIdentifier(this.FBattleID) as TChangeHeroPoint;
            _loc8_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc12_.Army[0]) as TEnemyArmy;
         }
         else if(this.FBattleType == BattleType_OrgSingle || this.FBattleType == BattleType_OrgGroup)
         {
            _loc13_ = SLogicsCore.NewOrgData.CurrentPoint.PointInfo;
            _loc8_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc13_.Army.army[0]) as TEnemyArmy;
         }
         _loc6_ = _loc8_.EnemyIdVect;
         _loc7_ = _loc8_.EnemyPosVect;
         _loc2_ = int(MAX_ARMYCOUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc1_]];
            _loc5_.visible = false;
            Bitmap(_loc5_["MC_Bmp_Icon"]).bitmapData = null;
            _loc1_++;
         }
         _loc2_ = int(_loc6_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc7_[_loc1_] > 0)
            {
               _loc5_ = this.FMC_OpponentArmy["MC_Slot_" + _loc7_[_loc1_]];
               _loc14_ = null;
               _loc4_ = null;
               _loc14_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc6_[_loc1_]) as TEnemy;
               _loc5_.Enemy = _loc14_;
               _loc4_ = this.FRoleModel.GetDatebaseByIdentifier(_loc14_.HeroIcon) as TRoleModel;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc4_.RoleHead,this.EnemyArmyPicArrive);
               _loc5_["MC_Bmp_Icon"].x = 3;
               _loc5_["MC_Bmp_Icon"].y = 3;
            }
            _loc1_++;
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         if(param2 is TInventory)
         {
            _loc4_ = param2 as TInventory;
            _loc6_ = _loc4_.Quantity;
            param3.Value = String(_loc6_);
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function ChangeTabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = param1 as int;
         if(_loc2_ == this.FTabIndex)
         {
            return;
         }
         this.FTabIndex = _loc2_;
         switch(this.FTabIndex)
         {
            case 0:
               this.FMC_Info.visible = true;
               this.FMC_BattleReport.visible = false;
               break;
            case 1:
               this.FMC_Info.visible = false;
               this.FMC_BattleReport.visible = true;
         }
      }
      
      protected function OnChangeTeammateHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnChangeTeammate != null)
         {
            this.FOnChangeTeammate(this);
         }
      }
      
      protected function OnChangeSkillHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnChangeSkill != null)
         {
            this.FOnChangeSkill(this);
         }
      }
      
      protected function OnAutoBattleHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEnemyArmy = null;
         var _loc7_:TEnemy = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:TOrgPointInfo = null;
         var _loc10_:Dictionary = null;
         var _loc11_:Dictionary = null;
         var _loc12_:uint = 0;
         var _loc13_:TMonster = null;
         var _loc14_:TConfigValue = null;
         var _loc15_:Vector.<uint> = null;
         var _loc16_:Array = null;
         var _loc17_:uint = 0;
         var _loc18_:String = null;
         _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBattleID) as TBlockPoint;
         if(_loc8_ == null)
         {
            if(this.FBattleType != BattleType_OrgSingle)
            {
               return;
            }
            _loc9_ = SLogicsCore.NewOrgData.CurrentPoint.PointInfo;
         }
         this.FNodalAutoMonsterInfo.HootMonster.length = 0;
         this.FNodalAutoMonsterInfo.CurAutoMissionId = this.FBattleID;
         this.FNodalAutoMonsterInfo.CurAutoCityId = this.FCityID;
         _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BLOCK_AUTO_TIME) as TConfigValue;
         this.FNodalAutoMonsterInfo.CostTime = 60;
         _loc10_ = new Dictionary(true);
         _loc11_ = new Dictionary(true);
         if(_loc9_ != null)
         {
            _loc16_ = _loc9_.Army.army;
         }
         else
         {
            _loc15_ = _loc8_.Armys;
         }
         _loc17_ = _loc16_ != null ? _loc16_.length : _loc15_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc17_)
         {
            _loc5_ = _loc16_ != null ? uint(_loc16_[_loc3_]) : _loc15_[_loc3_];
            _loc6_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc5_) as TEnemyArmy;
            _loc4_ = 0;
            while(_loc4_ < _loc6_.EnemyIdVect.length)
            {
               _loc12_ = _loc6_.EnemyIdVect[_loc4_];
               _loc7_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc12_) as TEnemy;
               if(_loc10_[_loc12_] == null)
               {
                  _loc10_[_loc12_] = 1;
                  _loc11_[_loc12_] = _loc7_.Level;
               }
               else
               {
                  _loc10_[_loc12_] += 1;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         for(_loc18_ in _loc10_)
         {
            _loc13_ = this.FPoolCampaign.AcquireMonster(int(_loc18_));
            _loc13_.MonsterLevel = _loc11_[_loc18_];
            _loc13_.MonsterCount = _loc10_[_loc18_];
            this.FNodalAutoMonsterInfo.HootMonster.push(_loc13_);
         }
         this.FNodalAutoMonsterInfo.BattleType = this.FBattleType;
         if(this.FOnAutoBattle != null)
         {
            this.FOnAutoBattle(this,this.FNodalAutoMonsterInfo);
         }
      }
      
      protected function OnBtnResetHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnReset != null)
         {
            this.FOnReset();
         }
      }
      
      protected function OnResetMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnResetMoveCall != null)
         {
            this.FOnResetMoveCall(this);
         }
      }
      
      protected function OnResetOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnResetOutCall != null)
         {
            this.FOnResetOutCall(this);
         }
      }
      
      protected function OnAttackHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCharacter.CreditMilitaryOrders < uint(this.FTF_ActionPoint.text))
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_01));
            }
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_InsufficientMobility);
            }
            return;
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,this.FBattleType,this.FBattleID);
         }
         if(this.FOnBattle != null)
         {
            this.FOnBattle(this,this.FBattleID);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartBattle);
      }
      
      protected function OnWindowCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_BarrierClose);
      }
      
      protected function OnSlotOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnOverLayOver != null)
         {
            this.FOnOverLayOver(param1,param2);
         }
      }
      
      protected function OnSlotOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnOverLayOut != null)
         {
            this.FOnOverLayOut(param1,param2);
         }
      }
      
      protected function OnFormationMove(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TStarPointDesc = null;
         var _loc7_:Vector.<TKnifeAdd> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc5_ = "";
         _loc7_ = new Vector.<TKnifeAdd>();
         _loc2_ = param1.currentTarget as Sprite;
         _loc9_ = int(this.FCharacter.KnifeSoul.ChangedID);
         if(_loc9_ > 0)
         {
            if(_loc2_.name == "Slef_LogoFront")
            {
               _loc7_ = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(_loc9_).AddedFront;
            }
            else if(_loc2_.name == "Slef_LogoMiddle")
            {
               _loc7_ = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(_loc9_).AddedMiddle;
            }
            else if(_loc2_.name == "Slef_LogoAfter")
            {
               _loc7_ = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(_loc9_).AddedBack;
            }
            else if(_loc2_.name != "Opp_LogoFront")
            {
               if(_loc2_.name != "Opp_LogoMiddle")
               {
                  if(_loc2_.name == "Opp_LogoAfter")
                  {
                  }
               }
            }
         }
         if(_loc7_.length > 0)
         {
            _loc4_ = int(_loc7_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc7_[_loc3_].Value != 0)
               {
                  _loc6_ = this.FStarPointDesc.GetDatebaseByIdentifier(17500000 + _loc7_[_loc3_].Type) as TStarPointDesc;
                  _loc5_ += _loc6_.Desc + ":" + Math.round(_loc7_[_loc3_].Value * 100) + "%" + "\n";
               }
               else
               {
                  _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_03);
               }
               _loc3_++;
            }
         }
         else
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_03);
            if(_loc2_.name == "Slef_LogoFront")
            {
               _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_23);
            }
         }
         this.FHint.Caption = _loc5_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(param1,this.FHint);
         }
      }
      
      protected function OnFormationOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnArmyOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:THero = null;
         var _loc5_:TEnemy = null;
         _loc2_ = param1.currentTarget.parent.name;
         if(_loc2_ == "MC_Teammate")
         {
            _loc4_ = param1.currentTarget.Hero;
            this.FArmyTip.SetHeroData(_loc4_);
         }
         else if(_loc2_ == "MC_Opponent")
         {
            _loc5_ = param1.currentTarget.Enemy;
            this.FArmyTip.SetHeroData(null,_loc5_);
         }
         this.FArmyTip.Visible = true;
      }
      
      protected function OnArmyOut(param1:MouseEvent) : void
      {
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.Visible = false;
         }
      }
      
      public function get OnChangeTeammate() : Function
      {
         return this.FOnChangeTeammate;
      }
      
      public function set OnChangeTeammate(param1:Function) : void
      {
         this.FOnChangeTeammate = param1;
      }
      
      public function get OnChangeSkill() : Function
      {
         return this.FOnChangeSkill;
      }
      
      public function set OnChangeSkill(param1:Function) : void
      {
         this.FOnChangeSkill = param1;
      }
      
      public function get OnAutoBattle() : Function
      {
         return this.FOnAutoBattle;
      }
      
      public function set OnAutoBattle(param1:Function) : void
      {
         this.FOnAutoBattle = param1;
      }
      
      public function get OnBattle() : Function
      {
         return this.FOnBattle;
      }
      
      public function set OnBattle(param1:Function) : void
      {
         this.FOnBattle = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnOverLayOver() : Function
      {
         return this.FOnOverLayOver;
      }
      
      public function set OnOverLayOver(param1:Function) : void
      {
         this.FOnOverLayOver = param1;
      }
      
      public function get OnOverLayOut() : Function
      {
         return this.FOnOverLayOut;
      }
      
      public function set OnOverLayOut(param1:Function) : void
      {
         this.FOnOverLayOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(param1)
         {
            this.Mount();
         }
      }
      
      public function set OnReset(param1:Function) : void
      {
         this.FOnReset = param1;
      }
      
      public function set OnResetMoveCall(param1:Function) : void
      {
         this.FOnResetMoveCall = param1;
      }
      
      public function set OnResetOutCall(param1:Function) : void
      {
         this.FOnResetOutCall = param1;
      }
      
      public function UpDataBarrierChoose(param1:Object, param2:TNodal, param3:int, param4:int, param5:int) : void
      {
         this.FNodalModel = param2;
         this.FBattleType = param3;
         this.FCityID = param4;
         this.FBattleID = param5;
      }
      
      public function Mount() : void
      {
         if(Boolean(this.FMC_Info) && Boolean(this.FMC_BattleReport))
         {
            this.FMC_Info.visible = true;
            this.FMC_BattleReport.visible = false;
            this.UpdateUI();
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_BarrierOpen);
         }
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FSlot_SelfArmyVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FSlot_SelfArmyVect.length)
            {
               this.FSlot_SelfArmyVect[_loc1_].Context = null;
               _loc1_++;
            }
         }
         if(this.FSlot_OpponentArmyVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FSlot_OpponentArmyVect.length)
            {
               this.FSlot_OpponentArmyVect[_loc1_].Context = null;
               _loc1_++;
            }
         }
         if(this.FSlot_AwardVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FSlot_AwardVect.length)
            {
               this.FSlot_AwardVect[_loc1_].Context = null;
               _loc1_++;
            }
         }
      }
   }
}

