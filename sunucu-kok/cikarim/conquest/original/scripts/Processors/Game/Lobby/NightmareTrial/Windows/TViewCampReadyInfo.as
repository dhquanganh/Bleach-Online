package Processors.Game.Lobby.NightmareTrial.Windows
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityDate;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.NightmareTrial.VO.TNightmareTrialEnemyVo;
   import Logics.NightmareTrial.VO.TNightmareTrialPointVo;
   import Logics.SLogicsCore;
   import Logics.TimeCoolDown.TTimeCoolDown;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.BattleReady.IRelatedReadySlot;
   import Processors.Game.Lobby.RelatedPartner.BattleReady.TItemReadyBackupSlot;
   import Processors.Game.Lobby.RelatedPartner.BattleReady.TItemReadyCampSlot;
   import Processors.Game.Lobby.TacticalDeployment.Components.TDeploymentTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components.TArmyTip;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TViewCampReadyInfo extends TProcessorLobbyWindow
   {
      
      protected static const CAMPSLOTNUM:int = 7;
      
      protected static const PAGESIZE:int = 4;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected static const DeployPositionLookTable:Vector.<int> = Vector.<int>([1,7,6,8,12,11,13]);
      
      protected static const DeployClassLookTable:Vector.<int> = Vector.<int>([1,2,2,2,3,3,3]);
      
      protected static const LevelFormat:String = "Lv.%0";
      
      protected var FMainUI:Sprite;
      
      protected var FBtnFight:TUIButton;
      
      protected var FBtnEquip:TUIButton;
      
      protected var FBtnSkill:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FTFCondition:TextField;
      
      protected var FSlots_My:Vector.<IRelatedReadySlot>;
      
      protected var FHeroTypeImgVec:Vector.<Sprite>;
      
      protected var FHerosFighting:THeros;
      
      protected var FMyCampAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FSelectedUnloadHero:THero;
      
      protected var FUnloadingHero:Boolean;
      
      protected var FIfCanUnload:Boolean;
      
      protected var FSlots_Enemy:Vector.<IRelatedReadySlot>;
      
      protected var FUIPage:TUIPage;
      
      protected var FSlots_Backup:Vector.<IRelatedReadySlot>;
      
      protected var FMountPointsAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FCurrentPage:int;
      
      protected var FHerosBackup:THeros;
      
      protected var FUIImage:TUIImage;
      
      protected var FSwitchingDeployment:Boolean;
      
      protected var FSelectedHero:THero;
      
      protected var FSelectedSlot:TItemReadyCampSlot;
      
      protected var FEnemyVO:TNightmareTrialEnemyVo;
      
      protected var FArmyTip:TArmyTip;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      protected var FSkillInfoMc:Sprite;
      
      protected var FTFSkillInfo:TextField;
      
      protected var FScrollTextField:TScrollTextField;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FTF_RefreshTime:TextField;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FNightmarePointVo:TNightmareTrialPointVo;
      
      protected var FID:int;
      
      protected var FConfigValue:TConfigValue;
      
      private var FBtnHelp:TUIButton;
      
      private var FHint:THint;
      
      private var FData:TNightmareTrialData;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FSwitchFunction:Function;
      
      public function TViewCampReadyInfo(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_NIGHTMARETRIAL.RESOURCESID_Swf_NightmareTrial);
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
         var _loc1_:int = 0;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("NightmareBattlePanle") as Sprite;
         addChild(this.FMainUI);
         this.FSkillInfoMc = this.FMainUI["ta_monsterInfo"];
         this.FTFSkillInfo = this.FSkillInfoMc["TF_SkillInfo"];
         this.FScrollTextField = new TScrollTextField(this.FTFSkillInfo);
         this.FSkillInfoMc.addChild(this.FScrollTextField);
         this.FScorll = new TScrollBarSimple(this,this.FSkillInfoMc["mc_bar"],this.FSkillInfoMc["btn_up"],this.FSkillInfoMc["btn_down"],55,this.FScrollTextField);
         this.FSkillInfoMc.addChild(this.FScorll);
         this.FSkillInfoMc["mc_bar"].visible = false;
         this.FSkillInfoMc["btn_up"].visible = false;
         this.FSkillInfoMc["btn_down"].visible = false;
         this.FSkillInfoMc["mc_barback"].visible = false;
         this.FTF_RefreshTime = this.FMainUI["TF_RefreshTime"];
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue).GetDatebaseByIdentifier(CONST_NIGHTMARETRIAL.CONFIGVALUE_Refresh) as TConfigValue;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_NightmareTrial);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.UIDispatchBtns();
         this.UIDispatchMyCamp();
         this.UIDispatchEnemyCamp();
         this.UIDispatchBackup();
         this.FHeroInfoTip = new TDeploymentTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
         this.FBtnHelp = new TUIButton();
         this.FBtnHelp.Substrate = this.FMainUI["Btn_Help"];
         this.FBtnHelp.OnMove = this.OnShowHelpTips;
         this.FBtnHelp.OnOut = this.OnHideHelpTips;
         this.FBtnHelp.OnClick = this.OnRefreshSkill;
         this.FHint = new THint();
      }
      
      protected function UIDispatchBtns() : void
      {
         this.FBtnFight = new TUIButton();
         this.FBtnFight.Substrate = this.FMainUI["btn_Fight"];
         this.FBtnFight.OnClick = this.BtnOnClick;
         this.FBtnEquip = new TUIButton();
         this.FBtnEquip.Substrate = this.FMainUI["btn_Equip"];
         this.FBtnEquip.OnClick = this.BtnOnClick;
         this.FBtnSkill = new TUIButton();
         this.FBtnSkill.Substrate = this.FMainUI["btn_Skill"];
         this.FBtnSkill.OnClick = this.BtnOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnOnClick;
         this.FTFCondition = this.FMainUI["TF_Condition"];
         this.FTFCondition.text = "";
      }
      
      protected function UIDispatchMyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyCampSlot = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         _loc1_ = this.FMainUI["MyCampInfo"];
         this.FSlots_My = new Vector.<IRelatedReadySlot>();
         this.FHeroTypeImgVec = new Vector.<Sprite>();
         this.FMyCampAnimationSequence = new Vector.<TAnimationSequence>(10);
         this.FHerosFighting = new THeros();
         _loc3_ = 0;
         while(_loc3_ < CAMPSLOTNUM)
         {
            _loc2_ = new TItemReadyCampSlot(this,_loc1_["Slot" + _loc3_]);
            _loc2_.IsOperatable = true;
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnDown = this.MyCampSlotOnDown;
            _loc2_.SlotOnOut = this.MyCampSlotOnOut;
            _loc2_.SlotOnOver = this.MyCampSlotOnOver;
            _loc2_.Init();
            this.FSlots_My.push(_loc2_);
            _loc4_ = _loc1_["Slot" + _loc3_]["MC_HeroType"];
            this.FHeroTypeImgVec[_loc3_] = _loc4_;
            _loc3_++;
         }
      }
      
      protected function UIDispatchEnemyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyCampSlot = null;
         var _loc3_:int = 0;
         _loc1_ = this.FMainUI["EnemyCampInfo"];
         this.FSlots_Enemy = new Vector.<IRelatedReadySlot>();
         _loc3_ = 0;
         while(_loc3_ < CAMPSLOTNUM)
         {
            _loc2_ = new TItemReadyCampSlot(this,_loc1_["Slot" + _loc3_]);
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnOut = this.EnemyCampSlotOnOut;
            _loc2_.SlotOnMove = this.EnemyCampSlotOnOver;
            _loc2_.Init();
            this.FSlots_Enemy.push(_loc2_);
            _loc1_["Slot" + _loc3_]["MC_HeroType"].visible = false;
            _loc3_++;
         }
         this.FArmyTip = new TArmyTip(this);
         this.FArmyTip.Visible = false;
      }
      
      protected function UIDispatchBackup() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyBackupSlot = null;
         var _loc3_:int = 0;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_SelectHero"]["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_SelectHero"]["MC_PageRight"];
         this.FUIPage.PageSize = PAGESIZE;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FMountPointsAnimationSequence = new Vector.<TAnimationSequence>(PAGESIZE);
         this.FSlots_Backup = new Vector.<IRelatedReadySlot>();
         _loc3_ = 0;
         while(_loc3_ < PAGESIZE)
         {
            _loc2_ = new TItemReadyBackupSlot(this,this.FMainUI["MC_SelectHero"]["Slot" + _loc3_]);
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnDown = this.SlotsOnDragBegin;
            _loc2_.SlotOnOver = this.SlotsOnOver;
            _loc2_.SlotOnOut = this.SlotsOnOut;
            _loc2_.Init();
            this.FSlots_Backup.push(_loc2_);
            _loc3_++;
         }
         this.FHerosBackup = new THeros();
         this.FUIImage = new TUIImage(FParent);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.SlotsOnDragEnd);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.UnloadOnEnd);
      }
      
      protected function ResetCamps(param1:Vector.<IRelatedReadySlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IRelatedReadySlot = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc4_.Visible = false;
            _loc4_.MountPoint.bitmapData = null;
            _loc4_.Level = 0;
            _loc2_++;
         }
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FTimeCoolDown.TimingTime = TUtilityDate.GetCountDownTime(STimingCore.ServerTick,int(this.FConfigValue.Value));
         this.FHerosFighting.Clear();
         this.FHerosBackup.Clear();
         this.SelectHeros(this.FHerosFighting,this.FHerosBackup);
         this.RenderMyCampInfo();
         this.CreateHelpEnemy();
         this.RenderEnemyCampInfo();
         this.RenderBackupCampInfo();
      }
      
      protected function RenderMyCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:THero = null;
         this.ClearAnimationSequnce(this.FMyCampAnimationSequence);
         _loc5_ = DeployPositionLookTable;
         this.ResetCamps(this.FSlots_My);
         _loc2_ = this.FHerosFighting.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc1_);
            _loc3_ = _loc5_.indexOf(_loc6_.FightPosition);
            this.FSlots_My[_loc3_].Visible = true;
            TItemReadyCampSlot(this.FSlots_My[_loc3_]).SetMask(false);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.SmallID,this.MyCampPicArrive);
            this.FSlots_My[_loc3_].Level = _loc6_.RebirthLevel;
            _loc1_++;
         }
      }
      
      protected function RenderEnemyCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TRoleModel = null;
         _loc5_ = DeployPositionLookTable;
         this.ResetCamps(this.FSlots_Enemy);
         _loc2_ = int(this.FEnemyVO.TemplateIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.indexOf(this.FEnemyVO.FightPoses[_loc1_]);
            this.FSlots_Enemy[_loc3_].Visible = true;
            TItemReadyCampSlot(this.FSlots_Enemy[_loc3_]).SetMask(false);
            this.FSlots_Enemy[_loc3_].Level = 0;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FEnemyVO.TemplateIds[_loc1_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.RoleHead,this.EnemeyCampPicArrive);
            _loc1_++;
         }
      }
      
      protected function RenderBackupCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         _loc2_ = this.FCurrentPage * PAGESIZE;
         _loc3_ = _loc2_ + PAGESIZE;
         _loc3_ = _loc3_ > this.FHerosBackup.Count ? this.FHerosBackup.Count : _loc3_;
         this.ClearAnimationSequnce(this.FMountPointsAnimationSequence);
         _loc4_ = 0;
         this.ResetCamps(this.FSlots_Backup);
         this.SetupPage(this.FHerosBackup.Count,this.FCurrentPage,this.FUIPage);
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = this.FHerosBackup.GetHeroByIndex(_loc1_);
            this.FSlots_Backup[_loc4_].Visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.SmallID,this.BackupCampPicArrive);
            this.FSlots_Backup[_loc4_].Level = _loc5_.RebirthLevel;
            _loc1_++;
            _loc4_++;
         }
      }
      
      protected function MyCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         _loc9_ = DeployPositionLookTable;
         _loc5_ = this.FHerosFighting.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc4_);
            _loc7_ = _loc9_.indexOf(_loc6_.FightPosition);
            if(param3 == _loc6_.SmallID)
            {
               this.FSlots_My[_loc7_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FMyCampAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
            }
            _loc4_++;
         }
      }
      
      protected function MyEnemyCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         _loc8_ = DeployPositionLookTable;
         _loc6_ = _loc8_.indexOf(this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroPos);
         this.FSlots_My[_loc6_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function EnemeyCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         var _loc9_:TRoleModel = null;
         _loc8_ = DeployPositionLookTable;
         _loc5_ = int(this.FEnemyVO.TemplateIds.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc8_.indexOf(this.FEnemyVO.FightPoses[_loc4_]);
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FEnemyVO.TemplateIds[_loc4_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc9_.RoleHead,this.EnemeyCampPicArrive);
            if(_loc9_.RoleHead == param3)
            {
               this.FSlots_Enemy[_loc6_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function BackupCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:THero = null;
         _loc5_ = this.FCurrentPage * PAGESIZE;
         _loc6_ = _loc5_ + PAGESIZE;
         _loc6_ = _loc6_ > this.FHerosBackup.Count ? this.FHerosBackup.Count : _loc6_;
         _loc7_ = 0;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = this.FHerosBackup.GetHeroByIndex(_loc4_);
            if(_loc8_.SmallID == param3)
            {
               this.FMountPointsAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
               this.FSlots_Backup[_loc7_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
            _loc7_++;
         }
      }
      
      protected function ClearAnimationSequnce(param1:Vector.<TAnimationSequence>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_] = null;
            _loc2_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function SelectHeros(param1:THeros, param2:THeros) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THeros = null;
         var _loc6_:THero = null;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc4_ = _loc5_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetHeroByIndex(_loc3_);
            if(_loc6_.FightPosition != 0)
            {
               param1.Add(_loc6_);
            }
            else
            {
               param2.Add(_loc6_);
            }
            _loc3_++;
         }
      }
      
      private function CreateHelpEnemy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<int> = null;
         var _loc3_:TRoleModel = null;
         var _loc4_:TEnemy = null;
         var _loc5_:int = 0;
         _loc2_ = DeployPositionLookTable;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroId) as TEnemy;
         this.HideHeroSign();
      }
      
      private function HideHeroSign() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FHeroTypeImgVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FHeroTypeImgVec[_loc2_];
            _loc1_.visible = false;
            _loc2_++;
         }
      }
      
      protected function GetMyCampHeroBySlotIndex(param1:int) : THero
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         _loc4_ = DeployPositionLookTable;
         _loc5_ = DeployPositionLookTable[param1];
         _loc3_ = this.FHerosFighting.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc2_);
            if(_loc6_.FightPosition == _loc5_)
            {
               return _loc6_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function ShowHeroInfoTip(param1:THero) : void
      {
         this.FHeroInfoTip.Visible = true;
         if(param1 == null || this.FSwitchingDeployment)
         {
            return;
         }
         this.FHeroInfoTip.SetHeroData(param1);
      }
      
      protected function HideHeroInfoTip() : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      private function GetHelpEnemyName() : String
      {
         var _loc1_:TEnemy = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroId == 0)
         {
            _loc3_ = "";
         }
         else
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroId) as TEnemy;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_HELP) + _loc1_.Name;
         }
         return _loc3_;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TPacket = null;
         _loc3_ = param1 as TUIButton;
         this.Reset();
         switch(_loc3_)
         {
            case this.FBtnEquip:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
               this.FSwitchFunction();
               break;
            case this.FBtnSkill:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
               this.FSwitchFunction();
               break;
            case this.FBtnFight:
               _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_AttackReq);
               _loc4_.Data.writeUnsignedInt(this.FID);
               SNetworkCore.Transceiver.PacketTransmit(_loc4_);
               if(this.FOnSetBattleStatus != null)
               {
                  this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_NightmareTrial,0);
                  this.Visible = false;
               }
               break;
            case this.FBtnClose:
               this.Visible = false;
         }
      }
      
      protected function OnRefreshSkill(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TConfigValue = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_NIGHTMARETRIAL.CONFIGVALUE_RefreshSkillTimes) as TConfigValue;
         _loc5_ = Vector.<int>(_loc4_.Value);
         _loc6_ = this.FData.GetNightmareTrialLevelVo(this.FID).SelectInfoVo.CurrentRefreshTimes >= _loc5_.length ? int(_loc5_.length - 1) : this.FData.GetNightmareTrialLevelVo(this.FID).SelectInfoVo.CurrentRefreshTimes;
         _loc3_ = _loc5_[_loc6_];
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_RefreshInfoID),_loc3_);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
      }
      
      protected function MyCampSlotOnDown(param1:int) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.GetMyCampHeroBySlotIndex(param1);
         if(_loc2_ != null)
         {
            this.FSelectedUnloadHero = _loc2_;
            this.FUIImage.Sequence = this.FMyCampAnimationSequence[param1];
            FUICore.MouseStartDrag(this.FUIImage,true);
         }
         this.FUnloadingHero = true;
      }
      
      protected function MyCampSlotOnOver(param1:int) : void
      {
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TEnemy = null;
         _loc4_ = DeployPositionLookTable;
         _loc3_ = _loc4_.indexOf(this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroPos);
         if(param1 == _loc3_)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FNightmarePointVo.NightmareTrialPointInfo.HelpHeroId) as TEnemy;
            this.FArmyTip.SetHeroData(null,_loc5_);
            this.FArmyTip.Visible = true;
         }
         else
         {
            this.FSelectedSlot = TItemReadyCampSlot(this.FSlots_My[param1]);
            _loc2_ = this.GetMyCampHeroBySlotIndex(param1);
            if(this.FSelectedUnloadHero != null)
            {
               if(_loc2_ == this.FSelectedUnloadHero)
               {
                  this.FIfCanUnload = false;
               }
            }
            else
            {
               this.ShowHeroInfoTip(_loc2_);
            }
         }
      }
      
      protected function MyCampSlotOnOut(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         if(this.FSelectedSlot == this.FSlots_My[param1])
         {
            this.FSelectedSlot = null;
         }
         if(this.FSelectedUnloadHero != null)
         {
            _loc3_ = this.GetMyCampHeroBySlotIndex(param1);
            if(_loc3_ == this.FSelectedUnloadHero)
            {
               this.FIfCanUnload = true;
            }
         }
         this.HideHeroInfoTip();
         this.FArmyTip.Visible = false;
      }
      
      protected function EnemyCampSlotOnOver(param1:int) : void
      {
         var _loc2_:TEnemy = null;
         var _loc3_:int = 0;
         _loc3_ = this.FEnemyVO.FightPoses.indexOf(DeployPositionLookTable[param1]);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FEnemyVO.TemplateIds[_loc3_]) as TEnemy;
         this.FArmyTip.SetHeroData(null,_loc2_);
         this.FArmyTip.Visible = true;
      }
      
      protected function EnemyCampSlotOnOut(param1:int) : void
      {
         this.FArmyTip.Visible = false;
      }
      
      protected function SlotsOnOver(param1:int) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.FHerosBackup.GetHeroByIndex(param1 + this.FCurrentPage * PAGESIZE);
         this.ShowHeroInfoTip(_loc2_);
      }
      
      protected function SlotsOnOut(param1:int) : void
      {
         this.HideHeroInfoTip();
      }
      
      protected function SlotsOnDragBegin(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ += this.FCurrentPage * PAGESIZE + param1;
         if(this.FMountPointsAnimationSequence[param1] == null)
         {
            return;
         }
         this.FUIImage.Sequence = this.FMountPointsAnimationSequence[param1];
         FUICore.MouseStartDrag(this.FUIImage,true);
         this.FSwitchingDeployment = true;
         this.FSelectedHero = this.FHerosBackup.GetHeroByIndex(_loc2_);
         this.SwitchDeploySlotReady(this.FSelectedHero);
      }
      
      protected function SwitchDeploySlotReady(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(TUtilityLobby.GetStandPositionWithProfession(param1.Profession));
         _loc3_ = CAMPSLOTNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots_My[_loc2_].Visible = true;
            TItemReadyCampSlot(this.FSlots_My[_loc2_]).SetMask(DeployClassLookTable[_loc2_] != _loc4_);
            _loc2_++;
         }
      }
      
      protected function SlotsOnDragEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         if(!this.FSwitchingDeployment)
         {
            return;
         }
         this.FSwitchingDeployment = false;
         FUICore.MouseStopDrag(this.FUIImage);
         this.CreateHelpEnemy();
         if(this.FSelectedSlot != null)
         {
            _loc2_ = this.FSlots_My.indexOf(this.FSelectedSlot);
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc3_.Data.writeUnsignedInt(this.FSelectedHero.Identifier);
            _loc3_.Data.writeByte(DeployPositionLookTable[_loc2_]);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.RenderBackupCampInfo();
      }
      
      protected function UnloadOnEnd(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         if(this.FIfCanUnload)
         {
            this.FIfCanUnload = false;
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc2_.Data.writeUnsignedInt(this.FSelectedUnloadHero.Identifier);
            _loc2_.Data.writeByte(0);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
            this.FSelectedUnloadHero = null;
         }
         if(this.FUnloadingHero)
         {
            FUICore.MouseStopDrag(this.FUIImage);
         }
      }
      
      private function OnShowHelpTips(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_HELP_TIPSID),Number(this.FConfigValue.Value) / 3600);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      private function OnHideHelpTips(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function UpdateSkillColdTime() : void
      {
         this.FTF_RefreshTime.text = TUtilityTiming.fomatTime(this.FTimeCoolDown.TimingTime);
         if(this.FTimeCoolDown.TimingTime <= 0)
         {
            this.FTimeCoolDown.TimingTime = TUtilityDate.GetCountDownTime(STimingCore.ServerTick,int(this.FConfigValue.Value));
            this.RequestRefreshSkill(CONST_NIGHTMARETRIAL.Auto_Request);
         }
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         this.RequestRefreshSkill(CONST_NIGHTMARETRIAL.Refresh_Request);
      }
      
      private function RequestRefreshSkill(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_SkillReq);
         _loc2_.Data.writeUnsignedInt(this.FID);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get SwitchFunction() : Function
      {
         return this.FSwitchFunction;
      }
      
      public function set SwitchFunction(param1:Function) : void
      {
         this.FSwitchFunction = param1;
      }
      
      public function get Data() : TNightmareTrialData
      {
         return this.FData;
      }
      
      public function set Data(param1:TNightmareTrialData) : void
      {
         this.FData = param1;
      }
      
      public function Show(param1:TNightmareTrialPointVo, param2:String, param3:int) : void
      {
         var _loc4_:TRelatedCondition = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         this.FNightmarePointVo = param1;
         this.FID = param3;
         _loc5_ = this.FNightmarePointVo.NightmareTrialPointInfo.Condition;
         _loc8_ = "";
         _loc7_ = int(_loc5_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedCondition,_loc5_[_loc6_]) as TRelatedCondition;
            if(_loc6_ == _loc7_ - 1)
            {
               _loc8_ += this.GetHelpEnemyName() + _loc4_.CondtionHtml;
            }
            else
            {
               _loc8_ += _loc4_.CondtionHtml;
            }
            _loc6_++;
         }
         this.FTFCondition.htmlText = _loc8_;
         this.FEnemyVO = this.FNightmarePointVo.Enemys;
         this.FTFSkillInfo.htmlText = param2;
         this.RenderUI();
      }
      
      public function ProcessorChangePosition() : void
      {
         this.RenderUI();
      }
      
      public function Reset() : void
      {
         this.FCurrentPage = 0;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FHeroInfoTip != null && this.FHeroInfoTip.visible == true)
         {
            this.FHeroInfoTip.UpdataBitmap();
         }
         if(this.FScorll != null)
         {
            this.FScorll.LogicsProcess();
         }
         if(this.Visible)
         {
            this.UpdateSkillColdTime();
         }
      }
   }
}

