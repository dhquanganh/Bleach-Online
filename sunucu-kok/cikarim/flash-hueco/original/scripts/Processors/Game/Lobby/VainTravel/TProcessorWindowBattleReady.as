package Processors.Game.Lobby.VainTravel
{
   import Components.ComboBox.TComboBox;
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Components.Standard.TUIImage;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Logics.SLogicsCore;
   import Logics.Skills.TSkill;
   import Logics.Skills.TSkills;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelPlayerInfor;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowBattleReady extends TProcessorLobbyWindow
   {
      
      protected static const CAMPSLOTNUM:int = 7;
      
      protected static const PAGESIZE:int = 10;
      
      protected static const BLOODFULLRATE:int = 100;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const DeployPositionLookTable:Vector.<int> = Vector.<int>([1,7,6,8,12,11,13]);
      
      protected static const DeployClassLookTable:Vector.<int> = Vector.<int>([1,2,2,2,3,3,3]);
      
      protected static const LevelFormat:String = "Lv.%0";
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnFight:TUIButton;
      
      protected var FBtnEquip:TUIButton;
      
      protected var FPower_My:TextField;
      
      protected var FSlots_My:Vector.<Sprite>;
      
      protected var FMasks_My:Vector.<Sprite>;
      
      protected var FDeadFlags_My:Vector.<Sprite>;
      
      protected var FMountPoints_My:Vector.<Bitmap>;
      
      protected var FMyCampAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FLevels_My:Vector.<TextField>;
      
      protected var FBloodBars_My:Vector.<Sprite>;
      
      protected var FHerosFighting:THeros;
      
      protected var FSkillComboBox:TComboBox;
      
      protected var FKnifeComboBox:TComboBox;
      
      protected var FSkillComboBoxItems:Vector.<DisplayObject>;
      
      protected var FKnifeComboBoxItems:Vector.<DisplayObject>;
      
      protected var FSkillIDS:Vector.<int>;
      
      protected var FKnifeIDS:Vector.<int>;
      
      protected var FSelectedUnloadHero:THero;
      
      protected var FUnloadingHero:Boolean;
      
      protected var FIfCanUnload:Boolean;
      
      protected var FPower_Enemy:TextField;
      
      protected var FSkill_Enemy:TextField;
      
      protected var FKnife_Enemy:TextField;
      
      protected var FSlots_Enemy:Vector.<Sprite>;
      
      protected var FMasks_Enemy:Vector.<Sprite>;
      
      protected var FMountPoints_Enemy:Vector.<Bitmap>;
      
      protected var FLevels_Enemy:Vector.<TextField>;
      
      protected var FBloodBars_Enemy:Vector.<Sprite>;
      
      protected var FDeadFlags_Enemy:Vector.<Sprite>;
      
      protected var FUIPage:TUIPage;
      
      protected var FSlots_Backup:Vector.<Sprite>;
      
      protected var FMountPoints_Backup:Vector.<Bitmap>;
      
      protected var FMountPointsAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FLevels_Backup:Vector.<TextField>;
      
      protected var FBloodBars_Backup:Vector.<Sprite>;
      
      protected var FDeadFlags_Backup:Vector.<Sprite>;
      
      protected var FCurrentPage:int;
      
      protected var FHerosBackup:THeros;
      
      protected var FUIImage:TUIImage;
      
      protected var FSwitchingDeployment:Boolean;
      
      protected var FSelectedHero:THero;
      
      protected var FSelectedSlot:Sprite;
      
      protected var FVainTravelData:TVainTravelData;
      
      protected var FVainTravelPlayerInfor:TVainTravelPlayerInfor;
      
      public function TProcessorWindowBattleReady(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("VainTravelBattleReady") as Sprite;
         addChild(this.FMainUI);
         this.UIDispatchBtns();
         this.UIDispatchMyCamp();
         this.UIDispatchEnemyCamp();
         this.UIDispatchBackup();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function UIDispatchBtns() : void
      {
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnFight = new TUIButton();
         this.FBtnFight.Substrate = this.FMainUI["btn_Fight"];
         this.FBtnFight.OnClick = this.BtnFightOnClick;
         this.FBtnEquip = new TUIButton();
         this.FBtnEquip.Substrate = this.FMainUI["btn_Equip"];
         this.FBtnEquip.OnClick = this.BtnEquipOnClick;
      }
      
      protected function UIDispatchMyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         _loc1_ = this.FMainUI["MyCampInfo"];
         this.FPower_My = this.FMainUI["MyPower"];
         this.FSlots_My = new Vector.<Sprite>();
         this.FMasks_My = new Vector.<Sprite>();
         this.FDeadFlags_My = new Vector.<Sprite>();
         this.FMountPoints_My = new Vector.<Bitmap>();
         this.FLevels_My = new Vector.<TextField>();
         this.FBloodBars_My = new Vector.<Sprite>();
         this.FDeadFlags_My = new Vector.<Sprite>();
         this.FMyCampAnimationSequence = new Vector.<TAnimationSequence>(PAGESIZE);
         _loc4_ = CAMPSLOTNUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_["Slot" + _loc3_];
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.MyCampSlotOnDown);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.MyCampSlotOnOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.MyCampSlotOnOut);
            this.FSlots_My.push(_loc2_);
            this.FMasks_My.push(_loc2_["Mask"]);
            this.FLevels_My.push(_loc2_["TF_Level"]);
            this.FBloodBars_My.push(_loc2_["BloodBar"]);
            this.FDeadFlags_My.push(_loc2_["MC_Mark"]);
            _loc5_ = new Bitmap();
            _loc2_["MountPoint"].addChild(_loc5_);
            this.FMountPoints_My.push(_loc5_);
            _loc3_++;
         }
         this.FHerosFighting = new THeros();
         this.FSkillComboBoxItems = new Vector.<DisplayObject>();
         this.FKnifeComboBoxItems = new Vector.<DisplayObject>();
         this.FSkillIDS = new Vector.<int>();
         this.FKnifeIDS = new Vector.<int>();
         this.FSkillComboBox = new TComboBox(this,this.FMainUI["MC_ComboBoxSkill"],this.FSkillComboBoxItems,158,this.ComboBoxSkillOnSelect);
         this.FKnifeComboBox = new TComboBox(this,this.FMainUI["MC_ComboBoxKnife"],this.FKnifeComboBoxItems,158,this.ComboBoxKnifeOnSelect);
      }
      
      protected function UIDispatchEnemyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         _loc1_ = this.FMainUI["EnemyCampInfo"];
         this.FPower_Enemy = this.FMainUI["EnemyPower"];
         this.FSkill_Enemy = this.FMainUI["TF_Skill"];
         this.FKnife_Enemy = this.FMainUI["TF_Knife"];
         this.FMasks_Enemy = new Vector.<Sprite>();
         this.FMountPoints_Enemy = new Vector.<Bitmap>();
         this.FLevels_Enemy = new Vector.<TextField>();
         this.FBloodBars_Enemy = new Vector.<Sprite>();
         this.FSlots_Enemy = new Vector.<Sprite>();
         this.FDeadFlags_Enemy = new Vector.<Sprite>();
         _loc4_ = CAMPSLOTNUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_["Slot" + _loc3_];
            this.FSlots_Enemy.push(_loc2_);
            this.FMasks_Enemy.push(_loc2_["Mask"]);
            this.FLevels_Enemy.push(_loc2_["TF_Level"]);
            this.FBloodBars_Enemy.push(_loc2_["BloodBar"]);
            this.FDeadFlags_Enemy.push(_loc2_["MC_Mark"]);
            _loc5_ = new Bitmap();
            _loc2_["MountPoint"].addChild(_loc5_);
            this.FMountPoints_Enemy.push(_loc5_);
            _loc3_++;
         }
      }
      
      protected function UIDispatchBackup() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FUIPage.PageSize = PAGESIZE;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FMountPoints_Backup = new Vector.<Bitmap>();
         this.FMountPointsAnimationSequence = new Vector.<TAnimationSequence>(PAGESIZE);
         this.FLevels_Backup = new Vector.<TextField>();
         this.FBloodBars_Backup = new Vector.<Sprite>();
         this.FSlots_Backup = new Vector.<Sprite>();
         this.FDeadFlags_Backup = new Vector.<Sprite>();
         _loc4_ = PAGESIZE;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FMainUI["Slot" + _loc3_];
            this.FSlots_Backup.push(_loc2_);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.SlotsOnDragBegin);
            this.FLevels_Backup.push(_loc2_["TF_Level"]);
            this.FBloodBars_Backup.push(_loc2_["BloodBar"]);
            this.FDeadFlags_Backup.push(_loc2_["MC_Mark"]);
            _loc5_ = new Bitmap();
            _loc2_["MountPoint"].addChild(_loc5_);
            this.FMountPoints_Backup.push(_loc5_);
            _loc3_++;
         }
         this.FHerosBackup = new THeros();
         this.FUIImage = new TUIImage(this);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.SlotsOnDragEnd);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.UnloadOnEnd);
      }
      
      protected function RenderUI() : void
      {
         this.FHerosFighting.Clear();
         this.FHerosBackup.Clear();
         this.SelectHeros(this.FHerosFighting,this.FHerosBackup);
         this.RenderMyCampInfo();
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
         this.FPower_My.text = this.GetPvPPowerByHeros(this.FHerosFighting).toString();
         this.ResetCamps(this.FSlots_My,this.FMountPoints_My,this.FLevels_My,this.FDeadFlags_My);
         _loc2_ = this.FHerosFighting.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc1_);
            _loc3_ = _loc5_.indexOf(_loc6_.FightPosition);
            this.FSlots_My[_loc3_].visible = true;
            this.FMasks_My[_loc3_].visible = false;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.SmallID,this.MyCampPicArrive);
            this.FLevels_My[_loc3_].text = TUtilityString.Format(LevelFormat,_loc6_.RebirthLevel);
            _loc4_ = this.FVainTravelData.MyHeroIDS.indexOf(_loc6_.Identifier);
            this.FBloodBars_My[_loc3_].scaleX = this.FVainTravelData.MyHeroBloodRate[_loc4_] / BLOODFULLRATE;
            this.FDeadFlags_My[_loc3_].visible = this.FVainTravelData.MyHeroBloodRate[_loc4_] == 0;
            _loc1_++;
         }
         this.CreateSkillComboBoxItem();
         this.FSkillComboBox.ResetList(this.FSkillComboBoxItems);
         this.CreateKnifeComboBoxItem();
         this.FKnifeComboBox.ResetList(this.FKnifeComboBoxItems);
      }
      
      protected function RenderEnemyCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TRoleModel = null;
         var _loc7_:TSkillConfig = null;
         var _loc8_:TKnifeExpand = null;
         var _loc9_:TKnife = null;
         _loc5_ = DeployPositionLookTable;
         this.FPower_Enemy.text = this.FVainTravelPlayerInfor.PlayerPower.toString();
         this.FSkill_Enemy.text = "";
         this.FKnife_Enemy.text = "";
         if(this.FVainTravelPlayerInfor.PlayerSkillID != 0)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FVainTravelPlayerInfor.PlayerSkillID) as TSkillConfig;
            this.FSkill_Enemy.text = _loc7_.Name;
         }
         if(this.FVainTravelPlayerInfor.KnifeID != 0)
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,this.FVainTravelPlayerInfor.KnifeID) as TKnifeExpand;
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc8_.RelationID) as TKnife;
            this.FKnife_Enemy.text = _loc9_.Name;
         }
         this.ResetCamps(this.FSlots_Enemy,this.FMountPoints_Enemy,this.FLevels_Enemy,this.FDeadFlags_Enemy);
         _loc2_ = int(this.FVainTravelPlayerInfor.HeroTemplateID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.indexOf(this.FVainTravelPlayerInfor.HeroFightPos[_loc1_]);
            this.FSlots_Enemy[_loc3_].visible = true;
            this.FMasks_Enemy[_loc3_].visible = false;
            this.FLevels_Enemy[_loc3_].text = TUtilityString.Format(LevelFormat,this.FVainTravelPlayerInfor.HeroLevel[_loc1_]);
            this.FBloodBars_Enemy[_loc3_].scaleX = this.FVainTravelPlayerInfor.HeroBloodRate[_loc1_] / BLOODFULLRATE;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FVainTravelPlayerInfor.HeroTemplateID[_loc1_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.RoleHead,this.EnemeyCampPicArrive);
            this.FDeadFlags_Enemy[_loc3_].visible = this.FVainTravelPlayerInfor.HeroBloodRate[_loc1_] == 0;
            _loc1_++;
         }
      }
      
      protected function RenderBackupCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         _loc2_ = this.FCurrentPage * PAGESIZE;
         _loc3_ = _loc2_ + PAGESIZE;
         _loc3_ = _loc3_ > this.FHerosBackup.Count ? this.FHerosBackup.Count : _loc3_;
         this.ClearAnimationSequnce(this.FMountPointsAnimationSequence);
         _loc4_ = 0;
         this.ResetCamps(this.FSlots_Backup,this.FMountPoints_Backup,this.FLevels_Backup,this.FDeadFlags_Backup);
         this.SetupPage(this.FHerosBackup.Count,this.FCurrentPage,this.FUIPage);
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc6_ = this.FHerosBackup.GetHeroByIndex(_loc1_);
            this.FSlots_Backup[_loc4_].visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.SmallID,this.BackupCampPicArrive);
            this.FLevels_Backup[_loc4_].text = TUtilityString.Format(LevelFormat,_loc6_.RebirthLevel);
            _loc5_ = this.FVainTravelData.MyHeroIDS.indexOf(_loc6_.Identifier);
            this.FBloodBars_Backup[_loc4_].scaleX = this.FVainTravelData.MyHeroBloodRate[_loc5_] / BLOODFULLRATE;
            this.FDeadFlags_Backup[_loc4_].visible = this.FVainTravelData.MyHeroBloodRate[_loc5_] == 0;
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
               this.FMountPoints_My[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FMyCampAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
               break;
            }
            _loc4_++;
         }
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
         _loc5_ = int(this.FVainTravelPlayerInfor.HeroTemplateID.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc8_.indexOf(this.FVainTravelPlayerInfor.HeroFightPos[_loc4_]);
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FVainTravelPlayerInfor.HeroTemplateID[_loc4_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc9_.RoleHead,this.EnemeyCampPicArrive);
            if(_loc9_.RoleHead == param3)
            {
               this.FMountPoints_Enemy[_loc6_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
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
            if(_loc8_.Identifier == param3)
            {
               this.FMountPointsAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
               this.FMountPoints_Backup[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
            _loc7_++;
         }
      }
      
      protected function ResetCamps(param1:Vector.<Sprite>, param2:Vector.<Bitmap>, param3:Vector.<TextField>, param4:Vector.<Sprite>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc6_ = int(param1.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            param1[_loc5_].visible = false;
            param2[_loc5_].bitmapData = null;
            param3[_loc5_].text = "";
            param4[_loc5_].visible = false;
            _loc5_++;
         }
      }
      
      protected function GetPvPPowerByHeros(param1:THeros) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         _loc5_ = 0;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetHeroByIndex(_loc2_);
            _loc5_ += _loc4_.PvPAttributeFightingPower;
            _loc2_++;
         }
         return _loc5_;
      }
      
      protected function GetPvPPowerByPlayerInfors(param1:Vector.<TVainTravelPlayerInfor>, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TVainTravelPlayerInfor = null;
         _loc4_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc5_ = param1[_loc3_];
            _loc4_ += _loc5_.PlayerPower;
            _loc3_++;
         }
         return _loc4_;
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
      
      protected function FlashMyHeroState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc2_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc1_);
            _loc3_ = this.FVainTravelData.MyHeroIDS.indexOf(_loc4_.Identifier);
            if(_loc3_ == -1)
            {
               this.FVainTravelData.MyHeroIDS.push(_loc4_.Identifier);
               this.FVainTravelData.MyHeroBloodRate.push(BLOODFULLRATE);
            }
            _loc1_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function CreateSkillComboBoxItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSkills = null;
         var _loc4_:TSkill = null;
         var _loc5_:Sprite = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         _loc3_ = SLogicsCore.Character.Skills;
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_.GetSkillByIndex(_loc1_);
            if(_loc4_.IsUnlock)
            {
               _loc6_ = this.FSkillIDS.indexOf(_loc4_.Identifier);
               if(_loc6_ == -1)
               {
                  _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("VainTravel_Item") as MovieClip;
                  this.FSkillComboBoxItems.push(_loc5_);
                  this.FSkillIDS.push(_loc4_.Identifier);
                  _loc5_["tf_into"].text = _loc4_.Name;
                  _loc5_["Tag"] = _loc4_.Identifier;
               }
            }
            _loc1_++;
         }
         _loc2_ = int(this.FSkillComboBoxItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FSkillComboBoxItems[_loc1_]["Tag"] == SLogicsCore.Character.MainHero.Skill.Identifier)
            {
               _loc7_ = this.FSkillComboBoxItems[_loc1_];
               this.FSkillComboBoxItems.splice(_loc1_,1);
               this.FSkillComboBoxItems.splice(0,0,_loc7_);
            }
            _loc1_++;
         }
      }
      
      protected function CreateKnifeComboBoxItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:TKnifeOfKillSoulData = null;
         var _loc7_:TKnifeOfkillSoulDatas = null;
         _loc7_ = SLogicsCore.Character.KnifeOfKillSoul;
         _loc2_ = _loc7_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc7_.GetByIndex(_loc1_);
            _loc4_ = this.FKnifeIDS.indexOf(_loc6_.ID);
            if(_loc6_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK && _loc4_ == -1)
            {
               _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("VainTravel_Item") as Sprite;
               this.FKnifeComboBoxItems.push(_loc3_);
               this.FKnifeIDS.push(_loc6_.ID);
               _loc3_["tf_into"].text = _loc6_.Name;
               _loc3_["Tag"] = _loc6_.ID;
            }
            _loc1_++;
         }
         _loc2_ = int(this.FKnifeComboBoxItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc7_.GetByIndentifier(this.FKnifeComboBoxItems[_loc1_]["Tag"]);
            if(_loc6_.ID == SLogicsCore.Character.KnifeSoul.ChangedID)
            {
               _loc5_ = this.FKnifeComboBoxItems[_loc1_];
               this.FKnifeComboBoxItems.splice(_loc1_,1);
               this.FKnifeComboBoxItems.splice(0,0,_loc5_);
            }
            _loc1_++;
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
            this.FSlots_My[_loc2_].visible = true;
            this.FMasks_My[_loc2_].visible = DeployClassLookTable[_loc2_] != _loc4_;
            this.FDeadFlags_My[_loc2_].visible = false;
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
      
      protected function MyCampSlotOnDown(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         _loc4_ = DeployPositionLookTable;
         _loc2_ = this.FSlots_My.indexOf(param1.currentTarget as Sprite);
         _loc5_ = this.GetMyCampHeroBySlotIndex(_loc2_);
         if(_loc5_ != null)
         {
            this.FSelectedUnloadHero = _loc5_;
            this.FUIImage.Sequence = this.FMyCampAnimationSequence[_loc2_];
            FUICore.MouseStartDrag(this.FUIImage,true);
         }
         this.FUnloadingHero = true;
      }
      
      protected function MyCampSlotOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         this.FSelectedSlot = param1.currentTarget as Sprite;
         if(this.FSelectedUnloadHero != null)
         {
            _loc2_ = this.FSlots_My.indexOf(param1.currentTarget as Sprite);
            _loc3_ = this.GetMyCampHeroBySlotIndex(_loc2_);
            if(_loc3_ == this.FSelectedUnloadHero)
            {
               this.FIfCanUnload = false;
            }
         }
      }
      
      protected function MyCampSlotOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         if(this.FSelectedSlot == param1.currentTarget as Sprite)
         {
            this.FSelectedSlot = null;
         }
         if(this.FSelectedUnloadHero != null)
         {
            _loc2_ = this.FSlots_My.indexOf(param1.currentTarget as Sprite);
            _loc3_ = this.GetMyCampHeroBySlotIndex(_loc2_);
            if(_loc3_ == this.FSelectedUnloadHero)
            {
               this.FIfCanUnload = true;
            }
         }
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
      
      protected function SlotsOnDragBegin(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FSlots_Backup.indexOf(param1.currentTarget as Sprite);
         _loc3_ += this.FCurrentPage * PAGESIZE + _loc2_;
         if(this.FMountPointsAnimationSequence[_loc2_] == null)
         {
            return;
         }
         this.FUIImage.Sequence = this.FMountPointsAnimationSequence[_loc2_];
         FUICore.MouseStartDrag(this.FUIImage,true);
         this.FSwitchingDeployment = true;
         this.FSelectedHero = this.FHerosBackup.GetHeroByIndex(_loc3_);
         this.SwitchDeploySlotReady(this.FSelectedHero);
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
         this.RenderMyCampInfo();
         if(this.FSelectedSlot != null)
         {
            _loc2_ = this.FSlots_My.indexOf(this.FSelectedSlot);
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc3_.Data.writeUnsignedInt(this.FSelectedHero.Identifier);
            _loc3_.Data.writeByte(DeployPositionLookTable[_loc2_]);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      protected function ComboBoxSkillOnSelect(param1:Object, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         if(this.FSkillComboBoxItems[param2]["Tag"] == SLogicsCore.Character.MainHero.Skill.Identifier)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GeneralStar_ChangeSkillReq);
         _loc3_.Data.writeUnsignedInt(this.FSkillComboBoxItems[param2]["Tag"]);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ComboBoxKnifeOnSelect(param1:Object, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ChangeKnifeRequest);
         if(this.FKnifeComboBoxItems[param2]["Tag"] == SLogicsCore.Character.KnifeSoul.ChangedID)
         {
            return;
         }
         _loc3_.Data.writeByte(CONST_KNIFEOFKILLSOUL.KnifeChangeShpae);
         _loc3_.Data.writeUnsignedInt(this.FKnifeComboBoxItems[param2]["Tag"]);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function BtnFightOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VainTravel_BattleReq);
         _loc3_.Data.writeByte(this.FVainTravelPlayerInfor.Index);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnEquipOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Reset();
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.RenderBackupCampInfo();
      }
      
      public function Show(param1:TVainTravelData, param2:TVainTravelPlayerInfor) : void
      {
         this.FVainTravelData = param1;
         this.FVainTravelPlayerInfor = param2;
         this.FlashMyHeroState();
         this.RenderUI();
         Visible = true;
      }
      
      public function Reset() : void
      {
         this.FCurrentPage = 0;
      }
      
      public function ProcessorChangePosition() : void
      {
         this.RenderUI();
      }
      
      public function BattleResultNotify() : void
      {
         this.RenderUI();
      }
   }
}

